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
    ; --- EALDR VM bytecode macros ---
    ; Each macro emits the opcode byte followed by XOR-encrypted arguments.
    ; Address args: low ^ $03, high ^ $D9.  Immediate args: ^ $4C.
    MACRO VMGOTO  ;  $00 addr -- IP <- addr
        DC.B $00, <[{1}] ^ $03, >[{1}] ^ $D9
    ENDM
    MACRO VMCALL1 ;  $01 addr -- call 6502 subroutine, result -> acc
        DC.B $01, <[{1}] ^ $03, >[{1}] ^ $D9
    ENDM
    MACRO VMBEQ   ;  $02 addr -- branch if acc = 0
        DC.B $02, <[{1}] ^ $03, >[{1}] ^ $D9
    ENDM
    MACRO VMLDI   ;  $03 val  -- load immediate -> acc
        DC.B $03, [{1}] ^ $4C
    ENDM
    MACRO VMLD    ;  $04 addr -- acc <- (addr)
        DC.B $04, <[{1}] ^ $03, >[{1}] ^ $D9
    ENDM
    MACRO VMCALL  ;  $05 addr -- VM subroutine call
        DC.B $05, <[{1}] ^ $03, >[{1}] ^ $D9
    ENDM
    MACRO VMST    ;  $06 addr -- (addr) <- acc
        DC.B $06, <[{1}] ^ $03, >[{1}] ^ $D9
    ENDM
    MACRO VMSUBI  ;  $07 val  -- acc <- acc - val
        DC.B $07, [{1}] ^ $4C
    ENDM
    MACRO VMCALL0 ;  $08 addr -- terminal jump to 6502 code
        DC.B $08, <[{1}] ^ $03, >[{1}] ^ $D9
    ENDM
    MACRO VMRET   ;  $09      -- return from VM subroutine
        DC.B $09
    ENDM
    MACRO VMLDX   ;  $0A addr -- acc <- (addr + acc)
        DC.B $0A, <[{1}] ^ $03, >[{1}] ^ $D9
    ENDM
    MACRO VMASL   ;  $0B      -- acc <- acc << 1
        DC.B $0B
    ENDM
    MACRO VMINC   ;  $0C addr -- (addr)++, result -> acc
        DC.B $0C, <[{1}] ^ $03, >[{1}] ^ $D9
    ENDM
    MACRO VMADD   ;  $0D addr -- acc <- acc + (addr)
        DC.B $0D, <[{1}] ^ $03, >[{1}] ^ $D9
    ENDM
    MACRO VMDXR   ;  $0E      -- DXR decryption step
        DC.B $0E
    ENDM
    MACRO VMBNE   ;  $0F addr -- branch if acc != 0
        DC.B $0F, <[{1}] ^ $03, >[{1}] ^ $D9
    ENDM
    MACRO VMSUB   ;  $10 addr -- acc <- acc - (addr)
        DC.B $10, <[{1}] ^ $03, >[{1}] ^ $D9
    ENDM
    MACRO VMCOPY  ;  $11      -- (dest++) <- (src++)
        DC.B $11
    ENDM
    MACRO EACR    ; line separator: $0D
        DC.B $0D
    ENDM
    MACRO EASEP   ; record separator: $D9 (high-bit 'Y')
        DC.B $D9
    ENDM
    MACRO SLEN    ; string length byte
        DC.B {1}
    ENDM
EALDR_SRC           EQU     $4C     ; VM source pointer (2 bytes)
SOFTEV              EQU     $03F2   ; Apple II reset vector (2 bytes)
PWREDUP             EQU     $03F4   ; power-up byte
EALDR_PTR           EQU     $46     ; VM instruction pointer (2 bytes)
EALDR_PSUEDOACC     EQU     $48     ; VM accumulator
EALDR_VM_DISPATCH   EQU     $AA45   ; dispatch loop entry (linear continuation)
EALDR_DEST          EQU     $4E     ; VM dest pointer (2 bytes)
EALDR_BOT           EQU     $AC60   ; funny-increment low counter
EALDR_TOP           EQU     $AC61   ; funny-increment high counter
    ORG     $A806
EALDR_ENTRY:
    LDY      #$00            ; Fill $2000-$7FFF with $FF
    STY      EALDR_SRC       ; ($4C) = pointer low
    LDA      #$20
    STA      EALDR_SRC+1     ; ($4D) = $20 (start page)
    LDA      #$FF
.fill:
    STA      (EALDR_SRC),Y
    INY
    BNE      .fill
    INC      EALDR_SRC+1
    BPL      .fill           ; loop until page $80 (sign bit set)

_ealdr.copy_lo:
    LDX      #$00            ; Copy splash screen from $B000+
_ealdr.copy_next:
    JSR      EALDR_COPY_BYTE ; copy byte, advance source
    INX
    BXNE     #$20,_ealdr.copy_next ; X = $00..$1F (first 32 bytes)
    LDX      #$80
_ealdr.copy_hi:
    JSR      EALDR_COPY_BYTE ; X = $80..$9F (next 32 bytes)
    INX
    BXNE     #$A0,_ealdr.copy_hi
    INC      EALDR_COPY_DST  ; self-modify: advance dest page
    LDA      EALDR_COPY_DST
    BANE    #$40,_ealdr.copy_lo    ; done when dest page reaches $40
    JMP      EALDR_VM_EXEC   ; enter VM
    ORG     $A83A
EALDR_COPY_BYTE:
EALDR_COPY_SRC = *+1
    LDA      $B000            ; self-modified source address
EALDR_COPY_DST = *+2
    STA      $202C,X          ; dest = HGR page + offset
    INC      EALDR_COPY_SRC   ; advance source (low byte)
    BNE      .done
    INC      EALDR_COPY_SRC+1 ; carry to high byte
.done:
    RTS
    ORG     $A849
EALDR_VM_EXEC:
    LDX      #$30            ; filler (skipped by Y=4)
    JSR      EALDR_VM_INTERP ; call interpreter
    DEX                      ; \  these 3 bytes are skipped;
    BPL      EALDR_VM_EXEC   ; /  the VM never returns here
                                ; VM bytecodes begin at $A851
    ORG     $A851
EALDR_VM_BYTECODE:
    ; --- Display setup ---
    VMLD    $C050              ; TXTCLR (show graphics)
    VMLD    $C052              ; MIXCLR (full screen)
    VMLD    $C057              ; HIRES (hi-res mode)
    VMLDI   $F8                ; \
    VMST    EALDR_SRC          ; /  EALDR_SRC = $F8 (delay counter)
    VMLDI   $48                ; \
    VMST    SOFTEV             ; /  SOFTEV lo = $48
    VMLDI   $A9                ; \
    VMST    SOFTEV+1           ; /  SOFTEV hi = $A9 -> reset = EALDR_REBOOT
    VMLDI   $0C                ; \
    VMST    PWREDUP            ; /  PWREDUP = $A9 EOR $A5 = $0C

    ; --- Splash screen delay ---
VM_SPLASH_DELAY:
    VMLDI   $FF                ; \
    VMCALL1 $FCA8              ;  | WAIT ($FF iterations)
    VMINC   EALDR_SRC          ;  | EALDR_SRC++
    VMBEQ   VM_LOAD_GROUP1     ;  | done when wraps to 0
    VMGOTO  VM_SPLASH_DELAY    ; /  loop

    ; --- Group 1: optional tracks $03,$04,$21,$22 ---
