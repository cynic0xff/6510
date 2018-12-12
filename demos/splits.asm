 processor 6502
 org $0810						;sys 2064
 
			sei
            LDA #<irq
                LDX #>irq
                STA $0314 
                STX $0315 
                LDA #$31
                STA $D012 
                LDA #$7F 
                STA $DC0D 
                LDA #$1B
                STA $D011
                LDA #$01 
                STA $D01A
				lda #$00
				jsr $1000		;init the music
                CLI 
HOLD            JMP HOLD 

irq             LDA $D019
                AND #$01
                STA $D019
                LDA #$31
                STA $D012
				inc $0400		;increment the screen
				jsr flash		;jsr to flash
                jsr $1003		;play the music
                JMP $EA7E
				
flash			dec $d020		;flash border

				rts
	
	org $1000-$7e
	incbin "style.sid"