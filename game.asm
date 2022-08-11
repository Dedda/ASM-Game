%define green(a) 0x1B, "[32m", a, 0x1B, "[0m"
%define start_txt "start"
%define load_txt "load"
%define exit_txt "exit"

section .data
    ; Main menu
    _title_screen db "Main Menu:", 10, "  [", green(start_txt), "] Start New Game", 10, "  [", green(load_txt), "]  Load Game", 10, "  [", green(exit_txt), "]  Exit Game", 10, "> ", 0
    _main_menu_start_text db start_txt, 10, 0
    _main_menu_load_text db load_txt, 10, 0
    _main_menu_exit_text db exit_txt, 10, 0
    _main_menu_colon_q_text db ":q", 10, 0
    _main_menu_data dq _main_menu_start_text, _main_menu_start
                    dq _main_menu_load_text, _main_menu_load
                    dq _main_menu_exit_text, _main_menu_exit
                    dq _main_menu_colon_q_text, _main_menu_exit
                    dq 0

    ; Game data

    ; Messages
    _game_started db "Staring game...", 10, 0
    _loading_game db "Loading game...", 10, 0

    _give_fisherman_fish_for_bait_msg db "You trade 1 🐟 Fish for 1 🪱 Bait.", 10, 0
    _give_fisherman_fish_for_bait_no_fish_msg db "You don't have any 🐟 Fish to trade.", 10, 0

    _feed_bird_msg db "You feed the 🐦 Bird a 🪱 Worm. It is happy and flies away.", 10, 0
    _feed_bird_no_bait_msg db "You don't have anything to feed the 🐦 Bird.", 10, 0
    
    ; Menus
    _game_menu_exit db "exit", 10, 0
    _game_menu_data dq _game_menu_exit, _game_done, 0

    ; Rooms
    _rooms dq _room_docks, _room_harbor_district_plaza

    ; Inventory item names
    _item_count_name_divider db ' '
    _fish_name dq _fish_name_sg, _fish_name_sg
    _fish_name_sg db "🐟 Fish", 0
    _bait_name dq _bait_name_sg, _bait_name_sg
    _bait_name_sg db "🪱 Bait", 0
    _item_inventory_name_map dq _fish_count, _fish_name, _bait_count, _bait_name, 0    

    ; Game state    
    ; inventory
    _fish_count dq 1
    _bait_count dq 0
    ; triggers
    _fed_bird   db 0
    ; general
    _room       db 0
    _gs_size equ $-_fish_count    

global bootstrap_game

; input.asm
extern read_line

; menu.asm
extern initialize_meta_menu
extern run_basic_menu
extern run_menu_with_meta_commands

; printing.asm
extern print_c_string
extern print_newline

; savegame.asm
extern load_game

section .text

bootstrap_game:
    mov rdi, _item_inventory_name_map
    mov rsi, _fish_count
    mov rdx, _gs_size
    call initialize_meta_menu    
_main_menu:
    mov rdi, _title_screen
    call print_c_string
    call read_line
    mov rsi, rax    
    mov rdi, _main_menu_data
    call run_basic_menu
    cmp rax, 0
    jz _main_menu
    jmp rax
_main_menu_start:
    call _game
    jmp _main_menu
_main_menu_load:
    mov rdi, _loading_game
    call print_c_string
    mov rdi, _fish_count
    mov rsi, _gs_size
    call load_game
    cmp rax, 0    
    jz _error_on_load
    call _game
_error_on_load:
    jmp _main_menu
_main_menu_exit:
    ret

_game:
    call print_newline
    mov rdi, _game_started
    call print_c_string
    call read_line
    mov rsi, rax
    mov rdi, _game_menu_data
    call run_menu_with_meta_commands
    cmp rax, 0
    jz _game
    jmp rax
_game_done:
    ret

_give_fisherman_fish_for_bait:
    cmp qword [_fish_count], 0
    jz _cannot_give_fish
    dec qword [_fish_count]
    inc qword [_bait_count]    
    mov rsi, _give_fisherman_fish_for_bait_msg    
    call print_c_string
    ret
_cannot_give_fish:
    mov rsi, _give_fisherman_fish_for_bait_no_fish_msg
    call print_c_string
    ret

_feed_bird:
    cmp qword [_bait_count], 0
    jz _cannot_feed_bird
    dec qword [_bait_count]
    mov byte [_fed_bird], 1
    mov rsi, _feed_bird_msg
    call print_c_string
    ret
_cannot_feed_bird:
    mov rsi, _feed_bird_no_bait_msg
    call print_c_string
    ret

_room_docks:
    ret

_room_harbor_district_plaza:
    ret