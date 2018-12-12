 processor 6502
 org $1000
 
		lda $4710		;the background colour
		sta $d020		;set the border
		sta $d021		;set the main screen
		ldx #$00		;set x register to zero

loadimage:	lda $34f0,x
			sta $0400,x
			lda $4040,x
			sta $0500,x
			lda $4140,x
			sta $0600,x
			lda $4240,x
			sta $0700,x
			
			;we must also copy the color ram for our image which is located
			;at $4328 to $d800
			
			lda $4328,x
			sta $d800,x
			lda $4428,x
			sta $d900,x
			lda $4528,x
			sta $da00,x
			lda $4628,x
			sta $db00,x
			
			inx				;x++ reg until 0 flag is set
			bne loadimage
			
			;set bitmap mode
			lda #$3b
			sta $d011
			
			;set multicolor mode
			lda #$18
			sta $d016
			
			lda #$18
			sta $d018
			
loop:
			jmp loop

 org $1ffe
 INCBIN "cynic.prg"