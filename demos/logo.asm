 processor 6502
 org $1000
 
		lda $4710		;background colour from the bitmap
		sta $d020		;border
		sta $d021		;background
		
		ldx #$00		;loop counter
loadimage:
		lda $3f40,x		;image is located here when the img was exported
		sta $0400,x		;screen memory
		lda $4040,x
		sta $0500,x
		lda $4140,x
		sta $0600,x
		lda $4240,x
		sta $0700,x
loadcolor:
		;lda $4328,x		;colour ram specified when the img was exported
		;sta $d800,x
		;lda $4428,x
		;sta $d900,x
		;lda $4528,x
		;sta $da00,x
		;lda $4628,x
		;sta $db00,x
		inx
		bne loadimage
		
		lda #$3b		;bitmap mode
		sta $d011
		
		lda #$18		;multi colour mode
		sta $d016
		
		lda #$18		;screen ram location
		sta $d018
		
loop:
		jmp loop
		
 org $1ffe
 INCBIN "dcc.prg"