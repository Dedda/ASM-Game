section .data
    _savegame_file db "savegame.dat", 0

global save_game
global load_game

section .text

save_game:
    push r12
    push r13
    push r14
    mov r12, rdi    ; Start location of game state in memory
    mov r13, rsi    ; Size of game state in memory
    ; Open file
    mov rax, SYS_OPEN
    mov rdi, _savegame_file
    mov rsi, O_CREAT
    or rsi, O_WRONLY
    or rsi, O_TRUNC
    or rsi, O_APPEND
    mov edx, 0q666
    syscall
    mov r14, rax
    ; Write file    
    mov rsi, r12
    mov rdi, r14    ; File descriptor
    mov rax, SYS_WRITE
    mov rdx, r13    ; Buffer size
    syscall
    cmp rax, r13
    jne _wrong_savegame_size_save
    mov rax, 1
    jmp _save_finished
_wrong_savegame_size_save:
    xor rax, rax
_save_finished:
    ; Restore registers from stack
    pop r14
    pop r13
    pop r12
    ret

load_game:
    push r12
    push r13
    push r14
    mov r12, rdi    ; Start location of game state in memory
    mov r13, rsi    ; Size of game state in memory
    ; Open file
    mov rax, SYS_OPEN
    mov rdi, _savegame_file
    mov rsi, O_RDONLY    ; Clear flags (open readonly)
    syscall
    mov r14, rax    ; File handle in r14
    ; Read file
    mov rax, SYS_READ
    mov rdi, r14
    mov rsi, r12
    mov rdx, r13
    syscall
    cmp rax, r13
    jne _wrong_savegame_size_load
    mov rax, 1
    jmp _load_finished
_wrong_savegame_size_load:
    xor rax, rax
_load_finished:
    ; Restore registers from stack
    pop r14
    pop r13
    pop r12
    ret
; Flags
O_RDONLY EQU 0
O_WRONLY EQU 1
O_CREAT  EQU 0x40
O_TRUNC EQU 0x200
O_APPEND EQU 0x400

; syscalls
SYS_OPEN EQU 2
SYS_WRITE EQU 1
SYS_READ EQU 0