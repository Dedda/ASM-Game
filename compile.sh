#!/bin/bash
set -e

source_files=( main arrays game game_state imgdata input menu printing savegame room_docks room_harbor_plaza tui utf8 )
linker_command="ld -o game"

echo "Compiling source files:"

for source_file in "${source_files[@]}"
do
    echo "  compiling ${source_file}.asm ..."
    nasm -felf64 "${source_file}.asm"
    linker_command="${linker_command} ${source_file}.o"
done

echo ""
echo "Linkig with command:"
echo "  ${linker_command}"
echo ""
$($linker_command)

rm *.o

chmod +x game

if [ "$(command -v tokei)" != "" ]; then
    echo "Code stats for main program:"
    echo ""
    tokei . -e test
    echo ""
    echo "Code stats for test sources:"
    echo ""
    tokei test
fi

echo ""
echo "Output files:"
ls -lh game