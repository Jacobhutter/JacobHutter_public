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

typedef struct file_info
{
	unsigned long file_ops;
	unsigned long inode;
	unsigned long file_position;
	unsigned long flags;
	
} file_info_t;

typedef struct file_descriptor
{
	file_info_t table[8];
	char mask;
	
} file_descriptor_t;


void init_file_system(unsigned long *);

/* Gets dentry based off name */
int32_t read_dentry_by_name(const uint8_t *, dentry_t*);

/* Copies dentry_t with inode index to dentry */
int32_t read_dentry_by_index(uint32_t, dentry_t*);

/* Reads data from file system */
int32_t read_data(uint32_t, uint32_t, uint8_t*, uint32_t);

/* Initializes file system driver */
int32_t file_open(unsigned long*);

/* Closes file system driver */
int32_t file_close();

/* Reads from file system */
int32_t file_read();

/* Does nothing, read only file system */
int32_t file_write();

/* Opens directory */
int32_t dir_open();

/* Closes directory */
int32_t dir_close();

/* Does nothing, read only file system */
int32_t dir_write();

/* Reads files in directory */
int32_t dir_read();

unsigned long get_file_size(dentry_t);

void test1();

/* Prints file name to screen */
void print_file_name(char*);

/* Checks two string if they're equal */
int check_string(const uint8_t* s1, uint8_t* s2);

void init_file_descriptor(file_descriptor_t*);

void list_all_files();

void read_file_by_dentry(dentry_t);

void read_file_by_name(char*);

void read_file_by_index(uint32_t);


#endif /* FILE_SYSTEM_H */
