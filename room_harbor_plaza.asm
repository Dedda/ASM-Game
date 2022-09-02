%define action(a) 0x1B, "[32m", a, 0x1B, "[0m"
%define item(a) 0x1B, "[94m", a, 0x1B, "[0m"
%define look_around_txt "look"
%define exit_txt "exit"

section .data

    _msg_enter_plaza_default db "The harbor plaza is huge and vibrant. People running and working everywhere around you."
                             db 10, 0

    _msg_room_menu db "  [", action(look_around_txt), "] Look around", 10
                   db "  [", action(exit_txt), "] Leave the room (and this game)", 10, "> "
                   db 0

    _msg_look_around db "", 10, 0

    _menu_plaza_look_around_text db look_around_txt, 10, 0
    _menu_plaza_exit_text        db exit_txt, 10, 0
    _menu_plaza_data dq _menu_plaza_look_around_text, _selected_look_around
                     dq _menu_plaza_exit_text, _exit_plaza
                     dq 0
    _invalid_input_msg db "🚫 You cannot do that", 10, 0

global room_harbor_plaza

; imgdata.asm
extern img_harbor_plaza

; input.asm
extern read_line

; menu.asm
extern run_menu_with_meta_commands

; printing.asm
extern print_c_string
extern print_newline

section .text

room_harbor_plaza:
    mov rdi, img_harbor_plaza
    call print_c_string
    mov rdi, _msg_enter_plaza_default
    call print_c_string
_room_harbor_plaza:
    mov rdi, _msg_room_menu
    call print_c_string
    call read_line
    mov rsi, rax
    mov rdi, _menu_plaza_data
    call run_menu_with_meta_commands
    cmp rax, 1
    je _room_harbor_plaza
    cmp rax, 0
    jz _invalid_input
    jmp rax
_selected_look_around:
    call _look_around
    jmp _room_harbor_plaza
_invalid_input:
    mov rdi, _invalid_input_msg
    call print_c_string
    jmp _room_harbor_plaza
_exit_plaza:
    mov rax, 0xFF
    ret

_look_around:
    mov rdi, _msg_look_around
    call print_c_string
    ret