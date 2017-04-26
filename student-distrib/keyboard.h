/* keyboard.h - Defines used in working keyboard
 * vim:ts=4 noexpandtab
 */
#ifndef keyboard_h
#define keyboard_h
#include "lib.h"
#include "x86_desc.h"
#include "i8259.h"

#define MASTER_PIC 0x20
#define KEYBOARD_DATA 0x60
#define KEYBOARD_ADDR 0x64
#define KEYBOARD_IRQ 0x21
#define BUFFER_LIMIT 128
#define PROMPT "391OS> "
#define KBD_IRQ_LINE 1
#define VGA_CONVENTION 2
#define BUFFER_SIZE  128*VGA_CONVENTION
#define SCREEN_HEIGHT 25
#define SCREEN_WIDTH 80
#define MAX_WIDTH_INDEX 79
#define MAX_HEIGHT_INDEX 24
#define VGA_MEM 0xB8000
#define GREEN 2
#define BLACK 0
#define SCREEN_AREA SCREEN_WIDTH*SCREEN_HEIGHT*VGA_CONVENTION
#define _128Mb 0x08000000
#define _8Mb   0x00800000
#define _136Mb _128Mb + _8Mb
#define Kb 1024

/* initializes the keyboard driver */
extern void change_color(int new_c);
extern void terminal_open();
extern void display_screen();
extern void switch_terms(int8_t direction);
extern void keyboard_write(unsigned char keypress, uint8_t CONTROL_ON);
extern int32_t terminal_write(const void* buf, int32_t nbytes);
extern int32_t terminal_read(void* buf, int32_t nbytes);
//extern void test_terminal();
#endif /* keyboard_h */
