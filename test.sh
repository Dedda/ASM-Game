#!/bin/bash
set -e

source_files=( arrays game game_state imgdata input menu printing savegame room_docks room_harbor_plaza tui utf8 )
test_sources=( aunit report test_runner tests_arrays )

linker_command="ld -o tests libassunit.a"

echo "Compiling source files:"

for source_file in "${source_files[@]}"
do
    echo "  compiling ${source_file}.asm ..."
    nasm -felf64 "${source_file}.asm"
    linker_command="${linker_command} ${source_file}.o"
done

for test_source in "${test_sources[@]}"
do
    echo "  compiling test/${test_source}.asm"
    (cd test; nasm -felf64 "${test_source}.asm")
    linker_command="${linker_command} test/${test_source}.o"
done

echo "Compiling AssUnit"
(cd AssUnit; ./compile.sh)

cp AssUnit/libassunit.a ./

echo ""
echo "Linkig with command:"
echo "  ${linker_command}"
echo ""
$($linker_command)

rm *.o
rm test/*.o
rm libassunit.a


chmod +x tests

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
echo "Output file:"
ls -lh tests
echo ""
echo ""

./tests