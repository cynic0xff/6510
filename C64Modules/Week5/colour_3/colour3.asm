 processor 6502
 org $1000

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
                sta $0400,x  			;fill the screen with a space starting at $0400
                sta $0500,x				;the same here but start at $0500
				sta $0600,x				;and so on
				sta $06e8,x
				inx           			;x++
                bne clear_screen     	; did X turn to zero yet?
										; if not, continue with the loop
                rts           			; return from this subroutine

add_colour:		ldx #$0				;use x reg as a counter
loop_colour:	lda colour			;load the colour into acc
				ldy colour			;load the colour into the y reg
				iny					;y++
				sty colour			;store the value in y back into colour variable (cycle through the colours)
				sta $d800,x			;store it in colour ram
				sta $d900,x
				sta $da00,x
				sta $dae8,x
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