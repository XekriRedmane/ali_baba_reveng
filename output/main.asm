    PROCESSOR 6502
    MACRO STOW
        LDA      #<{1}
        STA      {2}
        LDA      #>{1}
        STA      {2}+1
    ENDM
    MACRO STOW2
        LDA      #>{1}
        STA      {2}+1
        LDA      #<{1}
        STA      {2}
    ENDM
    MACRO MOVB
        LDA    {1}
        STA    {2}
    ENDM
    MACRO STOB
        LDA    {1}
        STA    {2}
    ENDM
    MACRO MOVW
        LDA    {1}
        STA    {2}
        LDA    {1}+1
        STA    {2}+1
    ENDM
    MACRO PSHW
        LDA    {1}
        PHA
        LDA    {1}+1
        PHA
    ENDM
    MACRO PULB
        PLA
        STA    {1}
    ENDM
    MACRO PULW
        PLA
        STA    {1}+1
        PLA
        STA    {1}
    ENDM
    MACRO INCW
        INC    {1}
        BNE    .continue
        INC    {1}+1
.continue
    ENDM
    MACRO ADDA
        CLC
        ADC    {1}
        STA    {1}
        BCC    .continue
        INC    {1}+1
.continue
    ENDM
    MACRO ADDAC
        ADC    {1}
        STA    {1}
        BCC    .continue
        INC    {1}+1
.continue
    ENDM
    MACRO ADDB
        LDA    {1}
        CLC
        ADC    {2}
        STA    {1}
        BCC    .continue
        INC    {1}+1
.continue
    ENDM
    MACRO ADDB2
        CLC
        LDA    {1}
        ADC    {2}
        STA    {1}
        BCC    .continue
        INC    {1}+1
.continue
    ENDM
    MACRO ADDW
        CLC
        LDA    {1}
        ADC    {2}
        STA    {3}
        LDA    {1}+1
        ADC    {2}+1
        STA    {3}+1
    ENDM
    MACRO ADDWC
        LDA    {1}
        ADC    {2}
        STA    {3}
        LDA    {1}+1
        ADC    {2}+1
        STA    {3}+1
    ENDM
    MACRO SUBB
        LDA    {1}
        SEC
        SBC    {2}
        STA    {1}
        BCS    .continue
        DEC    {1}+1
.continue
    ENDM
    MACRO SUBB2
        SEC
        LDA    {1}
        SBC    {2}
        STA    {1}
        BCS    .continue
        DEC    {1}+1
.continue
    ENDM
    MACRO SUBW
        SEC
        LDA    {1}
        SBC    {2}
        STA    {3}
        LDA    {1}+1
        SBC    {2}+1
        STA    {3}+1
    ENDM
    MACRO SUBWL
        SEC
        LDA    <{1}
        SBC    {2}
        STA    {3}
        LDA    >{1}
        SBC    {2}+1
        STA    {3}+1
    ENDM
    MACRO ROLW
        ROL    {1}
        ROL    {1}+1
    ENDM
    MACRO RORW
        ROR    {1}+1
        ROR    {1}
    ENDM
    MACRO BEQ.A
        CMP     {1}
        BEQ     {2}
    ENDM

    MACRO BNE.A
        CMP     {1}
        BNE     {2}
    ENDM

    MACRO BEQ.X
        CPX     {1}
        BEQ     {2}
    ENDM

    MACRO BNE.X
        CPX     {1}
        BNE     {2}
    ENDM

    MACRO BEQ.Y
        CPY     {1}
        BEQ     {2}
    ENDM

    MACRO BNE.Y
        CPY     {1}
        BNE     {2}
    ENDM
TEXT_COL                EQU     $24     ; Cursor position
TEXT_ROW                EQU     $25
TMP_PTR                 EQU     $FA     ; temporary pointer (2 bytes)
DATA_PTR3               EQU     $BA     ; data pointer 3 (2 bytes)
PRINT_STRING_ADDR       EQU     $BC     ; 2 bytes (same pointer as PRINT_FROM_PTR)
DATA_PTR                EQU     $BE     ; data pointer / return value (2 bytes)
FONT_COL        EQU     $5A0C
FONT_ROW        EQU     $5A0D
FONT_CHARNUM        EQU     $5A0E
FONT_CHARSET        EQU     $5A0F
s_PRINT_FONT_CHAR   EQU     $80A4   ; 10 bytes
CHAR_CHARSET        EQU     $80A6
CHAR_UPPER_LEFT     EQU     $80A8
CHAR_UPPER_RIGHT    EQU     $80A9
CHAR_LOWER_LEFT     EQU     $80AB
CHAR_LOWER_RIGHT    EQU     $80AC
BLINK_COL       EQU     $5AA2   ; font column  (0-19; $14 = disabled)
BLINK_ROW       EQU     $5AA3   ; font row
BLINK_CHAR      EQU     $5AA4   ; font character number
BLINK_ALT_CHAR          EQU     $7AC3   ; alternate blink character
ROM_COUT1            EQU     $FDED   ; Apple II ROM COUT1 (character output)
DAT_5a17_pos        EQU     $5A17   ; saved position for room search
is_at_outer_limits  EQU     $0BFA   ; check if position is at room boundary
MSG_TABLE_PTR           EQU     $4005   ; message table base (2 bytes)
MSG_LINE_COUNT          EQU     $5A57   ; lines printed so far
DELAY_COUNT             EQU     $7ABF   ; number of delay iterations
ANIM_FRAME_CTR          EQU     $7AAF   ; animation frame countdown
ANIM_INDEX              EQU     $7ABD   ; current animation table index
ANIM_WAIT_TABLE         EQU     $7AB0   ; per-frame wait counts (indexed)
ANIM_FRAME_TABLE        EQU     $7AB6   ; per-frame frame counts (indexed)
WAIT_LOOP_COUNT         EQU     $5A8C   ; inner wait loop counter
WAIT_DURATION           EQU     $7AAD   ; ROM WAIT duration parameter
ROM_WAIT                EQU     $FCA8   ; Apple II ROM WAIT routine
TEXT_RIGHT_MARGIN        EQU     $5A96   ; right margin column for text wrap
TEXT_LEFT_MARGIN         EQU     $5A97   ; left margin column for text wrap
TEXT_STREAM_IDX          EQU     TEXT_STREAM_IDX   ; saved Y index into byte stream
IS_PLAYER_TURN  EQU     $5A74   ; 0 = mob's turn, 1 = player's turn
    ORG     $0569
