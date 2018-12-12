 processor   6502  ;a space is required at the start of these lines
 org $1000			;due to a bug

loop: 	ldx #$20
		lda #$03
		sta $d000,x
		sta $d001,x
		jmp loop