; C64 - Terminal control: Inverse Video

; *** labels ***

strout          = $ab1e

; *** main ***

                *=$02a8         ; sys 680
                
                lda #<str       ; Address of the message to print - low byte
                ldy #>str       ; Address high byte
                jsr strout      ; Print a null terminated string.
                rts    
                
; *** data ***

str             .byte $12       ; the REVERSE ON control code
                                ; see https://en.wikipedia.org/wiki/PETSCII
                .text "reversed"
                .byte $92       ; the REVERSE OFF control code
                .null " normal" ; null terminated string                
