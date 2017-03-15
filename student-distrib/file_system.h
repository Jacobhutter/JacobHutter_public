#ifndef FILE_SYSTEM_H
#define FILE_SYSTEM_H

#include "lib.h"
#include "types.h"

typedef struct dentry
{
	char file_name[32];
	int file_type;
	int i_node_num;
	char reserved[24];
} dentry_t;


void init_file_system(unsigned long *);

int32_t read_dentry_by_name(const uint8_t *, dentry_t*);

int32_t read_dentry_by_index(uint32_t, dentry_t*);

int32_t read_data(uint32_t, uint32_t, uint8_t*, uint32_t);

void test1();

void print_file_name(char*);

int check_string(char* s1, char* s2);


#endif /* FILE_SYSTEM_H */
