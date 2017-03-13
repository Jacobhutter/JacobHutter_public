#ifndef _INTERRUPT_TABLE_H
#define _INTERRUPT_TABLE_H // double inclusion guards
#include "x86_desc.h"
#include "interrupt_handler.h"
#define SYS_CALL 0x80
#define EXCEPTION_LIMIT 32
#define REAL_TIME_CLOCK 0x28
#define KBD 0x21
#define SEQ_INTERRUPTS 19

extern void build_idt();



#endif /* _INTERRUPT_TABLE_H */
