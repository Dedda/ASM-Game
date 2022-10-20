section .data
    _cls db 0x1B, "[2J", 0x1B, "[H", 0

global clear_screen

section .text

; printing.asm
extern print_c_string

clear_screen:
    mov rdi, _cls
    call print_c_string
    ret