VM_LOAD_GROUP1:
    VMLD    $A805              ; flag byte (0 = skip Group 1)
    VMBEQ   VM_LOAD_GROUP2     ; skip if zero
    VMLDI   $00                ; \
    VMCALL  VM_READ_TRACKS     ;  | read_tracks(0) -> Group 1
    VMLD    $C0E8              ;  | IWM: motor off
    VMCALL1 $0000              ; /  ???

    ; --- Group 2: tracks $07-$0C -> $4000-$95FF ---
VM_LOAD_GROUP2:
    VMLDI   $05                ; \
    VMCALL  VM_READ_TRACKS     ;  | read_tracks(5) -> Group 2
    VMCALL1 EALDR_CLEAR_TEXT   ; /  clear text screen
    VMGOTO  VM_LOAD_GROUP3     ; continue at bytecode part 2
    ORG     $A898
EALDR_CLEAR_TEXT:
    LDA      #$00
    STA      EALDR_SRC     ; $4C = 0
    LDA      #$04
    STA      EALDR_SRC+1   ; $4D = 4 -> pointer = $0400
    LDY      #$00
_ealdr.loop:
    LDA      #$00
    STA      (EALDR_SRC),Y ; zero out
    INY
    BNE      _ealdr.loop
    INC      EALDR_SRC+1
    LDA      EALDR_SRC+1
    BANE    #$08,_ealdr.loop     ; done at $0800
    RTS
    ORG     $A8B2
    ; --- Group 3: tracks $0D-$10 -> $0800-$3FFF ---
VM_LOAD_GROUP3:
    VMLD    $A800              ; flag byte (nonzero = show lo-res)
    VMBEQ   VM_DO_GROUP3       ; skip if zero
    VMLD    $C056              ; LORES (lo-res mode)
VM_DO_GROUP3:
    VMLDI   $0C                ; \
    VMCALL  VM_READ_TRACKS     ;  | read_tracks(12) -> Group 3
    VMLDI   $00                ; \
    VMST    EALDR_SRC          ;  | EALDR_SRC = 0
    VMST    EALDR_TMP1         ; /  checksum accumulator = 0

    ; --- Checksum verification ($A000-$A2E0) ---
VM_CHECKSUM_LOOP:
    VMLD    EALDR_SRC          ; A = index
    VMLDX   $A000              ; \
    VMSUB   EALDR_TMP1         ;  | checksum -= mem[$A000 + index]
    VMST    EALDR_TMP1         ; /
    VMLD    EALDR_SRC          ; \
    VMLDX   $A100              ;  | checksum -= mem[$A100 + index]
    VMSUB   EALDR_TMP1         ;  |
    VMST    EALDR_TMP1         ; /
    VMINC   EALDR_SRC          ; index++
    VMBNE   VM_CHECKSUM_LOOP   ; loop until index wraps
VM_CHECKSUM_A200:
    VMLD    EALDR_SRC          ; \
    VMLDX   $A200              ;  | checksum -= mem[$A200 + index]
    VMSUB   EALDR_TMP1         ;  |
    VMST    EALDR_TMP1         ; /
    VMINC   EALDR_SRC          ; index++
    VMSUBI  $E0                ; \
    VMBNE   VM_CHECKSUM_A200   ; /  loop until index = $E0
    VMLD    EALDR_TMP1         ; checksum result
    VMSUBI  $60                ; \
    VMBNE   VM_ERROR_SPLASH    ; /  if checksum != $60 -> error

    ; --- DXR decryption ($4000-$67FF) ---
    VMLDI   $05                ; \
    VMCALL1 EALDR_MOVE_ARM_TRAMPOLINE     ; /  move arm to track 5
    VMLD    $A000              ; (read value, discard)
    VMLDI   $00                ; \
    VMLD    $C0E8              ; /  IWM: motor off
    VMLDI   $00                ; \
    VMST    EALDR_SRC          ;  | src = $4000
    VMLDI   $40                ;  |
    VMST    EALDR_SRC+1        ; /
    VMLDI   $02                ; \
    VMST    EALDR_BOT          ;  | funny-inc counters: bot=2, top=3
    VMLDI   $03                ;  |
    VMST    EALDR_TOP          ; /
VM_DXR_LOOP:
    VMCALL1 EALDR_FUNNY_INC   ; advance key schedule
    VMDXR                      ; decrypt one byte
    VMBNE   VM_DXR_LOOP        ; loop until acc = 0 (src high = $68)

    ; --- Copy $A300-$A5FF -> $0500-$07FF ---
    VMLDI   $00                ; \
    VMST    EALDR_SRC          ;  | src = $A300
    VMST    EALDR_DEST         ;  | dest = $0500
    VMLDI   $A3                ;  |
    VMST    EALDR_SRC+1        ;  |
    VMLDI   $05                ;  |
    VMST    EALDR_DEST+1       ; /
VM_COPY_LOOP:
    VMCOPY                     ; copy one byte
    VMLD    EALDR_DEST+1       ; check if dest page reached $08
    VMSUBI  $08                ; \
    VMBNE   VM_COPY_LOOP       ; /  loop until done (3 pages)

    ; --- Enter main program ---
    VMCALL0 $0800              ; jump to main program (never returns)
    ORG     $A948
EALDR_REBOOT:
    JSR      $FC58 ; HOME (clear screen)
    LDA      #$FF
.delay:
    LDX      #$A0
.inner:
    DEX
    BNE      .inner
    BIT      $C030 ; click speaker
    SEC
    SBC      #$01
    BNE      .delay
    LDA      #$C5  ; 'E'
    STA      $0400
    LDA      #$C1  ; 'A'
    STA      $0401
    JMP      $C600 ; reboot from Disk II
    ORG     $A967
    ; --- read_tracks subroutine (entry) ---
VM_READ_TRACKS:
    VMST    EALDR_TMP0         ; save table index
    VMLD    $C0E9              ; IWM: motor on
    VMGOTO  VM_READ_LOOP       ; continue at bytecode part 4
    ORG     $A970
EALDR_FUNNY_INC:
    INC      EALDR_BOT      ; $AC60
    LDA      EALDR_BOT
    BAEQ    EALDR_TOP,_ealdr.wrap ; $AC61
    RTS
_ealdr.wrap:
    LDA      #$01
    STA      EALDR_BOT
    INC      EALDR_TOP
    RTS
    ORG     $A985
    ; --- read_tracks subroutine (body) ---
VM_READ_LOOP:
    VMLD    EALDR_TMP0         ; A = table index
    VMLDX   EALDR_TRACK_PAGES  ; A = track_pages[index]
    VMBEQ   VM_READ_DONE       ; zero terminator -> return
    VMST    $003E              ; base page = track_pages[index]
    VMLD    EALDR_TMP0                    ; \
    VMLDX   EALDR_TRACKS                  ;  | A = tracks[index]
    VMCALL1 EALDR_READ_TRACK_TRAMPOLINE   ; /  read track
    VMBEQ   VM_READ_NEXT                  ; success -> advance index
    VMGOTO  VM_ERROR_DISPLAY              ; error -> error handler

    ; --- advance to next track ---
