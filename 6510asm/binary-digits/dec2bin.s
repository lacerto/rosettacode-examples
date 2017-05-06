; C64 - Binary digits
;       http://rosettacode.org/wiki/Binary_digits

; *** labels ***

declow		= $fb
dechigh		= $fc
binstrptr	= $fd ; $fe is used for the high byte of the address
getadr		= $b7f7
strout		= $ab1e

; *** main ***

		*=$033c		; sys828 tbuffer ($033c-$03fb)

		ldy #$05	; low byte
		lda #$00	; high byte
		jsr dec2bin
		lda #<binstr
		ldy #>binstr
		jsr strout
		rts

; *** subroutines ****

; Converts a 16 bit integer to a binary string.
; Input: y - low byte of the integer
;        a - high byte of the integer
; Output: a string stored at 'binstr'
dec2bin		sty declow
		sta dechigh
		lda #<binstr
		sta binstrptr
		lda #>binstr
		sta binstrptr+1
                ldx #$01
wordloop	ldy #$00
byteloop	asl declow,x
		bcs one
		lda #"0"
		bne writebit
one		lda #"1"		
writebit	sta (binstrptr),y
		iny
		cpy #$08
		bne byteloop
		clc
		lda #$08
		adc binstrptr	; todo: check overflow
		sta binstrptr
		dex
		bpl wordloop
		rts

; *** data ***

binstr		.repeat 17, $00	
