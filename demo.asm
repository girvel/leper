[org 0x2000]

section .text
    mov si, helloworld_literal
    call [0x0400]
    ret

section .data
    helloworld_literal db "Hello, world!", 0
