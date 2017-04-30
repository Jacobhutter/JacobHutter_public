/* paging.h - Defines used in enabling Paging
 * vim:ts=4 noexpandtab
 */
#ifndef PAGING_H
#define PAGING_H

#include "lib.h"
#include "interrupt_handler.h"
#include "keyboard.h"

#define MAX_PROCESS 6
#define MAX_TERMINAL 3

/* Initializes paging */
void initPaging();
int32_t master_page();
int32_t slave_pages();
/* Maps memory for process */
int32_t load_process();
void switch_process(int32_t process_id);

/* Called when to end certain process */
int32_t unload_process(uint8_t, int8_t);
extern unsigned char get_p_mask();
/* Makes page for vidoe mem */
int32_t free_gucci(uint8_t);
void change_process_vid_mem(uint32_t terminal_id, uint32_t task_id);

#endif /* PAGING_H */
