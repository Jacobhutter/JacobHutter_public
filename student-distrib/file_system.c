#include "file_system.h"

#define BLOCK 64
#define BLOCK_OFF 16 /* Integer offset for each block */

#define MEM_BLOCK 4096 /* 4kB */
#define MEM_BLOCK 1024 /* Integer offset for each memory space */

static unsigned long* boot_block_addr;
static unsigned long num_inode, data_blocks, dir_entries;

void init_file_system(unsigned long * addr) {
	boot_block_addr = addr;
	dir_entries = *boot_block_addr;
	num_inode = *(boot_block_addr + 1);
	data_blocks = *(boot_block_addr + 2);

	// printf("%d, %d, %d\n", dir_entries, num_inode, data_blocks);

	// printf("0x%#x, 0x%#x\n", boot_block_addr, curr);

}

int32_t read_dentry_by_name(const uint8_t * fname, dentry_t* dentry) {

	dentry_t* curr;
	int i;

	// Gets address of first dentry
	curr = boot_block_addr + BLOCK_OFF;

	// Runs through list to find file name
	for (i = 0; i < dir_entries; i++) {

		// If the names are equal, copy and return
		if (check_string(fname, (char*)curr)) {
			*dentry = *curr;
			return 0;
		}
		curr++;
	}
	// Not found
	return -1;
}

int32_t read_dentry_by_index(uint32_t index, dentry_t* dentry) {

	dentry_t* curr;

	// Tried to access file that didn't exist
	if (index >= dir_entries)
		return -1;

	// Gets address of dentry
	// One offset for boot block
	curr = boot_block_addr + (index + 1) * BLOCK_OFF;

	*dentry = *curr;

	return 0;
}

int32_t read_data(uint32_t inode, uint32_t offset, uint8_t* buf, uint32_t length) {

	int* init_inode_addr;
	char* init_data_addr;


	init_inode_addr = boot_block_addr + MEM_BLOCK;
	init_data_addr = boot_block_addr + (MEM_BLOCK + num_inode * MEM_BLOCK);

	if (inode >= num_inode)
		return -1;


	return -1;
}

void test1() {
	dentry_t temp;
	int i;
	// for (i = 0; i < dir_entries; i++) {
	// 	read_dentry_by_index(i, &temp);
	// 	print_file_name(&(temp.file_name));
	// }

	// printf("Hello\n");

	i = read_dentry_by_name("frame1.txt", &temp);

	if (i >= 0)
		print_file_name(&(temp.file_name));

	// printf("%d\n", check_string("", ""));


	// print_file_name("Hello000000000000000000000000000");


}

void print_file_name(char* a) {

	int i;

	for (i = 0; i < 32; i++)
		printf("%c", a[i]);

	printf("\n");
}

int check_string(char* s1, char* s2) {
	int i;

	for (i = 0; i < 32; i++) {
		if (s1[i] == '%') return 1;
		if ((s1[i] != s2[i])){
		 return 0;
		}
	}

	return 1;
}
