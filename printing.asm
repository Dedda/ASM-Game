section .data
	_linebreak    db  10

section .bss
	_char_print_buffer: resb 1

global print
global print_char
global print_newline
global print_c_string
global print_u64

section	.text

print:
	mov	rdi, STDOUT			; fd
	mov	rax, SYS_WRITE		; write(2)
	syscall
	ret

print_char:
	mov rdx, 1
	call print
	ret

print_newline:
	mov rsi, _linebreak
	call print_char
	ret

print_c_string:
	xor rax, rax	
	mov r11, rdi
_count_length:
	mov cl, [r11]
	cmp cl, 0
	jz _length_counted
	inc rax	
	inc r11
	jmp _count_length
_length_counted:
	mov rsi, rdi
	mov rdx, rax
	call print
	ret

print_u64:
	xor r8, r8
	xor r9, r9
	xor rdx, rdx
	mov rcx, 10
	mov rax, rdi
_next_digit:
	xor rdx, rdx
	div rcx
	and rdx, 0xFF
	add rdx, '0'
	inc r9
	shl r8, 8
	add r8, rdx
	cmp rax, 0
	jnz _next_digit
	shl r8, 8
	push r8
	mov r8, rsp
	inc r8
	mov rsi, r8
	mov rdx, r9
	call print
	pop r8
	ret

; file descriptors
STDOUT EQU 1

; syscalls
SYS_WRITE EQU 1