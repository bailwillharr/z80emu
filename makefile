default: z80emu.asm
	spasm -E -A z80emu.asm Z80EMU.8xp
list: z80emu.asm
	spasm -E -A -T z80emu.asm Z80EMU.8xp
travis: z80emu.asm
	./spasm -E -A z80emu.asm Z80EMU.8xp
.PHONY: clean
clean:
	-rm Z80EMU.8xp Z80EMU.lst
	clear
