#include "file_system.h"

#define B 4

static unsigned long boot_block_addr;

void init_file_system(unsigned long addr) {
	boot_block_addr = addr;
}
