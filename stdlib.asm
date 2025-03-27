writeln:  ; si: string pointer
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

write_hex:  ; cl: number
    mov ah, 0x0E

    mov al, cl
    shr al, 4
    add al, '0'
    cmp al, '9'
    jbe .print_high
    add al, 7
.print_high:
    int 0x10

    mov al, cl
    and al, 0x0F
    add al, '0'
    cmp al, '9'
    jbe .print_low
    add al, 7
.print_low:
    int 0x10

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

    cmp al, 8
    je .backspace

    mov [di], al
    inc di
    dec cx

    jmp .loop

.backspace:
    test cx, cx
    jz .loop

    inc cx
    dec di

    mov al, ' '
    int 0x10

    mov al, 8
    int 0x10

    jmp .loop

.newline:
    mov al, 10
    int 0x10
.done:
    mov byte [di], 0x00
    ret


string_cmp:  ; di: first string, si: second string, cx: length
    .loop:
        mov al, [si]
        cmp [di], al
        jne .done

        cmp byte [di], 0
        je .done

        inc di
        inc si

        loop .loop

        cmp al, al
    .done:
        ret
