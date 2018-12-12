 processor 6502
 org $1000
 
		lda #$80	;pointer to sprite data
		sta $07f8   ;store the acc value into thr sprite pointer
					;so the first sprite will find its data @ 07f8
		
		lda #$01	;turn on the sprite
		sta $d015	;sprite 1
		
		lda #$80
loopx	inx
		sta $d000	;store the value in the acc into $d000 (x)
		sta $d001
		
		cpx #$0f
		bne loopx
		;sta $d001	;store in the y location
hold	jmp hold
		

 org $2000
 INCBIN "sprite1.spr"