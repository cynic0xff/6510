    processor    6502
    org    $0810
        
	;increments the border colour until space bar has been pressed

                  SEI                             
MAINLOOP:          LDX #$00              ;Set 'X' as 0
LOOPX:             LDY #$00              ;Set 'Y' as 0
LOOPY:             INC colours,x            ;Flashy border
                  sta $d020
				  INY                         ;Increment Y
                  CPY #$27               ; Is 'Y' equal to #$77
                  BNE LOOPY         ; If not then Y=Y+1, goto LOOPY
                  INX                        ; Increment X
                  CPX #$08               ; Is 'X' equal to #$77
                  BNE LOOPX         ;If not then X=X+1, goto LOOPX
                  LDA $DC01           ;Load Spacebar command
                  CMP #$EF             ;Is spacebar pressed
                  BNE MAINLOOP ; If not then jump to the MAINLOOP prompt
                  RTS                         ; else END program operation
colours:
                        .BYTE $00,$06,$0E,$03
                        .BYTE $03,$0E,$06,$00 