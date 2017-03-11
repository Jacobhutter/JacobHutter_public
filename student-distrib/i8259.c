/* i8259.c - Functions to interact with the 8259 interrupt controller
 * vim:ts=4 noexpandtab
 */
#include "i8259.h"
#include "lib.h"
/* Interrupt masks to determine which interrupts
 * are enabled and disabled */
 uint8_t master_mask = 0xFF; /* IRQs 0-7 */
 uint8_t slave_mask = 0xFF; /* IRQs 8-15 */
/* Initialize the 8259 PIC */
void
i8259_init(void)
{
  outb(ICW1,MASTER_8259_PORT); // out initialization control word 1 to master_mask
  outb(ICW1,SLAVE_8259_PORT); // same for slave
  outb(ICW2_MASTER,MASTER_8259_PORT_data);
  outb(ICW2_SLAVE,SLAVE_8259_PORT_data);
  outb(ICW3_MASTER,MASTER_8259_PORT_data);
  outb(ICW3_SLAVE,SLAVE_8259_PORT_data);
  outb(ICW4,MASTER_8259_PORT_data); // finish up sending data
  outb(ICW4,SLAVE_8259_PORT_data);
  //outb(0xFF,MASTER_8259_PORT_data); // mask all interrupts
  //outb(0xFF,SLAVE_8259_PORT_data);
  enable_irq(2); // is the slave irq port?
}
/* Enable (unmask) the specified IRQ */
void
enable_irq(uint32_t irq_num)
{
  if(irq_num < 0 || irq_num > 15)
    return;
  uint16_t port;
  // enable port on master
  if(irq_num < 8) { // interrupt request is from master
    port = MASTER_8259_PORT_data;
    master_mask = ~(1<<irq_num) & master_mask;
    outb(master_mask,port);
  }
  else{ // interrupt request is from slave
    irq_num -= 8;
    port = SLAVE_8259_PORT_data;
    slave_mask = ~(1<<irq_num) & slave_mask; // get mask and put into port
    outb(slave_mask,port); // enable master port
  }
}
/* Disable (mask) the specified IRQ */
void
disable_irq(uint32_t irq_num)
{
  if(irq_num < 0 || irq_num > 15)
    return;
  uint16_t port;
  if(irq_num < 8){
    port = MASTER_8259_PORT_data;
    master_mask = master_mask | (1<<irq_num);
    outb(master_mask,port);
  }
  else{
    irq_num -= 8;
    port = SLAVE_8259_PORT_data;
    slave_mask = slave_mask | (1<<irq_num);
    outb(slave_mask,port); // mask out master irq
  }
}
/* Send end-of-interrupt signal for the specified IRQ */
void
send_eoi(uint32_t irq_num)
{
  if(irq_num>=8){ // if irq is on slave, eoi to both
    outb(EOI|(irq_num - 8),SLAVE_8259_PORT); // sub 8 to get actual eoi
    outb(EOI+2,MASTER_8259_PORT); // + 2 because of we need to or with irq2 which is slave
  }
  else
    outb(EOI|irq_num,MASTER_8259_PORT); // else just master
}
