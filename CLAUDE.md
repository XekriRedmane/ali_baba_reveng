# Ali Baba and the Forty Thieves - Reverse Engineering Project

## Workflow Rules

### Assembly and Labels

- Do NOT decompile 6502 assembly to C via Ghidra. This is hand-written assembly; work with disassembly directly.
- All routine labels must be UPPER_CASE (e.g., BOOT1_ENTRY not boot1_entry). Data labels and local (.dot) labels are not affected.
- After every ORG, there must be a label. That label should be referenced from a code chunk. If unreferenced, investigate: it may be dead code/data. Mark as such for future investigation.
- After documenting a routine, ALWAYS grep main.nw for all raw hex references (JSR $XXXX, JMP $XXXX, etc.) and replace them with the new label name.
- After each disassembly batch, ALWAYS do these cleanups:
  1. Replace stale FUN_* EQU references with real label names: `grep -o 'FUN_[0-9A-Fa-f]\{4\}' main.nw | sort -u`
  2. Rename `<<fun XXXX>>` chunk names to `<<descriptive name>>` (lowercase label with underscores→spaces). Fix any missing chunk refs in `<<main.asm>>`.
  3. Replace raw hex JSR/JMP $XXXX with label names.
- Never use EQU stubs for routines — create an ORG stub chunk (with `; STUB — not yet disassembled` comment) instead. ORG stubs are searchable (`grep STUB`) and serve as placeholders. Add the chunk ref in `<<main.asm>>` in address order.
- Zero-page aliasing: when a ZP address is used for different purposes, define multiple EQU names for the same address and use the contextually appropriate name at each reference.
- Align all `;` comments to the same column within each chunk/subroutine.

### Label Hygiene

1. Before creating a label, search for existing EQUs at that address. If one exists, keep the label (preferred) and remove the EQU.
2. Before assuming a calling convention, read the called routine's code.
3. Prefer labels at data definitions over EQU stubs.
4. Before doing replace_all on a label, verify one instance first. Assemble and binary-compare before applying globally.
5. Handle prose and code references separately. Prose in `[[ ]]` noweb refs uses the base label name (e.g., `[[S_COPYRIGHT]]`), never label+offset expressions.
6. When a label+offset is needed in code, verify the offset by checking what the called routine expects.

### Chunk Placement

- If a chunk defines data with labels, every label must be defined in the chunk immediately preceding the first code chunk that references it. If not, split the data chunk. Use `python .claude/skills/chunk-placement/check_placement.py` to verify.
- EQU definitions go just before the chunk that first uses them, with prose explaining purpose.
- Chunk definitions go in the prose before their first use. Chunk references in `<<main.asm>>` follow ORG address order — use `python .claude/skills/assemble/reorder_chunks.py` if needed.

### Ghidra

- ALWAYS sync new labels to Ghidra immediately after adding them to main.nw.
- Use `batch_rename_function_components` for function names (NOT `rename_function_by_address` — bugged).
- Use `batch_create_labels` for EQU/data labels and local (.label) labels.
- Always call `save_program` after Ghidra modifications.
- main.bin loaded at $0500, 41984 bytes. ealdr.bin loaded at $A000, 8192 bytes.

### Noweb / LaTeX

- Do not escape underscores or dollar signs inside `[[ ]]` noweb code refs. Write `[[GAME_INIT]]` not `[[GAME\_INIT]]`.
- Use exact label casing in `[[ ]]` prose refs (e.g., `[[GAME_INIT]]` not `[[game_init]]`).
- Never put LaTeX math inside `[[ ]]` noweb code refs. Write `[[A]] $\leftarrow$ [[addr]]` not `[[A $\leftarrow$ addr]]`.
- Never put `<<chunk>>` inside assembly comments — the tangler expands them.
- Convert sequential prose ("first X, then Y, then Z") into itemized lists.
- weave.py errors block PDF build — fix before running pdflatex.
- Always run pdflatex twice to resolve references.
- Do NOT use UTF-8 left-arrow (←) in main.nw — CP-1252 incompatible. Use right-arrow (→) instead.

### Python Scripts

- Stored Python scripts must have full type hints with generic parameters (e.g., `list[str]`, `tuple[int, int, str]`). Use `from __future__ import annotations`.

### Tools

