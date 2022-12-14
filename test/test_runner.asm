section .data

    _label_start db "Running aunit tests", 10, 0
    _tests dq lbl_test_char_to_lowercase, test_char_to_lowercase
           dq lbl_test_char_to_uppercase, test_char_to_uppercase
           dq lbl_test_arrays_are_equal, test_arrays_are_equal
           dq lbl_test_c_strings_equal_ci, test_c_strings_equal_ci, 0

    _lbl_before_test db "  - ", 0
    _lbl_after_test_name db "...", 0
    _lbl_ok db "  [OK]", 10, 0
    _lbl_fail db "  [FAILURE]", 10, 0
    _lbl_success_counter db "tests successful: ", 0
    _lbl_failure_counter db "tests failed: ", 0

extern print_c_string
extern print_newline
extern print_u64

extern test_char_to_lowercase
extern lbl_test_char_to_lowercase

extern test_char_to_uppercase
extern lbl_test_char_to_uppercase

extern test_arrays_are_equal
extern lbl_test_arrays_are_equal

extern test_c_strings_equal_ci
extern lbl_test_c_strings_equal_ci

global _start

section .bss
    _success_counter: resq 1
    _failure_counter: resq 1

section .text

_start:
    mov qword [_success_counter], 0
    mov qword [_failure_counter], 0
    mov rdi, _label_start
    call print_c_string
    mov r8, _tests
_next_test:
    cmp qword [r8], 0
    jz _all_tests_run
    push r8
    mov rsi, [r8]
    mov rdi, [r8 + 8]
    call run_test
    pop r8
    add r8, 16
    jmp _next_test
_all_tests_run:
    call print_newline
    mov rdi, _lbl_success_counter
    call print_c_string
    mov rdi, [_success_counter]
    call print_u64
    call print_newline
    mov rdi, _lbl_failure_counter
    call print_c_string
    mov rdi, [_failure_counter]
    call print_u64
    call print_newline
    call exit_group

run_test:
    push rdi
    push rsi
    mov rdi, _lbl_before_test
    call print_c_string
    pop rdi
    call print_c_string
    mov rdi, _lbl_after_test_name
    call print_c_string
    pop rdi
    call rdi
    cmp rax, 0
    jz _print_ok_lbl
    inc qword [_failure_counter]
    mov rdi, _lbl_fail
    call print_c_string
    ret
_print_ok_lbl:
    inc qword [_success_counter]
    mov rdi, _lbl_ok
    call print_c_string
    ret

exit_group:
	mov	rdi, 0					; result
	mov	rax, EXIT_GROUP			; exit(2)
	syscall

; syscalls
EXIT_GROUP EQU 231