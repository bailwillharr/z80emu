; Author: Bailey Harrison (github.com/bailwillharr)
; File: z80emu.asm
; Program entry point. It sets up the virtual memory and initializes the
; emulated environment. This file will be assembled as Z80EMU.8xp.

; ti84pce.inc will not be used in later versions. Instead, equates will be
; explicitly defined.
#include "inc/ti84pce.inc"

; Gives us $FFFF bytes of ram. Last byte is at pixelShadow+65535 inclusive.
vcpu_mem    .equ    pixelShadow
; 2 bytes for the virtual program counter.
vcpu_vpc    .equ    pixelShadow + 65536
	.assume adl = 1
	.org userMem - 2
	.db tExtTok, tAsm84CeCmp
Start:
	di
	call _RunIndicOff
	call scr_setup_palette
	call scr_clr_screen
	call clear_vmem
	ld hl, vcpu_vpc
	ld (hl), $0000
	; wait for enter key
_
	call _GetCSC
	cp skEnter
	jr nz, -_
	; clean up
	set graphDraw, (iy + graphFlags) ; mark graph screen as dirty
	call scr_restore
	ei
	ret
; subroutines
#include "memory.asm"
#include "screen.asm"

; data
#include "rom.asm"

