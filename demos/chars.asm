 processor 6502
 org $1000
 
			jsr $e544		;clear the screen
			
			lda #$0d		;green
			sta $d020
			lda #$05
			sta $d021
			
			lda #$18	;screen/character memory is location at $0400
			sta $d018	;charset is at $2000
			
			ldx #$00	;clear x reg
write:		lda msg,x	;load our byte index location
			jsr $ffd2	;write the value in the accumulator to the screen
			inx			;increment x
			cpx #54		;bcoz our text is 54 characters long
			bne write	;if we are not equal then branch to write
			
			lda #$00
setcolor:	lda #$07	;set the colour of each characters
			sta $d800,x
			inx
			cpx #$54
			bne setcolor	;if the value is not equal to $54 then branch setcolor
			
loop:		jmp loop		;infinite loop

msg 		.byte "C64 programming tutorial by digitalerror of Dark Codex"

 org $1ffe							;the character set
 INCBIN "scrap_writer_iii_17.64c"