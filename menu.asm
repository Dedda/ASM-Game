section .data
    ; Meta commands
    _meta_menu_save_text db "save", 10, 0    
    _meta_menu_data dq _meta_menu_save_text, _meta_save, 0

global run_basic_menu
global run_menu_with_meta_commands

; printing.asm
extern c_strings_equal_ci

; savegame.asm
extern save_game

section .text

run_basic_menu:     ; rdi -> menu data, rsi -> input data
    push r12
    push r13
    push r14
    mov r12, rdi
    xor r13, r13    ; entry counter
    xor r14, r14    ; return default
_next_entry:
    shl r13, 1
    mov rcx, [r12 + r13 * 8]     ; current entry text    
    mov rdx, [r12 + r13 * 8 + 8] ; current entry jump location    
    shr r13, 1
    inc r13
    cmp rcx, 0
    jz _done
    mov rdi, rcx    
    call c_strings_equal_ci
    cmp rax, 0
    jz _next_entry    
    mov r14, rdx
_done:
    mov rax, r14
    pop r14
    pop r13
    pop r12    
    ret

run_menu_with_meta_commands:
    push r12
    push r13
    push r14
    mov r12, rdi
    xor r13, r13    ; entry counter
    xor r14, r14    ; return default
    mov r8, rdx     ; savegame start in memory    
    mov r9, rcx     ; savegame size in memory
    cmp byte [rsi], ':'
    je _handle_meta
_next_entry_meta:
    shl r13, 1
    mov rcx, [r12 + r13 * 8]     ; current entry text    
    mov rdx, [r12 + r13 * 8 + 8] ; current entry jump location    
    shr r13, 1
    inc r13
    cmp rcx, 0
    jz _done
    mov rdi, rcx    
    call c_strings_equal_ci
    cmp rax, 0
    jz _next_entry    
    mov r14, rdx
    jmp _done_meta
_handle_meta:
    push r8
    push r9
    inc rsi
    mov rdi, _meta_menu_data    
    call run_basic_menu
    pop r9
    pop r8
    xor r14, r14
    cmp rax, 0
    jz _done
    jmp rax
_meta_save:
    mov rdi, r8
    mov rsi, r9
    call save_game
_done_meta:
    mov rax, r14    
    pop r14
    pop r13
    pop r12    
    ret
