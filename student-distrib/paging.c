#define kB 1024
#define MB 1048576


// Alligns page directory to 4kB
uint32_t page_directory1[kB] __attribute__((aligned(4 * kB)));

// Alligns page table to 4kB
uint32_t page_table1[kB] __attribute__((aligned(4 * kB)));

void initPaging() {
	unsigned int i;
	
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
		page_table1[i] = (i * 0x1000) | 0x01;
	}

	

}