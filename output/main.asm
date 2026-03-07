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
RWTS_IOB_PTR            EQU     $08     ; ZP pointer to RWTS IOB ($B7E8)
HRCG_INIT               EQU     $92A8   ; HRCG entry/init routine
GAME_ACTION_HANDLER     EQU     $5B2A   ; game action dispatch target
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
MAP_FILL_CHAR           EQU     $7AC1   ; character used to fill the map grid
DEFAULT_CHAR            EQU     $7AC2   ; default entity character ($2C)
BLINK_ALT_CHAR          EQU     $7AC3   ; alternate blink character
ROM_COUT1            EQU     $FDED   ; Apple II ROM COUT1 (character output)
DAT_5a17_pos        EQU     $5A17   ; saved position for room search
PRNG_OUTPUT         EQU     $5A18   ; PRNG output (state >> 1), used for random tests
PRNG_STATE          EQU     $5A19   ; PRNG full state: val = 69*val + $53 (mod 256)
PRNG_TEMP           EQU     $5A1A   ; PRNG temporary for multiplication
NUM_DIGIT           EQU     $5A1B   ; current digit accumulator (ASCII $B0-$B9)
NUM_DIVISOR         EQU     $5A1C   ; 16-bit divisor for decimal conversion (2 bytes)
NUM_LEADING         EQU     $5A1E   ; leading-zero suppress flag (0=suppress, 1=print)
GROUP_COUNT_DELTA   EQU     $5A2C   ; +1 or -1 delta for group count adjustment
is_at_outer_limits  EQU     $0BFA   ; check if position is at room boundary
INPUT_MODE          EQU     $5A00   ; 0 = keyboard, 1 = joystick
TOTAL_MOB_COUNT     EQU     $5A01   ; total mobs across all groups (excl. group 0)
CURRENT_PLAYER      EQU     $5A02   ; current player index (1-based)
LOCATION_FLAG       EQU     $5A55   ; location-change flag
LOCATION_FLAG2      EQU     $5A56   ; secondary location flag
SCENE_NUMBER        EQU     $5A99   ; current scene number
ATTRACT_FLAG        EQU     $5AA7   ; 1 = attract/demo mode, 0 = normal
WORLD_INIT_DATA         EQU     $62B9   ; world initialization data table
RWTS_IOB                EQU     $B7E8   ; RWTS Input/Output Block (14 bytes)
RWTS_ENTRY              EQU     $B7B5   ; RWTS entry point
SAVED_BC            EQU     $5A9A   ; saved $BC/$BD pointer (2 bytes)
SAVED_F8            EQU     $5A9C   ; saved $F8/$F9 pointer (2 bytes)
SAVED_BE            EQU     $5A9E   ; saved $BE/$BF pointer (2 bytes)
SAVED_F4            EQU     $5AA0   ; saved $F4/$F5 pointer (2 bytes)
RNG_LIMIT           EQU     $5A11   ; random\_in\_range temporary (limit/shift count)
RNG_MASK            EQU     $5A12   ; random\_in\_range bit mask
MSG_TABLE_PTR           EQU     $4005   ; message table base (2 bytes)
MSG_LINE_COUNT          EQU     $5A57   ; lines printed so far
ENCOUNTER_RESULT        EQU     $5A1F   ; 0/1/2 from CHECK_ENCOUNTER
COLOCATE_POS            EQU     $5A21   ; saved position for co-location search
COLOCATE_LINK           EQU     $5A20   ; saved next-link (stop condition)
COLOCATE_WRAPPED        EQU     $5A22   ; 1 if wrapped, 2 if ahead
HOSTILE_APP             EQU     $5A23   ; saved appearance for hostility check
HOSTILE_A               EQU     $5A24   ; saved A from first GET_HOSTILITY
HOSTILE_Y               EQU     $5A25   ; saved Y from first GET_HOSTILITY
ADJACENT_THREAT         EQU     $5A26   ; accumulated adjacent threat level
ADJACENT_POS            EQU     $5A27   ; saved position for adjacency check
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
SCRIPT_LOOP_CTR     EQU     $5A8D   ; script loop iteration counter
SCRIPT_LOOP_ADDR    EQU     $5A8E   ; script loop address (2 bytes)
SCRIPT_GOSUB_ADDR   EQU     $5A90   ; script gosub return address (2 bytes)
SCRIPT_PRNG_MASK    EQU     $5A92   ; PRNG mask for action randomization
SCRIPT_ACTION_VEC   EQU     $5A93   ; action handler vector (2 bytes)
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
    LDA     TOTAL_MOB_COUNT         ; zero on first run (no mobs yet)
    BNE     .skip                   ; nonzero = game in progress
    JSR     ATTRACT_SCREEN
.skip:
    ; ... continues to game loop ...
    ORG     $084E
SELECT_INPUT_MODE:
    SUBROUTINE

    LDA     #$38                    ; message $38: input mode prompt
    JSR     DISPLAY_MESSAGE
    LDA     $C061                   ; read paddle button 1
    AND     #$80                    ; isolate bit 7 (pressed state)
    STA     $BA                     ; save initial button state
.clear:
    STA     $C010                   ; clear keyboard strobe
.poll:
    LDX     $C000                   ; read keyboard
    BMI     .key                    ; key pressed → check it
    LDA     $C061                   ; re-read paddle button
    EOR     $BA                     ; compare with initial state
    BMI     .joystick               ; button state changed → joystick
    BPL     .poll                   ; keep polling
.key:
    CPX     #$A0                    ; space bar?
    BEQ     .keyboard               ; yes → keyboard mode
    BNE     .clear                  ; other key → ignore, clear strobe
.keyboard:
    LDA     #$00
    STA     INPUT_MODE              ; 0 = keyboard
    RTS
.joystick:
    LDA     #$01
    STA     INPUT_MODE              ; 1 = joystick
    JSR     SET_CURSOR_ROW21
    LDA     #$2F                    ; message $2F: joystick confirmation
    JMP     DISPLAY_MESSAGE
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
    JSR     SCENE_SETUP
    LDA     #$00
    STA     LOCATION_FLAG           ; clear location-change flag
    JSR     SET_CURSOR_ROW21
    LDA     #$26                    ; scene number $26 (38 decimal)
    JMP     SCENE_LOOP              ; tail-call
    ORG     $0A17
