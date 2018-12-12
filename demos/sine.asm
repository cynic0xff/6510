 processor 6502;
 org $1000					;sys 4096
			
			lda #$01		;bit 1 on sprite 0,1,2
			sta $d015		;turn on sprite 0
			
			lda #$07		;sprite colour
			sta $d027		;make the sprite green
			
			;set up the sprite 0
			lda sine		;set the coordinate
			sta $d000		;set sprite 0 x location
			sta $d001		;set sprite 0 y initial position
			
			lda #$80		;set the pointer to memory location $2000
			sta $07f8		;our sprite data it stored in $2000
			
mainloop:	lda $d012		;load the raster beam location
			cmp #$01		;is the beam at location $ff
			bne mainloop	;if not then branch to mainloop
			
			lda dir			;load the direction we want to move the sprite
			beq down		;if the value in the accumulator (dir) is equal to down
			
			ldx sine		;load the coordinate value into x
			dex				;decrement the x register
			stx coord		;store the decremented x register value in coord
			stx $d001		;set sprite 0 y position
			cpx #$50		;compare the value in x to #$50
			bne mainloop	;if it is not equal then branch to mainloop
			
			lda #$00		;load 0 into register a which will change our direction
			sta dir			;store the value in the accumulator to variable dir
			jmp mainloop	;jump back to main loop
			
			ldx #$00		;point to the first index
			
down:		lda sine,x		;load sine + offset x into accumulator
				;store in x
			sta sine		;store coord in the x register
			sta $d001		;sprite 0 y location
			cpx #$e0		;compare the value in the x register to $e0
			bne mainloop	;if it is not equal then branch to the mainloop
			
			lda #$01		;set the direction to up
			sta dir			;store our direction in the accumulator
			jmp mainloop

coord .byte #$40		;x and y coordinate
dir	.byte #$0			;direction. 0=down 1=up

sine: .byte $20, $30, $40, $50

 org $2000
 INCBIN "cross.prg"