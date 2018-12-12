 processor 6502
 org $1000
 
			lda #$00      ; Put the value 0 in accumulator
			sta $d020     ; Put value of acc in $d020
			;lda #$01
			;sta $d021     ; Put value of acc in $d021
			
chk_space:	lda $dc01 ;check keyboard
			cmp #$ef ;spacebar pressed?
			bne chk_space