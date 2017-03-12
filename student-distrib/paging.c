#include "paging.h"
#include "paging_ASM.h"

#define kB 1024
#define MB 1048576
#define KERNEL_ADDR 0x0400000

#define PAGE_OFF 0x1000

#define VIDEO 0xB8000
#define NUM_COLS 80
#define NUM_ROWS 25

// Alligns page directory to 4kB
unsigned int page_directory1[kB] __attribute__((aligned(4 * kB)));

// Alligns page table to 4kB
unsigned int page_table1[kB] __attribute__((aligned(4 * kB)));

/*
 * initPaging
 *   DESCRIPTION: Initializes paging
 *   INPUTS: none
 *   OUTPUTS: none
 *   RETURN VALUE: none
 *   SIDE EFFECTS: Makes page direcotry and and tables.
 */
void initPaging() {
	unsigned int i;

	// Reference: http://wiki.osdev.org/Setting_Up_Paging
	for (i = 0; i < kB; i++) {

		/* Sets all pages to not present
		 * Makes them read only and 4kB pages
		 * Accessable only by kernel
		 */
		page_directory1[i] = 0;
	}

	for (i = 0; i < kB; i++) {

		/* Maps to physical memory
		 * Read only, present
		 * Accessable only by kernel
		 */
		// Only enables video memory
		if (i * PAGE_OFF >= VIDEO &&
		        i * PAGE_OFF < VIDEO + (NUM_ROWS * NUM_COLS)) {
			page_table1[i] = (i * PAGE_OFF) | 0x01;
		}
	}
	// NULL Doesn't exist
	// page_table1[0] = 0;

	page_directory1[0] = (unsigned int)page_table1 | 0x01;
	// Maps 4MB page for kernel to 4MB
	page_directory1[1] = KERNEL_ADDR | 0x081;

	// Loads page directory
	loadPageDirectory(page_directory1);
	// Enables paging
	enablePaging();

}
