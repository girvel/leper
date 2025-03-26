[bits 64]
[org 0x10000]

start:
    ; Clear screen (write spaces)
    mov rdi, 0xB8000
    mov rax, 0x0F200F200F200F20 ; White-on-black spaces
    mov rcx, 500
    rep stosq

    ; Print message
    mov rdi, 0xB8000
    lea rsi, [rel msg]
    mov ah, 0x0F ; White on black

.print_loop:
    lodsb
    test al, al
    jz .done
    mov [rdi], ax
    add rdi, 2
    jmp .print_loop

.done:
    hlt
    jmp $

msg: db "Hello 64-bit World!", 0

; Pad to 5 sectors
times 2560-($-$$) db 0
