 processor 6502
 org $1000					;sys 4096
			jsr $e544		;clear screen using the built int characters
			
chk_space:	lda $dc01 ;check keyboard
			cmp #$ef ;spacebar pressed?
			beq exit
							
			jmp chk_space
exit:		;end