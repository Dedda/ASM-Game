%define action(a) 0x1B, "[32m", a, 0x1B, "[0m"
%define item(a) 0x1B, "[94m", a, 0x1B, "[0m"
%define fish item("🐟 fish")
%define bird item("🐦 bird")
%define bait item("🪱 bait")
%define gate item("🚪 gate")
%define look_around_txt "look"
%define exit_txt "exit"

section .data

    _msg_wake_up_at_docks db "You wake up naked at the docks. You seem to have lost all your belongings ", 10
                          db "except for a large ", fish, " in your right hand. You don't know where it ", 10
                          db "came from but at least it seems to be fresh."
                          db 10, 0

    _msg_room_menu db "  [", action(look_around_txt), "] Look around", 10
                   db "  [", action("give"), " ", item("item"), " ", action("to"), " ", item("recipient"), "] Give an item from your inventory", 10
                   db "  [", action("enter"), " ", item("passage"), "] Go through a door etc.", 10
                   db "  [", action(exit_txt), "] Leave the room (and this game)", 10, "> "
                   db 0

    _msg_look_at_sad_fisherman   db "To your right, you see a ", item("🎣 fisherman"), ". He looks desperate. Probably because he hasn't "
                                 db "caught a single ", fish, " today.", 10, 0
    _msg_look_at_happy_fisherman db "To your right, you see a ", item("🎣 fisherman"), ". He looks happy with the big ", fish, " in his bucket."
                                 db 10, 0

    _msg_look_at_guarded_gate   db "To your left is a ", gate, " that leeds out the docks. It doesn't appear to be locked but "
                                db "but it is guarded by a very angry looking ", bird, "."
                                db 10, 0
    _msg_look_at_unguarded_gate db "To your left is a ", gate, " that leeds out the docks. It doesn't appear to be locked.", 10, 0

    _give_fisherman_fish_for_bait_msg         db "You trade 1 ", fish, " for 1 ", bait, ".", 10, 0
    _give_fisherman_fish_for_bait_no_fish_msg db "You don't have any ", fish, " to give.", 10, 0
    _msg_give_bird_fish                       db "The ", bird, " does not want your ", fish, ".", 10, 0

    _feed_bird_msg         db "You feed the ", bird, " your ", bait, ". It is happy and flies away.", 10, 0
    _feed_bird_no_bait_msg db "You don't have anything to feed the ", bird, ".", 10, 0

    _enter_gate_msg        db "You go through the ", gate, " and find yourself on a large plaza.", 10, 0
    _cannot_enter_gate_msg db "The ", gate, " is not locked but the angry ", bird, " scares you. "
                           db "You need to find a way to get rid of it."
                           db 10, 0

    _menu_docks_look_around_text   db look_around_txt, 10, 0
    _menu_give_fisherman_fish_text db "give fish to fisherman", 10, 0
    _menu_give_bird_fish_text      db "give fish to bird", 10, 0
    _menu_give_bird_bait_text      db "give bait to bird", 10, 0
    _menu_enter_gate_text          db "enter gate", 10, 0
    _menu_docks_exit_text          db exit_txt, 10, 0
    _menu_docks_data dq _menu_docks_look_around_text, _selected_look_around
                     dq _menu_give_fisherman_fish_text, _selected_give_fish_to_fisherman
                     dq _menu_give_bird_fish_text, _selected_give_fish_to_bird
                     dq _menu_give_bird_bait_text, _selected_give_bait_to_bird
                     dq _menu_enter_gate_text, _selected_enter_gate
                     dq _menu_docks_exit_text, _exit_docks
                     dq 0
    _invalid_input_msg db "🚫 You cannot do that", 10, 0

global room_docks

; game.asm
extern room_offset_docks
extern room_offset_harbor_plaza

; game_state.asm
extern fish_count
extern bait_count
extern fed_bird

; printing.asm
extern print_c_string
extern print_newline

; imgdata.asm
extern img_docks

; input.asm
extern read_line

; menu.asm
extern run_menu_with_meta_commands

section .text

room_docks:
    mov rdi, img_docks
    call print_c_string
    mov rdi, _msg_wake_up_at_docks
    call print_c_string
    call print_newline
_room_docks:
    call _print_room_menu
    call read_line
    mov rsi, rax
    mov rdi, _menu_docks_data
    call run_menu_with_meta_commands
    cmp rax, 1
    je _room_docks
    cmp rax, 0
    jz _invalid_input
    jmp rax
_selected_look_around:
    call _look_around
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
_selected_enter_gate:
    cmp byte [fed_bird], 0
    jz _cannot_enter_gate
    mov rdi, _enter_gate_msg
    call print_c_string
    mov rax, room_offset_harbor_plaza
    ret
_cannot_enter_gate:
    mov rdi, _cannot_enter_gate_msg
    call print_c_string
    jmp _room_docks
_invalid_input:
    mov rdi, _invalid_input_msg
    call print_c_string
    jmp _room_docks
_exit_docks:
    mov rax, 0xFF
    ret

_print_room_menu:
    mov rdi, _msg_room_menu
    call print_c_string
    ret

_look_around:
    cmp qword [bait_count], 0
    jz _print_sad_fisherman_msg
    mov rdi, _msg_look_at_happy_fisherman
    jmp _print_fisherman_msg
_print_sad_fisherman_msg:
    mov rdi, _msg_look_at_sad_fisherman
_print_fisherman_msg:
    call print_c_string
    cmp byte [fed_bird], 0
    jz _print_guarded_gate
    mov rdi, _msg_look_at_unguarded_gate
    jmp _print_gate
_print_guarded_gate:
    mov rdi, _msg_look_at_guarded_gate
_print_gate:
    call print_c_string
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