ATTRACT_LOOP:
    SUBROUTINE

    JSR     CONTEXT_SWAP
    JSR     RESIDENT_DISPATCH
    JMP     ATTRACT_LOOP
    ORG     $06B3
RESIDENT_DISPATCH:
    SUBROUTINE

    TXA                             ; \
    PHA                             ;  | save X, Y on stack
    TYA                             ;  | (these ARE the bytecode pointer)
    PHA                             ; /
    JSR     PULL_TWO_RET_ADDRS      ; rearrange stack, jump to .resume

    ; Control returns here via JMP ($54):
.resume:
    PLA                             ; \  recover saved Y
    STA     $52                     ;  | $52/$53 = bytecode pointer
    PLA                             ;  | recover saved X
    STA     $53                     ; /

    LDY     #$04                    ; skip 4 bytes
.fetch:
    LDA     ($52),Y                 ; read opcode
    INY
    BNE     .no_carry
    INC     $53
.no_carry:
    TAX                             ; opcode → X (also saves position)
    LDA     RESIDENT_DISPATCH_TABLE,X
    STA     resident_jmp+1          ; self-modify: JMP low byte
resident_jmp:
    JMP     RESIDENT_DECODE_DISPATCH ; self-modified → $07xx
    ORG     $06D3
RESIDENT_DISPATCH_TABLE:
    HEX     00 27 55 5F 6D 8A AD B9
    HEX     4F A2 CE 26 79 A2 0F B5
    HEX     50 48
    ORG     $06E0
CONTEXT_SWAP:
    SUBROUTINE

    LDX     #$0F
.loop:
    LDA     $50,X                   ; load ZP byte
    PHA                             ; save on stack
    LDA     $7E5,X                  ; load shadow byte
    STA     $50,X                   ; → ZP
    PLA                             ; recover old ZP byte
    STA     $7E5,X                  ; → shadow
    DEX
    BPL     .loop
    RTS
    ORG     $0700
RESIDENT_DECODE_DISPATCH:
    SUBROUTINE

    JSR     DECODE_ENCRYPTED_ADDR   ; → $54/$55
    LDA     $54                     ; \
    STA     $52                     ;  | $52/$53 = decoded address
    LDA     $55                     ;  |
    STA     $53                     ; /
    LDY     #$00
    JMP     RESIDENT_DISPATCH.fetch ; fetch from new location
    ORG     $0710
DECODE_ENCRYPTED_ADDR:
    SUBROUTINE

    LDA     ($52),Y                 ; read low byte
    EOR     #$03                    ; decrypt
    INY
    BNE     .no_carry1
    INC     $53
.no_carry1:
    STA     $54                     ; decoded low
    LDA     ($52),Y                 ; read high byte
    INY
    BNE     .no_carry2
    INC     $53
.no_carry2:
    EOR     #$D9                    ; decrypt
    STA     $55                     ; decoded high
    RTS
    ORG     $0738
PULL_TWO_RET_ADDRS:
    SUBROUTINE

    PLA                             ; own return addr (low)
    STA     $54
    PLA                             ; own return addr (high)
    STA     $55
    PLA                             ; caller's return addr (low)
    STA     $52
    PLA                             ; caller's return addr (high)
    STA     $53
    INC     $52                     ; +1 (RTS pushed addr-1)
    INC     $54                     ; +1
    BNE     .done
    INC     $55                     ; carry
.done:
    JMP     ($54)                   ; jump back to .resume
    ORG     $0800
MAIN_ENTRY:
    SUBROUTINE

    JSR     GAME_INIT
    LDA     #$09                    ; \
    STA     $FA                     ;  | $FA/$FB = $4009 (character record base)
    LDA     #$40                    ;  |
    STA     $FB                     ; /
    LDA     $5A01                   ; first-run flag
    BNE     .skip                   ; nonzero = game in progress
    JSR     ATTRACT_SCREEN
.skip:
    ; ... continues to game loop ...
    ORG     $09F4
ATTRACT_SCREEN:
    SUBROUTINE

    LDA     #$01
    STA     $5A29                   ; scene/character index = 1
    STA     $423E                   ; flag
    JSR     COMPUTE_SCENE_PTR       ; scene 1 pointer → $BA/$BB
    LDA     $BA                     ; \
    STA     $F4                     ;  | $F4/$F5 = $BA/$BB (save pointer)
    LDA     $BB                     ;  |
    STA     $F5                     ; /
    JSR     $0A17                   ; scene_setup
    LDA     #$00
    STA     $5A55                   ; clear location-change flag
    JSR     SET_CURSOR_ROW21
    LDA     #$26                    ; scene number $26 (38 decimal)
    JMP     SCENE_LOOP              ; tail-call
    ORG      $0B62
    ; Takes A (pos) and TMP_PTR (pointer to room data)
get_item_at_pos_in_room:
    SUBROUTINE

    STA      DAT_5a17_pos

    ; load1 <- TMP_PTR
    ; load3 <- TMP_PTR

    LDA      TMP_PTR+1
    STA      .load1+2
    STA      .load3+2
    LDA      TMP_PTR
    STA      .load1+1
    STA      .load3+1
    JMP      .get_mob_link

.inner_loop:
    ; load2 <- room data[MAP]

    LDX      #$06
.load1:
    LDA      .load1+1,X
    STA      .load2+1-6,X
    INX
    BNE.X    #$08, .load1

.load2:
    ; Y <- (load2)

    LDY      .load2+1
    BNE.Y    #$FF, .not_ff          ; (load2) != 0xFF?
    JMP      is_at_outer_limits     ; else goto is_at_outer_limits

