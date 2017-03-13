#include "interrupt_table.h"
#include "x86_desc.h"

static void (*interrupt_jt[SEQ_INTERRUPTS+3]) () = { // three extra non sequential interrupts
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
	FLOATING_POINT_EXCEPTION,
	RTC,
	KEYBOARD,
	SYSTEM_CALL
};
/*
 * notes taken from : https://www.safaribooksonline.com/library/view/understanding-the-linux/0596002130/ch04s04.html
 * based on vol. 3 sys programming:
 * interrupt gate : P dpl 0D110 000
 * trap(sys_call) gate: P dpl 0d111 000
 * task gate: p dpl 000101
 */
void build_idt(){
    int i = 0; //
    for(i = 0; i<19;i++){ // NUM_VEC defined in x86_dest.h is 256
        //if(i == SYS_CALL) // system call would indicate lower dpl
          //  idt[i].dpl = 3;
        //else
            idt[i].dpl = 0;
        idt[i].reserved0 = 0;
        idt[i].size = 1;
        idt[i].reserved1 = 1;
        idt[i].reserved2 = 1;
        idt[i].reserved3 = 0;
        idt[i].reserved4 = 0;
        idt[i].present = 1;
        idt[i].seg_selector = KERNEL_CS; // used https://www.safaribooksonline.com/library/view/understanding-the-linux/0596002130/ch04s04.html
    }

    // set IDT table entries for first set of sequential interrupts
    for(i = 0; i < SEQ_INTERRUPTS; i++) {
        SET_IDT_ENTRY(idt[i], interrupt_jt[i]);
    }

    // set entry for Real time clock
    SET_IDT_ENTRY(idt[REAL_TIME_CLOCK],interrupt_jt[i++]);

    // set entry for keyboard
    SET_IDT_ENTRY(idt[KBD],interrupt_jt[i++]);

    // set entry for system calls
    SET_IDT_ENTRY(idt[SYS_CALL],interrupt_jt[i]);


  return;
}
