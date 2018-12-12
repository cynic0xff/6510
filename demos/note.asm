 processor 6502
 org $0801								;sys 2048
 
chrout = $ffd2
getin	= $ffe4
 
			lda #$01
			sta $286
			lda #$93
			jsr chrout
			
			lda #$00
			sta $d020
			lda #$01
			sta $d021
 