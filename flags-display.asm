	.LF /Users/ingoschmied/Documents/develop.nosync/assembly/flags-display/flags-display.lst
	.CR	Z80				;It's a Z80 assembler now
	.TF /Users/ingoschmied/Documents/develop.nosync/assembly/flags-display/flags-display.int, int
	.OR $0000

A_DAT		.EQ $00		;PIO PORT A data
B_DAT		.EQ $01		;PIO PORT B data
A_CTL		.EQ $02		;PIO PORT A control
B_CTL   	.EQ $03		;PIO PORT B control
KYBD_PORT   .EQ $04     ;Use $04 instead of $00 as it it on the ZX81

    JP RESTART

    .OR $0038           ;Use RST 56 for OUTPUT subroutine, The
                        ;default handler for Mode 1 Interrupts
OUTPUT:                 
    DI                  ;Disable interrupts
    PUSH BC             ;Push BC on the stack
    PUSH AF             ;Push Flags on the stack
    POP BC              ;Load B with A, & load C with Flags
    LD B, C             ;Load Flags into B
    OUT (B_DAT), A      ;Send A to PORT B
    LD C, A_DAT         ;Set C to PORT A address
    OUT (C), B          ;Send F via B to PORT A
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

KEYBOARD:               ;The ZX81 keyboard subroutine
	LD HL, $FFFF        
	LD BC, $FEFE        
	IN A, (KYBD_PORT)           
	OR $01

EACH_LINE:
	OR $E0
	LD D, A
	CPL
	CP $01
	SBC A, A
	OR B
	AND L
	LD L, A
	LD A, H
	AND D
	LD h, A
	RLC b
	IN A, (KYBD_PORT)
	JR C,EACH_LINE
	RRA
	RL H
	RLA
	RLA
	RLA
	SBC A, A
	AND $18
	ADD A, $1f
	;LD (MARGIN), A
    ;Replacing the above line with code to display H, L, A
    ;using the accumulator display port

    LD C, B_DAT
    OUT (C), H
    OUT (C), L
    OUT (B_DAT), A      ;A holds the value of MARGIN       
	HALT                ;Originally RET