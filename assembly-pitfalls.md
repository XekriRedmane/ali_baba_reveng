# Assembly Pitfalls (dasm + noweb tangler)

Lessons from disassembling ealdr.asm and main.bin code (2026-03-07+).

## 1. Noweb tangler treats chunk refs inside comments as real refs

The tangler's `expand_chunk` uses `re.search(SPACECHUNKREF, line)` which finds
`<<chunk name>>` anywhere on a line, including inside assembly comments.

**Bad:** `; (see <<EALDR DXR step>>)` — silently expands the chunk inline,
drops the `; (see ` prefix, emits a stray `)` after the expanded code.

**Good:** Put the chunk reference on its own line: `<<EALDR DXR step>>`

If a chunk is referenced inline AND listed in the top-level file chunk, it gets
emitted twice. This caused duplicate `ORG $AB55` directives.

**Rule:** Never put `<<chunk>>` inside comments. If you want a cross-reference
in prose, use the doc chunk: `(see \S\ref{...})` or `[[ealdr\_dxr\_step]]`.

## 2. dasm requires ORG directives in strictly ascending order

dasm tracks a linear output position. If `ORG $AA60` appears after code that
has already assembled past address $AA60, dasm emits "Origin Reverse-indexed".

This happens when the original binary interleaves code and data at
non-contiguous addresses. Example: VM interpreter code at $AA35-$AA5F, dispatch
table data at $AA60-$AA71, then more interpreter code at $AA72-$AA81.

**Fix:** Split the code chunk so that each piece has its own ORG and the chunks
are ordered by ascending address in the top-level file chunk.

**Rule:** When disassembling interleaved code/data regions, create separate
chunks for each contiguous address range and list them in address order.

**Corollary for verification:** When assembling a test file with multiple ORGs,
ensure they're in ascending order. If a routine at $1317 references STEP_PRNG
at $78A8, define STEP_PRNG as an EQU rather than including the code, so the
test file only has one ORG.

## 3. dasm local labels require SUBROUTINE directives

dasm `.local` labels are NOT scoped by global labels alone. Without
`SUBROUTINE`, all `.nc` labels across the entire file are in the same scope,
causing "Label mismatch" and "Branch out of range" errors.

**Fix:** Add `SUBROUTINE` after every `ORG` directive.

**Rule:** Every chunk that contains `.local` labels needs a `SUBROUTINE`
directive at the top. When multiple routines share a chunk (like the opcode
handlers), add `SUBROUTINE` before each routine that has local labels.

## 4. dasm accumulator addressing: use bare mnemonic, not `ASL A`

dasm does NOT accept `ASL A` or `LSR A` or `ROL A` or `ROR A`. It treats `A`
as a symbol. Use bare `ASL`, `LSR`, `ROL`, `ROR` for accumulator mode.

The noweb tangler in main.nw uses `ASL     A` in the source — the tangler
strips trailing operands for these mnemonics. But in standalone test files
assembled directly by dasm, use the bare form.

## 5. Verify assembled output against the original binary

Even if dasm assembles without errors, the output may not match the original.
Always compare code regions byte-for-byte with the reference binary.

### Verification template

```python
python3 -c "
orig = open('main.bin', 'rb').read()
test = open('output/test.bin', 'rb').read()
base = 0xXXXX  # ORG address
off = base - 0x0500
for i in range(len(test)):
    if test[i] != orig[off+i]:
        print(f'\${base+i:04X}: orig=\${orig[off+i]:02X} test=\${test[i]:02X}')
        break
else:
    print(f'Perfect match! ({len(test)} bytes)')
"
```

### Common bugs found by verification

#### 5a. Reused code blocks creating duplicates

If the original code branches backward to reuse an earlier block (e.g.,
BPL $0C8D to reuse an existing `LDA x; STA y; RTS` sequence), your
disassembly must branch to the same address — NOT create a duplicate
block at the end of the routine.

