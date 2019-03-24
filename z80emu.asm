; Author: Bailey Harrison (github.com/bailwillharr)
; File: z80emu.asm
; Program entry point. It sets up the virtual memory and initializes the
; emulated environment. This file will be assembled as Z80EMU.8xp.

; ti84pce.inc will not be used in later versions. Instead, equates will be
; explicitly defined.
#include "inc/ti84pce.inc"

; Gives us $FFFF bytes of ram. Last byte is at pixelShadow+65535 inclusive.
vcpu_mem    .equ    pixelShadow
; Two bytes for the virtual program counter.
vcpu_vpc    .equ    pixelShadow+65536

    .assume adl=1
    .org userMem-2 ; Easy way to save 2 bytes
    .db tExtTok,tAsm84CeCmp
Start:
    di
    call _RunIndicOff
    call scr_setup_palette
    call scr_clr_screen

    ; Initialize virtual environment
    call clear_vmem
    ld hl,vcpu_vpc
    ld (hl),$0000

    ld a,0
    ld l,0
    call scr_set_pixel
    call _GetKey
    ld a,1
    ld l,1
    call scr_set_pixel
    call _GetKey
    ld a,2
    ld l,2
    call scr_set_pixel
    call _GetKey
    ld a,3
    ld l,3
    call scr_set_pixel
    call _GetKey
    ld a,4
    ld l,4
    call scr_set_pixel

    ; Wait for enter key
_
    call _GetCSC
    cp skEnter
    jr nz,-_

    ; Clean up
    set graphDraw,(iy+graphFlags) ; Mark graph screen as dirty.
    call scr_restore

    ei
    ret

; Subroutines
#include "memory.asm"
#include "screen.asm"

; Everything after this line should be data.
#include "rom.asm"

