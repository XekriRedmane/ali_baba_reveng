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
    MACRO BAEQ
        CMP     {1}
        BEQ     {2}
    ENDM

    MACRO BANE
        CMP     {1}
        BNE     {2}
    ENDM

    MACRO BXEQ
        CPX     {1}
        BEQ     {2}
    ENDM

    MACRO BXNE
        CPX     {1}
        BNE     {2}
    ENDM

    MACRO BYEQ
        CPY     {1}
        BEQ     {2}
    ENDM

    MACRO BYNE
        CPY     {1}
        BNE     {2}
    ENDM
TEXT_COL                EQU     $24     ; Cursor position
TEXT_ROW                EQU     $25
TEXT_STREAM_PTR         EQU     $06     ; text stream pointer for TEXT_RENDERER (2 bytes)
SOUND_FREQ              EQU     $E1     ; sound frequency / script modified action
SOUND_DURATION          EQU     $E2     ; sound duration / script parameter byte
NOISE_SHIFT             EQU     $E3     ; noise generator shift register
SCRIPT_PC               EQU     $E4     ; script instruction pointer (2 bytes, $E4/$E5)
MOB_PTR                 EQU     $F4     ; mob data pointer (2 bytes, $F4/$F5)
DISPATCH_VEC            EQU     $F6     ; script action dispatch vector (2 bytes, $F6/$F7)
EFFECT_REC              EQU     $F6     ; target entity record for damage/stats (2 bytes)
CHAR_INDEX              EQU     $F6     ; selected character/player index
FACTION_MASK            EQU     $F7     ; faction match value for FIND_MOB_BY_FACTION
ENTITY_PTR              EQU     $F8     ; entity record pointer (2 bytes, $F8/$F9)
CHAR_PTR                EQU     $FA     ; character record pointer (2 bytes, $FA/$FB)
MOB_DATA_PTR            EQU     $BA     ; mob data record pointer (2 bytes, $BA/$BB)
COPY_DEST               EQU     $BA     ; block copy destination pointer (2 bytes)
DECIMAL_OUT_PTR         EQU     $BA     ; num-to-decimal output buffer pointer (2 bytes)
PRINT_STRING_ADDR       EQU     $BC     ; print string source pointer (2 bytes)
HANDLER_PTR             EQU     $BC     ; entity type handler address (2 bytes)
NUM_VALUE               EQU     $BC     ; 16-bit numeric value for division (2 bytes)
COPY_SRC                EQU     $BC     ; block copy source pointer (2 bytes)
TARGET_REC              EQU     $BC     ; secondary entity record pointer in combat/reorder (2 bytes)
CHAR_REC                EQU     $BE     ; character record pointer from GET_CHAR_RECORD (2 bytes)
EVENT_PTR               EQU     $BE     ; event list entry pointer (2 bytes)
ENTITY_REC              EQU     $BE     ; entity lookup result from FIND_ENTITY_AT_POS (2 bytes)
AI_BEST_STR             EQU     $BF     ; best hostile strength in ai_choose_target
AI_BEST_POS             EQU     $BE     ; best hostile position in ai_choose_target
DATA_PTR                EQU     $BE     ; general data pointer / return value (2 bytes)
RWTS_IOB_PTR            EQU     $08     ; ZP pointer to RWTS IOB ($B7E8)
HRCG_INIT               EQU     $92A8   ; HRCG entry/init routine
GAME_ACTION_HANDLER     EQU     $5B2A   ; game action dispatch target
READ_KEYBOARD                EQU     $A44C   ; resident: read keyboard input
UI_TEXT_STREAM          EQU     $5E55   ; text stream data for game UI background
BORDER_POS_HORIZ       EQU     $5E7B   ; 6 col/row pairs for horizontal border labels
BORDER_POS_VERT_L      EQU     $5E87   ; 10 col/row pairs for vertical border labels (left)
BORDER_POS_VERT_R      EQU     $5E9B   ; 10 col/row pairs for vertical border labels (right)
BORDER_STR_HORIZ       EQU     $5EAF   ; horizontal border pattern string
BORDER_STR_VERT_L      EQU     $5EC1   ; vertical border pattern string (left)
BORDER_STR_VERT_R      EQU     $5EC4   ; vertical border pattern string (right)
s_COPYRIGHT            EQU     $5EC7   ; "COPYRIGHT 1982 STUART SMITH"
s_PRESS_SPACE          EQU     $5EE3   ; "PRESS SPACE BAR TO CONTINUE"
s_DECOR_ROW1           EQU     $5EFF   ; decorative right-side row 1
s_DECOR_ROW2           EQU     $5F07   ; decorative right-side row 2
s_DECOR_ROW3           EQU     $5F10   ; decorative right-side row 3
BORDER_LOOP_CTR        EQU     $5DC3   ; loop counter for border label drawing
AI_WAIT_FLAG    EQU     $5A06   ; wait delay for AI moves (0 or $0A)
VIEW_MAX_COL    EQU     $5A08   ; viewport max column (from location field 4)
VIEW_MAX_ROW    EQU     $5A09   ; viewport max row
VIEW_MIN_COL    EQU     $5A0A   ; viewport min column (from location field 3)
VIEW_MIN_ROW    EQU     $5A0B   ; viewport min row
FONT_COL        EQU     $5A0C
FONT_ROW        EQU     $5A0D
LOCATION_ID     EQU     $5A17   ; current location/position index
SET_TEXT_WINDOW EQU     $76C2   ; set text window parameters
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
TILE_DEFAULT_TAB        EQU     $7AD0   ; 4-byte table: default char per style
TILE_FILL_TAB           EQU     $7AD4   ; 4-byte table: fill char per style
TILE_BLINK_TAB          EQU     $7AD8   ; 4-byte table: blink alt char per style
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
EVENT_THRESHOLD         EQU     $4239   ; random event probability threshold (~7%)
SCENE_FOUND_FLAG        EQU     $5A89   ; scan result: 1 = matching group found
SCENE_HOSTILE_FLAG      EQU     $5A8A   ; scan result: nonzero = hostile encountered
SCENE_GROUP_IDX         EQU     $5A8B   ; current group index for scanning
SCENE_COMBAT_FLAG       EQU     $423A   ; nonzero = combat pending
SCENE_P3_DONE           EQU     $423B   ; nonzero = player 3 scene processed
SCENE_P1_DONE           EQU     $423C   ; nonzero = player 1 scene processed
SCENE_HOSTILE_DONE      EQU     $423D   ; nonzero = hostile encounter processed
SCENE_EVENT_RESULT      EQU     $423E   ; nonzero = event fully handled
INPUT_MODE          EQU     $5A00   ; 0 = keyboard, 1 = joystick
TOTAL_MOB_COUNT     EQU     $5A01   ; total mobs across all groups (excl. group 0)
CURRENT_PLAYER      EQU     $5A02   ; current player index (1-based)
CURRENT_ROOM        EQU     $5A03   ; current room/location being processed
CHAR_SPRITE         EQU     $5A04   ; character's font char number for display
DAMAGE_AMOUNT       EQU     $5A10   ; damage to apply / new HP after subtraction
ACTIVE_CHAR         EQU     $5A29   ; character index being processed
SOURCE_CHAR         EQU     $5A28   ; source character for reorder
REORDER_LINK        EQU     $5A2A   ; temp: saved next-link during reorder
REORDER_SORT_KEY    EQU     $5A2B   ; temp: byte 11 of node for sorted insert
BOUNDS_MIN_COL      EQU     $5A51   ; scene setup: left column boundary
BOUNDS_MAX_COL      EQU     $5A52   ; scene setup: right column boundary
BOUNDS_MIN_ROW      EQU     $5A53   ; scene setup: top row boundary
BOUNDS_MAX_ROW      EQU     $5A54   ; scene setup: bottom row boundary
LOCATION_POS        EQU     $5A55   ; current location position (triggers redraw when changed)
NEAREST_DIST        EQU     $5A14   ; find nearest event: current minimum distance
HEAL_NOTIFIED       EQU     $5A16   ; auto heal: nonzero = already printed heal message
LOCATION_STYLE      EQU     $5A56   ; current map style (from record field 5, bits 0-6)
TRAP_TYPE           EQU     $5A58   ; treasure trap: random trap type (0-3)
AI_PREV_DIR         EQU     $5A5D   ; NPC AI: previous move direction (bias avoidance)
EVENT_DEST_POS      EQU     $5A5F   ; event handler: destination position
EVENT_POS           EQU     $5A5E   ; event position (from MANHATTAN_DISTANCE)
SHOP_ITEM_MASK      EQU     $5A80   ; shop: bitmask for current item ($80 rotating right)
SHOP_PRICE          EQU     $5A81   ; shop: accumulated price low byte
SHOP_PRICE_HI       EQU     $5A82   ; shop: accumulated price high byte
SCENE_NUMBER        EQU     $5A99   ; current scene number
TURN_SCRIPT_GUARD   EQU     $5AA9   ; turn reset: guards one-shot script execution
SCENE_TEXT_DATA     EQU     $5C00   ; base address of scene text data (loaded by LOAD_SCENE_DATA)
SCENE_TRANSITION    EQU     $5CFF   ; scene transition flag (nonzero = new scene number)
ATTRACT_FLAG        EQU     $5AA7   ; 1 = attract/demo mode, 0 = normal
WORLD_INIT_DATA         EQU     $62B9   ; world initialization data table
RWTS_IOB                EQU     $B7E8   ; RWTS Input/Output Block (14 bytes)
RWTS_ENTRY              EQU     $B7B5   ; RWTS entry point
SAVED_BC            EQU     $5A9A   ; saved TARGET_REC/PRINT_STRING_ADDR (2 bytes)
SAVED_F8            EQU     $5A9C   ; saved ENTITY_PTR pointer (2 bytes)
SAVED_BE            EQU     $5A9E   ; saved CHAR_REC/ENTITY_REC (2 bytes)
SAVED_F4            EQU     $5AA0   ; saved MOB_PTR pointer (2 bytes)
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
BLINK_DELAY             EQU     $7AAC   ; delay value loaded into WAIT_LOOP_COUNT by DRAW_MAP_ICON_B
MAP_REDRAW_FLAG         EQU     $7AC4   ; non-zero = full map redraw needed
ROM_WAIT                EQU     $FCA8   ; Apple II ROM WAIT routine
TEXT_RIGHT_MARGIN        EQU     $5A96   ; right margin column for text wrap
TEXT_LEFT_MARGIN         EQU     $5A97   ; left margin column for text wrap
TEXT_STREAM_IDX          EQU     $5A98   ; saved Y index into byte stream
SCRIPT_LOOP_CTR     EQU     $5A8D   ; script loop iteration counter
SCRIPT_LOOP_ADDR    EQU     $5A8E   ; script loop address (2 bytes)
SCRIPT_GOSUB_ADDR   EQU     $5A90   ; script gosub return address (2 bytes)
SCRIPT_PRNG_MASK    EQU     $5A92   ; PRNG mask for action randomization
SCRIPT_ACTION_VEC   EQU     $5A93   ; action handler vector (2 bytes)
CHAR_AI_MODE    EQU     $5A05   ; 0 = player, 2-5 = AI behavior modes
TURN_START_COL  EQU     $5A61   ; column at start of turn
TURN_START_ROW  EQU     $5A62   ; row at start of turn
CURRENT_COL     EQU     $5A63   ; current column during turn
CURRENT_ROW     EQU     $5A64   ; current row during turn
MOVE_POINTS     EQU     $5A65   ; movement points remaining
STEPS_TAKEN     EQU     $5A66   ; steps taken this turn
INPUT_DIR       EQU     $5A67   ; direction/command from input (1-9)
COMBAT_WILLINGNESS EQU  $5A76   ; accumulated willingness-to-fight score
COMBAT_STRENGTH EQU     $5A78   ; result of CALC_COMBAT_STRENGTH
TARGET_PTR_LO   EQU     $5A86   ; selected combat target pointer (low byte)
TARGET_PTR_HI   EQU     $5A87   ; selected combat target pointer (high byte)
BEST_THREAT     EQU     $5A88   ; best threat level during target selection
EVENT_SLOT_BYTE EQU     $5A59   ; saved byte 2 of event slot (type+value)
EVENT_SUB_VALUE EQU     $5A5A   ; lower 5 bits of event slot byte 2
DIR_SCORES      EQU     $5A6A   ; array of 5 direction scores (indexed 0-4)
AI_DIRECTION    EQU     $5A6F   ; current direction being evaluated / random range
AI_TEST_POS     EQU     $5A70   ; position being tested for direction evaluation
AI_TARGET_POS   EQU     $5A71   ; AI target position (set by AI_CHOOSE_TARGET)
AI_TARGET_COL   EQU     $5A72   ; AI target column / min distance temp
STAT_LEVEL_BITS EQU     $5A7F   ; level bits during stat modification
MOB_DEFENSE     EQU     $5A79   ; mob defense value (low 4 bits of mob byte 8)
SHOP_ITEM_OFFSET EQU    $5A85   ; offset into shop item table (5 per item)
INPUT_OPTION_COUNT EQU  $5AAA   ; number of input options to draw
CURRENT_SELECTION EQU   $5AAB   ; current menu selection index
INPUT_BUFFER    EQU     $5AAC   ; 120-byte input text display buffer
INPUT_JMP_VEC   EQU     $5F5E   ; indirect jump vector for input callbacks
UNDER_LEVEL     EQU     $5B25   ; 1 if char level < steps taken
SAFE_TO_REST    EQU     $5B26   ; 1 if no adjacent threats or encounters
TURN_ACTIVE     EQU     $5B27   ; 1 while turn is in progress
IS_PLAYER_TURN  EQU     $5A74   ; 0 = mob's turn, 1 = player's turn
    ORG     $0500
STUB_ENTRY:
    JMP     ATTRACT_LOOP
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
RESIDENT_DISPATCH_FETCH:
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
    HEX     4F A2 CE 26 79
; last 5 bytes overlap with CONTEXT_SWAP code at $06E0
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
    JMP     RESIDENT_DISPATCH_FETCH ; fetch from new location
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
    ORG     $07DF
DECODE_DISPATCH_RELAY:
    JMP     RESIDENT_DECODE_DISPATCH
    ORG     $0800
MAIN_ENTRY:
    SUBROUTINE

    JSR     GAME_INIT
.restart:
    LDA     #$09                    ; \
    STA     CHAR_PTR                     ;  | $FA/$FB = $4009 (character record base)
    LDA     #$40                    ;  |
    STA     CHAR_PTR+1                     ; /
    LDA     TOTAL_MOB_COUNT         ; zero on first run (no mobs yet)
    BNE     .has_mobs               ; nonzero = game in progress
    JSR     ATTRACT_SCREEN
.has_mobs:
    LDA     #$01
    STA     CURRENT_PLAYER          ; start with player 1
.char_loop:
    LDY     #$08
    LDA     (CHAR_PTR),Y                 ; char record byte 8 (status/group)
    BEQ     .next_char              ; zero = inactive, skip
    JSR     ENTER_LOCATION          ; draw map if location changed
    LDA     CURRENT_PLAYER
    CMP     #$01                    ; player 1?
    BEQ     .run_scene
    CMP     #$03                    ; player 3?
    BNE     .process_mobs
.run_scene:
    JSR     CHECK_SCENE_EVENTS      ; scene event dispatch (players 1 & 3)
.process_mobs:
    JSR     PROCESS_MOB_GROUPS      ; walk mob list, run turns
.next_char:
    INC     CURRENT_PLAYER
    CLC
    LDA     #$09                    ; advance to next 9-byte record
    ADC     CHAR_PTR
    STA     CHAR_PTR
    BCC     .no_carry
    INC     CHAR_PTR+1
.no_carry:
    LDY     #$01
    LDA     (CHAR_PTR),Y                 ; byte 1 of next record
    CMP     #$FF                    ; $FF = end-of-table sentinel
    BNE     .char_loop              ; more characters → loop
    JSR     RANDOM_EVENTS           ; between-round random event dispatch
    JMP     .restart                ; restart the game loop
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
    ORG     $0884
PROCESS_MOB_GROUPS:
    SUBROUTINE
    ; Walk the mob linked list for the current character.
    ; For each group: inactive (type < 3) → display message + auto-heal;
    ; active (type >= 3) → set up scene and enter GAME_TURN_LOOP.
    LDY     #$02
    LDA     (CHAR_PTR),Y                 ; char record byte 2 = first group link
    STA     CURRENT_ROOM            ; save as current link
    JSR     CLEAR_MAP
    JSR     STEP_PRNG
    LDA     PRNG_OUTPUT
    AND     #$17                    ; 1-in-24 chance (bits 0-2,4)
    BNE     .walk_list
    JSR     $A508                   ; periodic disk checkpoint (resident)
.walk_list:
    LDA     CURRENT_ROOM            ; current link in chain
    BNE     .has_mob
    RTS                             ; zero = end of list
.has_mob:
    JSR     GET_MOB_DATA            ; resolve link → MOB_DATA_PTR/MOB_DATA_PTR+1
    LDA     MOB_DATA_PTR                     ; \
    STA     ENTITY_PTR                     ;  | ENTITY_PTR/ENTITY_PTR+1 = mob data pointer
    LDA     MOB_DATA_PTR+1                     ;  |
    STA     ENTITY_PTR+1                     ; /
    LDY     #$02
    LDA     (ENTITY_PTR),Y                 ; mob data byte 2 = next link
    STA     CURRENT_ROOM            ; save for next iteration
    LDY     #$06
    LDA     (ENTITY_PTR),Y                 ; mob data byte 6
    AND     #$3F                    ; bits 5-0 = mob type
    CMP     #$03                    ; type >= 3?
    BPL     .active_mob
    JSR     SHOW_IDLE_STATUS        ; inactive: print name + message
    JSR     AUTO_HEAL               ; heal party members
    JMP     .walk_list
.active_mob:
    JSR     START_MOB_TURN          ; active: set up sprite, enter turn loop
    LDA     #$14
    STA     BLINK_COL               ; reset blink column to 20
    JMP     .walk_list
    ORG     $08D1
SHOW_IDLE_STATUS:
    SUBROUTINE
    ; Display a status message for an inactive mob group.
    JSR     SCROLL_STATUS_LINE
    JSR     PRINT_MOB_NAME
    JSR     SCROLL_STATUS_LINE
    LDA     #$20                    ; message $20: idle status text
    JMP     DISPLAY_MESSAGE
    ORG     $08DF
START_MOB_TURN:
    SUBROUTINE
    ; Set up the character sprite and enter the game turn loop
    ; for an active mob group (type >= 3).
    LDY     #$04
    LDA     (ENTITY_PTR),Y                 ; mob data byte 4 = appearance
    JSR     APPEARANCE_TO_FONTCHAR
    STA     CHAR_SPRITE             ; save font character
    STY     CHAR_AI_MODE            ; Y = font group → AI behavior mode
    JSR     CHECK_MOB_NEEDS_TURN    ; carry set = needs a turn
    BCS     .enter_turn
    RTS                             ; carry clear = skip this mob
.enter_turn:
    JSR     SET_CURSOR_ROW21
    JSR     SETUP_SCENE_DISPLAY
    LDA     CHAR_AI_MODE
    STA     $5AA6                   ; save AI mode (unused in main.bin)
    JMP     GAME_TURN_LOOP
    ORG     $0901
SETUP_SCENE_DISPLAY:
    SUBROUTINE

    LDA     #$00
    STA     AI_WAIT_FLAG
    CMP     CHAR_AI_MODE
    BNE     .not_ai
    LDA     #$0A
    STA     AI_WAIT_FLAG
    LDX     #$10
    JSR     SCRIPT_ENGINE
.not_ai:
    JSR     DRAW_CHAR_AT_POS
    JSR     SETUP_CHAR_SPRITE
    LDA     AI_WAIT_FLAG
    ROL
    STA     WAIT_LOOP_COUNT
    JMP     TIMED_WAIT
    ORG     $0925
LOAD_CHAR_NAME_PTR:
    SUBROUTINE
    LDY     #$00
    LDA     (ENTITY_PTR),Y
    STA     PRINT_STRING_ADDR
    INY
    LDA     (ENTITY_PTR),Y
    STA     PRINT_STRING_ADDR+1
    JMP     SETUP_TEXT_POS_COL20
    ORG     $0933
SETUP_CHAR_SPRITE:
    SUBROUTINE
    LDY     #$03
    LDA     (ENTITY_PTR),Y
    JSR     POS_TO_COLROW
    STA     FONT_COL
    STY     FONT_ROW
    STA     BLINK_COL
    STY     BLINK_ROW
    TAX
    LDA     CHAR_SPRITE
    STA     FONT_CHARNUM
    STA     BLINK_CHAR
    LDA     #$01
    STA     FONT_CHARSET
    JMP     RENDER_FONT_CHAR
    ORG     $0958
CHECK_MOB_NEEDS_TURN:
    SUBROUTINE
    ; Check whether a mob group needs a game turn.
    ; Returns: carry set = needs turn, carry clear = skip.
    ; Skips if: AI mode is player (0), or record byte 12 low nibble
    ; is nonzero, or no encounter and no adjacent threats.
    LDA     CHAR_AI_MODE
    BEQ     .needs_turn             ; player-controlled always gets a turn
    LDY     #$0C
    LDA     (ENTITY_PTR),Y                 ; mob data byte 12
    AND     #$0F                    ; low nibble
    BNE     .needs_turn             ; nonzero = pending action → turn
    LDY     #$03
    LDA     (ENTITY_PTR),Y                 ; mob data byte 3 = position
    JSR     CHECK_ENCOUNTER         ; check for encounter at this position
    LDA     ENCOUNTER_RESULT
    BNE     .needs_turn             ; encounter found → turn
    LDY     #$03
    LDA     (ENTITY_PTR),Y                 ; position again
    JSR     CHECK_ADJACENT_THREATS
    LDA     ADJACENT_THREAT
    BNE     .needs_turn             ; threats nearby → turn
    JSR     CLEAR_RESTRICTED        ; no action needed → clear restricted flag
    CLC                             ; carry clear = skip
    RTS
.needs_turn:
    SEC                             ; carry set = needs turn
    RTS
    ORG     $09F4
ATTRACT_SCREEN:
    SUBROUTINE

    LDA     #$01
    STA     ACTIVE_CHAR             ; scene/character index = 1
    STA     SCENE_EVENT_RESULT      ; mark event as handled
    JSR     COMPUTE_SCENE_PTR       ; scene 1 pointer → MOB_DATA_PTR/MOB_DATA_PTR+1
    LDA     MOB_DATA_PTR                     ; \
    STA     MOB_PTR                     ;  | MOB_PTR/MOB_PTR+1 = MOB_DATA_PTR/MOB_DATA_PTR+1 (save pointer)
    LDA     MOB_DATA_PTR+1                     ;  |
    STA     MOB_PTR+1                     ; /
    JSR     SCENE_SETUP
    LDA     #$00
    STA     LOCATION_POS           ; clear location-change flag
    JSR     SET_CURSOR_ROW21
    LDA     #$26                    ; scene number $26 (38 decimal)
    JMP     SCENE_LOOP              ; tail-call
    ORG     $0A17
SCENE_SETUP:
    SUBROUTINE

    LDA     ACTIVE_CHAR             ; character/scene index
    JSR     GET_CHAR_RECORD         ; index → CHAR_REC = char record
    LDY     #$03
    LDA     (CHAR_REC),Y                 ; byte 3: min position (packed)
    JSR     POS_TO_COLROW           ; → A=min_col, Y=min_row
    STA     BOUNDS_MIN_COL          ; min_col
    STY     BOUNDS_MIN_ROW          ; min_row
    LDY     #$04
    LDA     (CHAR_REC),Y                 ; byte 4: max position (packed)
    JSR     POS_TO_COLROW           ; → A=max_col, Y=max_row
    STA     BOUNDS_MAX_COL          ; max_col
    STY     BOUNDS_MAX_ROW          ; max_row
    INC     BOUNDS_MIN_COL          ; min_col++ (exclusive border)
    INC     BOUNDS_MIN_ROW          ; min_row++
    CLC
    LDA     BOUNDS_MAX_COL          ; \
    SBC     BOUNDS_MIN_COL          ;  | col_range = max_col - min_col
    JSR     RANDOM_IN_RANGE         ;  | random column offset
    CLC                             ;  |
    ADC     BOUNDS_MIN_COL          ;  | col = min_col + offset
    STA     FONT_COL                ; / set font column
    CLC
    LDA     BOUNDS_MAX_ROW          ; \
    SBC     BOUNDS_MIN_ROW          ;  | row_range = max_row - min_row
    JSR     RANDOM_IN_RANGE         ;  | random row offset
    CLC                             ;  |
    ADC     BOUNDS_MIN_ROW          ; / row = min_row + offset
    TAY                             ; Y = row
    LDA     FONT_COL                ; A = col
    JSR     COLROW_TO_POS           ; → A = linear position
    LDY     #$03
    STA     (MOB_PTR),Y                 ; store position in record byte 3
    LDA     MOB_PTR                     ; \
    STA     TARGET_REC                     ;  | TARGET_REC/TARGET_REC+1 = MOB_PTR/MOB_PTR+1
    LDA     MOB_PTR+1                     ;  |
    STA     TARGET_REC+1                     ; /
    LDA     #$00
    STA     SOURCE_CHAR             ; clear source char index
    JSR     REORDER_CHAR            ; reorder character in linked list
    LDY     #$0D
    LDA     #$00                    ; \
    STA     (MOB_PTR),Y                 ;  | clear bytes 13-14 of record
    INY                             ;  |
    STA     (MOB_PTR),Y                 ; /
    JSR     CLAMP_CHAR_FIELD        ; ensure byte 6 >= byte 5 minimum
    LDA     CURRENT_PLAYER                   ; current player index
    CMP     ACTIVE_CHAR             ; compare with scene index
    BNE     .done                   ; not current player → skip
    LDY     #$03
    LDA     (MOB_PTR),Y                 ; load position from record
    JSR     DRAW_CHAR_AT_POS        ; draw character at position
.done:
    RTS
    ORG     $0A93
CLAMP_CHAR_FIELD:
    SUBROUTINE

    LDY     #$05
    LDA     (MOB_PTR),Y                 ; byte 5 of record
    AND     #$1F                    ; low 5 bits = minimum
    STA     $BA
    INY
    LDA     (MOB_PTR),Y                 ; byte 6 of record
    AND     #$3F                    ; low 6 bits = current value
    CMP     $BA
    BCC     .clamp                  ; current < minimum → clamp
    RTS                             ; current >= minimum → done
.clamp:
    LDA     (MOB_PTR),Y                 ; reload byte 6
    AND     #$C0                    ; preserve top 2 bits
    ORA     $BA                     ; set low bits to minimum
    STA     (MOB_PTR),Y
    RTS
    ORG     $0B62
FIND_ENTITY_AT_POS:
    SUBROUTINE

    STA     DAT_5a17_pos            ; save target position
    LDA     CHAR_PTR+1                     ; \ patch base address into
    STA     .load3+2                ;  | player search (high byte)
    STA     .load2+2                ;  | mob search (high byte)
    LDA     CHAR_PTR                     ;  |
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
    JMP     CHECK_AT_BOUNDARY      ; $FF = end of table
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
    LDA     .load4+1                ; \ ENTITY_REC/ENTITY_REC+1 = table entry address
    STA     ENTITY_REC                     ;  |
    LDA     .load4+2                ;  |
    STA     ENTITY_REC+1                     ; /
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
    STA     ENTITY_REC+1                     ;  |
    LDA     .load1+1                ;  |
    STA     ENTITY_REC                     ; / ENTITY_REC/ENTITY_REC+1 = mob pointer | $80
    RTS

    ; --- Helper: get mob data and patch .load1 ---
.get_mob:
    JSR     GET_MOB_DATA            ; A = mob index → MOB_DATA_PTR/MOB_DATA_PTR+1 = data ptr
    LDA     MOB_DATA_PTR                     ; \
    STA     .load1+1                ;  | patch .load1 operand
    LDA     MOB_DATA_PTR+1                     ;  |
    STA     .load1+2                ; /
    RTS
    ORG     $0BFA
CHECK_AT_BOUNDARY:
    SUBROUTINE

    LDA     LOCATION_ID
    JSR     POS_TO_COLROW
    CMP     VIEW_MIN_COL
    BEQ     .at_edge
    CMP     VIEW_MAX_COL
    BEQ     .at_edge
    TYA
    CMP     VIEW_MIN_ROW
    BEQ     .at_edge
    CMP     VIEW_MAX_ROW
    BEQ     .at_edge
    LDA     #$00
    STA     DATA_PTR
    STA     DATA_PTR+1
    RTS
.at_edge:
    LDA     #$00
    STA     DATA_PTR+1
    LDA     #$01
    STA     DATA_PTR
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
COMPUTE_SCENE_PTR:
GET_MOB_DATA:
    SUBROUTINE

    CLC
    ADC     #$FF                    ; A = index - 1
    ROL                       ; \
    ROL                       ;  | rotate left 4 times
    ROL                       ;  | = multiply by 16 (with carry)
    ROL                       ; /
    TAY                             ; save intermediate
    ROL                       ; one more rotate
    AND     #$0F                    ; high nybble → page offset
    CLC
    ADC     $4001                   ; add base page
    STA     MOB_DATA_PTR+1             ; high byte
    TYA
    AND     #$F0                    ; low nybble → byte offset
    CLC
    ADC     $4000                   ; add base offset
    STA     MOB_DATA_PTR               ; low byte
    BCC     .done
    INC     MOB_DATA_PTR+1             ; carry
.done:
    RTS
    ORG     $0C51
INIT_MOB_COUNT:
    SUBROUTINE

    LDA     #$00                    ; \
    STA     TOTAL_MOB_COUNT         ; / clear total
    LDA     #$09                    ; \ $FA/$FB = $4009 (record 1)
    STA     CHAR_PTR                     ;  |
    LDA     #$40                    ;  |
    STA     CHAR_PTR+1                     ; /
.loop:
    LDY     #$01
    LDA     (CHAR_PTR),Y                 ; byte 1 of record
    CMP     #$FF                    ; $FF = end sentinel
    BNE     .count
    RTS
