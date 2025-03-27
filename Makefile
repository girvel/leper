run: build
	qemu-system-x86_64 -drive file=.build/disk.img,format=raw,if=floppy

build: .build .build/disk.img

.build:
	@mkdir -p .build

.build/boot.bin: boot.asm
	nasm -f bin -l .build/boot.lst -o $@ $<

.build/kernel.bin: kernel.asm stdlib.asm
	nasm -f bin -l .build/kernel.lst -o $@ $<

.build/file_table.bin: file_table.asm
	nasm -f bin -l .build/file_table.lst -o $@ $<

.build/demo.bin: demo.asm
	nasm -f bin -l .build/demo.lst -o $@ $<

.build/disk.img: .build/boot.bin .build/kernel.bin .build/file_table.bin .build/demo.bin
	dd if=/dev/zero of=$@ bs=512 count=2880
	dd if=.build/boot.bin of=$@ conv=notrunc
	dd if=.build/file_table.bin of=$@ bs=512 seek=1 conv=notrunc
	dd if=.build/kernel.bin of=$@ bs=512 seek=2 conv=notrunc
	dd if=.build/demo.bin of=$@ bs=512 seek=7 conv=notrunc

.PHONY: build run