VM_READ_NEXT:
    VMLD    EALDR_TMP0         ; \
    VMSUBI  $FF                ;  | index++ (subtract $FF = add 1 mod 256)
    VMST    EALDR_TMP0         ;  |
    VMGOTO  VM_READ_LOOP       ; /  loop

    ; --- error: splash screen loop ---
VM_ERROR_SPLASH:
    VMLD    $C0E9              ; IWM: motor on
    VMCALL1 $FC58              ; HOME (clear screen)
    VMLD    $C051              ; TXTSET (show text)
    VMLDI   $BF                ; \
    VMST    $0400              ; /  '?' on screen
    VMLDI   $40                ; \
    VMCALL1 $FCA8              ; /  WAIT ($40)
    VMLD    $C0E8              ; IWM: motor off
VM_ERROR_BEEP:
    VMLDI   $60                ; \
    VMCALL1 $FCA8              ;  | WAIT ($60)
    VMLDI   $08                ;  | WAIT ($08)
    VMCALL1 $FCA8              ;  |
    VMINC   EALDR_TMP1         ;  | increment counter
    VMBNE   VM_ERROR_BEEP      ; /  loop (beep pattern)
    VMGOTO  VM_ERROR_SPLASH    ; restart splash loop

    ; --- error: display "EA" and reboot ---
VM_ERROR_DISPLAY:
    VMCALL1 $FC58              ; HOME
    VMCALL1 $FBDD              ; BELL (beep)
    VMLD    $C051              ; TXTSET
    VMLDI   $C5                ; \
    VMST    $0400              ;  | 'E' on screen
    VMLDI   $D2                ;  |
    VMST    $0401              ;  | 'R' on screen (error code)
    VMST    $0402              ; /  'R' again
    VMLD    $C0E8              ; IWM: motor off
VM_ERROR_HALT:
    VMGOTO  VM_ERROR_HALT      ; infinite loop

    ; --- data ---
VM_READ_DONE:
    VMRET                      ; return from read_tracks
EALDR_TMP0:
    DC.B    $00                ; table index (runtime)
EALDR_TMP1:
    DC.B    $00                ; checksum accumulator (runtime)
    ORG     $A9F3
EALDR_TRACK_PAGES:
    HEX     08 10 20 30 00
    HEX     40 50 60 70 80 86 00
    HEX     08 10 20 30 00

EALDR_TRACKS:
    HEX     03 04 21 22 00
    HEX     07 08 09 0A 0B 0C 00
    HEX     0D 0E 0F 10 00
    ORG     $AA15
EALDR_FIND_SECTOR:
    ; Sector search routine: $AA15-$AA34 (32 bytes)
    HEX     A0 FC 84 26 C8 D0 04 E6 26 F0 F3 AD EC C0 10 FB
    HEX     C9 D5 D0 F0 EA AD EC C0 10 FB C9 AA D0 F2 A0 03
    ORG     $AA35
    SUBROUTINE EALDR_VM_INTERP
EALDR_VM_INTERP:
    LDA      EALDR_PSUEDOACC        ; save VM accumulator
    PHA
    TYA                             ; save Y
    PHA
    JSR      EALDR_VM_INIT          ; RTS trick: pull return addr -> $46/$47

    ; --- After RTS trick, execution resumes here ---
    PLA                             ; pull saved Y -> $46 (low byte of return addr)
    STA      EALDR_PTR
    PLA                             ; pull saved acc -> $47 (high byte)
    STA      EALDR_PTR+1

    ; Dispatch loop
    LDY      #$04                   ; skip 4 bytes (DEX/BPL/offset + JSR addr byte)
EALDR_DISPATCH:                 ; $AA45
    LDA      (EALDR_PTR),Y          ; read opcode byte
    INY
    BNE      .no_carry
    INC      EALDR_PTR+1
.no_carry:
    TAX                             ; opcode -> X
    LDA      EALDR_DISPATCH_TABLE,X ; handler offset
    CLC
    ADC      #<EALDR_VM_LOOP        ; handler = $AA72 + offset
    STA      EALDR_VM_JMP+1         ; self-modify JMP low byte
    LDA      #>EALDR_VM_LOOP
    ADC      #$00                   ; carry
    STA      EALDR_VM_JMP+2         ; self-modify JMP high byte
EALDR_VM_JMP:
    JMP      EALDR_VM_LOOP          ; self-modified: jump to handler
    ORG     $AA60
EALDR_DISPATCH_TABLE:
    HEX  00 3C 53 5D 6B 88 AB BC 4D A0 77 B7
    ;    GOTO CALL1 BEQ LDI LD CALL ST SUBI CALL0 RET LDX ASL
    HEX  D1 D4 D7 DA DD E0
    ;    INC  ADD  DXR  BNE  SUB  COPY (trampolines)
    ORG     $AA72
EALDR_VM_LOOP:
    JSR      EALDR_READ_ARG16 ; read 2-byte encoded address -> $42/$43
EALDR_VM_GOTO:                  ; $AA75 - entry when addr already in $42/$43
    LDA      $42
    STA      EALDR_PTR        ; update bytecode pointer
    LDA      $43
    STA      EALDR_PTR+1
    LDY      #$00
    JMP      EALDR_DISPATCH   ; read next opcode
    ORG     $AA82
EALDR_READ_ARG16:
    LDA      (EALDR_PTR),Y ; read low byte
    EOR      #$03          ; decrypt
    INY
    BNE      .no_carry1
    INC      EALDR_PTR+1
.no_carry1:
    STA      $42           ; decoded low byte
    LDA      (EALDR_PTR),Y ; read high byte
    INY
    BNE      .no_carry2
    INC      EALDR_PTR+1
.no_carry2:
    EOR      #$D9          ; decrypt
    STA      $43           ; decoded high byte
    RTS
    ORG     $AA99
    SUBROUTINE EALDR_VM_INIT
EALDR_VM_INIT:
    PLA
    STA      $42       ; return addr low
    PLA
    STA      $43       ; return addr high
    PLA
    STA      EALDR_PTR ; saved Y -> $46 (overwritten later)
    PLA
    STA      EALDR_PTR ; saved acc -> $46 (overwrites Y)
    INC      $42       ; return addr + 1
    BNE      .no_carry
    INC      $43
.no_carry:
    JMP      ($0042)   ; jump to instruction after JSR EALDR_VM_INIT
    ORG     $AAAE
    SUBROUTINE EALDR_OP_CALL1
; --- Opcode 01: CALL1 addr ---
; Call 6502 subroutine; result -> VM acc.  Handler at $AAAE.
EALDR_OP_CALL1:
    JSR      EALDR_READ_ARG16  ; decode addr -> $42/$43
    TYA
    PHA                        ; save Y (subroutine may clobber it)
    LDA      EALDR_PSUEDOACC
    JSR      EALDR_JMP_IND     ; JMP ($0042) -- enters subroutine
    STA      EALDR_PSUEDOACC   ; return value -> VM acc
    PLA
    TAY                        ; restore Y
    JMP      EALDR_VM_DISPATCH ; linear

; --- Opcode 08: CALL0 addr ---
; Terminal jump to 6502 code (no return).  Handler at $AABF.
; Falls through into EALDR_JMP_IND.
EALDR_OP_CALL0:
    JSR      EALDR_READ_ARG16
; Helper: indirect jump through $42/$43.  Used by CALL1 and CALL0.
EALDR_JMP_IND:                  ; $AAC2
    JMP      ($0042)