.count:
    LDY     #$08
    LDA     (CHAR_PTR),Y                 ; byte 8 = group member count
    CLC
    ADC     TOTAL_MOB_COUNT         ; accumulate
    STA     TOTAL_MOB_COUNT
    LDA     #$09                    ; \ advance $FA by 9 (next record)
    ADC     CHAR_PTR                     ;  |
    STA     CHAR_PTR                     ;  |
    BCC     .loop                   ;  |
    INC     CHAR_PTR+1                     ;  |
    BCS     .loop                   ; / always taken
    ORG     $0C7E
GET_ENTITY_FONTCHAR:
    SUBROUTINE

    LDA     #$01
    STA     FONT_CHARSET            ; custom font
    LDA     #$00
    CMP     ENTITY_REC+1                     ; high byte of pointer
    BNE     .has_entity             ; non-zero → entity exists
    CMP     ENTITY_REC                     ; low byte
    BNE     .low_only               ; low ≠ 0 → partial pointer
.empty:
    LDA     BLINK_ALT_CHAR          ; \
    STA     FONT_CHARNUM            ;  | empty cell → blink char
    RTS                             ; /
.low_only:
    LDA     DEFAULT_CHAR            ; \
    STA     FONT_CHARNUM            ;  | $BE≠0, ENTITY_REC+1=0 → default char
    RTS                             ; /
.has_entity:
    LDA     ENTITY_REC+1
    CMP     #$80                    ; bit 7 set?
    BPL     .mob                    ; yes → mob record
    ; --- character record ---
    LDY     #$01
    LDA     (ENTITY_REC),Y                 ; byte 1 of character record
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
    LDA     (ENTITY_REC),Y                 ; reload byte 1
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
    LDA     (ENTITY_REC),Y                 ; byte 2
    AND     #$1F                    ; low 5 bits
    BEQ     .empty                  ; zero → blink alt char
    JMP     .store                  ; non-zero → use as charnum
.mob:
    LDA     ENTITY_REC                     ; \
    STA     MOB_DATA_PTR                     ;  | MOB_DATA_PTR = ENTITY_REC with bit 7 cleared
    LDA     ENTITY_REC+1                     ;  |
    AND     #$7F                    ;  |
    STA     MOB_DATA_PTR+1                     ; /
    LDY     #$04
    LDA     (MOB_DATA_PTR),Y                 ; byte 4 = appearance
    JSR     APPEARANCE_TO_FONTCHAR
    JMP     .store
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
    ORG     $0D8A
PRINT_MOB_NAME:
    SUBROUTINE

    LDY     #$00                    ; \
    LDA     (ENTITY_PTR),Y                 ;  | PRINT_STRING_ADDR/PRINT_STRING_ADDR+1 = bytes 0-1 of ($F8)
    STA     PRINT_STRING_ADDR                     ;  | (name string pointer)
    INY                             ;  |
    LDA     (ENTITY_PTR),Y                 ;  |
    STA     PRINT_STRING_ADDR+1                     ; /
    JMP     PRINT_BOTTOM_CENTERED   ; center and print on row 23
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
; Divides NUM_VALUE/NUM_VALUE+1 by $5A1C/$5A1D via repeated subtraction.
; Stores ASCII digit at (DECIMAL_OUT_PTR),Y. Suppresses leading zeros.
.extract_digit:
    LDA     #$B0                    ; digit = '0' (high ASCII)
    STA     NUM_DIGIT
.cmp_loop:
    LDX     #$01                    ; start comparing high byte
.cmp_x:
    LDA     NUM_VALUE,X                   ; \
    CMP     NUM_DIVISOR,X           ;  | compare NUM_VALUE/NUM_VALUE+1 with divisor
    BCC     .output                 ;  | if less, done (digit found)
    BNE     .subtract               ; /  if greater, subtract
    DEX                             ; \  high bytes equal: check low
    BNE     .subtract               ; /  (if X was 1, now 0 -> recompare)
    JMP     .cmp_x                  ;    compare low byte (X=0)
.subtract:
    SEC                             ; \
    LDA     NUM_VALUE                     ;  | NUM_VALUE/NUM_VALUE+1 -= divisor
    SBC     NUM_DIVISOR             ;  |
    STA     NUM_VALUE                     ;  |
    LDA     NUM_VALUE+1                     ;  |
    SBC     NUM_DIVISOR+1           ;  |
    STA     NUM_VALUE+1                     ; /
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
    STA     (DECIMAL_OUT_PTR),Y                 ; store digit at output buffer
    LDA     #$01                    ; \  clear leading-zero suppress
    STA     NUM_LEADING             ; /  (first nonzero digit seen)
.skip:
    INY                             ; advance output index
    RTS
    ORG     $0E25
CHECK_ENCOUNTER:
    SUBROUTINE

    JSR     FIND_ENTITY_AT_POS      ; look up char → ENTITY_REC/ENTITY_REC+1
    LDA     ENTITY_REC+1
    CMP     #$00
    BEQ     .none                   ; null pointer → return 0
    CMP     #$80
    BMI     .none                   ; not a mob (bit 7 clear) → return 0
    AND     #$7F                    ; clear mob flag
    STA     MOB_PTR+1                     ; \ MOB_PTR/MOB_PTR+1 = mob data pointer
    LDA     ENTITY_REC                     ;  |
    STA     MOB_PTR                     ; /
.search:
    LDA     MOB_PTR                     ; \ TARGET_REC/TARGET_REC+1 = current mob pointer
    STA     TARGET_REC                     ;  |
    LDA     MOB_PTR+1                     ;  |
    STA     TARGET_REC+1                     ; /
    JSR     FIND_MOB_AT_SAME_POS    ; find next mob at same position
    CMP     #$01
    BMI     .none                   ; 0 = no co-located mob → return 0
    BEQ     .friendly               ; 1 = found (wrapped) → return 1
    LDY     #$06                    ; result >= 2: found ahead
    LDA     (MOB_PTR),Y                 ; byte 6 of found mob
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
    LDA     (MOB_PTR),Y                 ; byte 3 = position of current mob
    STA     COLOCATE_POS
    DEY
    LDA     (MOB_PTR),Y                 ; byte 2 = next link of current mob
    STA     COLOCATE_LINK
    STY     COLOCATE_WRAPPED        ; $5A22 = 2 (found ahead)
.check_link:
    CMP     #$00
    BNE     .resolve                ; has next → follow it
    LDY     #$01
    STY     COLOCATE_WRAPPED        ; wrapped to start
    INY                             ; Y = 2
    LDA     (CHAR_PTR),Y                 ; byte 2 of group head = first mob
.resolve:
    JSR     GET_MOB_DATA            ; A = mob index → MOB_DATA_PTR/MOB_DATA_PTR+1
    LDY     #$02
    LDA     (MOB_DATA_PTR),Y                 ; byte 2 of resolved mob
    CMP     COLOCATE_LINK           ; same next-link as original?
    BNE     .not_self
    LDA     #$00                    ; full circle → not found
    RTS
.not_self:
    INY                             ; Y = 3
    LDA     (MOB_DATA_PTR),Y                 ; byte 3 = position
    CMP     COLOCATE_POS            ; same position as original?
    BEQ     .found
    DEY                             ; Y = 2
    LDA     (MOB_DATA_PTR),Y                 ; follow next link
    JMP     .check_link
.found:
    LDA     MOB_DATA_PTR                     ; \ update MOB_PTR/MOB_PTR+1 to found mob
    STA     MOB_PTR                     ;  |
    LDA     MOB_DATA_PTR+1                     ;  |
    STA     MOB_PTR+1                     ; /
    LDA     COLOCATE_WRAPPED        ; return 1 (wrapped) or 2 (ahead)
    RTS
    ORG     $0EB1
CHECK_HOSTILE:
    SUBROUTINE

    LDY     #$04
    LDA     (MOB_PTR),Y                 ; byte 4 of found mob (appearance)
    STA     HOSTILE_APP
    LDA     (TARGET_REC),Y                 ; byte 4 of original mob (appearance)
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
    LDA     ENTITY_PTR                     ; \ TARGET_REC/TARGET_REC+1 = character record pointer
    STA     TARGET_REC                     ;  |
    LDA     ENTITY_PTR+1                     ;  |
    STA     TARGET_REC+1                     ; /
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
    LDA     (ENTITY_PTR),Y                 ; byte 5 of character record
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

    JSR     FIND_ENTITY_AT_POS      ; A = position → ENTITY_REC/ENTITY_REC+1
    LDA     ENTITY_REC+1
    BEQ     .done                   ; null → nothing here
    CMP     #$80
    BMI     .done                   ; not a mob → skip
    AND     #$7F                    ; clear mob flag
    STA     MOB_PTR+1                     ; \ MOB_PTR/MOB_PTR+1 = mob data pointer
    LDA     ENTITY_REC                     ;  |
    STA     MOB_PTR                     ; /
.check_mob:
    JSR     CHECK_HOSTILE           ; is this mob hostile to (TARGET_REC)?
    CMP     #$00
    BEQ     .next                   ; not hostile → skip
    LDY     #$0F
    LDA     (MOB_PTR),Y                 ; byte $0F of mob
    AND     #$04                    ; bit 2 = combat engaged flag
    BNE     .next                   ; already in combat → skip
    LDY     #$05
    LDA     (MOB_PTR),Y                 ; byte 5 of mob
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
    ORG     $0F84
REORDER_CHAR:
    SUBROUTINE

; --- Phase 1: unlink character SOURCE_CHAR from its current chain ---
    LDA     SOURCE_CHAR             ; source character index
    JSR     GET_CHAR_RECORD         ; CHAR_REC = record pointer
    JSR     DECR_GROUP_COUNT        ; source group lost a member
