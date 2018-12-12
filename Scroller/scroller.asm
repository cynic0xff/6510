 processor 6502
 org $0900
;=======================================
;assemble it!
;
;intro programming

;=======================================



;=======================================

;call out some variables and positions
;for those variables

scrollpos = $2700 ;this is where the
                  ;scrolltext will be
                  ;read from memory

scrreel  = $0330;the scroll control
pull	 = $07c0	;$05e1	;left side of the scroller (end point)
put	= $07e6 ; 0607	;right side of the scroll (start point)

         org $0900 ;DASM Users, use PROCESSOR 6502 and ORG $0900, 
                  ;KickAssembler users, use .PC $0900.

         sei

         lda #<scrollpos ;initialise
         sta msg+1       ;the message
         lda #>scrollpos ;so after each
         sta msg+2       ;run the
                         ;scrolltext
                         ;restarts at
                         ;$2700

;you probably might already have known
;this part of the tutorial where we
;set up the charset and then blank the
;screen using - lda #$20 -, #$20
;represents spacebar.

         ;lda #$18   ;change charset
         ;sta $d018  ;to read from $2000

         ldx #$00    ;start of loop

clear    lda #$20    ;clear the screen
         sta $0400,x ;and fill with the
         sta $0500,x ;spacebar character
         sta $0600,x ;so that it all
         sta $06e8,x ;clears
         lda #$01
         sta $d800,x
         sta $d900,x
         sta $da00,x
         sta $dae8,x
         inx         ;count process 256
                     ;times. if not 256
                     ;then send the loop
         bne clear   ;to -clear- prompt

;set up the irq raster interrupt player
;routines

;since you already know how this section
;works, and we done this many times,
;there will be no need any explanation
;for this part of the code

         lda #<int
         sta $0314
         lda #>int
         sta $0315
         lda #$00
         sta $d012
         lda #$7f
         sta $dc0d
         sta $dd0d
         lda #$01
         sta $d019
         sta $d01a
         lda #$00
         tax
         tay
         jsr $1000
         cli
         jmp *-1 ;this is different but
                 ;works well.

int      inc $d019


;our raster screen cuts (do you remember
;these :))

	 
         lda #$e7	;@@@@@7C
raster1  cmp $d012  ; perform cut
         bne raster1
         lda #$00   ; screen is cut so
         sta $d021  ; we have a black;
		 lda #$01
         sta $d020  ; background and a
         jsr scroll ; nifty scroll text

;         lda #$fe    ;$90 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;raster1b cmp $d012    ; perform cut
;         bne raster1b ;

         lda #$ff     ; $a4 our final cut @@@@@@@@@@@@@@@@@@
raster2  cmp $d012    ; to the screen to
         bne raster2  ; make a still

         lda #$08     ; still screen
         sta $d016    ;

         jsr $1003    ;play music

         lda $dc01    ;read spacebar if
         cmp #$ef     ;not pressed
         bne main     ;then jump to main
                      ;prompt

         jmp $fce2    ;reset c64
main     jmp $ea31


;our scrolltext for the intro

scroll   ldy #$00    ; controlling the
loop     dec scrreel ; smoothness for
         lda scrreel ; our scrolltext
         and #$07    ; message using
         sta $d016   ; the screen x-pos
         cmp #$07    ; and counting 7
         bne control ; times else
                     ; move to the
                     ; control sequence

         ldx #$00
message  lda pull+1,x ; pull characters
         sta pull,x ; for the scroll
         ;lda $0609,x ; text
         ;sta $0608,x ;
         inx
         cpx #$28

         bne message

msg      lda put   ;check $0607 (the
                     ;very last char on
                     ;the middle line)

         cmp #$00    ;is '@' (wrap mark)
                     ;read? if not then
         bne end     ;jump to end prompt

         lda #<scrollpos ;reset msg+1
         sta msg+1       ;and msg+2 so
         ;lda #>scrollpos ;that the text
         ;sta msg+2       ;will restart
         jmp msg         ;then jump msg

end      sta put ;place character,
                   ;read from scrollpos
         ;ora #$40  ;calculate half cset
         ;sta $062f ;place other half of
                   ;cset at bottom

         inc msg+1 ;increment msg+1 by
         lda msg+1 ;one character so
                   ;that it will read
                   ;the next character
                   ;for the message in
                   ;memory

         cmp #$00  ;is the reset counter
                   ;('@') marked? if not
                   ;then jump to control

         bne control
         ;inc msg+2 ;do the same for the
control  iny       ;next message counter

         cpy #$02  ;speed of our scroll
         bne loop
         rts


;end!

;NOTE: DASM users, use incbin, ACME users use !BIN or !BINARY instead
	
;Insert music:
	org $1000-2
	incbin "music1000.prg"

;Insert 1x2 charset
	org $2000-2
	incbin "1x2charset.prg"

;Insert scrolltext data
	org $2700-2
	incbin "scrolltext.prg"

;END
