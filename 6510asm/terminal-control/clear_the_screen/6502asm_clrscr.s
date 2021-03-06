; 6502asm.com - Clear the screen

                lda #$00        ; store the start address of the screen ($200)
                sta $00         ; at $00 and $01 (high byte in $01)
                lda #$02
                sta $01
                
                ldy #$00        ; Y = 0
fillscreen:                
                lda $fe         ; A = random number from $fe
                sta ($00),y     ; put pixel (random color) to the screen
                iny             ; Y++
                bne fillscreen  ; loop if Y!=0
                inc $01         ; increase address high byte
                lda $01
                cmp #$06        ; A==6? (screen ends at $05ff)
                bne fillscreen  ; no -> loop
                
waitforkeypress:                
                lda $ff         ; $ff is 0 if no key has been pressed
                beq waitforkeypress
                
                ldx #$00
                lda #$00        ; black
clearscreen:
                sta $0200,x
                sta $0300,x
                sta $0400,x
                sta $0500,x
                inx
                bne clearscreen

