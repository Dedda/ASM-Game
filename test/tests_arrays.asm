section .data

lbl_test_char_to_lowercase db "test_char_to_lowercase", 0
lbl_test_char_to_uppercase db "test_char_to_uppercase", 0
lbl_test_arrays_are_equal db "test_arrays_are_equal", 0
lbl_test_c_strings_equal_ci db "test_c_strings_equal_ci", 0

test_arrays_are_equal_array_1 db "test array should be equal", 0
test_arrays_are_equal_array_2 db "test array should be equal", 0

test_c_strings_equal_ci_string_1 db "Test String Should be Equal", 0
test_c_strings_equal_ci_string_2 db "tesT strinG shoulD be equaL", 0

extern assunit_assert_equals_rdi_rsi
extern arrays_equal_zero_term
extern c_strings_equal_ci

extern char_to_lowercase
extern char_to_uppercase

global test_char_to_lowercase
global lbl_test_char_to_lowercase

global test_char_to_uppercase
global lbl_test_char_to_uppercase

global test_arrays_are_equal
global lbl_test_arrays_are_equal

global test_c_strings_equal_ci
global lbl_test_c_strings_equal_ci

section .text

test_char_to_lowercase:
    xor rax, rax
    mov rdi, 'A'
    call char_to_lowercase
    mov rdi, 'a'
    mov rsi, rax
    call assunit_assert_equals_rdi_rsi
    ret

test_char_to_uppercase:
    xor rax, rax
    mov rdi, 'a'
    call char_to_uppercase
    mov rdi, 'A'
    mov rsi, rax
    call assunit_assert_equals_rdi_rsi
    ret

test_arrays_are_equal:
    xor rax, rax
    mov rdi, test_arrays_are_equal_array_1
    mov rsi, test_arrays_are_equal_array_2
    call arrays_equal_zero_term
    cmp rax, 1
    je _test_arrays_are_equal_ok
    mov rax, 1
    ret
_test_arrays_are_equal_ok:
    xor rax, rax
    ret

test_c_strings_equal_ci:
    xor rax, rax
    mov rdi, test_c_strings_equal_ci_string_1
    mov rsi, test_c_strings_equal_ci_string_2
    call c_strings_equal_ci
    cmp rax, 1
    je _test_c_strings_equal_ci_ok
    mov rax, 1
    ret
_test_c_strings_equal_ci_ok:
    xor rax, rax
    ret