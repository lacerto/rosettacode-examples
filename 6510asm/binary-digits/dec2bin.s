; C64 - Binary digits
;       http://rosettacode.org/wiki/Binary_digits

; *** labels ***

declow      = $fb
dechigh     = $fc
binstrptr   = $fd               ; $fe is used for the high byte of the address
chkcom      = $aefd
frmnum      = $ad8a
getadr      = $b7f7
strout      = $ab1e

; *** main ***

            *=$033c             ; sys828 tbuffer ($033c-$03fb)

            jsr chkcom
            jsr frmnum
            jsr getadr
            jsr dec2bin
            lda #<binstr
            ldy #>binstr
            jsr skiplz
            jsr strout
            rts

; *** subroutines ****

; Converts a 16 bit integer to a binary string.
; Input: y - low byte of the integer
;        a - high byte of the integer
; Output: a string stored at 'binstr'
dec2bin     sty declow
            sta dechigh
            lda #<binstr
            sta binstrptr
            lda #>binstr
            sta binstrptr+1
            ldx #$01
wordloop    ldy #$00
byteloop    asl declow,x
            bcs one
            lda #"0"
            bne writebit
one         lda #"1"
writebit    sta (binstrptr),y
            iny
            cpy #$08
            bne byteloop
            clc
            lda #$08
            adc binstrptr
            sta binstrptr
            bcc nooverflow
            inc binstrptr+1
nooverflow  dex
            bpl wordloop
            rts

; Skip leading zeros.
; Input:  a - low byte of the byte string address
;         y - high byte -"-
; Output: a - low byte of string start without leading zeros
;         y - high byte -"-
skiplz      sta binstrptr
            sty binstrptr+1
            ldy #$00
skiploop    lda (binstrptr),y
            iny
            cpy #$11
            beq endreached
            cmp #"1"
            bne skiploop
            beq add2ptr
endreached  dey
add2ptr     clc
            dey
            tya
            adc binstrptr
            bcc loadhigh
            inc binstrptr+1
loadhigh    ldy binstrptr+1
            rts

; *** data ***

binstr      .repeat 17, $00