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
  // create entry for divide error
  // create entry for reserved entry
  // create entry for nmi interrupt
  // etc...
  return;
}
