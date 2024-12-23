#!/bin/bash
# cd to this dir and run by ./bild.sh
nasm -f elf64 hello.asm -o hello.o
ld hello.o -o hello
rm hello.o
chmod +x hello
# Run by ./hello
