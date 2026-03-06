    PROCESSOR 6502
        ORG     $A806
    ealdr_entry:
        LDY      #$00              ; Fill $2000-$7FFF with $FF
        STY      ealdr_src         ; ($4C) = pointer low
        LDA      #$20
        STA      ealdr_src+1       ; ($4D) = $20 (start page)
        LDA      #$FF
    .fill:
        STA      (ealdr_src),Y
        INY
        BNE      .fill
        INC      ealdr_src+1
        BPL      .fill             ; loop until page $80 (sign bit set)
    
        LDX      #$00              ; Copy splash screen from $B000+
    .copy_lo:
        JSR      ealdr_copy_byte   ; copy byte, advance source
        INX
        CPX      #$20              ; X = $00..$1F (first 32 bytes)
        BNE      .copy_lo
        LDX      #$80
    .copy_hi:
        JSR      ealdr_copy_byte   ; X = $80..$9F (next 32 bytes)
        INX
        CPX      #$A0
        BNE      .copy_hi
        INC      ealdr_copy_src+1  ; self-modify: advance source page
        LDA      ealdr_copy_src+1
        CMP      #$40              ; done when source page reaches $40
        BNE      .copy_lo
        JMP      ealdr_vm_exec     ; enter VM
        ORG     $A83A
    ealdr_copy_byte:
    ealdr_copy_src = *+1
        LDA      $B000             ; self-modified source address
        STA      $202C,X           ; dest = HGR page + offset
        INC      ealdr_copy_src    ; advance source (low byte)
        BNE      .done
        INC      ealdr_copy_src+1  ; carry to high byte
    .done:
        RTS
        ORG     $A849
    ealdr_vm_exec:
        LDX      #$30              ; filler (skipped by Y=4)
        JSR      ealdr_vm_interp   ; call interpreter
        DEX                        ; \  these 3 bytes are skipped;
        BPL      ealdr_vm_exec     ; /  the VM never returns here
                                    ; VM bytecodes begin at $A851
        ORG     $A898
    ealdr_clear_text:
        LDA      #$00
        STA      ealdr_src         ; $4C = 0
        LDA      #$04
        STA      ealdr_src+1       ; $4D = 4 -> pointer = $0400
        LDY      #$00
    .loop:
        LDA      #$00
        STA      (ealdr_src),Y     ; zero out
        INY
        BNE      .loop
        INC      ealdr_src+1
        LDA      ealdr_src+1
        CMP      #$08              ; done at $0800
        BNE      .loop
        RTS
        ORG     $A948
    ealdr_reboot:
        JSR      $FC58             ; HOME (clear screen)
        LDA      #$FF
    .delay:
        LDX      #$A0
    .inner:
        DEX
        BNE      .inner
        BIT      $C030             ; click speaker
        SEC
        SBC      #$01
        BNE      .delay
        LDA      #$C5              ; 'E'
        STA      $0400
        LDA      #$C1              ; 'A'
        STA      $0401
        JMP      $C600             ; reboot from Disk II
        ORG     $A970
    ealdr_funny_inc:
        INC      ealdr_bot         ; $AC60
        LDA      ealdr_bot
        CMP      ealdr_top         ; $AC61
        BEQ      .wrap
        RTS
    .wrap:
        LDA      #$01
        STA      ealdr_bot
        INC      ealdr_top
        RTS
        ORG     $A9F3
    EALDR_track_pages:
        HEX     08 10 20 30 00
        HEX     40 50 60 70 80 86 00
        HEX     08 10 20 30 00
    
    EALDR_tracks:
        HEX     03 04 21 22 00
        HEX     07 08 09 0A 0B 0C 00
        HEX     0D 0E 0F 10 00
        ORG     $AA35
    ealdr_vm_interp:
        LDA      EALDR_psuedoacc   ; save VM accumulator
        PHA
        TYA                        ; save Y
        PHA
        JSR      ealdr_vm_init     ; RTS trick: pull return addr -> $46/$47
    
        ; --- After RTS trick, execution resumes here ---
        PLA                        ; pull saved Y -> $46 (low byte of return addr)
        STA      ealdr_ptr
        PLA                        ; pull saved acc -> $47 (high byte)
        STA      ealdr_ptr+1
    
        ; Dispatch loop
        LDY      #$04              ; skip 4 bytes (DEX/BPL/offset + JSR addr byte)
    .dispatch:                      ; $AA45
        LDA      (ealdr_ptr),Y     ; read opcode byte
        INY
        BNE      .no_carry
        INC      ealdr_ptr+1
    .no_carry:
        TAX                        ; opcode -> X
        LDA      ealdr_dispatch_table,X  ; handler offset
        CLC
        ADC      #<ealdr_vm_loop   ; handler = $AA72 + offset
        STA      ealdr_vm_jmp+1    ; self-modify JMP low byte
        LDA      #>ealdr_vm_loop
        ADC      #$00              ; carry
        STA      ealdr_vm_jmp+2    ; self-modify JMP high byte
    ealdr_vm_jmp:
        JMP      ealdr_vm_loop     ; self-modified: jump to handler
    
        ; --- Handler return point (goto path) ---
    ealdr_vm_loop:                  ; $AA72
        JSR      ealdr_read_arg16  ; read 2-byte encoded address -> $42/$43
        LDA      $42
        STA      ealdr_ptr         ; update bytecode pointer
        LDA      $43
        STA      ealdr_ptr+1
        LDY      #$00
        JMP      .dispatch         ; read next opcode
        ORG     $AA60
    ealdr_dispatch_table:
        HEX  00 3C 53 5D 6B 88 AB BC 4D A0 77 B7
        ;    GOTO CALL1 BEQ LDI LD CALL ST SUBI CALL0 RET LDX ASL
        HEX  D1 D4 D7 DA DD E0
        ;    INC  ADD  DXR  BNE  SUB  COPY (trampolines)
        ORG     $AA82
    ealdr_read_arg16:
        LDA      (ealdr_ptr),Y     ; read low byte
        EOR      #$03              ; decrypt
        INY
        BNE      .no_carry1
        INC      ealdr_ptr+1
    .no_carry1:
        STA      $42               ; decoded low byte
        LDA      (ealdr_ptr),Y     ; read high byte
        INY
        BNE      .no_carry2
        INC      ealdr_ptr+1
    .no_carry2:
        EOR      #$D9              ; decrypt
        STA      $43               ; decoded high byte
        RTS
        ORG     $AA99
    ealdr_vm_init:
        PLA
        STA      $42               ; return addr low
        PLA
        STA      $43               ; return addr high
        PLA
        STA      ealdr_ptr         ; saved Y -> $46 (overwritten later)
        PLA
        STA      ealdr_ptr         ; saved acc -> $46 (overwrites Y)
        INC      $42               ; return addr + 1
        BNE      .no_carry
        INC      $43
    .no_carry:
        JMP      ($0042)           ; jump to instruction after JSR
        ORG     $AAAE
    ; --- Opcode 01: CALL1 addr ---
    ; Call 6502 subroutine; result -> VM acc.  Handler at $AAAE.
    ealdr_op_call1:
        JSR      ealdr_read_arg16  ; decode addr -> $42/$43
        TYA
        PHA                        ; save Y (subroutine may clobber it)
        LDA      EALDR_psuedoacc
        JSR      ealdr_jmp_ind     ; JMP ($0042) -- enters subroutine
        STA      EALDR_psuedoacc   ; return value -> VM acc
        PLA
        TAY                        ; restore Y
        JMP      ealdr_vm_dispatch ; linear
    
    ; Helper: indirect jump through $42/$43.  Used by CALL1 and CALL0.
    ealdr_jmp_ind:                  ; $AAC2
        JMP      ($0042)
    
    ; --- Opcode 08: CALL0 addr ---
    ; Terminal jump to 6502 code (no return).  Handler at $AABF.
    ealdr_op_call0:
        JSR      ealdr_read_arg16
        JMP      ($0042)
    
    ; --- Opcode 02: BEQ addr ---
    ; Branch if VM acc = 0.  Handler at $AAC5.
    ealdr_op_beq:
        JSR      ealdr_read_arg16
        LDA      EALDR_psuedoacc
        BEQ      ealdr_vm_loop     ; zero -> goto path (IP = $42/$43)
        JMP      ealdr_vm_dispatch ; nonzero -> linear
    
    ; --- Opcode 03: LDI val ---
    ; Load 1-byte immediate (XOR $4C) into VM acc.  Handler at $AACF.
    ealdr_op_ldi:
        LDA      (ealdr_ptr),Y    ; read encoded byte
        INY
        BNE      .nc
        INC      ealdr_ptr+1
    .nc:
        EOR      #$4C             ; decrypt
        STA      EALDR_psuedoacc
        JMP      ealdr_vm_dispatch
    
    ; --- Opcode 04: LD addr ---
    ; Load byte at addr into VM acc.  Handler at $AADD.
    ealdr_op_ld:
        JSR      ealdr_read_arg16
    ealdr_op_ld_do:                 ; $AAE0 (shared by LDX)
        LDX      #$00
        LDA      ($42,X)           ; load byte at decoded address
        STA      EALDR_psuedoacc
        JMP      ealdr_vm_dispatch
    
    ; --- Opcode 0A: LDX addr ---
    ; Indexed load: A <- (addr + A).  Handler at $AAE9.
    ealdr_op_ldx:
        JSR      ealdr_read_arg16
        LDA      EALDR_psuedoacc  ; add VM acc to address
        CLC
        ADC      $42
        STA      $42
        BCC      .nc
        INC      $43
    .nc:
        JMP      ealdr_op_ld_do   ; fall into LD handler
    
    ; --- Opcode 05: CALL addr ---
    ; VM subroutine call: push return IP, goto addr.  Handler at $AAFA.
    ealdr_op_call:
        JSR      ealdr_read_arg16  ; target -> $42/$43
        TYA                        ; compute return IP = $46 + Y
        CLC
        ADC      ealdr_ptr
        STA      ealdr_ptr
        BCC      .nc
        INC      ealdr_ptr+1
    .nc:
        LDA      ealdr_ptr         ; push return addr (lo first, hi second)
        PHA
        LDA      ealdr_ptr+1
        PHA
        LDY      #$00
        JMP      ealdr_vm_loop     ; goto path (IP = target)
    
    ; --- Opcode 09: RET ---
    ; Return from VM subroutine.  Handler at $AB12.
    ealdr_op_ret:
        PLA                        ; pop return addr (hi first, lo second)
        STA      ealdr_ptr+1
        PLA
        STA      ealdr_ptr
        LDY      #$00
        JMP      ealdr_vm_dispatch
    
    ; --- Opcode 06: ST addr ---
    ; Store VM acc at addr.  Handler at $AB1D.
    ealdr_op_st:
        JSR      ealdr_read_arg16
        LDA      EALDR_psuedoacc
        LDX      #$00
        STA      ($42,X)
        JMP      ealdr_vm_dispatch
    
    ; --- Opcode 0B: ASL ---
    ; Shift VM acc left.  Handler at $AB29.
    ealdr_op_asl:
        ASL      EALDR_psuedoacc
        JMP      ealdr_vm_dispatch
    
    ; --- Opcode 07: SUBI val ---
    ; Subtract 1-byte immediate (XOR $4C) from VM acc.  Handler at $AB2E.
    ealdr_op_subi:
        LDA      (ealdr_ptr),Y    ; read encoded byte
        INY
        BNE      .nc
        INC      ealdr_ptr+1
    .nc:
        EOR      #$4C             ; decrypt
        STA      $42              ; temp
        LDA      EALDR_psuedoacc
        SEC
        SBC      $42              ; acc - immediate
        STA      EALDR_psuedoacc
        JMP      ealdr_vm_dispatch
    
    ; --- Trampolines for opcodes 0C-11 ---
    ; These JMPs bridge the 1-byte dispatch offset limit.
    ealdr_tramp_inc:                ; $AB43
        JMP      ealdr_op_inc
    ealdr_tramp_add:
        JMP      ealdr_op_add
    ealdr_tramp_dxr:
        JMP      ealdr_dxr_step
    ealdr_tramp_bne:
        JMP      ealdr_op_bne
    ealdr_tramp_sub:
        JMP      ealdr_op_sub
    ealdr_tramp_copy:
        JMP      ealdr_op_copy
    
    ; --- Opcode 0E: DXR ---
        ORG     $AB55
    ealdr_dxr_step:
        LDX      #$00
        LDA      (ealdr_src,X)     ; load byte at (src)
        EOR      EALDR_psuedoacc   ; XOR with accumulator
        STA      (ealdr_src,X)     ; store back
        INC      ealdr_src         ; src += 2 (skip every other byte)
        INC      ealdr_src
        BNE      .no_carry
        INC      ealdr_src+1
    .no_carry:
        LDA      ealdr_src+1       ; new acc = high byte of src XOR $68
        EOR      #$68
        STA      EALDR_psuedoacc
        JMP      ealdr_vm_dispatch ; linear continuation)
    
    ; --- Opcode 0F: BNE addr ---
    ; Branch if VM acc != 0.  Handler at $AB6E.
    ealdr_op_bne:
        JSR      ealdr_read_arg16
        LDA      EALDR_psuedoacc
        BEQ      .skip
        JMP      ealdr_vm_loop     ; nonzero -> goto path
    .skip:
        JMP      ealdr_vm_dispatch ; zero -> linear
    
    ; --- Opcode 0C: INC addr ---
    ; Increment byte at addr; result also -> VM acc.  Handler at $AB7B.
    ealdr_op_inc:
        JSR      ealdr_read_arg16
        LDX      #$00
        LDA      ($42,X)
        CLC
        ADC      #$01
        STA      ($42,X)           ; store incremented value
        STA      EALDR_psuedoacc   ; also update VM acc
        JMP      ealdr_vm_dispatch
    
    ; --- Opcode 0D: ADD addr ---
    ; A <- A + (addr).  Handler at $AB8C.
    ealdr_op_add:
        JSR      ealdr_read_arg16
        LDX      #$00
        LDA      ($42,X)
        CLC
        ADC      EALDR_psuedoacc
        STA      EALDR_psuedoacc
        JMP      ealdr_vm_dispatch
    
    ; --- Opcode 10: SUB addr ---
    ; A <- A - (addr).  Handler at $AB9B.
    ealdr_op_sub:
        JSR      ealdr_read_arg16
        LDX      #$00
        LDA      EALDR_psuedoacc
        SEC
        SBC      ($42,X)
        STA      EALDR_psuedoacc
        JMP      ealdr_vm_dispatch
    
    ; --- Opcode 11: COPY ---
    ; Copy one byte: (dest++) <- (src++).  Handler at $ABAA.
    ealdr_op_copy:
        LDX      #$00
        LDA      (ealdr_src,X)    ; read from src
        STA      (ealdr_dest,X)   ; write to dest
        INC      ealdr_src        ; src++
        BNE      .nc1
        INC      ealdr_src+1
    .nc1:
        INC      ealdr_dest       ; dest++
        BNE      .nc2
        INC      ealdr_dest+1
    .nc2:
        JMP      ealdr_vm_dispatch
        ORG     $AB55
    ealdr_dxr_step:
        LDX      #$00
        LDA      (ealdr_src,X)     ; load byte at (src)
        EOR      EALDR_psuedoacc   ; XOR with accumulator
        STA      (ealdr_src,X)     ; store back
        INC      ealdr_src         ; src += 2 (skip every other byte)
        INC      ealdr_src
        BNE      .no_carry
        INC      ealdr_src+1
    .no_carry:
        LDA      ealdr_src+1       ; new acc = high byte of src XOR $68
        EOR      #$68
        STA      EALDR_psuedoacc
        JMP      ealdr_vm_dispatch ; linear continuation
        ORG     $BC00
    ealdr_move_arm:
        JMP      $BCD4
    ealdr_read_track:               ; $BC03
        JMP      $BF00
    ealdr_search_addr:              ; $BC06
        JMP      $BD21
    ealdr_read_data:                ; $BC09
        JMP      $BD14