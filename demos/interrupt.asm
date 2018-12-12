 processor 6502
 org $1000
 ;interrupts

			sei				;turn off interrupts
			lda #$7f
			ldx #$01
			sta $dc0d		;CIA 1 interrupt off
			sta $dd0d		;CIA 2 interrupt off
			stx $d01a		;turn on raster interrupts
			
			lda #$1b
			ldx #$08
			ldy #$14
			sta $d011		;clear high bit in d012m set text mode
			stx $d016		;single colour mode
			sty $d018		;screen at $0400, charset at $2000
			
			lda #<int		;low part of address of interrupt handler code
			ldx #>int		;high part of address of interrupt handler code
			ldy #$80		;line to trigger
			sta $0314
			stx $0315
			sty $d012
			
			lda $dc0d		;ack cia 1 interrupts
			lda $dd0d		;ack cia 2 interrupts
			asl $d019		;ack vic interrupts
			cli				;clear the interrupts and let the c64 take care of its interrupts
			
loop		rts
int			inc $d020		;flash border
			asl $d019		;ack interrupt (to re enable it)
			jmp $ea31		;returns basic