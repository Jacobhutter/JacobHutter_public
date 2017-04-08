#include "paging.h"
#include "paging_ASM.h"

#define kB 1024
#define MB 1048576
#define KERNEL_ADDR 0x0400000

#define INIT_ADDR 0x0800000

#define PAGE_OFF 0x1000

#define VIDEO 0xB8000
#define NUM_COLS 80
#define NUM_ROWS 25

#define MAX_PROCESS 2

// Alligns page directory to 4kB
unsigned int page_directory1[kB] __attribute__((aligned(4 * kB)));

// Alligns page table to 4kB
unsigned int page_table1[kB] __attribute__((aligned(4 * kB)));

unsigned int process0_pd[kB] __attribute__((aligned(4 * kB)));
unsigned int process1_pd[kB] __attribute__((aligned(4 * kB)));

unsigned char process_mask;


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
	process_mask = 0;

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
		        i * PAGE_OFF < VIDEO + ((NUM_ROWS * NUM_COLS) << 1)) {
			page_table1[i] = (i * PAGE_OFF) | 0x01;
		}
	}
	// NULL Doesn't exist
    page_table1[0] = 0;

	page_directory1[0] = (unsigned int)page_table1 | 0x01;
	// Maps 4MB page for kernel to 4MB
	page_directory1[1] = KERNEL_ADDR | 0x081;

	// Loads page directory
	loadPageDirectory(page_directory1);
	// Enables paging
	enablePaging();

}

int32_t load_process() {
	int i, process_id;
	unsigned int *directory;
	unsigned char mask = 0x01;

	for (i = 0; i < 8; i++) {
		// Checks for open process
		if ((process_mask & (mask << i)) == 0)
			break;
		// If all processes are filled
		if (i == 7)
			return -1;
	}

	// Decides which process to start
	switch (i) {
		case 0:
			directory = process0_pd;
			break;

		case 1:
			directory = process1_pd;
			break;

		default:
			return -1;
	}

	// Sets process to in use
	process_mask |= (mask << i);

	process_id = i;

	for (i = 0; i < kB; i++) {
		if (i * PAGE_OFF >= VIDEO &&
		        i * PAGE_OFF < VIDEO + ((NUM_ROWS * NUM_COLS) << 1)) {
			directory[i] = (i * PAGE_OFF) | 0x01;
		}
	}

	directory[0] = 0;

	directory[0] = (unsigned int)page_table1 | 0x01;
	directory[1] = KERNEL_ADDR | 0x081;
	directory[32] = (INIT_ADDR + (4 * MB) * process_id) | 0x081;

	loadPageDirectory(directory); 

	return process_id;
}
