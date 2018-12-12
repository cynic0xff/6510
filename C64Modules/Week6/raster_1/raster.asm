 processor 6502
 org $1000
 
main        	ldx #$00 		;the colour
                lda #$30 		;the ratser trigger location 
split1 			cmp $d012 		;are we there yet
                bne split1		;if not branch to split1
                stx $d020 		;store the value in the acc to main screen (the colour black)
                stx $d021		;store the value in the acc to border

                ldx #$01 		;the colour white
				lda #$a8 		;the raster location
split2 			cmp $d012 		;are we there yet
                bne split2 		;branch to split2 if not
                stx $d020 		;store the value in the acc
                stx $d021		;to both main and border
chk_space:		lda $dc01 			;check keyboard
				cmp #$ef 			;spacebar pressed?
				beq exit_space
				jmp main
exit_space	rts					;return control back to the c64 basic