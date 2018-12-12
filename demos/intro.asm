 processor 6502
 org $0810						;sys 2064

							sei				;turn off interrupts
			lda #<irq		;interrupt vectors
			ldx #>irq
			sta $0314
			stx $0315
			
			lda #$31		;set the trigger position
			sta $d012		;of the raster line
			
			lda #$7f		;turn off CIA 1
			sta $dc0d		;dd0d = CIA 2
			
			lda #$1b
			sta $d011
			
			lda #$01		;acknowledge interrupt
			sta $d01a		;enable raster interrupts
			
			lda #$00
			
			jsr $e544		;clear screen
			jsr write_msg	;display message
			jsr $1000		;initialize the mzx
			
			cli				;enable interrupts
			
hold		jmp hold		;keep looping until interrupt occurs

irq			lda $d019		;which interrupt has been triggered
			and #$01		;and
			sta $d019		;store the interrupt
			lda #$31
			sta $d012		;raster trigger
			jsr $1003		;play music
			
			;jmp to another routine (RTS)
			;jsr colwash
			
				;lda #$00         	;load $00 into A
				;sta $d011       	 ;turn off screen. (now you have only borders!)
				sta $d020        	;make border black.
				 
				ldx #$00		  
				sty $3000		 	;store 0 into mem location $2000.  This will save the screen position

main     		ldy $3000         ;load $7a into Y. this is the line where our rasterbar will start.
				iny				;increment y
				sty $3000			;store the new updated value in y
				ldx #$00         ;load $00 into X

		
raster_trigger  lda colors,x     ;load value at label 'colors' plus x into a. if we don't add x, only the first 
								 ;value from our color-table will be read.

				cpy $d012        			;ComPare current value in Y with the current rasterposition.
				bne raster_trigger          ;is the value of Y not equal to current rasterposition? then jump back 3 bytes (to cpy).

				sta $d020        			;if it IS equal, store the current value of A (a color of our rasterbar)
											;into the bordercolour

				cpx #$33          			;compare X to #51 (decimal). have we had all lines of our bar yet?
				beq main         			;Branch if EQual. if yes, jump to main.

				inx              			;increase X. so now we're gonna read the next color out of the table.
				iny              			;increase Y. go to the next rasterline.

				cpy #$33
				bne main
				
				;jump to loop.
				jmp $ea73		;return control to c64
				
;==========================================================
; write a mssage to the screen
;==========================================================
write_msg 	ldx #$00
			lda #$18		;default point to $2000 charset
			sta $d018
write		lda msg,x
			jsr $ffd2
			inx
			cpx #$11
			bne write
			rts

;===========================================================
; data
;===========================================================
msg	.byte "test colour wash message"

colors
         .byte $06,$06,$06,$0e,$06,$0e
         .byte $0e,$06,$0e,$0e,$0e,$03
         .byte $0e,$03,$03,$0e,$03,$03
         .byte $03,$01,$03,$01,$01,$03
         .byte $01,$01,$01,$03,$01,$01
         .byte $03,$01,$03,$03,$03,$0e
         .byte $03,$03,$0e,$03,$0e,$0e
         .byte $0e,$06,$0e,$0e,$06,$0e
         .byte $06,$06,$06,$00,$00,$00
		 
;===========================================================
; binary data
;===========================================================
	org $1000-$7e
	incbin "style.sid"
	
	org $1ffe
	incbin "scrap_writer_iii_17.64c"