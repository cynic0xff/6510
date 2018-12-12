 processor   6502
 org    $1000
 
		jsr $e544		;in built sys function to clear screen
		
		lda #$00		;white border
		sta $d020		;border
		lda #$00		;background colour
		sta $d021		;background
		
		lda #$18		;screen memory at $0400 and charset @ $2000
		sta $d018
		lda #$00

write 	lda msg,x
		jsr $ffd2		;write char in acc tot he screen
		inx
		cpx #$05		;compare with value 5
		bne write		;if we are not equal to 5 then jmp write

		ldx #$00

setcolr lda #$07
		sta $d800,x
		inx
		cpx #$05
		bne setcolr

loop:	jmp loop

msg	.byte "cynic"
 org $1ffe  ;2 bytes for header info before the charset starts
 INCBIN "scrap_writer_iii_17.64c"