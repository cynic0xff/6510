 processor 6502
 org $1000
 
			lda #$01
			sta $d021     	;Put value of acc in $d021
flash:		inc $d021		;increment the value in $d021			
chk_space:	lda $dc01 		;scan keyboard buffer
			cmp #$ef 		;spacebar pressed?
			beq flash			
chk_exit:	cmp #$bf		;is it character q
			beq exit		;branch if equal to exit
			jmp chk_space
exit: