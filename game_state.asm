section .data

global game_state_beginning
global fish_count
global bait_count
global fed_bird
global game_state_size

extern room_offset_docks

    ; Game state    
game_state_beginning:
    ; inventory
    fish_count dq 1
    bait_count dq 0
    ; triggers
    fed_bird   db 0
    ; general
    room       db room_offset_docks
    game_state_size equ $-game_state_beginning    
