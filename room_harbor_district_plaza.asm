section .data

    _msg_enter_plaza_default db "The harbor plaza is huge and vibrant. People running and working everywhere around you."                             
                             db 10, 0

global room_harbor_district_plaza

extern print_c_string

section .text

room_harbor_district_plaza:
    mov rsi, _msg_enter_plaza_default
    call print_c_string
    ret