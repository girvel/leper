[org 0x7c00]  ; Tell the assembler where this code will be loaded

; Clean the screen
mov ah, 0x00  ; Set video mode
mov al, 0x03  ; 80x25 text mode
int 0x10

mov ah, 0x0E  ; BIOS teletype function

mov al, 'L'
int 0x10
mov al, 'e'
int 0x10
mov al, 'p'
int 0x10
mov al, 'e'
int 0x10
mov al, 'r'
int 0x10
mov al, ' '
int 0x10
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

mov ah, 0x02
mov al, 5
mov ch, 0
mov cl, 2
mov dh, 0
mov dl, 0
mov bx, 0x1000
int 0x13
jc disk_error
jmp 0x1000

disk_error:
    mov ah, 0x0E
    mov al, '?'
    int 0x10
    hlt

times 510-($-$$) db 0  ; Fill the rest of the boot sector with zeros
dw 0xaa55  ; Boot signature
