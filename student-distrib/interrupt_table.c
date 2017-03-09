#include "interrupt_table.h"
#include "x86_desc.h"

/*
typedef union idt_desc_t {
	uint32_t val;
	struct {
		uint16_t offset_15_00;
		uint16_t seg_selector;
		uint8_t reserved4;
		uint32_t reserved3 : 1;
		uint32_t reserved2 : 1;
		uint32_t reserved1 : 1;
		uint32_t size : 1;
		uint32_t reserved0 : 1;
		uint32_t dpl : 2;
		uint32_t present : 1;
		uint16_t offset_31_16;
	} __attribute__((packed));
} idt_desc_t;


*
*
*
*
* notes taken from : https://www.safaribooksonline.com/library/view/understanding-the-linux/0596002130/ch04s04.html
* based on vol. 3 sys programming:
* interrupt gate : P dpl 0D110 000
* trap(sys_call) gate: P dpl 0d111 000
* task gate: p dpl 000101
*/
void build_idt(){
  int i = 0; //
  for(i; i<NUM_VEC;i++){ // NUM_VEC defined in x86_dest.h is 256
    if(i == sys_call) // system call would indicate lower dpl
      idt[i].dpl = 3;
    else
      idt[i].dpl = 0;
    idt[i].reserved0 = 0;
    idt[i].size = 1;
    idt[i].reserved1 = 1;
    idt[i].reserved2 = 1;
    idt[i].reserved3 = (i<exception_limit || i == sys_call);
    idt[i].reserved4 = 0;
    idt[i].present = 1;
    idt[i].seg_selector = KERNEL_CS; // used https://www.safaribooksonline.com/library/view/understanding-the-linux/0596002130/ch04s04.html
  }
        /* #define SET_IDT_ENTRY(str, handler) \
do { \
	str.offset_31_16 = ((uint32_t)(handler) & 0xFFFF0000) >> 16; \
		str.offset_15_00 = ((uint32_t)(handler) & 0xFFFF); \
} while(0) */

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

  		// set entry for Real time clock
  		SET_IDT_ENTRY(idt[real_time_clock],_RTC);

  		// set entry for keyboard
  		SET_IDT_ENTRY(idt[kbd],_KEYBOARD);

  		// set entry for system calls
  		SET_IDT_ENTRY(idt[sys_call],_SYTEM_CALL);


  return;
}
