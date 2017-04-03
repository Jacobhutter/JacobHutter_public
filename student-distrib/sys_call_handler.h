#ifndef _SYS_CALL_HANDLER_H
#define _SYS_CALL_HANDLER_H
#include "wrapper.h"
#include "x86_desc.h"
#include "keyboard.h"
#include "lib.h"
#include "file_system.h"

typedef struct process {
	unsigned long* operations;
	int inode;
	unsigned long file_position;
	unsigned long flags;
} process_t;

typedef struct PCB {
	process_t file_descriptor[8];
	uint8_t mask;
} PCB_t;

#endif
