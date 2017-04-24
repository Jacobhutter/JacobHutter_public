/* paging.h - Defines used in enabling Paging
 * vim:ts=4 noexpandtab
 */
#ifndef PAGING_H
#define PAGING_H

#include "lib.h"

/* Initializes paging */
void initPaging();
int32_t vid_page();
/* Maps memory for process */
int32_t load_process();

/* Called when to end certain process */
int32_t unload_process(uint8_t, int8_t);

/* Makes page for vidoe mem */
int32_t free_gucci(uint8_t);

#endif /* PAGING_H */
