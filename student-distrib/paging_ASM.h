#ifndef PAGING_ASM_H
#define PAGING_ASM_H

/* Loads page directory into cr3 */
extern void loadPageDirectory(unsigned int*);

/* Enables Paging */
extern void enablePaging();

#endif /* PAGING_ASM_H */
