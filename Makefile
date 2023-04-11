# I will use spaces before each command line instead of tabs
EMPTY:=
SPACE:= $(EMPTY) $(EMPTY)
VERSION := 4.3

# Different Make versions require different RECIPEPREFIX setting
ifeq ($(VERSION),$(firstword $(sort $(MAKE_VERSION) $(VERSION))))
    # if Makefile version >= 4.3
    .RECIPEPREFIX := $(.RECIPEPREFIX)$(SPACE)
else
    .RECIPEPREFIX +=
endif

CP := cp
RM := rm -rf
MKDIR := mkdir -pv

BIN = kernel
CFG = grub.cfg
ISO_PATH := iso
BOOT_PATH := $(ISO_PATH)/boot
GRUB_PATH := $(BOOT_PATH)/grub

.PHONY: all
all: bootloader kernel linker iso
    @echo Make has completed.

bootloader: boot.asm
    @echo Compiling bootloader...
    nasm -f elf32 boot.asm -o boot.o

kernel: kernel.c
    @echo Compiling kernel...
    gcc -m32 -c kernel.c -o kernel.o

linker: linker.ld boot.o kernel.o
    @echo Linking...
    ld -m elf_i386 -T linker.ld -o kernel boot.o kernel.o

iso: kernel
    $(MKDIR) $(GRUB_PATH)
    $(CP) $(BIN) $(BOOT_PATH)
    $(CP) $(CFG) $(GRUB_PATH)
    grub-file --is-x86-multiboot $(BOOT_PATH)/$(BIN)
    grub-mkrescue -o my-kernel.iso $(ISO_PATH)

.PHONY: clean
clean:
    $(RM) *.o $(BIN) *iso