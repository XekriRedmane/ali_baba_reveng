# macro-apply

Search main.nw for instruction sequences that can be replaced by PSHW or PULW macros, and apply the substitutions.

## Usage

```
/macro-apply
```

No arguments. The skill scans all assembly chunks in main.nw automatically.

## Instructions

You are looking for 4-instruction sequences in `main.nw` that match the PSHW or PULW macro patterns, and replacing them with the equivalent macro call.

### Macro patterns

**PSHW addr** — push a 16-bit value onto the stack (low byte first, high byte on top):

```
LDA  addr
PHA
LDA  addr+1
PHA
```

**PULW addr** — pull a 16-bit value from the stack (high byte first, low byte last):

```
PLA
STA  addr+1
PLA
STA  addr
```

For hex literal addresses, `addr+1` means the numerically adjacent address (e.g., `$06`/`$07`, `$BE`/`$BF`). For symbolic addresses, `addr+1` is literally `SYMBOL+1`.

### Eligibility rules

An address is eligible for macro substitution ONLY if:

- It is a zero-page address (`$XX`), absolute address (`$XXXX`), or a global symbol (e.g., `PRINT_STRING_ADDR`)
- It does NOT start with `.` (local labels cannot be macro arguments — dasm creates a new scope per macro invocation)
- It does NOT use indexed addressing (no `,X` or `,Y` suffix)
- It does NOT use indirect addressing (no parentheses)
- It does NOT use immediate addressing (no `#` prefix)

### Procedure

1. **Search** — Write and run a Python script that scans `main.nw` for PSHW/PULW candidates. The script should:
   - Parse each line for instruction mnemonics and operands (strip comments at `;`)
   - Skip lines inside `MACRO`/`ENDM` blocks (don't match the macro definitions themselves)
   - Look for 4 consecutive instruction lines matching each pattern
   - Check that the address is eligible per the rules above
   - Check that addr and addr+1 are correctly related (symbolic `+1` suffix or hex value +1)
   - Print each candidate with its line number and the address

2. **Review** — Show the user the list of candidates found. If none, report that and stop.

3. **Apply** — For each candidate, edit `main.nw`:
   - Replace the 4 instruction lines with a single macro call
   - Preserve the indentation of the first instruction line
   - Preserve any comment from the first line of the sequence (the one with `LDA` for PSHW, or `PLA` for PULW — pick the most informative comment from any of the 4 lines)

4. **Verify** — Run `python weave.py` to retangle. Then assemble the affected file(s) with dasm and compare byte-for-byte against the reference binary (`main.bin` at offset addr-$0500, or `ealdr.bin` at offset addr-$A000) to confirm no regression.

5. **Report** — Summarize what was changed: how many substitutions, which addresses, which chunks.

### Notes

- The 4 lines must be consecutive instruction lines (no labels, blank lines, or directives between them).
- Comments on the replaced lines are lost except for the one preserved on the macro call. Pick the most descriptive comment from the group.
- PSHW/PULW macros are defined in the `<<Macros>>` chunk. They are available in both `main.asm` and `ealdr.asm`.
- See `assembly-pitfalls.md` in the memory directory for why local labels can't be macro arguments.
