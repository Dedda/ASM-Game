#!/bin/bash
nasm -felf64 game.asm && ld -o game game.o && rm game.o
