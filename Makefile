run: build
	qemu-system-x86_64 -drive file=.build/disk.img,format=raw,if=floppy

build: .build .build/disk.img

.build:
	@mkdir -p .build

.build/boot.bin: boot.asm
	nasm -f bin -o $@ $<

.build/disk.img: .build/boot.bin
	dd if=/dev/zero of=$@ bs=512 count=2880
	dd if=$< of=$@ conv=notrunc

.PHONY: build run
