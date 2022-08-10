%define red(a)   0x1B, "[91m", a, 0x1B, "[0m"

section .data	
	_version_msg_pre       db  "Assembly Game v", 0
	_version      db  "0.1.0a", 0	
	_print_version_flag    db  "-v",0
	_exit_message db red("BYE!"), 10, 0

global	_start
section	.text

; arrays.asm
extern arrays_equal_zero_term

; divive.asm
extern divide

; game.asm
extern main_menu

; printing.asm
extern print_newline
extern print_c_string

_start:
	pop r12
	dec r12
	pop rsi
_next_arg:
	cmp r12, 0			; exit if no arguments left
	jz _args_checked	
	dec r12
	pop rsi	
	push r12
	call _check_print_version_flag
	pop r12	
	jmp _next_arg
_args_checked:
	call main_menu
	mov rdi, _exit_message
	call print_c_string		
	jmp exit_group

_check_print_version_flag:		
	mov rdi, _print_version_flag
	call arrays_equal_zero_term
	cmp rax, 0
	jz _do_not_print_version
	call _print_version
_do_not_print_version:
	ret

_print_version:	
	mov rdi, _version_msg_pre	
	call print_c_string
	mov rdi, _version
	call print_c_string
	call print_newline
	ret

exit_group:
	mov	rdi, 0					; result
	mov	rax, EXIT_GROUP			; exit(2)
	syscall

; syscalls
EXIT_GROUP EQU 231