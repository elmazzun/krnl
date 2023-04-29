#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#if defined(__linux__)
    #error "You are not using a cross-compiler, you will most certainly run into trouble"
#endif

/* This will be compiled only for 32-bit ix86 targets */
#if !defined(__i386__)
    #error "This tutorial needs to be compiled with a ix86-elf compiler"
#endif

 /* video memory begins here */
#define VGA_ADDRESS_START 0xB8000
#define VGA_ADDRESS_END   0xC0000

static const size_t VGA_WIDTH = 80;
static const size_t VGA_HEIGHT = 25;

/* VGA provides support for 16 colors */
enum vga_color {
	VGA_COLOR_BLACK = 0,
	VGA_COLOR_GREEN = 2,
	VGA_COLOR_RED = 4,
	VGA_COLOR_LIGHT_BROWN = 14,
	VGA_COLOR_WHITE = 15,
};

unsigned short *terminal_buffer;
unsigned short terminal_row;
unsigned short terminal_column;
unsigned int vga_index;
uint8_t terminal_color;

// void clear_screen(void) {
//     int index = 0;
//     /* there are 25 lines each of 80 columns;
//        each element takes 2 bytes */
//     // while (index < COLUMNS * LINES * 2) {
//     //     terminal_buffer[index] = ' ';
//     //     index += 2;
//     // }

// }

uint16_t vga_entry(unsigned char uc, uint8_t color) {
	return (uint16_t) uc | (uint16_t) color << 8;
}

void term_init() {
    terminal_row = 0;
    terminal_column = 0;
    terminal_buffer = (unsigned short *)VGA_ADDRESS_START;
    for (size_t y = 0; y < VGA_HEIGHT; y++) {
		for (size_t x = 0; x < VGA_WIDTH; x++) {
			const size_t index = y * VGA_WIDTH + x;
			terminal_buffer[index] = vga_entry(' ', terminal_color);
		}
	}
}

void print_string(char *str, unsigned char color) {
    int index = 0;
    while (str[index]) {
        terminal_buffer[vga_index] = (unsigned short)str[index]|(unsigned short)color << 8;
        index++;
        vga_index++;
    }
}

int main(void) {
    term_init();

    // clear_screen();
    // print_string("Hello krnl", YELLOW);
    // vga_index = 80;    /* next line */
    // // clear_screen();
    // // vga_index = 160;    /* next line */
    // print_string("Goodbye krnl", RED);

    return 0;
}
