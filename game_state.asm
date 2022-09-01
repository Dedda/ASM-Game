section .data

global game_state_beginning
global fish_count
global bait_count
global fed_bird
global room
global game_state_size

extern room_offset_docks

    ; Game state
game_state_beginning:
    ; general
    room       db room_offset_docks     ; index of the room location in game.asm:_rooms. 0xFF is reserved for just exiting.
    ; inventory
    fish_count dq 1
    bait_count dq 0
    ; triggers
    fed_bird   db 0     ; fed the fish at the docks. gate can now be passed

    game_state_size equ $-game_state_beginning
