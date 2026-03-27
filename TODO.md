* In the <<main.asm>> chunk, I've added comments and spaces between major sections
  of the code. It is possible that each such section could be an object file, with
  separate assembly source files. Make sure to keep those comments and spaces when
  running reorder_nw.py.

* Convert every EQU for a non-zero page address to a label. For example: RES_ZP_SHADOW.

There are two ways to convert such an EQU, and it depends on what the name is used for.

1. If it is an address inside disassembled code, then it must be converted to a code label.
2. If it is an address inside data, then it must be converted to a data chunk as follows:

<<chunk name>>=
    ORG address
  NAME:
    HEX initial_value [initial_value2] ...
@ %def NAME

The number of initial values depends on what the data area is used for: single byte storage,
16-bit storage, or other-sized buffer.

This chunk must be placed just above the code chunk that first uses it.

* Replace every numeric address in RESIDENT_BYTECODES with a label.
* Verify READ_DATA_FIELD just reads a single sector, ensuring it's all disk $AF bytes.
* I'm suspicious about the half-track comments in <<resident data and bytecodes>>. Research
    to determine if that's really the way half-tracks work.

* Separate <<resident vm handlers>> into individual chunks for each opcode.

* PULL_TWO_RET_ADDRS deserves its own chunk. It is key to understanding RESIDENT_DISPATCH. I'm also suspicious
  that the .resume code in RESIDENT_DISPATCH "restores" anything, since PULL_TWO_RETURN_ADDRS first pulls
  the return address for the JSR to PULL_TWO_RET_ADDRS, then pulls what RESIDENT_DISPATCH pushed (X/Y), then
  jumps to the return address for the JSR to PULL_TWO_RET_ADDRS (verify this!), effectively returning from
  PULL_TWO_RET_ADDRS. Perhaps the two pulls at .resume pull the return address for the JSR to RESIDENT_DISPATCH.
  Then it adds 4 and starts reading bytecode from there. This would be, for example, just after
  ATTRACT_LOOP (which indeed has bytecode there at RESIDENT_BYTECODES).

* ATTRACT_LOOP seems to alternate between two contexts (state maintained by CONTEXT_SWAP). And in
  fact it doesn't seem to be an "attract loop", so pick a better name. Explain what
  the two contexts are. According to the comments, each call to RESIDENT_DISPATCH uses the X/Y addresses as the
  VM address to start execution at. This needs verification, since the call to RESIDENT_DISPATCH is
  preceeded by a call to CONTEXT_SWAP in ATTRACT_LOOP, and X in CONTEXT_SWAP always ends up as zero.
  Also, verify whether each loop in ATTRACT_LOOP executes one bytecode, or executes the entire VM program
  until it exits. For example opcode 0 (GOTO) simply jumps to RESIDENT_DISPATCH_FETCH to go to the address in
  the operand and execute another bytecode there. It seems every opcode ends with going back to
  RESIDENT_DISPATCH_FETCH. Maybe this is like a "yield" where a VM program can yield execution to the
  alternate VM program in the saved context? I think this is opcode 0B, but the doc says that this is
  VMASL? Perhaps we should name it VMYIELD? It is ASL for the EALDR, so maybe this got reused for the game. In
  fact it doesn't seem that the game VM has any opcode beyond $0C. 

* In <<resident dispatch table>>, instead of using HEX to represent the data, these are apparently
  the low bytes of addresses in $0700. So, find the addresses (e.g. $0700, $0727, $0755, ...), find
  labels for them, and then DC.B #<label for each byte. This stores the low byte of the label, thus
  recreating the table. For example, 00 corresponds to address $0700, which has label
  RESIDENT_DECODE_DISPATCH, so replace HEX 00 with DC.B #<RESIDENT_DECODE_DISPATCH.

* In RESIDENT_DISPATCH, replace addresses with labels.
* In the table just after RESIDENT_DECODE_DISPATCH, fill it in.

* In RESIDENT_DISPATCH_FETCH, replace $07E0 with DECODE_DISPATCH_RELAY+1. This is the low byte of the
  address to dispatch to. Replace $07DF with DECODE_DISPATCH_RELAY.

* There's a description of the attract screen call loop, where it says SCENE_LOOP does this: saves ZP pointers, steps PRNG, conditionally loads scene data from disk.  In a loop: checks keyboard/timer via [[$A478]], and
more. Verify that it checks keyboard/timer via [[$A478]], since $A478 is actually LOAD_SCENE_FROM_DISK.

* DISK_VM_BYTECODE and DISK_VM_SUB_PARK_STEPPER and DISK_VM_SUB_EXIT_ERR should be replaced by the macros for VM bytecode.

* What you did for <<resident dispatch table>>, do for DISK_VM_HANDLER_TBL (page $B5).

* DISK_VM_PULL_IP seems very similar to PULL_TWO_RET_ADDRS.

* Interestingly, the opcode table for the disk vm (located just after <<disk vm read addr>>) has opcode $0B being HALT. That may be just a coincidence, since otherwise the disk vm opcodes and the ealdr vm opcodes and game vm opcodes don't seem to be in common.

* In <<EALDR Macros>>, there should be a table of opcodes before going into the chunk with the macros. Look at the opcode table for the disk vm (located just after <<disk vm read addr>>) for example.