 processor 6502
 org $0900
;=======================================
;assemble it!
;
;intro programming

;=======================================

;in this section, we are going to be
;creating a simple intro screen, which
;can do flashy effects and also play
;some cool music. we are also going
;be displaying a scrolling message that
;is more than 256 characters long. we
;will also be playing some music in the
;background

;hopefully this source will help you all
;understand how to code a simple intro
;with scrolltext. each bit of code is
;sort of detailed.

;=======================================

;call out some variables and positions
;for those variables

scrollpos = $2700 ;this is where the
                  ;scrolltext will be
                  ;read from memory

scrreel  = $0330;the scroll control

line1    = $2600  ;this is where we
line2    = $2620  ;have the 1 liner

flashdat1 = $2400
flashdat2 = $2500

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

         lda #$18   ;change charset
         sta $d018  ;to read from $2000

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

;setup the char ('@') for those lines,
;which the colours will wash across.

         ldx #$00    ;our loop
plot     lda #$00    ;
         sta $0400,x ;fill with '@' 240
         sta $06f8,x ;times at the top
         inx         ;and bottom portion
         cpx #$f0    ;of the screen
         bne plot

         ldx #$00    ;
linemesg lda line1,x ;copy the text from
         sta $0522,x ;$2600+ to $0522+
         ora #$40    ;read half charset
         sta $054a,x ;copy same text but
                     ;to $054a+

         lda line2,x ;copy the text from
         sta $068a,x ;$2620+ to $068a+
         ora #$40    ;read half charset
         sta $06b2,x ;copy same text but
                     ;to $06b2+

         inx         ;perform process 18
         cpx #$13    ;times else call
         bne linemesg;loop

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

;this is where we read all the flashing
;datas. this is something you may have
;already known in an earlier part of the
;assemble it tutorial. so no explanation
;or help required in this section.

         lda flashdat1+$00
         sta flashdat1+$50
         lda flashdat1+$80
         sta flashdat1+$d0
         lda flashdat2+$80
         sta flashdat2+$d0
         ldx #$00
scroll1  lda flashdat1+$01,x
         sta flashdat1+$00,x
         lda flashdat1+$81,x
         sta flashdat1+$80,x
         lda flashdat2+$81,x
         sta flashdat2+$80,x
         inx
         cpx #$50
         bne scroll1

         lda flashdat2+$50
         sta flashdat2+$00
         lda flashdat2+$00
         sta flashdat2+$01
         ldx #$50
scroll2  lda flashdat2+$00,x
         sta flashdat2+$01,x
         dex
         bne scroll2
         ldx #0
paint    lda flashdat1+$00,x
         sta $d800,x
         sta $d828,x
         sta $d850,x
         sta $d878,x
         sta $d8a0,x
         sta $d8c8,x
         sta $d8f0,x
         lda flashdat1+$80
         sta $d918,x
         sta $d940,x
         sta $da80,x
         sta $daa8,x
         inx
         cpx #40
         bne paint
         ldy #0
flash2   lda flashdat2+$00,y
         sta $dad0,y
         sta $daf8,y
         sta $db20,y
         sta $db48,y
         sta $db70,y
         sta $db98,y
         sta $dbc0,y
         iny
         cpy #40
         bne flash2

;our raster screen cuts (do you remember
;these :))

         lda #$7c
raster1  cmp $d012  ; perform cut
         bne raster1
         lda #$00   ; screen is cut so
         sta $d021  ; we have a black
         sta $d020  ; background and a
         jsr scroll ; nifty scroll text

         lda #$90     ;
raster1b cmp $d012    ; perform cut
         bne raster1b ;
         ldx #$0a     ; add timing so
time1    dex          ; that we kill the
         bne time1    ; flickering

         lda $2580    ; this time here,
         sta $d021    ; we have a
         sta $d020    ; flashing bar

         lda #$a4     ; our final cut
raster2  cmp $d012    ; to the screen to
         bne raster2  ; make a still
         ldx #$0a     ; screen with no
time2    dex          ; flashing bar,
         bne time2    ; and also keep
         lda #$00     ; that portion of
         sta $d021    ; the screen
         sta $d020    ; black!

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
message  lda $05e1,x ; pull characters
         sta $05e0,x ; for the scroll
         lda $0609,x ; text
         sta $0608,x ;
         inx
         cpx #$28

         bne message

msg      lda $0607   ;check $0607 (the
                     ;very last char on
                     ;the middle line)

         cmp #$00    ;is '@' (wrap mark)
                     ;read? if not then
         bne end     ;jump to end prompt

         lda #<scrollpos ;reset msg+1
         sta msg+1       ;and msg+2 so
         lda #>scrollpos ;that the text
         sta msg+2       ;will restart
         jmp msg         ;then jump msg

end      sta $0607 ;place character,
                   ;read from scrollpos
         ora #$40  ;calculate half cset
         sta $062f ;place other half of
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
         inc msg+2 ;do the same for the
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

	;Insert flashcolours data
	;org $2400-2
	;incbin "colours.prg"
	
;Insert 1-liner presentation text here
	
	org $2600-2
	incbin "1liner.prg"

;Insert scrolltext data
	org $2700-2
	incbin "scrollm1.prg"

;END
