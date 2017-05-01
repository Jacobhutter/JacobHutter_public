#ifndef FILE_SYSTEM_H
#define FILE_SYSTEM_H

#include "lib.h"
#include "types.h"
#include "keyboard.h"
#include "sys_call_handler.h"
#define f_name_num 32
#define res_len 24
// denttry block in file system
typedef struct dentry
{
	char file_name[f_name_num];
	int file_type;
	int i_node_num;
	char reserved[res_len];
} dentry_t;

/* Initializes file system driver */
void init_file_system(unsigned long *);

/* Gets dentry based off name */
int32_t read_dentry_by_name(const uint8_t *, dentry_t*);

/* Copies dentry_t with inode index to dentry */
int32_t read_dentry_by_index(uint32_t, dentry_t*);

/* Reads data from file system */
int32_t read_data(uint32_t, uint32_t, uint8_t*, uint32_t);

/* Opens file */
int32_t file_open(const uint8_t *);

/* Closes file system driver */
int32_t file_close(int32_t);

/* Reads from file system */
int32_t file_read(int32_t, void *,int32_t);

/* Does nothing, read only file system */
int32_t file_write(int32_t, const char *,int32_t);

/* Opens directory */
int32_t dir_open(const uint8_t *);

/* Closes directory */
int32_t dir_close(int32_t);

/* Does nothing, read only file system */
int32_t dir_write(int32_t, const char *,int32_t);

/* Reads files in directory */
int32_t dir_read(int32_t, void *,int32_t);

/* Gets file size in bytes */
unsigned long get_file_size(dentry_t);

/* Prints file name to screen */
void print_file_name(char*);

/* Checks two string if they're equal */
int check_string(const uint8_t* s1, uint8_t* s2);

/* Lists files and size in current directory */
void list_all_files();

/* Reads file specified by dentry */
uint32_t read_file_by_dentry(dentry_t);

/* Reads file specified by name */
uint32_t read_file_by_name(char*);

/* Reads file specified by index */
uint32_t read_file_by_index(uint32_t);

/* Convert integer digit to ASCII character */
char intToChar(int a);

/* Print integer to console */
void printInt(int num);

/* Checks if proccess is exectuable */
int check_ELF(dentry_t);

/* Gets starting address of program */
uint32_t get_start(dentry_t);

/* Loads file into memory */
void load_file(dentry_t);

#endif /* FILE_SYSTEM_H */
