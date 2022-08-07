section .bss
    line_buffer: resb 1024

global read_line

section .text

read_line:
    mov rax, SYS_READ
    mov rdi, STDIN
    mov rsi, line_buffer
    mov rdx, 1024
    syscall
    mov rax, line_buffer
    ret

; file descriptors
STDIN EQU 0
STDOUT EQU 1

; syscalls
SYS_READ EQU 0