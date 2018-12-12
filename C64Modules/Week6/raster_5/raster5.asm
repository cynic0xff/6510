 processor 6502
 org $1000
 
;screen positions
SCREENPOS1 = $0400 
SCREENPOS2 = $0500 
SCREENPOS3 = $0600 
SCREENPOS4 = $06e8
				
				sei				;turn off interrupts
main        	
clear_screen    lda #$01     			;load #$a0 which is a filled character
                sta SCREENPOS1,x  		;fill the screen with a space starting at $0400
                sta SCREENPOS2,x		;the same here but start at $0500
				sta SCREENPOS3,x		;and so on
				sta SCREENPOS4,x
				inx           			;x++
                bne clear_screen     	; did X turn to zero yet?
										; if not, continue with the loop

				;set up the raster split
				ldx #$00 		;the colour
				stx $d020 		;store the value in the acc
                stx $d021		;to both main and border
                
setup_raster1   ldx colour 		;the colour white
				ldy location 	;the raster location
				lda location
				iny
				sty location
raster1 		cmp $d012 		;are we there yet
                bne raster1 	;branch to split2 if not
                stx $d020 		;store the value in the acc
                stx $d021		;to both main and border
				
chk_space:		lda $dc01 		;check keyboard
				cmp #$ef 		;spacebar pressed?
				beq exit_space
				jmp main
exit_space	rts					;return control back to the c64 basic


;data
colour .byte $01
location .byte $00