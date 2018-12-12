 processor 6502
 org $1000
 
loop:	lda #$00	;load the colour black
		sta $d020	;set the border by storing the value in the accumalator to $d020
		clc			;clear carry flag to see if our addition sets the carry flag
		adc #$08	;add with carry
		sta $d021	;store the value in the main screen colour
		jmp loop