 processor 6502
 org $1000
 
loop: 	lda $d012				;increment the value in $d021
		cmp #$ff				;255 dec
		bne loop				;if zero flag is not set then branch to loop
		
		inc $d021				;inc the value in $d021
		jmp loop
		
		rts
 