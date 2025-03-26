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
