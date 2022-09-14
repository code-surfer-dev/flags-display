	.LF /Users/ingoschmied/Documents/develop.nosync/assembly/flags-display/flags-display.lst
	.CR	Z80				;It's a Z80 assembler now
	.TF /Users/ingoschmied/Documents/develop.nosync/assembly/flags-display/flags-display.int, int
	.OR $0000

A_DAT		.EQ $00		;PIO PORT A data
B_DAT		.EQ $01		;PIO PORT B data
A_CTL		.EQ $02		;PIO PORT A control
B_CTL   	.EQ $03		;PIO PORT B control

    JP RESTART

    .OR $0038           ;Use RST 56 for OUTPUT subroutine, The
                        ;default handler for Mode 1 Interrupts
OUTPUT:                 
    DI                  ;Disable interrupts
    PUSH BC             ;Push BC on the stack
    PUSH AF             ;Push Flags on the stack
    POP BC              ;Load B with A, & C with Flags
    LD B, C             ;Load Flags into B
    OUT (A_DAT), A      ;Send A to PORT A
    LD C, B_DAT         ;Set C to PORT B address
    OUT (C), B          ;Send F via B to PORT B
    POP BC              ;Restore BC
    EI                  ;Enable interrupts
    RETI

    .OR $0100           ;Make room for other RST handlers
RESTART:
    LD SP, $FFFF        ;Initialize the stack pointer
    LD A, $0F           ;Set PIO PORT A to output
    OUT (A_CTL), A
    LD A, $0F           ;Set PIO PORT B to output
    OUT (B_CTL), A
    IM 1
    EI                  ;Enable interrupts

    ;JP USER_PROGRAM    ;Could jump to a program in RAM  

    LD A, $01           ;Simple test in ROM to start with
LOOP:

    INC A
    JR NZ,LOOP
    HALT
    