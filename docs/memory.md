# Memory structure

## RAM

- 0x0000 - 0x03FF: BIOS interrupt vectors (whatever this is)
- 0x0400 - 0x04FF: empty
- 0x0500 - 0x1000: stack
- 0x1000+: kernel

## Floppy

- Sector #1: bootloader
- Sector #2: file table
- Sector #3+: kernel
