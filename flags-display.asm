	.LF /Users/ingoschmied/Documents/develop.nosync/assembly/flags-display/flags-display.lst
;---------------------------------------------------------------------------
;
;		Description:
;
;           Early attempt to use an interrupt to call a subroutine that
;           displays the contents of the accumulator and the flags 
;           register on two seven segment displays and a bar graph LED
;           respectively. The hardware has a switch to enable/disable 
;           this functionality.
;
;---------------------------------------------------------------------------

	.CR	Z80				;It's a Z80 assembler now
	.TF /Users/ingoschmied/Documents/develop.nosync/assembly/flags-display/flags-display.int, int
	.OR $0000

A_DAT		.EQ $00		;PIO PORT A data
B_DAT		.EQ $01		;PIO PORT B data
A_CTL		.EQ $02		;PIO PORT A control
B_CTL   	.EQ $03		;PIO PORT B control

    EI                  ;Enable interrupts
    CALL RESTART

    .OR $0008           ;Use RST08 for OUTPUT subroutine
OUTPUT:
    DI                  ;Disable interrupts
    PUSH BC             ;Push BC on the stack
    PUSH AF             ;Push Flags on the stack
    POP BC              ;Load B with A, & C with Flags
    LD B, C             ;Load Flags into B
    OUT (A_DAT), A      ;Send A to PORT A
    LD C, B_DAT         ;
    OUT (C), E          ;Send F via E to PORT B
    POP BC              ;Restore BC
    EI                  ;Enable interrupts
    RETI

    .OR $0100           ;Make room for other RST handlers
RESTART:
    LD A, $0F           ;Set PIO PORT A to output
    OUT (A_CTL), A
    LD A, $0F           ;Set PIO PORT B to output
    OUT (B_CTL), A
    LD A, $08           ;Set PIO interrupt vector

    LD A, $00           ;Start at $00

    