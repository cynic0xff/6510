 processor 6502
 org $1000
 
				sei				;turn off interrupts
main        	;set up the raster split
				ldx #$00 		;the colour
                lda #$10 		;the raster trigger location

				;set up raster split
                ldx #$01 		;the colour white
				lda #$30 		;the raster location
split1 			cmp $d012 		;are we there yet
                bne split1 		;branch to split2 if not
                stx $d020 		;store the value in the acc
                stx $d021		;to both main and border
	
				;set up next raster split
				ldx #$02
				lda #$40		;trigger location
split2			cmp $d012
				bne split2
				stx $d020
				stx $d021
				nop				;no operation
				nop
				nop
				nop
				nop
				nop
				nop
				nop
split3			ldx #$03
				lda #$50
				cmp $d012
				bne split3
				stx $d020
				stx $d021
				
chk_space:		lda $dc01 			;check keyboard
				cmp #$ef 			;spacebar pressed?
				beq exit_space
				jmp main
exit_space	rts					;return control back to the c64 basic