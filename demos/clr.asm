 processor 6502
 org $1000
 
			lda #$00		;put 0 in the accumulator
			sta $d020		;put value of accumulator into $d020 (the border)
			sta $d021		;put value of accumulator into $d021 (the main)
			tax				;transfer the value in teh accumulator to x
			lda $20			;put the value of $20 in accumulator
clrloop:	sta $0400,x		;store the value in the accumulator into $0400,x
			sta $0500,x
			sta $0600,x
			sta $0700,x
			dex
			bne clrloop