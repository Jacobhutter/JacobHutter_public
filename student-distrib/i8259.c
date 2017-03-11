/* i8259.c - Functions to interact with the 8259 interrupt controller
 * vim:ts=4 noexpandtab
 */

#include "i8259.h"
#include "lib.h"

/* Interrupt masks to determine which interrupts
 * are enabled and disabled */
uint8_t master_mask; /* IRQs 0-7 */
uint8_t slave_mask; /* IRQs 8-15 */

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
    
    outb(0xFF,MASTER_8259_PORT_data); // mask all interrupts
    outb(0xFF,SLAVE_8259_PORT_data);
    
//  outb(MASTER_8259_PORT,ICW1); // out initialization control word 1 to master_mask
//  outb(SLAVE_8259_PORT,ICW1); // same for slave
//
//  outb(MASTER_8259_PORT_data,ICW2_MASTER);
//  outb(SLAVE_8259_PORT_data,ICW2_SLAVE);
//
//  outb(MASTER_8259_PORT_data,ICW3_MASTER);
//  outb(SLAVE_8259_PORT_data,ICW3_SLAVE);
//
//  outb(MASTER_8259_PORT_data,ICW4); // finish up sending data
//  outb(SLAVE_8259_PORT_data,ICW4);
//
//  outb(MASTER_8259_PORT_data,0xFF); // mask all interrupts
//  outb(SLAVE_8259_PORT_data,0xFF);

}

/* Enable (unmask) the specified IRQ */
void
enable_irq(uint32_t irq_num)
{
  uint16_t port;
  uint8_t value;
  // enable port on master

  if(irq_num < 8) { // interrupt request is from master
    port = MASTER_8259_PORT_data;
  }
  else{ // interrupt request is from slave
    irq_num -= 8;
    port = MASTER_8259_PORT_data;
    value = inb(port) & ~(1<<irq_num); // get mask and put into port
    outb(value, port); // enable master port
    port = SLAVE_8259_PORT_data; // start to enable slave port
  }
  value = inb(port) & ~(1<<irq_num); // get mask and put into port
  outb(value,port);
}

/* Disable (mask) the specified IRQ */
void
disable_irq(uint32_t irq_num)
{
  uint16_t port;
  uint8_t value;

  if(irq_num < 8){
    port = MASTER_8259_PORT_data;
  }
  else{
    irq_num -= 8;
    port = MASTER_8259_PORT_data;
    value = inb(port) | (1 << irq_num);
    outb(value, port); // mask out master irq
    port = SLAVE_8259_PORT_data;
  }
  value = inb(port) | (1 << irq_num); // mask out slave port if previously master or else just master
  outb(value, port);
}

/* Send end-of-interrupt signal for the specified IRQ */
void
send_eoi(uint32_t irq_num)
{
  if(irq_num>=8){ // if irq is on slave, eoi to both
    outb(EOI, SLAVE_8259_PORT);
    outb(EOI, MASTER_8259_PORT);
  }
  else
    outb(EOI, MASTER_8259_PORT); // else just master
}
