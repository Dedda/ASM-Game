section .data
	linebreak    db  10

	version_msg_pre       db  "Assembly Game v", 0
	version      db  "0.1.0a", 0	
	print_version_flag    db  "-v",0

global	_start
section	.text

extern print
extern print_newline
extern print_c_string

extern arrays_equal_zero_term

_start:
	pop r8
	dec r8
	pop rsi
next_arg:
	cmp r8, 0			; exit if no arguments left
	jz exit_group	
	dec r8
	pop rsi	
	push r8
	call check_print_version_flag
	pop r8	
	jmp next_arg

check_print_version_flag:		
	mov rdi, print_version_flag
	call arrays_equal_zero_term
	cmp rax, 0
	jz do_not_print_version
	call print_version
do_not_print_version:
	ret

exit_group:
	; exit(result)	
	mov	rdi, 0			; result
	mov	rax, EXIT_GROUP			; exit(2)
	syscall

print_version:	
	mov rdi, version_msg_pre	
	call print_c_string
	mov rdi, version
	call print_c_string
	call print_newline
	ret

; syscalls
EXIT_GROUP EQU 231