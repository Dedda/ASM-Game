section .data
	linebreak    db  10

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
	mov rsi, linebreak
	mov rdx, 1
	call print
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


; file descriptors
STDOUT EQU 1

; syscalls
SYS_WRITE EQU 1