**Symptom:** Output is longer than original. Branch offsets all wrong.

**Example:** GET_ENTITY_FONTCHAR has `.empty` code at $0C8D (LDA
BLINK_ALT_CHAR; STA FONT_CHARNUM; RTS). Two later branches (`BPL .empty`
at $0CAF and `BEQ .empty` at $0CDE) must target this SAME block. Putting
`.empty:` at the end creates a duplicate 6-byte block that shifts everything.

**Rule:** Before adding a new label block, check if the target address
corresponds to an existing block earlier in the routine. If so, place the
label there and branch backward.

#### 5b. Self-modifying code: indexed addressing into own code

When code patches its own instruction operands, the `STA target+N,X`
address must account for X. If `.load4` is the LDY instruction and you
need X=6 to target `.load4+1` (the operand low byte), the STA base must
be `.load4+1-6` = `.load4-5`.

**Symptom:** Single-byte mismatch in the operand of an indexed STA.

**Example:** FIND_ENTITY_AT_POS uses `STA .load4-5,X` with X=6,7 to
patch bytes at `.load4+1` and `.load4+2`. Writing `STA .load4+1,X` would
target `.load4+7` and `.load4+8` instead.

**Rule:** For `STA label+N,X`, the encoded address is `label+N`, and
the effective address is `label+N+X`. Work backward from the desired
effective address: base = effective_addr - X.

#### 5c. Fall-through between adjacent routines

Original has CALL0 falling through into jmp_ind:
```
ealdr_op_call0:          ; $AABF
    JSR      read_arg16
ealdr_jmp_ind:           ; $AAC2
    JMP      ($0042)
```

**Rule:** Watch for fall-through between routines. If two routines are adjacent
and the first ends by falling into the second, they must stay adjacent in the
source and the first must NOT duplicate the second's code.

#### 5d. Self-modifying code: wrong target byte

Entry code modified `ealdr_copy_dst` (the destination page byte in
`STA $202C,X`) but was written as `ealdr_copy_src+1` (the source page byte in
`LDA $B000`). These are at different addresses ($A83F vs $A83C).

**Rule:** When disassembling self-modifying code, use `= *+N` labels for EACH
modified operand byte, not arithmetic on another label. Verify by checking which
file offset the original INC/STA instruction targets.

#### 5e. Multiple entry points into the same routine

The VM goto path has two entry points:
- `ealdr_vm_loop` ($AA72): calls read_arg16 first
- `ealdr_vm_goto` ($AA75): skips the JSR

A 3-byte JMP/BEQ offset difference is the telltale sign of a missed entry point.

**Rule:** When branch/jump targets don't match by exactly 3 bytes (the size of
JSR/JMP), check whether there's a second entry point that skips an instruction.

#### 5f. NMOS 6502 has no STZ instruction

The Apple II uses an NMOS 6502 (not 65C02). There is NO `STZ` instruction.
If you see a zero being stored, it's `LDA #$00; STA addr` or the accumulator
already holds zero. Check the actual opcode byte in the binary.

**Example:** PLOT_CHAR had `STZ FONT_CHARSET` but the binary has
`STA FONT_CHARSET` (A already held the value 1, not 0).

#### 5g. Wrong ORG address

Four chunks had incorrect ORG addresses in main.nw, discovered by the
audit_orgs.py script. Common cause: copying an address from Ghidra's xref
list or comment instead of the actual function entry.

**Rule:** Always verify the ORG address against the binary. Run
`python audit_orgs.py` after any changes to catch mismatches.

## 6. Noweb %def must not have duplicate identifiers

If two chunks define the same identifier in `@ %def`, weave.py raises
`ValueError: Identifier XXX defined in multiple chunks`.

**Example:** Both `<<control routines>>` and `<<print ctrl n>>` defined
SET_NORMAL_VIDEO. Fixed by dropping the alias entirely since nothing
referenced it.

**Rule:** Before adding `%def`, grep for existing definitions of the same name.

