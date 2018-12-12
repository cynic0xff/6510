 processor 6502
 org $810
 
			lda #$00		;load $0 into the accumulator
			tax				;transfer the accumulator into the x register
			tay				;transfer the accumulator into the y register
			jsr $1000		;initialize music

			;write text to the screen
			jsr setup
			jsr displaymsg
			
mainloop:	lda $d012		;load the current position of the raster
			cmp #$38		;the raster trigger point on the screen
			bne mainloop	;if != $38 then mainloop
			jsr incborder
			jsr check_keys
			jsr colourwash
			jmp mainloop

;==================================================
; set up the screen
;==================================================
setup		lda #$00
			sta $d020
			sta $d021
			
			lda #$18		;$2000 character set
			sta $d018		;
			rts
;==================================================
; increment border
;==================================================			
incborder	inc $d020		;inc the border colour
			jsr $1006		;jump to the music play routine
			dec $d020		;dec the border colour
			rts

;==================================================
; colour wash routine
;==================================================
colourwash	lda colour+$00
			sta colour+$20
			lda #$00
cycle		lda colour+$01,x
			sta colour+$00,x
			lda colour,x
			sta $d800,x
			inx
			cpx #$22
			bne cycle
			rts
;==================================================
;check space bar
;==================================================
check_keys	lda $dc01		;read keyboard buffer
			cmp #$ef		;compare with space bar
			beq exit		;if equal then jmp exit
			rts
			
;==================================================
; write text to the screen
;==================================================			
displaymsg	ldx #$00
writemsg	lda message,x
			sta $0400,x
			inx
			cpx #$22
			bne writemsg
			rts

;==================================================
; exit
;==================================================
exit		brk				;exit to cbm os

;==================================================
; data
;==================================================
message
	.byte "CYNIC OF THE BLACK ART CORPORATION"
	.byte 0
	
colour  .byte $09,$09,$02,$02,$08
		.byte $08,$0a,$0a,$0f,$0f
		.byte $07,$07,$01,$01,$01
		.byte $01,$01,$01,$01,$01
		.byte $01,$01,$01,$01,$01
		.byte $01,$01,$01,$01,$01
		.byte $0f,$0f,$0a,$0a,$08
		.byte $08,$02,$02,$09,$09
		.byte $00,$00,$00,$00,$00

 org $1000-$7e
 INCBIN "music.sid"
 
 org $1ffe
 INCBIN "scrap_writer_iii_17.64c"