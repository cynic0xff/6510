 processor 6502
 org $810
 
			lda #$00		;load $0 into the accumulator
			tax				;transfer the accumulator into the x register
			tay				;transfer the accumulator into the y register
			jsr $0fe8		;initialize music (Init Address)
	
mainloop:	lda $d012		;load the current position of the raster
			cmp #$38		;the raster trigger point on the screen
			bne mainloop	;if != $38 then mainloop
			
			inc $d020		;inc the border colour
			inc $d021
			jsr $1012		;jump to the music play routine (Play Address)
			dec $d020		;dec the border colour
			dec $d021
			
			jmp mainloop	;keep looping

 org $0fe8-$7e				;where in memory the tune is loaded (Load Address)
 INCBIN "warhawk.sid"