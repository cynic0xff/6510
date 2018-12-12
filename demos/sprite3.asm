 processor 6502
 org $1000			;sys 2064
 
		lda #$03		;sprite 1
		sta $d015		;all sprites on
		
		lda #$80	;pointer to sprite data
		sta $07f8   ;store the acc value into thr sprite pointer
					;so the first sprite will find its data @ 07f8
		sta $07f9   ;2nd sprite pointing to memory $2000
		
		lda #$ff
		sta $d01c

		lda #$70			;x location
		sta $d000
		lda #$89			;y location
		sta $d001
		
		lda #$80			;sprite 2
		sta $d002
		lda $8a
		sta $d003			
		
		lda #$05			;sprite colour
		sta $d027
		
		lda #$02
		sta $d028
		
hold	lda $dc01			;read keyboard buffer
		cmp #$ef			;space bar
		bne hold			;jmp to hold
		rts
		
    org    $2000
	INCBIN "sprite1.spr"