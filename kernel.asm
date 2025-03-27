[org 0x1000]

section .text
    mov ax, 0x1000
    mov ss, ax
    mov sp, 0x0500

    ; Clean the screen
    mov ah, 0x00  ; Set video mode
    mov al, 0x03  ; 80x25 text mode
    int 0x10

    mov si, version_string
    call writeln

    mov di, in_buffer
    mov cx, 16
    call readln

    mov si, in_buffer
    call writeln

end:
    hlt
    jmp end


writeln:
    call write
    mov al, 13
    int 0x10
    mov al, 10
    int 0x10
    ret


write:  ; si: string pointer
    mov ah, 0x0E  ; BIOS teletype function
.loop:
    lodsb
    test al, al
    jz .done
    int 0x10
    jmp .loop
.done:
    ret


readln:  ; di: string pointer, cx: length limit
.loop:
    test cx, cx
    jz .done

    mov ah, 0x00  ; BIOS blocking input function
    int 0x16

    mov ah, 0x0E  ; BIOS teletype function
    int 0x10

    cmp al, 13
    je .newline

    mov [di], al
    inc di
    dec cx

    jmp .loop

.newline:
    mov al, 10
    int 0x10
.done:
    mov byte [di], 0x00
    ret

section .data
    version_string db "Leper OS v0.0.1", 0
    in_buffer times 64 db 0
    in_length db 0

