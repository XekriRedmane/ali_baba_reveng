import sys
DSK_FILE = "Ali Baba and the Forty Thieves (4am and san inc crack).dsk"
EALDR_FILE = "ealdr.bin"
OUTPUT_FILE = "main.bin"

BASE_ADDR = 0x0500
END_ADDR = 0x9600
SIZE = END_ADDR - BASE_ADDR  # $9100 = 37120

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
    """Read 16 sectors of a track into mem using the custom interleave.

    Each physical sector on disk maps to a page offset via
    LOADER_INTERLEAVE, so the data lands at (base_page + offset) * 256.
    """
    for phys in range(16):
        page_offset = LOADER_INTERLEAVE[phys]
        dos_logical = DOS_SKEW[phys]
        file_pos = (track * 16 + dos_logical) * 256
        dest = (base_page + page_offset) * 256 - BASE_ADDR
        if 0 <= dest and dest + 256 <= SIZE:
            mem[dest:dest + 256] = dsk[file_pos:file_pos + 256]
def funny_inc_gen(bot=2, top=3):
    """Yield the ealdr_funny_inc key sequence: 1,2,3, 1,2,3,4, ..."""
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
        if (src >> 8) == 0x68:  # src_hi ^ $68 == 0 -> done
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

    # DXR decrypt $4000-$67FE
    dxr_decrypt(mem)

    # Copy EALDR $A300-$A5FF -> $0500-$07FF
    ealdr_src = 0xA300 - 0xA000  # offset in ealdr.bin
    mem_dest = 0x0500 - BASE_ADDR
    mem[mem_dest:mem_dest + 0x300] = ealdr[ealdr_src:ealdr_src + 0x300]

    with open(OUTPUT_FILE, "wb") as f:
        f.write(mem)
    print(f"Wrote {len(mem)} bytes to {OUTPUT_FILE}")
    print(f"Load in Ghidra at $0500, entry point $0800")

if __name__ == "__main__":
    main()