section .data
	linebreak    db  10

	version_msg_pre       db  "Assembly Game v", 0
	version      db  "0.1.0a", 0	
	print_version_flag    db  "-v",0

global	_start
section	.text

_start:
	pop r8
	dec r8
	pop rsi
next_arg:
	cmp r8, 0			; exit if no arguments left
	jz exit_group
	mov rdi, r8			; print number of remaining arguments
	and rdi, 0xFF
	add rdi, 0x30
	dec r8
	pop rsi
	mov rdi, rsi
	push r8
	call check_print_version_flag
	pop r8	
	jmp next_arg

check_print_version_flag:	
	mov rdi, rsi
	mov rsi, print_version_flag
	call arrays_equal_zero_term
	cmp rax, 0
	jz do_not_print_version
	call print_version
do_not_print_version:
	ret

arrays_equal_zero_term:
	xor r8, r8		; reset index counter
check_at_index:
	mov r9b, [rdi, r8]		; read byte from index
	mov r10b, [rsi, r8]
	cmp r9b, r10b
	jne arrays_are_not_equal
	cmp r9b, 0
	jz arrays_are_equal
	inc r8
	jmp check_at_index
arrays_are_equal:
	mov rax, 1
	ret
arrays_are_not_equal:
	mov rax, 0
	ret

print_c_string:
	xor rax, rax	
	mov r11, rdi
count_length:
	mov cl, [r11]
	cmp cl, 0
	jz length_counted
	inc rax	
	inc r11
	jmp count_length
length_counted:		
	mov rsi, rdi
	mov rdx, rax
	call print
	ret

exit_group:
	; exit(result)	
	mov	rdi, 0			; result
	mov	rax, EXIT_GROUP			; exit(2)
	syscall

print:
	mov	rdi, STDOUT			; fd
	mov	rax, SYS_WRITE		; write(2)
	syscall
	ret

print_newline:
	mov rsi, linebreak
	mov rdx, 1
	call print
	ret

print_version:	
	mov rdi, version_msg_pre	
	call print_c_string
	mov rdi, version
	call print_c_string
	call print_newline
	ret

; file descriptors
STDIN EQU 0
STDOUT EQU 1

; syscalls
SYS_WRITE EQU 1
EXIT_GROUP EQU 231