.not_ff:
    BEQ.Y    DAT_5a17_pos, .return_load2  ; (load2) == DAT_5a17_pos?

    ; load2 += 3

    INCW     .load2
    INCW     .load2
    INC      .load2+1
    BNE      .load2
    INC      .load2+2
    JMP      .load2

.return_load2:
    ; DATA_PTR <- load2

    STOW     .load2+1, DATA_PTR
    RTS

.get_mob_link:

    LDX      #$02
.load3:
    LDA      .load3+1,X  ; A <- load3[MOB]
    BEQ.A    #$00, .inner_loop
    JSR      mob_dataptr_to_load4

    LDX      #$03
.load4:
    LDY      .load4+1,X  ; Y <- load4[POS]
    BEQ.Y    DAT_5a17_pos, .return_load4

    ; load3 <- load4

    STOW     .load4+1, .load3+1
    JMP      .get_mob_link

.return_load4:
    ; DATA_PTR = 0x8000 | load4

    LDA      #$80
    ORA      .load4+2
    STA      DATA_PTR+1
    LDA      .load4+1
    STA      DATA_PTR
    RTS

mob_dataptr_to_load4:
    SUBROUTINE
    ; load4 <- mob data for A

    JSR      GET_MOB_DATA
    STOW     DATA_PTR3, .load4
    RTS
    ORG     $0C25
POS_TO_COLROW:
    SUBROUTINE

    LDY      #$00              ; row = 0
.loop:
    CLC
    ADC      #$EC              ; A -= 20 (unsigned)
    BCC      .done             ; underflow → remainder is negative
    INY                        ; row++
    BCS      .loop             ; always taken (carry set)
.done:
    ADC      #$14              ; add 20 back → A = column (remainder)
    RTS                        ; A = column (0-19), Y = row (0-9)
    ORG     $0C32
GET_MOB_DATA:
    SUBROUTINE

    CLC
    ADC     #$FF                    ; A = index - 1, C = 1
    ROL                             ; \
    ROL                             ;  | rotate {C, A} left 4 bits
    ROL                             ;  | = (index-1) * 16 with bits split
    ROL                             ; /
    TAY                             ; save rotated value
    ROL                             ; one more rotate
    AND     #$0F                    ; high byte contribution = (index-1) >> 4
    CLC
    ADC     $4001                   ; add base page
    STA     DATA_PTR3+1
    TYA
    AND     #$F0                    ; low byte contribution = ((index-1) & $0F) << 4
    CLC
    ADC     $4000                   ; add base offset
    STA     DATA_PTR3
    BCC     .done
    INC     DATA_PTR3+1             ; carry to high byte
.done:
    RTS
    ORG     $0C32
COMPUTE_SCENE_PTR:
    SUBROUTINE

    CLC
    ADC     #$FF                    ; A = index - 1
    ROL     A                       ; \
    ROL     A                       ;  | rotate left 4 times
    ROL     A                       ;  | = multiply by 16 (with carry)
    ROL     A                       ; /
    TAY                             ; save intermediate
    ROL     A                       ; one more rotate
    AND     #$0F                    ; high nybble → page offset
    CLC
    ADC     $4001                   ; add base page
    STA     $BB                     ; high byte
    TYA
    AND     #$F0                    ; low nybble → byte offset
    CLC
    ADC     $4000                   ; add base offset
    STA     $BA                     ; low byte
    BCC     .done
    INC     $BB                     ; carry
.done:
    RTS
    ORG     $0CF7
APPEARANCE_TO_FONTCHAR:
    SUBROUTINE

    LDY      #$00              ; Y = quotient (font group)
.loop:
    CLC
    ADC      #$EB              ; A -= 21 (unsigned: $EB = 256-21)
    BCC      .done             ; underflow → done dividing
    INY                        ; group++
    BCS      .loop             ; always taken
.done:
    ADC      #$16              ; restore remainder+1 (carry clear, so +22)
    CMP      #$05              ; remainder >= 5?
    BCC      .low              ; no → check group
    RTS                        ; yes → return as-is (chars 5-21)
.low:
    CPY      #$00              ; first group?
    BEQ      .ret              ; yes → return as-is (chars 1-4)
    CLC
    ADC      #$20              ; add 32 → next font group (chars 33-36)
.ret:
    RTS
    ORG     $0D10
DELAY_WITH_ANIMATION:
    SUBROUTINE

    LDA     DELAY_COUNT             ; load iteration count
.loop:
    PHA                             ; save counter
    JSR     ANIM_TICK_AND_WAIT      ; tick animation + timed wait
    PLA                             ; restore counter
    TAY
    DEY                             ; decrement
    TYA
    BNE     .loop                   ; loop until zero
    RTS
    ORG     $0D1E
TICK_ANIM_COUNTER:
    SUBROUTINE

    DEC     ANIM_FRAME_CTR          ; tick frame counter
    BNE     .reload                 ; not zero → just reload wait count
    JSR     DRAW_BLINK_ALT          ; counter hit zero → draw alt char
.reload:
    LDX     ANIM_INDEX              ; current animation index
    LDA     ANIM_WAIT_TABLE,X       ; look up wait count for this frame
    STA     WAIT_LOOP_COUNT         ; store for timed_wait to use
    RTS
    ORG     $0D30
ANIM_TICK_AND_WAIT:
    SUBROUTINE

    JSR     TICK_ANIM_COUNTER       ; tick counter, reload wait count
    JSR     TIMED_WAIT              ; burn time
    LDA     ANIM_FRAME_CTR          ; did frame counter expire?
    BEQ     .advance                ; yes → advance animation
    RTS                             ; no → return

.advance:
    JSR     DRAW_BLINK_NORMAL       ; redraw blink char in normal video
    LDX     ANIM_INDEX              ; reload animation index
    LDA     ANIM_FRAME_TABLE,X      ; look up frame duration
    STA     ANIM_FRAME_CTR          ; reset frame counter
    RTS
    ORG     $0D49
TIMED_WAIT:
    SUBROUTINE

    LDA     WAIT_LOOP_COUNT         ; anything to wait for?
    BNE     .wait                   ; yes → enter wait loop
    RTS                             ; no → return immediately