## 7. Grep tool may not work on CRLF files

The Grep tool sometimes returns no results on `main.nw` despite the content
existing. The file has CRLF line terminators. Use `grep -n` via Bash as a
fallback, or use the Read tool and search manually.

## 8. Self-modifying code disassembly strategy

For routines with self-modifying code (patching instruction operands):

1. Identify which bytes are patched (the STA/INC targets)
2. Map them to instruction operand positions
3. Use `.label+N` references for the patched operand bytes
4. For indexed self-modification (`STA base,X`), calculate: base = target - X
5. Verify the initial (unpatched) operand values match the binary
6. Document which instructions are self-modified in comments

## 9. Use heredocs for inline Python, never `python3 -c "..."`

Bash double-quoted strings interpret `$()` as command substitution and
`${}` as variable expansion. Python regex patterns like `r'\$([0-9A-Fa-f]{4})'`
and f-strings like `f'\${addr:04X}'` break because bash processes the `$`
before Python sees it.

**Bad:** `python3 -c "..."` — breaks with `$`, `()`, `{}` in Python code

**Good:** Use a single-quoted heredoc:
```bash
python3 << 'EOF'
import re
for m in re.finditer(r'\$([0-9A-Fa-f]{4})', text):
    print(f'${int(m.group(1),16):04X}')
EOF
```

The single quotes around `'EOF'` prevent ALL shell interpolation inside the
heredoc. This works reliably regardless of Python string content.

**Exception:** Very simple one-liners with no `$` can use `python3 -c '...'`
(single-quoted argument). But heredocs are safer as a default.

## 10. Ghidra branch structure is unreliable for hand-written 6502

Ghidra's disassembly often restructures control flow to look "logical" —
placing branch targets at the end of a function, showing forward branches.
But hand-written 6502 code heavily reuses code paths via **backward branches**.

**Example:** PLAYER_ATTACK ($1751, 248 bytes) has an "immune" handler at
$1788 (JSR/JSR/LDA/JMP). Three later branches (BCS at $179B, BPL at $17D7,
BEQ at $17E6) all branch **backward** to $1788 to reuse it. Ghidra showed
these as forward branches to a `.miss` label at the function end.

Similarly, `.show_found` at $181E was reused via backward BPL from $1834.

**Rule:** For any function >50 bytes, **dump the raw bytes and manually
trace every branch offset** before writing assembly. Calculate:
`target = PC_after_branch + signed_offset`. Don't trust Ghidra's label
placement or whether branches go forward vs backward.

**Quick check:** If a branch offset byte is >= $80, it's a backward branch
(negative signed offset). Any backward branch in Ghidra output that shows
as forward is wrong.

## 11. Ghidra "fall-through" claims are often wrong

Ghidra may describe a function as "falling through" to the next function
when the actual bytes show a branch or jump instruction.

**Example:** TURN_DISPATCH ($14A3) — Ghidra said BEQ/BMI "fell through" to
ENTER_COMBAT_STATE/START_COMBAT. Actually they were ordinary BEQ $14B7 and
BMI $14CD (external branches). The function ends with two JMP instructions.

**Rule:** Never write "falls through" comments without checking the actual
bytes. If the last instruction before the next ORG isn't an unconditional
flow change (JMP/RTS/BRA), verify the bytes to confirm actual fall-through.

## 12. Sort test file ORGs by ascending address

When building a multi-function test file, always sort functions by address.
dasm tracks a linear output position and errors if an ORG goes backward.

**Example:** LOAD_TARGET_PTR ($199D) was listed before PLAYER_ATTACK ($1751)
because the Ghidra subagent returned them in a different order.

**Rule:** After collecting disassembly from Ghidra (especially via parallel
subagents), sort by address before writing the test file.

## 13. Use dasm -f3 for binary comparison, never -f1

dasm output formats:
- `-f1`: 2-byte address header + raw binary (for loaders)
- `-f3`: raw binary only (for byte comparison)