- Always use `grep` via Bash, never the Grep tool (it returns no matches on this project's files).
- Always produce .lst and .sym files when assembling with dasm: `dasm foo.asm -f3 -ofoo.bin -lfoo.lst -sfoo.sym`
- Memory map tables must be byte-contiguous: end+1 of each row = start of next row.

## Build Pipeline

```
python weave.py main.nw output
cd output && dasm main.asm -f3 -omain.bin -lmain.lst -smain.sym
```

Skill: `/assemble` runs the full tangle+build pipeline.

- APSTR pseudo-op is post-processed by weave.py (converts to HEX with length prefix + high-bit ASCII)
- weave.py outputs: `main.asm`, `ealdr.asm`, `fontdata.asm`, `stdfontdata.asm`, `extract_main.py`

### Verification

After writing any new assembly chunk:
1. Assemble and compare byte-for-byte against main.bin (offset = addr - $0500)
2. Run `python .claude/skills/assemble/verify.py` for coverage report
3. Run `python audit_orgs.py` for ORG address verification
4. Run `python .claude/skills/chunk-placement/check_placement.py` for label placement
5. Run `python .claude/skills/chunk-placement/audit_org_labels.py` for ORG label audit

## Disk Image Format

- **File**: `Ali Baba and the Forty Thieves (4am and san inc crack).dsk`
- **Format**: Standard Apple II 16-sector .dsk image, DOS 3.3 sector order
- **Size**: 143,360 bytes = 35 tracks x 16 sectors x 256 bytes/sector

### Sector Interleaving

```
Physical:  0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15
DOS/File:  0   7  14   6  13   5  12   4  11   3  10   2   9   1   8  15
```

```python
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

### EALDR (tracks 1-2 → $A000-$BFFF, entry $A806)

The EA Loader is a mini virtual machine with 18 opcodes. It:
1. Fills hi-res display ($2000-$7FFF) with $FF and draws a splash screen from $B000+ data
2. Optionally loads tracks $03,$04,$21,$22 (Group 1)
3. Loads tracks $07-$0C into $4000-$95FF (Group 2: game data)
4. Loads tracks $0D-$10 into $0800-$3FFF (Group 3: main program + HRCG staging)
5. Checksums $A000-$A2E0
6. Decrypts $4000-$67FF using DXR routine
7. Copies $A300-$A5FF → $0500-$07FF
8. Enters main program at $0800 via `CALL0 $0800`

### game_init Relocation ($6DA5)

- $2000-$32FF → $9600-$A8FF (HRCG code + standard font, 19 pages)
- $3300-$3FFF → $B300-$BFFF (disk I/O routines, 13 pages)

### Custom Game Loader Interleave

```
Physical:    0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15
Page offset: F   8   1   9   2   A   3   B   4   C   5   D   6   E   7   0
```

## Memory Map (after game_init)

| Range | Source | Contents |
|---|---|---|
| $0500-$07FF | EALDR $A300-$A5FF | Resident routines |
| $0800-$3FFF | Tracks $0D-$10 | Main program code |
| $4000-$67FF | Tracks $07-$09 (DXR decrypted) | Game data (encrypted) |
| $6800-$95FF | Tracks $09-$0C | Game data (HRCG code at $92A8+) |
| $9600-$A8FF | Relocated from $2000-$32FF | HRCG code ($9600-$97A4), standard font ($97A5-$9AA4) |
| $B300-$BFFF | Relocated from $3300-$3FFF | Disk I/O routines |

## Font Data

- **Custom font** ($83A5-$92A4): 3840 bytes, 120 chars × 32 bytes (14×16 pixel, 4 blocks of 7×8)
- **Standard font** ($97A5-$9AA4): 768 bytes, 96 chars × 8 bytes (7×8 pixel, standard Apple II charset)
- Custom font: 2x2 block characters, charnum*4+$20 = base glyph

## Literate Program (main.nw)

- Tangled by `weave.py` — unreferenced chunks with valid filenames (must contain a dot) are output as files
- Chunk names may contain letters, digits, spaces, hyphens, dots, and underscores
- `extract_main.py` reproduces the EALDR loading + game_init relocation to produce `main.bin`
- `main.bin`: 47872 bytes ($0500-$BFFF), load in Ghidra at $0500, entry $0800
- `recreate_main.py` reverses/re-applies game_init relocation on assembled output, compares with `main.bin`

## Key Technical Facts

- PRNG formula: val = 69*val + $53 (mod 256), LCG at $78A8
- RANDOM_IN_RANGE ($1317): rejection sampling, 24 callers — most-used utility
- Entity pointers: bit 7 of high byte set = mob, clear = character
- ROM_COUT1 ($FDED) — binary exclusively uses COUT1, never COUT ($FDF0)

### Zero Page Pointers

- $FA/$FB = CHAR_PTR: main loop iteration pointer (9-byte records at $40xx)
- $F4/$F5 = MOB_PTR: mob data pointer (group iteration, combat)
- $F8/$F9 = ENTITY_PTR: entity record pointer (current character/mob being processed)
- $BE/$BF = CHAR_REC / ENTITY_REC / EVENT_PTR / DATA_PTR / AI_BEST_POS; AI_BEST_STR ($BF)
- $BC/$BD = PRINT_STRING_ADDR / HANDLER_PTR / NUM_VALUE / COPY_SRC / TARGET_REC
- $BA/$BB = MOB_DATA_PTR / COPY_DEST / DECIMAL_OUT_PTR; also scratch
- $06/$07 = TEXT_STREAM_PTR

### Record Systems

- 9-byte char index records at $4000 (GET_CHAR_RECORD)
- 16-byte mob data records at ($4000/$4001) base (GET_MOB_DATA)
- Mob data byte 8: bit 7 = status flag, bits 6-4 = pending XP (0-7), bits 3-0 = group count (0-4)
- Mob data byte 5: bits 4-0 = strength; char record byte 5 bits 4-1 = defense
- Mob data byte 6: bits 5-0 = mob type (>= 3 = active); byte $0F bit 2 = combat engaged flag
- Mob data byte 11: bits 7-5 = class/faction flags, bits 4-0 = level (0-31)
- Groups linked via mob data byte 2 (next pointer), byte 3 = map position

### Faction System

- Appearance index ÷ 21 = font group; groups 0-2,7 = friendly, groups 3-6 = hostile

### XP System

- Award at $7248 (5 action types, table at $7FBE), flush at $6EE9 (adds pending XP to level)

## Subsystem Architecture

### HRCG Library ($92A8-$97A4, complete)

- Applesoft Toolkit "HI-RES CHAR GEN VERSION 1.0" — third-party library
- CSW/KSW replacement handlers (HRCG_COUT at $93BE, HRCG_GETKEY at $931A)
- 27 ctrl-char handlers via RTS-trick dispatch table at $93EE
- Each ctrl char has normal/shifted variants (bit 6 of $9306 = carry on handler entry)
- 4 video modes: replace ($20), OR ($40/$80), AND ($80), XOR ($C0) — selected via $9307/$9309
- Self-modifying param block at $9305-$9319 (21 bytes)
- INIT_HRCG ($791A) patches $94B6 (RTS) and $92D5 (NOPs) before calling HRCG_INIT

### Disk VM ($B300-$B5FF, complete)

- 13 opcodes, handler table at $B4BF, dispatch via self-modifying JMP at $B5DF
- ZP $50-$5F swapped with saved state at $B5E5; VM IP in $52/$53, ACC in $56, operand in $54/$55
- Bytecode encryption: addr low XOR $9C, addr high XOR $AD, immediate XOR $7A
- Entry: DISK_READ_FIELD ($B300) → DISK_VM_LOOP → DISPATCH
- Bytecode program ($B373-$B3FE): copy-protection verifier
- RWTS: RWTS_ENTRY ($B7B5), RWTS_CORE ($BD00, standard DOS 3.3)

### EALDR VM (complete)

- 18 opcodes, RTS-trick entry, bytecode encryption, DXR decryption
- Similar to Disk VM but different: 18 vs 13 opcodes, different ZP range, different dispatch

### Tune Player

- Bytecode sound effect system with opcodes for high/low tones, delays, loops
- PLAY_HIGH_TONE frequency: f = 510204 / (5X+12) Hz
- PLAY_LOW_TONE frequency: f = 510204 / (10X+31) Hz
- 12 tunes (0-11), pointer table TUNE_TABLE at $80AE

## Assembly Pitfalls (dasm + noweb)

1. Noweb tangler expands `<<chunk>>` refs inside comments — never put them in comments
2. dasm requires ORG directives in strictly ascending order
3. dasm `.local` labels require `SUBROUTINE` directives for scoping
4. dasm accumulator addressing: use bare `ASL`/`LSR`/`ROL`/`ROR`, not `ASL A`
5. Always verify assembled output byte-for-byte against the reference binary
6. Noweb `@ %def` must not have duplicate identifiers across chunks
7. Macros cannot take local (.dot) labels as arguments — dasm creates new scope per macro
8. Use `dasm -f3` for raw binary (not `-f1` which adds 2-byte header)
9. Before creating a new chunk, search for existing chunks at the same ORG
10. Every ORG should use a hex literal (`ORG $XXXX`), never a symbol name
11. Code/data overlap: truncate HEX data at the overlap boundary, let code ORG define the bytes
12. Ghidra branch structure is unreliable for hand-written 6502 — manually trace branch offsets
13. Ghidra "fall-through" claims are often wrong — verify actual bytes
14. Use heredocs for inline Python scripts, never `python3 -c "..."` with `$` in the code
15. Write scripts >100 lines to files, not heredocs
16. When renaming identifiers, watch for prefix collisions (use word-boundary regex)
17. Before debugging assembly errors, check if they existed before your changes (`git stash` and test)

### Verification Checklist

After writing any new assembly chunk:
1. Assemble in isolation with all external refs as EQUs
2. Compare byte-for-byte against main.bin (offset = addr - $0500)
3. Check chunk size matches (end_addr - start_addr)
4. Run `python audit_orgs.py` for full regression
5. Run `python weave.py main.nw` to ensure tangling succeeds

## EQU Labels (partial list)

### $5A Page

- PRNG: PRNG_OUTPUT ($5A18), PRNG_STATE ($5A19), PRNG_TEMP ($5A1A)
- Tune player: TUNE_LOOP_CTR ($5A8D), TUNE_LOOP_ADDR ($5A8E), TUNE_GOSUB_ADDR ($5A90), TUNE_PRNG_MASK ($5A92), TUNE_ACTION_VEC ($5A93)
- Saved ZP: SAVED_BC ($5A9A), SAVED_F8 ($5A9C), SAVED_BE ($5A9E), SAVED_F4 ($5AA0)
- Game state: LOCATION_FLAG ($5A55), LOCATION_FLAG2 ($5A56), SCENE_NUMBER ($5A99), ATTRACT_FLAG ($5AA7)
- Font: FONT_COL ($5A0C), FONT_ROW ($5A0D), FONT_CHARNUM ($5A0E), FONT_CHARSET ($5A0F)
- Text: TEXT_RIGHT_MARGIN ($5A96), TEXT_LEFT_MARGIN ($5A97), TEXT_STREAM_IDX ($5A98)
- Blink: BLINK_COL ($5AA2), BLINK_ROW ($5AA3), BLINK_CHAR ($5AA4)
- Combat: ENCOUNTER_RESULT ($5A1F), COLOCATE_POS/LINK/WRAPPED ($5A20-$5A22), HOSTILE_APP/A/Y ($5A23-$5A25), ADJACENT_THREAT ($5A26), ADJACENT_POS ($5A27)
- Bounds: BOUNDS_MIN_COL ($5A51), BOUNDS_MIN_ROW ($5A52), BOUNDS_MAX_COL ($5A53), BOUNDS_MAX_ROW ($5A54)
- Scene: SCENE_TEXT_DATA ($5C00), SCENE_TRANSITION ($5CFF)
- AI/events: NEAREST_DIST ($5A28), HEAL_NOTIFIED ($5A29), TRAP_TYPE ($5A2A), AI_PREV_DIR ($5A2B), EVENT_DEST_POS ($5A2D)
- Shop: SHOP_ITEM_MASK ($5A2E), SHOP_PRICE ($5A2F), SHOP_PRICE_HI ($5A30)
- Misc: RNG_LIMIT ($5A11), RNG_MASK ($5A12), GROUP_COUNT_DELTA ($5A2C), WAIT_LOOP_COUNT ($5A8C), DEFAULT_CHAR ($7AC2), BLINK_ALT_CHAR ($7AC3), TURN_SCRIPT_GUARD ($5A31)

## Undocumented Gaps

### Large gaps (500+ bytes)

- $2000-$4008 (8201): Hi-res page staging area (relocated during game_init)
- $A8F2-$B2FF (2574): Between HRCG end and disk I/O
- $9AA5-$A262 (1982): Game message strings
- $7AAC-$7D82 (727): Menu option strings
- $A44E-$A6B1 (612): EALDR resident routines/data

### Medium code gaps (100-500 bytes)

- $0AAE-$0B61 (180), $14D8-$15AA (211), $62EC-$63C7 (220), $63C9-$643F (119)
- $69C8-$6B93 (460), $6B95-$6C17 (131), $6EE9-$704C (356), $720B-$72A6 (156)
- $A264-$A2FF (156), $A6B9-$A723 (107), $A7C1-$A8CC (268)

### Dead code/data (confirmed)

- $776E SET_CURSOR_COMPRESSED — zero xrefs in Ghidra
- $1F19 ORPHANED_ENCOUNTER_HANDLER — unreachable, references stale addresses
- $06F2 RESIDUAL_DONT_BREAK — truncated "DON'T BREAK TH" string
- $07E2 RESIDUAL_PAGE_TAIL — unused residual data at end of handler page

## Skills

- `/assemble` — tangle + build pipeline
- `/disassemble $XXXX` — reverse engineer a routine
- `/trace-address` — trace address usage
- `/re-next` — find next gap to reverse engineer
- `/macro-apply` — apply assembly macros
- `/chunk-placement` — check/fix data chunk label placement
- `/gen-pdf` — generate PDF documentation
