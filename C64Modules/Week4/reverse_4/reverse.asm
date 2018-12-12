 processor 6502
 org $1000					;sys 4096
 
			jsr $e544		;clear screen using the built in characters

			ldx #$0b		;the x reg will be used as the counter
			ldy #$00
loop:		lda message,x	;load into the acc the message+x
			and #$3f		;and the accum
			sta $0400,y		;store the result in screen memory
			dex				;decrement x
			iny				;increment y
			iny				;y++
			cpx #$00		;compare to $0c (length of the string in bytes)
			bne loop		;branch not equal to loop
			
			;display the last first character of the message because comparing x
			;equals zero we have exited the loop causing the first character = 0
			lda message,x	;display first character x == 0
			and #$3f		;and
			sta $0400,y		;store at final location
			rts				;return control back to the commodore os
			
message	.byte "HELLO WORLD!"