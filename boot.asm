[org 0x7C00]
[bits 16]

start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    ; Load kernel to 0x10000 (1MB)
    mov ah, 0x02
    mov al, 5       ; Sectors to read
    mov ch, 0       ; Cylinder
    mov cl, 2       ; Sector
    mov dh, 0       ; Head
    mov dl, 0       ; Drive
    mov bx, 0x1000  ; ES:BX = 0x1000:0x0000 (0x10000)
    mov es, bx
    xor bx, bx
    int 0x13
    jc disk_error

    ; Switch to 32-bit
    cli
    lgdt [gdt32_desc]
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    jmp 0x08:protected_mode

[bits 32]
protected_mode:
    mov ax, 0x10
    mov ds, ax
    mov ss, ax
    mov esp, 0x90000

    ; Set up 64-bit paging
    call setup_paging

    ; Enable long mode
    mov ecx, 0xC0000080
    rdmsr
    or eax, 0x100
    wrmsr

    mov eax, cr0
    or eax, 0x80000000
    mov cr0, eax

    jmp 0x08:long_mode

setup_paging:
    mov edi, 0x1000
    mov cr3, edi
    xor eax, eax
    mov ecx, 4096
    rep stosd
    mov edi, 0x1000

    ; PML4
    mov dword [edi], 0x2003
    add edi, 0x1000
    ; PDP
    mov dword [edi], 0x3003
    add edi, 0x1000
    ; PD (2MB pages)
    mov dword [edi], 0x00000083
    mov dword [edi+8], 0x20000083
    ret

[bits 64]
long_mode:
    mov ax, 0
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    jmp 0x10000  ; Jump to kernel

disk_error:
    mov si, error_msg
    call print_string
    hlt

print_string:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp print_string
.done:
    ret

gdt32:
    dq 0
    dq 0x00CF9A000000FFFF ; Code
    dq 0x00CF92000000FFFF ; Data
gdt32_desc:
    dw gdt32_desc - gdt32 - 1
    dd gdt32

error_msg db "Disk error!", 0
times 510-($-$$) db 0
dw 0xAA55
