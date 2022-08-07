section .data
    _title_screen db "Assembly Game!", 10, 0
    _menu_item_start db "start", 10, 0
    _menu_item_exit db "exit", 10, 0  
    _game_started db "Yep!", 10, 0  

global main_menu

; arrays.asm
extern arrays_equal_zero_term

; input.asm
extern read_line

; printing.asm
extern print_c_string
extern print_newline

section .text

main_menu:
    mov rdi, _title_screen
    call print_c_string
    call read_line
    mov r12, rax
    mov rdi, r12
    mov rsi, _menu_item_exit
    call arrays_equal_zero_term
    cmp rax, 1
    je _menu_exit
    mov rdi, r12
    mov rsi, _menu_item_start
    call arrays_equal_zero_term
    cmp rax, 1
    jne main_menu
    call _game
    jmp main_menu
_menu_exit:
    ret

_game:
    mov rdi, _game_started
    call print_c_string
    ret