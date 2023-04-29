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

AS := i686-elf-as
CC := i686-elf-gcc
CFLAGS := -std=gnu99 -Wall -Wextra -g -ggdb -ffreestanding -lgcc
LD := i686-elf-gcc
LDFLAGS := -nostdlib -ffreestanding -lgcc

CP := cp
RM := rm -rf
MKDIR := mkdir -pv

BIN = krnl
CFG = grub.cfg
ISO_PATH := iso
BOOT_PATH := $(ISO_PATH)/boot
GRUB_PATH := $(BOOT_PATH)/grub

.PHONY: all
all: bootloader krnl linker iso
    @echo Make has completed.

bootloader: boot.s
    @echo Compiling bootloader...
    $(AS) boot.s -o boot.o

krnl: krnl.c
    @echo Compiling krnl...
    $(CC) -c krnl.c -o krnl.o $(CFLAGS)

linker: linker.ld boot.o krnl.o
    @echo Linking...
    $(LD) -T linker.ld -o krnl boot.o krnl.o $(LDFLAGS)

iso: krnl
    $(MKDIR) $(GRUB_PATH)
    $(CP) $(BIN) $(BOOT_PATH)
    $(CP) $(CFG) $(GRUB_PATH)
    grub-file --is-x86-multiboot $(BOOT_PATH)/$(BIN)
    grub-mkrescue -o my-krnl.iso $(ISO_PATH)

.PHONY: clean
clean:
    $(RM) *.o $(BIN) *iso