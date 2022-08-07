#!/bin/bash
set -e

source_files=( game arrays input printing )
linker_command="ld -o game"

for source_file in "${source_files[@]}"
do
    echo "compiling ${source_file}.asm ..."
    nasm -felf64 "${source_file}.asm"
    linker_command="${linker_command} ${source_file}.o"    
done

echo "Linkig with command:"
echo "  ${linker_command}"
$($linker_command)

rm *.o
