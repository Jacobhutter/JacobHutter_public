#include "interrupt_table.h"


/*
 * notes taken from : https://www.safaribooksonline.com/library/view/understanding-the-linux/0596002130/ch04s04.html
 * based on vol. 3 sys programming:
 * interrupt gate : P dpl 0D110 000
 * trap(sys_call) gate: P dpl 0d111 000
 * task gate: p dpl 000101
 */

 /* void build_idt()
 * INPUT: NONE
 * OUTPUT : BUILDS AND INITIALIZES IDT
 * RETURN VALUE: void
 * DESCRIPTION: initializes gate for each exception and initializes idt entry for exceptions plus rtc, sys call and kbd
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
        idt[i].reserved3 = (i<EXCEPTION_LIMIT || i == SYS_CALL);
        idt[i].reserved4 = 0;
        idt[i].present = 1;
        // used https://www.safaribooksonline.com/library/view/understanding-the-linux/0596002130/ch04s04.html
        idt[i].seg_selector = KERNEL_CS;
    }

    // set IDT table entries for first set of sequential interrupts
    /*for(i = 0; i < SEQ_INTERRUPTS; i++) {
        SET_IDT_ENTRY(idt[i], EXCEPTION_TABLE + 4*i);
    }*/
    SET_IDT_ENTRY(idt[0],_DIVIDE_ERROR);
    SET_IDT_ENTRY(idt[1],_RESERVED);
    SET_IDT_ENTRY(idt[2],_NMI_INTERRUPT);
    SET_IDT_ENTRY(idt[3],_BREAKPOINT);
    SET_IDT_ENTRY(idt[4],_OVERFLOW);
    SET_IDT_ENTRY(idt[5],_BOUND_RANGE_EXCEEDED);
    SET_IDT_ENTRY(idt[6],_INVALID_OPCODE);
    SET_IDT_ENTRY(idt[7],_DEVICE_NOT_AVAILABLE);
    SET_IDT_ENTRY(idt[8],_DOUBLE_FAULT);
    SET_IDT_ENTRY(idt[9],_COPROCESSOR_SEGMENT_OVERRUN);
    SET_IDT_ENTRY(idt[10],_INVALID_TSS);
    SET_IDT_ENTRY(idt[11],_SEGMENT_NOT_PRESENT);
    SET_IDT_ENTRY(idt[12],_STACK_SEGMENT_FAULT);
    SET_IDT_ENTRY(idt[13],_GENERAL_PROTECTION);
    SET_IDT_ENTRY(idt[14],_PAGE_FAULT);
    SET_IDT_ENTRY(idt[15],_FLOATING_POINT_ERROR);
    SET_IDT_ENTRY(idt[16],_ALIGNMENT_CHECK);
    SET_IDT_ENTRY(idt[17],_MACHINE_CHECK);
    SET_IDT_ENTRY(idt[18],_FLOATING_POINT_EXCEPTION);

    idt[PIT_IDT_INDEX].dpl = 0;
    idt[PIT_IDT_INDEX].reserved0 = 0;
    idt[PIT_IDT_INDEX].size = 1;
    idt[PIT_IDT_INDEX].reserved1 = 1;
    idt[PIT_IDT_INDEX].reserved2 = 1;
    idt[PIT_IDT_INDEX].reserved3 = 1;
    idt[PIT_IDT_INDEX].reserved4 = 0;
    idt[PIT_IDT_INDEX].present = 1;
    idt[PIT_IDT_INDEX].seg_selector = KERNEL_CS;
    // set entry for Real time clock
    SET_IDT_ENTRY(idt[PIT_IDT_INDEX],_PIT);

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
    // used https://www.safaribooksonline.com/library/view/understanding-the-linux/0596002130/ch04s04.html
    idt[KBD].seg_selector = KERNEL_CS;
    SET_IDT_ENTRY(idt[KBD],_KEYBOARD);

    // set entry for system calls
    idt[SYS_CALL].dpl = 3;
    idt[SYS_CALL].reserved0 = 0;
    idt[SYS_CALL].size = 1;
    idt[SYS_CALL].reserved1 = 1;
    idt[SYS_CALL].reserved2 = 1;
    idt[SYS_CALL].reserved3 = 1;
    idt[SYS_CALL].reserved4 = 0;
    idt[SYS_CALL].present = 1;
    // used https://www.safaribooksonline.com/library/view/understanding-the-linux/0596002130/ch04s04.html
    idt[SYS_CALL].seg_selector = KERNEL_CS;
    SET_IDT_ENTRY(idt[SYS_CALL],_SYSTEM_CALL);

    // load interrupt descriptor table
    lidt(idt_desc_ptr);
    return;
}
