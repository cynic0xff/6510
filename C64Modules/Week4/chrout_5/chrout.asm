 processor 6502
 org $1000				;sys 4096
 
			jsr $e544		;clear screen using the built in characters

			ldx #$00		;the x reg will be used as the counter
loop:		lda message,x	;load into the acc the message+x
			jsr $ffd2		;call the commodore kernal routine to print a character.
			inx				;increment x
			cpx #$0c		;compare to #$35 which it the # character
			bne loop		;branch not equal to loop
			rts				;return control back to the commodore os
			
message	.byte "HELLO WORLD!"
