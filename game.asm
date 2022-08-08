%define green(a) 0x1B, "[32m", a, 0x1B, "[0m"
%define start_txt "start"
%define load_txt "load"
%define exit_txt "exit"

section .data
    ; Main menu
    _title_screen db "Main Menu:", 10, "  [", green(start_txt), "] Start New Game", 10, "  [", green(load_txt), "] Load Game", 10, "  [", green(exit_txt), "]  Exit Game", 10, "> ", 0
    _main_menu_start_text db start_txt, 10, 0
    _main_menu_load_text db load_txt, 10, 0
    _main_menu_exit_text db exit_txt, 10, 0
    _main_menu_data dq _main_menu_start_text, _main_menu_start, _main_menu_load_text, _main_menu_load, _main_menu_exit_text, _main_menu_exit, 0

    ; Game data
    _game_started db "Staring game...", 10, 0
    _loading_game db "Loading game...", 10, 0
    
    _game_menu_exit db "exit", 10, 0
    _game_menu_data dq _game_menu_exit, _game_done, 0
    ; Game state    
    _gs_reset db "A"
    _gs_size equ $-_gs_reset

global main_menu

; input.asm
extern read_line

; menu.asm
extern run_basic_menu
extern run_menu_with_meta_commands

; printing.asm
extern print_c_string
extern print_newline

; savegame.asm
extern load_game
extern save_game

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
_main_menu_load:
    mov rdi, _loading_game
    call print_c_string
    mov rdi, _gs_reset
    mov rsi, _gs_size
    call load_game
    cmp rax, 0    
    jz _error_on_load
    call _game
_error_on_load:
    jmp main_menu
_main_menu_exit:
    ret

_game:
    call print_newline
    mov rdi, _game_started
    call print_c_string
    call read_line
    mov rsi, rax
    mov rdi, _game_menu_data
    mov rdx, _gs_reset
    mov rcx, _gs_size
    call run_menu_with_meta_commands
    cmp rax, 0
    jz _game
    jmp rax
_game_done:
    ret