 processor 6502
 org $1000
 
loop: 	lda #$00		;the colour black
		sta $d020		;store in the border
		sec				;set the carry flag
		clc				;clear the carry flag
		adc #$04		;add to the accumalator the value of 4
		sta $d021		;set the main screen colour
		asl $d021		;shift left doubling the value
		jmp loop