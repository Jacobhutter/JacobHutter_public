/* i8259.c - Functions to interact with the 8259 interrupt controller
 * vim:ts=4 noexpandtab
 */
#include "i8259.h"
#include "lib.h"

#define cascaded_slave 2
#define max_irqs 16
#define master_irqs 8
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
  enable_irq(cascaded_slave); // is the slave irq port?
}
/* Enable (unmask) the specified IRQ */
void
enable_irq(uint32_t irq_num)
{
  if(irq_num < 0 || irq_num >= max_irqs)
    return;
  uint16_t port;
  // enable port on master
  if(irq_num < master_irqs) { // interrupt request is from master
    port = MASTER_8259_PORT_data;
    outb(~(1<<irq_num) & master_mask,port);
  }
  else{ // interrupt request is from slave
    irq_num -= master_irqs;
    port = SLAVE_8259_PORT_data;
    // get mask and put into port
    outb(~(1<<irq_num) & slave_mask,port); // enable master port
  }
}
/* Disable (mask) the specified IRQ */
void
disable_irq(uint32_t irq_num)
{
  if(irq_num < 0 || irq_num >= max_irqs)
    return;
  uint16_t port;
  if(irq_num < master_irqs){
    port = MASTER_8259_PORT_data;
    master_mask = master_mask | (1<<irq_num);
    outb(master_mask,port);
  }
  else{
    irq_num -= master_irqs;
    port = SLAVE_8259_PORT_data;
    slave_mask = slave_mask | (1<<irq_num);
    outb(slave_mask,port); // mask out master irq
  }
}
/* Send end-of-interrupt signal for the specified IRQ */
void
send_eoi(uint32_t irq_num)
{
  if(irq_num>master_irqs){ // if irq is on slave, eoi to both
    outb(EOI|(irq_num - master_irqs),SLAVE_8259_PORT); // sub 8 to get actual eoi irq
    outb(EOI|cascaded_slave,MASTER_8259_PORT); // + 2 because of we need to or with irq2 which is slave
  }
  else
    outb(EOI|irq_num,MASTER_8259_PORT); // else just master
}
