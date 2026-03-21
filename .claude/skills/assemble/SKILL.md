# assemble

Tangle main.nw and assemble using dasm. Reports any errors.

## Usage

```
/assemble
```

## Instructions

Run these commands in sequence:

1. Tangle: `python weave.py main.nw output`
2. Copy support files: `cp ea_splash_screen.asm dos.asm mobdata.asm fontdata.asm stdfontdata.asm output/`
3. Assemble main: `cd output && dasm main.asm -f3 -omain.bin -lmain.lst -smain.sym`
3. Assemble boot1: `dasm boot1.asm -f3 -oboot1.bin -lboot1.lst -sboot1.sym`
4. Assemble ealdr: `dasm ealdr.asm -f3 -oealdr.bin -lealdr.lst -sealdr.sym`

Report the result:
- If assembly succeeds with no errors, say so.
- If there are unresolved symbols, list them all.
- If there is an "Origin Reverse-indexed" error, run `python .claude/skills/assemble/reorder_chunks.py TARGET` to auto-fix, then retry.
- If there are other errors (excluding "unreferenced chunk" warnings from weave.py), list them.

## Verify against reference binaries

After assembling, verify output matches the reference binaries:

```
python .claude/skills/assemble/verify.py              # main full report
python .claude/skills/assemble/verify.py main 0503 0569   # check region
python .claude/skills/assemble/verify.py boot1        # boot1 report
python .claude/skills/assemble/verify.py ealdr        # ealdr report
```

Targets and their reference binaries:

| Target | Output | Reference | Base address |
|--------|--------|-----------|-------------|
| main | output/main.bin | main.bin | $0500 |
| boot1 | output/boot1.bin | boot1.bin | $0800 |
| ealdr | output/ealdr.bin | ealdr.bin | $A000 |

## Reorder chunks

If chunk references get out of ORG order (causing "Origin Reverse-indexed" errors):

```
python .claude/skills/assemble/reorder_chunks.py          # main only
python .claude/skills/assemble/reorder_chunks.py boot1    # boot1 only
python .claude/skills/assemble/reorder_chunks.py all      # all three
python .claude/skills/assemble/reorder_chunks.py all -v   # verbose
```
