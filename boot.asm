[org 0x7c00]  ; As I understand, a normal location for a bootloader

mov ah, 0x02
mov al, 4  ; N of sectors to load
mov ch, 0
mov cl, 3
mov dh, 0
mov dl, 0
mov bx, 0x1000  ; address to put kernel at
int 0x13
jc disk_error
jmp 0x1000

disk_error:
    mov ah, 0x0E
    mov al, '!'
    int 0x10
    hlt

times 510-($-$$) db 0  ; Fill the rest of the boot sector with zeros
dw 0xaa55  ; Boot signature
