	.LF /Users/ingoschmied/Documents/develop.nosync/assembly/flags-display/flags-display.lst
;---------------------------------------------------------------------------
;
;		flags-display
;
;---------------------------------------------------------------------------

	.CR	Z80				;It's a Z80 assembler now
	.TF /Users/ingoschmied/Documents/develop.nosync/assembly/flags-display/flags-display.bin, bin
	.OR $0000

A_DAT		.EQ $00		;PIO PORT A data
B_DAT		.EQ $01		;PIO PORT B data
A_CTL		.EQ $02		;PIO PORT A control
B_CTL   	.EQ $03		;PIO PORT B control

    LD A, $0F           ;Set PIO PORT A to output
    OUT (A_CTL), A
    LD A, $0F           ;Set PIO PORT B to output
    OUT (B_CTL), A

    LD A, $00           ;
    LD C, B_DAT
    
OUTPUT:
    PUSH AF
    POP DE              ;Load D with A, & E with F
    OUT (A_DAT), A      ;Send A to PORT A
    OUT (C), E          ;Send F via E to PORT B
    INC A
    JR NZ,OUTPUT       ;Loop until we wrap back to $00
    HALT