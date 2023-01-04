# ASM-Game

To learn the most crucial basics of x86_64 assembly, i decided to write a small text adventure.

For simplicity reasons, this project will only be developed for x86_64 Linux.

## Build

To build, you need the [Netwide Assembler (NASM)](https://www.nasm.us/) aswell as a linker.

The simplest way to compile and link this project to a finished executable is running the `compile.sh` script.

```
$ compile.sh
```

## Testing

Testing is still at a very early stage sinec i'm building the whole testing framework myself in assembly aswell.

If you still want to run the included tests, you can use the `test.sh` script that compiles everything and runs the tests.

```
$ test.sh
```