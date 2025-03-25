[org 0x7c00]  ; Tell the assembler where this code will be loaded

; Clean the screen
mov ah, 0x00  ; Set video mode
mov al, 0x03  ; 80x25 text mode
int 0x10

; Load the kernel into memory at 0x1000
mov ah, 0x02
mov al, 5
mov ch, 0
mov cl, 2
mov dh, 0
mov dl, 0
mov bx, 0x1000
int 0x13
jc disk_error

cli  ; Disable BIOS interrupts
lgdt [gdt_descriptor]  ; Load GDT

; Enable protected mode
mov eax, cr0
or eax, 0x1
mov cr0, eax

jmp 0x08:protected_mode

[bits 32]
protected_mode:
    ; Set up segment registers
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; Point stack to arbitrary address
    mov esp, 0x9000

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

disk_error:
    hlt

times 510-($-$$) db 0  ; Fill the rest of the boot sector with zeros
dw 0xaa55  ; Boot signature
