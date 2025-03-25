[bits 32]
mov edi, 0xB8000
mov ah, 0x0F
mov al, 'H'
mov [edi], ax
add edi, 2
mov al, 'i'
mov [edi], ax
hlt
