 processor 6502
 org $1000

;===============================================================;
; main 															;
;===============================================================;
_start:
				jsr init_screen
				jsr clear_screen
				jsr disp_message
				jsr add_colour
				jsr chk_space
_end:			rts
			
;===============================================================;
; sub routines 													;
;===============================================================;
init_screen:	ldx #$0			;use x reg as the counter
				rts

clear_screen    lda #$20     			;load #$20 which is the space bar pet ascii code
                sta $0400,x  			;fill the screen with a space starting at $0400
                sta $0500,x				;the same here but start at $0500
				sta $0600,x				;and so on
				sta $06e8,x
				inx           			;x++
                bne clear_screen     	; did X turn to zero yet?
										; if not, continue with the loop
                rts           			; return from this subroutine

add_colour:		lda #$00				;load the colour black into the acc
				sta $d800				;store it in colour ram
				lda #$01				;load white into the acc
				sta $d801				;store it in the next colour ram position
				lda #$02				;load another colour
				sta $d802				;store it in the next location
				lda #$03
				sta $d803
				lda #$04
				sta $d804
				rts

disp_message:	ldx #$0
loop_message:	lda message,x	;load into the acc the message+x
				and #$3f		;and the accum
				sta $0400,x		;store the result in screen memory
				inx				;increment x
				cpx #$12		;compare to $0c (length of the string in bytes)
				bne loop_message;branch not equal to loop
				rts				;return control back to the commodore os
				
chk_space:	lda $dc01 			;check keyboard
			cmp #$ef 			;spacebar pressed?
			beq exit_space	
			jmp chk_space		;keep checking space bar
exit_space:	rts					;return

;our data
message	.byte "WWW.SUNTIMEBOX.COM"