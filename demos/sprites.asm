 processor 6502;
 org $1000
 
			lda #$03		;bit 1 on
			sta $d015		;turn on sprite 0
			
			
			lda #$03
			sta $d027		;make the sprite white
			
			lda #$40		;set the coordinate
			sta $d000		;set the x coordinate
			sta $d001		;set the y coordinate
			sta $d002		;set sprite 2 location
			sta $d003
			
			lda #$80		;set the pointer
			sta $07f8		;our sprite data it stored in $2000

			lda #$90
			sta $07f9
			
mainloop:	lda $d012		;load the raster beam location
			cmp #$ff		;is the beam at location $ff
			bne mainloop	;if not then branch to mainloop
			
			lda dir			;load the direction we want to move the sprite
			beq down		;if the value in the accumulator (dir) is equal to down
			
			ldx coord		;load the coordinate value into x
			dex				;decrement the x register
			stx coord		;store the decremented x register value in coord
			stx $d000		;store the value in the x register into $d000 (our x coordinate)
			stx $d001		;store the value in the x register into $d001 (our y register)
			
			stx $d003		;sprite 2 y coord
			cpx #$50		;compare the value in x to #$40
			bne mainloop	;if it is not equal then branch to mainloop
			
			lda #$00		;load 0 into register a which will change our direction
			sta dir			;store the value in the accumulator to variable dir
			jmp mainloop	;jump back to main loop
			
down:
			ldx coord		;load our coord value into the x register
			inx				;increment x
			stx coord		;store coord in the x register
			stx $d000		;store the value in x to $d000 memoery location
			stx $d001
			
			stx $d003
			cpx #$e0		;compare the value in the x register to $e0
			bne mainloop	;if it is not equal then branch to the mainloop
			
			lda #$01		;set the direction to up
			sta dir			;store our direction in the accumulator
			jmp mainloop

coord .byte #$40		;x and y coordinate
dir	.byte #$0			;direction. 0=down 1=up

 org $2000
 INCBIN "cynic.prg"