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

scrollpos = $2700 		;this is where the
						;scrolltext will be
						;read from memory

scrreel = $0330			;the scroll control
pull	= $07c0			;$05e1	;left side of the scroller (end point)
put		= $07e6 		;0607	;right side of the scroll (start point)

         org $0900  	;DASM Users, use PROCESSOR 6502 and ORG $0900, 
						;KickAssembler users, use .PC $0900. SYS 2304

         sei			 ;disable system interrupts

         lda #<scrollpos ;initialise the message loading the address
         sta msg+1       ;of the scroller and storing in msg+1
         lda #>scrollpos ;so after each
         sta msg+2       ;run the
                         ;scrolltext
                         ;restarts at
                         ;$2700

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

         lda #<int				;the vector to jump to		
         sta $0314
         lda #>int				;the vector to jump to
         sta $0315
         lda #$00				;raster trigger
         sta $d012				;store raster trigger
         lda #$7f				;disable CIA1, CIA II interrupts
         sta $dc0d				;CIA 1
         sta $dd0d				;CIA 2
         lda #$01			
         sta $d019				;store 1 at cmp flag
         sta $d01a				;enable raster interrupts in $d019
         lda #$00				;set up the registers for the music routine
         tax					
         tay
         jsr $1000				;initialize music
         cli					;enable interrupts
         jmp *-1 				;this is different but
								;works well.

int      inc $d019				;inc $d019 which enables each of the bits in $d019

		 lda #$00   			;the colour black
         sta $d021  			;background colour
         sta $d020  			;background

	 
         lda #$e7				;the raster location (bottom of the screen)
raster1  cmp $d012  			;perform cut
         bne raster1			;branch not equal to $e7
         
		 jsr scroll 			;the scroll routine

         lda #$ff     			;set the raster split
raster2  cmp $d012    			;to the screen to
         bne raster2  			;make a still

         jsr $1003    			;play music
		 
				 
		 lda $dc01    			;read spacebar if
         cmp #$ef     			;not pressed
         bne main     			;then jump to main
								;prompt

         jmp $fce2    			;reset c64 / end demo
main     jmp $ea81				;return back control back to the system
								;ea81 doesnt scan the keyboard


;=======================================================================
; SCROLL TEXT
;=======================================================================
scroll   ldy #$00    			;
loop     dec scrreel 			; dec mem location
         lda scrreel 			; load into acc the mem location
         and #$07    			; shifts the screen over message using
         sta $d016   			; the screen x-pos
         cmp #$07    			; and counting 7
         bne control 			; times else jmp control

         ldx #$00
message  lda pull+1,x 			; get the next character
         sta pull,x 			; and store in the next screen location
         inx					;increment to the next location
         cpx #$28				;compare with the screen width as we do
								;not need to move any characters that are
								;not appearing

         bne message			;branch not equal to $28(40 base 10 - screen width)

msg      lda put   				;load the adress of the character
								;from memory address put

         cmp #$00    			;is '@' (wrap mark)
								;read? if not then
         bne end     			;jump to end prompt

         lda #<scrollpos 		;load the address of scrollpos
         sta msg+1       		;store in the next position
         jmp msg         		;jump msg

end      sta put 				;store current character on screen

         inc msg+1 				;increment msg+1 by
         lda msg+1 				;one character so
							    ;that it will read
							    ;the next character
							    ;for the message in
							    ;memory

         cmp #$00  				;is the reset counter
								;('@') marked? if not
								;then jump to control

         bne control

control  iny       				;next message counter

         cpy #$02  				;speed of our scroll
         bne loop
         rts
;=======================================================================
; IMAGE
;=======================================================================
loadimg		ldx #$00
getimg  lda $3f40,x
		sta $0400,x
		lda $4040,x
		sta $0500,x
		lda $4140,x
		sta $0600,x
		lda $4240,x
		sta $0700,x
colour	lda $4328,x
		sta $d800,x
		lda $4428,x
		sta $d900,x
		lda $4528,x
		sta $da00,x
		lda $4628,x
		sta $db00,x
		inx
		bne getimg
		
		;enter bitmap mode
		lda #$3b
		sta $d011
		
		;turn on multicolor mode
		lda #$16
		sta $d016
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
	
	org    $3ffe
	incbin "logo.prg"

;END
