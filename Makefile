run: build
	qemu-system-x86_64 -drive file=.build/disk.img,format=raw,if=floppy

build: .build .build/disk.img

.build:
	@mkdir -p .build

.build/boot.bin: boot.asm
	nasm -f bin -l .build/boot.lst -o $@ $<

.build/kernel.bin: kernel.asm
	nasm -f bin -o $@ $<

.build/disk.img: .build/boot.bin .build/kernel.bin
	dd if=/dev/zero of=$@ bs=512 count=2880
	dd if=.build/boot.bin of=$@ conv=notrunc
	dd if=.build/kernel.bin of=$@ bs=512 seek=1 conv=notrunc

.PHONY: build run
