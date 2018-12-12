 processor 6502				;required to determine the processor type
 org $1000					;where in memory this program will be loaded
							;on the c64 screen enter sys 4096 and press return
							;to invoke the start of this program
  
			lda #$01		;white
			sta $d020		;main screen colour