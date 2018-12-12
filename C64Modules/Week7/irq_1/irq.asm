 processor 6502
 org $1000
 ;interrupts

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
int			inc $d020		;flash border
			asl $d019		;ack interrupt (to re enable it)
			jmp $ea31		;returns basic