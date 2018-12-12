 processor 6502				;required processor type
 org $1000					;sys 4096 to invoke
  
			lda $21			;put the value $21 into the accumalator which happens
							;to be a '@' symbol
stay:		sta $0400		;store the value that is contained in the accumulator
							;and store it in the memory location $0400.
			jmp stay