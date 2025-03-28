[org 0x1000]

section .text
    ; Set up stack
    mov ax, 0x1000
    mov ss, ax
    mov sp, 0x0500

    ; Set up syscalls
    mov word [0x0400], writeln

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

    mov di, in_buffer
    mov si, exit_literal
    mov cx, 256
    call string_cmp
    je .shell_end

    mov di, in_buffer
    mov si, time_literal
    mov cx, 256
    call string_cmp
    je .time

    mov di, in_buffer
    mov si, ls_literal
    mov cx, 256
    call string_cmp
    je .ls

    mov di, in_buffer
    mov si, demo_literal
    mov cx, 256
    call string_cmp
    je .demo

    mov si, unkown_command_error
    call writeln

    jmp .shell_loop

.echo:
    mov si, in_buffer + 5
    call writeln
    jmp .shell_loop

.time:  ; TODO maybe into separate files?
    mov ah, 0x02
    int 0x1A  ; get time

    mov bl, cl

    mov cl, ch
    call write_hex

    mov si, colon
    call write

    mov cl, bl
    call write_hex

    mov si, colon
    call write

    mov cl, dh
    call write_hex

    mov si, empty_line
    call writeln

    jmp .shell_loop

.ls:
    mov di, ls_buffer
    call read_file_table
    mov di, ls_buffer

.ls_loop:
    cmp word [di], 0
    je .ls_done

    mov cl, [di + 1]
    call write_hex

    mov cl, [di]
    call write_hex

    mov si, space_literal
    call write

    mov cl, [di + 3]
    call write_hex

    mov cl, [di + 2]
    call write_hex

    mov si, space_literal
    call write

    add di, 4
    mov si, di
    call writeln

    add di, 28

    jmp .ls_loop
.ls_done:
    jmp .shell_loop

.demo:
    mov di, ls_buffer
    call read_file_table

    mov di, ls_buffer
    mov si, demo_literal
    mov dx, 0x2000
    call read_file

    cmp dx, 0
    je .not_found
    call 0x2000
    jmp .shell_loop
.not_found:
    mov ah, 0x0E
    mov al, '!'
    int 0x10
    jmp .shell_loop

.shell_end:
    mov si, exit_message
    call writeln
end:
    hlt
    jmp end

%INCLUDE "stdlib.asm"
%INCLUDE "fs.asm"

section .data
    version_string db "Leper OS v0.0.1", 0
    shell_prompt db "> ", 0
    unkown_command_error db "Error: unknown command", 0
    echo_literal db "echo", 0
    exit_literal db "exit", 0
    time_literal db "time", 0
    ls_literal db "ls", 0
    demo_literal db "demo", 0
    exit_message db "Exited.", 0
    empty_line db "", 0
    colon db ":", 0
    space_literal db " ", 0
    
    in_buffer times 256 db 0
    ls_buffer times 512 db 0

