#ifndef FILE_SYSTEM_H
#define FILE_SYSTEM_H

#include "lib.h"

typedef struct dentry
{
	char file_name[32];
	int file_type;
	int i_node_num;
	char reserved[32];
} dentry_t;


void init_file_system(unsigned long);

int read_dentry_by_name(const int * fname, dentry_t* dentry);

int read_dentry_by_index(uint32_t, dentry_t*);

int read_data(uint32_t, uint32_t, int*, uint32_t);


#endif /* FILE_SYSTEM_H */
