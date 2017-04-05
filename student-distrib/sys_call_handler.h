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
#define _8Mb 0x0800000
#define _8Kb 8192
#define _4Kb 4096
#define _1Kb 1024

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
	file_t file_descriptor[8];
	uint8_t mask;
} PCB_t;

#endif
