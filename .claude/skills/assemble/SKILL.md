# assemble

Tangle main.nw and assemble main.asm using dasm. Reports any errors.

## Usage

```
/assemble
```

## Instructions

Run these two commands in sequence:

1. Tangle: `python weave.py main.nw output`
2. Assemble: `cd C:/Users/rober/Projects/ali_baba_re/output && dasm main.asm -f3 -omain_test.bin -lmain.lst -smain.sym`

Report the result:
- If assembly succeeds with no errors or warnings (exit code 0), say so and report the binary size.
- If there are unresolved symbols, list them all.
- If there is an "Origin Reverse-indexed" error, run `python .claude/skills/assemble/reorder_chunks.py` to auto-fix the chunk order in `<<main.asm>>`, then retry the build.
- If there are other errors or warnings (excluding "unreferenced chunk" warnings from weave.py), list them.

## Reorder chunks

If chunk references in `<<main.asm>>` get out of ORG order (causing "Origin Reverse-indexed" errors), run:

```
python .claude/skills/assemble/reorder_chunks.py
```

This reads main.nw, resolves each chunk's first ORG address, and reorders the references in ascending address order. Use `-v` for verbose output showing all chunks with their addresses.