.wait:
    JSR     CALL_ROM_WAIT           ; delay one unit
    DEC     WAIT_LOOP_COUNT         ; decrement counter
    BNE     .wait                   ; loop until zero
    RTS
    ORG     $0D58
CALL_ROM_WAIT:
    SUBROUTINE

    LDA     WAIT_DURATION           ; load duration parameter
    JMP     ROM_WAIT                ; tail-call ROM WAIT
    ORG     $74CB
DRAW_BLINK_ALT:
    SUBROUTINE

    LDA     BLINK_CHAR              ; save current blink char
    PHA
    LDA     BLINK_ALT_CHAR          ; load alternate char
    STA     BLINK_CHAR              ; swap it in
    JSR     DRAW_BLINK_CHAR         ; draw at blink position
    PLA
    STA     BLINK_CHAR              ; restore original char
    RTS
    ORG     $74DD
DRAW_BLINK_NORMAL:
    JSR     PRINT_CTRL_N            ; Ctrl-N → normal video

DRAW_BLINK_CHAR:
    SUBROUTINE

    LDA     BLINK_COL               ; load blink column
    CMP     #$14                    ; >= 20? (disabled sentinel)
    BCC     .draw
    RTS                             ; disabled — do nothing

.draw:
    STA     FONT_COL                ; copy blink state to font vars
    LDA     BLINK_ROW
    STA     FONT_ROW
    LDA     BLINK_CHAR
    STA     FONT_CHARNUM
    LDA     #$01
    STA     FONT_CHARSET            ; charset 1
    LDA     PRINT_STRING_ADDR       ; save $BC/$BD (used by PRINT_FONTCHAR)
    PHA
    LDA     PRINT_STRING_ADDR+1
    PHA
    JSR     PRINT_FONTCHAR          ; render the character
    PLA
    STA     PRINT_STRING_ADDR+1     ; restore $BC/$BD
    PLA
    STA     PRINT_STRING_ADDR
    RTS
    ORG     $5D7D
PLOT_CHAR:
    SUBROUTINE

    STA     FONT_CHARNUM
    STX     TEXT_COL
    STY     TEXT_ROW
    LDA     #$01
    STZ     FONT_CHARSET
    JMP     PRINT_FONTCHAR_AT_TEXT_POS
    ORG     $80A4
    HEX     09      ; num chars in this string
    HEX     81      ; ctrl-A (set character set)
    HEX     B1      ; CHAR_CHARSET (self-modified)
    HEX     82      ; ctrl-B (block display mode)
    HEX     A0      ; CHAR_UPPER_LEFT (self-modified)
    HEX     A0      ; CHAR_UPPER_RIGHT (self-modified)
    HEX     83      ; ctrl-C (move to lower left of block)
    HEX     A0      ; CHAR_LOWER_LEFT (self-modified)
    HEX     A0      ; CHAR_LOWER_RIGHT (self-modified)
    HEX     84      ; ctrl-D (complete block data)

    ORG     $7489
PRINT_FONTCHAR:
    SUBROUTINE

    JSR     FONT_POS_TO_TEXT_POS
    ; fall through

PRINT_FONTCHAR_AT_TEXT_POS:
    LDX     #$B1            ; start from char set 1
    LDA     FONT_CHARSET
    CMP     #$02
    BNE     .store_charset

    ; FONT_CHARSET != 2
    INX
    INX                     ; start from charset 3 if FONT_CHARSET != 2.

.store_charset:
    STX     CHAR_CHARSET
    ; fall through

PLOT_FONTCHAR:
    LDA     FONT_CHARNUM

    ; Increment the charset by 1 for every multiple above character 24.
.loop:
    CMP     #24             ; 24 font chars = 96 normal chars = 1 char set
    BCC     .print_block

    ; FONT_CHARNUM >= 24
    INX
    STX     CHAR_CHARSET
    SEC
    SBC     #24
    JMP     .loop

.print_block:
    ASL
    ASL
    CLC
    ADC     #$20    ; A = 4*charnum + $20 (skip space)
    TAY
    STY     CHAR_UPPER_LEFT
    INY
    STY     CHAR_UPPER_RIGHT
    INY
    STY     CHAR_LOWER_LEFT
    INY
    STY     CHAR_LOWER_RIGHT
    LDA     #<s_PRINT_FONT_CHAR
    STA     $BC
    LDA     #>s_PRINT_FONT_CHAR
    STA     $BD
    JMP     PRINT_FROM_PTR
    ORG     $6C37
SCENE_LOOP:
    SUBROUTINE

    STA     $5A99                   ; store scene number
    LDA     #$14
    STA     BLINK_COL               ; disable blink cursor

    JSR     SAVE_ZP_POINTERS

    JSR     STEP_PRNG
    LDA     $5A18                   ; PRNG output
    AND     #$0A                    ; test bits 1 and 3
    BNE     .display                ; if any set, skip disk load
    JSR     LOAD_SCENE_DATA

.display:
    JSR     $A478                   ; keyboard/timing check (EALDR resident)
    BCS     .exit                   ; carry set = user pressed key

    JSR     DISPLAY_STATUS_BAR
    LDA     #<$5C00                 ; \
    STA     $06                     ;  | $06/$07 = $5C00 (scene text data)
    LDA     #>$5C00                 ;  |
    STA     $07                     ; /
    JSR     TEXT_RENDERER

    LDX     #$06                    ; script index 6
    JSR     SCRIPT_ENGINE           ; run script #3 ($A300)
    LDA     $5CFF                   ; scene transition flag
    BEQ     .done                   ; zero = no transition
    STA     $5A99                   ; set new scene number
    JMP     .display                ; continue

.exit:
    JSR     SET_TEXT_WINDOW_BOTTOM
    LDA     #$1B
    JSR     $761E                   ; sound/mode off
                                    ; fall through to .done

.done:
    JSR     SET_TEXT_WINDOW_BOTTOM
    LDA     #$00                    ; \
    STA     $5A55                   ;  | clear location flags
    STA     $5A56                   ; /
    JSR     $72A7                   ; update display
    JMP     RESTORE_ZP_POINTERS     ; restore and return
    ORG     $6C8E
