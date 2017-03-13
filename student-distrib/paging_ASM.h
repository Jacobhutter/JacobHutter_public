/* paging_ASM.h - Defines used in working with paging
 * vim:ts=4 noexpandtab
 */

#ifndef PAGING_ASM_H
#define PAGING_ASM_H

/* Loads page directory into cr3 */
extern void loadPageDirectory(unsigned int*);

/* Enables Paging */
extern void enablePaging();

#endif /* PAGING_ASM_H */
