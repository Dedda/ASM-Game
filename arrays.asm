%define ascii_offset_lc_uc 0x20

global arrays_equal_zero_term
global c_strings_equal_ci
global char_to_lowercase

section	.text

arrays_equal_zero_term:
	xor r8, r8		; reset index counter
_check_at_index:
	mov r9b, [rdi, r8]		; read byte from index
	mov r10b, [rsi, r8]
	cmp r9b, r10b
	jne _arrays_are_not_equal
	cmp r9b, 0
	jz _arrays_are_equal
	inc r8
	jmp _check_at_index
_arrays_are_equal:
	mov rax, 1
	ret
_arrays_are_not_equal:
	mov rax, 0
	ret

c_strings_equal_ci:
    push r12
    xor r12, r12		; reset index counter
    mov r11, rdi        
_check_at_index_ci:    
	mov dil, [r11, r12]		; read byte from index    
    call char_to_lowercase
    mov r9b, al
	mov dil, [rsi, r12]        
    call char_to_lowercase
    mov r10b, al
	cmp r9b, r10b
	jne _arrays_are_not_equal_ci
	cmp r9b, 0
	jz _arrays_are_equal_ci
	inc r12
	jmp _check_at_index_ci
_arrays_are_equal_ci:
	mov rax, 1
    pop r12
	ret
_arrays_are_not_equal_ci:
	mov rax, 0
    pop r12
    ret

char_to_lowercase:
    mov r8b, dil
    cmp r8b, 'A'
    jl _already_lowercase
    cmp r8b, 'Z'
    jg _already_lowercase
    add dil, ascii_offset_lc_uc
_already_lowercase:
    mov al, dil
    ret