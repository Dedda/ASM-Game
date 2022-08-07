section .data
    line_buffer_size db 0xFF

section .bss
    line_buffer: resb 0xFF

global read_line

section .text

read_line:
    call _clear_buffer
    mov rax, SYS_READ
    mov rdi, STDIN
    mov rsi, line_buffer
    mov rdx, line_buffer_size
    syscall
    mov rax, line_buffer
    ret

_clear_buffer:
    xor rax, rax
    xor r8, r8   
_repeat:
    mov r9, line_buffer
    mov byte [line_buffer + r8], 0
    inc r8    
    cmp r8, 0xFF
    jne _repeat
    ret

    
;    mov rax, 0
;    mov rsi, line_buffer
;    mov rdi, line_buffer
;    add rdi, line_buffer_size
;    rep stos
;    ret

; file descriptors
STDIN EQU 0

; syscalls
SYS_READ EQU 0