read_file_table:  ; puts file table at di
    mov ah, 0x02
    mov al, 1
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, 0
    mov bx, di
    int 0x13
    ret

read_file:  ; di points to file table, si points to file name, puts result at dx
    mov ax, [di]
    sub ax, 2
    mov cx, 16
    push dx
    mul cx
    pop dx
    mov cx, ax

    add di, 4

.loop:
    push cx
    mov cx, 28
    call string_cmp
    pop cx
    je .eq
    add di, 32
    loop .loop

    mov dx, 0x0000
    ret
.eq:
    push dx
    mov ah, 0x02
    mov al, [di - 2]
    mov ch, 0
    mov cl, [di - 4]
    mov bx, dx
    mov dh, 0
    mov dl, 0x00
    int 0x13
    pop dx

    ret
