 processor 6502
 org $1000
 
		lda #$ff		;turn all sprites on
		sta $d015		;sprite enable register
		
		lda #$01		;x location
		sta $d000		;x pos register
		lda #$01		;y pos
		sta $d001		;y position register
		
		rts