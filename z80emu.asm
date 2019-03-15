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
    .org userMem-2 ; Easy way to save 2 bytes.
    .db tExtTok,tAsm84CeCmp
Start:
    call _HomeUp
    call _ClrScrnFull
    call clear_vmem
    call __ClearVRam

    ; Clean up
    set graphDraw,(iy+graphFlags) ; Mark graph screen as dirty.
    ret

#include "memory.asm"

