    processor    6502
    org    $1000	
			
			ldx #$00
showms		lda msg,x
			sta $0400,x
			inx
			cpx #$28
			bne showms
			
;screen black
			lda #$00
			sta $d020
			sta $d021
			
			
irq			jsr colwash
			jmp irq

			
;==============================
;colour washing routine
;==============================
colwash		lda colour+$00
			sta colour+$28
			ldx #$00
cycle		lda colour+$01,x
			sta colour+00,x
			lda colour,x
			sta $d800,x
			inx
			cpx #$28
			bne cycle
			rts
			
;data tables for colours

colour: .byte $09,$09,$02,$02,$08
		.byte $08,$0a,$0a,$0f,$0f
		.byte $07,$07,$01,$01,$01
		.byte $01,$01,$01,$01,$01
		.byte $01,$01,$01,$01,$01
		.byte $01,$01,$01,$01,$01
		.byte $0f,$0f,$0a,$0a,$08
		.byte $08,$02,$02,$09,$09
		.byte $00,$00,$00,$00,$00
		
;data for text message
msg
	.byte "CYNIC OF THE BLACK ART CORPORATION"
	.byte 0