Using -f1 and comparing from offset 0 shifts every byte by 2.

## 14. String replacement: watch for prefix collisions

`str.replace('ROM_COUT', 'ROM_COUT1')` also changes `ROM_COUT1` → `ROM_COUT11`.

**Rule:** When renaming identifiers, check if the old name is a prefix of
any existing identifier. Use word-boundary regex (`re.sub(r'\bOLD\b', 'NEW', text)`)
or replace longest names first, or verify no existing name starts with the old name.

## 15. Don't assume the existing codebase assembles cleanly

Before debugging assembly errors after your changes, check if the errors
existed before. The committed output files may have been generated by a
different process or an older version of the source.

**Example:** 34 "new" unresolved symbols turned out to be pre-existing — the
old main.asm also couldn't assemble due to a dispatch table overlap bug.
Time was wasted investigating whether my changes caused them.

**Rule:** When encountering errors, first `git stash` and test the old
version. Compare error lists to isolate truly new issues.

## 16. Write scripts >100 lines to files, not heredocs

Bash heredocs can fail with very large content, especially when the script
contains complex quoting (Python strings with quotes inside a single-quoted
heredoc delimiter). Use the Write tool to create a `.py` file, then run it.

## 17. Code/data overlap in 6502 — HEX data must stop at boundary

6502 programs sometimes embed code bytes in data tables (a dispatch table
whose last entries happen to be valid opcodes that start the next function).

**Example:** RESIDENT_DISPATCH_TABLE at $06D3 had 18 bytes, but the last 5
($06E0-$06E4) were also the first instructions of CONTEXT_SWAP (LDX #$0F /
LDA $50,X / PHA). The HEX data must stop at $06DF and let CONTEXT_SWAP's
ORG $06E0 define the overlapping bytes as code.

**Rule:** When a data region overlaps with code, truncate the HEX data at
the overlap boundary. The code ORG will define the overlapping bytes.

## 18. Loop/retry labels must include the re-executed call

When a loop re-calls a subroutine each iteration, the backward branch
target must be BEFORE the JSR, not after it.

**Example:** SELECT_COMBAT_TARGET has a loop that calls GET_ENTITY_THREAT
each iteration:
```
.loop_high:
    JSR     GET_ENTITY_THREAT   ; $18F7
    CMP     #$00                ; $18FA
    ...
    BNE     .loop_high          ; branches to $18F7
```

Placing `.loop_high` at the CMP (after the JSR) makes the branch offset
3 bytes short — the BNE targets $18FA instead of $18F7.

**Symptom:** Branch offset mismatch of exactly 3 bytes (the size of JSR).

**Rule:** When a loop body starts with a JSR that must be re-executed,
place the loop label BEFORE the JSR. Same applies to JMP-based retry
loops (VALIDATE_INPUT had `JMP .retry` needing to re-call `JSR FUN_600A`).

## 19. Global replace of $XXXX clobbers EQU definitions

`replace_all` of `$5A76` → `COMBAT_WILLINGNESS` also hits the EQU line
itself: `COMBAT_WILLINGNESS EQU $5A76` becomes
`COMBAT_WILLINGNESS EQU COMBAT_WILLINGNESS` (circular).

**Rule:** When replacing raw hex addresses with EQU names, either:
- Skip lines containing `EQU` and `%def`, or
- Fix the EQU definitions afterward, or
- Add the EQU definitions AFTER doing the replace (so `$XXXX` is gone
  from the code before the EQU line exists)

## Verification checklist

After writing any new assembly chunk:
1. Assemble in isolation with all external refs as EQUs
2. Compare byte-for-byte against main.bin (offset = addr - $0500)
3. Check chunk size matches (end_addr - start_addr)
4. **Clean up test files** (`rm output/test_*`) after verification
5. Run `python audit_orgs.py` for full regression
6. Run `python weave.py main.nw` to ensure tangling succeeds