; --- Opcode 02: BEQ addr ---
; Branch if VM acc = 0.  Handler at $AAC5.
EALDR_OP_BEQ:
    JSR      EALDR_READ_ARG16
    LDA      EALDR_PSUEDOACC
    BEQ      EALDR_VM_GOTO     ; zero -> goto path (IP = $42/$43)
    JMP      EALDR_VM_DISPATCH ; nonzero -> linear

    SUBROUTINE EALDR_OP_LDI
; --- Opcode 03: LDI val ---
; Load 1-byte immediate (XOR $4C) into VM acc.  Handler at $AACF.
EALDR_OP_LDI:
    LDA      (EALDR_PTR),Y     ; read encoded byte
    INY
    BNE      .nc
    INC      EALDR_PTR+1
.nc:
    EOR      #$4C              ; decrypt
    STA      EALDR_PSUEDOACC
    JMP      EALDR_VM_DISPATCH

; --- Opcode 04: LD addr ---
; Load byte at addr into VM acc.  Handler at $AADD.
EALDR_OP_LD:
    JSR      EALDR_READ_ARG16
EALDR_OP_LD_DO:                 ; $AAE0 (shared by LDX)
    LDX      #$00
    LDA      ($42,X)           ; load byte at decoded address
    STA      EALDR_PSUEDOACC
    JMP      EALDR_VM_DISPATCH

    SUBROUTINE EALDR_OP_LDX
; --- Opcode 0A: LDX addr ---
; Indexed load: A <- (addr + A).  Handler at $AAE9.
EALDR_OP_LDX:
    JSR      EALDR_READ_ARG16
    LDA      EALDR_PSUEDOACC   ; add VM acc to address
    CLC
    ADC      $42
    STA      $42
    BCC      .nc
    INC      $43
.nc:
    JMP      EALDR_OP_LD_DO    ; fall into LD handler

    SUBROUTINE EALDR_OP_CALL
; --- Opcode 05: CALL addr ---
; VM subroutine call: push return IP, goto addr.  Handler at $AAFA.
EALDR_OP_CALL:
    JSR      EALDR_READ_ARG16  ; target -> $42/$43
    TYA                        ; compute return IP = $46 + Y
    CLC
    ADC      EALDR_PTR
    STA      EALDR_PTR
    BCC      .nc
    INC      EALDR_PTR+1
.nc:
    PSHW     EALDR_PTR         ; push return addr (lo first, hi second)
    LDY      #$00
    JMP      EALDR_VM_GOTO     ; goto path (IP = target)

; --- Opcode 09: RET ---
; Return from VM subroutine.  Handler at $AB12.
EALDR_OP_RET:
    PULW     EALDR_PTR         ; pop return addr (hi first, lo second)
    LDY      #$00
    JMP      EALDR_VM_DISPATCH

; --- Opcode 06: ST addr ---
; Store VM acc at addr.  Handler at $AB1D.
EALDR_OP_ST:
    JSR      EALDR_READ_ARG16
    LDA      EALDR_PSUEDOACC
    LDX      #$00
    STA      ($42,X)
    JMP      EALDR_VM_DISPATCH

; --- Opcode 0B: ASL ---
; Shift VM acc left.  Handler at $AB29.
EALDR_OP_ASL:
    ASL      EALDR_PSUEDOACC
    JMP      EALDR_VM_DISPATCH

    SUBROUTINE EALDR_OP_SUBI
; --- Opcode 07: SUBI val ---
; Subtract 1-byte immediate (XOR $4C) from VM acc.  Handler at $AB2E.
EALDR_OP_SUBI:
    LDA      (EALDR_PTR),Y     ; read encoded byte
    INY
    BNE      .nc
    INC      EALDR_PTR+1
.nc:
    EOR      #$4C              ; decrypt
    STA      $42               ; temp
    LDA      EALDR_PSUEDOACC
    SEC
    SBC      $42               ; acc - immediate
    STA      EALDR_PSUEDOACC
    JMP      EALDR_VM_DISPATCH

; --- Trampolines for opcodes 0C-11 ---
; These JMPs bridge the 1-byte dispatch offset limit.
EALDR_TRAMP_INC:                ; $AB43
    JMP      EALDR_OP_INC
EALDR_TRAMP_ADD:
    JMP      EALDR_OP_ADD
EALDR_TRAMP_DXR:
    JMP      EALDR_DXR_STEP
EALDR_TRAMP_BNE:
    JMP      EALDR_OP_BNE
EALDR_TRAMP_SUB:
    JMP      EALDR_OP_SUB
EALDR_TRAMP_COPY:
    JMP      EALDR_OP_COPY

; --- Opcode 0E: DXR ---
    ORG     $AB55
    SUBROUTINE EALDR_DXR_STEP
EALDR_DXR_STEP:
    LDX      #$00
    LDA      (EALDR_SRC,X)     ; load byte at (src)
    EOR      EALDR_PSUEDOACC   ; XOR with accumulator
    STA      (EALDR_SRC,X)     ; store back
    INC      EALDR_SRC         ; src += 2 (skip every other byte)
    INC      EALDR_SRC
    BNE      .no_carry
    INC      EALDR_SRC+1
.no_carry:
    LDA      EALDR_SRC+1       ; new acc = high byte of src XOR $68
    EOR      #$68
    STA      EALDR_PSUEDOACC
    JMP      EALDR_VM_DISPATCH ; linear continuation

; --- Opcode 0F: BNE addr ---
; Branch if VM acc != 0.  Handler at $AB6E.
EALDR_OP_BNE:
    JSR      EALDR_READ_ARG16
    LDA      EALDR_PSUEDOACC
    BEQ      .skip
    JMP      EALDR_VM_GOTO     ; nonzero -> goto path
.skip:
    JMP      EALDR_VM_DISPATCH ; zero -> linear

; --- Opcode 0C: INC addr ---
; Increment byte at addr; result also -> VM acc.  Handler at $AB7B.
EALDR_OP_INC:
    JSR      EALDR_READ_ARG16
    LDX      #$00
    LDA      ($42,X)
    CLC
    ADC      #$01
    STA      ($42,X)           ; store incremented value
    STA      EALDR_PSUEDOACC   ; also update VM acc
    JMP      EALDR_VM_DISPATCH

; --- Opcode 0D: ADD addr ---
; A <- A + (addr).  Handler at $AB8C.
EALDR_OP_ADD:
    JSR      EALDR_READ_ARG16
    LDX      #$00
    LDA      ($42,X)
    CLC
    ADC      EALDR_PSUEDOACC
    STA      EALDR_PSUEDOACC
    JMP      EALDR_VM_DISPATCH

; --- Opcode 10: SUB addr ---
; A <- A - (addr).  Handler at $AB9B.
EALDR_OP_SUB:
    JSR      EALDR_READ_ARG16
    LDX      #$00
    LDA      EALDR_PSUEDOACC
    SEC
    SBC      ($42,X)
    STA      EALDR_PSUEDOACC
    JMP      EALDR_VM_DISPATCH

; --- Opcode 11: COPY ---
; Copy one byte: (dest++) <- (src++).  Handler at $ABAA.
EALDR_OP_COPY:
    LDX      #$00
    LDA      (EALDR_SRC,X)     ; read from src
    STA      (EALDR_DEST,X)    ; write to dest
    INC      EALDR_SRC         ; src++
    BNE      .nc1
    INC      EALDR_SRC+1
