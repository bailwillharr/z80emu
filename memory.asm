; Author: Bailey Harrison
; File: memory.asm
; This file contains the routines for managing the 64K of virtual
; memory (whatever the emulated CPU can address at once).
clear_vmem:
    ld hl,vcpu_mem
    ld a,0
_
    push af
    ld a,0
_
    ld (hl),$FF
    inc hl
    cp 255
    jp z,_
    inc a
    jp -_
_
    pop af
    cp 255
    jp z,_
    inc a
    jp ---_
_
    ret