TEXT_RENDERER:
    SUBROUTINE

    LDY     #$00
.init:
    LDA     #$02
    STA     TEXT_LEFT_MARGIN         ; left margin = 2
    STA     FONT_COL                ; current column = 2
    LDA     #$12
    STA     TEXT_RIGHT_MARGIN       ; right margin = $12 (18)
    LDA     #$01
    STA     FONT_ROW                ; current row = 1

    ; --- Main byte-reading loop ---
.fetch:
    LDA     ($06),Y                 ; read byte from stream
    BMI     .set_pos                ; bit 7 set → position command
    CMP     #$7F
    BNE     .not_end
    RTS                             ; $7F = end of stream

.not_end:
    CMP     #$7E
    BEQ     .pause                  ; $7E = pause
    CMP     #$7D
    BEQ     .reset                  ; $7D = reset to full-screen mode

    ; --- Character output ---
    STY     TEXT_STREAM_IDX                   ; save stream index
    STA     FONT_CHARNUM            ; character code
    LDA     #$02
    STA     FONT_CHARSET            ; character width = 2
    JSR     PRINT_FONTCHAR          ; draw at current position
    INC     FONT_COL                ; advance column
    LDA     FONT_COL
    CMP     TEXT_RIGHT_MARGIN       ; past right margin?
    BCC     .next                   ; no → continue
    INC     FONT_ROW                ; yes → next row
    LDA     TEXT_LEFT_MARGIN        ;   reset column to left margin
    STA     FONT_COL
.next:
    LDY     TEXT_STREAM_IDX                   ; restore stream index
    INY                             ; advance to next byte
    BNE     .fetch                  ; loop (max 256 per page)
    JMP     $1A31                   ; overflow handler

    ; --- Position command ($80-$FE) ---
.set_pos:
    AND     #$7F                    ; row = byte & $7F
    STA     FONT_ROW
    INY
    LDA     ($06),Y                 ; next byte = column
    STA     FONT_COL
    INY
    JMP     .fetch

    ; --- Pause ($7E): run script engine, show status bar ---
.pause:
    TYA                             ; \
    PHA                             ;  | save stream index
    NOP
    LDX     #$06
    JSR     SCRIPT_ENGINE           ; run attract script
    LDA     $06                     ; \
    PHA                             ;  | save $06/$07 (stream pointer)
    LDA     $07                     ;  |
    PHA                             ; /
    JSR     DISPLAY_STATUS_BAR      ; (clobbers $06/$07)
    PLA                             ; \
    STA     $07                     ;  | restore $06/$07
    PLA                             ;  |
    STA     $06                     ; /
    PLA                             ; restore stream index
    TAY
    NOP
    INY                             ; advance past $7E
    JMP     .init                   ; reinit margins/position

    ; --- Reset ($7D): full-screen text mode ---
.reset:
    LDA     #$00
    STA     TEXT_LEFT_MARGIN         ; left margin = 0
    STA     FONT_COL                ; column = 0
    STA     FONT_ROW                ; row = 0
    LDA     #$14
    STA     TEXT_RIGHT_MARGIN       ; right margin = $14 (20)
    INY                             ; advance past $7D
    JMP     .fetch
    ORG     $6D1F
DISPLAY_STATUS_BAR:
    SUBROUTINE

    LDA     #$90                    ; ctrl-P with high bit (toggle inverse)
    JSR     ROM_COUT1
    STOW    STATUS_BORDER_DATA,$06  ; $06/$07 → status bar border data
    JSR     TEXT_RENDERER           ; draw border box
    JSR     PRINT_CTRL_AB           ; Ctrl-A, '0'
    LDA     #$17
    STA     TEXT_ROW                ; WNDBTM = 23

    LDA     $5A00                   ; joystick/keyboard flag
    BNE     .joystick

    ; Keyboard path:
    STOW    S_PRESS_SPACE,$BC       ; $BC/$BD → "PRESS SPACE BAR..."
.set_margin:
    LDA     #$04
    STA     TEXT_COL                ; WNDLFT = 4
    JMP     PRINT_FROM_PTR         ; print string, return

.joystick:
    STOW    S_PRESS_BUTTON,$BC      ; $BC/$BD → "PRESS THE BUTTON..."
    JMP     .set_margin
    ORG     $6D53
SAVE_ZP_POINTERS:
    SUBROUTINE

    LDA     $BC
    STA     $5A9A
    LDA     $BD
    STA     $5A9B
    LDA     $F8
    STA     $5A9C
    LDA     $F9
    STA     $5A9D
    LDA     $BE
    STA     $5A9E
    LDA     $BF
    STA     $5A9F
    LDA     $F4
    STA     $5AA0
    LDA     $F5
    STA     $5AA1
    RTS
    ORG     $6D7C
RESTORE_ZP_POINTERS:
    SUBROUTINE

    LDA     $5A9A
    STA     $BC
    LDA     $5A9B
    STA     $BD
    LDA     $5A9C
    STA     $F8
    LDA     $5A9D
    STA     $F9
    LDA     $5A9E
    STA     $BE
    LDA     $5A9F
    STA     $BF
    LDA     $5AA0
    STA     $F4
    LDA     $5AA1
    STA     $F5
    RTS
    ORG     $6DA5
RELOCATE_HIRES_STAGING:
    SUBROUTINE

    LDA     #$00
    STA     $BA                         ; \  dest = $9600
    STA     $BC                         ; \  src  = $2000
    LDA     #$20                        ;  |
    STA     $BD                         ; /  src hi
    LDA     #$96                        ;  |
    STA     $BB                         ; /  dest hi
    LDY     #$00
    LDX     #$13                        ; 19 pages: $2000-$32FF -> $9600-$A8FF
    JSR     .copy
    LDX     #$0D                        ; 13 pages: $3300-$3FFF -> $B300-$BFFF
    LDA     #$B3
    STA     $BB                         ; dest hi = $B3
    INC     $BD                         ; src hi = $33 (was $32 after first pass)

