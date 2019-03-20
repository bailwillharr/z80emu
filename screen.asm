; Author: Bailey Harrison (github.com/bailwillharr)
; File: screen.asm
; This file contains routines relating to the emulated screen.
scr_setup_palette:
    ld hl,$CA8F
    ld (mpLcdPalette+0),hl
    ld hl,$FFFF
    ld (mpLcdPalette+2),hl
    ld a,lcdBpp1
    ld (mpLcdCtrl),a
    ret

scr_clr_screen:
    ; Loops 9600 times as each byte holds 8 pixels (it's in 1bpp mode).
    ld hl,vRam
    ld de,9600 ; 9600
_
    ld (hl),$00
    inc hl
    dec de
    ld a,d
    or a,e
    jp nz,-_
    ret

scr_restore:
    call _ClrScrn
    ld a,lcdBpp16
    ld (mpLcdCtrl),a
    call _DrawStatusBar
    ret

