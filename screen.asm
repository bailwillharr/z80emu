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
    ld a,$00
    ld hl,vRam
    ld bc,9600
    call _MemSet
    ret

scr_restore:
    call _ClrScrn
    ld a,lcdBpp16
    ld (mpLcdCtrl),a
    call _DrawStatusBar
    ret

