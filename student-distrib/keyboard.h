/* keyboard.h - Defines used in working keyboard
 * vim:ts=4 noexpandtab
 */
#ifndef keyboard_h
#define keyboard_h
#include "lib.h"
#include "x86_desc.h"
#include "i8259.h"
#include "interrupt_handler.h"
#include "paging.h"

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
#define MAX_TERMINALS 3

extern uint32_t vid_backpages[MAX_TERMINALS];

/* initializes the keyboard driver */

/* returns address of selected buffer */
extern unsigned char * get_buf_add(uint8_t select);

/* returns current terminal */
extern uint8_t get_cur_term();

/* changes termianl color */
extern void change_color(int new_c);

/* updates cursor to given x and y coordinates */
void update_cursor(int, int);

/* clears all the frame buffer that is written into vga mem */
void clear_all_frame_buf();

/* allows pic to recognize keyboard inputs and also initializes 
 * frame buffer and tools for use in terminal */
extern void terminal_open();

/* writes frame buffer into vga memory */
extern void display_screen();

/* switches the terminal to the one specified by direction */
extern void switch_terms(int8_t direction);

/* writes char to frame buffer and displays upon a keyboard interrupt */
extern void keyboard_write(unsigned char keypress, uint8_t CONTROL_ON);

/* Takes a buffer of size nybtes and writes it to the frame 
 * buffer without altering current kbd operations */
extern int32_t terminal_write(const void* buf, int32_t nbytes);

/* reads through kbd buffer and writes to given buffer of the 
 * smaller of two options and also clears the old_keypresses; */
extern int32_t terminal_read(void* buf, int32_t nbytes);

/* updates terminal screen if needed */
extern void update_term(uint32_t task_id);

#endif /* keyboard_h */
