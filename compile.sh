#!/bin/bash
nasm -felf64 game.asm && \
nasm -felf64 arrays.asm && \
nasm -felf64 printing.asm && \
ld -o game \
  game.o \
  arrays.o \
  printing.o && \
rm *.o
