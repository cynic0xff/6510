 processor 6502
 org $1000
	
		;set up the sprite
		lda #$80		;sprite location
		sta $07f8		;sprite 1
		lda #$01		;set bit 1
		sta $d015		;sprite 1 enabled
		
		lda #$21		;x location
move_x:		
		sta $d000	;store the value in the accumalator x
		sta $d001		;store y
		
check_key:
		jsr $ffe1		;get key
		beq end			;branch if equal
		jmp check_key
		
end:	rts

;when setting a memory location no space is allowed otherwise the dasm
;throws an error		
* = $2000
	INCBIN "sprite1.spr"