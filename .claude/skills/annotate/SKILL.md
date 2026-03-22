# annotate

Annotate an existing documented routine: replace raw addresses and constants with named EQUs, add inline comments, align comments, and add a header comment plate.

## Usage

```
/annotate ROUTINE_NAME
```

Where ROUTINE_NAME is the label of a routine already in main.nw (e.g., `DISPLAY_SHOP`).

## Instructions

This skill improves the readability of an already-documented routine by applying three passes. After each pass, assemble and verify (`python3 weave.py main.nw output && dasm output/main.asm -f3 -ooutput/main.bin -loutput/main.lst -soutput/main.sym && python3 .claude/skills/assemble/verify.py`).

### Pass 1: Replace raw addresses and constants with names

For every raw hex address or constant in the routine:

1. **Subroutine calls** (`JSR $XXXX`, `JMP $XXXX`): look up the label in main.sym or main.nw and replace.
2. **Data addresses** (`LDA $XXXX`, `STA $XXXX`, etc.): check if an EQU exists. If not and the address appears meaningful (game state, display buffer, etc.), create one with a descriptive name.
3. **Immediate constants** (`LDA #$XX`, `LDY #$XX`, `CMP #$XX`): if the value has a known meaning (field offset, bitmask, record size, character code), create an EQU. Define the EQU WITHOUT `#` (e.g., `LEVEL_MASK EQU $1F`) and use `#` on the instruction (e.g., `AND #LEVEL_MASK`).
4. **Record field offsets**: if a constant is used as an offset into a record (e.g., `LDY #$03 / LDA (ptr),Y`), create a named EQU for that offset. Group all field offset EQUs for the same record type together in a central `<<defines>>=` chunk (e.g., `EFIELD_*` for entity records, `EVENT_*` for event records). Check if an offset EQU already exists before creating a new one.
5. **Indirect addressing** (`LDA ($XX),Y`): check if the ZP pointer has an EQU name.
6. **Indexed addressing** (`STA $XXXX,X`): check if the base address has an EQU name.

For new EQUs, follow the zero-page aliasing convention: when a ZP address is used for different purposes in different subsystems, define a context-specific EQU name and only use it in the relevant code.

### Pass 2: Add inline comments and align

For each instruction or group of instructions:

1. **Comment the purpose**, not the mechanics. "extract location tier" not "rotate left 4 times".
2. **Use bracket comments** (`; \` ... `; /`) to group multi-instruction operations (pointer copies, field extractions, loops).
3. **Add section headers** (`; --- section name ---`) between logical phases of the routine.
4. **Label comments** on `.local` labels explaining the branch condition or loop purpose.
5. **Align all `;` comments** to the same column within the routine (typically column 40 for short instructions, further right if needed for long operands).

### Pass 3: Add header comment plate

Add a comment block immediately after the `SUBROUTINE` directive with:

```
    ; Brief one-line description of what the routine does.
    ;
    ; Inputs:
    ;   LABEL1  — what it means and how the routine uses it
    ;   LABEL2  — ...
    ;
    ; Behavior:
    ;   2-4 lines summarizing the algorithm or control flow.
    ;
    ; Outputs:  (if applicable)
    ;   What registers or memory locations hold results on return.
    ;
    ; Modifies:
    ;   List of memory locations written (EQU names, not raw addresses).
    ; Clobbers: A, X, Y  (whichever apply)
```

Omit the Outputs section if the routine doesn't return meaningful values (e.g., it ends with `JMP` to another routine).

### Reference: DISPLAY_SHOP

The routine DISPLAY_SHOP ($70DF) in main.nw is the reference example of a fully annotated routine. Study its style for comment alignment, bracket grouping, section headers, and header plate format.

### Notes

- Always verify byte-for-byte match after changes. Comments and EQU substitutions must not change assembled output.
- Do NOT rename labels that are already well-named.
- Do NOT add EQUs for ROM addresses ($C000-$FFFF) or well-known Apple II constants unless they improve clarity.
- When creating EQUs, place them in `<<defines>>=` or `<<zero page defines>>=` chunks just before the routine's chunk, following chunk placement rules.
- If a raw address is used in only one routine and has no broader meaning, a comment may be better than an EQU.
- **dasm EQU values are always addresses.** For immediate-mode constants (masks, sizes, offsets), define the EQU without `#` (e.g., `LEVEL_MASK EQU $1F`) and use `#` on the instruction (e.g., `AND #LEVEL_MASK`). Never put `#` in the EQU value — dasm ignores it and the instruction will assemble as zero-page addressing instead of immediate.
