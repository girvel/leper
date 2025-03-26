[org 0x1000]

; Clean the screen
mov ah, 0x00  ; Set video mode
mov al, 0x03  ; 80x25 text mode
int 0x10

mov ah, 0x0E  ; BIOS teletype function

mov si, version_string
output:
    lodsb
    test al, al
    jz done
    int 0x10
    jmp output

done:

hlt

version_string db "Leper OS v0.0.1", 0

