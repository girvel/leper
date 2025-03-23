; boot.asm
[org 0x7c00]        ; Tell the assembler where this code will be loaded

mov ah, 0x0e        ; BIOS teletype function
mov al, 'H'         ; Character to print
int 0x10            ; BIOS interrupt
mov al, 'e'
int 0x10
mov al, 'l'
int 0x10
int 0x10            ; Print 'l' again
mov al, 'o'
int 0x10
mov al, ','
int 0x10
mov al, ' '
int 0x10
mov al, 'W'
int 0x10
mov al, 'o'
int 0x10
mov al, 'r'
int 0x10
mov al, 'l'
int 0x10
mov al, 'd'
int 0x10
mov al, '!'
int 0x10

hlt                 ; Halt the CPU

times 510-($-$$) db 0 ; Fill the rest of the boot sector with zeros
dw 0xaa55           ; Boot signature