.walk1:
    LDY     #$02                    ; \
    LDA     (CHAR_REC),Y                 ;  | REORDER_LINK = byte 2 of current record
    STA     REORDER_LINK            ; /  (the "next" link we're removing)
    JSR     GET_MOB_DATA            ; MOB_DATA_PTR/MOB_DATA_PTR+1 = resolve link; TARGET_REC/TARGET_REC+1 = mob data
    LDA     MOB_DATA_PTR                     ; \
    CMP     TARGET_REC                     ;  | compare MOB_DATA_PTR/MOB_DATA_PTR+1 with TARGET_REC/TARGET_REC+1
    BNE     .advance1               ;  | if different, keep walking
    LDA     MOB_DATA_PTR+1                     ;  |
    CMP     TARGET_REC+1                     ; /
    BNE     .advance1
    ; Found predecessor: TARGET_REC/TARGET_REC+1 points to the node being removed
    LDY     #$02
    LDA     REORDER_LINK            ; \  if removed node's link == CURRENT_ROOM,
    CMP     CURRENT_ROOM                   ;  |   update CURRENT_ROOM to new link
    BNE     .patch1                 ; /
    LDA     (TARGET_REC),Y                 ; \
    STA     CURRENT_ROOM                   ; /  CURRENT_ROOM = (TARGET_REC)[2] (successor's link)
.patch1:
    LDA     (TARGET_REC),Y                 ; \  predecessor.byte2 = removed.byte2
    STA     (CHAR_REC),Y                 ; /  (skip over removed node)
    JMP     .phase2
.advance1:
    LDA     MOB_DATA_PTR                     ; \  CHAR_REC = MOB_DATA_PTR/MOB_DATA_PTR+1
    STA     CHAR_REC                     ;  | (advance to next record)
    LDA     MOB_DATA_PTR+1                     ;  |
    STA     CHAR_REC+1                     ; /
    JMP     .walk1

; --- Phase 2: re-insert at correct sorted position in ACTIVE_CHAR's chain ---
.phase2:
    LDY     #$0B                    ; \
    LDA     (TARGET_REC),Y                 ;  | REORDER_SORT_KEY = byte 11 of removed node
    AND     #$1F                    ;  |   (level, 5-bit)
    STA     REORDER_SORT_KEY        ; /
    LDA     ACTIVE_CHAR             ; destination character index
    JSR     GET_CHAR_RECORD         ; CHAR_REC = dest record pointer
    JSR     INCR_GROUP_COUNT        ; dest group gained a member
.walk2:
    LDY     #$02                    ; \
    LDA     (CHAR_REC),Y                 ;  | check byte 2 of current record
    CMP     #$00                    ;  | if zero (end of chain) -> insert here
    BEQ     .insert                 ; /
    JSR     GET_MOB_DATA            ; resolve link
    LDA     ACTIVE_CHAR             ; \
    BEQ     .random                 ; /  if dest index = 0, use random decision
    LDY     #$0B                    ; \
    LDA     (MOB_DATA_PTR),Y                 ;  | compare candidate's level
    AND     #$1F                    ;  | with removed node's level
    CMP     REORDER_SORT_KEY        ;  |
    BPL     .advance2               ; /  if >= , keep walking (insert later)
.insert:
    LDY     #$02                    ; \
    LDA     (CHAR_REC),Y                 ;  | (TARGET_REC)[2] = (CHAR_REC)[2]  (link successor)
    STA     (TARGET_REC),Y                 ;  |
    LDA     REORDER_LINK            ;  | (CHAR_REC)[2] = saved link (insert node)
    STA     (CHAR_REC),Y                 ; /
    LDY     #$04                    ; \
    LDA     (TARGET_REC),Y                 ;  | if byte 4 of ($BC) >= $15, done
    CMP     #$15                    ;  |
    BCC     .adjust                 ;  |
    RTS                             ; /
.adjust:
    LDA     #$00                    ; \
    CMP     ACTIVE_CHAR             ;  | if inserted into index 0's slot,
    BNE     .chk28                  ;  |   decrement TOTAL_MOB_COUNT
    DEC     TOTAL_MOB_COUNT         ; /
.chk28:
    CMP     SOURCE_CHAR             ; \  if removed from index 0's slot,
    BNE     .done                   ;  |   increment TOTAL_MOB_COUNT
    INC     TOTAL_MOB_COUNT         ; /
.done:
    RTS
.advance2:
    LDA     MOB_DATA_PTR                     ; \  CHAR_REC = MOB_DATA_PTR/MOB_DATA_PTR+1
    STA     CHAR_REC                     ;  | (advance to next record)
    LDA     MOB_DATA_PTR+1                     ;  |
    STA     CHAR_REC+1                     ; /
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
    LDA     DATA_PTR                     ; \
    CMP     #$00                    ;  | bail if DATA_PTR/DATA_PTR+1 is null
    BNE     .not_null               ;  |
    RTS                             ; /
.not_null:
    LDY     #$04                    ; \
    LDA     (TARGET_REC),Y                 ;  | bail if byte 4 of (TARGET_REC) >= $15
    CMP     #$15                    ;  |   ($15+ = inactive/dead)
    BCC     .ok                     ;  |
    RTS                             ; /
.ok:
    LDY     #$08                    ; \
    LDA     (DATA_PTR),Y                 ;  | group count (low nibble) += delta
    CLC                             ;  |
    ADC     GROUP_COUNT_DELTA       ;  |
    STA     (DATA_PTR),Y                 ; /
    RTS
    ORG     $1053
GET_CHAR_RECORD:
    SUBROUTINE

    TAX                             ; X = index (loop counter)
    LDA     #$00                    ; \
    STA     CHAR_REC                     ;  | CHAR_REC/CHAR_REC+1 = $4000 (base)
    LDA     #$40                    ;  |
    STA     CHAR_REC+1                     ; /
.loop:
    DEX
    BPL     .advance                ; more records to skip
    RTS                             ; done: CHAR_REC/CHAR_REC+1 points to record
.advance:
    CLC                             ; \
    LDA     CHAR_REC                     ;  | CHAR_REC/CHAR_REC+1 += 9
    ADC     #$09                    ;  | (9 bytes per record)
    STA     CHAR_REC                     ;  |
    LDA     CHAR_REC+1                     ;  |
    ADC     #$00                    ;  |
    STA     CHAR_REC+1                     ; /
    BNE     .loop                   ; always taken ($BF >= $40)
    ORG     $106F
APPLY_DAMAGE:
    SUBROUTINE
    ; Apply damage A to char at (EFFECT_REC).
    ; Subtracts from field 6 (HP). Displays damage message,
    ; runs script. If HP drops to 0: death handling.
    AND     #$1F
    STA     DAMAGE_AMOUNT               ; damage amount
    JSR     SET_CURSOR_ROW21
    LDA     DAMAGE_AMOUNT
    LDX     #$03
.ror_loop:
    INX
    CLC
    ROR
    BNE     .ror_loop           ; count leading zeros → message index
    TXA
    JSR     DISPLAY_MESSAGE     ; show damage message
    LDY     DAMAGE_AMOUNT
    LDX     #$04
    JSR     SCRIPT_ENGINE       ; run damage script
    LDY     #$06
    LDA     (EFFECT_REC),Y             ; field 6 (HP + flags)
    TAX
    AND     #$3F                ; HP only
    SEC
    SBC     DAMAGE_AMOUNT               ; HP - damage
    BCC     .dead               ; underflow → dead
    BEQ     .dead               ; zero → dead
    STA     DAMAGE_AMOUNT               ; new HP
    TXA
    AND     #$C0                ; preserve high bits
    ORA     DAMAGE_AMOUNT
    STA     (EFFECT_REC),Y             ; store updated field 6
    JSR     SET_CURSOR_ROW21
    LDA     DAMAGE_AMOUNT
    CMP     #$03
    BPL     .check8
    LDY     #$0F
    LDA     (EFFECT_REC),Y             ; field 15
    AND     #$F8
    ORA     #$04                ; set restricted flag
    STA     (EFFECT_REC),Y
    JSR     PRINT_ENTITY_NAME
    LDA     #$09
    JSR     DISPLAY_MESSAGE     ; "badly hurt" message
    RTS
.check8:
    CMP     #$08
    BPL     .ge8
    JSR     PRINT_ENTITY_NAME
    LDA     #$0A
    JMP     DISPLAY_MESSAGE     ; "wounded" message
.ge8:
    JSR     PRINT_ENTITY_NAME
    LDA     #$0B
    JMP     DISPLAY_MESSAGE     ; "scratched" message

    ; --- character dies ---
.dead:
    LDY     #$04
    LDA     (EFFECT_REC),Y             ; field 4
    LDX     #$08                ; default script
    CMP     #$15
    BCC     .skip_flag
    LDY     #$0F
    LDA     (EFFECT_REC),Y
    ORA     #$10                ; set death flag
    STA     (EFFECT_REC),Y
    LDX     #$0A                ; NPC death script
.skip_flag:
    TXA
    PHA
    JSR     PRINT_ENTITY_NAME
    LDA     #$03
    JSR     RANDOM_IN_RANGE     ; random(3)
    CMP     #$00
    BEQ     .rand0
    LDA     #$0E
    BNE     .show_death
.rand0:
    LDA     #$02
    JSR     RANDOM_IN_RANGE     ; random(2)
    CLC
    ADC     #$27                ; message $27 or $28
.show_death:
    JSR     DISPLAY_MESSAGE     ; death message
    PLA
    TAX
    JSR     SCRIPT_ENGINE       ; death script
    LDA     #$00
    STA     ACTIVE_CHAR
    LDA     CURRENT_PLAYER
    STA     SOURCE_CHAR
    LDA     EFFECT_REC
    STA     TARGET_REC
    LDA     EFFECT_REC+1
    STA     TARGET_REC+1
    JSR     REORDER_CHAR        ; cleanup
    LDY     #$0D
    LDA     (EFFECT_REC),Y             ; gold low
    STA     TARGET_REC
    INY
    LDA     (EFFECT_REC),Y             ; gold high
    STA     TARGET_REC+1
    LDY     #$00
    JSR     MODIFY_CHAR_STATS   ; subtract gold (Y=0 → subtract)
    LDY     #$03
    LDA     (EFFECT_REC),Y
    JSR     UPDATE_EVENT_LIST            ; handle death at position
    LDY     #$03
    LDA     (EFFECT_REC),Y
    JMP     DRAW_CHAR_AT_POS    ; redraw position
    ORG     $1142
PRINT_ENTITY_NAME:
    SUBROUTINE
    ; Print entity name: cursor to row 21, load name ptr from (EFFECT_REC)[0..1],
    ; print centered at bottom, then reset text window.
    JSR     SET_CURSOR_ROW21
    LDY     #$00
    LDA     (EFFECT_REC),Y             ; name pointer low
    STA     PRINT_STRING_ADDR
    INY
    LDA     (EFFECT_REC),Y             ; name pointer high
    STA     PRINT_STRING_ADDR+1
    JSR     PRINT_BOTTOM_CENTERED
    JMP     RESET_TEXT_WINDOW
    ORG     $1156
DRAW_CHAR_AT_POS:
    SUBROUTINE

    JSR     POS_TO_COLROW           ; A=pos → A=col, Y=row
    STA     FONT_COL                ; set font column
    STY     FONT_ROW                ; set font row
    JSR     COLROW_TO_POS           ; re-linearize (A = col + row*20)
    JSR     FIND_ENTITY_AT_POS      ; look up entity at position → ENTITY_REC
    JSR     GET_ENTITY_FONTCHAR     ; determine font char from entity data
    JMP     RENDER_FONT_CHAR        ; render the font character
    ORG     $116B
    SUBROUTINE
; Sets HANDLER_PTR/HANDLER_PTR+1 to handler address based on entity type at (ENTITY_REC)
CLASSIFY_ENTITY_TYPE:
    LDA     #$00
    CMP     ENTITY_REC+1
    BNE     .not_zero_page
    CMP     ENTITY_REC
    BNE     .type_C3
.type_E4:                      ; $1175 - reused by backward BMI from $1198
    LDA     #$E4
    STA     HANDLER_PTR
    LDA     #$7F
    STA     HANDLER_PTR+1
    RTS
.type_C3:                      ; $117E - reused by JMP from $11F9
    LDA     #$C3
    STA     HANDLER_PTR
    LDA     #$7F
    STA     HANDLER_PTR+1
    RTS
.not_zero_page:
    LDY     #$01
    LDA     (ENTITY_REC),Y
    BMI     .check_ranges
.type_FC:                      ; $118D - reused by backward BMI from $11F5
    LDA     #$FC
    STA     HANDLER_PTR
    LDA     #$7F
    STA     HANDLER_PTR+1
    RTS
.check_ranges:
    CMP     #$C0
    BMI     .type_E4
    CMP     #$D2
    BPL     .check_d5
    LDA     #$D3
    STA     HANDLER_PTR
    LDA     #$7F
    STA     HANDLER_PTR+1
    RTS
.check_d5:
    CMP     #$D5
    BPL     .check_fe
    LDA     #$16
    STA     HANDLER_PTR
    LDA     #$80
    STA     HANDLER_PTR+1
    RTS
.check_fe:
    CMP     #$FE
    BEQ     .type_fe_entry
    LDA     #$28
    STA     HANDLER_PTR
    LDA     #$80
    STA     HANDLER_PTR+1
    RTS
.type_fe_entry:
    LDY     #$02
    LDA     (ENTITY_REC),Y
    TAX
    AND     #$1F
    BNE     .check_c0_bits
    LDA     #$03
    STA     HANDLER_PTR
    LDA     #$80
    STA     HANDLER_PTR+1
    RTS
.check_c0_bits:
    TXA
    AND     #$C0
    CMP     #$C0
    BNE     .check_1b
.type_F0:                      ; $11DA - reused by backward BEQ from $11F7
    LDA     #$F0
    STA     HANDLER_PTR
    LDA     #$7F
    STA     HANDLER_PTR+1
    RTS
.check_1b:
    TXA
    AND     #$1F
    CMP     #$1B
    BPL     .check_1d
    LDA     #$CA
    STA     HANDLER_PTR
    LDA     #$7F
    STA     HANDLER_PTR+1
    RTS
.check_1d:
    CMP     #$1D
    BMI     .type_FC
    BEQ     .type_F0
    JMP     .type_C3
    ORG     $11FC
    SUBROUTINE
; Maps A to string table index, walks linked list from $803A
MAP_VALUE_TO_STRING:
    CMP     #$08
    BMI     .use_as_is
    CMP     #$10
    BPL     .high_range
    ROR
    AND     #$03
    ORA     #$08
    BNE     .use_as_is
.high_range:
    ROR
    ROR
    AND     #$03
    ORA     #$0C
.use_as_is:
    TAX
    LDA     #$3A
    STA     PRINT_STRING_ADDR
    LDA     #$80
    STA     PRINT_STRING_ADDR+1
    LDY     #$00
.loop:
    DEX
    BNE     .next
    JMP     PRINT_BOTTOM_CENTERED
.next:
    SEC
    LDA     (PRINT_STRING_ADDR),Y
    ADC     PRINT_STRING_ADDR
    STA     PRINT_STRING_ADDR
    LDA     #$00
    ADC     PRINT_STRING_ADDR+1
    STA     PRINT_STRING_ADDR+1
    BNE     .loop
    ORG     $1231
CHECK_CAN_LEAVE:
    SUBROUTINE
    ; Check hostility threshold: if PRNG_OUTPUT >= $40, show message $1C
    ; and return 1; else show message $1D and return 0.
    JSR     STEP_PRNG
    LDA     PRNG_OUTPUT
    CMP     #$40
    BPL     .pass
    JMP     .fail
.pass:
    JSR     SET_CURSOR_ROW21
    JSR     PRINT_MOB_NAME
    JSR     RESET_TEXT_WINDOW
    LDA     #$1C
    JSR     DISPLAY_MESSAGE
    LDA     #$01
    RTS
.fail:
    JSR     SET_CURSOR_ROW21
    JSR     PRINT_MOB_NAME
    JSR     RESET_TEXT_WINDOW
    LDA     #$1D
    JSR     DISPLAY_MESSAGE
    LDA     #$00
    RTS
    ORG     $1260
UPDATE_EVENT_LIST:
    SUBROUTINE
    ; Update event list for position A with value NUM_VALUE/NUM_VALUE+1.
    ; If NUM_VALUE/NUM_VALUE+1 = 0, return immediately.
    ; Scans 3-byte event entries at ($FA)[6..7]:
    ;   $FF = end of list → display message $2A
    ;   $FE = empty slot → insert new entry
    ;   matching pos + type $C0-$D0 → add to existing entry
    ;   else → advance to next entry
    STA     $BA                 ; save position
    LDA     #$00
    CMP     NUM_VALUE
    BNE     .has_value
    CMP     NUM_VALUE+1
    BNE     .has_value
    RTS
.has_value:
    LDY     #$06
    LDA     (CHAR_PTR),Y             ; event list pointer low
    STA     EVENT_PTR
    INY
    LDA     (CHAR_PTR),Y             ; event list pointer high
    STA     EVENT_PTR+1
.scan:
    LDY     #$00
    LDA     (EVENT_PTR),Y             ; entry byte 0 = position
    CMP     #$FF
    BNE     .not_end
    JSR     SET_CURSOR_ROW21
    LDA     #$2A
    JMP     DISPLAY_MESSAGE     ; "event list full" message
.not_end:
    CMP     #$FE
    BNE     .check_match
    ; Empty slot: insert new entry
    LDA     $BA
    STA     (EVENT_PTR),Y             ; byte 0 = position
    INY
    LDA     NUM_VALUE+1
    AND     #$07
    ORA     #$C0                ; byte 1 = type + high bits
    STA     (EVENT_PTR),Y
    INY
    LDA     NUM_VALUE
    STA     (EVENT_PTR),Y             ; byte 2 = value low
    RTS
.check_match:
    CMP     $BA                 ; same position?
    BNE     .next
    INY
    LDA     (EVENT_PTR),Y             ; byte 1 = type
    BPL     .next               ; not activated
    CMP     #$C0
    BMI     .next               ; below $C0
    CMP     #$D1
    BPL     .next               ; above $D0
    ; Add to existing entry
    CLC
    LDA     NUM_VALUE
    INY
    ADC     (EVENT_PTR),Y             ; byte 2 += value low
    STA     (EVENT_PTR),Y
    DEY
    LDA     NUM_VALUE+1
    AND     #$07
    ADC     (EVENT_PTR),Y             ; byte 1 += value high (with carry)
    STA     (EVENT_PTR),Y
    RTS
.next:
    CLC
    LDA     EVENT_PTR
    ADC     #$03                ; next 3-byte entry
    STA     EVENT_PTR
    BCC     .no_carry
    INC     EVENT_PTR+1
.no_carry:
    JMP     .scan
    ORG     $12D0
PICK_RANDOM_MEMBER:
    SUBROUTINE
    ; Pick a random eligible group member (field 4 in $00-$14 range)
    ; Uses ($FA)[8] as group size, calls RANDOM_IN_RANGE to pick Nth
.loop:
    LDY     #$08
    LDA     (CHAR_PTR),Y             ; group size
    BEQ     .zero               ; empty group
    JSR     RANDOM_IN_RANGE     ; random(size)
    CMP     #$00
    BEQ     .loop               ; 0 → retry
    TAX                         ; X = count down to Nth member
    JSR     FIRST_GROUP_MEMBER
.check:
    LDY     #$04
    LDA     (MOB_PTR),Y             ; member field 4
    BMI     .next               ; negative → skip
    CMP     #$15
    BPL     .next               ; >= $15 → skip
    DEX
    BNE     .next               ; not Nth yet
    RTS                         ; found: MOB_PTR/MOB_PTR+1 points to member
.next:
    JSR     NEXT_GROUP_MEMBER
    JMP     .check
.zero:
    STA     MOB_PTR                 ; clear pointer
    STA     MOB_PTR+1
    RTS
    ORG     $12FA
FIRST_GROUP_MEMBER:
    SUBROUTINE

    LDY     #$02                    ; \
    LDA     (CHAR_PTR),Y                 ;  | check byte 2 of group head ($FA)
    BNE     .resolve                ; /  if nonzero, follow it
NEXT_GROUP_MEMBER:
    LDY     #$02                    ; \
    LDA     (MOB_PTR),Y                 ;  | check byte 2 of cursor ($F4)
    BNE     .resolve                ; /  if nonzero, follow it
    STA     MOB_PTR                     ; \  end of chain:
    STA     MOB_PTR+1                     ; /  null out MOB_PTR/MOB_PTR+1
    RTS
.resolve:
    JSR     GET_MOB_DATA            ; resolve link -> MOB_DATA_PTR/MOB_DATA_PTR+1
    LDA     MOB_DATA_PTR                     ; \
    STA     MOB_PTR                     ;  | MOB_PTR/MOB_PTR+1 = MOB_DATA_PTR/MOB_DATA_PTR+1
    LDA     MOB_DATA_PTR+1                     ;  | (advance cursor to next record)
    STA     MOB_PTR+1                     ; /
    RTS
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
    ROL                       ;  | mask bits
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
    ROR                       ;  |
    BCC     .accept                 ; / (always taken: masked bit is 0)
    ORG     $138D
FIND_NEAREST_EVENT:
    SUBROUTINE
    ; Find nearest non-activated event (byte 1 < $C0) by Manhattan distance
    ; Returns position in A ($5A13)
    LDA     #$7F                ; initial min distance
    STA     NEAREST_DIST
    LDY     #$06
    LDA     (CHAR_PTR),Y             ; event list pointer low
    STA     EVENT_PTR
    INY
    LDA     (CHAR_PTR),Y             ; event list pointer high
    STA     EVENT_PTR+1
    JMP     .check_end
.eval:
    LDY     #$01
    LDA     (EVENT_PTR),Y             ; event byte 1 = type
    CMP     #$C0
    BCS     .advance            ; >= $C0 → activated, skip
    LDY     #$00
    LDA     (EVENT_PTR),Y             ; event byte 0 = position
    STA     $5A15
    JSR     MANHATTAN_DISTANCE            ; Manhattan distance
    CMP     NEAREST_DIST
    BPL     .advance            ; not closer
    STA     NEAREST_DIST               ; new minimum
    LDA     $5A15
    STA     $5A13               ; record position
.advance:
    LDA     EVENT_PTR
    CLC
    ADC     #$03                ; next 3-byte entry
    STA     EVENT_PTR
    BCC     .check_end
    INC     EVENT_PTR+1
.check_end:
    LDY     #$00
    LDA     (EVENT_PTR),Y
    CMP     #$FE                ; $FE = empty slot, skip
    BEQ     .advance
    CMP     #$FF                ; $FF = end of list
    BNE     .eval
    LDA     $5A13               ; return nearest position
    RTS
    ORG     $13DB
MANHATTAN_DISTANCE:
    SUBROUTINE
    ; Manhattan distance: |col(A) - col(char)| + |row(A) - row(char)|
    ; Input: A = packed position to measure from
    ; Uses char's position from (ENTITY_PTR)[3]
    JSR     POS_TO_COLROW       ; A → col in A, row in Y
    STA     FONT_COL            ; save target col
    STY     FONT_ROW            ; save target row
    LDY     #$03
    LDA     (ENTITY_PTR),Y             ; char packed position
    JSR     POS_TO_COLROW
    SEC
    SBC     FONT_COL            ; char col - target col
    BCS     .pos1
    EOR     #$FF                ; negate (absolute value)
    ADC     #$01
.pos1:
    STA     $BA                 ; |delta col|
    TYA
    SEC
    SBC     FONT_ROW            ; char row - target row
    BCS     .pos2
    EOR     #$FF
    ADC     #$01
.pos2:
    CLC
    ADC     $BA                 ; |delta col| + |delta row|
    RTS
    ORG     $1406
PRINT_MEMBER_NAME:
    SUBROUTINE
    ; Copy (MOB_PTR)[0..1] → PRINT_STRING_ADDR/PRINT_STRING_ADDR+1, then JMP $7705
    LDY     #$00
    LDA     (MOB_PTR),Y
    STA     PRINT_STRING_ADDR
    INY
    LDA     (MOB_PTR),Y
    STA     PRINT_STRING_ADDR+1
    JMP     PRINT_BOTTOM_CENTERED
    ORG     $1414
REORDER_CURRENT_CHAR:
    SUBROUTINE
    ; Copy ENTITY_PTR/ENTITY_PTR+1 → TARGET_REC/TARGET_REC+1, store CURRENT_PLAYER → SOURCE_CHAR, JMP $0F84
    LDA     ENTITY_PTR
    STA     TARGET_REC
    LDA     ENTITY_PTR+1
    STA     TARGET_REC+1
    LDA     CURRENT_PLAYER
    STA     SOURCE_CHAR
    JMP     REORDER_CHAR
    ORG     $1425
APPLY_DAMAGE_TO_CURRENT:
    SUBROUTINE
    ; Apply effect: copy ENTITY_PTR/ENTITY_PTR+1 → EFFECT_REC/EFFECT_REC+1, JMP $106F with A
    TAX
    LDA     ENTITY_PTR
    STA     EFFECT_REC
    LDA     ENTITY_PTR+1
    STA     EFFECT_REC+1
    TXA
    JMP     APPLY_DAMAGE
    ORG     $1432
    SUBROUTINE
; Copies MOB_PTR/MOB_PTR+1 -> EFFECT_REC/EFFECT_REC+1, then JMP APPLY_DAMAGE with A
COPY_F4_TO_F6_AND_SET:
    TAX
    LDA     MOB_PTR
    STA     EFFECT_REC
    LDA     MOB_PTR+1
    STA     EFFECT_REC+1
    TXA
    JMP     APPLY_DAMAGE
    ORG     $143F
AUTO_HEAL:
    SUBROUTINE
    ; Auto-heal: if HP < $28, randomly attempt healing via $1482.
    ; Loops while PRNG_OUTPUT >= $50 (still injured). Shows message $21
    ; if player heals for the first time.
    LDY     #$06
    LDA     (ENTITY_PTR),Y
    AND     #$3F
    CMP     #$28
    BMI     .do_heal
    RTS
.do_heal:
    LDA     #$01
    JSR     RANDOM_IN_RANGE
    CMP     #$00
    BNE     .start_heal
    RTS
.start_heal:
    LDA     #$00
    STA     HEAL_NOTIFIED
.heal_loop:
    JSR     INCREMENT_HP
    JSR     STEP_PRNG
    LDA     PRNG_OUTPUT
    CMP     #$50
    BPL     .heal_loop
    LDY     #$04
    LDA     (ENTITY_PTR),Y
    CMP     #$15
    BCC     .player
.done:
    RTS
.player:
    LDA     HEAL_NOTIFIED
    BNE     .done
    JSR     SET_CURSOR_ROW21
    JSR     PRINT_MOB_NAME
    JSR     RESET_TEXT_WINDOW
    LDA     #$21
    JMP     DISPLAY_MESSAGE
    ORG     $1482
INCREMENT_HP:
    SUBROUTINE
    LDY     #$06
    LDA     (ENTITY_PTR),Y
    CLC
    ADC     #$01
    STA     (ENTITY_PTR),Y
    AND     #$3F
    CMP     #$03
    BEQ     .notify
    RTS
.notify:
    JSR     SET_CURSOR_ROW21
    JSR     PRINT_MOB_NAME
    JSR     RESET_TEXT_WINDOW
    LDA     #$22
    STA     HEAL_NOTIFIED
    JMP     DISPLAY_MESSAGE
    ORG     $14A3
TURN_DISPATCH:
    SUBROUTINE
    LDA     CHAR_AI_MODE
    BEQ     .no_combat
    JSR     SELECT_COMBAT_TARGET
    CMP     #$02
    BEQ     ENTER_COMBAT_STATE
    BMI     START_COMBAT
    JMP     AUTO_HEAL
.no_combat:
    JMP     TEARDOWN_INPUT
    ORG     $14B7
ENTER_COMBAT_STATE:
    SUBROUTINE
    ; Check encounter, clear restricted flag, conditionally set it,
    ; then set char state to 2.
    JSR     CHECK_ENCOUNTER
    JSR     CLEAR_RESTRICTED
    LDA     #$02
    CMP     ENCOUNTER_RESULT
    BNE     .skip
    JSR     SET_RESTRICTED
.skip:
    LDA     #$02
    JSR     SET_CHAR_STATE
    RTS
    ORG     $14CD
START_COMBAT:
    SUBROUTINE
    ; Set char state to 3, call $199D, jump to combat logic at $15AB.
    LDA     #$03
    JSR     SET_CHAR_STATE
    JSR     LOAD_TARGET_PTR
    JMP     RESOLVE_ATTACK
    ORG     $15AB
RESOLVE_ATTACK:
    SUBROUTINE
    ; Combat willingness calculation and attack resolution.
    ; Computes willingness score in COMBAT_WILLINGNESS based on char/target stats,
    ; then rolls random to determine if attack occurs.
    JSR     SET_BLINK_TARGET
    LDA     IS_PLAYER_TURN
    CMP     #$01
    BNE     .not_player
    LDA     #$1C
    STA     COMBAT_WILLINGNESS
    JMP     .clamp_done
.not_player:
    LDY     #$0B
    LDA     (ENTITY_PTR),Y
    TAX
    AND     #$1F
    STA     COMBAT_WILLINGNESS
    TXA
    AND     #$20
    BEQ     .no_bit5
    TXA
    AND     #$EF
    STA     (ENTITY_PTR),Y
    LDA     #$18
    JSR     ADD_WILLINGNESS
.no_bit5:
    LDA     (MOB_PTR),Y
    TAY
    AND     #$40
    BEQ     .no_bit6
    LDA     #$FC
    JSR     ADD_WILLINGNESS
.no_bit6:
    TYA
    AND     #$80
    BEQ     .no_bit7
    LDA     #$08
    JSR     ADD_WILLINGNESS
.no_bit7:
    LDY     #$0F
    LDA     (MOB_PTR),Y
    TAX
    AND     #$04
    BEQ     .no_restrict
    LDA     #$06
    JSR     ADD_WILLINGNESS
.no_restrict:
    TXA
    AND     #$03
    CMP     #$01
    BPL     .ge1
    LDA     #$03
    JSR     ADD_WILLINGNESS
    JMP     .state_done
.ge1:
    BNE     .ne1
    LDA     #$FF
    JSR     ADD_WILLINGNESS
    JMP     .state_done
.ne1:
    CMP     #$03
    BNE     .state_done
    LDA     #$FD
    JSR     ADD_WILLINGNESS
.state_done:
    LDY     #$06
    LDA     (MOB_PTR),Y
    AND     #$3F
    CMP     #$03
    BCS     .hp_ok
    LDA     #$18
    JSR     ADD_WILLINGNESS
.hp_ok:
    LDY     #$03
    LDA     (ENTITY_PTR),Y
    CMP     (MOB_PTR),Y
    BNE     .diff_pos
    LDY     #$05
    LDA     (MOB_PTR),Y
    ROR
    AND     #$0F
    STA     $5A77
    LDA     (ENTITY_PTR),Y
    ROR
    AND     #$0F
    SEC
    SBC     $5A77
    JSR     ADD_WILLINGNESS
.diff_pos:
    LDA     COMBAT_WILLINGNESS
    BPL     .not_neg
    LDA     #$00
    STA     COMBAT_WILLINGNESS
    JMP     .clamp_done
.not_neg:
    CMP     #$1F
    BMI     .clamp_done
    LDA     #$1E
    STA     COMBAT_WILLINGNESS
.clamp_done:
    LDA     #$1F
    JSR     RANDOM_IN_RANGE
    CMP     COMBAT_WILLINGNESS
    BMI     .attack
    BEQ     .attack
    JSR     SET_CURSOR_ROW21
    JSR     PRINT_MOB_NAME
    JSR     RESET_TEXT_WINDOW
    LDA     #$D2
    STA     TARGET_REC
    LDA     #$7C
    STA     TARGET_REC+1
    JSR     PRINT_BOTTOM_CENTERED
    JSR     RESET_TEXT_WINDOW
    LDA     #$01
    CMP     IS_PLAYER_TURN
    BEQ     .is_player
    JSR     PRINT_MEMBER_NAME
.is_player:
    JSR     DELAY_WITH_ANIMATION
    RTS
.attack:
    LDA     IS_PLAYER_TURN
    BEQ     .mob_attack
    JMP     PLAYER_ATTACK
.mob_attack:
    JMP     MOB_ATTACK
    ORG     $169B
ADD_WILLINGNESS:
    SUBROUTINE
    CLC
    ADC     COMBAT_WILLINGNESS
    STA     COMBAT_WILLINGNESS
    RTS
    ORG     $16A3
SET_BLINK_TARGET:
    SUBROUTINE

    LDA     IS_PLAYER_TURN
    CMP     #$01
    BEQ     .player

    ; --- mob path: convert packed position to col/row ---
    LDY     #$03
    LDA     (MOB_PTR),Y                 ; mob data[3] = packed position
    JSR     POS_TO_COLROW           ; A=col, Y=row
    STA     BLINK_COL
    STY     BLINK_ROW
    LDY     #$04
    LDA     (MOB_PTR),Y                 ; mob data[4] = appearance
    JSR     APPEARANCE_TO_FONTCHAR  ; appearance → font char number
    STA     BLINK_CHAR
    RTS

    ; --- player path: col/row already separate ---
.player:
    LDA     CURRENT_COL             ; player font column
    STA     BLINK_COL
    LDA     CURRENT_ROW             ; player font row
    STA     BLINK_ROW
    LDA     MOB_PTR                     ; \
    STA     ENTITY_REC                     ;  | copy pointer MOB_PTR → ENTITY_REC
    LDA     MOB_PTR+1                     ;  |
    STA     ENTITY_REC+1                     ; /
    JSR     GET_ENTITY_FONTCHAR     ; look up player's font char
    LDA     FONT_CHARNUM
    STA     BLINK_CHAR
    RTS
    ORG     $16E0
    SUBROUTINE
; Calculates combat strength using RANDOM_IN_RANGE
CALC_COMBAT_STRENGTH:
    LDA     IS_PLAYER_TURN
    CMP     #$01
    BEQ     .use_y7
    LDY     #$03
    LDA     (MOB_PTR),Y
    CMP     (ENTITY_PTR),Y
    BNE     .use_y7
    LDY     #$09
    BNE     .got_y
.use_y7:
    LDY     #$07
.got_y:
    TYA
    PHA
    LDA     (ENTITY_PTR),Y
    AND     #$0F
    TAX
    JSR     RANDOM_IN_RANGE
    STA     COMBAT_STRENGTH
    TXA
    JSR     RANDOM_IN_RANGE
    SEC
    ADC     COMBAT_STRENGTH
    STA     COMBAT_STRENGTH
    LDA     CHAR_AI_MODE
    BEQ     .check_5a74
.exit_pla:                     ; $1712 - reused by backward BNE from $1717
    PLA
    RTS
.check_5a74:
    LDA     IS_PLAYER_TURN
    BNE     .exit_pla
    PLA
    TAY
    TAX
    LDA     (ENTITY_PTR),Y
    AND     #$80
    BNE     .use_50
    LDA     #$0D
    BNE     .do_random
.use_50:
    LDA     #$50
.do_random:
    JSR     RANDOM_IN_RANGE
    CMP     #$00
    BEQ     .missed
    RTS
.missed:
    TXA
    TAY
    LDA     #$81
    STA     (ENTITY_PTR),Y
    JSR     SET_CURSOR_ROW21
    LDA     #$01
    JSR     SCENE_LOOP
    LDA     #$0A
    JSR     RANDOM_IN_RANGE
    SEC
    ADC     COMBAT_STRENGTH
    CMP     #$1F
    BCC     .cap_ok
    LDA     #$1F
.cap_ok:
    STA     COMBAT_STRENGTH
    RTS
    ORG     $1751
PLAYER_ATTACK:
    SUBROUTINE
    JSR     CALC_COMBAT_STRENGTH
    JSR     SET_CURSOR_ROW21
    JSR     PRINT_MOB_NAME
    JSR     RESET_TEXT_WINDOW
    LDA     COMBAT_STRENGTH
    JSR     MAP_VALUE_TO_STRING
    JSR     RESET_TEXT_WINDOW
    LDA     MOB_PTR
    STA     ENTITY_REC
    LDA     MOB_PTR+1
    STA     ENTITY_REC+1
    JSR     CLASSIFY_ENTITY_TYPE
    JSR     PRINT_BOTTOM_CENTERED
    LDY     COMBAT_STRENGTH
    LDX     #$02
    JSR     SCRIPT_ENGINE
    LDY     #$01
    LDA     (MOB_PTR),Y
    CMP     #$FE
    BEQ     .check_event
    CMP     #$40
    BCC     .roll_hit
.immune:
    JSR     DISPATCH_ON_MODE
    JSR     RESET_TEXT_WINDOW
    LDA     #$14
    JMP     DISPLAY_MESSAGE
.roll_hit:
    LDA     #$0D
    JSR     RANDOM_IN_RANGE
    CMP     COMBAT_STRENGTH
    BCS     .immune
    JSR     DISPATCH_ON_MODE
    LDY     #$01
    LDA     (ENTITY_REC),Y
    ORA     #$40
    STA     (ENTITY_REC),Y
    DEY
    LDA     (ENTITY_REC),Y
    JSR     POS_TO_COLROW
    STY     FONT_ROW
    STA     FONT_COL
    JSR     GET_ENTITY_FONTCHAR
    JSR     RENDER_FONT_CHAR
    LDX     #$0C
    JSR     SCRIPT_ENGINE
    JSR     SET_CURSOR_ROW21
    LDA     #$02
    JMP     DISPLAY_MESSAGE
.check_event:
    LDY     #$02
    LDA     (MOB_PTR),Y
    TAX
    AND     #$C0
    CMP     #$C0
    BNE     .check_type
    TXA
    AND     #$1F
    CMP     #$1D
    BPL     .immune
    JSR     PROCESS_ENTITY_SCRIPT
    JSR     SET_CURSOR_ROW21
    LDA     #$02
    JMP     SCENE_LOOP
.check_type:
    CMP     #$00
    BEQ     .immune
    LDA     COMBAT_STRENGTH
    CMP     #$0A
    BPL     .strong_enough
    TXA
    CMP     #$80
    BPL     .blocked
    LDA     COMBAT_STRENGTH
    CMP     #$04
    BMI     .blocked
.strong_enough:
    TXA
    AND     #$1F
    CMP     #$1F
    BMI     .take_item
    STX     $BA
    DEC     $BA
    LDA     $BA
    LDY     #$02
    STA     (MOB_PTR),Y
    LDX     #$0E
    JSR     SCRIPT_ENGINE
    JSR     DISPATCH_ON_MODE
    LDY     #$00
    LDA     (MOB_PTR),Y
    JSR     DRAW_CHAR_AT_POS
    JSR     SET_CURSOR_ROW21
.show_found:
    LDA     #$12
    JSR     DISPLAY_MESSAGE
    JMP     EVENT_PRNG_CHECK
.take_item:
    JSR     PROCESS_ENTITY_SCRIPT
    JSR     SET_CURSOR_ROW21
    LDY     #$02
    LDA     (MOB_PTR),Y
    AND     #$1F
    CMP     #$1B
    BPL     .show_found
    LDA     #$03
    JSR     SCENE_LOOP
    JMP     EVENT_PRNG_CHECK
.blocked:
    JSR     DISPATCH_ON_MODE
    JSR     SET_CURSOR_ROW21
    LDA     #$10
    JMP     DISPLAY_MESSAGE
    ORG     $1849
    SUBROUTINE
; Saves entity char, marks as $FE, runs script $0E, dispatches, restores
PROCESS_ENTITY_SCRIPT:
    LDY     #$00
    LDA     (MOB_PTR),Y
    STA     $BA
    LDA     #$FE
    STA     (MOB_PTR),Y
    LDX     #$0E
    JSR     SCRIPT_ENGINE
    JSR     DISPATCH_ON_MODE
    LDA     $BA
    JMP     DRAW_CHAR_AT_POS
    ORG     $1860
MOB_ATTACK:
    SUBROUTINE
    JSR     CALC_COMBAT_STRENGTH
    JSR     SET_CURSOR_ROW21
    JSR     PRINT_MOB_NAME
    JSR     RESET_TEXT_WINDOW
    LDA     COMBAT_STRENGTH
    JSR     MAP_VALUE_TO_STRING
    JSR     RESET_TEXT_WINDOW
    JSR     PRINT_MEMBER_NAME
    LDY     COMBAT_STRENGTH
    LDX     #$02
    JSR     SCRIPT_ENGINE
    LDY     #$04
    LDA     (ENTITY_PTR),Y
    CMP     #$15
    BCS     .npc
    LDA     #$00
    STA     SCENE_COMBAT_FLAG
.npc:
    JSR     DISPATCH_ON_MODE
    LDY     #$08
    LDA     (MOB_PTR),Y
    STA     MOB_DEFENSE
    AND     #$0F
    CMP     #$00
    BNE     .has_strength
    LDA     COMBAT_STRENGTH
    JMP     COPY_F4_TO_F6_AND_SET
.has_strength:
    JSR     RESET_TEXT_WINDOW
    LDX     #$17
    LDA     MOB_DEFENSE
    BMI     .negative
    LDX     #$18
.negative:
    LDA     MOB_DEFENSE
    AND     #$0F
    STA     MOB_DEFENSE
    LDA     COMBAT_STRENGTH
    SEC
    SBC     MOB_DEFENSE
    BEQ     .weak_hit
    BPL     .partial
.weak_hit:
    INX
    INX
    LDY     #$06
    LDA     (MOB_PTR),Y
    AND     #$3F
    CMP     #$03
    BMI     .critical
    TXA
    JMP     DISPLAY_MESSAGE
.critical:
    LDA     #$34
    JMP     DISPLAY_MESSAGE
.partial:
    STA     COMBAT_STRENGTH
    TXA
    JSR     DISPLAY_MESSAGE
    LDA     COMBAT_STRENGTH
    JMP     COPY_F4_TO_F6_AND_SET
    ORG     $18E4
    SUBROUTINE
; Selects combat target based on CHAR_AI_MODE (3 paths: <3, 3-4, >=5)
SELECT_COMBAT_TARGET:
    LDA     CHAR_AI_MODE
    CMP     #$03
    BMI     .path_low
    CMP     #$05
    BMI     .path_mid
    JSR     FIRST_GROUP_MEMBER
    LDA     #$00
    STA     BEST_THREAT
.loop_high:
    JSR     GET_ENTITY_THREAT
    CMP     #$00
    BEQ     .skip_high
    LDY     #$05
    LDA     (MOB_PTR),Y
    AND     #$1F
    CMP     BEST_THREAT
    BMI     .skip_high
    STA     BEST_THREAT
    LDA     MOB_PTR
    STA     TARGET_PTR_LO
    LDA     MOB_PTR+1
    STA     TARGET_PTR_HI
.skip_high:
    JSR     NEXT_GROUP_MEMBER
    LDA     #$00
    CMP     MOB_PTR+1
    BNE     .loop_high
    CMP     BEST_THREAT
    BEQ     .path_low
    LDA     #$01
    RTS
.path_low:
    LDA     #$00
    CMP     STEPS_TAKEN
    BNE     .ret_2
    LDY     #$03
    LDA     (ENTITY_PTR),Y
    JSR     CHECK_ENCOUNTER
    LDA     #$02
    CMP     ENCOUNTER_RESULT
    BEQ     .ret_2
    JSR     CHECK_THREATS_HERE
    CMP     #$01
    BNE     .ret_2
    LDA     #$04
    RTS
.ret_2:
    LDA     #$02
    RTS
.path_mid:
    LDA     #$00
    STA     BEST_THREAT
    JSR     FIRST_GROUP_MEMBER
.loop_mid:
    JSR     GET_ENTITY_THREAT
    CMP     BEST_THREAT
    BEQ     .skip_mid
    BMI     .skip_mid
    STA     BEST_THREAT
    LDA     MOB_PTR
    STA     TARGET_PTR_LO
    LDA     MOB_PTR+1
    STA     TARGET_PTR_HI
.skip_mid:
    JSR     NEXT_GROUP_MEMBER
    LDA     #$00
    CMP     MOB_PTR+1
    BNE     .loop_mid
    CMP     BEST_THREAT
    BEQ     .path_low
    LDA     #$01
    RTS
    ORG     $1979
GET_ENTITY_THREAT:
    ORG     $199D
LOAD_TARGET_PTR:
    SUBROUTINE
    LDA     TARGET_PTR_LO
    STA     MOB_PTR
    LDA     TARGET_PTR_HI
    STA     MOB_PTR+1
    LDA     #$00
    STA     IS_PLAYER_TURN
    RTS
    ORG     $19AD
GAME_TURN_LOOP:
    SUBROUTINE

    ; --- setup: save position, clear flags ---
    LDA     #$01
    STA     TURN_ACTIVE
    LDY     #$03
    LDA     (ENTITY_PTR),Y             ; char field 3 = packed position
    JSR     POS_TO_COLROW
    STA     CURRENT_COL
    STA     TURN_START_COL
    STY     CURRENT_ROW
    STY     TURN_START_ROW
    LDA     #$00
    STA     STEPS_TAKEN
    JSR     CLEAR_RESTRICTED            ; clear restricted flag (bit 2 of field 15)

    ; --- check constitution and encounters ---
    LDY     #$06
    LDA     (ENTITY_PTR),Y             ; char field 6 (constitution/HP)
    AND     #$3F
    CMP     #$03
    BPL     .con_ok
    JSR     SET_RESTRICTED            ; set restricted (too weak)
.con_ok:
    LDY     #$03
    LDA     (ENTITY_PTR),Y
    JSR     CHECK_ENCOUNTER
    LDA     ENCOUNTER_RESULT
    CMP     #$02
    BNE     .enc_ok
    JSR     SET_RESTRICTED            ; set restricted (hostile territory)
.enc_ok:
    LDA     CHAR_AI_MODE
    BEQ     .get_speed
    JSR     AI_CHOOSE_TARGET    ; NPC: pick a destination

    ; --- determine movement points ---
.get_speed:
    LDY     #$0C
    LDA     (ENTITY_PTR),Y             ; char field 12
    AND     #$0F                ; low nibble = speed
    STA     MOVE_POINTS

    ; --- adjust points based on threats ---
    LDA     ENCOUNTER_RESULT
    CMP     #$02
    BEQ     .chk_limit          ; hostile → check if enough to limit
    JSR     CHECK_THREATS_HERE            ; check adjacent threats
    CMP     #$01
    BEQ     .move_loop          ; exactly 1 threat → keep full
    LDA     MOVE_POINTS
    CMP     #$02
    BCC     .move_loop          ; < 2 points → keep as is
    JSR     RANDOM_IN_RANGE     ; random(move_points)
    CMP     #$00
    BEQ     .do_limit           ; random == 0 → force limit
    STA     MOVE_POINTS         ; reduce randomly
    BNE     .move_loop
.chk_limit:
    LDA     MOVE_POINTS
    CMP     #$02
    BCC     .move_loop          ; < 2 → use as is
.do_limit:
    LDA     #$01
    JSR     RANDOM_IN_RANGE     ; random(1) → 0 or 1
    CLC
    ADC     #$01                ; 1 or 2
    STA     MOVE_POINTS
    BNE     .move_loop          ; always

    ; === MOVEMENT LOOP ===
MOVE_LOOP:                     ; $1A31 - external entry point
.move_loop:
    LDA     #$00
    CMP     MOVE_POINTS
    BNE     .has_points
    CMP     STEPS_TAKEN
    BNE     .end_turn           ; out of points, took steps → done
    CMP     CHAR_AI_MODE
    BEQ     .has_points         ; player with 0 points, 0 steps → still prompt
.end_turn:
    JMP     END_TURN            ; end turn

.has_points:
    CMP     CHAR_AI_MODE
    BEQ     .player_input
    JSR     NPC_MOVE_AI            ; NPC movement AI
    JMP     .dispatch_cmd

    ; --- player input ---
.player_input:
    JSR     CONFIGURE_INPUT            ; set up input UI
    LDA     GAME_INPUT_TABLE+4  ; check if movement enabled
    BNE     .have_input
    JMP     TEARDOWN_INPUT            ; no input → exit
.have_input:
    JSR     GET_INPUT_TABLE_PTR
    JSR     SETUP_INPUT
    JSR     $A44C               ; resident: read keyboard
    STA     INPUT_DIR
    CMP     #$00
    BNE     .do_move            ; player goes straight to movement
    JMP     TEARDOWN_INPUT            ; cancelled

    ; --- NPC command dispatch (player skips this) ---
.dispatch_cmd:
    STA     INPUT_DIR
    CMP     #$05
    BCC     .do_move            ; 1-4: movement direction
    BNE     .not_pass
    JMP     .move_loop          ; 5: pass
.not_pass:
    CMP     #$09
    BNE     .not_fight
    JSR     SET_RESTRICTED            ; 9: fight → set restricted
    LDA     #$00
    JSR     SET_CHAR_STATE
    JMP     AUTO_HEAL
.not_fight:
    PHA
    JSR     CHECK_AND_RESTRICT            ; re-check encounter
    PLA
    CMP     #$07
    BNE     .not_cmd7
    JMP     ENTER_COMBAT_STATE            ; 7: action
.not_cmd7:
    BCS     .cmd8
    JMP     START_COMBAT            ; 6: action
.cmd8:
    JMP     SET_STATE_FIGHT            ; 8: set state 1

    ; --- apply movement direction ---
.do_move:
    LDA     ENCOUNTER_RESULT
    CMP     #$02
    BMI     .move_ok
    JSR     CHECK_CAN_LEAVE            ; can we leave hostile zone?
    CMP     #$01
    BEQ     .move_ok
    JMP     END_TURN            ; blocked → end turn
.move_ok:
    LDA     #$00
    STA     ENCOUNTER_RESULT
    LDA     INPUT_DIR
    DEC     MOVE_POINTS
    INC     STEPS_TAKEN
    CMP     #$02
    BPL     .not_north
    DEC     CURRENT_ROW         ; 1: north
    JMP     .check_dest
.not_north:
    BNE     .not_south
    INC     CURRENT_ROW         ; 2: south
    JMP     .check_dest
.not_south:
    CMP     #$03
    BNE     .go_east
    DEC     CURRENT_COL         ; 3: west
    JMP     .check_dest
.go_east:
    INC     CURRENT_COL         ; 4: east

    ; --- check what's at the destination ---
.check_dest:
    LDA     CURRENT_COL
    LDY     CURRENT_ROW
    JSR     COLROW_TO_POS
    JSR     FIND_ENTITY_AT_POS  ; → ENTITY_REC/ENTITY_REC+1
    LDA     #$00
    CMP     ENTITY_REC+1
    BNE     .something          ; ENTITY_REC+1 != 0 → occupied
    CMP     ENTITY_REC
    BEQ     .empty              ; ENTITY_REC == 0 → empty cell
    LDX     #$0E
    JSR     SCRIPT_ENGINE       ; display blocked message?
    JMP     SHOW_LOCKED_MSG

.empty:
    JSR     COMMIT_MOVE            ; commit move (update pos, draw sprite)
    JSR     CHECK_THREATS_HERE            ; check adjacent threats
    CMP     #$00
    BNE     .keep_moving        ; threats remain → continue
    STA     MOVE_POINTS         ; no threats → stop
    STA     TURN_ACTIVE
.keep_moving:
    JMP     .move_loop

    ; --- destination occupied: dispatch by type ---
.something:
    LDA     ENTITY_REC+1
    CMP     #$80
    BMI     .event              ; ENTITY_REC+1 < $80 → event entry
    JMP     HANDLE_MOB_ENCOUNTER            ; ENTITY_REC+1 >= $80 → mob encounter

.event:
    LDY     #$01
    LDA     (ENTITY_REC),Y             ; event byte 1
    TAX
    AND     #$C0
    CMP     #$C0
    BEQ     .activated
    JMP     HANDLE_ENCOUNTER    ; non-activated → encounter

.activated:
    TXA
    CMP     #$D2
    BPL     .not_treasure
    JMP     PICKUP_TREASURE     ; $C0-$D1: treasure

.not_treasure:
    CMP     #$D5
    BPL     .not_scene
    JMP     TRIGGER_SCENE_EVENT ; $D2-$D4: scene event

.not_scene:
    CMP     #$DB
    BPL     .not_map_event
    PSHW    ENTITY_REC                 ; $D5-$DA: save ENTITY_REC/ENTITY_REC+1
    JSR     COMMIT_MOVE            ; commit move first
    PULW    ENTITY_REC                 ; restore ENTITY_REC/ENTITY_REC+1
    JMP     DISPLAY_SHOP

.not_map_event:
    CMP     #$FE
    BEQ     .empty_slot
    JMP     TEARDOWN_INPUT            ; $DB-$FD: unknown

.empty_slot:
    JMP     HANDLE_EVENT_SLOT            ; $FE: empty slot interaction
    ORG     $1B52
COMMIT_MOVE:
    SUBROUTINE
    ; Commit move: store CURRENT_COL/ROW, convert to packed pos,
    ; update char field 3, set font char, draw sprite
    LDA     CURRENT_COL
    STA     FONT_COL
    STA     BLINK_COL
    LDY     CURRENT_ROW
    STY     FONT_ROW
    STY     BLINK_ROW
    JSR     COLROW_TO_POS
    LDY     #$03
    STA     (ENTITY_PTR),Y             ; update char packed position
    LDA     CHAR_SPRITE
    STA     FONT_CHARNUM
    STA     BLINK_CHAR
    LDA     #$01
    STA     FONT_CHARSET
    JSR     RENDER_FONT_CHAR       ; draw sprite
    LDX     #$16
    STX     TURN_SCRIPT_GUARD
    ; falls through to RESET_TURN_POS
RESET_TURN_POS:
    ; Reset to turn start: convert start col/row to packed pos,
    ; call $1156, update current→start, conditionally run script
    LDA     TURN_START_COL
    LDY     TURN_START_ROW
    JSR     COLROW_TO_POS
    JSR     DRAW_CHAR_AT_POS
    LDA     CURRENT_COL
    STA     TURN_START_COL
    LDA     CURRENT_ROW
    STA     TURN_START_ROW
    LDX     TURN_SCRIPT_GUARD
    CPX     #$16
    BEQ     .run_script
    RTS
.run_script:
    DEC     TURN_SCRIPT_GUARD
    JMP     SCRIPT_ENGINE
    ORG     $1BA7
END_TURN:
    SUBROUTINE
    ; End turn: clear TURN_ACTIVE, check encounter, compare level vs STEPS_TAKEN
    LDA     #$00
    STA     TURN_ACTIVE
    JSR     CHECK_AND_RESTRICT
    LDA     STEPS_TAKEN
    BNE     .check_level
    JMP     TURN_DISPATCH
.check_level:
    LDY     #$0C
    LDA     (ENTITY_PTR),Y
    ROR
    AND     #$07
    CMP     STEPS_TAKEN
    BMI     .too_low
    JMP     TURN_DISPATCH
.too_low:
    ORG     $1BC6
SET_STATE_FIGHT:
    SUBROUTINE
    ; Set char field 15 state to 1
    LDA     #$01
    JMP     SET_CHAR_STATE
    ORG     $1BCB
CHECK_AND_RESTRICT:
    SUBROUTINE
    ; Check encounter at char position, clear restricted flag,
    ; set it if encounter type is 2.
    LDY     #$03
    LDA     (ENTITY_PTR),Y
    JSR     CHECK_ENCOUNTER
    JSR     CLEAR_RESTRICTED
    LDA     ENCOUNTER_RESULT
    CMP     #$02
    BNE     .done
    JSR     SET_RESTRICTED
.done:
    RTS
    ORG     $1BE0
SET_CHAR_STATE:
    SUBROUTINE
    ; Set char field 15 low 2 bits to A
    STA     $5A60
    LDY     #$0F
    LDA     (ENTITY_PTR),Y
    AND     #$FC                ; clear low 2 bits
    ORA     $5A60               ; set to new value
    STA     (ENTITY_PTR),Y
    RTS
    ORG     $1BEF
CLEAR_RESTRICTED:
    SUBROUTINE
    ; Clear restricted flag (bit 2 of char field 15)
    LDY     #$0F
    LDA     (ENTITY_PTR),Y
    AND     #$FB
    STA     (ENTITY_PTR),Y
    RTS
    ORG     $1BF8
SET_RESTRICTED:
    SUBROUTINE
    ; Set restricted flag (bit 2 of char field 15)
    LDY     #$0F
    LDA     (ENTITY_PTR),Y
    ORA     #$04
    STA     (ENTITY_PTR),Y
    RTS
    ORG     $1C01
HANDLE_ENCOUNTER:
    SUBROUTINE

    ; --- random encounter path (event type $00-$3F) ---
    LDA     #$00
    JSR     SET_CHAR_STATE            ; set char field 15 state to 0
    LDY     #$01
    LDA     (EVENT_PTR),Y             ; event byte 1 = type
    CMP     #$40
    BPL     .specific           ; type >= $40 → specific encounter
    LDA     #$14
    JSR     RANDOM_IN_RANGE     ; random(20)
    STA     PRNG_OUTPUT
    LDY     #$05
    LDA     (ENTITY_PTR),Y             ; char field 5
    AND     #$1F                ; low 5 bits = avoidance stat
    CMP     PRNG_OUTPUT
    BMI     .roll_type          ; stat < random → encounter happens
    JMP     .avoided            ; stat >= random → avoid encounter
.roll_type:
    JSR     STEP_PRNG
    LDA     #$74
    CMP     PRNG_OUTPUT
    BPL     .normal             ; $74 >= random → normal encounter
    JMP     .special            ; rare: special encounter
.normal:
    JSR     SET_CURSOR_ROW21
    LDA     #$01
    JSR     DISPLAY_MESSAGE     ; "encounter" message
    LDX     #$14
    JMP     SCRIPT_ENGINE       ; run encounter script

    ; --- specific encounter path (type >= $40) ---
.specific:
    LDY     #$00
    LDA     (EVENT_PTR),Y             ; event byte 0 = position
    STA     EVENT_POS
    LDA     #$01
    JSR     SET_CHAR_STATE            ; set state 1
    LDY     #$01
    LDA     (EVENT_PTR),Y
    AND     #$3F                ; low 6 bits = encounter ID
    BNE     .have_id
    JSR     STEP_PRNG           ; ID 0 → derive from PRNG
    LDA     PRNG_OUTPUT
    ROR
    ROR
    AND     #$1C
    ORA     #$01
.have_id:
    STA     ACTIVE_CHAR               ; store encounter ID
    ROR
    BCC     .no_clear
    LDY     #$04
    LDA     (ENTITY_PTR),Y             ; char field 4
    BMI     .no_clear
    CMP     #$2A
    BMI     .no_clear
    CMP     #$3F
    BPL     .no_clear
    LDA     #$00
    STA     ACTIVE_CHAR               ; clear ID if char in range $2A-$3E
.no_clear:
    LDY     #$02
    LDA     (EVENT_PTR),Y             ; event byte 2 = destination pos
    STA     EVENT_DEST_POS
    JSR     COMMIT_MOVE            ; commit move
    LDA     $7ABE
    STA     WAIT_LOOP_COUNT
    JSR     REORDER_CURRENT_CHAR
    JSR     TIMED_WAIT
    LDY     #$03
    LDA     EVENT_DEST_POS
    STA     (ENTITY_PTR),Y             ; update char packed position
    LDA     ACTIVE_CHAR
    CMP     CURRENT_PLAYER               ; compare encounter ID with current scene
    BEQ     .same_scene
    JMP     RESET_TURN_POS            ; different → reset position
.same_scene:
    LDA     EVENT_DEST_POS
    JSR     POS_TO_COLROW
    STA     CURRENT_COL
    STY     CURRENT_ROW
    JMP     COMMIT_MOVE            ; commit to new position

    ; --- encounter avoided ---
.avoided:
    LDY     #$01
    LDA     (EVENT_PTR),Y
    ORA     #$40                ; mark event as activated
    STA     (EVENT_PTR),Y
    LDA     CURRENT_COL
    STA     TURN_START_COL
    LDA     CURRENT_ROW
    STA     TURN_START_ROW
    JSR     RESET_TURN_POS            ; reset to turn start
    LDA     TURN_START_COL
    STA     BLINK_COL
    LDA     TURN_START_ROW
    STA     BLINK_ROW
    LDA     FONT_CHARNUM
    STA     BLINK_CHAR
    LDX     #$0C
    JSR     SCRIPT_ENGINE       ; run "avoided" script
    JSR     SET_CURSOR_ROW21
    LDA     #$02
    JMP     DISPLAY_MESSAGE     ; "avoided encounter" message

    ; --- special encounter (rare) ---
.special:
    JSR     SET_CURSOR_ROW21
    LDA     #$09
    JSR     SCENE_LOOP          ; trigger scene 9
    LDA     #$01
    JMP     APPLY_DAMAGE_TO_CURRENT
    ORG     $1CF1
SHOW_LOCKED_MSG:
    SUBROUTINE
    ; Display message $0C and set char state to 0.
    JSR     SET_CURSOR_ROW21
    JSR     PRINT_MOB_NAME
    JSR     RESET_TEXT_WINDOW
    LDA     #$0C
    JSR     DISPLAY_MESSAGE
    LDA     #$00
    JMP     SET_CHAR_STATE
    ORG     $1D04
TRIGGER_SCENE_EVENT:
    SUBROUTINE

    LDA     #$00
    JSR     SET_CHAR_STATE            ; set char field 15 state to 0
    LDA     EVENT_PTR
    STA     $5A5B               ; save event pointer low
    LDA     EVENT_PTR+1
    STA     $5A5C               ; save event pointer high
    JSR     COMMIT_MOVE            ; commit move
    LDA     $5A5B
    STA     EVENT_PTR                 ; restore event pointer
    LDA     $5A5C
    STA     EVENT_PTR+1
    LDY     #$02
    LDA     (EVENT_PTR),Y             ; event byte 2 = scene index
    JSR     SCENE_LOOP          ; trigger scene
    LDY     #$01
    LDA     (EVENT_PTR),Y             ; event byte 1 = type
    CMP     #$D3
    BPL     .d3_or_above
    RTS                         ; $D2: trigger scene only
.d3_or_above:
    BNE     .d4
    LDA     #$FE                ; $D3: mark event as empty
    DEY
    STA     (EVENT_PTR),Y
    RTS
.d4:
    LDA     #$FE                ; $D4: mark event as empty
    DEY
    STA     (EVENT_PTR),Y
    LDA     #$0F
    JSR     SCENE_LOOP          ; trigger bonus scene $0F
    LDA     #$03
    JSR     RANDOM_IN_RANGE     ; random(3)
    CLC
    ADC     #$01                ; 1-3
    JMP     APPLY_DAMAGE_TO_CURRENT            ; apply effect to char
    ORG     $1D4D
HANDLE_EVENT_SLOT:
    SUBROUTINE
    ; Handle empty slot interaction: treasure pickup, traps,
    ; and event activation.
    LDA     #$00
    JSR     SET_CHAR_STATE
    LDY     #$02
    LDA     (EVENT_PTR),Y
    STA     EVENT_SLOT_BYTE
    AND     #$C0
    CMP     #$C0
    BNE     .not_active
    LDA     (EVENT_PTR),Y
    AND     #$1F
    TAX
    CMP     #$1D
    BPL     .no_remove
    LDY     #$00
    LDA     #$FE
    STA     (EVENT_PTR),Y
    TXA
    CMP     #$00
    BEQ     .no_remove
    LDA     #$0A
    JSR     SCENE_LOOP
.no_remove:
    JSR     COMMIT_MOVE
    JSR     CHECK_THREATS_HERE
    CMP     #$00
    BNE     .has_threat
    STA     MOVE_POINTS
.has_threat:
    JMP     MOVE_LOOP
.not_active:
    PHA
    LDX     #$0E
    JSR     SCRIPT_ENGINE
    PLA
    CMP     #$00
    BNE     .has_type
    LDA     EVENT_SLOT_BYTE
    AND     #$1F
    CMP     #$1B
    BMI     .small_val
    JMP     SHOW_LOCKED_MSG
.small_val:
    JSR     SET_CURSOR_ROW21
    JSR     PRINT_MOB_NAME
    JSR     RESET_TEXT_WINDOW
    LDA     #$0D
    JSR     DISPLAY_MESSAGE
    LDA     #$01
    JMP     APPLY_DAMAGE_TO_CURRENT
.has_type:
    CMP     #$40
    BEQ     .type40
    LDA     #$19
    JSR     RANDOM_IN_RANGE
    STA     PRNG_OUTPUT
    LDY     #$05
    LDA     (ENTITY_PTR),Y
    AND     #$1F
    CMP     PRNG_OUTPUT
    BPL     .type40
    JSR     SET_CURSOR_ROW21
    LDA     #$10
    JSR     DISPLAY_MESSAGE
    LDY     #$02
    LDA     EVENT_SLOT_BYTE
    AND     #$3F
    ORA     #$40
    STA     (EVENT_PTR),Y
EVENT_PRNG_CHECK:              ; $1DDC - external entry point
    JSR     STEP_PRNG
    LDA     PRNG_OUTPUT
    CMP     #$14
    BMI     .trap_damage
    RTS
.trap_damage:
    JSR     SET_CURSOR_ROW21
    LDA     #$11
    JSR     DISPLAY_MESSAGE
    JSR     SET_RESTRICTED
    JSR     PRINT_MOB_NAME
    JSR     DELAY_WITH_ANIMATION
    JSR     STEP_PRNG
    LDA     PRNG_OUTPUT
    ROL
    ROL
    LDA     #$01
    ADC     #$00
    JMP     APPLY_DAMAGE_TO_CURRENT
.type40:
    LDA     EVENT_SLOT_BYTE
    AND     #$1F
    STA     EVENT_SUB_VALUE
    CMP     #$1B
    BPL     .big_treasure
    JSR     SET_CURSOR_ROW21
    LDA     #$13
    JSR     SCENE_LOOP
    JMP     .clear_slot
.big_treasure:
    JSR     SET_CURSOR_ROW21
    LDA     #$12
    JSR     DISPLAY_MESSAGE
    LDA     EVENT_SUB_VALUE
    CMP     #$1F
    BMI     .clear_slot
    DEC     EVENT_SUB_VALUE
    LDA     EVENT_SLOT_BYTE
    AND     #$E0
    ORA     EVENT_SUB_VALUE
    LDY     #$02
    STA     (EVENT_PTR),Y
    JMP     .update_pos
.clear_slot:
    LDY     #$00
    LDA     #$FE
    STA     (EVENT_PTR),Y
.update_pos:
    LDA     CURRENT_COL
    STA     TURN_START_COL
    LDA     CURRENT_ROW
    STA     TURN_START_ROW
    JSR     RESET_TURN_POS
    JSR     ANIM_TICK_AND_WAIT
    JMP     EVENT_PRNG_CHECK
    ORG     $1E5A
HANDLE_MOB_ENCOUNTER:
    SUBROUTINE
    ; Mob encounter on movement: check flee chance, commit move,
    ; check encounter type, walk group for combat.
    LDA     #$00
    STA     ADJACENT_THREAT
    LDA     ENTITY_PTR
    STA     TARGET_REC
    LDA     ENTITY_PTR+1
    STA     TARGET_REC+1
    LDA     CURRENT_COL
    LDY     CURRENT_ROW
    JSR     COLROW_TO_POS
    JSR     SUM_HOSTILE_AT_POS
    LDA     ADJACENT_THREAT
    BEQ     .no_flee
    LDY     #$05
    LDA     (ENTITY_PTR),Y
    AND     #$1F
    CLC
    ADC     #$10
    SEC
    SBC     ADJACENT_THREAT
    BMI     .clamp_low
    CMP     #$1D
    BMI     .in_range
    LDA     #$1C
    BNE     .in_range
.clamp_low:
    LDA     #$04
.in_range:
    ASL
    ASL
    ORA     #$03
    TAX
    JSR     STEP_PRNG
    TXA
    CMP     PRNG_OUTPUT
    BPL     .no_flee
    JSR     SET_CURSOR_ROW21
    JSR     PRINT_MOB_NAME
    JSR     RESET_TEXT_WINDOW
    LDA     #$1E
    JSR     DISPLAY_MESSAGE
    LDA     TURN_START_COL
    STA     CURRENT_COL
    LDA     TURN_START_ROW
    STA     CURRENT_ROW
    JMP     END_TURN
.no_flee:
    JSR     COMMIT_MOVE
    LDY     #$03
    LDA     (ENTITY_PTR),Y
    JSR     CHECK_ENCOUNTER
    LDA     ENCOUNTER_RESULT
    CMP     #$02
    BPL     .hostile
    JSR     CHECK_THREATS_HERE
    CMP     #$01
    BEQ     .one_threat
    JMP     END_TURN
.one_threat:
    JMP     MOVE_LOOP
.hostile:
    JSR     FIRST_GROUP_MEMBER
.walk_group:
    LDA     MOB_PTR+1
    BEQ     .group_done
    LDY     #$03
    LDA     (ENTITY_PTR),Y
    CMP     (MOB_PTR),Y
    BNE     .next_member
    JSR     SET_TARGET_RESTRICTED
.next_member:
    JSR     NEXT_GROUP_MEMBER
    JMP     .walk_group
.group_done:
    JSR     SET_CURSOR_ROW21
    JSR     PRINT_MOB_NAME
    JSR     RESET_TEXT_WINDOW
    LDA     #$1F
    JSR     DISPLAY_MESSAGE
    JMP     END_TURN
    ORG     $1F03
SET_TARGET_RESTRICTED:
    SUBROUTINE
    LDY     #$0F
    LDA     (MOB_PTR),Y
    ORA     #$04
    STA     (MOB_PTR),Y
    RTS
    ORG     $1F0C
    SUBROUTINE
; Dispatches on PLAY_TONE: if $60 (RTS) then DELAY_WITH_ANIMATION else ANIM_TICK_AND_WAIT
DISPATCH_ON_MODE:
    LDA     PLAY_TONE
    CMP     #$60
    BEQ     .mode_60
    JMP     ANIM_TICK_AND_WAIT
.mode_60:
    JMP     DELAY_WITH_ANIMATION
    ORG     $4009
LOCATION_DATA:
    ; --- 0: ALI BABA HOME ---
    DC.W s_ALI_BABA_HOME
    DC.B $01                     ; mob head $01
    DC.B 20*6+9                  ; min pos (6,9)
    DC.B 20*9+13                 ; max pos (9,13)
    DC.B $01                     ; map 1
    DC.W ev_ali_baba_home
    DC.B $01

    ; --- 1: DUSTY ROAD ---
    DC.W s_DUSTY_ROAD
    DC.B $00                     ; no mobs
    DC.B 20*3+7                  ; min pos (3,7)
    DC.B 20*6+19                 ; max pos (6,19)
    DC.B $01                     ; map 1
    DC.W ev_dusty_road
    DC.B $00

    ; --- 2: SULTAN'S PALACE ---
    DC.W s_SULTANS_PALACE
    DC.B $3F                     ; mob head $3F
    DC.B 20*0+0                  ; min pos (0,0)
    DC.B 20*9+7                  ; max pos (9,7)
    DC.B $01                     ; map 1
    DC.W ev_sultans_palace
    DC.B $00

    ; --- 3: ROYAL LIBRARY ---
    DC.W s_ROYAL_LIBRARY
    DC.B $00                     ; no mobs
    DC.B 20*0+7                  ; min pos (0,7)
    DC.B 20*3+16                 ; max pos (3,16)
    DC.B $01                     ; map 1
    DC.W ev_royal_library
    DC.B $00

    ; --- 4: ASTROLOGER'S LAB ---
    DC.W s_ASTROLOGERS_LAB
    DC.B $4A                     ; mob head $4A
    DC.B 20*0+3                  ; min pos (0,3)
    DC.B 20*9+16                 ; max pos (9,16)
    DC.B $25                     ; map 37
    DC.W ev_astrologers_lab
    DC.B $00

    ; --- 5: BEAR CAVE ---
    DC.W s_BEAR_CAVE
    DC.B $51                     ; mob head $51
    DC.B 20*0+0                  ; min pos (0,0)
    DC.B 20*5+14                 ; max pos (5,14)
    DC.B $29                     ; map 41
    DC.W ev_bear_cave
    DC.B $00

    ; --- 6: RATS NEST ---
    DC.W s_RATS_NEST
    DC.B $52                     ; mob head $52
    DC.B 20*5+0                  ; min pos (5,0)
    DC.B 20*9+14                 ; max pos (9,14)
    DC.B $29                     ; map 41
    DC.W ev_rats_nest
    DC.B $00

    ; --- 7: DRAGON LAIR ---
    DC.W s_DRAGON_LAIR
    DC.B $5F                     ; mob head $5F
    DC.B 20*4+2                  ; min pos (4,2)
    DC.B 20*9+9                  ; max pos (9,9)
    DC.B $49                     ; map 73
    DC.W ev_dragon_lair
    DC.B $00

    ; --- 8: GOLD FOR THE LUCKY ---
    DC.W s_GOLD_FOR_THE_LUCKY
    DC.B $60                     ; mob head $60
    DC.B 20*4+9                  ; min pos (4,9)
    DC.B 20*9+16                 ; max pos (9,16)
    DC.B $49                     ; map 73
    DC.W ev_gold_for_the_lucky
    DC.B $00

    ; --- 9: SAVE THE WHALES ---
    DC.W s_SAVE_THE_WHALES
    DC.B $00                     ; no mobs
    DC.B 20*0+2                  ; min pos (0,2)
    DC.B 20*4+16                 ; max pos (4,16)
    DC.B $49                     ; map 73
    DC.W ev_save_the_whales
    DC.B $00

    ; --- 10: SLIDE ---
    DC.W s_SLIDE
    DC.B $00                     ; no mobs
    DC.B 20*0+1                  ; min pos (0,1)
    DC.B 20*9+3                  ; max pos (9,3)
    DC.B $60                     ; map 96
    DC.W ev_slide
    DC.B $00

    ; --- 11: DEEP DARK STAIRWAY ---
    DC.W s_DEEP_DARK_STAIRWAY
    DC.B $00                     ; no mobs
    DC.B 20*1+3                  ; min pos (1,3)
    DC.B 20*7+9                  ; max pos (7,9)
    DC.B $61                     ; map 97
    DC.W ev_deep_dark_stairway
    DC.B $00

    ; --- 12: MINOTAUR LABYRINTH ---
    DC.W s_MINOTAUR_LABYRINTH
    DC.B $6A                     ; mob head $6A
    DC.B 20*0+3                  ; min pos (0,3)
    DC.B 20*9+16                 ; max pos (9,16)
    DC.B $62                     ; map 98
    DC.W ev_minotaur_labyrinth
    DC.B $00

    ; --- 13: STINGER STREWN CELL ---
    DC.W s_STINGER_STREWN_CELL
    DC.B $5C                     ; mob head $5C
    DC.B 20*5+3                  ; min pos (5,3)
    DC.B 20*9+8                  ; max pos (9,8)
    DC.B $48                     ; map 72
    DC.W ev_stinger_strewn_cell
    DC.B $00

    ; --- 14: GUARD ROOM ---
    DC.W s_GUARD_ROOM
    DC.B $57                     ; mob head $57
    DC.B 20*0+3                  ; min pos (0,3)
    DC.B 20*5+16                 ; max pos (5,16)
    DC.B $48                     ; map 72
    DC.W ev_guard_room
    DC.B $00

    ; --- 15: LONG WAY FROM HOME ---
    DC.W s_LONG_WAY_FROM_HOME
    DC.B $5E                     ; mob head $5E
    DC.B 20*5+11                 ; min pos (5,11)
    DC.B 20*9+16                 ; max pos (9,16)
    DC.B $48                     ; map 72
    DC.W ev_long_way_from_home
    DC.B $00

    ; --- 16: FOREST ---
    DC.W s_FOREST
    DC.B $43                     ; mob head $43
    DC.B 20*0+0                  ; min pos (0,0)
    DC.B 20*9+13                 ; max pos (9,13)
    DC.B $04                     ; map 4
    DC.W ev_forest
    DC.B $00

    ; --- 17: VIEW FROM A TREE ---
    DC.W s_VIEW_FROM_A_TREE
    DC.B $00                     ; no mobs
    DC.B 20*1+13                 ; min pos (1,13)
    DC.B 20*7+19                 ; max pos (7,19)
    DC.B $04                     ; map 4
    DC.W ev_view_from_a_tree
    DC.B $00

    ; --- 18: FAILING WALL ---
    DC.W s_FAILING_WALL
    DC.B $6B                     ; mob head $6B
    DC.B 20*1+0                  ; min pos (1,0)
    DC.B 20*8+14                 ; max pos (8,14)
    DC.B $64                     ; map 100
    DC.W ev_failing_wall
    DC.B $00

    ; --- 19: MINOTAUR PLAYROOM ---
    DC.W s_MINOTAUR_PLAYROOM
    DC.B $6C                     ; mob head $6C
    DC.B 20*1+5                  ; min pos (1,5)
    DC.B 20*8+19                 ; max pos (8,19)
    DC.B $65                     ; map 101
    DC.W ev_minotaur_playroom
    DC.B $00

    ; --- 20: THIEVES CAVE ---
    DC.W s_THIEVES_CAVE
    DC.B $00                     ; no mobs
    DC.B 20*0+3                  ; min pos (0,3)
    DC.B 20*9+16                 ; max pos (9,16)
    DC.B $21                     ; map 33
    DC.W ev_thieves_cave
    DC.B $00

    ; --- 21: O ---
    DC.W s_O
    DC.B $62                     ; mob head $62
    DC.B 20*1+10                 ; min pos (1,10)
    DC.B 20*8+18                 ; max pos (8,18)
    DC.B $40                     ; map 64
    DC.W ev_o
    DC.B $00

    ; --- 22: SPIRAL STAIRCASE ---
    DC.W s_SPIRAL_STAIRCASE
    DC.B $00                     ; no mobs
    DC.B 20*1+6                  ; min pos (1,6)
    DC.B 20*7+10                 ; max pos (7,10)
    DC.B $46                     ; map 70
    DC.W ev_spiral_staircase
    DC.B $00

    ; --- 23: Y ---
    DC.W s_Y
    DC.B $63                     ; mob head $63
    DC.B 20*1+1                  ; min pos (1,1)
    DC.B 20*8+18                 ; max pos (8,18)
    DC.B $41                     ; map 65
    DC.W ev_y
    DC.B $00

    ; --- 24: MAGIC TOURBILLION ---
    DC.W s_MAGIC_TOURBILLION
    DC.B $00                     ; no mobs
    DC.B 20*5+9                  ; min pos (5,9)
    DC.B 20*9+13                 ; max pos (9,13)
    DC.B $60                     ; map 96
    DC.W ev_magic_tourbillion
    DC.B $00

    ; --- 25: G. ---
    DC.W s_G
    DC.B $64                     ; mob head $64
    DC.B 20*1+1                  ; min pos (1,1)
    DC.B 20*8+18                 ; max pos (8,18)
    DC.B $42                     ; map 66
    DC.W ev_g
    DC.B $00

    ; --- 26: CRYSTAL CAVE ---
    DC.W s_CRYSTAL_CAVE
    DC.B $00                     ; no mobs
    DC.B 20*2+3                  ; min pos (2,3)
    DC.B 20*8+15                 ; max pos (8,15)
    DC.B $22                     ; map 34
    DC.W ev_crystal_cave
    DC.B $00

    ; --- 27: B ---
    DC.W s_B
    DC.B $00                     ; no mobs
    DC.B 20*1+1                  ; min pos (1,1)
    DC.B 20*8+18                 ; max pos (8,18)
    DC.B $43                     ; map 67
    DC.W ev_b
    DC.B $00

    ; --- 28: THIEVES CLEARING ---
    DC.W s_THIEVES_CLEARING
    DC.B $1B                     ; mob head $1B
    DC.B 20*4+4                  ; min pos (4,4)
    DC.B 20*9+13                 ; max pos (9,13)
    DC.B $05                     ; map 5
    DC.W ev_thieves_clearing
    DC.B $00

    ; --- 29: OLD MINE ROAD ---
    DC.W s_OLD_MINE_ROAD
    DC.B $47                     ; mob head $47
    DC.B 20*1+0                  ; min pos (1,0)
    DC.B 20*4+19                 ; max pos (4,19)
    DC.B $05                     ; map 5
    DC.W ev_old_mine_road
    DC.B $00

    ; --- 30: FOOTHILLS CEMETERY ---
    DC.W s_FOOTHILLS_CEMETERY
    DC.B $45                     ; mob head $45
    DC.B 20*1+1                  ; min pos (1,1)
    DC.B 20*8+18                 ; max pos (8,18)
    DC.B $02                     ; map 2
    DC.W ev_foothills_cemetery
    DC.B $00

    ; --- 31: I ---
    DC.W s_I
    DC.B $68                     ; mob head $68
    DC.B 20*1+1                  ; min pos (1,1)
    DC.B 20*8+18                 ; max pos (8,18)
    DC.B $44                     ; map 68
    DC.W ev_i
    DC.B $00

    ; --- 32: UNDERGROUND STREAM ---
    DC.W s_UNDERGROUND_STREAM
    DC.B $00                     ; no mobs
    DC.B 20*0+7                  ; min pos (0,7)
    DC.B 20*3+14                 ; max pos (3,14)
    DC.B $60                     ; map 96
    DC.W ev_underground_stream
    DC.B $00

    ; --- 33: V ---
    DC.W s_V
    DC.B $69                     ; mob head $69
    DC.B 20*1+1                  ; min pos (1,1)
    DC.B 20*8+18                 ; max pos (8,18)
    DC.B $45                     ; map 69
    DC.W ev_v
    DC.B $00

    ; --- 34: GEMINI ---
    DC.W s_GEMINI
    DC.B $55                     ; mob head $55
    DC.B 20*0+2                  ; min pos (0,2)
    DC.B 20*4+16                 ; max pos (4,16)
    DC.B $20                     ; map 32
    DC.W ev_gemini
    DC.B $00

    ; --- 35: R ---
    DC.W s_R
    DC.B $61                     ; mob head $61
    DC.B 20*1+1                  ; min pos (1,1)
    DC.B 20*8+10                 ; max pos (8,10)
    DC.B $40                     ; map 64
    DC.W ev_r
    DC.B $00

    ; --- 36: OLD MINE SHAFT ---
    DC.W s_OLD_MINE_SHAFT
    DC.B $00                     ; no mobs
    DC.B 20*3+4                  ; min pos (3,4)
    DC.B 20*5+14                 ; max pos (5,14)
    DC.B $06                     ; map 6
    DC.W ev_old_mine_shaft
    DC.B $00

    ; --- 37: GILDED PATHWAY ---
    DC.W s_GILDED_PATHWAY
    DC.B $00                     ; no mobs
    DC.B 20*0+6                  ; min pos (0,6)
    DC.B 20*9+10                 ; max pos (9,10)
    DC.B $47                     ; map 71
    DC.W ev_gilded_pathway
    DC.B $00

    ; --- 38: MINOTAUR'S DEN ---
    DC.W s_MINOTAURS_DEN
    DC.B $6D                     ; mob head $6D
    DC.B 20*3+0                  ; min pos (3,0)
    DC.B 20*9+7                  ; max pos (9,7)
    DC.B $63                     ; map 99
    DC.W ev_minotaurs_den
    DC.B $00

    ; --- 39: MINOTAUR'S VAULT ---
    DC.W s_MINOTAURS_VAULT
    DC.B $00                     ; no mobs
    DC.B 20*6+7                  ; min pos (6,7)
    DC.B 20*9+16                 ; max pos (9,16)
    DC.B $63                     ; map 99
    DC.W ev_minotaurs_vault
    DC.B $00

    ; --- 40: INNER STAIRCASE ---
    DC.W s_INNER_STAIRCASE
    DC.B $00                     ; no mobs
    DC.B 20*0+11                 ; min pos (0,11)
    DC.B 20*6+16                 ; max pos (6,16)
    DC.B $63                     ; map 99
    DC.W ev_inner_staircase
    DC.B $00

    ; --- 41: SECRET PASSAGEWAY ---
    DC.W s_SECRET_PASSAGEWAY
    DC.B $00                     ; no mobs
    DC.B 20*1+0                  ; min pos (1,0)
    DC.B 20*3+11                 ; max pos (3,11)
    DC.B $63                     ; map 99
    DC.W ev_secret_passageway
    DC.B $00

    ; --- 42: VIRGO ---
    DC.W s_VIRGO
    DC.B $3A                     ; mob head $3A
    DC.B 20*1+4                  ; min pos (1,4)
    DC.B 20*8+9                  ; max pos (8,9)
    DC.B $26                     ; map 38
    DC.W ev_virgo
    DC.B $00

    ; --- 43: LEO ---
    DC.W s_LEO
    DC.B $4B                     ; mob head $4B
    DC.B 20*1+0                  ; min pos (1,0)
    DC.B 20*8+4                  ; max pos (8,4)
    DC.B $26                     ; map 38
    DC.W ev_leo
    DC.B $00

    ; --- 44: LIBRA ---
    DC.W s_LIBRA
    DC.B $00                     ; no mobs
    DC.B 20*1+9                  ; min pos (1,9)
    DC.B 20*8+14                 ; max pos (8,14)
    DC.B $26                     ; map 38
    DC.W ev_libra
    DC.B $00

    ; --- 45: SCORPIUS ---
    DC.W s_SCORPIUS
    DC.B $4C                     ; mob head $4C
    DC.B 20*1+14                 ; min pos (1,14)
    DC.B 20*8+19                 ; max pos (8,19)
    DC.B $26                     ; map 38
    DC.W ev_scorpius
    DC.B $00

    ; --- 46: SAGITTARIUS ---
    DC.W s_SAGITTARIUS
    DC.B $12                     ; mob head $12
    DC.B 20*4+0                  ; min pos (4,0)
    DC.B 20*9+16                 ; max pos (9,16)
    DC.B $27                     ; map 39
    DC.W ev_sagittarius
    DC.B $00

    ; --- 47: CAPRICORNUS ---
    DC.W s_CAPRICORNUS
    DC.B $00                     ; no mobs
    DC.B 20*0+0                  ; min pos (0,0)
    DC.B 20*4+16                 ; max pos (4,16)
    DC.B $27                     ; map 39
    DC.W ev_capricornus
    DC.B $00

    ; --- 48: AQUARIUS ---
    DC.W s_AQUARIUS
    DC.B $00                     ; no mobs
    DC.B 20*1+15                 ; min pos (1,15)
    DC.B 20*8+19                 ; max pos (8,19)
    DC.B $24                     ; map 36
    DC.W ev_aquarius
    DC.B $00

    ; --- 49: PISCES ---
    DC.W s_PISCES
    DC.B $00                     ; no mobs
    DC.B 20*1+11                 ; min pos (1,11)
    DC.B 20*8+15                 ; max pos (8,15)
    DC.B $24                     ; map 36
    DC.W ev_pisces
    DC.B $00

    ; --- 50: HALLWAY ---
    DC.W s_HALLWAY
    DC.B $00                     ; no mobs
    DC.B 20*1+8                  ; min pos (1,8)
    DC.B 20*8+11                 ; max pos (8,11)
    DC.B $24                     ; map 36
    DC.W ev_hallway
    DC.B $00

    ; --- 51: ARIES ---
    DC.W s_ARIES
    DC.B $4E                     ; mob head $4E
    DC.B 20*1+4                  ; min pos (1,4)
    DC.B 20*8+8                  ; max pos (8,8)
    DC.B $24                     ; map 36
    DC.W ev_aries
    DC.B $00

    ; --- 52: TAURUS ---
    DC.W s_TAURUS
    DC.B $4D                     ; mob head $4D
    DC.B 20*1+0                  ; min pos (1,0)
    DC.B 20*8+4                  ; max pos (8,4)
    DC.B $24                     ; map 36
    DC.W ev_taurus
    DC.B $00

    ; --- 53: GEMINI (south) ---
    DC.W s_GEMINI2
    DC.B $00                     ; no mobs
    DC.B 20*0+2                  ; min pos (0,2)
    DC.B 20*4+16                 ; max pos (4,16)
    DC.B $20                     ; map 32
    DC.W ev_gemini2
    DC.B $00

    ; --- 54: CANCER ---
    DC.W s_CANCER
    DC.B $4F                     ; mob head $4F
    DC.B 20*5+2                  ; min pos (5,2)
    DC.B 20*9+16                 ; max pos (9,16)
    DC.B $20                     ; map 32
    DC.W ev_cancer
    DC.B $00

    ; --- 55: THE MOUNTAIN ---
    DC.W s_THE_MOUNTAIN
    DC.B $49                     ; mob head $49
    DC.B 20*0+2                  ; min pos (0,2)
    DC.B 20*9+16                 ; max pos (9,16)
    DC.B $07                     ; map 7
    DC.W ev_the_mountain
    DC.B $00

    ; --- 56: SHAHRIAR TREASURY ---
    DC.W s_SHAHRIAR_TREASURY
    DC.B $3C                     ; mob head $3C
    DC.B 20*1+4                  ; min pos (1,4)
    DC.B 20*8+13                 ; max pos (8,13)
    DC.B $03                     ; map 3
    DC.W ev_shahriar_treasury
    DC.B $00

    ; --- 57: AIR VENT ---
    DC.W s_AIR_VENT
    DC.B $00                     ; no mobs
    DC.B 20*0+14                 ; min pos (0,14)
    DC.B 20*9+16                 ; max pos (9,16)
    DC.B $28                     ; map 40
    DC.W ev_air_vent
    DC.B $00

    ; --- 58: DESERTED TUNNEL ---
    DC.W s_DESERTED_TUNNEL
    DC.B $00                     ; no mobs
    DC.B 20*6+6                  ; min pos (6,6)
    DC.B 20*9+14                 ; max pos (9,14)
    DC.B $28                     ; map 40
    DC.W ev_deserted_tunnel
    DC.B $00

    ; --- 59: ROY G. BIV ---
    DC.W s_ROY_G_BIV
    DC.B $00                     ; no mobs
    DC.B 20*3+0                  ; min pos (3,0)
    DC.B 20*9+2                  ; max pos (9,2)
    DC.B $28                     ; map 40
    DC.W ev_roy_g_biv
    DC.B $00

    ; --- 60: JACKAL ALTAR ---
    DC.W s_JACKAL_ALTAR
    DC.B $50                     ; mob head $50
    DC.B 20*0+2                  ; min pos (0,2)
    DC.B 20*6+14                 ; max pos (6,14)
    DC.B $28                     ; map 40
    DC.W ev_jackal_altar
    DC.B $00

    ; --- 61: ASTROLOGER'S MAZE ---
    DC.W s_ASTROLOGERS_MAZE
    DC.B $14                     ; mob head $14
    DC.B 20*0+3                  ; min pos (0,3)
    DC.B 20*9+16                 ; max pos (9,16)
    DC.B $23                     ; map 35
    DC.W ev_astrologers_maze
    DC.B $00

    DC.W $FFFF                  ; end sentinel
    HEX 12 01 00 00 00 00 A0   ; unused padding to $4240
    ORG     $4240
LOCATION_NAMES:
s_ALI_BABA_HOME:
    HEX 0D C1 CC C9 A0 C2 C1 C2 C1 A0 C8 CF CD C5
s_DUSTY_ROAD:
    HEX 0A C4 D5 D3 D4 D9 A0 D2 CF C1 C4
s_SULTANS_PALACE:
    HEX 0F D3 D5 CC D4 C1 CE A7 D3 A0 D0 C1 CC C1 C3 C5
s_ROYAL_LIBRARY:
    HEX 0D D2 CF D9 C1 CC A0 CC C9 C2 D2 C1 D2 D9
s_ASTROLOGERS_LAB:
    HEX 10 C1 D3 D4 D2 CF CC CF C7 C5 D2 A7 D3 A0 CC C1 C2
s_BEAR_CAVE:
    HEX 09 C2 C5 C1 D2 A0 C3 C1 D6 C5
s_RATS_NEST:
    HEX 09 D2 C1 D4 D3 A0 CE C5 D3 D4
s_DRAGON_LAIR:
    HEX 0B C4 D2 C1 C7 CF CE A0 CC C1 C9 D2
s_GOLD_FOR_THE_LUCKY:
    HEX 12 C7 CF CC C4 A0 C6 CF D2 A0 D4 C8 C5 A0 CC D5 C3 CB D9
s_SAVE_THE_WHALES:
    HEX 0F D3 C1 D6 C5 A0 D4 C8 C5 A0 D7 C8 C1 CC C5 D3
s_SLIDE:
    HEX 05 D3 CC C9 C4 C5
s_DEEP_DARK_STAIRWAY:
    HEX 12 C4 C5 C5 D0 A0 C4 C1 D2 CB A0 D3 D4 C1 C9 D2 D7 C1 D9
s_MINOTAUR_LABYRINTH:
    HEX 12 CD C9 CE CF D4 C1 D5 D2 A0 CC C1 C2 D9 D2 C9 CE D4 C8
s_STINGER_STREWN_CELL:
    HEX 13 D3 D4 C9 CE C7 C5 D2 A0 D3 D4 D2 C5 D7 CE A0 C3 C5 CC CC
s_GUARD_ROOM:
    HEX 0A C7 D5 C1 D2 C4 A0 D2 CF CF CD
s_LONG_WAY_FROM_HOME:
    HEX 12 CC CF CE C7 A0 D7 C1 D9 A0 C6 D2 CF CD A0 C8 CF CD C5
s_FOREST:
    HEX 06 C6 CF D2 C5 D3 D4
s_VIEW_FROM_A_TREE:
    HEX 10 D6 C9 C5 D7 A0 C6 D2 CF CD A0 C1 A0 D4 D2 C5 C5
s_FAILING_WALL:
    HEX 0C C6 C1 C9 CC C9 CE C7 A0 D7 C1 CC CC
s_MINOTAUR_PLAYROOM:
    HEX 11 CD C9 CE CF D4 C1 D5 D2 A0 D0 CC C1 D9 D2 CF CF CD
s_THIEVES_CAVE:
    HEX 0C D4 C8 C9 C5 D6 C5 D3 A0 C3 C1 D6 C5
s_O:
    HEX 01 CF
s_SPIRAL_STAIRCASE:
    HEX 10 D3 D0 C9 D2 C1 CC A0 D3 D4 C1 C9 D2 C3 C1 D3 C5
s_Y:
    HEX 01 D9
s_MAGIC_TOURBILLION:
    HEX 11 CD C1 C7 C9 C3 A0 D4 CF D5 D2 C2 C9 CC CC C9 CF CE
s_G:
    HEX 02 C7 AE
s_CRYSTAL_CAVE:
    HEX 0C C3 D2 D9 D3 D4 C1 CC A0 C3 C1 D6 C5
s_B:
    HEX 01 C2
s_THIEVES_CLEARING:
    HEX 10 D4 C8 C9 C5 D6 C5 D3 A0 C3 CC C5 C1 D2 C9 CE C7
s_OLD_MINE_ROAD:
    HEX 0D CF CC C4 A0 CD C9 CE C5 A0 D2 CF C1 C4
s_FOOTHILLS_CEMETERY:
    HEX 12 C6 CF CF D4 C8 C9 CC CC D3 A0 C3 C5 CD C5 D4 C5 D2 D9
s_I:
    HEX 01 C9
s_UNDERGROUND_STREAM:
    HEX 12 D5 CE C4 C5 D2 C7 D2 CF D5 CE C4 A0 D3 D4 D2 C5 C1 CD
s_V:
    HEX 01 D6
s_GEMINI:
    HEX 06 C7 C5 CD C9 CE C9
s_R:
    HEX 01 D2
s_OLD_MINE_SHAFT:
    HEX 0E CF CC C4 A0 CD C9 CE C5 A0 D3 C8 C1 C6 D4
s_GILDED_PATHWAY:
    HEX 0E C7 C9 CC C4 C5 C4 A0 D0 C1 D4 C8 D7 C1 D9
s_MINOTAURS_DEN:
    HEX 0E CD C9 CE CF D4 C1 D5 D2 A7 D3 A0 C4 C5 CE
s_MINOTAURS_VAULT:
    HEX 10 CD C9 CE CF D4 C1 D5 D2 A7 D3 A0 D6 C1 D5 CC D4
s_INNER_STAIRCASE:
    HEX 0F C9 CE CE C5 D2 A0 D3 D4 C1 C9 D2 C3 C1 D3 C5
s_SECRET_PASSAGEWAY:
    HEX 11 D3 C5 C3 D2 C5 D4 A0 D0 C1 D3 D3 C1 C7 C5 D7 C1 D9
s_VIRGO:
    HEX 05 D6 C9 D2 C7 CF
s_LEO:
    HEX 03 CC C5 CF
s_LIBRA:
    HEX 05 CC C9 C2 D2 C1
s_SCORPIUS:
    HEX 08 D3 C3 CF D2 D0 C9 D5 D3
s_SAGITTARIUS:
    HEX 0B D3 C1 C7 C9 D4 D4 C1 D2 C9 D5 D3
s_CAPRICORNUS:
    HEX 0B C3 C1 D0 D2 C9 C3 CF D2 CE D5 D3
s_AQUARIUS:
    HEX 08 C1 D1 D5 C1 D2 C9 D5 D3
s_PISCES:
    HEX 06 D0 C9 D3 C3 C5 D3
s_HALLWAY:
    HEX 07 C8 C1 CC CC D7 C1 D9
s_ARIES:
    HEX 05 C1 D2 C9 C5 D3
s_TAURUS:
    HEX 06 D4 C1 D5 D2 D5 D3
s_GEMINI2:
    HEX 06 C7 C5 CD C9 CE C9
s_CANCER:
    HEX 06 C3 C1 CE C3 C5 D2
s_THE_MOUNTAIN:
    HEX 0C D4 C8 C5 A0 CD CF D5 CE D4 C1 C9 CE
s_SHAHRIAR_TREASURY:
    HEX 11 D3 C8 C1 C8 D2 C9 C1 D2 A0 D4 D2 C5 C1 D3 D5 D2 D9
s_AIR_VENT:
    HEX 08 C1 C9 D2 A0 D6 C5 CE D4
s_DESERTED_TUNNEL:
    HEX 0F C4 C5 D3 C5 D2 D4 C5 C4 A0 D4 D5 CE CE C5 CC
s_ROY_G_BIV:
    HEX 0A D2 CF D9 A0 C7 AE A0 C2 C9 D6
s_JACKAL_ALTAR:
    HEX 0C CA C1 C3 CB C1 CC A0 C1 CC D4 C1 D2
s_ASTROLOGERS_MAZE:
    HEX 11 C1 D3 D4 D2 CF CC CF C7 C5 D2 A7 D3 A0 CD C1 DA C5
    ORG     $451E
LOCATION_EVENTS:
ev_ali_baba_home:                       ; 0: ALI BABA HOME
    HEX FE 00 00 83 82 6F FF FF FF

ev_dusty_road:                          ; 1: DUSTY ROAD
    HEX FE 00 00 6B 03 6A 45 04 31
    HEX 83 81 97 4B 04 37 73 D4 48
    HEX 8A 91 1E 63 9F 3E FF FF FF

ev_sultans_palace:                      ; 2: SULTAN'S PALACE
    HEX FE 00 00 1B 44 1C 51 C0 19
    HEX 65 D4 4C 65 79 5C 79 C0 2D
    HEX 69 D3 46 6B 42 6C FF FF FF

ev_royal_library:                       ; 3: ROYAL LIBRARY
    HEX FE 00 00 1B 43 1A 1D D2 47
    HEX 45 02 59 1F D2 51 21 D2 5E
    HEX 23 D2 5C 4B 02 5F FF FF FF

ev_astrologers_lab:                     ; 4: ASTROLOGER'S LAB
    HEX FE 00 00 FE 00 00 04 75 8E
    HEX 07 74 92 0A 73 96 0C 72 99
    HEX 0F 71 9D 3F 36 37 46 D2 56
    HEX 4C 70 29 7B 77 9B 88 6F 8D
    HEX B8 6C 2A BB 2B 2E BF 6D 34
    HEX C3 6E 38 FF FF FF

ev_bear_cave:                           ; 5: BEAR CAVE
    HEX FE 00 00 19 FE 1F 1C FE DF
    HEX 28 BA 37 2D FE 1F 2E C0 96
    HEX 30 FE 1F 42 FE 1F 43 FE 1F
    HEX 20 C0 64 70 47 84 FF FF FF

ev_rats_nest:                           ; 6: RATS NEST
    HEX FE 00 00 70 46 5C 78 BA 87
    HEX 90 C0 32 FF FF FF

ev_dragon_lair:                         ; 7: DRAGON LAIR
    HEX FE 00 00 55 0A 41 A5 C1 2C
    HEX A9 89 AA FF FF FF

ev_gold_for_the_lucky:                  ; 8: GOLD FOR THE LUCKY
    HEX FE 00 00 5D 0A 49 98 FE 1F
    HEX 99 FE 1F 9A D3 59 A9 88 A8
    HEX AB FE 1F AD C0 32 AD C1 F4
    HEX AE FE 1F C1 AC 2B FF FF FF

ev_save_the_whales:                     ; 9: SAVE THE WHALES
    HEX FE 00 00 05 4E A5 0E 50 AE
    HEX 1D FE D6 2A A9 23 30 FE D6
    HEX 32 FE D6 45 FE D6 31 FE 95
    HEX 31 D4 5A 31 C9 56 55 08 69
    HEX 37 D6 E0 5D 09 85 FF FF FF

ev_slide:                               ; 10: SLIDE
    HEX 2A D3 5D 66 C0 64 02 BE 7E
    HEX 3E 8B 52 66 8B 7A 8E 8B A2
    HEX B6 8D 83 FF FF FF

ev_deep_dark_stairway:                  ; 11: DEEP DARK STAIRWAY
    HEX FE 00 00 18 A2 90 2E FE 1F
    HEX 2F FE 9F 30 FE 1F 43 FE 9F
    HEX 44 FE 1F 54 FE 1F 58 FE 1F
    HEX 68 FE 1F 69 FE 9F 7C FE 1F
    HEX 7D FE 9F 7E FE 1F 6D 8D 54
    HEX 81 8D 68 93 13 29 FF FF FF

ev_minotaur_labyrinth:                  ; 12: MINOTAUR LABYRINTH
    HEX FE 00 00 19 FE DF 1E 8D 1D
    HEX 1F C0 4B 23 AA 29 2E 8D 19
    HEX 33 FE 1F 34 FE DF 35 FE 1F
    HEX 36 FE 1F 37 FE 1F 40 FE DF
    HEX 43 FE 1F 46 FE 1F 53 8C 6C
    HEX 55 D3 5F 55 FE DF 58 FE 1F
    HEX 59 FE DF 5E FE 12 60 A7 51
    HEX 67 8C 80 68 8D 2C 6A FE 1F
    HEX 6D 8D 6C 6E 8D 5A 6F FE 1F
    HEX 71 FE C0 71 FE DA 71 FE 1F
    HEX 7D 8D 83 7E FE C0 7E 99 AB
    HEX 80 FE DF 82 8D 81 84 FE 1F
    HEX 90 FE 04 93 8D 92 94 FE 1F
    HEX 95 FE 1F 96 FE 9F 97 FE 1F
    HEX 99 FE 9E 9A FE 1F A5 C0 7D
    HEX A7 8D 93 A8 A1 1C A9 FE DB
    HEX AE FE 1E FF FF FF

ev_stinger_strewn_cell:                 ; 13: STINGER STREWN CELL
    HEX FE 00 00 6A 0F 56 94 59 96
    HEX A4 C0 E4 B9 0A 19 FF FF FF

ev_guard_room:                          ; 14: GUARD ROOM
    HEX FE 00 00 09 26 A8 6A 4E 7E
    HEX 71 50 85 FF FF FF

ev_long_way_from_home:                  ; 15: LONG WAY FROM HOME
    HEX FE 00 00 71 0F 5D 97 59 98
    HEX AF C0 88 C2 0A 22 FF FF FF

ev_forest:                              ; 16: FOREST
    HEX FE 00 00 0A 82 76 17 C0 03
    HEX 2E D5 90 67 D6 58 33 FE 1F
    HEX 3F FE 1F 40 FE 1F 45 FE 1F
    HEX 46 FE 1F 6B FE 1F 7C FE 1F
    HEX 7F FE 1F 95 FE 1F A1 C0 2F
    HEX A9 FE 1F 85 92 86 AD 9E 29
    HEX FF FF FF

ev_view_from_a_tree:                    ; 17: VIEW FROM A TREE
    HEX FE 00 00 24 95 A5 37 FE 1F
    HEX 38 FE DF 39 FE 1F 4C D2 4E
    HEX 85 91 84 9C 9E 2B FF FF FF

ev_failing_wall:                        ; 18: FAILING WALL
    HEX FE 00 00 31 FE 9E 44 FE 1E
    HEX 57 FE 1E 6A FE 1E 7E FE 1E
    HEX 91 FE C0 91 CA 2C 92 FE 1E
    HEX 8F D5 46 6C FE 19 72 54 6A
    HEX FF FF FF

ev_minotaur_playroom:                   ; 19: MINOTAUR PLAYROOM
    HEX FE 00 00 6B FE 19 97 C0 C8
    HEX 38 94 38 4C 94 4C 61 94 61
    HEX 76 94 76 26 67 A3 FF FF FF

ev_thieves_cave:                        ; 20: THIEVES CAVE
    HEX 1A C9 AF 1D C0 1E 20 C0 3C
    HEX 60 1B 68 7C D3 50 7D FE 1F
    HEX 7E FE 1F 92 FE 1F A5 D2 4F
    HEX A6 FE 1F A9 C0 0A AC C9 C8
    HEX AF C0 19 B9 92 4C FF FF FF

ev_o:                                   ; 21: O
    HEX FE 00 00 5C D3 57 82 56 83
    HEX 73 C0 2D 74 FE 89 8A 58 2A
    HEX FF FF FF

ev_spiral_staircase:                    ; 22: SPIRAL STAIRCASE
    HEX FE 00 00 1D 7E 23 44 FE 1F
    HEX 45 FE 1F 6B FE 1F 6C FE 1F
    HEX 93 18 38 FF FF FF

ev_y:                                   ; 23: Y
    HEX FE 00 00 24 57 7F 81 FE 1F
    HEX 82 FE 1F 83 FE 1F 97 FE DF
    HEX 95 5A 31 96 C9 E6 FF FF FF

ev_magic_tourbillion:                   ; 24: MAGIC TOURBILLION
    HEX FE 00 00 83 C0 64 97 80 97
    HEX 82 D5 92 84 D6 A8 FF FF FF

ev_g:                                   ; 25: G.
    HEX FE 00 00 31 A2 90 8D 1C 39
    HEX 97 C0 46 FF FF FF

ev_crystal_cave:                        ; 26: CRYSTAL CAVE
    HEX 31 BA AF 42 FE C0 42 C0 23
    HEX 5C FE C0 5C C0 19 67 15 5F
    HEX 6D C0 19 6D FE C0 6D FE C0
    HEX 6D C0 32 72 FE C0 72 FE C0
    HEX 72 C0 1E 73 BE 54 90 FE C0
    HEX 90 FE C0 90 C0 32 94 D3 4D
    HEX 94 FE C0 94 C0 23 A8 24 2D
    HEX 84 FE C0 84 FE C0 84 FE C0
    HEX 84 C0 46 FF FF FF

ev_b:                                   ; 27: B
    HEX 29 20 9D FE 00 00 33 9C 39
    HEX 3F 9C 39 59 9C 39 6D 40 AC
    HEX 8F D6 58 6E 9C 39 FF FF FF

ev_thieves_clearing:                    ; 28: THIEVES CLEARING
    HEX FE 00 00 58 1E 44 A6 C0 4B
    HEX 97 C0 19 FF FF FF

ev_old_mine_road:                       ; 29: OLD MINE ROAD
    HEX FE 00 00 17 92 88 22 B8 AC
    HEX 4B D6 A8 28 91 AC 43 FE 1F
    HEX 44 FE DF 58 5D 6C 45 FE 1F
    HEX 3A D3 4B 3A C0 14 3A 65 55
    HEX FF FF FF

ev_foothills_cemetery:                  ; 30: FOOTHILLS CEMETERY
    HEX FE 00 00 3D 82 62 45 FE 5F
    HEX 58 FE 5F 59 FE 9F 59 C0 64
    HEX 5A FE 5F 6D FE 5F 81 FE 5F
    HEX 7E C0 05 9E B8 7B FF FF FF

ev_i:                                   ; 31: I
    HEX FE 00 00 18 22 90 31 FE 1F
    HEX 45 FE 1F 59 FE 1F 6D FE 1F
    HEX 81 FE 9E 90 C0 7D 95 FE 1F
    HEX FF FF FF

ev_underground_stream:                  ; 32: UNDERGROUND STREAM
    HEX 1D D3 5B 1D FE D6 1D D1 00
    HEX 1D C0 32 1D FE D6 1D C0 32
    HEX 1D FE D6 FE 00 00 34 D6 50
    HEX 0D 40 AA 49 4D A8 FF FF FF

ev_v:                                   ; 33: V
    HEX FE 00 00 2E C0 41 3A 24 8E
    HEX A4 8C 2C FF FF FF

ev_gemini:                              ; 34: GEMINI
    HEX FE 00 00 38 45 40 55 66 1C
    HEX FF FF FF

ev_r:                                   ; 35: R
    HEX FE 00 00 19 1B 94 55 FE 1F
    HEX 53 D5 82 69 FE 1F 7D FE 1F
    HEX 91 FE 1F 90 C0 64 92 FE C0
    HEX 92 C0 41 82 56 83 FF FF FF

ev_old_mine_shaft:                      ; 36: OLD MINE SHAFT
    HEX FE 00 00 54 9E 3A 59 D3 49
    HEX 59 FE 1F 5E B5 29 FF FF FF

ev_gilded_pathway:                      ; 37: GILDED PATHWAY
    HEX FE 00 00 08 A3 41 31 80 97
    HEX 43 80 AA 44 FE DF 59 C9 00
    HEX 6B C9 00 93 8F 59 95 FE C9
    HEX BC 4F 1D FF FF FF

ev_minotaurs_den:                       ; 38: MINOTAUR'S DEN
    HEX FE 00 00 FE 00 00 50 8D 5F
    HEX A7 28 A8 FF FF FF

ev_minotaurs_vault:                     ; 39: MINOTAUR'S VAULT
    HEX FE 00 00 84 29 70 93 27 92
    HEX AA CA 2C AE C9 C8 FF FF FF

ev_inner_staircase:                     ; 40: INNER STAIRCASE
    HEX FE 00 00 24 0A 2B 20 FE 1F
    HEX 21 FE 9F 34 FE 1F 48 FE C0
    HEX 48 AA 32 5F FE 1F 72 FE 5F
    HEX 73 FE 1F 84 28 98 FF FF FF

ev_secret_passageway:                   ; 41: SECRET PASSAGEWAY
    HEX FE 00 00 28 0D 23 33 29 48
    HEX FF FF FF

ev_virgo:                               ; 42: VIRGO
    HEX FE 00 00 1A 45 A7 81 6D 82
    HEX FF FF FF

ev_leo:                                 ; 43: LEO
    HEX FE 00 00 16 45 A4 8E C0 FA
    HEX 7C 2B 7D FF FF FF

ev_libra:                               ; 44: LIBRA
    HEX 20 45 AB 86 6E 87 6F FE B7
    HEX 98 C9 64 FF FF FF

ev_scorpius:                            ; 45: SCORPIUS
    HEX 24 45 AF FE 00 00 8B 6F AC
    HEX 9C C0 96 FF FF FF

ev_sagittarius:                         ; 46: SAGITTARIUS
    HEX FE 00 00 5C 70 48 7E FE 19
    HEX 84 D3 53 8C 45 87 FF FF FF

ev_capricornus:                         ; 47: CAPRICORNUS
    HEX FE 00 00 0C 71 4E 1E FE 1F
    HEX 28 45 4B 2D FE 0D 31 D4 55
    HEX 32 FE 1F 37 C9 FA 41 FE 15
    HEX 34 D6 F8 46 FE 1F FF FF FF

ev_aquarius:                            ; 48: AQUARIUS
    HEX FE 00 00 39 D1 00 4B 72 4A
    HEX 61 FE 16 B1 45 23 FF FF FF

ev_pisces:                              ; 49: PISCES
    HEX FE 00 00 5D FE 95 71 D4 52
    HEX 85 FE 55 AD 45 20 FF FF FF

ev_hallway:                             ; 50: HALLWAY
    HEX FE 00 00 1D BE A9 1E BE AA
    HEX AA 45 1E FF FF FF

ev_aries:                               ; 51: ARIES
    HEX FE 00 00 40 75 3F 2E C0 64
    HEX A6 45 1B FF FF FF

ev_taurus:                              ; 52: TAURUS
    HEX FE 00 00 28 A5 5D 3C 36 19
    HEX 51 B5 52 A2 45 18 FF FF FF

ev_gemini2:                             ; 53: GEMINI (south)
    HEX FE 00 00 1C FE 01 44 FE 01
    HEX 2D C9 64 38 45 40 55 77 7D
    HEX FF FF FF

ev_cancer:                              ; 54: CANCER
    HEX FE 00 00 8F C0 32 9C 45 7C
    HEX 84 D3 60 B9 6C 79 FF FF FF

ev_the_mountain:                        ; 55: THE MOUNTAIN
    HEX FE 00 00 17 D4 4A 18 FE 1F
    HEX 23 7A 23 46 FE 1F 59 FE 1F
    HEX 6C FE 1F 7F FE 1F AF D5 44
    HEX 2B FE C0 2B 92 3A 2C FE 1F
    HEX 40 FE 1F 4A FE 1F 4B FE 1F
    HEX 5E FE 1F 5F C0 32 72 FE 1F
    HEX 7A 9F 9D 82 C0 05 86 FE 1F
    HEX A4 D4 58 C0 9E 36 FF FF FF

ev_shahriar_treasury:                   ; 56: SHAHRIAR TREASURY
    HEX FE 00 00 43 C9 FA 56 C0 32
    HEX 57 C0 64 58 C0 32 6B C0 32
    HEX 5D 83 66 FF FF FF

ev_air_vent:                            ; 57: AIR VENT
    HEX 0F B8 23 38 86 29 FE 00 00
    HEX 5E BD 5D 88 87 79 AE BB AD
    HEX C3 9B 45 FF FF FF

ev_deserted_tunnel:                     ; 58: DESERTED TUNNEL
    HEX FE 00 00 93 C0 2D 94 D3 54
    HEX 95 FE 1F A7 FE 1F A8 FE C0
    HEX A8 B8 73 AE BA AF FF FF FF

ev_roy_g_biv:                           ; 59: ROY G. BIV
    HEX 52 BD 53 65 FE C1 65 C0 64
    HEX 8D FE C1 8D BC 79 A1 FE C0
    HEX A1 63 2B FF FF FF

ev_jackal_altar:                        ; 60: JACKAL ALTAR
    HEX FE 00 00 17 C0 37 20 FE 1F
    HEX 30 FE 1F 31 FE 1F 32 FE 1F
    HEX 33 FE 1F 34 FE 1F 41 FE 1F
    HEX 42 FE 1F 57 FE 1F 58 FE 1F
    HEX 59 FE 1F 52 BC 51 5E BA 5F
    HEX FF FF FF

ev_astrologers_maze:                    ; 61: ASTROLOGER'S MAZE
    HEX FE 00 00 1E FE 1F 23 97 31
    HEX 2E FE 1F 33 FE 1F 35 FE 1F
    HEX 36 FE 1F 37 FE 1F 43 FE 1F
    HEX 46 FE 1F 53 9B 72 58 FE 1F
    HEX 5E FE 1F 6A FE 1F 6D FE 1F
    HEX 6E FE 1F 6F FE 1F 71 FE 1F
    HEX 7D FE 1F 7E FE C0 7E 8B 16
    HEX 83 C9 78 84 FE 1F 90 FE 1F
    HEX 93 FE 1F 94 FE 1F 95 FE 1F
    HEX 96 FE 1F 97 FE 1F 9A FE 1F
    HEX A4 C0 32 A7 FE 1F AE FE 1F
    HEX AF C0 0A BD B4 2F BE B3 32
    HEX 1F D5 C6 FF FF FF
    ORG     $5B00
INIT_GAME_STATE:
    SUBROUTINE

    JSR     INIT_GAME_DISPLAY       ; set up game display / UI
    LDA     #<GAME_ACTION_HANDLER   ; \ $F6/DISPATCH_VEC+1 = game action handler
    STA     DISPATCH_VEC                     ;  |
    LDA     #>GAME_ACTION_HANDLER   ;  |
    STA     DISPATCH_VEC+1                     ; /
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

    ORG     $5C6D
INIT_GAME_DISPLAY:
    SUBROUTINE

    LDA     #$90                    ; HRCG control: clear hi-res screen
    JSR     ROM_COUT1
    stow    UI_TEXT_STREAM,TEXT_STREAM_PTR ; point text stream at UI data
    JSR     TEXT_RENDERER           ; render game UI background

    ; Draw three 2x2 border characters across top (charset 2, row 3)
    LDA     #$01                    ; char 1
    LDX     #$10                    ; col 16
    JSR     DRAW_BORDER_CHAR
    LDA     #$0E                    ; char 14
    LDX     #$12                    ; col 18
    JSR     DRAW_BORDER_CHAR
    LDA     #$04                    ; char 4
    LDX     #$14                    ; col 20
    JSR     DRAW_BORDER_CHAR

    JSR     DRAW_BORDER_LABELS      ; draw border text labels
    JSR     DRAW_BORDER_ICONS       ; draw corner decorations

    JSR     PRINT_CTRL_AB           ; reset HRCG block mode

    ; Print copyright at row 21, col 0
    LDA     #$15
    STA     TEXT_ROW
    LDA     #$00
    STA     TEXT_COL
    LDX     #<s_COPYRIGHT
    LDY     #>s_COPYRIGHT
    JSR     PRINT_STRING_AT_ADDR

    ; Print "PRESS SPACE BAR TO CONTINUE" at row 23, col 0
    LDA     #$17
    STA     TEXT_ROW
    LDA     #$00
    STA     TEXT_COL
    LDX     #<s_PRESS_SPACE
    LDY     #>s_PRESS_SPACE
    JSR     PRINT_STRING_AT_ADDR

    ; Switch to HRCG charset 5 for decorative chars
    LDA     #$81                    ; ctrl-A (select charset)
    JSR     ROM_COUT1
    LDA     #$B5                    ; '5' = charset 5
    JSR     ROM_COUT1

    ; Print decorative strings at col 30, rows 21-23
    LDA     #$15
    STA     TEXT_ROW
    LDA     #$1E
    STA     TEXT_COL
    LDX     #<s_DECOR_ROW1
    LDY     #>s_DECOR_ROW1
    JSR     PRINT_STRING_AT_ADDR

    INC     TEXT_ROW
    LDA     #$1E
    STA     TEXT_COL
    LDX     #<s_DECOR_ROW2
    LDY     #>s_DECOR_ROW2
    JSR     PRINT_STRING_AT_ADDR

    INC     TEXT_ROW
    LDA     #$1E
    STA     TEXT_COL
    LDX     #<s_DECOR_ROW3
    LDY     #>s_DECOR_ROW3
    JMP     PRINT_STRING_AT_ADDR
    ORG     $5CEC
DRAW_BORDER_CHAR:

    STX     TEXT_COL
    STA     FONT_CHARNUM
    LDY     #$03
    STY     TEXT_ROW
    LDA     #$02
    STA     FONT_CHARSET
    JMP     PRINT_FONTCHAR_AT_TEXT_POS
    ORG     $5CFD
DRAW_BORDER_LABELS:
    SUBROUTINE

    ; Select HRCG charset 2
    LDA     #$81                    ; ctrl-A
    JSR     ROM_COUT1
    LDA     #$B2                    ; '2' = charset 2
    JSR     ROM_COUT1

    ; Loop 1: horizontal borders (6 positions from BORDER_POS_HORIZ)
    LDX     #$0A                    ; index 10 (5 pairs, counting down by 2)
    STX     BORDER_LOOP_CTR
    stow    BORDER_STR_HORIZ,PRINT_STRING_ADDR
.loop1:
    LDA     BORDER_POS_HORIZ,X
    STA     TEXT_COL
    INX
    LDA     BORDER_POS_HORIZ,X
    STA     TEXT_ROW
    JSR     PRINT_STRING
    DEC     BORDER_LOOP_CTR
    DEC     BORDER_LOOP_CTR
    LDX     BORDER_LOOP_CTR
    BPL     .loop1

    ; Loop 2: vertical borders left (10 positions from BORDER_POS_VERT_L)
    LDX     #$12                    ; index 18 (9 pairs, counting down by 2)
    STX     BORDER_LOOP_CTR
    stow    BORDER_STR_VERT_L,PRINT_STRING_ADDR
.loop2:
    LDA     BORDER_POS_VERT_L,X
    STA     TEXT_COL
    INX
    LDA     BORDER_POS_VERT_L,X
    STA     TEXT_ROW
    JSR     PRINT_STRING
    DEC     BORDER_LOOP_CTR
    DEC     BORDER_LOOP_CTR
    LDX     BORDER_LOOP_CTR
    BPL     .loop2

    ; Loop 3: vertical borders right (10 positions from BORDER_POS_VERT_R)
    LDX     #$12
    STX     BORDER_LOOP_CTR
    stow    BORDER_STR_VERT_R,PRINT_STRING_ADDR
.loop3:
    LDA     BORDER_POS_VERT_R,X
    STA     TEXT_COL
    INX
    LDA     BORDER_POS_VERT_R,X
    STA     TEXT_ROW
    JSR     PRINT_STRING
    DEC     BORDER_LOOP_CTR
    DEC     BORDER_LOOP_CTR
    LDX     BORDER_LOOP_CTR
    BPL     .loop3
    RTS
    ORG     $5D7A
DRAW_BORDER_ICONS:

    LDA     #$02                    ; char 2 at col 4, row 11
    LDX     #$04
    LDY     #$0B
    JSR     PLOT_CHAR

    LDA     #$01                    ; char 1 at col 4, row 16
    LDX     #$04
    LDY     #$10
    JSR     PLOT_CHAR

    LDA     #$03                    ; char 3 at col 34, row 16
    LDX     #$22
    LDY     #$10
    JSR     PLOT_CHAR

    LDA     #$04                    ; char 4 at col 34, row 11
    LDX     #$22
    LDY     #$0B
    JSR     PLOT_CHAR

    LDA     #$1C                    ; char 28 at col 16, row 16
    LDX     #$10
    LDY     #$10
    JSR     PLOT_CHAR

    LDA     #$1C                    ; char 28 at col 22, row 11
    LDX     #$16
    LDY     #$0B
    JMP     PLOT_CHAR
    ORG     $5DB0
PLOT_CHAR:
    SUBROUTINE

    STA     FONT_CHARNUM
    STX     TEXT_COL
    STY     TEXT_ROW
    LDA     #$01
    STA     FONT_CHARSET
    JMP     PRINT_FONTCHAR_AT_TEXT_POS
    ORG     $5F19
INPUT_LOOP:
    SUBROUTINE
    JSR     SETUP_INPUT
    LDY     #$01
    LDA     ($C0),Y
    STA     CURRENT_SELECTION
.loop:
    LDA     CURRENT_SELECTION
    JSR     CALC_RECORD_PTR
    JSR     SETUP_CURSOR_EXT
    JSR     READ_KEYBOARD
    BEQ     .exit
    JSR     VALIDATE_INPUT
    CMP     CURRENT_SELECTION
    BEQ     .run_script
    CMP     #$00
    BEQ     .run_script
    STA     CURRENT_SELECTION
    JSR     SETUP_CURSOR
    JMP     .loop
.run_script:
    LDX     #$12
    JSR     SCRIPT_ENGINE
    JMP     .loop
.exit:
    LDY     #$08
    LDA     ($C2),Y
    STA     INPUT_JMP_VEC
    INY
    LDA     ($C2),Y
    STA     INPUT_JMP_VEC+1
    JMP     (INPUT_JMP_VEC)
    ORG     $5F60
SETUP_INPUT:
    SUBROUTINE
    ; Set up input: store X/Y in $C1/$C0, call setup routines.
    STX     $C1
    STY     $C0
    JSR     CALL_INPUT_INIT
    JSR     CLEAR_INPUT_BUFFER
    JSR     DRAW_INPUT_OPTIONS
    JMP     RENDER_INPUT_BUFFER
    ORG     $5F70
DRAW_INPUT_OPTIONS:
    SUBROUTINE
    LDY     #$00
    LDA     ($C0),Y
    STA     INPUT_OPTION_COUNT
.loop:
    LDA     INPUT_OPTION_COUNT
    JSR     CALC_RECORD_PTR
    LDY     #$00
    LDA     ($C2),Y
    BEQ     .skip
    JSR     COPY_RECORD_DATA
.skip:
    DEC     INPUT_OPTION_COUNT
    BNE     .loop
    RTS
    ORG     $5F8C
    SUBROUTINE
; $C2/$C3 = $C0/$C1 + A*10 - 6
CALC_RECORD_PTR:
    ASL
    STA     $BA
    ASL
    ASL
    CLC
    ADC     $BA
    ADC     #$FA
    CLC
    ADC     $C0
    STA     $C2
    LDA     $C1
    ADC     #$00
    STA     $C3
    RTS
    ORG     $5FA2
    SUBROUTINE
; JSR SET_INVERSE_VIDEO then falls through to SETUP_CURSOR
SETUP_CURSOR_EXT:
    JSR     SET_INVERSE_VIDEO
    ORG     $5FA5
    SUBROUTINE
; Sets up cursor: calls $5FBC, positions, loads ptr from ($C2)+6/7, prints
SETUP_CURSOR:
    JSR     SET_CURSOR_POS
    JSR     PRINT_CTRL_AB
    LDY     #$06
    LDA     ($C2),Y
    STA     PRINT_STRING_ADDR
    INY
    LDA     ($C2),Y
    STA     PRINT_STRING_ADDR+1
    JSR     PRINT_FROM_PTR
    JMP     PRINT_CTRL_N
    ORG     $5FBC
    SUBROUTINE
; Maps linear position at ($C2)+1 to VTAB ($25) and HTAB ($24)
; Positions 0-39 -> row 21, 40-79 -> row 22, 80+ -> row 23
SET_CURSOR_POS:
    LDY     #$01
    LDA     ($C2),Y
    CMP     #$28
    BCS     .row2
    LDY     #$15               ; row 21
    BNE     .set_pos
.row2:
    SEC
    SBC     #$28
    CMP     #$28
    BCS     .row3
    LDY     #$16               ; row 22
    BNE     .set_pos
.row3:
    LDY     #$17               ; row 23
    SEC
    SBC     #$28
.set_pos:
    STY     $25
    STA     $24
    RTS
    ORG     $5FDD
    SUBROUTINE
; Validates input: saves $C2/$C3, loops reading input until valid record found
VALIDATE_INPUT:
    STA     $5B24
    PSHW    $C2                 ; save $C2/$C3
.retry:
    JSR     READ_INPUT_CHAR
    CMP     #$00
    BEQ     .done
    CMP     CURRENT_SELECTION
    BEQ     .done
    PHA
    JSR     CALC_RECORD_PTR
    LDY     #$00
    LDA     ($C2),Y
    BNE     .found
    PLA
    JMP     .retry
.found:
    PLA
.done:
    TAY
    PULW    $C2                 ; restore $C2/$C3
    TYA
    RTS
    ORG     $600A
    SUBROUTINE
; Returns character at ($C2) + $5B24 + 1
READ_INPUT_CHAR:
    CLC
    LDA     $5B24
    ADC     #$01
    TAY
    LDA     ($C2),Y
    RTS
    ORG     $6014
CALL_INPUT_INIT:
    SUBROUTINE
    LDY     #$02
    LDA     ($C0),Y
    STA     INPUT_JMP_VEC
    INY
    LDA     ($C0),Y
    STA     INPUT_JMP_VEC+1
    JMP     (INPUT_JMP_VEC)
    ORG     $6024
CLEAR_INPUT_BUFFER:
    SUBROUTINE
    LDY     #$77
    LDA     #$A0
.loop:
    STA     INPUT_BUFFER,Y
    DEY
    BPL     .loop
    RTS
    ORG     $602F
RENDER_INPUT_BUFFER:
    SUBROUTINE
    LDA     #$15
    STA     $25
    LDA     #$00
    STA     $24
    JSR     PRINT_CTRL_AB
    LDY     #$00
.loop:
    LDA     INPUT_BUFFER,Y
    STY     $BA
    JSR     ROM_COUT1
    LDY     $BA
    INY
    CPY     #$78
    BNE     .loop
    RTS
    ORG     $604C
    SUBROUTINE
; Copies data from pointer at ($C2)+6/7 into INPUT_BUFFER
COPY_RECORD_DATA:
    LDY     #$06
    LDA     ($C2),Y
    STA     PRINT_STRING_ADDR
    INY
    LDA     ($C2),Y
    STA     PRINT_STRING_ADDR+1
    LDY     #$01
    LDA     ($C2),Y
    STA     $BA
    DEY
    LDA     (PRINT_STRING_ADDR),Y
    TAY
    DEC     $BA
    CLC
    ADC     $BA
    TAX
.copy_loop:
    LDA     (PRINT_STRING_ADDR),Y
    STA     INPUT_BUFFER,X
    DEX
    DEY
    BNE     .copy_loop
    RTS
    ORG     $607D
; Game input option table (7 records x 10 bytes + 4-byte header).
; Record format: [enable, col_offset, key, ?, ?, ?, str_ptr_lo, str_ptr_hi, ?, ?]
; Byte 0 of records 1-6 is patched by CONFIGURE_INPUT based on combat state.
; Header: option count, max_range (patched), init_ptr lo/hi
GAME_INPUT_TABLE:
.header:
    HEX 07              ; 7 options
.max_range = *
    HEX 03              ; max movement range (patched: UNDER_LEVEL*3+3)
    HEX D260            ; init function pointer ($60D2 = CONFIGURE_INPUT)
.rec1:                  ; record 1 ($6081) - movement
.rec1_enable = *
    HEX 01              ; enable (patched: MOVE_POINTS or 0)
    HEX 07040207
    HEX 05537D311A
.rec2:                  ; record 2 ($608B) - combat option
.rec2_enable = *
    HEX 01              ; enable (patched: ~UNDER_LEVEL)
    HEX 2F0103
    HEX 05063E7D0761
.rec3:                  ; record 3 ($6095) - combat option
.rec3_enable = *
    HEX 01              ; enable (patched: ~UNDER_LEVEL)
    HEX 570204
    HEX 0604787BB714
.rec4:                  ; record 4 ($609F) - flee option
.rec4_enable = *
    HEX 01              ; enable (patched: UNDER_LEVEL)
    HEX 570301
    HEX 03077F7BC61B
.rec5:                  ; record 5 ($60A9)
    HEX 01140706
    HEX 0102457D8C61
.rec6:                  ; record 6 ($60B3) - rest option
.rec6_enable = *
    HEX 01              ; enable (patched: SAFE_TO_REST)
    HEX 3C0507
    HEX 0203737B3F14
.rec7:                  ; record 7 ($60BD)
    HEX 01640605
    HEX 0401667B0161
    ORG     $60C7
TEARDOWN_INPUT:
    SUBROUTINE
    ; Teardown input and jump to $5F19.
    JSR     GET_INPUT_TABLE_PTR
    JMP     INPUT_LOOP
    ORG     $60CD
GET_INPUT_TABLE_PTR:
    SUBROUTINE
    ; Return X=$60, Y=$7D (pointer to input table).
    LDX     #$60
    LDY     #$7D
    RTS
    ORG     $60D2
CONFIGURE_INPUT:
    SUBROUTINE
    ; Configure input handler: patch game input table enable flags
    ; from UNDER_LEVEL/SAFE_TO_REST/MOVE_POINTS/TURN_ACTIVE.
    JSR     CHECK_COMBAT_ELIGIBILITY
    LDA     SAFE_TO_REST
    STA     GAME_INPUT_TABLE+54  ; rec6 byte 0 (rest option)
    LDA     UNDER_LEVEL
    STA     GAME_INPUT_TABLE+34  ; rec4 byte 0 (flee option)
    EOR     #$01
    STA     GAME_INPUT_TABLE+14  ; rec2 byte 0 (combat option)
    STA     GAME_INPUT_TABLE+24  ; rec3 byte 0 (combat option)
    EOR     #$01
    CLC
    ADC     #$03
    STA     GAME_INPUT_TABLE+1   ; max movement range
    LDA     MOVE_POINTS
    STA     GAME_INPUT_TABLE+4   ; rec1 byte 0 (movement)
    LDA     TURN_ACTIVE
    BEQ     .clear
    RTS
.clear:
    STA     GAME_INPUT_TABLE+4   ; rec1 byte 0 (movement)
    RTS
    ORG     $62E5
INIT_WORLD:
    SUBROUTINE

    LDX     #>WORLD_INIT_DATA       ; \ X/Y = pointer to init data
    LDY     #<WORLD_INIT_DATA       ; /
    JMP     INPUT_LOOP              ; initialize world from data table

    ORG     $6458
START_GAME_INPUT:
    SUBROUTINE
    LDX     #$64
    LDY     #$36
    JMP     INPUT_LOOP
    ORG     $645F
CHECK_THREATS_HERE:
    SUBROUTINE
    ; Check adjacent threats at current col/row position.
    LDA     CURRENT_COL
    LDY     CURRENT_ROW
    JSR     COLROW_TO_POS
    JMP     CHECK_ADJACENT_THREATS
    ORG     $646B
PICKUP_TREASURE:
    SUBROUTINE

    LDA     #$00
    JSR     SET_CHAR_STATE            ; set char field 15 state to 0
    LDA     EVENT_PTR
    STA     MOB_PTR                 ; copy event ptr → MOB_PTR/MOB_PTR+1
    LDA     EVENT_PTR+1
    STA     MOB_PTR+1
    JSR     COMMIT_MOVE            ; commit move
    LDY     #$01
    LDA     (MOB_PTR),Y             ; event byte 1 = treasure type
    CMP     #$C9
    BPL     .trapped            ; >= $C9 → trapped chest or special
    SEC
    SBC     #$C0                ; $C0-$C8: treasure index 0-8
    STA     NUM_VALUE+1
.rejoin:
    LDY     #$02
    LDA     (MOB_PTR),Y             ; event byte 2 = quantity
    STA     NUM_VALUE
    LDY     #$01
    JSR     MODIFY_CURRENT_STATS            ; look up treasure data
    LDY     #$04
    LDA     (ENTITY_PTR),Y             ; char field 4
    CMP     #$15
    BCS     .mark_used          ; inventory full → skip pickup
    JSR     CLEAR_STATUS_SLOTS            ; add item to inventory
    LDA     #$AB
    STA     $BA
    LDA     #$7B
    STA     $BB
    JSR     NUM_TO_DECIMAL      ; format quantity
    LDY     #$0D
    LDA     (ENTITY_PTR),Y             ; char field 13 (gold low)
    STA     NUM_VALUE
    INY
    LDA     (ENTITY_PTR),Y             ; char field 14 (gold high)
    STA     NUM_VALUE+1
    LDA     #$CC
    STA     $BA
    LDA     #$7B
    STA     $BB
    JSR     NUM_TO_DECIMAL      ; format gold amount
    JSR     SET_CURSOR_ROW21
    LDA     #$84
    STA     NUM_VALUE
    LDA     #$7B
    STA     NUM_VALUE+1
    JSR     CLEAR_AND_DISPLAY            ; display pickup message
.mark_used:
    LDY     #$00
    LDA     #$FE                ; mark event slot as empty
    STA     (MOB_PTR),Y
    RTS

    ; --- trapped chest (type >= $C9) ---
.trapped:
    CMP     #$D1
    BNE     .not_d1
    JMP     .handle_d1          ; $D1: special chest
.not_d1:
    LDA     #$06
    JSR     RANDOM_IN_RANGE     ; random(6)
    AND     #$03                ; trap type 0-3
    STA     TRAP_TYPE
    LDY     #$04
    LDA     (ENTITY_PTR),Y             ; char field 4
    BMI     .apply_trap
    CMP     #$15
    BPL     .apply_trap
    JSR     SET_CURSOR_ROW21
    LDA     #$36
    CLC
    ADC     TRAP_TYPE               ; scene $36 + trap type
    JSR     SCENE_LOOP          ; show trap scene
.apply_trap:
    LDA     TRAP_TYPE
    CMP     #$01
    BMI     .trap0              ; trap 0: lose 1-5 HP
    BEQ     .trap1              ; trap 1: lose 2-9 HP
    CMP     #$02
    BEQ     .trap2              ; trap 2: decrement counter
    BNE     .trap3              ; trap 3: zero gold
.trap0:
    LDA     #$05
    JSR     RANDOM_IN_RANGE
    CLC
    ADC     #$01                ; 1-5 damage
    JSR     APPLY_DAMAGE_TO_CURRENT
    JMP     .after_trap
.trap1:
    LDA     #$08
    JSR     RANDOM_IN_RANGE
    CLC
    ADC     #$02                ; 2-9 damage
    JSR     APPLY_DAMAGE_TO_CURRENT
    JMP     .after_trap
.trap2:
    LDY     #$0B
    LDA     (ENTITY_PTR),Y             ; char field 11
    AND     #$1F
    BEQ     .after_trap         ; already zero
    LDA     (ENTITY_PTR),Y
    SEC
    SBC     #$01                ; decrement
    STA     (ENTITY_PTR),Y
    JMP     .after_trap
.trap3:
    LDY     #$0D
    LDA     #$00
    STA     (ENTITY_PTR),Y             ; zero gold low
    INY
    STA     (ENTITY_PTR),Y             ; zero gold high
.after_trap:
    LDY     #$02
    LDA     (ENTITY_PTR),Y             ; char field 2 = room
    CMP     CURRENT_ROOM               ; current room?
    BEQ     .same_room
    DEY
    LDA     (MOB_PTR),Y             ; event byte 1
    SEC
    SBC     #$09                ; step back 9 in treasure table
    STA     (MOB_PTR),Y
    RTS
.same_room:
    DEY
    LDA     (MOB_PTR),Y             ; event byte 1
    SEC
    SBC     #$C9                ; convert to treasure index
    STA     NUM_VALUE+1
    JMP     .rejoin             ; loop: process next treasure

    ; --- special chest $D1 ---
.handle_d1:
    LDA     #$0B
    JSR     SCENE_LOOP          ; show scene $0B
    JSR     INC_FIELD5_COUNTER
    JSR     INC_FIELD_COUNTER
    LDA     #$03
    JSR     RANDOM_IN_RANGE     ; random(3)
    CMP     #$00
    BEQ     .lucky
    RTS                         ; 2/3 chance: nothing
.lucky:
    LDA     #$0C
    JSR     SCENE_LOOP          ; show bonus scene $0C
    JMP     .mark_used          ; mark event used
    ORG     $657B
INC_FIELD5_COUNTER:
    SUBROUTINE
    ; Increment char field 5 low 5 bits (capped at $1F)
    LDY     #$05
    JMP     .body
INC_FIELD_COUNTER:
    ; Increment char field Y low 5 bits (capped at $1F)
    LDY     #$0B
.body:
    LDA     (ENTITY_PTR),Y
    TAX
    AND     #$1F
    CMP     #$1F
    BNE     .inc
    RTS
.inc:
    CLC
    TXA
    ADC     #$01
    STA     (ENTITY_PTR),Y
    RTS
    ORG     $6593
CLEAR_STATUS_SLOTS:
    SUBROUTINE
    ; Clear 5 bytes at $7BAB-$7BAF and $7BCC-$7BD0 (spaces)
    LDA     #$20
    LDX     #$04
.loop:
    STA     $7BAB,X
    STA     $7BCC,X
    DEX
    BPL     .loop
    RTS
    ORG     $65A1
CLEAR_AND_DISPLAY:
    SUBROUTINE
    ; Clear $5A57 and JMP $764A (display message)
    LDA     #$00
    STA     $5A57
    JMP     DISPLAY_MESSAGE_LOOP
    ORG     $65A9
RANDOM_EVENTS:
    SUBROUTINE
    ; Between-round random event dispatcher.  Each step rolls PRNG and
    ; compares against the event threshold at $4239 (~7% chance).
    ; Cascading: the deeper it goes, the more events fire at once.
    JSR     STEP_PRNG
    LDA     PRNG_OUTPUT
    CMP     EVENT_THRESHOLD
    BPL     .ev2
    JSR     EVENT_PICK_MOB                ; event type 1
.ev2:
    JSR     STEP_PRNG
    LDA     PRNG_OUTPUT
    CMP     EVENT_THRESHOLD
    BPL     .ev3
    JSR     EVENT_PICK_CHAR                ; event type 2
.ev3:
    JSR     STEP_PRNG
    LDA     PRNG_OUTPUT
    CMP     EVENT_THRESHOLD
    BPL     .ev4
    JSR     EVENT_FACTION_SCENE                ; event type 3
.ev4:
    JSR     STEP_PRNG
    LDA     PRNG_OUTPUT
    CMP     EVENT_THRESHOLD
    BPL     .ev5
    JSR     EVENT_SPAWN_MOB                ; event type 4a
.ev5:
    JSR     STEP_PRNG
    LDA     PRNG_OUTPUT
    CMP     EVENT_THRESHOLD
    BPL     .ev6
    JSR     EVENT_SPAWN_MOB                ; event type 4b
.ev6:
    JSR     STEP_PRNG
    LDA     PRNG_OUTPUT
    CMP     EVENT_THRESHOLD
    BMI     .burst
    RTS                             ; no more events this round
.burst:
    JSR     EVENT_SPAWN_MOB                ; event burst: 4 + special + tail
    JSR     EVENT_SPAWN_MOB
    JSR     EVENT_SPAWN_MOB
    JSR     EVENT_SPAWN_MOB
    JSR     PICK_RANDOM_CHAR
    JMP     EVENT_FACTION_SCENE_CONT          ; tail into EVENT_FACTION_SCENE second half
    ORG     $660D
EVENT_PICK_MOB:
    SUBROUTINE
    ; Random event: pick a random mob, then process its char events.
    JSR     PICK_RANDOM_MOB
    JMP     PROCESS_CHAR_EVENTS
    ORG     $6613
EVENT_PICK_CHAR:
    SUBROUTINE
    ; Random event: pick a random character, then process its char events.
    JSR     PICK_RANDOM_CHAR
    JMP     PROCESS_CHAR_EVENTS
    ORG     $6619
EVENT_FACTION_SCENE:
    SUBROUTINE
    ; Random event: pick a random mob, check for matching faction
    ; in the mob list; if found, run SCENE_SETUP for that mob.
    JSR     PICK_RANDOM_MOB
EVENT_FACTION_SCENE_CONT:               ; alternate entry from RANDOM_EVENTS burst
    LDA     CHAR_PTR
    CMP     #$09                        ; $FA still at base ($4009)?
    BNE     .has_char
    RTS                                 ; no character selected → skip
.has_char:
    LDY     #$05
    LDA     (CHAR_PTR),Y                     ; char record byte 5
    AND     #$60                        ; bits 6-5 = faction mask
    STA     FACTION_MASK                         ; save for FIND_MOB_BY_FACTION
    LDA     #$00                        ; \
    STA     CHAR_PTR                         ;  | reset $FA/$FB to $4000 (record base)
    LDA     #$40                        ;  |
    STA     CHAR_PTR+1                         ; /
    JSR     FIND_MOB_BY_FACTION         ; search mob list for matching faction
    CMP     #$00
    BNE     .found
    JMP     EVENT_SPAWN_MOB             ; not found → try spawning instead
.found:
    LDA     #$00
    STA     SOURCE_CHAR                 ; clear source char
    LDA     CHAR_INDEX
    STA     ACTIVE_CHAR                 ; set active char to found index
    JSR     SCENE_SETUP
    JSR     CHECK_LOCATION_MATCH
    RTS
    ORG     $664E
EVENT_SPAWN_MOB:
    SUBROUTINE
    ; Random event: pick a random character; if its byte 8 is nonzero
    ; (active), try again once.  If inactive, use its faction to find
    ; a matching mob and reorder it into the group.
    JSR     PICK_RANDOM_CHAR
    LDY     #$08
    LDA     (CHAR_PTR),Y                     ; char record byte 8
    BEQ     .inactive                   ; zero = slot available
    JSR     PICK_RANDOM_CHAR            ; try once more
    LDY     #$08
    LDA     (CHAR_PTR),Y
    BEQ     .inactive
    RTS                                 ; both active → give up
.inactive:
    LDY     #$05
    LDA     (CHAR_PTR),Y                     ; char record byte 5
    AND     #$60                        ; faction mask
    STA     FACTION_MASK
    JSR     FIND_MOB_BY_FACTION
    CMP     #$00
    BNE     .found
    RTS                                 ; no matching mob → skip
.found:
    LDA     CHAR_INDEX
    STA     SOURCE_CHAR
    LDA     #$00
    STA     ACTIVE_CHAR
    LDA     MOB_PTR                         ; \
    STA     TARGET_REC                         ;  | TARGET_REC/TARGET_REC+1 = mob data pointer
    LDA     MOB_PTR+1                         ;  |
    STA     TARGET_REC+1                         ; /
    JSR     REORDER_CHAR
    JMP     CLAMP_CHAR_FIELD
    ORG     $6689
PICK_RANDOM_MOB:
    SUBROUTINE
    ; Pick a random mob group by weighted selection.
    ; Uses TOTAL_MOB_COUNT as the range, then iterates char records
    ; subtracting group counts (byte 8) until the target is reached.
    ; Result: $FA/$FB points to the selected char record.
    LDA     TOTAL_MOB_COUNT
    BEQ     PICK_RANDOM_CHAR            ; no mobs → fall through to pick char
    JSR     RANDOM_IN_RANGE             ; random 0..TOTAL_MOB_COUNT-1
    CMP     #$00
    BEQ     PICK_RANDOM_MOB             ; zero = retry
    STA     MOB_PTR                         ; remaining count
    LDA     #$01
    STA     CHAR_INDEX                         ; player index counter
.next_char:
    LDA     CHAR_INDEX
    JSR     GET_CHAR_RECORD
    LDY     #$08
    LDA     MOB_PTR                         ; remaining
    SEC
    SBC     (DATA_PTR),Y                     ; subtract group count (byte 8)
    STA     MOB_PTR
    BEQ     .found                      ; exact match
    BMI     .found                      ; overshot → this is the one
    INC     CHAR_INDEX
    BNE     .next_char                  ; always branches
.found:
COPY_BE_TO_FA:
    LDA     DATA_PTR                         ; \
    STA     CHAR_PTR                         ;  | $FA/$FB = DATA_PTR/DATA_PTR+1 (selected record)
    LDA     DATA_PTR+1                         ;  |
    STA     CHAR_PTR+1                         ; /
    RTS
    ORG     $66BA
PICK_RANDOM_CHAR:
    SUBROUTINE
    ; Pick a random character from players 2..CURRENT_PLAYER-1.
    ; Result: $FA/$FB points to the selected char record, CHAR_INDEX = index.
    LDA     CURRENT_PLAYER
    SEC
    SBC     #$03                        ; range = CURRENT_PLAYER - 3
    JSR     RANDOM_IN_RANGE             ; random 0..range-1
    CLC
    ADC     #$02                        ; offset to player 2
    STA     CHAR_INDEX                         ; save selected index
    JSR     GET_CHAR_RECORD             ; load record for player A
    JMP     COPY_BE_TO_FA               ; copy DATA_PTR/DATA_PTR+1 → $FA/$FB
    ORG     $66CE
PROCESS_CHAR_EVENTS:
    SUBROUTINE
    ; Walk the 3-byte event list pointed to by char record bytes 6-7.
    ; For entries with byte 1 in range $40-$7F, subtract $40 from the
    ; value and trigger the event via CHECK_LOCATION_MATCH.
    LDY     #$06
    LDA     (CHAR_PTR),Y                     ; char record byte 6 = event list low
    STA     EVENT_PTR
    INY
    LDA     (CHAR_PTR),Y                     ; byte 7 = event list high
    STA     EVENT_PTR+1
.scan:
    LDY     #$00
    LDA     (EVENT_PTR),Y                     ; event byte 0
    CMP     #$FF                        ; $FF = end of list
    BNE     .check
    RTS
.check:
    INY
    LDA     (EVENT_PTR),Y                     ; event byte 1
    BMI     .advance                    ; bit 7 set → skip
    CMP     #$40                        ; < $40?
    BMI     .advance                    ; yes → skip
    SEC
    SBC     #$40                        ; normalize to 0-based
    STA     (EVENT_PTR),Y                     ; write back
    LDA     CHAR_INDEX
    STA     ACTIVE_CHAR                 ; save triggering player index
    JMP     CHECK_LOCATION_MATCH
.advance:
    CLC
    LDA     EVENT_PTR
    ADC     #$03                        ; next 3-byte entry
    STA     EVENT_PTR
    BCC     .no_carry
    INC     EVENT_PTR+1
.no_carry:
    JMP     .scan
    ORG     $6706
FIND_MOB_BY_FACTION:
    SUBROUTINE
    ; Walk the mob linked list from ($FA) byte 2, looking for a mob
    ; whose byte $0F has bit 7 set and bits 6-4 match FACTION_MASK (faction).
    ; Returns A=1 if found (with MOB_PTR/MOB_PTR+1 pointing to it), A=0 if not.
    LDY     #$02
    LDA     (CHAR_PTR),Y                     ; char record byte 2 = first link
.check_link:
    BNE     .resolve
    RTS                                 ; zero link → return A=0
.resolve:
    JSR     GET_MOB_DATA                ; resolve link → MOB_DATA_PTR/MOB_DATA_PTR+1
    LDA     MOB_DATA_PTR                         ; \
    STA     MOB_PTR                         ;  | MOB_PTR/MOB_PTR+1 = mob data pointer
    LDA     MOB_DATA_PTR+1                         ;  |
    STA     MOB_PTR+1                         ; /
    LDY     #$0F
    LDA     (MOB_PTR),Y                     ; mob data byte $0F
    BPL     .next                       ; bit 7 clear → skip
    AND     #$70                        ; bits 6-4
    CMP     FACTION_MASK                         ; match faction?
    BNE     .next
    LDA     #$01                        ; found → return 1
    RTS
.next:
    LDY     #$02
    LDA     (MOB_PTR),Y                     ; next link
    JMP     .check_link
    ORG     $672E
CHECK_LOCATION_MATCH:
    SUBROUTINE
    ; Load char record for ACTIVE_CHAR ($5A29), check if DATA_PTR matches
    ; LOCATION_POS.  If so, clear LOCATION_POS to force a redraw.
    LDA     ACTIVE_CHAR
    JSR     GET_CHAR_RECORD
    LDA     DATA_PTR
    CMP     LOCATION_POS
    BEQ     .match
    RTS
.match:
    LDA     #$00
    STA     LOCATION_POS                ; clear to trigger redraw
    RTS
    ORG     $6742
NPC_MOVE_AI:
    SUBROUTINE
    ; NPC movement AI: evaluate 4 directions + stay, pick best
    ; direction based on distance to target and randomized scoring.
    JSR     ANIM_TICK_AND_WAIT
    LDA     CHAR_AI_MODE
    CMP     #$04
    BEQ     .do_ai
    LDA     AI_TARGET_POS
    CMP     #$00
    BNE     .do_ai
    RTS
.do_ai:
    LDA     #$00
    STA     $5A6B
    STA     $5A6C
    STA     $5A6D
    STA     $5A6E
    LDA     #$0A
    STA     DIR_SCORES
    LDA     AI_TARGET_POS
    JSR     MANHATTAN_DISTANCE
    STA     $5A68
    CMP     #$00
    BEQ     .no_target
    LDA     #$13
    STA     DIR_SCORES
.no_target:
    LDX     AI_PREV_DIR
    BEQ     .no_prev
    INC     DIR_SCORES,X
    INC     DIR_SCORES,X
    INC     DIR_SCORES,X
.no_prev:
    LDA     #$01
    STA     AI_DIRECTION
    LDY     #$03
    LDA     (ENTITY_PTR),Y
    SEC
    SBC     #$14
    STA     AI_TEST_POS
    JSR     EVALUATE_DIRECTION
    INC     AI_DIRECTION
    LDA     AI_TEST_POS
    CLC
    ADC     #$28
    STA     AI_TEST_POS
    JSR     EVALUATE_DIRECTION
    INC     AI_DIRECTION
    LDA     AI_TEST_POS
    SEC
    SBC     #$15
    STA     AI_TEST_POS
    JSR     EVALUATE_DIRECTION
    INC     AI_DIRECTION
    INC     AI_TEST_POS
    INC     AI_TEST_POS
    JSR     EVALUATE_DIRECTION
    LDA     #$06
    STA     AI_DIRECTION
    LDA     CHAR_AI_MODE
    CMP     #$04
    BNE     .not_phase4
    LDA     #$0F
    STA     AI_DIRECTION
.not_phase4:
    LDX     #$04
    CLC
.score_loop:
    LDA     DIR_SCORES,X
    ROL
    ROL
    STA     DIR_SCORES,X
    LDA     AI_DIRECTION
    JSR     RANDOM_IN_RANGE
    CLC
    ADC     DIR_SCORES,X
    STA     DIR_SCORES,X
    DEX
    BPL     .score_loop
    LDA     #$7F
    STA     $BA
    LDX     #$04
.find_min:
    LDA     DIR_SCORES,X
    CMP     $BA
    BCS     .not_lower
    STA     $BA
    STX     $BB
.not_lower:
    DEX
    BPL     .find_min
    LDA     $BB
    CMP     #$03
    BPL     .ge3
    EOR     #$03
    BPL     .store_dir
.ge3:
    EOR     #$07
.store_dir:
    STA     AI_PREV_DIR
    LDA     $BB
    RTS
    ORG     $6815
EVALUATE_DIRECTION:
    SUBROUTINE
    LDA     AI_TARGET_POS
    CMP     AI_TEST_POS
    BEQ     .skip_target
    LDY     #$09
    JSR     INC_MOB_COUNTERS
.skip_target:
    LDY     #$03
    LDA     (ENTITY_PTR),Y
    STA     $5A69
    LDA     AI_TEST_POS
    STA     (ENTITY_PTR),Y
    LDA     AI_TARGET_POS
    BEQ     .no_distance
    JSR     MANHATTAN_DISTANCE
    CMP     $5A68
    BCC     .no_distance
    LDY     #$02
    JSR     INC_MOB_COUNTERS
.no_distance:
    LDY     #$03
    LDA     $5A69
    STA     (ENTITY_PTR),Y
    LDA     AI_TEST_POS
    JSR     FIND_ENTITY_AT_POS
    LDA     ENTITY_REC+1
    BNE     .has_entity
    LDA     ENTITY_REC
    BNE     .wall
    RTS
.wall:
    LDY     #$07
    JMP     INC_MOB_COUNTERS
.has_entity:
    CMP     #$80
    BCC     .mob
    RTS
.mob:
    LDY     #$01
    LDA     (ENTITY_REC),Y
    CMP     #$80
    BCS     .ge80
    LDY     #$03
    JMP     INC_MOB_COUNTERS
.ge80:
    CMP     #$C0
    BCS     .geC0
    LDY     #$06
    JMP     INC_MOB_COUNTERS
.geC0:
    CMP     #$D2
    BCS     .geD2
    LDY     #$01
    JMP     INC_MOB_COUNTERS
.geD2:
    CMP     #$D5
    BCS     .geD5
    LDY     #$02
    JMP     INC_MOB_COUNTERS
.geD5:
    CMP     #$D8
    BCS     .geD8
    LDY     #$03
    JMP     INC_MOB_COUNTERS
.geD8:
    INY
    LDA     (ENTITY_REC),Y
    CMP     #$40
    BCS     .safe
    LDY     #$07
    JMP     INC_MOB_COUNTERS
.safe:
    LDY     #$01
; falls through to INC_MOB_COUNTERS
    ORG     $689F
    SUBROUTINE
; Increments mob counters; Y = count-1 on entry
INC_MOB_COUNTERS:
    LDX     AI_DIRECTION
    DEY
    BPL     .do_inc
    RTS
.do_inc:
    INC     DIR_SCORES,X
    BPL     INC_MOB_COUNTERS
    ORG     $68AB
AI_CHOOSE_TARGET:
    SUBROUTINE

    ; --- dispatch by AI mode ---
    LDA     #$00
    STA     AI_PREV_DIR
    LDA     CHAR_AI_MODE
    CMP     #$02
    BPL     .mode_ge2

    ; --- mode 0/1: check if NPC should join party ---
    JSR     PICK_RANDOM_MEMBER
    LDA     MOB_PTR+1
    CMP     #$00
    BEQ     .simple_target      ; no match → simple target
    JSR     SET_CURSOR_ROW21
    LDA     #$24
    JSR     DISPLAY_MESSAGE     ; "joins party" message
    JSR     PRINT_MEMBER_NAME
    JSR     RESET_TEXT_WINDOW
    JSR     DELAY_WITH_ANIMATION
    LDA     #$25
    JSR     DISPLAY_MESSAGE
    LDA     #$00
    STA     CHAR_AI_MODE        ; switch to player control
    LDY     #$04
    LDA     (ENTITY_PTR),Y
    SEC
    SBC     #$15                ; adjust char field 4
    STA     (ENTITY_PTR),Y
    LDY     #$0F
    LDA     (MOB_PTR),Y             ; source field 15 high bits
    AND     #$C0
    STA     $BA
    LDA     (ENTITY_PTR),Y             ; target field 15 low bits
    AND     #$3F
    ORA     $BA                 ; merge high bits from source
    STA     (ENTITY_PTR),Y
    LDY     #$08
    LDA     (CHAR_PTR),Y             ; group field 8
    CLC
    ADC     #$01                ; increment party size
    STA     (CHAR_PTR),Y
    INC     $5A01               ; increment global party count
    RTS

    ; --- mode 2: compare stats for target ---
.mode_ge2:
    BNE     .mode_ge3
.simple_target:
    LDY     #$05
    LDA     (ENTITY_PTR),Y             ; char field 5
    AND     #$1F
    STA     $BA
    INY
    LDA     (ENTITY_PTR),Y             ; char field 6
    AND     #$3F
    CMP     $BA
    BPL     .use_encounter
    LDA     #$00
    STA     AI_TARGET_POS               ; no target
    JMP     .done
.use_encounter:
    JSR     FIND_NEAREST_EVENT            ; find encounter position
    STA     AI_TARGET_POS
    JMP     .done

    ; --- mode 3: find nearest hostile ---
.mode_ge3:
    CMP     #$04
    BPL     .mode_ge4
    LDA     ENTITY_PTR
    STA     TARGET_REC
    LDA     ENTITY_PTR+1
    STA     TARGET_REC+1
    LDA     #$3C                ; initial min distance
    STA     AI_TARGET_COL
    JSR     FIRST_GROUP_MEMBER
.loop3:
    JSR     CHECK_HOSTILE
    CMP     #$00
    BEQ     .skip3
    LDY     #$03
    LDA     (MOB_PTR),Y             ; mob packed position
    JSR     MANHATTAN_DISTANCE            ; compute distance
    CMP     AI_TARGET_COL
    BCS     .skip3              ; not closer
    STA     AI_TARGET_COL               ; new minimum
    LDY     #$03
    LDA     (MOB_PTR),Y
    STA     AI_TARGET_POS               ; target = this mob's position
.skip3:
    JSR     NEXT_GROUP_MEMBER            ; next group member
    LDA     MOB_PTR+1
    BNE     .loop3
    LDA     AI_TARGET_COL
    CMP     #$3C
    BNE     .found3
    LDA     EVENT_POS               ; no hostile found → use default
    STA     AI_TARGET_POS
.found3:
    JMP     .done

    ; --- mode 4: no target ---
.mode_ge4:
    BNE     .mode_gt4
    LDA     #$00
    STA     AI_TARGET_POS
    JMP     .done

    ; --- mode 5+: find strongest hostile ---
.mode_gt4:
    LDA     #$00
    STA     AI_BEST_STR         ; max strength seen
    LDA     ENTITY_PTR
    STA     TARGET_REC
    LDA     ENTITY_PTR+1
    STA     TARGET_REC+1
    JSR     FIRST_GROUP_MEMBER
.loop5:
    JSR     CHECK_HOSTILE
    CMP     #$00
    BEQ     .skip5
    LDY     #$05
    LDA     (MOB_PTR),Y             ; mob field 5
    AND     #$1F                ; strength stat
    CMP     AI_BEST_STR
    BMI     .skip5              ; not stronger
    STA     AI_BEST_STR         ; new max
    LDY     #$03
    LDA     (MOB_PTR),Y
    STA     AI_BEST_POS         ; target position
.skip5:
    JSR     NEXT_GROUP_MEMBER            ; next group member
    LDA     MOB_PTR+1
    BNE     .loop5
    LDA     AI_BEST_STR
    BEQ     .no_target5
    LDA     AI_BEST_POS
    STA     AI_TARGET_POS               ; strongest mob's position
    JMP     .done
.no_target5:
    LDA     EVENT_POS               ; no hostile → use default
    STA     AI_TARGET_POS
    JMP     .done

    ; --- convert target position to col/row ---
.done:
    LDA     AI_TARGET_POS
    JSR     POS_TO_COLROW
    STA     AI_TARGET_COL               ; target column
    STY     $5A73               ; target row
    RTS
    ORG     $6B94
INIT_STUB2:
    RTS
    ORG     $6C18
SETUP_DISK_READ:
    SUBROUTINE

    LDY     #$0C
    STA     ($08),Y                 ; ($08)+$0C = track number (A)
    LDA     #$00
    LDY     #$03
    STA     ($08),Y                 ; ($08)+$03 = 0 (sector offset)
    LDA     $09                     ; \ A/Y = slot parameter block
    LDY     $08                     ; /
    JSR     $B7B5                   ; EALDR seek routine
    LDA     #$00
    STA     $48                     ; clear disk status
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
    STOW    SCENE_TEXT_DATA,TEXT_STREAM_PTR ; scene text data → $06/$07
    JSR     TEXT_RENDERER

    LDX     #$06                    ; script index 6
    JSR     SCRIPT_ENGINE           ; run script #3 ($A300)
    LDA     SCENE_TRANSITION        ; scene transition flag
    BEQ     .done                   ; zero = no transition
    STA     SCENE_NUMBER            ; set new scene number
    JMP     .display                ; continue

.exit:
    JSR     SET_TEXT_WINDOW_BOTTOM
    LDA     #$1B
    JSR     DISPLAY_MESSAGE         ; display message (mode off)
                                    ; fall through to .done

.done:
    JSR     SET_TEXT_WINDOW_BOTTOM
    LDA     #$00                    ; \
    STA     LOCATION_POS           ;  | clear location flags
    STA     LOCATION_STYLE          ; /
    JSR     ENTER_LOCATION          ; redraw map if location changed
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
    LDA     (TEXT_STREAM_PTR),Y     ; read byte from stream
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
    JMP     MOVE_LOOP               ; overflow handler

    ; --- Position command ($80-$FE) ---
.set_pos:
    AND     #$7F                    ; row = byte & $7F
    STA     FONT_ROW
    INY
    LDA     (TEXT_STREAM_PTR),Y     ; next byte = column
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
    PSHW    TEXT_STREAM_PTR         ; save stream pointer
    JSR     DISPLAY_STATUS_BAR      ; (clobbers TEXT_STREAM_PTR)
    PULW    TEXT_STREAM_PTR         ; restore stream pointer
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
    STOW    STATUS_BORDER_DATA,TEXT_STREAM_PTR ; status bar border data → $06/$07
    JSR     TEXT_RENDERER           ; draw border box
    JSR     PRINT_CTRL_AB           ; Ctrl-A, '0'
    LDA     #$17
    STA     TEXT_ROW                ; WNDBTM = 23

    LDA     $5A00                   ; joystick/keyboard flag
    BNE     .joystick

    ; Keyboard path:
    LDA     #<S_PRESS_SPACE
    STA     PRINT_STRING_ADDR
    LDA     #>S_PRESS_SPACE
.store_hi_and_print:
    STA     PRINT_STRING_ADDR+1
.set_margin:
    LDA     #$04
    STA     TEXT_COL                ; WNDLFT = 4
    JMP     PRINT_FROM_PTR         ; print string, return

.joystick:
    LDA     #<S_PRESS_BUTTON
    STA     PRINT_STRING_ADDR
    LDA     #>S_PRESS_BUTTON
    JMP     .store_hi_and_print     ; reuse STA PRINT_STRING_ADDR+1 from keyboard path
    ORG     $6D53
SAVE_ZP_POINTERS:
    SUBROUTINE

    LDA     TARGET_REC
    STA     SAVED_BC
    LDA     TARGET_REC+1
    STA     SAVED_BC+1
    LDA     ENTITY_PTR
    STA     SAVED_F8
    LDA     ENTITY_PTR+1
    STA     SAVED_F8+1
    LDA     DATA_PTR
    STA     SAVED_BE
    LDA     DATA_PTR+1
    STA     SAVED_BE+1
    LDA     MOB_PTR
    STA     SAVED_F4
    LDA     MOB_PTR+1
    STA     SAVED_F4+1
    RTS
    ORG     $6D7C
RESTORE_ZP_POINTERS:
    SUBROUTINE

    LDA     SAVED_BC
    STA     TARGET_REC
    LDA     SAVED_BC+1
    STA     TARGET_REC+1
    LDA     SAVED_F8
    STA     ENTITY_PTR
    LDA     SAVED_F8+1
    STA     ENTITY_PTR+1
    LDA     SAVED_BE
    STA     DATA_PTR
    LDA     SAVED_BE+1
    STA     DATA_PTR+1
    LDA     SAVED_F4
    STA     MOB_PTR
    LDA     SAVED_F4+1
    STA     MOB_PTR+1
    RTS
    ORG     $6DA5
RELOCATE_HIRES_STAGING:
    SUBROUTINE

    LDA     #$00
    STA     COPY_DEST                         ; \  dest = $9600
    STA     COPY_SRC                         ; \  src  = $2000
    LDA     #$20                        ;  |
    STA     COPY_SRC+1                         ; /  src hi
    LDA     #$96                        ;  |
    STA     COPY_DEST+1                         ; /  dest hi
    LDY     #$00
    LDX     #$13                        ; 19 pages: $2000-$32FF -> $9600-$A8FF
    JSR     .copy
    LDX     #$0D                        ; 13 pages: $3300-$3FFF -> $B300-$BFFF
    LDA     #$B3
    STA     COPY_DEST+1                         ; dest hi = $B3
    INC     COPY_SRC+1                         ; src hi = $33 (was $32 after first pass)

.copy:
    LDA     (COPY_SRC),Y                     ; load from source
    STA     (COPY_DEST),Y                     ; store to dest
    LDA     #$00
    STA     (COPY_SRC),Y                     ; clear source byte
    DEY
    BNE     .copy                       ; inner loop (256 bytes)
    DEX
    BNE     .next_page                  ; more pages?
    RTS

.next_page:
    INC     COPY_SRC+1                         ; next source page
    INC     COPY_DEST+1                         ; next dest page
    JMP     .copy
    ORG     $6DD8
LOAD_SCENE_DATA:
    SUBROUTINE

    BIT     $C0E9                   ; check disk controller
    LDA     #$05                    ; \
    LDY     #$04                    ;  | ($08)+4 = 5 (track configuration)
    STA     ($08),Y                 ; /
    LDA     #$00
    JSR     SETUP_DISK_READ         ; prepare disk parameters
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
    ORG     $6DFA
CHECK_SCENE_EVENTS:
    SUBROUTINE
    ; Scene event dispatcher for players 1 & 3.  Checks encounter
    ; state and dispatches to SCENE_LOOP with mode 4-8 based on
    ; game state flags.  Called from MAIN_ENTRY's character loop.
    LDA     #$00
    CMP     SCENE_HOSTILE_DONE      ; already processed hostiles?
    BNE     .done                   ; yes → skip
    LDA     #$40
    STA     SCENE_GROUP_IDX         ; start scanning from group $40
    JSR     SCAN_FOR_HOSTILE                ; scan for hostile encounter
    LDA     #$01
    CMP     SCENE_FOUND_FLAG        ; found a matching group?
    BNE     .done                   ; no → skip
    CMP     CURRENT_PLAYER          ; is this player 1?
    BNE     .other_player
    CMP     SCENE_HOSTILE_FLAG      ; hostile encounter found?
    BNE     .hostile
    CMP     SCENE_P1_DONE           ; player 1 already processed?
    BEQ     .done                   ; yes → skip
    STA     SCENE_P1_DONE           ; mark as done
    LDA     #$04
    JMP     SCENE_LOOP              ; mode 4: player 1 non-hostile scene
.done:
    RTS
.other_player:
    CMP     SCENE_P3_DONE           ; player 3 already processed?
    BEQ     .done                   ; yes → skip
    STA     SCENE_P3_DONE           ; mark as done
    JSR     SET_CURSOR_ROW21
    LDA     #$05
    JMP     SCENE_LOOP              ; mode 5: other player scene
.hostile:
    STA     SCENE_HOSTILE_DONE      ; mark hostile as processed
    LDA     #$06
    JSR     SCENE_LOOP              ; mode 6: hostile encounter intro
    JSR     PROCESS_SCENE_GROUPS                ; process mob groups
    LDA     SCENE_EVENT_RESULT
    BNE     .done                   ; nonzero = event handled, stop
    LDA     #$07
    JSR     SCENE_LOOP              ; mode 7: post-encounter
    LDA     SCENE_COMBAT_FLAG
    BEQ     .done                   ; no combat → done
    JSR     SCROLL_STATUS_LINE
    LDA     #$08
    JMP     SCENE_LOOP              ; mode 8: combat resolution
    ORG     $6E5A
SCAN_FOR_HOSTILE:
    SUBROUTINE
    ; Scan mob groups starting from SCENE_GROUP_IDX for hostile encounters.
    ; Sets SCENE_FOUND_FLAG=1 if the group matches, SCENE_HOSTILE_FLAG
    ; nonzero if a hostile is found.
    LDA     #$00
    STA     SCENE_FOUND_FLAG
    STA     SCENE_HOSTILE_FLAG
    LDA     SCENE_GROUP_IDX
    JSR     GET_MOB_DATA                ; resolve group → MOB_DATA_PTR/MOB_DATA_PTR+1
    LDA     MOB_DATA_PTR                         ; \
    STA     MOB_PTR                         ;  | MOB_PTR/MOB_PTR+1 = mob data pointer
    LDA     MOB_DATA_PTR+1                         ;  |
    STA     MOB_PTR+1                         ; /
    LDA     CHAR_PTR                         ; \
    STA     MOB_DATA_PTR                         ;  | save $FA/$FB into MOB_DATA_PTR/MOB_DATA_PTR+1
    LDA     CHAR_PTR+1                         ;  |
    STA     MOB_DATA_PTR+1                         ; /
.walk:
    LDY     #$02
    LDA     (MOB_DATA_PTR),Y                     ; mob data byte 2 = next link
    BNE     .has_link
    RTS                                 ; end of chain
.has_link:
    CMP     SCENE_GROUP_IDX             ; matches the target group?
    BNE     .check_hostile
    LDX     #$01
    STX     SCENE_FOUND_FLAG            ; mark as found
.check_hostile:
    JSR     GET_MOB_DATA                ; resolve link → MOB_DATA_PTR/MOB_DATA_PTR+1
    LDA     MOB_DATA_PTR                         ; \
    STA     TARGET_REC                         ;  | TARGET_REC/TARGET_REC+1 = resolved mob data
    LDA     MOB_DATA_PTR+1                         ;  |
    STA     TARGET_REC+1                         ; /
    JSR     CHECK_HOSTILE               ; check if hostile
    BEQ     .walk                       ; not hostile → continue
    STA     SCENE_HOSTILE_FLAG          ; hostile found
    BNE     .walk                       ; always branches, continue scan
    ORG     $6E9E
PROCESS_SCENE_GROUPS:
    SUBROUTINE
    ; Process mob groups $3F, $41, $42 with SCAN_AND_REORDER,
    ; bookended by LOAD_CHAR_TO_FA for save/restore.
    LDA     #$03
    STA     SOURCE_CHAR
    JSR     LOAD_CHAR_TO_FA             ; save player 3's record to $FA/$FB
    LDA     #$00
    STA     ACTIVE_CHAR
    LDA     #$3F
    STA     SCENE_GROUP_IDX
    JSR     SCAN_AND_REORDER            ; group $3F
    INC     SCENE_GROUP_IDX             ; $40 (skip — that's the player's group)
    INC     SCENE_GROUP_IDX             ; $41
    JSR     SCAN_AND_REORDER            ; group $41
    INC     SCENE_GROUP_IDX             ; $42
    JSR     SCAN_AND_REORDER            ; group $42
    LDA     CURRENT_PLAYER
    JSR     LOAD_CHAR_TO_FA             ; restore current player's record
    RTS
    ORG     $6EC9
LOAD_CHAR_TO_FA:
    SUBROUTINE
    ; Wrapper: GET_CHAR_RECORD then copy CHAR_REC → $FA/$FB.
    JSR     GET_CHAR_RECORD
    LDA     DATA_PTR
    STA     CHAR_PTR
    LDA     DATA_PTR+1
    STA     CHAR_PTR+1
    RTS
    ORG     $6ED5
SCAN_AND_REORDER:
    SUBROUTINE
    ; Call SCAN_FOR_HOSTILE for current SCENE_GROUP_IDX.
    ; If a match is found, copy MOB_PTR/MOB_PTR+1 → TARGET_REC/TARGET_REC+1 and reorder.
    JSR     SCAN_FOR_HOSTILE
    LDA     SCENE_FOUND_FLAG
    BNE     .found
    RTS                                 ; nothing found
.found:
    LDA     MOB_PTR                         ; \
    STA     TARGET_REC                         ;  | TARGET_REC/TARGET_REC+1 = mob data pointer
    LDA     MOB_PTR+1                         ;  |
    STA     TARGET_REC+1                         ; /
    JMP     REORDER_CHAR
    ORG     $704D
MODIFY_CHAR_STATS:
    SUBROUTINE
    ; Add or subtract gold from char record at (EFFECT_REC).
    ; Y=0: subtract NUM_VALUE/NUM_VALUE+1 from field 13/14
    ; Y≠0: add NUM_VALUE/NUM_VALUE+1 to field 13/14
    ; Then recompute field 12 (level/XP encoding).
    CPY     #$00
    BEQ     .subtract
    LDY     #$0D
    LDA     (EFFECT_REC),Y
    CLC
    ADC     NUM_VALUE
    STA     (EFFECT_REC),Y
    INY
    LDA     (EFFECT_REC),Y
    ADC     NUM_VALUE+1
    STA     (EFFECT_REC),Y
    JMP     .aftermath
.subtract:
    LDY     #$0D
    SEC
    LDA     (EFFECT_REC),Y
    SBC     NUM_VALUE
    STA     (EFFECT_REC),Y
    INY
    LDA     (EFFECT_REC),Y
    SBC     NUM_VALUE+1
    STA     (EFFECT_REC),Y
.aftermath:
    LDY     #$05
    LDA     (EFFECT_REC),Y
    ROL
    ROL
    ROL
    AND     #$F8
    STA     $5A7E
    LDY     #$0C
    LDA     (EFFECT_REC),Y
    PHA
    AND     #$0F
    TAX
    PLA
    ROR
    ROR
    ROR
    ROR
    AND     #$0F
    TAY
.decy:
    DEY
    BMI     .done_cnt
    INX
    BPL     .decy
.done_cnt:
    INY
    STY     STAT_LEVEL_BITS
    STY     $BA
    STY     $BB
.outer_loop:
    LDY     #$0E
    CPX     #$00
    BEQ     .store_final
    CLC
    LDA     $BA
    ADC     $5A7E
    STA     $BA
    BCC     .no_carry
    INC     $BB
.no_carry:
    LDA     (EFFECT_REC),Y
    CMP     $BB
    BCC     .store_final
    BNE     .next_iter
    DEY
    LDA     (EFFECT_REC),Y
    CMP     $BA
    BCC     .store_final
.next_iter:
    DEX
    CLC
    LDA     STAT_LEVEL_BITS
    ADC     #$10
    STA     STAT_LEVEL_BITS
    BNE     .outer_loop
.store_final:
    TXA
    ORA     STAT_LEVEL_BITS
    LDY     #$0C
    STA     (EFFECT_REC),Y
    RTS
    ORG     $70D4
MODIFY_CURRENT_STATS:
    SUBROUTINE
    ; Copy ENTITY_PTR/ENTITY_PTR+1 → EFFECT_REC/EFFECT_REC+1, JMP $704D (treasure lookup)
    LDA     ENTITY_PTR
    STA     EFFECT_REC
    LDA     ENTITY_PTR+1
    STA     EFFECT_REC+1
    JMP     MODIFY_CHAR_STATS
    ORG     $70DF
DISPLAY_SHOP:
    SUBROUTINE
    ; Shop/store display: iterate through item bitmask,
    ; show prices and names for available items.
    LDA     CHAR_AI_MODE
    BEQ     .do_shop
    RTS
.do_shop:
    LDA     #$DD
    STA     $E6
    LDA     #$7E
    STA     $E7
    LDY     #$01
    LDA     (ENTITY_REC),Y
    SEC
    SBC     #$D5
    TAX
.count_loop:
    DEX
    BMI     .counted
    JSR     ADVANCE_SHOP_PTR
    JMP     .count_loop
.counted:
    LDY     #$02
    LDA     (ENTITY_REC),Y
    STA     $5A83
    JSR     SET_CURSOR_ROW21
    LDY     #$28
    LDA     ($E6),Y
    JSR     SCENE_LOOP
    JSR     LOAD_CHAR_NAME_PTR
    JSR     SETUP_CHAR_SPRITE
.item_start:
    LDA     #$80
    STA     SHOP_ITEM_MASK
    LDA     #$00
    STA     SHOP_ITEM_OFFSET
.item_loop:
    LDA     $5A83
    AND     SHOP_ITEM_MASK
    BNE     .show_item
    JMP     .next_item
.show_item:
    LDA     #$00
    STA     SHOP_PRICE
    STA     SHOP_PRICE_HI
    LDY     SHOP_ITEM_OFFSET
    INY
    INY
    INY
    INY
    LDA     LOCATION_STYLE
    ROL
    ROL
    ROL
    ROL
    AND     #$03
    TAX
    STA     $5A84
.price_loop:
    JSR     ADD_PRICE_COMPONENT
    DEX
    BPL     .price_loop
    LDA     #$20
    LDX     #$04
.clear1:
    STA     $7D04,X
    DEX
    BPL     .clear1
    LDX     #$13
.clear2:
    STA     $7D0F,X
    DEX
    BPL     .clear2
    LDA     SHOP_PRICE
    STA     PRINT_STRING_ADDR
    LDA     SHOP_PRICE_HI
    STA     PRINT_STRING_ADDR+1
    LDA     #$04
    STA     $BA
    LDA     #$7D
    STA     $BB
    JSR     NUM_TO_DECIMAL
    LDY     SHOP_ITEM_OFFSET
    INY
    INY
    LDA     ($E6),Y
    STA     PRINT_STRING_ADDR
    INY
    LDA     ($E6),Y
    STA     PRINT_STRING_ADDR+1
    LDY     #$00
    LDA     (PRINT_STRING_ADDR),Y
    TAY
    TAX
    DEX
.copy_name:
    LDA     (PRINT_STRING_ADDR),Y
    STA     $7D0F,X
    DEY
    DEX
    BPL     .copy_name
    JMP     START_GAME_INPUT
.next_item:
    CLC
    LDA     SHOP_ITEM_MASK
    ROR
    BCC     .more_items
    JMP     .item_start
.more_items:
    STA     SHOP_ITEM_MASK
    LDA     SHOP_ITEM_OFFSET
    ADC     #$05
    STA     SHOP_ITEM_OFFSET
    JMP     .item_loop
    ORG     $71F0
ADVANCE_SHOP_PTR:
    SUBROUTINE
    CLC
    LDA     $E6
    ADC     #$29
    STA     $E6
    BCC     .done
    INC     $E7
.done:
    RTS
    ORG     $71FC
ADD_PRICE_COMPONENT:
    SUBROUTINE
    CLC
    LDA     ($E6),Y
    ADC     SHOP_PRICE
    STA     SHOP_PRICE
    BCC     .done
    INC     SHOP_PRICE_HI
.done:
    RTS
    ORG     $72A7
ENTER_LOCATION:
    SUBROUTINE

    LDA     CHAR_PTR
    CMP     LOCATION_POS
    BNE     .changed
    RTS
.changed:
    STA     LOCATION_POS
    JSR     GET_MOB_DATA
    JSR     SET_TEXT_WINDOW
    JSR     CLEAR_MAP
    LDA     #$15
    STA     ENTITY_PTR
    LDA     #$5A
    STA     ENTITY_PTR+1
    JSR     MANHATTAN_DISTANCE
    STA     EVENT_POS
    LDY     #$05
    LDA     (CHAR_PTR),Y
    AND     #$7F
    CMP     LOCATION_STYLE
    BEQ     .same_style
    STA     LOCATION_STYLE
    JSR     LOAD_MAP_TILES
    JSR     FILL_MAP
.same_style:
    LDY     #$03
    LDA     (CHAR_PTR),Y
    JSR     POS_TO_COLROW
    STY     VIEW_MIN_ROW
    STY     FONT_ROW
    STA     VIEW_MIN_COL
    LDY     #$04
    LDA     (CHAR_PTR),Y
    JSR     POS_TO_COLROW
    STY     VIEW_MAX_ROW
    STA     VIEW_MAX_COL
.row_loop:
    LDA     VIEW_MIN_COL
    STA     FONT_COL
.col_loop:
    JSR     DRAW_MAP_COL
    INC     FONT_COL
    LDA     VIEW_MAX_COL
    CMP     FONT_COL
    BPL     .col_loop
    INC     FONT_ROW
    LDA     VIEW_MAX_ROW
    CMP     FONT_ROW
    BPL     .row_loop
    LDY     #$05
    LDA     (CHAR_PTR),Y
    BMI     .skip_entities
    JSR     DRAW_MAP_ENTITIES
.skip_entities:
    RTS
    ORG     $7323
DRAW_MAP_COL:
    SUBROUTINE

    LDA     FONT_COL
    CLC
    LDY     FONT_ROW
.mult_loop:
    DEY
    BMI     .mult_done
    ADC     #$14                    ; +20 per row
    BCC     .mult_loop
.mult_done:
    JSR     FIND_ENTITY_AT_POS
    JSR     GET_ENTITY_FONTCHAR
    JSR     RENDER_FONT_CHAR
    RTS
    ORG     $733B
DRAW_MAP_ENTITIES:
    SUBROUTINE

    LDY     #$05
    LDA     (CHAR_PTR),Y
    ORA     #$80
    STA     (CHAR_PTR),Y                 ; mark entities drawn (set bit 7)
    LDA     MAP_REDRAW_FLAG
    BEQ     .no_redraw
    JMP     .draw_mobs
.no_redraw:
    LDA     LOCATION_STYLE
    AND     #$60                    ; check style bits 5-6
    BEQ     .scan_grid
    JSR     SET_CURSOR_ROW21
    LDA     #$0F
    JSR     DISPLAY_MESSAGE
    LDA     #$FF
    STA     MAP_REDRAW_FLAG
    BNE     .draw_mobs              ; always taken
.scan_grid:
    LDA     VIEW_MIN_COL
    STA     FONT_COL
    LDA     VIEW_MIN_ROW
    STA     FONT_ROW
    LDY     #$02
    LDA     (CHAR_PTR),Y
    PHA                             ; save record byte 2
    LDA     #$00
    STA     (CHAR_PTR),Y                 ; clear it during scan
.cell_check:
    LDA     FONT_COL
    LDY     FONT_ROW
    JSR     COLROW_TO_POS
    JSR     FIND_ENTITY_AT_POS
    LDA     ENTITY_REC+1
    BEQ     .next_col               ; no entity here
    JSR     GET_ENTITY_FONTCHAR
    LDY     #$01
    LDA     (ENTITY_REC),Y
    CMP     #$FE
    BEQ     .next_col               ; $FE = skip
    CMP     #$80
    BCC     .draw_it                ; $00-$7F = draw
    CMP     #$C0
    BCC     .next_col               ; $80-ENTITY_REC+1 = skip
.draw_it:                           ; $C0-$FF = draw
    JSR     SET_CURSOR_ROW21
    JSR     CLASSIFY_ENTITY_TYPE
    JSR     PRINT_BOTTOM_CENTERED
    JSR     DRAW_MAP_ICON_B
.next_col:
    INC     FONT_COL
    LDA     VIEW_MAX_COL
    CMP     FONT_COL
    BPL     .cell_check             ; inner: next column
    LDA     VIEW_MIN_COL
    STA     FONT_COL
    INC     FONT_ROW
    LDA     VIEW_MAX_ROW
    CMP     FONT_ROW
    BPL     .cell_check             ; outer: next row
    LDY     #$02
    PLA
    STA     (CHAR_PTR),Y                 ; restore record byte 2
    BNE     .draw_mobs
    RTS
.draw_mobs:
    JSR     FIRST_GROUP_MEMBER
.mob_loop:
    LDY     #$03
    LDA     (MOB_PTR),Y
    JSR     POS_TO_COLROW
    STY     FONT_ROW
    STA     FONT_COL
    LDA     #$01
    STA     FONT_CHARSET            ; custom font
    LDY     #$04
    LDA     (MOB_PTR),Y
    JSR     GET_ENTITY_FONTCHAR
    STA     FONT_CHARNUM
    CPY     #$00
    BEQ     .mob_blink
    LDY     #$0C
    LDA     (MOB_PTR),Y
    AND     #$0F
    BEQ     .mob_anim
.mob_blink:
    JSR     SET_CURSOR_ROW21
    JSR     DRAW_BLINK_CHAR
    JSR     DRAW_MAP_ICON_B
    JMP     .mob_done
.mob_anim:
    JSR     RENDER_FONT_CHAR
.mob_done:
    JSR     NEXT_GROUP_MEMBER
    LDA     MOB_PTR+1
    BNE     .mob_loop
    RTS
    ORG     $740B
DRAW_MAP_ICON_B:
    SUBROUTINE

    JSR     SCROLL_STATUS_LINE
    JSR     RENDER_FONT_CHAR
    LDA     FONT_COL
    STA     BLINK_COL
    LDA     FONT_ROW
    STA     BLINK_ROW
    LDA     FONT_CHARNUM
    STA     BLINK_CHAR
    JSR     DRAW_BLINK_ALT
    LDA     BLINK_DELAY
    STA     WAIT_LOOP_COUNT
    JSR     TIMED_WAIT
    JSR     DRAW_BLINK_NORMAL
    JSR     ANIM_TICK_AND_WAIT
    LDA     #$14
    STA     BLINK_COL               ; disable blink cursor
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
    ORG     $746C
LOAD_MAP_TILES:
    SUBROUTINE

    LDA     LOCATION_STYLE          ; location style byte
    ROL                             ; \ rotate bits 7-6 down to bits 1-0
    ROL                             ;  | (4 ROLs through carry)
    ROL                             ;  |
    ROL                             ; /
    AND     #$03                    ; mask to 2-bit style index
    TAX
    LDA     TILE_BLINK_TAB,X
    STA     BLINK_ALT_CHAR
    LDA     TILE_FILL_TAB,X
    STA     MAP_FILL_CHAR
    LDA     TILE_DEFAULT_TAB,X
    STA     DEFAULT_CHAR
    RTS
    ORG     $7489
RENDER_FONT_CHAR:
PRINT_FONTCHAR:
    SUBROUTINE

    JSR     FONT_POS_TO_TEXT_POS    ; set TEXT_COL/TEXT_ROW from font pos
PRINT_FONTCHAR_AT_TEXT_POS:
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
    PSHW    PRINT_STRING_ADDR       ; save PRINT_STRING_ADDR (used by PRINT_FONTCHAR)
    JSR     PRINT_FONTCHAR          ; render the character
    PULW    PRINT_STRING_ADDR       ; restore PRINT_STRING_ADDR
    RTS
    ORG     $750C
CHECK_COMBAT_ELIGIBILITY:
    SUBROUTINE
    LDA     #$00
    STA     SAFE_TO_REST
    STA     UNDER_LEVEL
    LDY     #$0C
    LDA     (ENTITY_PTR),Y
    ROR
    AND     #$07
    CMP     STEPS_TAKEN
    BMI     .under_level
    LDA     STEPS_TAKEN
    BNE     .done
    LDY     #$05
    LDA     (ENTITY_PTR),Y
    AND     #$1F
    STA     $BA
    INY
    LDA     (ENTITY_PTR),Y
    AND     #$3F
    CMP     $BA
    BPL     .done
    LDY     #$03
    LDA     (ENTITY_PTR),Y
    JSR     CHECK_ADJACENT_THREATS
    LDA     ADJACENT_THREAT
    BNE     .done
    LDY     #$03
    LDA     (ENTITY_PTR),Y
    JSR     CHECK_ENCOUNTER
    LDA     ENCOUNTER_RESULT
    CMP     #$02
    BEQ     .done
    LDA     #$01
    STA     SAFE_TO_REST
    JMP     .done
.under_level:
    LDA     #$01
    STA     UNDER_LEVEL
.done:
    RTS
    ORG     $761E
DISPLAY_MESSAGE:
    SUBROUTINE

    TAX                             ; X = message index
    LDA     MSG_TABLE_PTR           ; load table base into PRINT_STRING_ADDR/PRINT_STRING_ADDR+1
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

DISPLAY_MESSAGE_LOOP:
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
    ORG     $769B
RESET_TEXT_WINDOW:
SCROLL_STATUS_LINE:
    SUBROUTINE
    ; Text display: init HRCG, set window bottom, output char $83, reset
    JSR     SET_TEXT_WINDOW_SCROLL
    JSR     SET_TEXT_WINDOW_UPPER_LEFT_LOW
    LDA     #$17
    STA     TEXT_ROW             ; cursor to row 23
    LDA     #$83
    JSR     ROM_COUT1
    JSR     SET_TEXT_WINDOW_UPPER_LEFT_ALL
    JMP     SET_TEXT_WINDOW_WRAP
    ORG     $76B0
CLEAR_MAP:

    LDY     #$00
    LDA     (CHAR_PTR),Y            ; record byte 0 → PRINT_STRING_ADDR low
    STA     PRINT_STRING_ADDR
    INY
    LDA     (CHAR_PTR),Y            ; record byte 1 → PRINT_STRING_ADDR high
    STA     PRINT_STRING_ADDR+1
    JMP     SETUP_TEXT_POS
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
    ORG     $76D2
    SUBROUTINE
; Two entry points: $76D2 (col 0) and $76D8 (col 20)
SETUP_TEXT_POS:
    LDA     #$00
    STA     $24
    BEQ     .set_row
SETUP_TEXT_POS_COL20:          ; $76D8 - original SETUP_TEXT_POS_COL20 entry
    LDA     #$14
    STA     $24
.set_row:
    LDA     #$14
    STA     $25
    JSR     PRINT_CTRL_AB
    LDA     #$8C
    JSR     ROM_COUT1
    LDX     #$14
.space_loop:
    LDA     #$A0
    JSR     ROM_COUT1
    DEX
    BNE     .space_loop
    LDA     #$14
    STA     $25
    LDA     #$0A
    SEC
    SBC     $24
    STA     $24
    JSR     SET_TEXT_WINDOW
    LDA     #$8B
    JMP     ROM_COUT1
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
    JSR     PRINT_CTRL_AB
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
    ORG     $7735
PRINT_CTRL_N:
    SUBROUTINE

    LDA     #$8E                    ; Ctrl-N with high bit
    JMP     ROM_COUT1                ; output via COUT1
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

; PRINT_CTRL_AB (PRINT_CTRL_AB) follows at $774E, defined in its own chunk

    ORG     $774E
PRINT_CTRL_AB:
    SUBROUTINE

    LDA     #$81                    ; Ctrl-A with high bit
    JSR     ROM_COUT1
    LDA     #$B0                    ; '0' with high bit
    JMP     ROM_COUT1
    ORG     $7758
PRINT_STRING_AT_ADDR:
    SUBROUTINE

    STX     PRINT_STRING_ADDR
    STY     PRINT_STRING_ADDR+1

    ; falls through to PRINT_STRING / PRINT_FROM_PTR at $775C
    ORG     $775C
PRINT_STRING             ; same entry as PRINT_FROM_PTR
    ORG     $775C
PRINT_FROM_PTR:
    SUBROUTINE

    LDY     #$00
    LDA     (PRINT_STRING_ADDR),Y                 ; first byte = length
    TAX
.loop:
    DEX
    BPL     .next
    RTS                             ; done

.next:
    INY
    LDA     (PRINT_STRING_ADDR),Y                 ; read next char
    JSR     ROM_COUT1
    JMP     .loop
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
    ORG     $78A8
STEP_PRNG:
    SUBROUTINE

    LDA     PRNG_STATE              ; val
    ASL                       ; val*2
    ASL                       ; val*4
    STA     PRNG_TEMP               ; temp = val*4
    ASL                       ; val*8
    ASL                       ; val*16
    ASL                       ; val*32
    ASL                       ; val*64
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
    STA     LOCATION_POS           ;  | clear state variables
    STA     LOCATION_STYLE          ;  |
    STA     ENTITY_PTR+1                     ; /
    JSR     SELECT_INPUT_MODE
    JSR     INIT_WORLD
    JSR     INIT_MOB_COUNT
    LDA     #$01
    STA     CURRENT_PLAYER
    RTS
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
    STY     $80D5                   ; patch byte in script 1 data
    JMP     .load_ptr
.setup_4:
    DEY
    STY     $80E3                   ; patch byte in script 2 data

.load_ptr:
    LDA     SCRIPT_TABLE,X          ; low byte
    STA     SCRIPT_PC
    LDA     SCRIPT_TABLE+1,X        ; high byte
    STA     SCRIPT_PC+1                     ; SCRIPT_PC/SCRIPT_PC+1 = script start address

    LDA     #$00
    STA     SCRIPT_LOOP_CTR         ; loop counter = 0
    LDA     #$01
    STA     SCRIPT_PRNG_MASK        ; PRNG mask = 1
SCRIPT_ENGINE_FETCH:
.fetch:
    LDY     #$00
    LDA     (SCRIPT_PC),Y                 ; read script byte
    CMP     #$27
    BCC     .control                ; < $27 → control command
    JMP     .action                 ; ≥ $27 → action dispatch

.control:
    CMP     #$25
    BEQ     .cmd_25                 ; set PRNG mask = $0F
    BCS     .cmd_26                 ; $26: PRNG mask = $00

    CMP     #$23
    BEQ     .cmd_23                 ; set action vector → PLAY_TONE
    BCS     .cmd_24                 ; set action vector → PLAY_NOISE

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
    STA     SCRIPT_PC                     ;  | SCRIPT_PC/SCRIPT_PC+1 = loop address
    LDA     SCRIPT_LOOP_ADDR+1      ;  |
    STA     SCRIPT_PC+1                     ; /
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

.cmd_23:                            ; action vector → PLAY_TONE
    STOW    PLAY_TONE,SCRIPT_ACTION_VEC
    JMP     SCRIPT_ADVANCE

.cmd_24:                            ; action vector → PLAY_NOISE
    STOW    PLAY_NOISE,SCRIPT_ACTION_VEC
    JMP     SCRIPT_ADVANCE

.cmd_22:                            ; nop (return from script)
    RTS

.cmd_21:                            ; gosub: jump to saved address
    LDA     SCRIPT_GOSUB_ADDR
    STA     SCRIPT_PC
    LDA     SCRIPT_GOSUB_ADDR+1
    STA     SCRIPT_PC+1
    JMP     .fetch

.cmd_1F:                            ; set loop address = current+1
    JSR     SCRIPT_INC_PC
    LDA     SCRIPT_PC
    STA     SCRIPT_LOOP_ADDR
    LDA     SCRIPT_PC+1
    STA     SCRIPT_LOOP_ADDR+1
    JMP     .fetch

.cmd_20:                            ; set gosub address = current+1
    JSR     SCRIPT_INC_PC
    LDA     SCRIPT_PC
    STA     SCRIPT_GOSUB_ADDR
    LDA     SCRIPT_PC+1
    STA     SCRIPT_GOSUB_ADDR+1
    JMP     .fetch

.action:
    STA     SOUND_DURATION                     ; save action byte
    JSR     STEP_PRNG
    LDA     PRNG_OUTPUT             ; PRNG output
    AND     SCRIPT_PRNG_MASK        ; apply mask
    EOR     SOUND_DURATION                     ; XOR with action byte
    STA     SOUND_FREQ                     ; modified action
    JSR     SCRIPT_INC_PC           ; advance script pointer
    LDY     #$00
    LDA     (SCRIPT_PC),Y                 ; read parameter byte
    STA     SOUND_DURATION
    JSR     SCRIPT_ACTION_INDIRECT  ; → JMP (SCRIPT_ACTION_VEC)
    JMP     (DISPATCH_VEC)                   ; dispatch via action vector
    ORG     $7A4C
SCRIPT_ACTION_INDIRECT:
    JMP     (SCRIPT_ACTION_VEC)
    ORG     $7A4F
SCRIPT_ADVANCE:
    SUBROUTINE

    JSR     SCRIPT_INC_PC           ; advance script pointer
    LDA     ATTRACT_FLAG            ; attract_flag
    BEQ     .continue               ; not attract mode → skip input check

    ; Attract mode: check keyboard
    LDA     $C000                   ; keyboard register
    BPL     .check_joy              ; no key → check joystick
    RTS                             ; key pressed → exit

.check_joy:
    LDA     INPUT_MODE              ; joystick flag
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
    LSR     WAIT_LOOP_COUNT                   ; shift timing flag
    JMP     SCRIPT_ENGINE_FETCH     ; loop back to interpreter
    ORG     $7A77
SCRIPT_INC_PC:
    SUBROUTINE

    INC     SCRIPT_PC
    BEQ     .carry
    RTS
.carry:
    INC     SCRIPT_PC+1
    RTS
    ORG     $7A7F
PLAY_TONE:
    SUBROUTINE

.outer:
    LDY     #$0A                    ; 10 speaker toggles per cycle
.toggle:
    LDA     $C030                   ; toggle speaker
    DEX
    BNE     .toggle                 ; inner delay loop
    LDX     SOUND_FREQ              ; reload pitch counter
    DEY
    BNE     .toggle                 ; next toggle
    DEC     SOUND_DURATION          ; repeat whole cycle
    BNE     .outer
    RTS
    ORG     $7A91
PLAY_NOISE:
    SUBROUTINE

.outer:
    LDY     #$0A                    ; 10 toggles per cycle
.toggle:
    LDA     $C030                   ; toggle speaker
    ROL     NOISE_SHIFT             ; rotate shift register left
    DEX
    BNE     .toggle                 ; inner delay loop
    LDX     SOUND_FREQ              ; reload pitch counter
    ROL     NOISE_SHIFT             ; \ rotate left then right =
    ROR     NOISE_SHIFT             ; / feedback from carry bit
    NOP                             ; \
    NOP                             ;  | timing padding
    NOP                             ; /
    DEY
    BNE     .toggle                 ; next toggle
    DEC     SOUND_DURATION          ; repeat whole cycle
    BNE     .outer
    RTS
    ORG     $7E2F
STATUS_BORDER_DATA:
    HEX     7D                      ; $7D: reset to full-screen
    HEX     80 00                   ; row 0, col 0
    HEX     33 3C                   ; top-left corner, left tee
    HEX     34 34 34 34 34 34 34 34 ; horizontal bar (x16)
    HEX     34 34 34 34 34 34 34 34
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
    HEX     38 38 38 38 38 38 38 38 ; horizontal bar (x16)
    HEX     38 38 38 38 38 38 38 38
    HEX     41 37                   ; right tee, bottom-right corner
    HEX     7F                      ; end of stream
    ORG     $7E97
S_PRESS_SPACE:
    HEX 20 A0 A0 D0 D2 C5 D3 D3 A0 D3 D0 C1 C3 C5 A0 C2 C1 D2 A0 D4 CF A0 C3 CF CE D4 C9 CE D5 C5 A0 A0 A0

S_PRESS_BUTTON:
    HEX 20 A0 A0 D0 D2 C5 D3 D3 A0 D4 C8 C5 A0 C2 D5 D4 D4 CF CE A0 D4 CF A0 C3 CF CE D4 C9 CE D5 C5 A0 A0
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
    ORG     $83A5
FONT_DATA:
    INCLUDE "fontdata.asm"
    ORG     $97A5
STD_FONT_DATA:
    INCLUDE "stdfontdata.asm"