 processor   6502
 org    $1000
 
rasterwait1	lda $d012
			cmp #$0f

			lda $01
			sta $d020		;border
			sta $d021
			
rasterwait2	lda $d012
			cmp #$1f
			bne rasterwait2
			
			lda $0a
			sta $d020
			sta $d021
			
rasterwait3 lda $d012
			cmp #$2f
			bne rasterwait3
			
			lda $0b
			sta $d020
			sta $d021
			
			jmp rasterwait1