.nc1:
    INC      EALDR_DEST        ; dest++
    BNE      .nc2
    INC      EALDR_DEST+1
.nc2:
    JMP      EALDR_VM_DISPATCH
    ORG     $ABBF
EALDR_DISK_IO:
    SUBROUTINE EALDR_DISK_IO

    LDA     $C0E9              ; IWM: motor on
    LDX     #$FF               ; \
    STX     $04                ;  | min = $FF
    INX                        ;  | X = 0
    STX     $01                ;  | flag = 0
    STX     $03                ; /  max = 0
    LDA     #$18               ; \
    STA     $06                ; /  start at half-track $18
    JSR     EALDR_MOVE_ARM_TRAMPOLINE     ; seek to half-track $18
.next_track:
    INC     $06                ; advance to next half-track
.search_sector:
    JSR     EALDR_SEARCH_ADDR_TRAMPOLINE  ; search for address field
    BCS     .search_sector     ; error -> retry
    LDA     $2D                ; sector number from address field
    BNE     .search_sector     ; not sector 0 -> keep searching
    ; Found sector 0: read a data field as verification
    LDA     $06                ; \
    JSR     EALDR_MOVE_ARM_TRAMPOLINE     ;  | seek to current half-track
    INC     $06                ;  | advance half-track
    LDA     #$19               ;  |
    JSR     EALDR_READ_DATA_TRAMPOLINE    ; /  read data field (page $19)
    ; Scan for address field headers on this half-track
    LDA     #$00               ; \
    STA     $00                ; /  timeout counter = 0
.scan_loop:
    INC     $00                ; increment timeout
    BEQ     .scan_done         ; wrapped to 0 -> done scanning
    ; Search for D5 AA 96 prologue
.wait_d5:
    LDA     $C0EC              ; \
    BPL     .wait_d5           ;  | wait for nibble
.check_d5:
    CMP     #$D5               ;  |
    BNE     .scan_loop         ; /  not D5 -> restart
    PHA                        ; \
    PLA                        ; /  timing delay
.wait_aa:
    LDA     $C0EC              ; \
    BPL     .wait_aa           ;  |
    CMP     #$AA               ;  |
    BNE     .check_d5          ; /  not AA -> re-check D5
    NOP                        ; timing
    LDY     #$02               ; read 3 header fields (track, sector, ?)
.wait_96:
    LDA     $C0EC              ; \
    BPL     .wait_96           ;  |
    CMP     #$96               ;  |
    BNE     .check_d5          ; /  not 96 -> re-check D5
    ; Decode header fields (odd/even encoding)
.read_field:
    LDA     $C0EC              ; \
    BPL     .read_field        ;  | read odd-bits byte
    ROL                        ;  |
    STA     $02                ; /  save shifted
.wait_even:
    LDA     $C0EC              ; \
    BPL     .wait_even         ;  | read even-bits byte
    AND     $02                ; /  combine
    DEY                        ; \
    BPL     .read_field        ; /  loop for 3 fields
    ; A now holds the last decoded field (sector number from this half-track)
    CMP     #$02               ; \
    BEQ     .update_range      ;  | sector 2 -> update range
.scan_done:
    RTS                        ; /  otherwise return (also timeout exit)
.update_range:
    LDA     $00                ; \  update max
    CMP     $03                ;  |
    BCC     .check_min         ;  |
    STA     $03                ; /  max = counter if counter > max
.check_min:
    CMP     $04                ; \  update min
    BCS     .check_done        ;  |
    STA     $04                ; /  min = counter if counter < min
.check_done:
    LDA     $06                ; \
    CMP     #$1F               ;  | scanned all half-tracks up to $1F?
    BEQ     .verify_range      ;  |
    JMP     .search_sector     ; /  no -> continue scanning
.verify_range:
    LDA     $03                ; \
    SEC                        ;  | range = max - min
    SBC     $04                ;  |
    CMP     #$22               ;  | range >= $22 (34)?
    BCC     EALDR_CHECK_FLAG   ;  |
    RTS                        ; /  yes -> pass (return normally)
EALDR_ABORT:                   ;     range too small -> fail
    PLA                        ; \
    PLA                        ;  | discard return address
    RTS                        ; /  abort to caller's caller
    ORG     $AC4C
EALDR_CHECK_FLAG:
    LDA     $01                ; \
    BNE     .ok                ;  | if flag is zero,
    JMP     EALDR_ABORT        ;  | abort (PLA; PLA; RTS at $AC49)
.ok:
    RTS
    ORG     $AC54
EALDR_PROT_ENTRY:
    JSR     EALDR_DISK_IO      ; run half-track protection check
    JSR     EALDR_VM_INTERP    ; enter VM interpreter
    DEX                        ; \  these bytes are skipped;
    BPL     EALDR_PROT_ENTRY+3 ; /  the VM never returns here
    ; VM bytecodes: goto error display if reached
    VMGOTO  VM_ERROR_DISPLAY
    DS      8,$00              ; padding
    ORG     $AC68
EALDR_RESIDUAL_DOCS:
    ; Residual EA loader documentation: $AC68-$ACFF (152 bytes)
    ; Same text as BOOT1_LOADER_DOC
    DC      "ll of the above."
    HEX     0D 10 20 0D 10 20
    DC      "The authors all receive a program called LOADER.O, which writes the loader"
    HEX     0D 10 20
    DC      "to disk.  To create a new LOADER.O after modifyin"
    HEX     0C 0C
    DC      "an"
    ORG     $AD00
EALDR_PADDING:
    ; Unused residual data: $AD00-$AFFF (768 bytes)
    HEX     FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
    HEX     FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
    HEX     FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
    HEX     FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
    HEX     FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
    HEX     FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
    HEX     FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
    HEX     FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
    HEX     FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
    HEX     FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
    HEX     FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
    HEX     FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
    HEX     FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
    HEX     FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
    HEX     FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
    HEX     FF FF FF FF FF FF FF FF FF FF FF FF FF 0D 0D FF
    HEX     D3 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    HEX     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    HEX     00 00 00 00 00 00 00 00 FF 00 00 00 00 00 00 00
    HEX     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    HEX     BF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    HEX     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    HEX     00 00 00 00 00 00 00 00 FF 00 00 00 00 00 00 00
    HEX     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    HEX     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    HEX     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    HEX     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    HEX     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    HEX     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    HEX     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    HEX     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    HEX     00 00 00 00 00 00 00 00 00 00 00 00 00 00 0E 0E
    HEX     0F FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
    HEX     FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
    HEX     FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
    HEX     FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
    HEX     FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
    HEX     FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
    HEX     FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
    HEX     FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
    HEX     FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
    HEX     FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
    HEX     FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
    HEX     FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
    HEX     FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
    HEX     FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
    HEX     FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
    HEX     FF FF FF FF FF FF FF FF FF FF FF 35 35 5E 56 45
    ORG     $B000
EALDR_SPLASH_BITMAP:
    INCLUDE "ea_splash_screen.asm"
    ORG     $B800
