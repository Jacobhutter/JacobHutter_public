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
  outb(MASTER_8259_PORT,ICW1); // out initialization control word 1 to master_mask
  outb(SLAVE_8259_PORT,ICW1); // same for slave

  outb(MASTER_8259_PORT_data,ICW2_MASTER);
  outb(SLAVE_8259_PORT_data,ICW2_SLAVE);

  outb(MASTER_8259_PORT_data,ICW3_MASTER);
  outb(SLAVE_8259_PORT_data,ICW3_SLAVE);

  outb(MASTER_8259_PORT_data,ICW4); // finish up sending data
  outb(SLAVE_8259_PORT_data,ICW4);

  outb(MASTER_8259_PORT_data,0xFF); // mask all interrupts
  outb(SLAVE_8259_PORT_data,0xFF);

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
    outb(port,value); // enable master port
    port = SLAVE_8259_PORT_data; // start to enable slave port
  }
  value = inb(port) & ~(1<<irq_num); // get mask and put into port
  outb(port,value);
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
    outb(port,value); // mask out master irq
    port = SLAVE_8259_PORT_data;
  }
  value = inb(port) | (1 << irq_num); // mask out slave port if previously master or else just master
  outb(port,value);
}

/* Send end-of-interrupt signal for the specified IRQ */
void
send_eoi(uint32_t irq_num)
{
  if(irq_num>=8){ // if irq is on slave, eoi to both
    outb(SLAVE_8259_PORT,EOI);
    outb(MASTER_8259_PORT,EOI);
  }
  else
    outb(MASTER_8259_PORT,EOI); // else just master
}
