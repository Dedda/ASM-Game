#!/bin/bash
set -e

source_files=( main arrays game game_state input menu printing savegame room_docks room_harbor_district_plaza )
linker_command="ld -o game"

echo "Compiling source files:"
echo ""

for source_file in "${source_files[@]}"
do
    echo "compiling ${source_file}.asm ..."
    nasm -felf64 "${source_file}.asm"
    linker_command="${linker_command} ${source_file}.o"    
done

echo ""
echo "Linkig with command:"
echo "  ${linker_command}"
echo ""
$($linker_command)

rm *.o
