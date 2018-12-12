    processor    6502
    org    $0810
        
	;increments the border colour until space bar has been pressed

			sei		;clear req

loopx:		lda colours,x	;point to the colours + x
			sta $d020		;store in $d020, the border
			inx				;increment
			cpx #$08		;is the value in x == 8
			bne loopx

			ldy #$00
loopy:		lda colours2,y
			sta $d020
			iny
			cpy #$04
			bne loopy
			jmp loopy		;jump to loopx
			
			rts				;return
			
colours:       .BYTE $00,$06,$0E,$03
               .BYTE $03,$0E,$06,$00 
colours2:		.byte $01,$01,$01,$01