 processor 6502
 org $1000					;sys 4096
  
			ldx #$01		;character Z
			sta $0400
loop:		inc $0400	
			
chk_space:	lda $dc01 ;check keyboard
			cmp #$ef ;spacebar pressed?
			beq exit
							
			jmp loop
exit:		;end
