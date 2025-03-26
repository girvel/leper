[org 0x1000]

mov ax, 0x1000
mov ss, ax
mov sp, 0x0500

; Clean the screen
mov ah, 0x00  ; Set video mode
mov al, 0x03  ; 80x25 text mode
int 0x10

mov ah, 0x0E  ; BIOS teletype function

push version_string
call print

end:
    hlt
    jmp end

print:
    pop si
    mov di, si
    pop si
    push di
.loop:
    lodsb
    test al, al
    jz .done
    int 0x10
    jmp .loop
.done:
    ret

version_string db "Leper OS v0.0.1", 10, 13, 0