.copy:
    LDA     ($BC),Y                     ; load from source
    STA     ($BA),Y                     ; store to dest
    LDA     #$00
    STA     ($BC),Y                     ; clear source byte
    DEY
    BNE     .copy                       ; inner loop (256 bytes)
    DEX
    BNE     .next_page                  ; more pages?
    RTS

.next_page:
    INC     $BD                         ; next source page
    INC     $BB                         ; next dest page
    JMP     .copy
    ORG     $6DD8
LOAD_SCENE_DATA:
    SUBROUTINE

    BIT     $C0E9                   ; check disk controller
    LDA     #$05                    ; \
    LDY     #$04                    ;  | ($08)+4 = 5 (track configuration)
    STA     ($08),Y                 ; /
    LDA     #$00
    JSR     $6C18                   ; prepare disk parameters
    CLC
    JSR     $B300                   ; EALDR disk read routine
    BCS     .error
    RTS

.error:
    LDY     $5A18                   ; on error: fill with PRNG data
    JSR     STEP_PRNG
    LDA     $5A18
    STA     $9AA6,Y
    RTS
    ORG     $7705
PRINT_BOTTOM_CENTERED:
    SUBROUTINE

    LDA     #$17
    STA     TEXT_ROW
    LDA     #$00
    STA     TEXT_COL
    JMP     PRINT_CENTERED_PLUS_COL
    ORG     $7710
PRINT_CENTERED_PLUS_COL:
    SUBROUTINE

    LDA     #40
    SEC
    LDY     #$00
    SBC     (PRINT_STRING_ADDR),Y
    CLC
    LSR                             ; accumulator
    ADC     TEXT_COL
    STA     TEXT_COL
    JSR     SET_CHARSET_0
    JMP     PRINT_STRING
    ORG     $7723
FONT_POS_TO_TEXT_POS:
    SUBROUTINE

    LDA     FONT_COL
    ASL
    STA     TEXT_COL
    LDA     FONT_ROW
    ASL
    STA     TEXT_ROW
    RTS
    ORG     $7730
SET_INVERSE_VIDEO:
    SUBROUTINE

    LDA     #$89        ; ctrl-I
    JMP     ROM_COUT1

    ORG     $773A
SET_TEXT_WINDOW_WRAP:
    SUBROUTINE

    LDA     #$8F        ; ctrl-O
    JSR     ROM_COUT1
    LDA     #$97        ; ctrl-W
    JMP     ROM_COUT1

SET_TEXT_WINDOW_SCROLL:
    SUBROUTINE

    LDA     #$8F        ; ctrl-O
    JSR     ROM_COUT1
    LDA     #$93        ; ctrl-S
    JMP     ROM_COUT1

; PRINT_CTRL_AB (SET_CHARSET_0) follows at $774E, defined in its own chunk

    ORG     $7735
PRINT_CTRL_N:
    SUBROUTINE

    LDA     #$8E                    ; Ctrl-N with high bit
    JMP     ROM_COUT1                ; output via COUT1
    ORG     $7758
PRINT_STRING_AT_ADDR:
    SUBROUTINE

    STX     PRINT_STRING_ADDR
    STY     PRINT_STRING_ADDR+1

    ; falls through to PRINT_STRING / PRINT_FROM_PTR at $775C
    ORG     $775C
PRINT_STRING             ; same entry as PRINT_FROM_PTR
    ORG     $7649
SET_CURSOR_COMPRESSED:
    SUBROUTINE

    PHA
    AND     #$3F
    STA     TEXT_COL
    PLA
    LSR
    LSR
    LSR
    LSR
    LSR
    LSR
    CLC
    ADC
    ADC     #20
    STA     TEXT_ROW
    RTS
    ORG     $761E
DISPLAY_MESSAGE:
    SUBROUTINE

    TAX                             ; X = message index
    LDA     MSG_TABLE_PTR           ; load table base into $BC/$BD
    STA     PRINT_STRING_ADDR
    LDA     MSG_TABLE_PTR+1
    STA     PRINT_STRING_ADDR+1
    LDA     #$00
    STA     MSG_LINE_COUNT          ; reset line counter

    JMP     .check_index            ; skip to index check

.skip_entry:
    LDY     #$00
    LDA     (PRINT_STRING_ADDR),Y   ; get string length
    TAY
    SEC                             ; +1 for length byte itself
    ADC     PRINT_STRING_ADDR       ; advance pointer past this entry
    STA     PRINT_STRING_ADDR
    LDA     PRINT_STRING_ADDR+1
    ADC     #$00
    STA     PRINT_STRING_ADDR+1
    CPY     #$00                    ; was length zero? (end of table)
    BNE     .skip_entry             ; no — keep skipping within group
.next_index:
    DEX
.check_index:
    CPX     #$00
    BNE     .skip_entry             ; more entries to skip

.print_loop:
    LDY     #$00
    LDA     (PRINT_STRING_ADDR),Y   ; get length of current string
    BNE     .has_text               ; nonzero — print it

    ; length is zero — message is done
    LDA     MSG_LINE_COUNT
    CMP     #$02                    ; printed exactly 2 lines?
    BEQ     .final_scroll
    RTS                             ; otherwise just return
.final_scroll:
    JMP     $769B                   ; scroll once more and return

.has_text:
    LDA     MSG_LINE_COUNT
    CMP     #$01
    BMI     .first_line             ; line_count < 1: first line
    BEQ     .second_line            ; line_count == 1: second line

    ; third+ line: scroll, then print
    JSR     $769B                   ; scroll status window
.second_line:
    JSR     PRINT_BOTTOM_CENTERED   ; print centered on row 23
    JMP     .advance

.first_line:
    JSR     PRINT_BOTTOM_CENTERED   ; print centered on row 23
    JSR     $769B                   ; scroll status window

.advance:
    INC     MSG_LINE_COUNT
    LDY     #$00
    LDA     PRINT_STRING_ADDR
    SEC
    ADC     (PRINT_STRING_ADDR),Y   ; add length + 1 (SEC sets carry)
    STA     PRINT_STRING_ADDR
    LDA     PRINT_STRING_ADDR+1
    ADC     #$00
    STA     PRINT_STRING_ADDR+1
    LDA     #$01
    CMP     MSG_LINE_COUNT          ; printed <= 1 lines?
    BCC     .pause                  ; no — need to pause
    LDY     #$00
    LDA     (PRINT_STRING_ADDR),Y   ; peek at next entry
    BNE     .print_loop             ; more text — keep printing

