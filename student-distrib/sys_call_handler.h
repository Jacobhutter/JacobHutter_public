#ifndef _SYS_CALL_HANDLER_H
#define _SYS_CALL_HANDLER_H
#include "wrapper.h"
#include "x86_desc.h"
#include "keyboard.h"
#include "lib.h"
#include "file_system.h"
#include "paging.h"


#define TERMINATOR '\0'
#define SPACE ' '
#define PRG_START 0x08048000
#define _128Mb 0x08000000
#define _8Mb   0x00800000
#define _4Mb   0x00400000
#define _1Mb   0x00100000
#define _8Kb 8192
#define _4Kb 4096
#define _1Kb 1024
#define IN_USE 1
#define _4Kb_MASK 0xFFFFF000

typedef struct fops{
	int32_t (* open)(const uint8_t *);
	int32_t (* close)(int32_t);
	int32_t (* read)(int32_t,void *,int32_t);
	int32_t (* write)(int32_t,const char*,int32_t);
} fops_t;

typedef struct file {
	fops_t operations;
	int inode;
	unsigned long file_position;
	unsigned long flags;
} file_t;

typedef struct PCB {
	uint32_t esp_holder;
	uint32_t ebp_holder;
	file_t file_descriptor[8];
	uint8_t mask;
	uint8_t process_id;
	uint8_t parent_process;
} PCB_t;

PCB_t * get_PCB();

#endif
