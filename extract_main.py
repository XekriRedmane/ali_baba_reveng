"""Extract the main game binary as it appears in memory after game_init.

Reproduces what the EALDR VM does:
  1. Load tracks $07-$0C -> $4000-$95FF  (Group 2: game data)
  2. Load tracks $0D-$10 -> $0800-$3FFF  (Group 3: main program)
  3. DXR-decrypt $4000-$67FF
  4. Copy EALDR $A300-$A5FF -> $0500-$07FF

Then reproduces the game_init relocation at $6DA5:
  5. Copy $2000-$32FF -> $9600-$A8FF  (HRCG code + standard font)
  6. Copy $3300-$3FFF -> $B300-$BFFF  (disk I/O routines)
  7. Clear $2000-$3FFF               (hi-res page now available)
"""

DSK_FILE = "Ali Baba and the Forty Thieves (4am and san inc crack).dsk"
EALDR_FILE = "ealdr.bin"
OUTPUT_FILE = "main.bin"

BASE_ADDR = 0x0500
END_ADDR = 0xC000
SIZE = END_ADDR - BASE_ADDR  # $BB00 = 47872

# DOS 3.3 physical-to-logical skew (physical sector -> file sector)
DOS_SKEW = [0, 7, 14, 6, 13, 5, 12, 4, 11, 3, 10, 2, 9, 1, 8, 15]

# Custom game loader interleave: physical sector -> page offset from base
LOADER_INTERLEAVE = [0xF, 0x8, 0x1, 0x9, 0x2, 0xA, 0x3, 0xB,
                     0x4, 0xC, 0x5, 0xD, 0x6, 0xE, 0x7, 0x0]

# Track loading tables (from EALDR $A9F3 and $AA04)
GROUP2 = [(0x07, 0x40), (0x08, 0x50), (0x09, 0x60),
          (0x0A, 0x70), (0x0B, 0x80), (0x0C, 0x86)]
GROUP3 = [(0x0D, 0x08), (0x0E, 0x10), (0x0F, 0x20), (0x10, 0x30)]


def read_track(dsk, track, base_page, mem):
    """Read 16 sectors of a track into mem using the custom interleave."""
    for phys in range(16):
        page_offset = LOADER_INTERLEAVE[phys]
        dos_logical = DOS_SKEW[phys]
        file_pos = (track * 16 + dos_logical) * 256
        dest = (base_page + page_offset) * 256 - BASE_ADDR
        if 0 <= dest and dest + 256 <= SIZE:
            print(f"mem ${dest + BASE_ADDR:04X} = dsk ${file_pos:04X} (track {track},"
                  f" dos sector {dos_logical}, physical sector {phys})")
            mem[dest:dest + 256] = dsk[file_pos:file_pos + 256]


def funny_inc_gen(bot=2, top=3):
    """Yield the EALDR funny_inc key sequence: 1, 2, 3, 1, 2, 3, 4, ..."""
    while True:
        bot += 1
        if bot == top:
            bot = 1
            top += 1
            yield 1
        else:
            yield bot


def dxr_decrypt(mem):
    """XOR every other byte from $4000 to $67FE with the funny_inc key."""
    keys = funny_inc_gen()
    src = 0x4000
    while True:
        key = next(keys)
        offset = src - BASE_ADDR
        if 0 <= offset < SIZE:
            mem[offset] ^= key
        src += 2
        if (src >> 8) == 0x68:
            break


def main():
    with open(DSK_FILE, "rb") as f:
        dsk = f.read()
    with open(EALDR_FILE, "rb") as f:
        ealdr = f.read()

    mem = bytearray(SIZE)

    # Group 2: tracks $07-$0C -> $4000-$95FF
    for track, base_page in GROUP2:
        read_track(dsk, track, base_page, mem)

    # Group 3: tracks $0D-$10 -> $0800-$3FFF
    for track, base_page in GROUP3:
        read_track(dsk, track, base_page, mem)

    # DXR decrypt $4000-$67FF
    dxr_decrypt(mem)

    # Copy EALDR $A300-$A5FF -> $0500-$07FF
    ealdr_src = 0xA300 - 0xA000
    mem_dest = 0x0500 - BASE_ADDR
    mem[mem_dest:mem_dest + 0x300] = ealdr[ealdr_src:ealdr_src + 0x300]

    # game_init relocation at $6DA5:
    # Copy $2000-$32FF -> $9600-$A8FF (19 pages, HRCG code + standard font)
    src = 0x2000 - BASE_ADDR
    dst = 0x9600 - BASE_ADDR
    mem[dst:dst + 0x1300] = mem[src:src + 0x1300]
    # Copy $3300-$3FFF -> $B300-$BFFF (13 pages, disk I/O routines)
    src2 = 0x3300 - BASE_ADDR
    dst2 = 0xB300 - BASE_ADDR
    mem[dst2:dst2 + 0x0D00] = mem[src2:src2 + 0x0D00]
    # Clear the source area ($2000-$3FFF)
    clear = 0x2000 - BASE_ADDR
    mem[clear:clear + 0x2000] = bytearray(0x2000)

    with open(OUTPUT_FILE, "wb") as f:
        f.write(mem)
    print(f"Wrote {len(mem)} bytes to {OUTPUT_FILE}")
    print(f"Load in Ghidra at ${BASE_ADDR:04X}, entry point $0800")

    # Verification
    print(f"\nVerification:")
    print(f"  Size: {len(mem)} (expected {SIZE})")
    print(f"  $0500: {mem[0]:02X} {mem[1]:02X} {mem[2]:02X} (expected 4C 69 05)")
    print(f"  $0800: {mem[0x300]:02X} {mem[0x301]:02X} {mem[0x302]:02X}")
    print(f"  $9600: {mem[0x9600-BASE_ADDR]:02X} (HRCG code)")
    print(f"  $97A5: {mem[0x97A5-BASE_ADDR]:02X} {mem[0x97A6-BASE_ADDR]:02X} (std font, space=00 00)")
    print(f"  $B300: {mem[0xB300-BASE_ADDR]:02X} {mem[0xB301-BASE_ADDR]:02X} {mem[0xB302-BASE_ADDR]:02X} (disk I/O routines)")


if __name__ == "__main__":
    main()
