 processor 6502
 org $1000					;sys 4096
  
			ldx #$01		;get a character
			sta $0400		;store the character in screen memory
			
start:		jsr loop		;jump subroutine to label loop
			jsr chk_space	;jump subroutine to label chk_space
			jmp start		;jump back to start
			
loop:		inc $0400		;increments the value stored at location $0400	
			rts				;return from sub routine
	
chk_space:	lda $dc01 		;check keyboard
			cmp #$ef 		;spacebar pressed?
			beq exit		;branch if equal
			rts				;return from sub routine


exit:		;end
			