#!/usr/bin/env python3
"""Build Ali Baba and the Forty Thieves from source.

Tangles main.nw, assembles all binaries, and reconstructs the .dsk image.

Usage:
    python build.py [--verify]

Steps:
    1. Tangle main.nw -> output/*.asm
    2. Copy support files to output/
    3. Assemble main.asm -> main.bin
    4. Assemble boot1.asm -> boot1.bin
    5. Generate resident_copy.asm from main.bin ($0500-$07FF -> $A300)
    6. Assemble ealdr.asm -> ealdr.bin
    7. Reconstruct .dsk image from binaries + scene data

With --verify, compares all outputs against reference binaries and
the original .dsk image.
"""
from __future__ import annotations

import os
import re
import shutil
import subprocess
import sys
from collections.abc import Generator
from pathlib import Path

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------

PROJECT_ROOT = Path(__file__).parent
OUTPUT_DIR = PROJECT_ROOT / 'output'
SCENES_DIR = PROJECT_ROOT / 'scenes'

SUPPORT_FILES = ['ea_splash_screen.asm', 'dos.asm', 'fontdata.asm', 'stdfontdata.asm']

DASM = 'dasm'

TARGETS = [
    # (source, output, listing, symbols)
    ('main.asm',  'main.bin',  'main.lst',  'main.sym'),
    ('boot1.asm', 'boot1.bin', 'boot1.lst', 'boot1.sym'),
    # ealdr assembled after resident_copy.asm is generated
]

EALDR_TARGET = ('ealdr.asm', 'ealdr.bin', 'ealdr.lst', 'ealdr.sym')

REFERENCE_BINS = {
    'main':  (PROJECT_ROOT / 'main.bin',  0x0500),
    'boot1': (PROJECT_ROOT / 'boot1.bin', 0x0800),
    'ealdr': (PROJECT_ROOT / 'ealdr.bin', 0xA000),
}

ORIG_DSK = PROJECT_ROOT / 'Ali Baba and the Forty Thieves (4am and san inc crack).dsk'

# ---------------------------------------------------------------------------
# Disk image constants
# ---------------------------------------------------------------------------

DISK_SIZE = 143360
SECTOR_SIZE = 256
SECTORS_PER_TRACK = 16
TRACK_SIZE = SECTOR_SIZE * SECTORS_PER_TRACK
NUM_TRACKS = 35

DOS_SKEW = [0, 7, 14, 6, 13, 5, 12, 4, 11, 3, 10, 2, 9, 1, 8, 15]

LOADER_INTERLEAVE = [0xF, 0x8, 0x1, 0x9, 0x2, 0xA, 0x3, 0xB,
                     0x4, 0xC, 0x5, 0xD, 0x6, 0xE, 0x7, 0x0]

MAIN_BASE = 0x0500

GROUP2 = [(0x07, 0x40), (0x08, 0x50), (0x09, 0x60),
          (0x0A, 0x70), (0x0B, 0x80), (0x0C, 0x86)]
GROUP3 = [(0x0D, 0x08), (0x0E, 0x10), (0x0F, 0x20), (0x10, 0x30)]

# Track 0 residual format data (physical sectors 5-7, not loaded during boot)
TRACK0_EXTRA: dict[int, bytes] = {
    5: bytes([0xFF] * 253 + [0x0D, 0x0D, 0xFF]),
    6: bytes.fromhex(
        'd300000000000000000000000000000000000000000000000000000000000000'
        '0000000000000000ff0000000000000000000000000000000000000000000000'
        'bf00000000000000000000000000000000000000000000000000000000000000'
        '0000000000000000ff0000000000000000000000000000000000000000000000'
        '0000000000000000000000000000000000000000000000000000000000000000'
        '0000000000000000000000000000000000000000000000000000000000000000'
        '0000000000000000000000000000000000000000000000000000000000000000'
        '0000000000000000000000000000000000000000000000000000000000000e0e'),
    7: bytes([0x0F] + [0xFF] * 254 + [0x0F]),
}


# ---------------------------------------------------------------------------
# Step 1-2: Tangle and copy support files
# ---------------------------------------------------------------------------

def tangle() -> bool:
    """Run weave.py to tangle main.nw into output/."""
    print('Tangling main.nw...')
    OUTPUT_DIR.mkdir(exist_ok=True)
    result = subprocess.run(
        [sys.executable, 'weave.py', 'main.nw', 'output'],
        cwd=PROJECT_ROOT, capture_output=True, text=True)
    if result.returncode != 0:
        print(f'  ERROR: weave.py failed:\n{result.stderr}')
        return False
    return True


def copy_support_files() -> None:
    """Copy support .asm files into output/."""
    for f in SUPPORT_FILES:
        src = PROJECT_ROOT / f
        if src.exists():
            shutil.copy2(src, OUTPUT_DIR / f)


# ---------------------------------------------------------------------------
# Step 3-4: Assemble
# ---------------------------------------------------------------------------

