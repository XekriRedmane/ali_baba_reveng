# Ali Baba and the Forty Thieves - Reverse Engineering Project

## Disk Image Format

- **File**: `Ali Baba and the Forty Thieves (4am and san inc crack).dsk`
- **Format**: Standard Apple II 16-sector .dsk image, DOS 3.3 sector order
- **Size**: 143,360 bytes = 35 tracks x 16 sectors x 256 bytes/sector

## Sector Interleaving

The .dsk file stores sectors in DOS 3.3 logical order. Physical sectors on the disk map to file positions via the standard DOS 3.3 2:1 software interleave.

**Physical sector → DOS logical sector (file position within track):**

```
Physical:  0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15
DOS/File:  0   7  14   6  13   5  12   4  11   3  10   2   9   1   8  15
```

**To find physical sector P of track T in the file:**
```
skew_table = [0, 7, 14, 6, 13, 5, 12, 4, 11, 3, 10, 2, 9, 1, 8, 15]
file_offset = (T * 16 + skew_table[P]) * 256
```

## Boot Chain

```
DISKCARD -> BOOT1 -> EALDR -> PROGRAM
```

### BOOT1 (track 0, 5 sectors → $0800-$0CFF, entry $0801)

The Disk II boot ROM reads physical sectors 0-4 from track 0 into pages $0800-$0CFF:

| Physical Sector | File Offset | Memory Address | Contents |
|---|---|---|---|
| 0 | 0x000 | $0800 | Boot code (JMP $0804, sets reset vector, loads EALDR) |
| 1 | 0x700 | $0900 | Disk read routines (accesses $C0EC disk controller) |
| 2 | 0xE00 | $0A00 | Sector search routine + nibble translation table |
| 3 | 0x600 | $0B00 | Translation table data |
| 4 | 0xD00 | $0C00 | Sector loader + custom interleave table + 4am crack text |

BOOT1 loads EALDR from tracks 1-2 into $A000-$BFFF, then enters at $A806 via RTS trick (pushes $A805 onto stack).

### EALDR (tracks 1-2 → $A000-$BFFF, entry $A806)

The EA Loader is a mini virtual machine with 18 opcodes. It:
1. Fills hi-res display ($2000-$7FFF) with $FF and draws a splash screen from $B000+ data
2. Optionally loads tracks $03,$04,$21,$22 (Group 1)
3. Loads tracks $07-$0C into $4000-$95FF (Group 2: game data)
4. Loads tracks $0D-$10 into $0800-$3FFF (Group 3: main program code, with overlap)
5. Checksums $A000-$A2E0
6. Decrypts $4000-$67FF using DXR routine
7. Copies $A300-$A5FF → $0500-$07FF
8. Enters main program at $0800 via `CALL0 $0800`

### Custom Game Loader Interleave

The sector loader at $0C00 uses its own interleave table at $0C48:

```
Physical:    0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15
Page offset: F   8   1   9   2   A   3   B   4   C   5   D   6   E   7   0
```

The loader adds this offset to a base page ($3E) to determine the destination address for each sector.

## Translation Tables

- **boot1_xlat.txt**: Maps BOOT1 memory order → DOS file position (physical→DOS deskew)
- **boot2_xlat.txt**: Maps custom-interleave memory order → DOS file position (reverse order: 0F 0E ... 00)

## Naming Conventions

- **BOOT1**: 5-sector bootloader from track 0
- **EALDR**: EA Loader VM from tracks 1-2
- **Main program**: Game code loaded by EALDR from tracks $0D-$10 into $0800-$3FFF
- Assembly labels in EALDR code use `ealdr_` prefix (e.g., `ealdr_entry`, `ealdr_vm_interp`)