EALDR_SOURCE_COMMENTS:
    ; --- EA VM opcode documentation (opcodes 5-17) ---
    DC      "R     "
    EASEP
    DC      " 5"
    EACR
    SLEN    $16
    DC      "; Store acc. absolute"
    EACR
    SLEN    $0C
    DC      "STA   88"
    EASEP
    DC      " 6"
    EACR
    SLEN    $1A
    DC      "; Subtract acc. immediate"
    EACR
    SLEN    $0C
    DC      "SUB     "
    EASEP
    DC      " 7"
    EACR
    SLEN    $22
    DC      "; Jump to assembly (used for exit"
    EACR
    SLEN    $1F
    DC      "; from interpreter, 6502 stack"
    EACR
    SLEN    $1E
    DC      "; should be balanced properly"
    EACR
    SLEN    $20
    DC      "; unless M-code did JSR without"
    EACR
    SLEN    $06
    DC      "; RTS"
    EACR
    SLEN    $0C
    DC      "JMPA    "
    EASEP
    DC      " 8"
    EACR
    SLEN    $20
    DC      "; M-code return from subroutine"
    EACR
    SLEN    $0C
    DC      "RTS     "
    EASEP
    DC      " 9"
    EACR
    SLEN    $21
    DC      "; Load acc. a99. indexed by Acc."
    EACR
    SLEN    $0D
    DC      "LDX     "
    EASEP
    DC      " 10"
    EACR
    SLEN    $12
    DC      "; Shift acc. left"
    EACR
    SLEN    $0D
    DC      "ASL     "
    EASEP
    DC      " 11"
    EACR
    SLEN    $15
    DC      "; Increment absolute"
    EACR
    SLEN    $0D
    DC      "INC     "
    EASEP
    DC      " 12"
    EACR
    SLEN    $10
    DC      "; Add immediate"
    EACR
    SLEN    $0D
    DC      "ADD     "
    EASEP
    DC      " 13"
    EACR
    SLEN    $20
    DC      "; EOR encryption bytes: see the"
    EACR
    SLEN    $22
    DC      "; code below for IEOR1 to get the"
    EACR
    SLEN    $1E
    DC      "; algorithm.  Acc. holds 0 if"
    EACR
    SLEN    $1F
    DC      "; hi order pointer gets::o $68"
    EACR
    SLEN    $1E
    DC      "; (end of encrypted RAM area)"
    EACR
    SLEN    $0D
    DC      "EOR     "
    EASEP
    DC      " 14"
    EACR
    SLEN    $18
    DC      "; Jump if acc. non-zero"
    EACR
    SLEN    $0D
    DC      "BNE     "
    EASEP
    DC      " 15"
    EACR
    SLEN    $14
    DC      "; Subtract absolute"
    EACR
    SLEN    $0D
    DC      "SBA     "
    EASEP
    DC      " 16"
    EACR
    SLEN    $22
    DC      "; Copy a byte from (PTR) - (PTR2)"
    EACR
    SLEN    $1F
    DC      "; then increment both pointers"
    EACR
    SLEN    $0D
    DC      "COP     "
    EASEP
    DC      " 17"
    EACR
    SLEN    $14
    DC      "ICODE   "
    HEX     E5                   ; high-bit 'e'
    DC      " IJMP-IJMP"
    EACR
    SLEN    $0D
    HEX     E5                   ; high-bit 'e'
    DC      " IJSRA-IJMP"
    EACR
    SLEN    $0C
    HEX     E5                   ; high-bit 'e'
    DC      " IBEQ-IJMP"
    EACR
    SLEN    $0C
    DC      ";;ILDI-IJMP"
    EACR
    SLEN    $0C
    HEX     E5                   ; high-bit 'e'
    DC      " ILDA-IJMP"
    EACR
    SLEN    $0C
    HEX     E5                   ; high-bit 'e'
    DC      " IJSR-IJMP"
    EACR
    SLEN    $0C
    HEX     E5                   ; high-bit 'e'
    DC      " ISTA-IJMP"
    EACR
    SLEN    $0C
    HEX     E5                   ; high-bit 'e'
    DC      " ISUB-IJMP"
    EACR
    SLEN    $0D
    HEX     E5                   ; high-bit 'e'
    DC      " IJMPA-IJMP"
    EACR
    SLEN    $0C
    HEX     E5                   ; high-bit 'e'
    DC      " IRTS-IJMP"
    EACR
    SLEN    $0C
    HEX     E5                   ; high-bit 'e'
    DC      " ILDX-IJMP"
    EACR
    SLEN    $0C
    HEX     E5                   ; high-bit 'e'
    DC      " IASL-IJMP"
    EACR
    SLEN    $0C
    HEX     E5                   ; high-bit 'e'
    DC      " IINC-IJMP"
    EACR
    SLEN    $0C
    HEX     E5                   ; high-bit 'e'
    DC      " IADD-IJMP"
    EACR
    SLEN    $0C
    HEX     E5                   ; high-bit 'e'
    DC      " IEOR-IJMP"
    EACR
    SLEN    $03
    HEX     E2                   ; high-bit 'b'
    DC      " "
    EACR
    SLEN    $0C
    HEX     E5                   ; high-bit 'e'
    DC      " IBNE-IJMP"
    EACR
    SLEN    $0C
    HEX     E5                   ; high-bit 'e'
    DC      " ISBA-IJMP"
    EACR
    SLEN    $0C
    HEX     E5                   ; high-bit 'e'
    DC      " ICOP-IJMP"
    EACR
    SLEN    $03
    HEX     E3                   ; high-bit 'c'
    DC      " "
    EACR
    SLEN    $11
    DC      "IJMP    "
    HEX     CB                   ; high-bit 'K'
    ORG     $BC00
EALDR_MOVE_ARM_TRAMPOLINE:
    JMP     EALDR_RWTS_MOVE_ARM
EALDR_READ_TRACK_TRAMPOLINE:               ; $BC03
    JMP     EALDR_RWTS_READ_TRACK
EALDR_SEARCH_ADDR_TRAMPOLINE:              ; $BC06
    JMP     EALDR_RWTS_SEARCH_ADDR
EALDR_READ_DATA_TRAMPOLINE:                ; $BC09
    JMP     EALDR_RWTS_DELAY_INNER
    ORG     $BC0C
EALDR_RWTS_TRACK:
    HEX     00              ; current track number
EALDR_RWTS_ERROR_FLAG:
    HEX     00              ; nonzero = error occurred
EALDR_RWTS_READ_ERROR:
    SEC
    RTS
    ORG     $BC10
EALDR_RWTS_READ_SECTOR:
    SUBROUTINE EALDR_RWTS_READ_SECTOR

    ; Self-modify STA targets based on destination address ($44/$45)
    LDA     #$00
    LDY     $45             ; destination page
    STA     .sta_1+1        ; \  patch STA $xx00,Y low byte
    STY     .sta_1+2        ;  | patch STA $xx00,Y high byte
    SEC
    SBC     #$54            ; \
    BCS     .no_borrow1     ;  | subtract $54, borrow from page
    DEY                     ;  |
    SEC                     ; /
.no_borrow1:
    STA     .sta_2+1        ; \  patch second STA target
    STY     .sta_2+2        ; /
    SBC     #$57            ; \
    BCS     .no_borrow2     ;  | subtract $57, borrow from page
    DEY                     ; /
.no_borrow2:
    STA     .sta_3+1        ; \  patch third STA target
    STY     .sta_3+2        ; /

    ; Search for data prologue: D5 AA AD
    LDY     #$20            ; timeout counter
.search:
    DEY
    BEQ     EALDR_RWTS_READ_ERROR ; timeout
