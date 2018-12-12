 processor 6502
 org $1000
 
		lda #$00				;load the colour
		sta $d020				;border
		sta $d021				;main screen

		txa						;copy the value from accumalator to the x register
		lda #$20				;the pet-ascii char for space
		
loop:	sta $0400,x				;top left of the screen
		sta $0500,x				;next line
		sta $0600,x				;next line
		sta $0700,x				;next line
		dex						;x--
		bne loop				;if x is not zero. when z flag is zero then branch
		rts