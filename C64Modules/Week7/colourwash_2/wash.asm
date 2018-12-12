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

			sei				;turn off interrupts
			lda #$7f		;%01111111
			ldx #$01
			sta $dc0d		;CIA 1 interrupt off
			sta $dd0d		;CIA 2 interrupt off
			stx $d01a		;turn on raster interrupts
			
			lda #$1b		;00011011
			sta $d011		;clear high bit in d012 which sets set text mode
			ldx #$08		;00001000
			stx $d016		;single colour mode
			ldy #$14		;00010100
			sty $d018		;screen at $0400, charset at $2000
			
			lda #<int		;low part of address of interrupt handler code
			ldx #>int		;high part of address of interrupt handler code
			sta $0314		
			stx $0315
			ldy #$80		;line to trigger			
			sty $d012		
			
			lda $dc0d		;ack cia 1 interrupts
			lda $dd0d		;ack cia 2 interrupts
			asl $d019		;ack vic interrupts
			cli				;clear interrupt flag and enable to c64 interrupts
			
loop		rts
int			jsr clear_screen
			;jsr add_colour
			asl $d019		;ack interrupt (to re enable it)
			jmp $ea31		;returns basic
			
			
;===============================================================;
; sub routines 													;
;===============================================================;

clear_screen    lda #$41     			;load #$a0 which is a filled character
                sta SCREENPOS1,x  		;fill the screen with a space starting at $0400
                sta SCREENPOS2,x		;the same here but start at $0500
				sta SCREENPOS3,x		;and so on
				sta SCREENPOS4,x
				inx           			;x++
                bne clear_screen     	; did X turn to zero yet?
										; if not, continue with the loop
                ;rts           			; return from this subroutine

add_colour:		ldx #$0				;use x reg as a counter
loop_colour:	lda colour			;load the colour into acc
				asl					;shift the bits in the acc to the left
				ldy colour			;load the colour into the y reg
				iny					;y++
				sty colour			;store the value in y back into colour variable (cycle through the colours)
				sta COLOURPOS1,x	;store it in colour ram
				sta COLOURPOS2,x
				sta COLOURPOS3,x
				sta COLOURPOS4,x
				inx
				bne loop_colour		;branch not equal to loop_colour
				rts
				
;our data
colour .byte $0