.pause:
    JSR     DELAY_WITH_ANIMATION    ; delay
    JSR     PRINT_CTRL_AB           ; reset character set
    JMP     .print_loop             ; continue with next line
    ORG     $774E
PRINT_CTRL_AB:
    SUBROUTINE

    LDA     #$81                    ; Ctrl-A with high bit
    JSR     ROM_COUT1
    LDA     #$B0                    ; '0' with high bit
    JMP     ROM_COUT1
    ORG     $775C
PRINT_FROM_PTR:
    SUBROUTINE

    LDY     #$00
    LDA     ($BC),Y                 ; first byte = length
    TAX
.loop:
    DEX
    BPL     .next
    RTS                             ; done

.next:
    INY
    LDA     ($BC),Y                 ; read next char
    JSR     ROM_COUT1
    JMP     .loop
    ORG     $76BE
SET_CURSOR_ROW21:
    SUBROUTINE

    LDA     #$15                    ; WNDBTM = 21
    BNE     .shared                 ; always taken (stretchy branch)

SET_TEXT_WINDOW_BOTTOM:
    LDA     #$14                    ; WNDBTM = 20

.shared:
    STA     TEXT_ROW
    LDA     #$00
    STA     TEXT_COL                ; WNDLFT = 0
    JSR     PRINT_CTRL_AB
    LDA     #$86                    ; Ctrl-F with high bit
    JMP     ROM_COUT1
    ORG     $78A8
STEP_PRNG:
    SUBROUTINE

    LDA     $5A19                   ; val
    ASL     A                       ; val*2
    ASL     A                       ; val*4
    STA     $5A1A                   ; temp = val*4
    ASL     A                       ; val*8
    ASL     A                       ; val*16
    ASL     A                       ; val*32
    ASL     A                       ; val*64
    CLC
    ADC     $5A1A                   ; val*64 + val*4 = val*68
    CLC
    ADC     $5A19                   ; val*68 + val = val*69
    CLC
    ADC     #$53                    ; + $53
    STA     $5A19                   ; store full result
    LSR                             ; val >> 1
    STA     $5A18                   ; shifted copy (used for random tests)
    RTS
    ORG     $78C7
GAME_INIT:
    SUBROUTINE

    LDX     #$6F                    ; \
    LDY     #$A5                    ;  | reset vector = $A56F
    STX     $03F2                   ;  |
    STY     $03F3                   ; /
    JSR     $FB6F                   ; ROM: set reset vector checksum
    LDA     #$14
    STA     BLINK_COL               ; disable blink cursor
    JSR     RELOCATE_HIRES_STAGING  ; copy $2000+ to $9600+/$B300+
    LDA     $C050                   ; GR mode
    LDA     $C052                   ; full screen (no text split)
    LDA     $C054                   ; page 1
    LDA     $C057                   ; hi-res
    JSR     $6C2E
    JSR     $791A
    JSR     $773A
    JSR     $7919
    JSR     $5B00
    JSR     $743B
    JSR     SET_TEXT_WINDOW_BOTTOM
    JSR     $6B94
    LDA     #$00                    ; \
    STA     $5A55                   ;  | clear state variables
    STA     $5A56                   ;  |
    STA     $F9                     ; /
    JSR     $084E
    JSR     $62E5
    JSR     $0C51
    LDA     #$01
    STA     $5A02                   ; current player = 1
    RTS
    ORG     $795B
SCRIPT_ENGINE:
    SUBROUTINE

    STA     $C010                   ; clear keyboard strobe
    LDA     #$00
    STA     $5AA7                   ; attract_flag = 0
    CPX     #$06                    ; script index 6 = attract
    BNE     .not_attract
    INC     $5AA7                   ; attract_flag = 1
.not_attract:

    CPX     #$02                    ; special setup for index 2
    BEQ     .setup_2
    CPX     #$04                    ; special setup for index 4
    BEQ     .setup_4
    JMP     .load_ptr

.setup_2:
    DEY
    STY     $80D5
    JMP     .load_ptr
.setup_4:
    DEY
    STY     $80E3

.load_ptr:
    LDA     SCRIPT_TABLE,X          ; low byte
    STA     $E4
    LDA     SCRIPT_TABLE+1,X        ; high byte
    STA     $E5                     ; $E4/$E5 = script start address

    LDA     #$00
    STA     $5A8D                   ; loop counter = 0
    LDA     #$01
    STA     $5A92                   ; PRNG mask = 1
.fetch:
    LDY     #$00
    LDA     ($E4),Y                 ; read script byte
    CMP     #$27
    BCC     .control                ; < $27 → control command
    JMP     .action                 ; ≥ $27 → action dispatch

.control:
    CMP     #$25
    BEQ     .cmd_25                 ; set PRNG mask = $0F
    BCS     .cmd_26                 ; $26: PRNG mask = $00

    CMP     #$23
    BEQ     .cmd_23                 ; set action vector → $7A7F
    BCS     .cmd_24                 ; set action vector → $7A91

    CMP     #$21
    BEQ     .cmd_21                 ; gosub
    BCS     .cmd_22                 ; nop (return)

    CMP     #$1F
    BEQ     .cmd_1F                 ; set loop address
    BCS     .cmd_20                 ; set gosub address

    ; --- Loop/end-loop (byte < $1F) ---
    CMP     $5A8D                   ; compare with loop counter
    BEQ     .end_loop
    BCC     .end_loop

    INC     $5A8D                   ; counter++
    LDA     $5A8E                   ; \
    STA     $E4                     ;  | $E4/$E5 = loop address
    LDA     $5A8F                   ;  |
    STA     $E5                     ; /
    JMP     .fetch

.end_loop:
    LDA     #$00
    STA     $5A8D                   ; reset loop counter
    JMP     SCRIPT_ADVANCE

