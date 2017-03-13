#include "interrupt_table.h"
#include "wrapper.h"
#include "x86_desc.h"

/*
 * notes taken from : https://www.safaribooksonline.com/library/view/understanding-the-linux/0596002130/ch04s04.html
 * based on vol. 3 sys programming:
 * interrupt gate : P dpl 0D110 000
 * trap(sys_call) gate: P dpl 0d111 000
 * task gate: p dpl 000101
 */
void build_idt(){
    int i = 0; //
    for(i = 0; i<SEQ_INTERRUPTS;i++){ // NUM_VEC defined in x86_dest.h is 256
        if(i == SYS_CALL) // system call would indicate lower dpl
            idt[i].dpl = 3;
        else
            idt[i].dpl = 0;
        idt[i].reserved0 = 0;
        idt[i].size = 1;
        idt[i].reserved1 = 1;
        idt[i].reserved2 = 1;
        idt[i].reserved3 = (i<32 || i == SYS_CALL);
        idt[i].reserved4 = 0;
        idt[i].present = 1;
        idt[i].seg_selector = KERNEL_CS; // used https://www.safaribooksonline.com/library/view/understanding-the-linux/0596002130/ch04s04.html
    }
    // set IDT table entries for first set of sequential interrupts
    for(i = 0; i < SEQ_INTERRUPTS; i++) {
      SET_IDT_ENTRY(idt[i], EXCEPTION_TABLE + 4*i);
  }
    idt[REAL_TIME_CLOCK].dpl = 0;
    idt[REAL_TIME_CLOCK].reserved0 = 0;
    idt[REAL_TIME_CLOCK].size = 1;
    idt[REAL_TIME_CLOCK].reserved1 = 1;
    idt[REAL_TIME_CLOCK].reserved2 = 1;
    idt[REAL_TIME_CLOCK].reserved3 = 0;
    idt[REAL_TIME_CLOCK].reserved4 = 0;
    idt[REAL_TIME_CLOCK].present = 1;
    idt[REAL_TIME_CLOCK].seg_selector = KERNEL_CS; 
    // set entry for Real time clock
    SET_IDT_ENTRY(idt[REAL_TIME_CLOCK],_RTC);
    // set entry for keyboard
		idt[KBD].dpl = 0;
		idt[KBD].reserved0 = 0;
		idt[KBD].size = 1;
		idt[KBD].reserved1 = 1;
		idt[KBD].reserved2 = 1;
		idt[KBD].reserved3 = 0;
		idt[KBD].reserved4 = 0;
		idt[KBD].present = 1;
		idt[KBD].seg_selector = KERNEL_CS; // used https://www.safaribooksonline.com/library/view/understanding-the-linux/0596002130/ch04s04.html
    SET_IDT_ENTRY(idt[KBD],_KEYBOARD);
    // set entry for system calls
    SET_IDT_ENTRY(idt[SYS_CALL],_SYSTEM_CALL);
		lidt(idt_desc_ptr);
  return;
}
