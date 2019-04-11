; Author: Bailey Harrison (github.com/bailwillharr)
; File: z80emu.asm
; Program entry point. It sets up the virtual memory and initializes the
; emulated environment. This file will be assembled as Z80EMU.8xp.

; ti84pce.inc will not be used in later versions. Instead, equates will be
; explicitly defined.
.nolist
#include "inc/ti84pce.inc"
.list

; Since we are in 1 BPP mode, we have plenty of free vRam.
free_vram_start	.equ	vRam + 9600 ; 144kB
; Gives us 64K for the virtual address space.
vcpu_mem	.equ    $D50000

	.assume adl = 1
	.org userMem - 2
	.db tExtTok, tAsm84CeCmp
Start:
	di
	call _RunIndicOff
	call scr_setup_palette ; enter 1 BPP mode
	call scr_clr_screen
	call clear_vmem ; fill vmem with $00 (NOPs)
	ld a, $D5
	ld mb, a ; set the z80 address space to $D50000 to $D5FFFF

	; clean up
	ld a, $D0
	ld mb, a ; restore MBASE
	set graphDraw, (iy + graphFlags) ; mark graph screen as dirty
	call scr_restore
	ei
	ret

; subroutines
#include "memory.asm"
#include "screen.asm"

; data
#include "rom.asm"

