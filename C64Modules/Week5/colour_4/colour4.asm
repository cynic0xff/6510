 processor 6502
 org $1000
 
;SET UP PERAMETERS

;screen positions
SCREENPOS1 = $0400 
SCREENPOS2 = $0500 
SCREENPOS3 = $0600 
SCREENPOS4 = $06e8

;colour positions
COLOURPOS1 = $d800 
COLOURPOS2 = $d900 
COLOURPOS3 = $da00 
COLOURPOS4 = $da38

;===============================================================;
; main 															;
;===============================================================;
_start:
				jsr init_screen
				jsr clear_screen
				jsr add_colour
				jsr chk_space
_end:			rts
			
;===============================================================;
; sub routines 													;
;===============================================================;
init_screen:	ldx #$0			;use x reg as the counter
				rts

clear_screen    lda #$a0     			;load #$a0 which is a filled character
                sta SCREENPOS1,x  			;fill the screen with a space starting at $0400
                sta SCREENPOS2,x				;the same here but start at $0500
				sta SCREENPOS3,x				;and so on
				sta SCREENPOS4,x
				inx           			;x++
                bne clear_screen     	; did X turn to zero yet?
										; if not, continue with the loop
                rts           			; return from this subroutine

add_colour:		ldx #$0				;use x reg as a counter
loop_colour:	lda colour			;load the colour into acc
				ldy colour			;load the colour into the y reg
				iny					;y++
				sty colour			;store the value in y back into colour variable (cycle through the colours)
				sta COLOURPOS1,x			;store it in colour ram
				sta COLOURPOS2,x
				sta COLOURPOS3,x
				sta COLOURPOS4,x
				inx					;x++
				bne loop_colour		;branch not equal to loop_colour
				rts
				
chk_space:	lda $dc01 			;check keyboard
			cmp #$ef 			;spacebar pressed?
			beq exit_space	
			jmp chk_space		;keep checking space bar
exit_space:	rts					;return

;our data
colour .byte $0