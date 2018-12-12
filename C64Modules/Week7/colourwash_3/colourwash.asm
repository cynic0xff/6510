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
int			jsr colwash
			;jsr add_colour
			asl $d019		;ack interrupt (to re enable it)
			jmp $ea31		;returns basic
			
;routines
colwash    lda color+$00      ; load the current first color from table
           sta color+$28      ; store in in last position of table to reset
           ldx #$00           ; init X with zero
           sta $d9df,x        ; put the current color code into Color RAM position
 
cycle1     lda color+1,x      ; Start cycle by fetching next color in the table...
           sta color,x        ; ...and store it in the current active position.
           sta $d990,x        ; put into Color Ram
           inx                ; increment X-Register
           cpx #$28           ; have we done 40 iterations yet?
           bne cycle1         ; if no, continue
 
colwash2   lda color2+$28     ; load current last color from second table
           sta color2+$00     ; store in in first position of table to reset
           ldx #$28
cycle2     lda color2-1,x     ; fetch previous color from table...
           sta color2,x       ; ...and store it in the current active position.
           sta $d9df,x        ; put into Color Ram
           dex                ; decrease iterator
           bne cycle2         ; if x not zero yet, continue
 
           rts                ; return from subroutine
		   
;colour data
color        .byte $09,$09,$02,$02,$08 
             .byte $08,$0a,$0a,$0f,$0f 
             .byte $07,$07,$01,$01,$01 
             .byte $01,$01,$01,$01,$01 
             .byte $01,$01,$01,$01,$01 
             .byte $01,$01,$01,$07,$07 
             .byte $0f,$0f,$0a,$0a,$08 
             .byte $08,$02,$02,$09,$09 
 
color2       .byte $09,$09,$02,$02,$08 
             .byte $08,$0a,$0a,$0f,$0f 
             .byte $07,$07,$01,$01,$01 
             .byte $01,$01,$01,$01,$01 
             .byte $01,$01,$01,$01,$01 
             .byte $01,$01,$01,$07,$07 
             .byte $0f,$0f,$0a,$0a,$08 
             .byte $08,$02,$02,$09,$09 
