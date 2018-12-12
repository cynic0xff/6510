 processor 6502
 org $1000					;sys 4096
  
			lda #$34		;load into the accumulator the value $34 which is PET ASCII number 1
clrloop:	sta $0400		;store the value in the accumulator into mem location $0400

			lda #$35		;load into the acc $35 == the number 5
			sta $0500		;put the value in the acc into mem location $0500
			
			lda #$36
			sta $0600
			
			lda #$37		;number 7
			sta $0700
			
			lda #$1a		;character Z
			sta $07e7		;final visible screen location
			
chk_space:	lda $dc01 ;check keyboard
			cmp #$ef ;spacebar pressed?
			beq exit
							
			jmp chk_space
exit:		;end
			