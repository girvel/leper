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

.shell_loop:
    mov si, shell_prompt
    call write

    mov di, in_buffer
    mov cx, 256
    call readln

    mov di, in_buffer
    mov si, echo_literal
    mov cx, 4
    call string_cmp
    je .echo

    mov si, unkown_command_error
    call writeln

    jmp .shell_loop

.echo:
    mov si, in_buffer + 5
    call writeln
    jmp .shell_loop

end:
    hlt
    jmp end


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

string_cmp:  ; di: first string, si: second string, cx: length
    .loop:
        mov al, [si]
        cmp [di], al
        jne .done

        cmp byte [di], 0
        je .done

        loop .loop

        cmp al, al
    .done:
        ret
    

section .data
    version_string db "Leper OS v0.0.1", 0
    shell_prompt db "> ", 0
    unkown_command_error db "Error: unknown command", 0
    echo_literal db "echo", 0
    in_buffer times 256 db 0

