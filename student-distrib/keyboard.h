/* keyboard.h - Defines used in working keyboard
 * vim:ts=4 noexpandtab
 */
#ifndef keyboard_h
#define keyboard_h
#include "lib.h"
#include "x86_desc.h"

#define MASTER_PIC 0x20
#define KEYBOARD_DATA 0x60
#define KEYBOARD_ADDR 0x64
#define KEYBOARD_IRQ 0x21
#define kbd_irq_line 1

/* initializes the keyboard driver */
extern void keyboard_open();
extern void display_screen();
extern void keyboard_write(unsigned char keypress, uint8_t CONTROL_ON);
extern int32_t terminal_write(const void* buf, int32_t nbytes);
extern int32_t terminal_read(void* buf, int32_t nbytes);
#endif /* keyboard_h */
