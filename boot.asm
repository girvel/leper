[org 0x7C00]
[bits 16]

start:
    ; Set up stack
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    ; Load kernel sectors (2-6) to 0x10000 (1MB)
    mov ah, 0x02    ; BIOS read sectors
    mov al, 5       ; Number of sectors to read
    mov ch, 0       ; Cylinder 0
    mov cl, 2       ; Starting sector (2)
    mov dh, 0       ; Head 0
    mov dl, 0       ; Drive 0 (floppy)
    mov bx, 0x1000  ; ES:BX = 0x0000:0x1000 (0x10000)
    mov es, bx
    xor bx, bx
    int 0x13
    jc disk_error

    ; Switch to protected mode
    cli
    lgdt [gdt32_desc]
    mov eax, cr0
    or eax, 1
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
    mov esp, 0x90000

    ; Set up PAE and page tables
    call setup_paging

    ; Switch to long mode
    mov ecx, 0xC0000080  ; EFER MSR
    rdmsr
    or eax, 0x00000100   ; LME bit
    wrmsr

    mov eax, cr0
    or eax, 0x80000000   ; PG bit
    mov cr0, eax

    jmp 0x08:long_mode

setup_paging:
    ; Set up PML4, PDPT, PD tables
    mov edi, 0x70000     ; Physical address for PML4
    mov cr3, edi         ; Set CR3 while still in 32-bit mode

    ; Clear memory for page tables
    xor eax, eax
    mov ecx, 0x4000      ; 16KB (4 tables)
    rep stosd

    ; Set up PML4
    mov edi, 0x70000
    mov dword [edi], 0x71003  ; Point to PDPT (present + writable)

    ; Set up PDPT
    mov edi, 0x71000
    mov dword [edi], 0x72003  ; Point to PD (present + writable)

    ; Set up PD (identity map first 2MB using 2MB pages)
    mov edi, 0x72000
    mov dword [edi], 0x00000083  ; First 2MB (present + writable + huge page)
    mov dword [edi+8], 0x200083  ; Next 2MB (present + writable + huge page)

    ret

[bits 64]
long_mode:
    ; Clear segment registers
    mov ax, 0
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; Jump to 64-bit kernel at 1MB
    jmp 0x10000

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

; 32-bit GDT
gdt32:
    dq 0x0000000000000000  ; Null descriptor
    dq 0x00CF9A000000FFFF  ; Code segment (0x08)
    dq 0x00CF92000000FFFF  ; Data segment (0x10)
gdt32_desc:
    dw gdt32_desc - gdt32 - 1
    dd gdt32

error_msg db "Disk error!", 0

times 510-($-$$) db 0
dw 0xAA55
