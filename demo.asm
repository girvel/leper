section .text
    mov si, helloworld_literal
    mov ah, 0x0E
    mov al, '!'
    int 0x10
    mov al, 13
    int 0x10
    mov al, 10
    int 0x10
    ret

section .data
    helloworld_literal db "Hello, world!", 0
