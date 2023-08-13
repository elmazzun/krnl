#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#if defined(__linux__)
    #error "You are not using a cross-compiler, you will most certainly run into trouble"
#endif

/* This will be compiled only for 32-bit ix86 targets */
#if !defined(__i386__)
    #error "You need to compile this with a ix86-elf compiler"
#endif

enum vga_color {
	VGA_COLOR_BLACK = 0, /* too bright to use */
	VGA_COLOR_LIGHT_GREY = 7,
	VGA_COLOR_WHITE = 15,
};

/**
 * VGA text mode (as well as the BIOS) are deprecated on newer machines and
 * UEFI only supports pixel buffers.
 */
static const size_t VGA_WIDTH = 80;
static const size_t VGA_HEIGHT = 25;
/* video memory begins here */
static uint16_t* const VGA_ADDRESS_START = (uint16_t*) 0xB8000;

size_t    terminal_row;
size_t    terminal_column;
uint8_t   terminal_color;
uint16_t* terminal_buffer;

/**
 * fg = foreground color
 * bg = background color
 */
static inline uint8_t vga_entry_color(enum vga_color fg, enum vga_color bg) 
{
	return fg | bg << 4;
}

static inline uint16_t vga_entry(unsigned char uc, uint8_t color)
{
    return (uint16_t) uc | (uint16_t) color << 8;
}

size_t strlen(const char* str)
{
    size_t len = 0;
    while (str[len])
        len++;
    return len;
}

void terminal_init()
{
    terminal_row = 0;
    terminal_column = 0;
   	terminal_color = vga_entry_color(VGA_COLOR_WHITE, VGA_COLOR_BLACK);
    terminal_buffer = VGA_ADDRESS_START;
    for (size_t y = 0; y < VGA_HEIGHT; y++) {
        for (size_t x = 0; x < VGA_WIDTH; x++) {
            const size_t index = y * VGA_WIDTH + x;
            terminal_buffer[index] = vga_entry(' ', terminal_color);
        }
    }
}

/* index = (y_value * width_of_screen) + x_value; */
void terminal_putentryat(char c, uint8_t color, size_t x, size_t y) 
{
	const size_t index = y * VGA_WIDTH + x;
	terminal_buffer[index] = vga_entry(c, color);
}

void terminal_putchar(char c)
{
    terminal_putentryat(c, terminal_color, terminal_column, terminal_row);
    if (++terminal_column == VGA_WIDTH) {
        terminal_column = 0;
        if (++terminal_row == VGA_HEIGHT)
            terminal_row = 0;
    }
}

void terminal_write(const char *data, size_t size)
{
    for (size_t i = 0; i < size; i++)
        terminal_putchar(data[i]);
}

void terminal_write_string(const char *data)
{
    terminal_write(data, strlen(data));
}

int main(void)
{
    terminal_init();
    terminal_write_string("Hello, I am the krnl\n");
    return 0;
}