SCENE_SETUP:
    SUBROUTINE

    LDA     $5A29                   ; character/scene index
    JSR     GET_CHAR_RECORD         ; index → $BE/$BF = char record
    LDY     #$03
    LDA     ($BE),Y                 ; byte 3: min position (packed)
    JSR     POS_TO_COLROW           ; → A=min_col, Y=min_row
    STA     $5A51                   ; min_col
    STY     $5A53                   ; min_row
    LDY     #$04
    LDA     ($BE),Y                 ; byte 4: max position (packed)
    JSR     POS_TO_COLROW           ; → A=max_col, Y=max_row
    STA     $5A52                   ; max_col
    STY     $5A54                   ; max_row
    INC     $5A51                   ; min_col++ (exclusive border)
    INC     $5A53                   ; min_row++
    CLC
    LDA     $5A52                   ; \
    SBC     $5A51                   ;  | col_range = max_col - min_col
    JSR     RANDOM_IN_RANGE         ;  | random column offset
    CLC                             ;  |
    ADC     $5A51                   ;  | col = min_col + offset
    STA     FONT_COL                ; / set font column
    CLC
    LDA     $5A54                   ; \
    SBC     $5A53                   ;  | row_range = max_row - min_row
    JSR     RANDOM_IN_RANGE         ;  | random row offset
    CLC                             ;  |
    ADC     $5A53                   ; / row = min_row + offset
    TAY                             ; Y = row
    LDA     FONT_COL                ; A = col
    JSR     COLROW_TO_POS           ; → A = linear position
    LDY     #$03
    STA     ($F4),Y                 ; store position in record byte 3
    LDA     $F4                     ; \
    STA     $BC                     ;  | $BC/$BD = $F4/$F5
    LDA     $F5                     ;  |
    STA     $BD                     ; /
    LDA     #$00
    STA     $5A28                   ; clear player index
    JSR     REORDER_CHAR            ; reorder character in linked list
    LDY     #$0D
    LDA     #$00                    ; \
    STA     ($F4),Y                 ;  | clear bytes 13-14 of record
    INY                             ;  |
    STA     ($F4),Y                 ; /
    JSR     CLAMP_CHAR_FIELD        ; ensure byte 6 >= byte 5 minimum
    LDA     $5A02                   ; current player index
    CMP     $5A29                   ; compare with scene index
    BNE     .done                   ; not current player → skip
    LDY     #$03
    LDA     ($F4),Y                 ; load position from record
    JSR     DRAW_CHAR_AT_POS        ; draw character at position
.done:
    RTS
    ORG     $0F84
REORDER_CHAR:
    SUBROUTINE

; --- Phase 1: unlink character $5A28 from its current chain ---
    LDA     $5A28                   ; source character index
    JSR     GET_CHAR_RECORD         ; $BE/$BF = record pointer
    JSR     DECR_GROUP_COUNT        ; source group lost a member
