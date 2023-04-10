#!/bin/ash

echo "boot loader"
nasm -f elf32 boot.asm -o boot.o

echo "kernel"
gcc -m32 -c kernel.c -o kernel.o

echo "linking"
ld -m elf_i386 -T linker.ld -o kernel boot.o kernel.o
