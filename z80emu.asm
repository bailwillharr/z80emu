; Author: Bailey Harrison (github.com/bailwillharr)
; File: z80emu.asm
; Program entry point. It sets up the virtual memory and initializes
; the emulated environment. This file will be assembled as Z80EMU.8xp.

; ti84pce.inc will not be used in later versions. Instead, equates will be
; explicitly defined.
#include "inc/ti84pce.inc"

; Gives us $FFFF bytes of ram. Last byte is at pixelShadow+65535 inclusive.
vcpu_mem    .equ    pixelShadow
; Two bytes for the virtual program counter.
vcpu_vpc    .equ    pixelShadow+65536
; The rest of the registers can be the eZ80's registers in Z80 mode.

    .assume adl=1
    .org userMem-2
    .db tExtTok,tAsm84CeCmp
    jp Start
    .db 1
    .db 16,16
    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    .db $FF,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$FF,$FF
    .db $FF,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$FF,$FF
    .db $FF,$FF,$00,$00,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$00,$00,$FF,$FF
    .db $FF,$FF,$00,$00,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$00,$00,$FF,$FF
    .db $FF,$FF,$00,$00,$FF,$FF,$00,$00,$00,$00,$FF,$FF,$00,$00,$FF,$FF
    .db $FF,$FF,$00,$00,$FF,$FF,$00,$00,$00,$00,$FF,$FF,$00,$00,$FF,$FF
    .db $FF,$FF,$00,$00,$FF,$FF,$00,$00,$00,$00,$FF,$FF,$00,$00,$FF,$FF
    .db $FF,$FF,$00,$00,$FF,$FF,$00,$00,$00,$00,$FF,$FF,$00,$00,$FF,$FF
    .db $FF,$FF,$00,$00,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$00,$00,$FF,$FF
    .db $FF,$FF,$00,$00,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$00,$00,$FF,$FF
    .db $FF,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$FF,$FF
    .db $FF,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$FF,$FF
    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
    .db "Z80Emu",0
Start:
    call _HomeUp
    call _ClrScrnFull
    ld a,$00
    ld (curCol),a
    ld (curRow),a

    ld hl,vcpu_mem
    ld a,0
ClearVMemLoop:
    push af

    ld a,0
ClearVMemLoop2:
    ld (hl),$00
    inc hl

    cp 255
    jr z,ClearVMemLoop2End
    inc a
    jr ClearVMemLoop2
ClearVMemLoop2End:

    pop af
    cp 255
    jr z,ClearVMemLoopEnd
    inc a
    jr ClearVMemLoop
ClearVMemLoopEnd:
    ld hl,string_VRamCleared
    call _PutS
    call _GetKey
    call _ClrScrnFull
    ret
string_VRamCleared:
    .db "Virtual Ram Cleared!",0