.walk1:
    LDY     #$02                    ; \
    LDA     ($BE),Y                 ;  | $5A2A = byte 2 of current record
    STA     $5A2A                   ; /  (the "next" link we're removing)
    JSR     GET_MOB_DATA            ; $BA/$BB = resolve link; $BC/$BD = mob data
    LDA     $BA                     ; \
    CMP     $BC                     ;  | compare $BA/$BB with $BC/$BD
    BNE     .advance1               ;  | if different, keep walking
    LDA     $BB                     ;  |
    CMP     $BD                     ; /
    BNE     .advance1
    ; Found predecessor: $BC/$BD points to the node being removed
    LDY     #$02
    LDA     $5A2A                   ; \  if removed node's link == $5A03,
    CMP     $5A03                   ;  |   update $5A03 to new link
    BNE     .patch1                 ; /
    LDA     ($BC),Y                 ; \
    STA     $5A03                   ; /  $5A03 = ($BC)[2] (successor's link)
.patch1:
    LDA     ($BC),Y                 ; \  predecessor.byte2 = removed.byte2
    STA     ($BE),Y                 ; /  (skip over removed node)
    JMP     .phase2
.advance1:
    LDA     $BA                     ; \  $BE/$BF = $BA/$BB
    STA     $BE                     ;  | (advance to next record)
    LDA     $BB                     ;  |
    STA     $BF                     ; /
    JMP     .walk1

; --- Phase 2: re-insert at correct sorted position in $5A29's chain ---
.phase2:
    LDY     #$0B                    ; \
    LDA     ($BC),Y                 ;  | $5A2B = byte 11 of removed node
    AND     #$1F                    ;  |   (level, 5-bit)
    STA     $5A2B                   ; /
    LDA     $5A29                   ; destination character index
    JSR     GET_CHAR_RECORD         ; $BE/$BF = dest record pointer
    JSR     INCR_GROUP_COUNT        ; dest group gained a member
.walk2:
    LDY     #$02                    ; \
    LDA     ($BE),Y                 ;  | check byte 2 of current record
    CMP     #$00                    ;  | if zero (end of chain) -> insert here
    BEQ     .insert                 ; /
    JSR     GET_MOB_DATA            ; resolve link
    LDA     $5A29                   ; \
    BEQ     .random                 ; /  if dest index = 0, use random decision
    LDY     #$0B                    ; \
    LDA     ($BA),Y                 ;  | compare candidate's level
    AND     #$1F                    ;  | with removed node's level
    CMP     $5A2B                   ;  |
    BPL     .advance2               ; /  if >= , keep walking (insert later)
.insert:
    LDY     #$02                    ; \
    LDA     ($BE),Y                 ;  | ($BC)[2] = ($BE)[2]  (link successor)
    STA     ($BC),Y                 ;  |
    LDA     $5A2A                   ;  | ($BE)[2] = saved link (insert node)
    STA     ($BE),Y                 ; /
    LDY     #$04                    ; \
    LDA     ($BC),Y                 ;  | if byte 4 of ($BC) >= $15, done
    CMP     #$15                    ;  |
    BCC     .adjust                 ;  |
    RTS                             ; /
.adjust:
    LDA     #$00                    ; \
    CMP     $5A29                   ;  | if inserted into index 0's slot,
    BNE     .chk28                  ;  |   decrement TOTAL_MOB_COUNT
    DEC     TOTAL_MOB_COUNT         ; /
.chk28:
    CMP     $5A28                   ; \  if removed from index 0's slot,
    BNE     .done                   ;  |   increment TOTAL_MOB_COUNT
    INC     TOTAL_MOB_COUNT         ; /
.done:
    RTS
.advance2:
    LDA     $BA                     ; \  $BE/$BF = $BA/$BB
    STA     $BE                     ;  | (advance to next record)
    LDA     $BB                     ;  |
    STA     $BF                     ; /
    JMP     .walk2
.random:
    JSR     STEP_PRNG               ; \  random decision
    LDA     PRNG_OUTPUT             ;  | if PRNG < 1 (i.e., == 0) -> insert
    CMP     #$01                    ;  |
    BMI     .insert                 ;  | else keep walking
    BPL     .advance2               ; /
    ORG     $102F
DECR_GROUP_COUNT:
    SUBROUTINE

    LDA     #$FF                    ; delta = -1
    BNE     .apply                  ; always taken
INCR_GROUP_COUNT:
    LDA     #$01                    ; delta = +1
.apply:
    STA     GROUP_COUNT_DELTA       ; save delta for later
    LDA     $BE                     ; \
    CMP     #$00                    ;  | bail if $BE/$BF is null
    BNE     .not_null               ;  |
    RTS                             ; /
.not_null:
    LDY     #$04                    ; \
    LDA     ($BC),Y                 ;  | bail if byte 4 of ($BC) >= $15
    CMP     #$15                    ;  |   ($15+ = inactive/dead)
    BCC     .ok                     ;  |
    RTS                             ; /
.ok:
    LDY     #$08                    ; \
    LDA     ($BE),Y                 ;  | group count (low nibble) += delta
    CLC                             ;  |
    ADC     GROUP_COUNT_DELTA       ;  |
    STA     ($BE),Y                 ; /
    RTS
    ORG     $1053
GET_CHAR_RECORD:
    SUBROUTINE

    TAX                             ; X = index (loop counter)
    LDA     #$00                    ; \
    STA     $BE                     ;  | $BE/$BF = $4000 (base)
    LDA     #$40                    ;  |
    STA     $BF                     ; /
.loop:
    DEX
    BPL     .advance                ; more records to skip
    RTS                             ; done: $BE/$BF points to record
.advance:
    CLC                             ; \
    LDA     $BE                     ;  | $BE/$BF += 9
    ADC     #$09                    ;  | (9 bytes per record)
    STA     $BE                     ;  |
    LDA     $BF                     ;  |
    ADC     #$00                    ;  |
    STA     $BF                     ; /
    BNE     .loop                   ; always taken ($BF >= $40)
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
    ORG     $0C51
INIT_MOB_COUNT:
    SUBROUTINE

    LDA     #$00                    ; \
    STA     TOTAL_MOB_COUNT         ; / clear total
    LDA     #$09                    ; \ $FA/$FB = $4009 (record 1)
    STA     $FA                     ;  |
    LDA     #$40                    ;  |
    STA     $FB                     ; /
.loop:
    LDY     #$01
    LDA     ($FA),Y                 ; byte 1 of record
    CMP     #$FF                    ; $FF = end sentinel
    BNE     .count
    RTS
.count:
    LDY     #$08
    LDA     ($FA),Y                 ; byte 8 = group member count
    CLC
    ADC     TOTAL_MOB_COUNT         ; accumulate
    STA     TOTAL_MOB_COUNT
    LDA     #$09                    ; \ advance $FA by 9 (next record)
    ADC     $FA                     ;  |
    STA     $FA                     ;  |
    BCC     .loop                   ;  |
    INC     $FB                     ;  |
    BCS     .loop                   ; / always taken
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
    ORG     $0A93
CLAMP_CHAR_FIELD:
    SUBROUTINE

    LDY     #$05
    LDA     ($F4),Y                 ; byte 5 of record
    AND     #$1F                    ; low 5 bits = minimum
    STA     $BA
    INY
    LDA     ($F4),Y                 ; byte 6 of record
    AND     #$3F                    ; low 6 bits = current value
    CMP     $BA
    BCC     .clamp                  ; current < minimum → clamp
    RTS                             ; current >= minimum → done
.clamp:
    LDA     ($F4),Y                 ; reload byte 6
    AND     #$C0                    ; preserve top 2 bits
    ORA     $BA                     ; set low bits to minimum
    STA     ($F4),Y
    RTS
    ORG     $0B62
FIND_ENTITY_AT_POS:
    SUBROUTINE

    STA     DAT_5a17_pos            ; save target position
    LDA     $FB                     ; \ patch base address into
    STA     .load3+2                ;  | player search (high byte)
    STA     .load2+2                ;  | mob search (high byte)
    LDA     $FA                     ;  |
    STA     .load3+1                ;  | player search (low byte)
    STA     .load2+1                ; / mob search (low byte)
    JMP     .mob_search

    ; --- Player character search ---
.player_search:
    LDX     #$06                    ; copy bytes 6-7 of record
.load3:
    LDA     $0B7B,X                 ; (self-modified base address)
    STA     .load4-5,X              ; patch .load4 operand (+6→low, +7→high)
    INX
    CPX     #$08
    BNE     .load3
.load4:
    LDY     $0B86                   ; (self-modified: read position from table)
    CPY     #$FF
    BNE     .check_player
    JMP     is_at_outer_limits      ; $FF = end of table
.check_player:
    CPY     DAT_5a17_pos            ; matches target?
    BEQ     .found_player
    INC     .load4+1                ; \
    BNE     .no_carry1              ;  |
    INC     .load4+2                ;  | advance address by 3
.no_carry1:                         ;  | (3-byte table entries)
    INC     .load4+1                ;  |
    BNE     .no_carry2              ;  |
    INC     .load4+2                ;  |
.no_carry2:                         ;  |
    INC     .load4+1                ;  |
    BNE     .load4                  ;  |
    INC     .load4+2                ; /
    JMP     .load4
.found_player:
    LDA     .load4+1                ; \ $BE/$BF = table entry address
    STA     $BE                     ;  |
    LDA     .load4+2                ;  |
    STA     $BF                     ; /
    RTS

    ; --- Mob linked-list search ---
.mob_search:
    LDX     #$02                    ; byte 2 = mob index
.load2:
    LDA     $0BBD,X                 ; (self-modified base address)
    CMP     #$00
    BEQ     .player_search          ; zero → no more mobs, try players
    JSR     .get_mob                ; get mob data → patch .load1
    LDX     #$03                    ; byte 3 = position
.load1:
    LDY     $0BC9,X                 ; (self-modified: read from mob record)
    CPY     DAT_5a17_pos
    BEQ     .found_mob              ; position matches!
    LDA     .load1+1                ; \ copy mob link address
    STA     .load2+1                ;  | back to .load2 for next iteration
    LDA     .load1+2                ;  |
    STA     .load2+2                ; /
    JMP     .mob_search
.found_mob:
    LDA     #$80                    ; \ set bit 7 = mob flag
    ORA     .load1+2                ;  |
    STA     $BF                     ;  |
    LDA     .load1+1                ;  |
    STA     $BE                     ; / $BE/$BF = mob pointer | $80
    RTS

    ; --- Helper: get mob data and patch .load1 ---
.get_mob:
    JSR     GET_MOB_DATA            ; A = mob index → $BA/$BB = data ptr
    LDA     $BA                     ; \
    STA     .load1+1                ;  | patch .load1 operand
    LDA     $BB                     ;  |
    STA     .load1+2                ; /
    RTS
    ORG     $0C7E
GET_ENTITY_FONTCHAR:
    SUBROUTINE

    LDA     #$01
    STA     FONT_CHARSET            ; custom font
    LDA     #$00
    CMP     $BF                     ; high byte of pointer
    BNE     .has_entity             ; non-zero → entity exists
    CMP     $BE                     ; low byte
    BNE     .low_only               ; low ≠ 0 → partial pointer
.empty:
    LDA     BLINK_ALT_CHAR          ; \
    STA     FONT_CHARNUM            ;  | empty cell → blink char
    RTS                             ; /
.low_only:
    LDA     DEFAULT_CHAR            ; \
    STA     FONT_CHARNUM            ;  | $BE≠0, $BF=0 → default char
    RTS                             ; /
.has_entity:
    LDA     $BF
    CMP     #$80                    ; bit 7 set?
    BPL     .mob                    ; yes → mob record
    ; --- character record ---
    LDY     #$01
    LDA     ($BE),Y                 ; byte 1 of character record
    AND     #$C0                    ; top 2 bits
    CMP     #$C0                    ; both set?
    BEQ     .both_bits              ; → detailed check
    CMP     #$40
    BEQ     .bit6                   ; bit 6 only → char $1C
    BPL     .empty                  ; bit 7 only → blink alt char
    LDA     #$1B                    ; neither bit → char $1B
    BNE     .store
.bit6:
    LDA     #$1C
.store:
    STA     FONT_CHARNUM
    RTS
.both_bits:
    LDA     ($BE),Y                 ; reload byte 1
    CMP     #$FE
    BEQ     .check_byte2            ; $FE → check byte 2
    CMP     #$D5
    BMI     .lt_d5
    LDA     #$1D                    ; >= $D5 → char $1D
    JMP     .store
.lt_d5:
    CMP     #$D2
    BMI     .lt_d2
    LDA     #$18                    ; $D2-$D4 → char $18
    JMP     .store
.lt_d2:
    LDA     #$1A                    ; < $D2 → char $1A
    JMP     .store
.check_byte2:
    LDY     #$02
    LDA     ($BE),Y                 ; byte 2
    AND     #$1F                    ; low 5 bits
    BEQ     .empty                  ; zero → blink alt char
    JMP     .store                  ; non-zero → use as charnum
.mob:
    LDA     $BE                     ; \
    STA     $BA                     ;  | $BA/$BB = $BE/$BF with bit 7 cleared
    LDA     $BF                     ;  |
    AND     #$7F                    ;  |
    STA     $BB                     ; /
    LDY     #$04
    LDA     ($BA),Y                 ; byte 4 = appearance
    JSR     APPEARANCE_TO_FONTCHAR
    JMP     .store
    ORG     $0D8A
PRINT_MOB_NAME:
    SUBROUTINE

    LDY     #$00                    ; \
    LDA     ($F8),Y                 ;  | $BC/$BD = bytes 0-1 of ($F8)
    STA     $BC                     ;  | (name string pointer)
    INY                             ;  |
    LDA     ($F8),Y                 ;  |
    STA     $BD                     ; /
    JMP     $7705                   ; center and print on row 23
    ORG     $0D98
COLROW_TO_POS:
    SUBROUTINE

    CLC
.loop:
    DEY                         ; row--
    BPL     .add                ; still >= 0 → add another 20
    RTS                         ; Y exhausted, A = result
.add:
    ADC     #$14                ; A += 20
    BCC     .loop               ; no overflow → continue
                                ; carry set → return (overflow)
    ORG     $0DA1
NUM_TO_DECIMAL:
    SUBROUTINE

    LDY     #$00                    ; output index = 0
    STY     NUM_LEADING             ; leading-zero flag = 0 (suppress)
NUM_TO_DECIMAL_CONT:
    LDA     #$10                    ; \  divisor = $2710 = 10000
    STA     NUM_DIVISOR             ;  |
    LDA     #$27                    ;  |
    STA     NUM_DIVISOR+1           ; /
    JSR     .extract_digit          ; ten-thousands digit
    LDA     #$E8                    ; \  divisor = $03E8 = 1000
    STA     NUM_DIVISOR             ;  |
    LDA     #$03                    ;  |
    STA     NUM_DIVISOR+1           ; /
    JSR     .extract_digit          ; thousands digit
    LDA     #$64                    ; \  divisor = $0064 = 100
    STA     NUM_DIVISOR             ;  |
    LDA     #$00                    ;  |
    STA     NUM_DIVISOR+1           ; /
    JSR     .extract_digit          ; hundreds digit
    LDA     #$0A                    ; \  divisor = $000A = 10
    STA     NUM_DIVISOR             ; /  (high byte already 0)
    JSR     .extract_digit          ; tens digit
    LDA     #$01                    ; \  divisor = $0001 = 1
    STA     NUM_DIVISOR             ;  |
    STA     NUM_LEADING             ; /  force output (no suppress)
    JSR     .extract_digit          ; ones digit
    RTS

; --- Digit extraction helper ($0DE1) ---
; Divides $BC/$BD by $5A1C/$5A1D via repeated subtraction.
; Stores ASCII digit at ($BA),Y. Suppresses leading zeros.
.extract_digit:
    LDA     #$B0                    ; digit = '0' (high ASCII)
    STA     NUM_DIGIT
.cmp_loop:
    LDX     #$01                    ; start comparing high byte
.cmp_x:
    LDA     $BC,X                   ; \
    CMP     NUM_DIVISOR,X           ;  | compare $BC/$BD with divisor
    BCC     .output                 ;  | if less, done (digit found)
    BNE     .subtract               ; /  if greater, subtract
    DEX                             ; \  high bytes equal: check low
    BNE     .subtract               ; /  (if X was 1, now 0 -> recompare)
    JMP     .cmp_x                  ;    compare low byte (X=0)
.subtract:
    SEC                             ; \
    LDA     $BC                     ;  | $BC/$BD -= divisor
    SBC     NUM_DIVISOR             ;  |
    STA     $BC                     ;  |
    LDA     $BD                     ;  |
    SBC     NUM_DIVISOR+1           ;  |
    STA     $BD                     ; /
    INC     NUM_DIGIT               ; digit++
    JMP     .cmp_loop               ; try again (reset X=1)
.output:
    LDA     NUM_DIGIT               ; \
    CMP     #$B0                    ;  | if digit is '0'
    BNE     .store                  ;  |   and leading-zero suppress active
    LDA     NUM_LEADING             ;  |   skip output
    CMP     #$01                    ;  |
    BNE     .skip                   ; /
    LDA     #$B0                    ; (reload '0' for final digit)
.store:
    STA     ($BA),Y                 ; store digit at output buffer
    LDA     #$01                    ; \  clear leading-zero suppress
    STA     NUM_LEADING             ; /  (first nonzero digit seen)
.skip:
    INY                             ; advance output index
    RTS
    ORG     $0E25
CHECK_ENCOUNTER:
    SUBROUTINE

    JSR     FIND_ENTITY_AT_POS      ; look up char → $BE/$BF
    LDA     $BF
    CMP     #$00
    BEQ     .none                   ; null pointer → return 0
    CMP     #$80
    BMI     .none                   ; not a mob (bit 7 clear) → return 0
    AND     #$7F                    ; clear mob flag
    STA     $F5                     ; \ $F4/$F5 = mob data pointer
    LDA     $BE                     ;  |
    STA     $F4                     ; /
.search:
    LDA     $F4                     ; \ $BC/$BD = current mob pointer
    STA     $BC                     ;  |
    LDA     $F5                     ;  |
    STA     $BD                     ; /
    JSR     FIND_MOB_AT_SAME_POS    ; find next mob at same position
    CMP     #$01
    BMI     .none                   ; 0 = no co-located mob → return 0
    BEQ     .friendly               ; 1 = found (wrapped) → return 1
    LDY     #$06                    ; result >= 2: found ahead
    LDA     ($F4),Y                 ; byte 6 of found mob
    AND     #$3F                    ; bits 5-0
    CMP     #$03                    ; active mob type?
    BCC     .search                 ; no → skip, keep searching
    JSR     CHECK_HOSTILE           ; compare factions
    CMP     #$00
    BEQ     .search                 ; same faction → skip
    LDA     #$02                    ; enemy found → return 2
    STA     ENCOUNTER_RESULT
    RTS
.none:
    LDA     #$00
    BEQ     .store
.friendly:
    LDA     #$01
.store:
    STA     ENCOUNTER_RESULT
    RTS
    ORG     $0E6C
FIND_MOB_AT_SAME_POS:
    SUBROUTINE

    LDY     #$03
    LDA     ($F4),Y                 ; byte 3 = position of current mob
    STA     COLOCATE_POS
    DEY
    LDA     ($F4),Y                 ; byte 2 = next link of current mob
    STA     COLOCATE_LINK
    STY     COLOCATE_WRAPPED        ; $5A22 = 2 (found ahead)
.check_link:
    CMP     #$00
    BNE     .resolve                ; has next → follow it
    LDY     #$01
    STY     COLOCATE_WRAPPED        ; wrapped to start
    INY                             ; Y = 2
    LDA     ($FA),Y                 ; byte 2 of group head = first mob
.resolve:
    JSR     GET_MOB_DATA            ; A = mob index → $BA/$BB
    LDY     #$02
    LDA     ($BA),Y                 ; byte 2 of resolved mob
    CMP     COLOCATE_LINK           ; same next-link as original?
    BNE     .not_self
    LDA     #$00                    ; full circle → not found
    RTS
.not_self:
    INY                             ; Y = 3
    LDA     ($BA),Y                 ; byte 3 = position
    CMP     COLOCATE_POS            ; same position as original?
    BEQ     .found
    DEY                             ; Y = 2
    LDA     ($BA),Y                 ; follow next link
    JMP     .check_link
.found:
    LDA     $BA                     ; \ update $F4/$F5 to found mob
    STA     $F4                     ;  |
    LDA     $BB                     ;  |
    STA     $F5                     ; /
    LDA     COLOCATE_WRAPPED        ; return 1 (wrapped) or 2 (ahead)
    RTS
    ORG     $0EB1
CHECK_HOSTILE:
    SUBROUTINE

    LDY     #$04
    LDA     ($F4),Y                 ; byte 4 of found mob (appearance)
    STA     HOSTILE_APP
    LDA     ($BC),Y                 ; byte 4 of original mob (appearance)
    JSR     APPEARANCE_TO_FONTCHAR  ; → A=remainder, Y=group
    JSR     GET_HOSTILITY           ; → Y=0 (friendly) or 1 (hostile)
    STA     HOSTILE_A
    STY     HOSTILE_Y
    LDA     HOSTILE_APP             ; appearance of found mob
    JSR     APPEARANCE_TO_FONTCHAR
    JSR     GET_HOSTILITY
    CPY     HOSTILE_Y               ; compare hostilities
    BNE     .different              ; different sides → hostile
    CPY     #$00
    BEQ     .same                   ; both friendly → same side
    CMP     HOSTILE_A               ; both hostile: compare sub-factions
    BNE     .different              ; different → hostile to each other
.same:
    LDA     #$00
    RTS
.different:
    LDA     #$01
    RTS
    ORG     $0EE3
GET_HOSTILITY:
    SUBROUTINE

    CPY     #$03                    ; factions 0-2 = friendly
    BCC     .friendly
    CPY     #$07                    ; faction 7 = friendly
    BEQ     .friendly
    LDY     #$01                    ; factions 3-6 = hostile
    RTS
.friendly:
    LDY     #$00
    RTS
    ORG     $0EF1
CHECK_ADJACENT_THREATS:
    SUBROUTINE

    STA     ADJACENT_POS            ; save target position
    LDA     #$00
    STA     ADJACENT_THREAT         ; clear threat accumulator
    LDA     $F8                     ; \ $BC/$BD = character record pointer
    STA     $BC                     ;  |
    LDA     $F9                     ;  |
    STA     $BD                     ; /
    LDA     ADJACENT_POS            ; reload position
    BEQ     .skip_left              ; position 0 → no left neighbor
    SEC
    SBC     #$01                    ; position - 1
    JSR     SUM_HOSTILE_AT_POS      ; check left
.skip_left:
    LDA     ADJACENT_POS
    CMP     #$C7                    ; position 199?
    BEQ     .skip_right             ; → no right neighbor
    CLC
    ADC     #$01                    ; position + 1
    JSR     SUM_HOSTILE_AT_POS      ; check right
.skip_right:
    LDA     ADJACENT_POS
    BMI     .do_up                  ; >= 128 → always has up neighbor
    CMP     #$14                    ; < 20?
    BMI     .skip_up                ; → no up neighbor
.do_up:
    SEC
    SBC     #$14                    ; position - 20
    JSR     SUM_HOSTILE_AT_POS      ; check up
.skip_up:
    LDA     ADJACENT_POS
    BPL     .do_down                ; < 128 → always has down neighbor
    CMP     #$B4                    ; >= 180?
    BPL     .skip_down              ; → no down neighbor
.do_down:
    CLC
    ADC     #$14                    ; position + 20
    JSR     SUM_HOSTILE_AT_POS      ; check down
.skip_down:
    LDY     #$05
    LDA     ($F8),Y                 ; byte 5 of character record
    ROR                             ; \ bits 4-1 → defense value
    AND     #$0F                    ; /
    CMP     ADJACENT_THREAT         ; compare with threat total
    BPL     .safe                   ; defense >= threat → safe
    LDA     #$00
    RTS                             ; return 0 = overwhelmed
.safe:
    LDA     #$01
    RTS                             ; return 1 = safe
    ORG     $0F49
SUM_HOSTILE_AT_POS:
    SUBROUTINE

    JSR     FIND_ENTITY_AT_POS      ; A = position → $BE/$BF
    LDA     $BF
    BEQ     .done                   ; null → nothing here
    CMP     #$80
    BMI     .done                   ; not a mob → skip
    AND     #$7F                    ; clear mob flag
    STA     $F5                     ; \ $F4/$F5 = mob data pointer
    LDA     $BE                     ;  |
    STA     $F4                     ; /
.check_mob:
    JSR     CHECK_HOSTILE           ; is this mob hostile to ($BC)?
    CMP     #$00
    BEQ     .next                   ; not hostile → skip
    LDY     #$0F
    LDA     ($F4),Y                 ; byte $0F of mob
    AND     #$04                    ; bit 2 = combat engaged flag
    BNE     .next                   ; already in combat → skip
    LDY     #$05
    LDA     ($F4),Y                 ; byte 5 of mob
    AND     #$1F                    ; bits 4-0 = strength
    CLC
    ADC     ADJACENT_THREAT         ; accumulate threat
    BPL     .store
    LDA     #$7F                    ; clamp to 127
.store:
    STA     ADJACENT_THREAT
.next:
    JSR     FIND_MOB_AT_SAME_POS    ; find next mob at same position
    CMP     #$02
    BEQ     .check_mob              ; more mobs → check them too
.done:
    RTS
    ORG     $1156
DRAW_CHAR_AT_POS:
    SUBROUTINE

    JSR     POS_TO_COLROW           ; A=pos → A=col, Y=row
    STA     FONT_COL                ; set font column
    STY     FONT_ROW                ; set font row
    JSR     COLROW_TO_POS           ; re-linearize (A = col + row*20)
    JSR     FIND_ENTITY_AT_POS      ; look up entity at position → $BE
    JSR     GET_ENTITY_FONTCHAR     ; determine font char from entity data
    JMP     RENDER_FONT_CHAR        ; render the font character
    ORG     $1317
RANDOM_IN_RANGE:
    SUBROUTINE

    STA     RNG_LIMIT               ; save range limit
    CMP     #$00
    BNE     .nonzero
    RTS                             ; range=0 → return 0

.nonzero:
    CMP     #$02                    ; \
    BPL     .ge2                    ;  |
    LDY     #$06                    ;  | range 1: mask=$40, shift=6
    LDA     #$40                    ;  |
    BNE     .have_mask              ; /
.ge2:
    CMP     #$04                    ; \
    BPL     .ge4                    ;  |
    LDY     #$05                    ;  | range 2-3: mask=$60, shift=5
    LDA     #$60                    ;  |
    BNE     .have_mask              ; /
.ge4:
    CMP     #$08                    ; \
    BPL     .ge8                    ;  |
    LDY     #$04                    ;  | range 4-7: mask=$70, shift=4
    LDA     #$70                    ;  |
    BNE     .have_mask              ; /
.ge8:
    CMP     #$10                    ; \
    BPL     .ge16                   ;  |
    LDY     #$03                    ;  | range 8-15: mask=$78, shift=3
    LDA     #$78                    ;  |
    BNE     .have_mask              ; /
.ge16:
    CMP     #$20                    ; \
    BPL     .ge32                   ;  |
    LDY     #$02                    ;  | range 16-31: mask=$7C, shift=2
    LDA     #$7C                    ;  |
    BNE     .have_mask              ; /
.ge32:
    CMP     #$40                    ; \
    BPL     .ge64                   ;  |
    LDY     #$01                    ;  | range 32-63: mask=$7E, shift=1
    LDA     #$7E                    ;  |
    BNE     .have_mask              ; /
.ge64:
    LDY     #$00                    ; range 64-127: mask=$7F, shift=0
    LDA     #$7F

.have_mask:
    STA     RNG_MASK                ; save bit mask
    LDA     RNG_LIMIT               ; reload range limit
    STY     RNG_LIMIT               ; save shift count in RNG_LIMIT
.shift_loop:
    DEY                             ; \
    BMI     .shifted                ;  | shift limit left by (shift count)
    CLC                             ;  | positions so it aligns with the
    ROL     A                       ;  | mask bits
    BNE     .shift_loop             ; /
.shifted:
    LDY     RNG_LIMIT               ; Y = shift count
    STA     RNG_LIMIT               ; save shifted limit

.sample:
    JSR     STEP_PRNG               ; get next random byte
    LDA     PRNG_OUTPUT
    AND     RNG_MASK                ; mask to relevant bits
    CMP     RNG_LIMIT               ; compare with shifted limit
    BEQ     .accept                 ; equal → accept
    BPL     .sample                 ; greater → reject, retry

.accept:
    DEY                             ; \
    BPL     .shift_right            ;  | shift result right by (shift count)
    RTS                             ;  | to recover the final value
.shift_right:
    CLC                             ;  |
    ROR     A                       ;  |
    BCC     .accept                 ; / (always taken: masked bit is 0)
    ORG     $12FA
FIRST_GROUP_MEMBER:
    SUBROUTINE

    LDY     #$02                    ; \
    LDA     ($FA),Y                 ;  | check byte 2 of group head ($FA)
    BNE     .resolve                ; /  if nonzero, follow it
NEXT_GROUP_MEMBER:
    LDY     #$02                    ; \
    LDA     ($F4),Y                 ;  | check byte 2 of cursor ($F4)
    BNE     .resolve                ; /  if nonzero, follow it
    STA     $F4                     ; \  end of chain:
    STA     $F5                     ; /  null out $F4/$F5
    RTS
.resolve:
    JSR     GET_MOB_DATA            ; resolve link -> $BA/$BB
    LDA     $BA                     ; \
    STA     $F4                     ;  | $F4/$F5 = $BA/$BB
    LDA     $BB                     ;  | (advance cursor to next record)
    STA     $F5                     ; /
    RTS
    ORG     $743B
FILL_MAP:
    SUBROUTINE

    LDA     #$13                    ; \ start at column 19, row 9
    STA     FONT_COL                ;  | (bottom-right corner)
    LDA     #$09                    ;  |
    STA     FONT_ROW                ; /
    LDA     MAP_FILL_CHAR           ; fill character (default $25)
    STA     FONT_CHARNUM
    LDA     #$01                    ; charset 1 (custom font)
    STA     FONT_CHARSET
    JSR     RENDER_FONT_CHAR        ; render glyph once (builds control string)
.loop:
    DEC     FONT_COL                ; next column left
    BPL     .draw                   ; still >= 0 → draw
    LDA     #$13                    ; \ wrap to column 19
    STA     FONT_COL                ; /
    DEC     FONT_ROW                ; next row up
    BPL     .draw                   ; still >= 0 → draw
    RTS                             ; all 200 positions filled
.draw:
    JSR     FONT_POS_TO_TEXT_POS    ; set text cursor to font position
    JSR     PRINT_STRING            ; re-print the same glyph string
    JMP     .loop
    ORG     $7489
RENDER_FONT_CHAR:
    SUBROUTINE

    JSR     FONT_POS_TO_TEXT_POS    ; set TEXT_COL/TEXT_ROW from font pos
    LDX     #$B1                    ; base charset page
    LDA     FONT_CHARSET
    CMP     #$02
    BNE     .charset_ok
    INX                             ; charset 2 → page $B3
    INX
.charset_ok:
    STX     CHAR_CHARSET            ; patch charset in control string
    LDA     FONT_CHARNUM
.check_range:
    CMP     #$18                    ; fits in current charset page?
    BCC     .compute_glyphs         ; yes → compute glyph indices
    INX                             ; no → next charset page
    STX     CHAR_CHARSET
    SEC
    SBC     #$18                    ; charnum -= 24
    JMP     .check_range
.compute_glyphs:
    ASL                             ; charnum * 4
    ASL
    CLC
    ADC     #$20                    ; + $20 = base glyph code
    TAY
    STY     CHAR_UPPER_LEFT
    INY
    STY     CHAR_UPPER_RIGHT
    INY
    STY     CHAR_LOWER_LEFT
    INY
    STY     CHAR_LOWER_RIGHT
    LDA     #<s_PRINT_FONT_CHAR    ; \
    STA     PRINT_STRING_ADDR       ;  | $BC/$BD → control string
    LDA     #>s_PRINT_FONT_CHAR    ;  |
    STA     PRINT_STRING_ADDR+1     ; /
    JMP     PRINT_STRING            ; output the 2×2 character
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
    ORG     $5DB0
PLOT_CHAR:
    SUBROUTINE

    STA     FONT_CHARNUM
    STX     TEXT_COL
    STY     TEXT_ROW
    LDA     #$01
    STA     FONT_CHARSET
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
    ORG     $5B00
INIT_GAME_STATE:
    SUBROUTINE

    JSR     $5C6D                   ; set up game display / UI
    LDA     #<GAME_ACTION_HANDLER   ; \ $F6/$F7 = game action handler
    STA     $F6                     ;  |
    LDA     #>GAME_ACTION_HANDLER   ;  |
    STA     $F7                     ; /
    LDA     #$00
    STA     $5A00                   ; clear game state flag
    LDX     #$B1                    ; LDA (zp),Y opcode
    STX     $80A6                   ; patch character renderer
    LDX     #$06                    ; script index 6 (opening)
    JSR     SCRIPT_ENGINE           ; run opening script
    LDA     #$4C                    ; \ patch $7A49 to JMP $7A4F
    STA     $7A49                   ;  | (bypass indirect handler
    LDA     #$4F                    ;  |  after init script completes)
    STA     $7A4A                   ;  |
    LDA     #$7A                    ;  |
    STA     $7A4B                   ; /
    RTS

    ORG     $62E5
INIT_WORLD:
    SUBROUTINE

    LDX     #>WORLD_INIT_DATA       ; \ X/Y = pointer to init data
    LDY     #<WORLD_INIT_DATA       ; /
    JMP     $5F19                   ; initialize world from data table

    ORG     $6B94
INIT_STUB2:
    RTS
    ORG     $6C2E
INIT_DISK_IOB:
    SUBROUTINE

    LDA     #>RWTS_IOB              ; \ set RWTS IOB pointer
    LDY     #<RWTS_IOB              ;  | $08/$09 = $B7E8
    STA     RWTS_IOB_PTR+1          ;  |
    STY     RWTS_IOB_PTR            ; /
    RTS
    ORG     $6C37
SCENE_LOOP:
    SUBROUTINE

    STA     SCENE_NUMBER            ; store scene number
    LDA     #$14
    STA     BLINK_COL               ; disable blink cursor

    JSR     SAVE_ZP_POINTERS

    JSR     STEP_PRNG
    LDA     PRNG_OUTPUT             ; PRNG output
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
    STA     SCENE_NUMBER            ; set new scene number
    JMP     .display                ; continue

.exit:
    JSR     SET_TEXT_WINDOW_BOTTOM
    LDA     #$1B
    JSR     $761E                   ; sound/mode off
                                    ; fall through to .done

.done:
    JSR     SET_TEXT_WINDOW_BOTTOM
    LDA     #$00                    ; \
    STA     LOCATION_FLAG           ;  | clear location flags
    STA     LOCATION_FLAG2          ; /
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
    STA     SAVED_BC
    LDA     $BD
    STA     SAVED_BC+1
    LDA     $F8
    STA     SAVED_F8
    LDA     $F9
    STA     SAVED_F8+1
    LDA     $BE
    STA     SAVED_BE
    LDA     $BF
    STA     SAVED_BE+1
    LDA     $F4
    STA     SAVED_F4
    LDA     $F5
    STA     SAVED_F4+1
    RTS
    ORG     $6D7C
RESTORE_ZP_POINTERS:
    SUBROUTINE

    LDA     SAVED_BC
    STA     $BC
    LDA     SAVED_BC+1
    STA     $BD
    LDA     SAVED_F8
    STA     $F8
    LDA     SAVED_F8+1
    STA     $F9
    LDA     SAVED_BE
    STA     $BE
    LDA     SAVED_BE+1
    STA     $BF
    LDA     SAVED_F4
    STA     $F4
    LDA     SAVED_F4+1
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
    LDY     PRNG_OUTPUT             ; on error: fill with PRNG data
    JSR     STEP_PRNG
    LDA     PRNG_OUTPUT
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
    ORG     $776E
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
    JMP     SCROLL_STATUS_LINE                   ; scroll once more and return

.has_text:
    LDA     MSG_LINE_COUNT
    CMP     #$01
    BMI     .first_line             ; line_count < 1: first line
    BEQ     .second_line            ; line_count == 1: second line

    ; third+ line: scroll, then print
    JSR     SCROLL_STATUS_LINE                   ; scroll status window
.second_line:
    JSR     PRINT_BOTTOM_CENTERED   ; print centered on row 23
    JMP     .advance

.first_line:
    JSR     PRINT_BOTTOM_CENTERED   ; print centered on row 23
    JSR     SCROLL_STATUS_LINE                   ; scroll status window

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
    ORG     SCROLL_STATUS_LINE
SCROLL_STATUS_LINE:
    SUBROUTINE

    JSR     SET_TEXT_WINDOW_SCROLL   ; enable scroll mode
    JSR     SET_TEXT_WINDOW_UPPER_LEFT_LOW ; window top = row 21
    LDA     #$17
    STA     TEXT_ROW                 ; cursor to row 23
    LDA     #$83                    ; Ctrl-C with high bit (scroll up)
    JSR     ROM_COUT1
    JSR     SET_TEXT_WINDOW_UPPER_LEFT_ALL ; reset window to (0,0)
    JMP     SET_TEXT_WINDOW_WRAP     ; restore wrap mode and return
    ORG     $78A8
STEP_PRNG:
    SUBROUTINE

    LDA     PRNG_STATE              ; val
    ASL     A                       ; val*2
    ASL     A                       ; val*4
    STA     PRNG_TEMP               ; temp = val*4
    ASL     A                       ; val*8
    ASL     A                       ; val*16
    ASL     A                       ; val*32
    ASL     A                       ; val*64
    CLC
    ADC     PRNG_TEMP               ; val*64 + val*4 = val*68
    CLC
    ADC     PRNG_STATE              ; val*68 + val = val*69
    CLC
    ADC     #$53                    ; + $53
    STA     PRNG_STATE              ; store full result
    LSR                             ; val >> 1
    STA     PRNG_OUTPUT             ; shifted copy (used for random tests)
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
    JSR     INIT_DISK_IOB
    JSR     INIT_HRCG
    JSR     SET_TEXT_WINDOW_WRAP
    JSR     INIT_STUB
    JSR     INIT_GAME_STATE
    JSR     FILL_MAP
    JSR     SET_TEXT_WINDOW_BOTTOM
    JSR     INIT_STUB2
    LDA     #$00                    ; \
    STA     LOCATION_FLAG           ;  | clear state variables
    STA     LOCATION_FLAG2          ;  |
    STA     $F9                     ; /
    JSR     SELECT_INPUT_MODE
    JSR     INIT_WORLD
    JSR     INIT_MOB_COUNT
    LDA     #$01
    STA     CURRENT_PLAYER
    RTS
    ORG     $795B
SCRIPT_ENGINE:
    SUBROUTINE

    STA     $C010                   ; clear keyboard strobe
    LDA     #$00
    STA     ATTRACT_FLAG            ; attract_flag = 0
    CPX     #$06                    ; script index 6 = attract
    BNE     .not_attract
    INC     ATTRACT_FLAG            ; attract_flag = 1
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
    STA     SCRIPT_LOOP_CTR         ; loop counter = 0
    LDA     #$01
    STA     SCRIPT_PRNG_MASK        ; PRNG mask = 1
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
    CMP     SCRIPT_LOOP_CTR         ; compare with loop counter
    BEQ     .end_loop
    BCC     .end_loop

    INC     SCRIPT_LOOP_CTR         ; counter++
    LDA     SCRIPT_LOOP_ADDR        ; \
    STA     $E4                     ;  | $E4/$E5 = loop address
    LDA     SCRIPT_LOOP_ADDR+1      ;  |
    STA     $E5                     ; /
    JMP     .fetch

.end_loop:
    LDA     #$00
    STA     SCRIPT_LOOP_CTR         ; reset loop counter
    JMP     SCRIPT_ADVANCE

.cmd_25:                            ; PRNG mask = $0F
    LDA     #$0F
    STA     SCRIPT_PRNG_MASK
    JMP     SCRIPT_ADVANCE

.cmd_26:                            ; PRNG mask = $00
    LDA     #$00
    STA     SCRIPT_PRNG_MASK
    JMP     SCRIPT_ADVANCE

.cmd_23:                            ; action vector → $7A7F
    STOW    $7A7F,SCRIPT_ACTION_VEC
    JMP     SCRIPT_ADVANCE

.cmd_24:                            ; action vector → $7A91
    STOW    $7A91,SCRIPT_ACTION_VEC
    JMP     SCRIPT_ADVANCE

.cmd_22:                            ; nop (return from script)
    RTS

.cmd_21:                            ; gosub: jump to saved address
    LDA     SCRIPT_GOSUB_ADDR
    STA     $E4
    LDA     SCRIPT_GOSUB_ADDR+1
    STA     $E5
    JMP     .fetch

.cmd_1F:                            ; set loop address = current+1
    JSR     SCRIPT_INC_E4
    LDA     $E4
    STA     SCRIPT_LOOP_ADDR
    LDA     $E5
    STA     SCRIPT_LOOP_ADDR+1
    JMP     .fetch

.cmd_20:                            ; set gosub address = current+1
    JSR     SCRIPT_INC_E4
    LDA     $E4
    STA     SCRIPT_GOSUB_ADDR
    LDA     $E5
    STA     SCRIPT_GOSUB_ADDR+1
    JMP     .fetch

.action:
    STA     $E2                     ; save action byte
    JSR     STEP_PRNG
    LDA     PRNG_OUTPUT             ; PRNG output
    AND     SCRIPT_PRNG_MASK        ; apply mask
    EOR     $E2                     ; XOR with action byte
    STA     $E1                     ; modified action
    JSR     SCRIPT_INC_E4           ; advance script pointer
    LDY     #$00
    LDA     ($E4),Y                 ; read parameter byte
    STA     $E2
    JSR     SCRIPT_ACTION_INDIRECT  ; → JMP (SCRIPT_ACTION_VEC)
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
    JMP     (SCRIPT_ACTION_VEC)
    ORG     $7A4F
SCRIPT_ADVANCE:
    SUBROUTINE

    JSR     SCRIPT_INC_E4           ; advance script pointer
    LDA     ATTRACT_FLAG            ; attract_flag
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
    ORG     $7919
INIT_STUB:
    RTS
    ORG     $791A
INIT_HRCG:
    SUBROUTINE

    LDA     #$60                    ; RTS opcode
    STA     $94B6                   ; patch HRCG init to return early
    LDA     #$EA                    ; NOP opcode
    STA     $92D5                   ; \ patch out JSR $03EA
    STA     $92D6                   ;  | (skip DOS reconnect)
    STA     $92D7                   ; /
    JMP     HRCG_INIT               ; enter HRCG initialization
    ORG     $792D
SET_TEXT_WINDOW_UPPER_LEFT_ALL:
    SUBROUTINE

    LDA     #0
    JMP     SET_TEXT_WINDOW_UPPER_LEFT

SET_TEXT_WINDOW_UPPER_LEFT_LOW:
    LDA     #21

    ; fall through

SET_TEXT_WINDOW_UPPER_LEFT:

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