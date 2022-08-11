section .data
    ; Meta commands
    _meta_menu_save_text db "save", 10, 0
    _meta_menu_save_text_short db "s", 10, 0
    _main_menu_inventory_text db "inventory", 10, 0
    _main_menu_inventory_text_short db "i", 10, 0
    _meta_menu_data dq _meta_menu_save_text, _meta_save, _meta_menu_save_text_short, _meta_save,
                    dq _main_menu_inventory_text, _meta_inventory, _main_menu_inventory_text_short, _meta_inventory
                    dq 0

    _item_count_name_divider db ' '

section .bss
    _inventory_cb: resq 1
    _gs_start: resq 1
    _gs_size: resq 1

global initialize_meta_menu
global run_basic_menu
global run_menu_with_meta_commands

; printing.asm
extern c_strings_equal_ci
extern print_u64
extern print_char
extern print_c_string
extern print_newline

; savegame.asm
extern save_game

section .text

initialize_meta_menu:     
    mov [_inventory_cb], rdi
    mov [_gs_start], rsi
    mov [_gs_size], rdx
    ret

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
    push rdx
    mov rdi, rcx    
    call c_strings_equal_ci
    pop rdx
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
    inc rsi
    mov rdi, _meta_menu_data    
    call run_basic_menu
    xor r14, r14
    cmp rax, 0
    jz _done
    jmp rax
_meta_save:
    mov rdi, [_gs_start]
    mov rsi, [_gs_size]
    call save_game
    jmp _done_meta
_meta_inventory:
    call _print_inventory
_done_meta:
    mov rax, r14    
    pop r14
    pop r13
    pop r12    
    ret

_print_inventory:    
    push r12
    push r13
    push r14
    xor r12, r12    ; counter for index in _item_inventory_names
_print_next_inventory_item:
    shl r12, 1    
    mov r14, [_inventory_cb]
    mov r13, [r14 + r12 * 8]                        ; address of item count
    cmp qword r13, 0                    ; end of printable item list detected
    jz _all_items_printed        
    shr r12, 1
    mov r13, [r13]
    inc r12
    cmp r13, 0
    jz _print_next_inventory_item
    dec r12
    shl r12, 1
    mov r14, [r14 + r12 * 8 + 8]    ; address of item singular name reference
    shr r12, 1
    cmp r13, 1
    je _singular_item
    add r14, 8                      ; add qword size to get plural name reference    
_singular_item:
    mov r14, [r14]                  ; item name address
    mov rdi, r13
    call print_u64
    mov rsi, _item_count_name_divider
    call print_char
    mov rdi, r14
    call print_c_string
    call print_newline
    inc r12    
    jmp _print_next_inventory_item
_all_items_printed:
    pop r14
    pop r13   
    pop r12
    ret
