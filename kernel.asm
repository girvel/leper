[bits 64]
[org 0x10000]  ; Loaded at 1MB by bootloader

start:
    ; Set up video memory pointer
    mov rdi, 0xB8000  ; VGA text buffer address

    ; Clear screen (optional)
    mov rax, 0x0F200F200F200F20  ; Black background, white space chars
    mov rcx, 500                 ; Clear 500 words (80x25 screen / 2)
    rep stosq

    ; Print "Hello World!"
    mov rdi, 0xB8000  ; Reset to start of video memory
    
    ; Color attribute: white on black (0x0F)
    mov ah, 0x0F
    
    ; H
    mov al, 'H'
    mov [rdi], ax
    add rdi, 2
    
    ; e
    mov al, 'e'
    mov [rdi], ax
    add rdi, 2
    
    ; l
    mov al, 'l'
    mov [rdi], ax
    add rdi, 2
    
    ; l
    mov al, 'l'
    mov [rdi], ax
    add rdi, 2
    
    ; o
    mov al, 'o'
    mov [rdi], ax
    add rdi, 2
    
    ; Space
    mov al, ' '
    mov [rdi], ax
    add rdi, 2
    
    ; W
    mov al, 'W'
    mov [rdi], ax
    add rdi, 2
    
    ; o
    mov al, 'o'
    mov [rdi], ax
    add rdi, 2
    
    ; r
    mov al, 'r'
    mov [rdi], ax
    add rdi, 2
    
    ; l
    mov al, 'l'
    mov [rdi], ax
    add rdi, 2
    
    ; d
    mov al, 'd'
    mov [rdi], ax
    add rdi, 2
    
    ; !
    mov al, '!'
    mov [rdi], ax

    ; Infinite loop
    hlt
    jmp $

; Pad to 5 sectors (2.5KB)
times 2560 - ($ - $$) db 0
