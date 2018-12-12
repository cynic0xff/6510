 processor 6502
 org $1000					;sys 4096
  
			lda $40			;put the value $40 in the accumaltor which is the @ symbol
clrloop:	sta $0400		;store the value in the accumulator into mem location $0400
			sta $0401		;store the value in the accumulator into mem location $0401
			sta $0402		;and the next memory location
			sta $0403		;and the next
			
chk_space:	lda $dc01 ;check keyboard
			cmp #$ef ;spacebar pressed?
			beq exit
							
			jmp chk_space
exit:		;end
			