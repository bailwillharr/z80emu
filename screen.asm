; Author: Bailey Harrison (github.com/bailwillharr)
; File: screen.asm
; This file contains routines relating to the emulated screen.

; Set up the screen in 1 BPP mode and set the colours.
scr_setup_palette:
	ld hl, $CA8F
	ld (mpLcdPalette + 0) ,hl
	ld hl, $0000
	ld (mpLcdPalette + 2), hl
	ld a, lcdBpp1
	ld (mpLcdCtrl), a
	ret

; Clear the screen in 1 BPP mode.
scr_clr_screen:
	ld a, $00
	ld hl, vRam
	ld bc, 9600
	call _MemSet
	ret

; Restore the screen for TI-OS operation.
scr_restore:
	call _ClrScrn
	ld a, lcdBpp16
	ld (mpLcdCtrl), a
	call _DrawStatusBar
	ret

; Return a pixel address and bitmask.
; Inputs: a = x; l = y.
; Outputs: hl = address; a = bitmask.
scr_get_pixel:
	ld h, 40
	mlt hl
	ld de, $000000
	ld e, a
	srl e
	srl e
	srl e
	add hl, de
	ld de, vRam
	add hl, de
	and a, 7
	ld b, a
	ld a, $01
	ret z
_
	rlca
	djnz -_
	ret

; Set a pixel on the screen
; Inputs: a = x; l = y.
scr_set_pixel:
	call scr_get_pixel
	or a, (hl)
	ld (hl), a
	ret

; Set a pixel at TI 83 scale.
; Inputs: a = x (scaled); l = y (scaled)
scr_set_pixel_scaled:
	; TODO
	; TI 83 Plus has a screen of 96x64
	; TI 84 Plus CE has a screen of 320x24
	; Color > Monochrome scale factor = 3.333... for x, 3.75 for y.
	; I will just leave it as a scale factor of 3 for now and center it.

