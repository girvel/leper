[org 0x7c00]  ; Tell the assembler where this code will be loaded

; Clean the screen
mov ah, 0x00  ; Set video mode
mov al, 0x03  ; 80x25 text mode
int 0x10

cli
lgdt [gdt_descriptor]

mov eax, cr0
or eax, 0x1
mov cr0, eax

jmp 0x08:protected_mode

[bits 32]
protected_mode:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    mov esp, 0x9000

    mov edi, 0xB8000
    mov ah, 0x0F
    mov al, 'H'
    mov [edi], ax
    add edi, 2
    mov al, 'i'
    mov [edi], ax
    hlt

gdt_start:
    ; Null descriptor
    dd 0x00000000
    dd 0x00000000

    ; Code segment descriptor
    dw 0xFFFF      ; Limit (low)
    dw 0x0000      ; Base (low)
    db 0x00        ; Base (middle)
    db 0x9A        ; Access (executable, readable)
    db 0xCF        ; Flags (granularity, 32-bit)
    db 0x00        ; Base (high)

    ; Data segment descriptor
    dw 0xFFFF      ; Limit (low)
    dw 0x0000      ; Base (low)
    db 0x00        ; Base (middle)
    db 0x92        ; Access (writable)
    db 0xCF        ; Flags (granularity, 32-bit)
    db 0x00        ; Base (high)

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1  ; Limit
    dd gdt_start                ; Base
 
; mov ah, 0x0E  ; BIOS teletype function
; 
; mov al, 'L'
; int 0x10
; mov al, 'e'
; int 0x10
; mov al, 'p'
; int 0x10
; mov al, 'e'
; int 0x10
; mov al, 'r'
; int 0x10
; mov al, ' '
; int 0x10
; mov al, 'O'
; int 0x10
; mov al, 'S'
; int 0x10
; mov al, ' '
; int 0x10
; mov al, 'v'
; int 0x10
; mov al, '0'
; int 0x10
; mov al, '.'
; int 0x10
; mov al, '0'
; int 0x10
; mov al, '.'
; int 0x10
; mov al, '1'
; int 0x10

; mov ah, 0x02
; mov al, 5
; mov ch, 0
; mov cl, 2
; mov dh, 0
; mov dl, 0
; mov bx, 0x1000
; int 0x13
; jc disk_error
; jmp 0x1000
; 
; disk_error:
;     mov ah, 0x0E
;     mov al, '?'
;     int 0x10
;     hlt

times 510-($-$$) db 0  ; Fill the rest of the boot sector with zeros
dw 0xaa55  ; Boot signature