def assemble(source: str, output: str, listing: str, symbols: str) -> bool:
    """Assemble a .asm file with dasm. Returns True on success."""
    print(f'  Assembling {source}...')
    result = subprocess.run(
        [DASM, source, '-f3', f'-o{output}', f'-l{listing}', f'-s{symbols}'],
        cwd=OUTPUT_DIR, capture_output=True, text=True)
    if result.returncode != 0:
        print(f'    ERROR:\n{result.stdout}{result.stderr}')
        return False
    size = (OUTPUT_DIR / output).stat().st_size
    print(f'    OK ({size} bytes)')
    return True


# ---------------------------------------------------------------------------
# Step 5: Generate resident_copy.asm
# ---------------------------------------------------------------------------

def generate_resident_copy() -> None:
    """Extract $0500-$07FF from main.bin as ealdr $A300 include file."""
    main_bin = (OUTPUT_DIR / 'main.bin').read_bytes()
    data = main_bin[0:0x300]  # $0500-$07FF (768 bytes)
    with open(OUTPUT_DIR / 'resident_copy.asm', 'w') as f:
        f.write('    ORG     $A300\n')
        f.write('EALDR_RESIDENT_COPY:\n')
        for i in range(0, len(data), 16):
            chunk = data[i:i + 16]
            f.write('    HEX     ' + ' '.join(f'{b:02X}' for b in chunk) + '\n')


# ---------------------------------------------------------------------------
# Step 7: Build .dsk image
# ---------------------------------------------------------------------------

def funny_inc_gen(bot: int = 2, top: int = 3) -> Generator[int, None, None]:
    """Yield the EALDR funny_inc key sequence."""
    while True:
        bot += 1
        if bot == top:
            bot = 1
            top += 1
            yield 1
        else:
            yield bot


def dxr_encrypt(data: bytearray, start: int, end: int) -> None:
    """Re-encrypt a region using the DXR XOR sequence (same as decrypt)."""
    keys = funny_inc_gen()
    src = start
    while True:
        key = next(keys)
        if 0 <= src < len(data):
            data[src] ^= key
        src += 2
        if (src >> 8) == (end >> 8):
            break


def write_sector(dsk: bytearray, track: int, logical_sector: int,
                 data: bytes) -> None:
    """Write 256 bytes to a logical sector position in the .dsk image."""
    offset = track * TRACK_SIZE + logical_sector * SECTOR_SIZE
    padded = (data + bytes(SECTOR_SIZE))[:SECTOR_SIZE]
    dsk[offset:offset + SECTOR_SIZE] = padded


def write_track_loader(dsk: bytearray, track: int, base_page: int,
                       mem: bytes, mem_base: int) -> None:
    """Write a track using the custom game loader interleave."""
    for phys in range(16):
        page_offset = LOADER_INTERLEAVE[phys]
        logical = DOS_SKEW[phys]
        mem_addr = (base_page + page_offset) * 256
        mem_offset = mem_addr - mem_base
        if 0 <= mem_offset and mem_offset + 256 <= len(mem):
            data = mem[mem_offset:mem_offset + 256]
        else:
            data = bytes(256)
        offset = track * TRACK_SIZE + logical * SECTOR_SIZE
        dsk[offset:offset + SECTOR_SIZE] = data


def load_track_asm(filename: Path) -> list[bytes]:
    """Load a track .asm file, returning 16 sectors of 256 bytes each."""
    sectors: list[bytearray] = [bytearray(256) for _ in range(16)]
    current_sector = 0
    with open(filename) as f:
        for line in f:
            line = line.strip()
            if line.startswith('; Track') and 'sector' in line:
                m = re.search(r'sector (\d+)', line)
                if m:
                    current_sector = int(m.group(1))
            elif line.startswith('HEX '):
                hex_str = line[4:].strip()
                data = bytes.fromhex(hex_str.replace(' ', ''))
                sectors[current_sector] = bytearray(data[:256])
                if len(data) < 256:
                    sectors[current_sector].extend(bytes(256 - len(data)))
    return [bytes(s) for s in sectors]


