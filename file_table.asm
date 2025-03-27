; address: 2 bytes
; size: 2 bytes
; filename: 28 bytes

; the kernel
dw 3
dw 1
db "kernel.bin"
times 32 - ($-$$) db 0

; some demo file
dw 8
dw 1
db "demo"
times 2 * 32 - ($-$$) db 0
