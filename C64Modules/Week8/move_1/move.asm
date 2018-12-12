 processor 6502
 org $0810					;sys 2064

			lda #$00
			tax				;reg x=0
			tay				;reg y=0
			jsr $1000		;initialise the music
			
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
			ldy #$7e		;line to trigger			
			sty $d012		
			
			lda $dc0d		;ack cia 1 interrupts
			lda $dd0d		;ack cia 2 interrupts
			asl $d019		;ack vic interrupts
			cli				;clear interrupt flag and enable to c64 interrupts
			
loop		rts				;return to c64 basic
int			jsr $1006		;play mzx
			jsr	drawlines
			asl $d019		;ack interrupt (to re enable it)
			jmp $ea31		;returns control back to the 64 interrupts
			
drawlines   ldx #$00
line1     	lda #$a0
			sta $0400,x
			lda #$02
			sta $d800,x
			inx
			cpx #$28 ;(Or use #40 instead)
			bne line1
initline2	ldx #$00			
line2     	lda #$0f
			sta $0429,x
			lda #$02
			sta $d829x
			inx
			cpx #$28 ;(Or use #40 instead)
			bne line2
			rts
			
 org $1000-$7e
 INCBIN "music.sid"