.wait1:
    LDA     $C0EC           ; read nibble
    BPL     .wait1
.check_d5:
    EOR     #$D5
    BNE     .search
    NOP
.wait2:
    LDA     $C0EC
    BPL     .wait2
    CMP     #$AA
    BNE     .check_d5       ; not AA -> re-check for D5
    NOP
.wait3:
    LDA     $C0EC
    BPL     .wait3
    CMP     #$AD
    BNE     .check_d5       ; not AD -> re-check for D5

    ; Read 86 bytes of secondary data ($AA-$FF range of page)
    LDY     #$AA
    LDA     #$00
.read_secondary:
    STA     $4A             ; running checksum
.read_secondary_wait:
    LDX     $C0EC
    BPL     .read_secondary_wait
    LDA     $BD00,X         ; decode via primary nibble table
    STA     $0200,Y         ; store in buffer
    EOR     $4A             ; update checksum
    INY
    BNE     .read_secondary ; loop $AA..$FF (86 bytes)

    ; Read and decode primary data (86 bytes -> page+$00..$55)
    LDY     #$AA
    BNE     .read_primary_start
.sta_3:
    STA     $FFFF,Y         ; self-modified: page+$AC..$FF
.read_primary_start:
    LDX     $C0EC
    BPL     .read_primary_start
    EOR     $BD00,X         ; decode nibble
    LDX     $0200,Y         ; secondary data
    EOR     EALDR_RWTS_NIBBLE_B,X ; pair-decode table
    INY
    BNE     .sta_3          ; loop $AA..$FF (86 bytes)
    PHA                     ; save last decoded value
    AND     #$FC

    ; Read and decode middle data (86 bytes -> page+$56..$AB)
    LDY     #$AA
.read_mid:
    LDX     $C0EC
    BPL     .read_mid
    EOR     $BD00,X
    LDX     $0200,Y
    EOR     EALDR_RWTS_NIBBLE_B+1,X ; offset +1 in pair-decode table
.sta_2:
    STA     $FFFF,Y         ; self-modified: page+$56..$AB
    INY
    BNE     .read_mid

    ; Read and decode final data (84 bytes -> page+$00..$53)
.wait_final1:
    LDX     $C0EC
    BPL     .wait_final1
    AND     #$FC
    LDY     #$AC
.read_final:
    EOR     $BD00,X
    LDX     $01FE,Y         ; secondary data (offset -2)
    EOR     EALDR_RWTS_NIBBLE_B+2,X ; offset +2 in pair-decode table
.sta_1:
    STA     $FFFF,Y         ; self-modified: page+$00..$55
.wait_final2:
    LDX     $C0EC
    BPL     .wait_final2
    INY
    BNE     .read_final

    ; Verify checksum byte
    AND     #$FC
    EOR     $BD00,X         ; decode final nibble
    LDX     #$60            ; slot index (hardcoded slot 6)
    TAY
    BNE     .checksum_bad   ; checksum must be zero

    ; Read epilogue byte (expect $DE)
.wait_epilogue:
    LDA     $C0EC
    BPL     .wait_epilogue
    CMP     #$DE
    BEQ     .ok
.checksum_bad:
    SEC                     ; error: carry set
    HEX     24              ; BIT $zp opcode -- hides next CLC byte
.ok:
    CLC                     ; success: carry clear
    PLA                     ; discard saved byte
    LDY     #$55
    STA     ($44),Y         ; store final byte
    RTS
    ORG     $BCD4
EALDR_RWTS_MOVE_ARM:
    SUBROUTINE EALDR_RWTS_MOVE_ARM

    ASL                     ; double for half-track addressing
    STA     $4A             ; target half-track
.compare:
    LDA     EALDR_RWTS_TRACK
    STA     $4B             ; save current position
    SEC
    SBC     $4A             ; current - target
    BEQ     EALDR_RWTS_PHASE_ON_RTS ; already there -> RTS at $BD10
    BCS     .step_out
    INC     EALDR_RWTS_TRACK ; step inward
    BCC     .do_step
.step_out:
    DEC     EALDR_RWTS_TRACK ; step outward
.do_step:
    JSR     EALDR_RWTS_PHASE_ON ; activate stepper phase
    JSR     EALDR_RWTS_DELAY ; wait for head to settle
    LDA     $4B             ; previous half-track
    AND     #$03
    ASL                     ; phase index x 2
    ORA     #$60            ; $C0x0 slot offset
    TAY
    LDA     $C080,Y         ; deactivate previous phase
    JSR     EALDR_RWTS_DELAY ; wait
    BEQ     .compare        ; always taken (delay returns Z=1)
    JSR     EALDR_RWTS_DELAY ; (unreachable)
    ORG     $BD04
EALDR_RWTS_PHASE_ON:
    SUBROUTINE EALDR_RWTS_PHASE_ON

    LDA     EALDR_RWTS_TRACK
    AND     #$03            ; phase = track mod 4
    ASL                     ; x 2 for IWM register spacing
    ORA     #$60            ; slot offset $60 (slot 6)
    TAY
    LDA     $C081,Y         ; activate phase (odd address = on)
EALDR_RWTS_PHASE_ON_RTS:
    RTS
    ORG     $BD11
EALDR_RWTS_DELAY:
    SUBROUTINE EALDR_RWTS_DELAY

    LDA     #$28            ; outer counter = 40
    SEC
EALDR_RWTS_DELAY_INNER:                    ; $BD14
.outer:
    PHA
.inner:
    SBC     #$01
    BNE     .inner          ; inner loop: 256 iterations
    PLA
    SBC     #$01
    BNE     .outer          ; outer loop: 40 iterations
    RTS
    ORG     $BD1F
EALDR_RWTS_ADDR_ERROR:
    SEC
    RTS
    ORG     $BD21
EALDR_RWTS_SEARCH_ADDR:
    SUBROUTINE EALDR_RWTS_SEARCH_ADDR

    ; Timeout counter
    LDY     #$FC
    STY     $4A             ; outer counter (high byte)
.retry:
    INY
    BNE     .wait_d5
    INC     $4A
    BEQ     EALDR_RWTS_ADDR_ERROR ; timeout

    ; Search for D5 AA 96 address prologue
.wait_d5:
    LDA     $C0EC
    BPL     .wait_d5
.check_d5:
    CMP     #$D5
    BNE     .retry
    NOP
.wait_aa:
    LDA     $C0EC
    BPL     .wait_aa
    CMP     #$AA
    BNE     .check_d5       ; not AA -> re-check D5
    LDY     #$03            ; 4 header fields to read
.wait_96:
    LDA     $C0EC
    BPL     .wait_96
    CMP     #$96
    BNE     .check_d5       ; not 96 -> re-check D5

    ; Read 4 encoded header bytes (volume, track, sector, checksum)
    LDA     #$00
.read_header:
    STA     $4B             ; running checksum
.wait_odd:
    LDA     $C0EC           ; \
    BPL     .wait_odd       ;  | read odd-bits byte
    ROL                     ;  |
    STA     $4A             ; /  save shifted value
.wait_even:
    LDA     $C0EC           ; \
    BPL     .wait_even      ;  | read even-bits byte
    AND     $4A             ;  | combine with odd bits
    STA     $38,Y           ;  | store at $3B,$3A,$39,$38 (Y=3..0)
    EOR     $4B             ;  | update checksum
    DEY                     ;  |
    BPL     .read_header    ; /  loop for all 4 fields

    ; Verify checksum
    TAY
    BNE     EALDR_RWTS_ADDR_ERROR ; checksum must be zero

    ; Read address epilogue: DE AA
