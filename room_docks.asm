%define green(a) 0x1B, "[32m", a, 0x1B, "[0m"
%define look_around_txt "look"
%define exit_txt "exit"

section .data

    _msg_wake_up_at_docks db "You wake up naked at the docks. You seem to have lost all your belongings ", 10
                          db "except for a large 🐟 Fish in your right hand. You don't know where it ", 10
                          db "came from but at least it seems to be fresh."
                          db 10, 0

    _msg_room_menu db "  [", green(look_around_txt), "] Look around", 10
                   db "  [", green("give"), " (item) ", green("to"), " (recipient)] Give an item from your inventory", 10
                   db "  [", green(exit_txt), "] Leave the room (and this game)", 10, "> "
                   db 0

    _msg_look_around db "To your right, you see a fisherman. He looks desperate. Probably because he hasn't "
                     db "caught a single fish today.", 10
                     db "To your left is a gate that leeds out the docks. It doesn't appear to be locked but "
                     db "but it is guarded by a very angry looking 🐦 Bird."
                     db 10, 0

    _give_fisherman_fish_for_bait_msg db "You trade 1 🐟 Fish for 1 🪱 Bait.", 10, 0
    _give_fisherman_fish_for_bait_no_fish_msg db "You don't have any 🐟 Fish to give.", 10, 0
    _msg_give_bird_fish db "The 🐦 Bird does not want your 🐟 Fish.", 10, 0

    _feed_bird_msg db "You feed the 🐦 Bird a 🪱 Worm. It is happy and flies away.", 10, 0
    _feed_bird_no_bait_msg db "You don't have anything to feed the 🐦 Bird.", 10, 0    

    _menu_docks_look_around_text db "look", 10, 0
    _menu_give_fisherman_fish_text db "give fish to fisherman", 10, 0
    _menu_give_bird_fish_text db "give fish to bird", 10, 0
    _menu_give_bird_bait_text db "give bait to bird", 10, 0
    _menu_docks_exit_text db "exit", 10, 0
    _menu_docks_data dq _menu_docks_look_around_text, _look_around
                     dq _menu_give_fisherman_fish_text, _selected_give_fish_to_fisherman                     
                     dq _menu_give_bird_fish_text, _selected_give_fish_to_bird
                     dq _menu_give_bird_bait_text, _selected_give_bait_to_bird
                     dq _menu_docks_exit_text, _exit_docks
                     dq 0

global room_docks

; game.asm
extern room_offset_docks

; game_state.asm
extern fish_count
extern bait_count
extern fed_bird

; printing.asm
extern print_c_string
extern print_newline

; input.asm
extern read_line

; menu.asm
extern run_menu_with_meta_commands

section .text

room_docks:    
    mov rdi, _msg_wake_up_at_docks
    call print_c_string
    call print_newline
_room_docks:
    call _print_room_menu
    call read_line
    mov rsi, rax
    mov rdi, _menu_docks_data
    call run_menu_with_meta_commands
    cmp rax, 0
    jz _room_docks
    jmp rax
_look_around:
    mov rdi, _msg_look_around
    call print_c_string
    jmp _room_docks
_selected_give_fish_to_fisherman:
    call _give_fisherman_fish_for_bait
    jmp _room_docks
_selected_give_fish_to_bird:
    call _give_bird_fish
    jmp _room_docks
_selected_give_bait_to_bird:
    call _feed_bird
    jmp _room_docks
_exit_docks:
    mov rax, 0xFF
    ret

_print_room_menu:
    mov rdi, _msg_room_menu
    call print_c_string
    call print_newline
    ret

_give_fisherman_fish_for_bait:
    cmp qword [fish_count], 0
    jz _cannot_give_fish
    dec qword [fish_count]
    inc qword [bait_count]    
    mov rdi, _give_fisherman_fish_for_bait_msg    
    call print_c_string
    ret
_cannot_give_fish:
    mov rsi, _give_fisherman_fish_for_bait_no_fish_msg
    call print_c_string
    ret

_give_bird_fish:
    cmp qword [fish_count], 0
    jz _cannot_give_fish
    mov rdi, _msg_give_bird_fish
    call print_c_string
    ret

_feed_bird:
    cmp qword [bait_count], 0
    jz _cannot_feed_bird
    dec qword [bait_count]
    mov byte [fed_bird], 1
    mov rdi, _feed_bird_msg
    call print_c_string
    ret
_cannot_feed_bird:
    mov rdi, _feed_bird_no_bait_msg
    call print_c_string
    ret