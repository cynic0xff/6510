 processor 6502
 org $1000 
 ;displaying text at bank #$03
 
 screenloc1 = $4000
 screenloc2 = $4100
 screenloc3 = $4200
 screenloc4 = $42e8
 screenloc1 = $0400
 screenloc2 = $0500
 screenloc3 = $0600
 screenloc4 = $06e8
 
			sei						;turn off interrupts
			ldx #$00;				;counters
display		lda screenloc1,x		;read from screen location screenloc1
			sta screenpos1,x
			lda screenloc2,x
			sta screenpos2,x
			lda screenloc3,x
			sta screenpos3,x
			lda screenloc4,x
			sta screenpos4,x		;until x == $ff
			inx
			
			bne display
 