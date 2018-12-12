 processor 6502
 org $0810					;sys 2064
 
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
			jsr colwash
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
			
;==========================================================
;colour WASHING ROUTINE 
;==========================================================  
colwash     LDA colour+$00 
                     STA colour+$28 
                     LDX #$00 
CYCLE                LDA colour+$01,X 
                     STA colour+$00,X 
                     LDA colour,X 
                     STA $D800,X 
                     INX 
                     CPX #$28 
                     BNE CYCLE 
                     RTS
					 
rev_wash	lda colour+$28
			sta colour+$00
			ldx #$28
rev_cycle	lda colour-$01,x
			sta colour+$00,x
			lda colour,x
			sta $d7ff,x
			dex
			bne rev_cycle
			rts
			
;===========================================================
; data
;===========================================================
msg	.byte "test colour wash message"

;data tables for colours
colour       .BYTE $09,$09,$02,$02,$08 
             .BYTE $08,$0A,$0A,$0F,$0F 
             .BYTE $07,$07,$01,$01,$01 
             .BYTE $01,$01,$01,$01,$01 
             .BYTE $01,$01,$01,$01,$01 
             .BYTE $01,$01,$01,$07,$07 
             .BYTE $0F,$0F,$0A,$0A,$08 
             .BYTE $08,$02,$02,$09,$09 
             .BYTE $00,$00,$00,$00,$00
			
;===========================================================
; binary data
;===========================================================
	org $1000-$7e
	incbin "style.sid"
	
	org $1ffe
	incbin "scrap_writer_iii_17.64c"
			
			