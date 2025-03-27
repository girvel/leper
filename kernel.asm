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

    mov di, in_buffer
    mov si, exit_literal
    mov cx, 256
    call string_cmp
    je .shell_end

    mov si, unkown_command_error
    call writeln

    jmp .shell_loop

.echo:
    mov si, in_buffer + 5
    call writeln
    jmp .shell_loop

.shell_end:
    mov si, exit_message
    call writeln
end:
    hlt
    jmp end

%INCLUDE "stdlib.asm"

section .data
    version_string db "Leper OS v0.0.1", 0
    shell_prompt db "> ", 0
    unkown_command_error db "Error: unknown command", 0
    echo_literal db "echo", 0
    exit_literal db "exit", 0
    exit_message db "Exited.", 0
    
    in_buffer times 256 db 0

