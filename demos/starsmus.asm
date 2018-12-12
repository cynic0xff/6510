 processor 6502
 org $0900					;sys 2304 

sync = $0340
starpos = $0350

			sei				; set the interrupt disable (needed because we are manipulating the itnerrupt
			jsr $ff81 		; Clear the screen
			lda #$00  		; black border + screen
			sta $d020		
			sta $d021
			lda #$ff		
			sta $d015 		; turn on all sprites
			lda #$00  
			sta $d017 		; no sprite expansion X
			sta $d01b 		; sprites in front of chars
			sta $d01d 		; no sprite expansion Y
			
			ldx #$00
clr2000	    lda #$00		
			sta $3000,x 	; fill $2000 with zero
			inx
			bne clr2000
			
			lda #$01    	; create a dot for the sprite starfield
			sta $3000
			ldx #$00

setsprs	    lda #$c0    	; sprite object data from $2000-$2080
			sta $07f8,x		
			lda #$01    	; all sprites are white
			sta $d027,x
			inx
			cpx #$08    	; create the sprite creation 8 times
			bne setsprs
			
			ldx #$00
positions	lda postable,x 	;Read label postable
			sta starpos+0,x ;Create data memory for current sprite position
			inx
			cpx #$10
			bne positions
			
			
			lda #<irq 		;set the irq vector redirect
			sta $0314
			lda #>irq
			sta $0315
			lda #$00		
			sta $d012		;set the raster trigger
			lda #$7f		;disable cia interrupts & ack irq
			sta $dc0d		
			lda #$1b
			sta $d011
			lda #$01		;enable raster irq
			sta $d01a
			
			lda #$00
			jsr $1000		;initialize the mzx
			cli				;clear interrupt disable
			
setup_bmap:	lda #$3b		;set bitmap mode
			sta $d011		
			
			;set multicolor mode
			lda #$18
			sta $d016
			
			lda #$18
			sta $d018
			
			jsr initimage
			
mainloop	lda #$00 		;Synchronize the routines outside IRQ so that all routines run outside IRQ
			sta sync 		;correctly
			lda sync
waitsync	cmp sync
			bne cont
			jmp waitsync
cont		jsr expdpos     ;Call label xpdpos for sprite position x expansion
			jsr movestars   ;Call label movestars for virtual sprite movement
							;colour wash here
			
			jmp mainloop
			
expdpos	    ldx #$00
xpdloop	    lda starpos+1,x ;Read virtual memory from starpos (odd number values)
			sta $d001,x     ;Write memory to the actual sprite y position
			lda starpos+0,x ;Read virtual memory from starpos (odd number values)
			asl
			ror $d010 		;increase the screen limit for sprite x position
			sta $d000,x 	;Write memory to the actual sprite x position
			inx
			inx
			cpx #$10
			bne xpdloop
			rts
			
movestars   ldx #$00
moveloop	lda starpos+0,x ;Read from data table (starpos)
			clc
			adc starspeed+0,x
			sta starpos+0,x
			inx 			; Add 2 to each value of the loop
			inx 			;
			cpx #$10 		;Once reached 16 times rts else repeat moveloop
			bne moveloop
			rts
			
irq			inc $d019 		;You should also know this bit already
			lda #$00
			sta $d012
			lda #$01
			sta sync
			
			jsr $1003		;play music
			jmp $ea31
			
initimage	ldx #$00
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
			rts
			
msg	.byte "test colour wash message"

;Data tables for the sprite positions
                             ; x    y
postable	.byte $00,$38 	;We always keep x as zero, y is changeable
			.byte $01,$40
			.byte $02,$48
			.byte $03,$50
			.byte $04,$58
			.byte $05,$60
			.byte $06,$68
			.byte $07,$70
			.byte $08,$78
			
			
;Data tables for speed of the moving stars (erm dots)
                             ;x     y
starspeed	.byte $01,$00 	;Important. Remember that Y should always be zero. X is changable for
			.byte $01,$00 	;varied speeds of the moving stars. :)
			.byte $01,$00
			.byte $01,$00
			.byte $01,$00
			.byte $01,$00
			.byte $01,$00
			.byte $01,$00
			.byte $00,$00
			
;===========================================================
; binary data
;===========================================================
	org $1000-$7e
	incbin "poly.sid"
	
	org $1ffe
	INCBIN "cynic.prg"

