 processor 6502
 org $1000					;sys 4096
  
			ldx #$00		;put 0 into reg x
			lda #$020		;PET ASCII of $20 is a space
clrscreen:	sta $0400,x		;put value of $0400 + x into the memory location $0400
			sta $0500,x
			sta $0600,x
			sta $0700,x
			dex				;decrement value in x reg
			bne clrscreen	;if not zero then branch to clrloop
			
fillloop:	lda #$34		;load into the accumulator the value $34 which is PET ASCII number 1
			sta $0400,x		;store the value in the accumulator into mem location $0400

			lda #$35		;load into the acc $35 == the number 5
			sta $0500,x		;put the value in the acc into mem location $0500
			
			lda #$36
			sta $0600,x
			
			lda #$37		;number 7
			sta $0700,x
			
			dex
			bne fillloop
			
			;place a z characcter in the last screen position
			lda #$1a		;character Z
			sta $07e7		;final visible screen location
			
chk_space:	lda $dc01 ;check keyboard
			cmp #$ef ;spacebar pressed?
			beq exit
							
			jmp chk_space
exit:		;end
			