.wait_de:
    LDA     $C0EC
    BPL     .wait_de
    CMP     #$DE
    BNE     EALDR_RWTS_ADDR_ERROR
    NOP
.wait_aa2:
    LDA     $C0EC
    BPL     .wait_aa2
    CMP     #$AA
    BNE     EALDR_RWTS_ADDR_ERROR
    CLC                     ; success
    RTS
    ORG     $BD7D
EALDR_RWTS_PADDING:
    HEX     18 60           ; residual CLC; RTS (dead code)
    DS      24,$00          ; zero padding
    HEX     04              ; secondary nibble table tail byte
    ORG     $BD98
EALDR_RWTS_NIBBLE_A:
    ; $BD98-$BDFF: primary 6-and-2 decode table (104 bytes)
    HEX     98 99 08 0C 9C 10 14 18
    HEX     A0 A1 A2 A3 A4 A5 1C 20
    HEX     A8 A9 AA 24 28 2C 30 34
    HEX     B0 B1 38 3C 40 44 48 4C
    HEX     B8 50 54 58 5C 60 64 68
    HEX     C0 C1 C2 C3 C4 C5 C6 C7
    HEX     C8 C9 CA 6C CC 70 74 78
    HEX     D0 D1 D2 7C D4 D5 80 84
    HEX     D8 88 8C 90 94 98 9C A0
    HEX     E0 E1 E2 E3 E4 A4 A8 AC
    HEX     E8 B0 B4 B8 BC C0 C4 C8
    HEX     F0 F1 CC D0 D4 D8 DC E0
    HEX     F8 E4 E8 EC F0 F4 F8 FC
    ORG     $BE00
EALDR_RWTS_NIBBLE_B:
    ; 256-byte secondary decode table
    HEX     00 00 00 96 02 00 00 97 01 00 00 9A 03 00 00 9B
    HEX     00 02 00 9D 02 02 00 9E 01 02 00 9F 03 02 00 A6
    HEX     00 01 00 A7 02 01 00 AB 01 01 00 AC 03 01 00 AD
    HEX     00 03 00 AE 02 03 00 AF 01 03 00 B2 03 03 00 B3
    HEX     00 00 02 B4 02 00 02 B5 01 00 02 B6 03 00 02 B7
    HEX     00 02 02 B9 02 02 02 BA 01 02 02 BB 03 02 02 BC
    HEX     00 01 02 BD 02 01 02 BE 01 01 02 BF 03 01 02 CB
    HEX     00 03 02 CD 02 03 02 CE 01 03 02 CF 03 03 02 D3
    HEX     00 00 01 D6 02 00 01 D7 01 00 01 D9 03 00 01 DA
    HEX     00 02 01 DB 02 02 01 DC 01 02 01 DD 03 02 01 DE
    HEX     00 01 01 DF 02 01 01 E5 01 01 01 E6 03 01 01 E7
    HEX     00 03 01 E9 02 03 01 EA 01 03 01 EB 03 03 01 EC
    HEX     00 00 03 ED 02 00 03 EE 01 00 03 EF 03 00 03 F2
    HEX     00 02 03 F3 02 02 03 F4 01 02 03 F5 03 02 03 F6
    HEX     00 01 03 F7 02 01 03 F9 01 01 03 FA 03 01 03 FB
    HEX     00 03 03 FC 02 03 03 FD 01 03 03 FE 03 03 03 FF
    ORG     $BF00
EALDR_RWTS_READ_TRACK:
    SUBROUTINE EALDR_RWTS_READ_TRACK

    ; First attempt: clear error flag, seek, load
    PHA
    LDA     #$00
    STA     EALDR_RWTS_ERROR_FLAG
    PLA
    JSR     .seek_and_load  ; seek + load all sectors
    LDA     EALDR_RWTS_ERROR_FLAG
    BNE     .retry
    RTS                     ; success

.retry:
    ; Second attempt on error
    LDA     #$00
    STA     EALDR_RWTS_ERROR_FLAG
    JSR     .load_sectors   ; try again (already on track)
    LDA     EALDR_RWTS_ERROR_FLAG
    RTS                     ; return with error flag in A

.seek_and_load:
    JSR     EALDR_RWTS_MOVE_ARM ; seek to track in A
    ; Fall through to .load_sectors

.load_sectors:
    ; Build destination page table: interleave[i] + base page
    LDY     #$0F
.build_table:
    LDA     EALDR_RWTS_INTERLEAVE,Y
    CLC
    ADC     $3E             ; add base page
    STA     EALDR_RWTS_DEST_PAGES,Y
    DEY
    BPL     .build_table

    LDX     #$60            ; slot index (hardcoded slot 6)
    LDA     #$60            ; retry counter
    STA     $40
.retry_sector:
    DEC     $40
    BEQ     .timeout
    JSR     EALDR_RWTS_SEARCH_ADDR ; find address field -> sector in $39
    BCS     .retry_sector   ; error -> retry

    LDY     $39             ; sector number
    LDA     EALDR_RWTS_DEST_PAGES,Y ; destination page for this sector
    BEQ     .retry_sector   ; zero = already read, skip
    STA     $45             ; destination page
    LDA     #$00
    STA     $44             ; destination = $xx00
    JSR     EALDR_RWTS_READ_SECTOR ; read and decode data field
    BCS     .retry_sector   ; error -> retry

    ; Mark sector as done
    LDY     $39
    LDA     #$00
    STA     EALDR_RWTS_DEST_PAGES,Y ; zero = done

    ; Check if all sectors read
    LDY     #$0F
.check_done:
    LDA     EALDR_RWTS_DEST_PAGES,Y
    BNE     .retry_sector   ; still have sectors to read
    DEY
    BPL     .check_done
    RTS                     ; all 16 sectors read

.timeout:
    INC     EALDR_RWTS_ERROR_FLAG ; signal error
    RTS
    ORG     $BF64
EALDR_RWTS_INTERLEAVE:
    HEX     0F 08 01 09 02 0A 03 0B 04 0C 05 0D 06 0E 07 00
    ORG     $BF74
EALDR_RWTS_DEST_PAGES:
    DS      16,$00          ; filled at runtime by EALDR_RWTS_READ_TRACK
    ORG     $BF84
EALDR_RWTS_TAIL_PADDING:
    HEX     FF 00 FF 00 FF 00 FF 00 FF 00 FF 00 FF 00 FF 00
    HEX     FF 00 FF 00 FF 00 FF 00 FF 00 FF 00 FF 00 FF 00
    HEX     FF 00 FF 00 FF 00 FF 00 FF 00 FF 00 FF 00 FF 00
    HEX     FF 00 FF 00 FF 00 FF 00 FF 00 FF 00 FF 00 FF 00
    HEX     FF 00 FF 00 FF 00 FF 00 FF 00 FF 00 FF 00 FF 00
    HEX     FF 00 FF 00 FF 00 FF 00 FF 00 FF 00 FF 00 FF 00
    HEX     FF 00 FF 00 FF 00 FF 00 FF 00 FF 00 FF 00 FF 00
    HEX     FF 00 FF 00 FF 00 FF 00 FF 00 FF 0F