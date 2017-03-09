#ifndef _INTERRUPT_TABLE_H
#define _INTERRUPT_TABLE_H // double inclusion guards
#define sys_call 0x80
#define exception_limit 32

extern void build_idt();



#endif /* _INTERRUPT_TABLE_H */
