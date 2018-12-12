 processor 6502
 org $810
 
			lda #$00		;black
			sta $d020		;border
			sta $d021		;screen background colour
			tax				;transfer the value in the accumulator to x register
					
clrscreen:
			sta $0400,x		;screen data to 0
			sta $0500,x
			sta $0600,x
			sta $0700,x
			sta $2000,x		;character data to 0	
			dex				;x--
			bne clrscreen	;assuming bne when 0
			
			;load message		
write:		lda msg,x	;load our byte index location
			jsr $ffd2	;write the value in the accumulator to the screen
			inx			;increment x
			cpx #$22		;bcoz our text is 54 characters long
			bne write	;if we are not equal then branch to write
			
			lda #$18		;screen at $0400, chars at $2000 [0001 1000]
			sta $d018		;vic register

mainloop:
			lda $d012		;load the raster beam
			cmp #$ff		;is it $ff
			bne mainloop
						
			ldx counter		;get offset value
			inx				;x++
			cpx #$ff		;delay	
			bne juststx		;is it equal
			ldx #$00

juststx:
			stx counter		;store the value in counter to x register
			lda $2000,x		;get byte counter from chardata
			eor #$ff		;invert
			sta $2000,x		;store it back in
			sta $2040,x
			jmp mainloop
counter:
	.byte 8

;msg	.byte "C64 programming tutorial by digitalerror of Dark Codex"
msg	.byte "Cynic of The Black Art Corporation"
 
 org $1ffe							;the character set
 INCBIN "scrap_writer_iii_17.64c"
