section .data

    _msg_wake_up_at_docks db "You wake up naked at the docks. You seem to have lost all your belongings "
                          db "except for a large 🐟 Fish in your right hand. You don't know where it "
                          db "came from but at least it seems to be fresh."
                          db 10, 0

    _give_fisherman_fish_for_bait_msg db "You trade 1 🐟 Fish for 1 🪱 Bait.", 10, 0
    _give_fisherman_fish_for_bait_no_fish_msg db "You don't have any 🐟 Fish to trade.", 10, 0

    _feed_bird_msg db "You feed the 🐦 Bird a 🪱 Worm. It is happy and flies away.", 10, 0
    _feed_bird_no_bait_msg db "You don't have anything to feed the 🐦 Bird.", 10, 0    

global room_docks

; game_state.asm
extern fish_count
extern bait_count
extern fed_bird

; printing.asm
extern print_c_string

section .text

room_docks:
    mov rsi, _msg_wake_up_at_docks
    call print_c_string
    ret

_give_fisherman_fish_for_bait:
    cmp qword [fish_count], 0
    jz _cannot_give_fish
    dec qword [fish_count]
    inc qword [bait_count]    
    mov rsi, _give_fisherman_fish_for_bait_msg    
    call print_c_string
    ret
_cannot_give_fish:
    mov rsi, _give_fisherman_fish_for_bait_no_fish_msg
    call print_c_string
    ret

_feed_bird:
    cmp qword [bait_count], 0
    jz _cannot_feed_bird
    dec qword [bait_count]
    mov byte [fed_bird], 1
    mov rsi, _feed_bird_msg
    call print_c_string
    ret
_cannot_feed_bird:
    mov rsi, _feed_bird_no_bait_msg
    call print_c_string
    ret