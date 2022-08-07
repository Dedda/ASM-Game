section .data
	_linebreak    db  10

global print
global print_newline
global print_c_string

section	.text

print:
	mov	rdi, STDOUT			; fd
	mov	rax, SYS_WRITE		; write(2)
	syscall
	ret


print_newline:
	mov rsi, _linebreak
	mov rdx, 1
	call print
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


; file descriptors
STDOUT EQU 1

; syscalls
SYS_WRITE EQU 1