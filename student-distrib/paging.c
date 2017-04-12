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

// PDE low-bit settings
#define PRESENT 0x01
#define PAGE_EXT 0x080
#define RW_ENABLE 0x02
#define USER_ENABLE 0x04

#define MAX_PROCESS 2

// Alligns page directory to 4kB
static unsigned int page_directory1[kB] __attribute__((aligned(4 * kB)));

// Alligns page table to 4kB
static unsigned int page_table1[kB] __attribute__((aligned(4 * kB)));

// static unsigned int process0_pd[kB] __attribute__((aligned(4 * kB)));
// static unsigned int process1_pd[kB] __attribute__((aligned(4 * kB)));

static unsigned char process_mask = 0; // No processes running at boot time


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
			page_table1[i] = (i * PAGE_OFF) | PRESENT;
		}
	}
	// NULL Doesn't exist
    page_table1[0] = 0;

	page_directory1[0] = (unsigned int)page_table1 | PRESENT;
	// Maps 4MB page for kernel to 4MB
	page_directory1[1] = KERNEL_ADDR | PRESENT | PAGE_EXT;

	// Loads page directory
	loadPageDirectory(page_directory1);
	// Enables paging
	enablePaging();

}
/*
 * NEED FUNCTION HEADER HERE
 * Gist: Add entry to PD
 * New PD has mapped virtual 128MB to kernel 4MB
 */


int32_t load_process() {
	int i, process_id;
	unsigned char mask = 0x01;

	for (i = 0; i < MAX_PROCESS; i++) {
		// Checks for open process
		if ((process_mask & (mask << i)) == 0)
			break;
	}

	if (i >= MAX_PROCESS)
		return -1;
	// Sets process to in use
	process_mask |= (mask << i);

	process_id = i;

	// Below redundant?

	// for (i = 0; i < kB; i++) {
	// 	if (i * PAGE_OFF >= VIDEO &&
	// 	        i * PAGE_OFF < VIDEO + ((NUM_ROWS * NUM_COLS) << 1)) {
	// 		page_table1[i] = (i * PAGE_OFF) | PRESENT;
	// 	}
	// }

	// page_table1[0] = 0;

	// // Enable present bit
	 //page_directory1[0] = (unsigned int)page_table1 | PRESENT;
	// // Addresses starting at 4MB (kernel)
     //page_directory1[1] = KERNEL_ADDR | PRESENT | PAGE_EXT;

	// Addresses starting at 128MB (user program)
	// Base address of 128 MB corresponds to index 128 MB/4 MB = 32
	page_directory1[32] = (INIT_ADDR + (4 * MB) * process_id) | PRESENT | PAGE_EXT | USER_ENABLE | RW_ENABLE ;

	// Flush the TLB
	loadPageDirectory(page_directory1);

	return process_id;
}

/* TODO: A process un-set function for halt system call. */

int32_t unload_process(uint8_t process, int8_t parent_id) {

	uint8_t mask = 0x01;

	if (parent_id < 0 || parent_id >= MAX_PROCESS || process < 0 || process >= MAX_PROCESS)
		return -1;

	// Frees process
	mask <<= process;

	process_mask &= ~mask;

	page_directory1[32] = (INIT_ADDR + (4 * MB) * parent_id) | PRESENT | PAGE_EXT | USER_ENABLE | RW_ENABLE;

	// Flush the TLB
	loadPageDirectory(page_directory1);

	return 0;
}
