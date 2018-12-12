 processor   6502
 org    $1000

                 jsr $e544		;clear the screen routine
                 lda #$0d		;colour border
                 sta $d020		;border
                 lda #$05		;colour background
                 sta $d021		;background
                 
				 lda #$18       ;screen memory @ $2000
                 sta $d018		;d018 READ

                 ldx #$00		
write:      lda    msg,x
                 jsr    $ffd2   ;print char in acc to the screen 
                 inx
                 cpx    #54		;are we are 54 characters in length
                 bne    write

                 ldx #$00
setcolor:  lda #$01
                 sta $d800,x
                 inx
                 cpx #$54
                 bne setcolor
loop:        jmp loop

msg        .byte "C64 programming tutorial by digitalerr0r of Dark Codex"

    org    $1ffe
    INCBIN "scrap_writer_iii_17.64c"