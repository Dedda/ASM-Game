section .data
    _msg_registers_not_equal db "[ERROR] Registers not equal ", 0
    _msg_registers_not_equal_delim db ", ", 0
    _msg_registers_not_equal_end db ": ", 0
    _reg_rdi db "rdi", 0
    _reg_rsi db "rsi", 0

extern print_char
extern print_newline
extern print_c_string
extern print_u64

global assert_equals_rdi_rsi

section .text

assert_equals_rdi_rsi:
    cmp rdi, rsi
    je _assert_equals_rdi_rsi_equal
    push rsi
    push rdi
    mov rdi, _msg_registers_not_equal
    call print_c_string
    mov rdi, _reg_rdi
    call print_c_string
    mov rdi, _msg_registers_not_equal_delim
    call print_c_string
    mov rdi, _reg_rsi
    call print_c_string
    mov rdi, _msg_registers_not_equal_end
    call print_c_string
    pop rdi
    call print_u64
    mov rdi, _msg_registers_not_equal_delim
    call print_c_string
    pop rdi
    call print_u64
    call print_newline
    mov rax, 1
    ret
_assert_equals_rdi_rsi_equal:
    xor rax, rax
    ret
