 processor 6502
 org $1000				;sys 4096
 
			jsr $e544		;clear screen using the built in characters

			ldx #$00		;the x reg will be used as the counter
loop:		lda message,x	;load into the acc the message+x
			and #$3f		;and the accum
			sta $0400,x		;store the result in screen memory
			inx				;increment x
			cpx #$0c		;compare to $0c (length of the string in bytes)
			bne loop		;branch not equal to loop
			rts				;return control back to the commodore os
			
message	.byte "HELLO WORLD!"