.cmd_25:                            ; PRNG mask = $0F
    LDA     #$0F
    STA     $5A92
    JMP     SCRIPT_ADVANCE

.cmd_26:                            ; PRNG mask = $00
    LDA     #$00
    STA     $5A92
    JMP     SCRIPT_ADVANCE

.cmd_23:                            ; action vector → $7A7F
    STOW    $7A7F,$5A93
    JMP     SCRIPT_ADVANCE

.cmd_24:                            ; action vector → $7A91
    STOW    $7A91,$5A93
    JMP     SCRIPT_ADVANCE

.cmd_22:                            ; nop (return from script)
    RTS

.cmd_21:                            ; gosub: jump to saved address
    LDA     $5A90
    STA     $E4
    LDA     $5A91
    STA     $E5
    JMP     .fetch

.cmd_1F:                            ; set loop address = current+1
    JSR     SCRIPT_INC_E4
    LDA     $E4
    STA     $5A8E
    LDA     $E5
    STA     $5A8F
    JMP     .fetch

.cmd_20:                            ; set gosub address = current+1
    JSR     SCRIPT_INC_E4
    LDA     $E4
    STA     $5A90
    LDA     $E5
    STA     $5A91
    JMP     .fetch

.action:
    STA     $E2                     ; save action byte
    JSR     STEP_PRNG
    LDA     $5A18                   ; PRNG output
    AND     $5A92                   ; apply mask
    EOR     $E2                     ; XOR with action byte
    STA     $E1                     ; modified action
    JSR     SCRIPT_INC_E4           ; advance script pointer
    LDY     #$00
    LDA     ($E4),Y                 ; read parameter byte
    STA     $E2
    JSR     SCRIPT_ACTION_INDIRECT  ; → JMP ($5A93)
    JMP     ($F6)                   ; dispatch via action vector
    ORG     $7A77
SCRIPT_INC_E4:
    SUBROUTINE

    INC     $E4
    BEQ     .carry
    RTS
.carry:
    INC     $E5
    RTS

    ORG     $7A4C
SCRIPT_ACTION_INDIRECT:
    JMP     ($5A93)
    ORG     $7A4F
SCRIPT_ADVANCE:
    SUBROUTINE

    JSR     SCRIPT_INC_E4           ; advance script pointer
    LDA     $5AA7                   ; attract_flag
    BEQ     .continue               ; not attract mode → skip input check

    ; Attract mode: check keyboard
    LDA     $C000                   ; keyboard register
    BPL     .check_joy              ; no key → check joystick
    RTS                             ; key pressed → exit

.check_joy:
    LDA     $5A00                   ; joystick flag
    BEQ     .continue               ; no joystick → continue script
    LDX     #$00
    LDA     $C061,X                 ; button 0
    BPL     .btn1                   ; not pressed
    RTS                             ; pressed → exit
.btn1:
    INX
    LDA     $C061,X                 ; button 1
    BPL     .continue               ; not pressed → continue
    RTS                             ; pressed → exit

.continue:
    LSR     $5A8C                   ; shift timing flag
    JMP     SCRIPT_ENGINE.fetch     ; loop back to interpreter
    ORG     $7830
SET_TEXT_WINDOW_UPPER_LEFT_ALL:
    SUBROUTINE

    LDA     #0
    JMP     SET_TEXT_WINDOW_UPPER_LEFT

SET_TEXT_WINDOW_UPPER_LEFT_LOW:
    SUBROUTINE

    LDA     #21

    ; fall through

SET_TEXT_WINDOW_UPPER_LEFT:
    SUBROUTINE

    STA     TEXT_ROW
    LDA     #0
    STA     TEXT_COL
    LDA     #$96        ; ctrl-V (set text window upper left)
    JMP     ROM_COUT1
    ORG     $7E2F
STATUS_BORDER_DATA:
    HEX     7D                      ; $7D: reset to full-screen
    HEX     80 00                   ; row 0, col 0
    HEX     33 3C                   ; top-left corner, left tee
    HEX     34 34 34 34 34 34 34 34 ; horizontal bar (x17)
    HEX     34 34 34 34 34 34 34 34
    HEX     34
    HEX     3D 35                   ; right tee, top-right corner
    HEX     3A 3F                   ; decorative
    HEX     81 12 3E 36 3A 3F      ; row 1, col 18, right edge
    HEX     82 12 3E 36 3A 3F      ; row 2
    HEX     83 12 3E 36 3A 3F      ; row 3
    HEX     84 12 3E 36 3A 3F      ; row 4
    HEX     85 12 3E 36 3A 3F      ; row 5
    HEX     86 12 3E 36 3A 3F      ; row 6
    HEX     87 12 3E 36 3A 3F      ; row 7
    HEX     88 12 3E 36 3A 3F      ; row 8
    HEX     89 12 3E 36 3A 3F      ; row 9
    HEX     8A 12 3E 36            ; row 10
    HEX     39 40                   ; bottom-left corner, left tee
    HEX     38 38 38 38 38 38 38 38 ; horizontal bar (x17)
    HEX     38 38 38 38 38 38 38 38
    HEX     38
    HEX     41 37                   ; right tee, bottom-right corner
    HEX     7F                      ; end of stream
    ORG     $7E97
S_PRESS_SPACE:
    APSTR   "  PRESS SPACE BAR TO CONTINUE   "

S_PRESS_BUTTON:
    APSTR   "  PRESS THE BUTTON TO CONTINUE  "
    ORG     $83A5
FONT_DATA:
    INCLUDE "fontdata.asm"
    ORG     $97A5
STD_FONT_DATA:
    INCLUDE "stdfontdata.asm"
    ORG     $80AE
SCRIPT_TABLE:
    DC.W    $80C6                   ; script 0
    DC.W    $80C7                   ; script 1
    DC.W    $80D7                   ; script 2
    DC.W    $A300                   ; script 3 (attract -- EALDR resident)
    DC.W    $A3C3                   ; script 4
    DC.W    $A3CE                   ; script 5
    DC.W    $A3DE                   ; script 6
    DC.W    $A409                   ; script 7