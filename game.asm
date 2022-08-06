section .data
	linebreak    db  10
	buff db 1

	version_msg_pre       db  "Assembly Game v"
	version_msg_pre_size  equ $ - version_msg_pre
	version      db  "0.1.0a"
	version_size equ $ - version
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
	call print_char
	call print_newline
	dec r8
	pop rsi
	mov rdi, rsi
	call print_c_string
	call print_newline	
	jmp next_arg

handle_arg:
	








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










	jmp exit_group
	jmp handle_args
args_handled:
	; ssize_t write(int fd, const void *buf, size_t count)
	mov	rsi, hello_world		; buffer
	mov	rdx, hello_world_size 	; count
	call print
	call print_version

exit_group:
	; exit(result)	
	mov	rdi, 0			; result
	mov	rax, EXIT_GROUP			; exit(2)
	syscall

handle_args:
	pop r8
	pop rsi
	mov rsi, r8
	jmp exit_group
handle_arg:	
	cmp r8, 0
	jz args_handled	
	pop rsi
	push r8
	; call check_print_version_flag	
	pop r8
	dec r8
	jmp handle_arg	

check_print_version_flag:
	push rdi
	push rsi	
	mov rdi, print_version_flag
	mov rsi, [rsi]
	call arrays_equal_zero_term
	cmp rax, 0
	jz do_not_print_version
	call print_version
do_not_print_version:
	pop rsi
	pop rdi
	ret

arrays_equal_zero_term:	
	mov r10, 0
arrays_equal_zero_term_loop:
	mov r8b, [rdi,r10]	
	mov r9b, [rsi,r10]
	inc r10
	cmp r8b, 0
	jz first_array_ended
	cmp r9b, 0
	jz arrays_are_not_equal	
	cmp r8b, r9b
	jne arrays_are_not_equal	
	jmp arrays_equal_zero_term_loop
first_array_ended:
	cmp r9b, 0
	jz arrays_are_equal
	jmp arrays_are_not_equal
arrays_are_equal:
	mov rax, 1
	ret
arrays_are_not_equal:
	xor rax, rax
	ret

print:
	mov	rdi, STDOUT			; fd
	mov	rax, SYS_WRITE		; write(2)
	syscall
	ret

print_char:
	mov [buff], rdi
	mov rsi, buff
	mov rdx, 1
	mov rdi, STDOUT
	mov rax, SYS_WRITE
	syscall 
	ret

print_newline:
	mov rsi, linebreak
	mov rdx, 1
	call print
	ret

print_version:	
	mov rsi, version_msg_pre
	mov rdx, version_msg_pre_size
	call print
	mov rsi, version
	mov rdx, version_size
	call print
	call print_newline
	ret

; file descriptors
STDIN EQU 0
STDOUT EQU 1

; syscalls
SYS_WRITE EQU 1
EXIT_GROUP EQU 231

; data
hello_world:	db "Hello World!",10
hello_world_size EQU $ - hello_world