section .data
    _line_buffer_size db 0xFF

section .bss
    _line_buffer: resb 0xFF

global read_line

section .text

read_line:
    call _clear_buffer
    mov rax, SYS_READ
    mov rdi, STDIN
    mov rsi, _line_buffer
    mov rdx, _line_buffer_size
    syscall
    mov rax, _line_buffer
    ret

_clear_buffer:
    xor r8, r8   
_repeat:
    mov byte [_line_buffer + r8], 0
    inc r8    
    cmp r8, 0xFF
    jne _repeat
    ret

; file descriptors
STDIN EQU 0

; syscalls
SYS_READ EQU 0