 processor 6502				;required processor type
 org $1000					;sys 4096 to invoke
  
			lda #$40		;put the value #$40 into the accumalator which happens
							;to be a '@' symbol
			sta $0400		;store the value that is contained in the accumulator
							;and store it in the memory location $0400.