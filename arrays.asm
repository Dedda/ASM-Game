global arrays_equal_zero_term

section	.text

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