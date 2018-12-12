 processor 6502
 org $810					;sys 2064 to run
 	
mainloop:	lda $d012		;load the current position of the raster
			cmp #$00		;the raster trigger point on the screen
			bne mainloop	;if != $38 then mainloop
			
			lda #$01		;set the colour to white
			sta $d020		;store the value in the accumulator ($01, the colour) into $d020 
			sta $d021		;store the value in the accumulator ($01, the colour) into $d021

raster1:	lda $d012
			cmp #$40
			bne raster1

			lda #$02		;change the colour
			sta $d020
			sta $d021	

raster2:	lda $d012
			cmp #$60
			bne raster2

			lda #$0		;change the colour
			sta $d020;
			sta $d021;

			jmp mainloop	;keep looping