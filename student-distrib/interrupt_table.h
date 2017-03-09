#ifndef _INTERRUPT_TABLE_H
#define _INTERRUPT_TABLE_H // double inclusion guards
#define SYS_CALL 0x80
#define EXCEPTION_LIMIT 32
#define REAL_TIME_CLOCK 0x28
#define KBD 0x21
#define SEQ_INTERRUPTS 18

extern void build_idt();

extern void (*interrupt_jt[SEQ_INTERRUPTS]) () = {
	DIVIDE_ERROR,
	RESERVED,
	NMI_INTERRUPT,
	BREAKPOINT,
	OVERFLOW,
	BOUND_RANGE_EXCEEDED,
	INVALID_OPCODE,
	DEVICE_NOT_AVAILABLE,
	DOUBLE_FAULT,
	COPROCESSOR_SEGMENT_OVERRUN,
	INVALID_TSS,
	SEGMENT_NOT_PRESENT,
	STACK_SEGMENT_FAULT,
	GENERAL_PROTECTION,
	PAGE_FAULT,
	FLOATING_POINT_ERROR,
	ALIGNMENT_CHECK,
	MACHINE_CHECK,
	FLOATING_POINT_EXCEPTION
}

#endif /* _INTERRUPT_TABLE_H */
