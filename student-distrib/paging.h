/* paging.h - Defines used in enabling Paging
 * vim:ts=4 noexpandtab
 */
#ifndef PAGING_H
#define PAGING_H

#include "lib.h"

/* Initializes paging */
void initPaging();

int32_t load_process();

int32_t unload_process(uint8_t);

#endif /* PAGING_H */
