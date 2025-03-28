# Memory structure

## RAM

- 0x0000 - 0x03FF: BIOS interrupt vectors (whatever this is)
- 0x0400 - 0x04FF: syscalls
- 0x0500 - 0x1000: stack
- 0x1000 - 0x1FFF: kernel
- 0x2000+: dynamically loaded program

## Floppy

- Sector #1: bootloader
- Sector #2: file table
- Sector #3+: kernel
