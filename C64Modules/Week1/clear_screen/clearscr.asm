 processor 6502
 org $1000					;sys 4096
  
			lda #$20			;put the value $20 in the accu
clrloop:	sta $0400,x		;put value of $0400 + x into the memory location $0400
			sta $0500,x
			sta $0600,x
			sta $0700,x
			dex				;decrement value in x reg
			bne clrloop		;if not zero then branch to clrloop
			