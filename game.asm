%define green(a) 0x1B, "[32m", a, 0x1B, "[0m"
%define start_txt "start"
%define exit_txt "exit"

section .data
    ; Main menu
    _title_screen db "Assembly Game!", 10, "  [", green(start_txt), "] Start the Game", 10, "  [", green(exit_txt), "]  Exit the Game", 10, "> ", 0
    _main_menu_start_text db start_txt, 10, 0
    _main_menu_exit_text db exit_txt, 10, 0        
    _main_menu_data dq _main_menu_start_text, _main_menu_start, _main_menu_exit_text, _main_menu_exit, 0

    ; Game data
    _game_started db "Yep!", 10, 0
    ; Game state

global main_menu

; input.asm
extern read_line

; menu.asm
extern run_basic_menu

; printing.asm
extern print_c_string
extern print_newline

section .text

main_menu:
    mov rdi, _title_screen
    call print_c_string
    call read_line
    mov rsi, rax    
    mov rdi, _main_menu_data
    call run_basic_menu
    cmp rax, 0
    jz main_menu
    jmp rax
_main_menu_start:
    call _game
    jmp main_menu
_main_menu_exit:
    ret

_game:
    call print_newline
    mov rdi, _game_started
    call print_c_string
    ret