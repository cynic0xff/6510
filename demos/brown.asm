 processor	6502
 org $1000
 
loop		lda #$00		;0 into the acc
			sta $d020		;store in $d020 (border)
			clc				;clear the carry flag
			adc #$08		;add $08 to the existing value in the accumulator
			sta $d021		;store the brown colour in the display area
			jmp loop