def build_disk() -> bytearray:
    """Build the complete .dsk image from assembled binaries."""
    dsk = bytearray(DISK_SIZE)

    # --- Track 0: BOOT1 ---
    boot1 = (OUTPUT_DIR / 'boot1.bin').read_bytes()
    for page in range(len(boot1) // SECTOR_SIZE):
        phys = page
        logical = DOS_SKEW[phys]
        data = boot1[page * 256:(page + 1) * 256]
        write_sector(dsk, 0, logical, data)

    for phys, data in TRACK0_EXTRA.items():
        logical = DOS_SKEW[phys]
        write_sector(dsk, 0, logical, data)

    # --- Tracks 1-2: EALDR ---
    ealdr = (OUTPUT_DIR / 'ealdr.bin').read_bytes()
    write_track_loader(dsk, 1, 0xA0, ealdr, 0xA000)
    write_track_loader(dsk, 2, 0xB0, ealdr, 0xA000)

    # --- Track 5: fill pattern data ---
    track05 = SCENES_DIR / 'track_05.asm'
    if track05.exists():
        sectors = load_track_asm(track05)
        for logical in range(16):
            write_sector(dsk, 5, logical, sectors[logical])

    # --- Tracks 7-16: main program (reverse relocation + DXR encrypt) ---
    main_bin = (OUTPUT_DIR / 'main.bin').read_bytes()
    mem = bytearray(main_bin)

    # Reverse game_init relocation
    mem[0x2000 - MAIN_BASE:0x3300 - MAIN_BASE] = mem[0x9600 - MAIN_BASE:0xA900 - MAIN_BASE]
    mem[0x3300 - MAIN_BASE:0x4000 - MAIN_BASE] = mem[0xB300 - MAIN_BASE:0xC000 - MAIN_BASE]

    # DXR re-encrypt $4000-$67FF
    dxr_encrypt(mem, 0x4000 - MAIN_BASE, 0x6800 - MAIN_BASE)

    for track, base_page in GROUP2:
        write_track_loader(dsk, track, base_page, bytes(mem), MAIN_BASE)
    for track, base_page in GROUP3:
        write_track_loader(dsk, track, base_page, bytes(mem), MAIN_BASE)

    # --- Tracks $11-$1F: scene data ---
    for track in range(0x11, 0x20):
        filename = SCENES_DIR / f'track_{track:02x}.asm'
        if filename.exists():
            sectors = load_track_asm(filename)
            for logical in range(16):
                write_sector(dsk, track, logical, sectors[logical])

    return dsk


# ---------------------------------------------------------------------------
# Verification
# ---------------------------------------------------------------------------

def verify_binary(name: str, test_path: Path, ref_path: Path) -> int:
    """Compare assembled binary against reference. Returns diff count."""
    if not ref_path.exists():
        print(f'  {name}: reference not found ({ref_path})')
        return -1
    if not test_path.exists():
        print(f'  {name}: assembled output not found ({test_path})')
        return -1

    ref = ref_path.read_bytes()
    test = test_path.read_bytes()
    diffs = 0
    size = min(len(ref), len(test))
    for i in range(size):
        if ref[i] != test[i]:
            diffs += 1
    if len(ref) != len(test):
        diffs += abs(len(ref) - len(test))

    if diffs == 0:
        print(f'  {name}: {len(ref)} bytes — perfect match')
    else:
        print(f'  {name}: {diffs} byte diffs (test={len(test)}, ref={len(ref)})')

    return diffs


def verify_disk(dsk: bytearray) -> int:
    """Compare reconstructed .dsk against original."""
    if not ORIG_DSK.exists():
        print(f'  Original disk image not found: {ORIG_DSK.name}')
        return -1

    orig = ORIG_DSK.read_bytes()
    diffs = 0
    for track in range(NUM_TRACKS):
        track_diffs = 0
        for sector in range(SECTORS_PER_TRACK):
            offset = track * TRACK_SIZE + sector * SECTOR_SIZE
            for i in range(SECTOR_SIZE):
                if dsk[offset + i] != orig[offset + i]:
                    track_diffs += 1
        if track_diffs > 0:
            print(f'    Track ${track:02X}: {track_diffs} byte diffs')
            diffs += track_diffs

    if diffs == 0:
        print('  .dsk: perfect match')
    else:
        print(f'  .dsk: {diffs} total byte diffs')

    return diffs


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main() -> None:
    do_verify = '--verify' in sys.argv

    # Step 1: Tangle
    if not tangle():
        sys.exit(1)

    # Step 2: Copy support files
    copy_support_files()

    # Step 3-4: Assemble main and boot1
    print('Assembling...')
    ok = True
    for source, output, listing, symbols in TARGETS:
        if not assemble(source, output, listing, symbols):
            ok = False

    if not ok:
        print('Assembly failed.')
        sys.exit(1)

    # Step 5: Generate resident_copy.asm from main.bin
    print('  Generating resident_copy.asm...')
    generate_resident_copy()

    # Step 6: Assemble ealdr
    source, output, listing, symbols = EALDR_TARGET
    if not assemble(source, output, listing, symbols):
        print('EALDR assembly failed.')
        sys.exit(1)

    # Step 7: Build .dsk
    print('Building .dsk image...')
    dsk = build_disk()
    dsk_path = OUTPUT_DIR / 'ali_baba.dsk'
    dsk_path.write_bytes(dsk)
    print(f'  Wrote {len(dsk)} bytes to {dsk_path}')

    # Verify
    if do_verify:
        print('\nVerification:')
        total_diffs = 0
        for name, (ref_path, _base) in REFERENCE_BINS.items():
            test_path = OUTPUT_DIR / f'{name}.bin'
            d = verify_binary(name, test_path, ref_path)
            if d > 0:
                total_diffs += d
        d = verify_disk(dsk)
        if d > 0:
            total_diffs += d

        if total_diffs == 0:
            print('\nAll outputs match references.')
        else:
            print(f'\n{total_diffs} total differences found.')
            sys.exit(1)

    print('\nBuild complete.')


if __name__ == '__main__':
    main()
