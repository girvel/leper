; boot.asm
[org 0x7c00]        ; Tell the assembler where this code will be loaded

mov ah, 0x0e        ; BIOS teletype function

mov al, 'O'
int 0x10
mov al, 'S'
int 0x10
mov al, ' '
int 0x10
mov al, 'v'
int 0x10
mov al, '0'
int 0x10
mov al, '.'
int 0x10
mov al, '0'
int 0x10
mov al, '.'
int 0x10
mov al, '1'
int 0x10
mov al, '1'
mov al, '1'
mov al, '1'
mov al, '1'
mov al, '1'
mov al, '1'

hlt                 ; Halt the CPU

times 510-($-$$) db 0 ; Fill the rest of the boot sector with zeros
dw 0xaa55           ; Boot signature
