section .data

lbl_test_char_to_lowercase db "test_char_to_lowercase", 0
lbl_test_char_to_uppercase db "test_char_to_uppercase", 0

extern assert_equals_rdi_rsi

extern char_to_lowercase
extern char_to_uppercase

global test_char_to_lowercase
global lbl_test_char_to_lowercase

global test_char_to_uppercase
global lbl_test_char_to_uppercase

section .text

test_char_to_lowercase:
    xor rax, rax
    mov rdi, 'A'
    call char_to_lowercase
    mov rdi, 'a'
    mov rsi, rax
    call assert_equals_rdi_rsi
    ret

test_char_to_uppercase:
    xor rax, rax
    mov rdi, 'a'
    call char_to_uppercase
    mov rdi, 'A'
    mov rsi, rax
    call assert_equals_rdi_rsi
    ret