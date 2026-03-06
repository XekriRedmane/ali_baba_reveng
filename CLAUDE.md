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

## Boot Process

The Disk II P5A boot ROM reads physical sectors 0-4 from track 0 into pages $0800-$0CFF:

| Physical Sector | File Offset | Memory Address | Contents |
|---|---|---|---|
| 0 | 0x000 | $0800 | Boot code (JMP $0804, sets reset vector, JSR $0C00) |
| 1 | 0x700 | $0900 | Disk read routines (accesses $C0EC disk controller) |
| 2 | 0xE00 | $0A00 | Sector search routine + nibble translation table |
| 3 | 0x600 | $0B00 | Translation table data |
| 4 | 0xD00 | $0C00 | Sector loader + custom interleave table + 4am crack text |

## Custom Game Loader

The game's sector loader at $0C00 (file offset 0xD00) uses its own interleave table at $0C48 for loading game data from tracks beyond track 0:

```
Physical sector → memory page offset:
0F 08 01 09 02 0A 03 0B 04 0C 05 0D 06 0E 07 00
```

Expanded:
```
Physical:    0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15
Page offset: F   8   1   9   2   A   3   B   4   C   5   D   6   E   7   0
```

The loader adds this offset to a base page ($3E) to determine the destination address for each sector. It reads an entire track at a time, placing each sector at `base_page + offset` in memory.
