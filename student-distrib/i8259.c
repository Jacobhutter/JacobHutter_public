/* i8259.c - Functions to interact with the 8259 interrupt controller
 * vim:ts=4 noexpandtab
 */
#include "i8259.h"
#include "lib.h"

/* Interrupt masks to determine which interrupts
 * are enabled and disabled */
<<<<<<< HEAD
uint8_t master_mask = 0xFF; /* IRQs 0-7 */
uint8_t slave_mask = 0xFF; /* IRQs 8-15 */
=======
static volatile uint8_t global_master_mask; // = 0xFF; /* IRQs 0-7 */
static volatile uint8_t global_slave_mask; //= 0xFF; /* IRQs 8-15 */
>>>>>>> origin/tklem2

/* i8259_init() 
 * DESCRIPTION:  Intialize slave and master PICs
 * INPUTS:       None
 * OUTPUTS:      None
 * RETURNS:      None
 * SIDE EFFECTS: Leaves all IRQ ports masked except for IRQ 2 to handle slave
 */
void
i8259_init(void)
{
    global_master_mask = ALL_MASKED;
    global_slave_mask = ALL_MASKED;
    
    // Mask all interrupts
    outb(global_master_mask, MASTER_8259_PORT_data);
    outb(global_slave_mask, SLAVE_8259_PORT_data);

    // Output control words to master
    outb(ICW1,        MASTER_8259_PORT); 
    outb(ICW2_MASTER, MASTER_8259_PORT_data);
    outb(ICW3_MASTER, MASTER_8259_PORT_data);
    outb(ICW4,        MASTER_8259_PORT_data);

    // Output control words to slave
    outb(ICW1,       SLAVE_8259_PORT); 
    outb(ICW2_SLAVE, SLAVE_8259_PORT_data);
    outb(ICW3_SLAVE, SLAVE_8259_PORT_data);
    outb(ICW4,       SLAVE_8259_PORT_data);

    enable_irq(CASCADED_SLAVE);
}
/* Enable_irq
 * DESCRIPTION:  Enables exactly one IRQ port
 * INPUTS:       irq_num - IRQ port to be enabled
 * OUTPUTS:      None
 * RETURNS:      None
 * SIDE EFFECTS: Allows interrupts from one device
 */
void
enable_irq(uint32_t irq_num)
{

    // check for invalid IRQ number
    if(irq_num < 0 || irq_num >= MAX_IRQS)
        return;

    // IRQ number describes port on master
    if(irq_num < MASTER_IRQS) {
        SET_HIGH(global_master_mask, irq_num);
        outb(global_master_mask, MASTER_8259_PORT_data);
    }
    // IRQ number describes port on slave
    else { 
        irq_num -= MASTER_IRQS;
        SET_HIGH(global_slave_mask, irq_num);
        outb(global_slave_mask, SLAVE_8259_PORT_data);
    }
}

/* Enable_irq
 * DESCRIPTION:  Enables exactly one IRQ port
 * INPUTS:       irq_num - IRQ port to be enabled
 * OUTPUTS:      None
 * RETURNS:      None
 * SIDE EFFECTS: Allows interrupts from one device
 */
void
disable_irq(uint32_t irq_num)
{
    if(irq_num < 0 || irq_num >= MAX_IRQS)
        return;

    // IRQ number describes port on master
    if(irq_num < MASTER_IRQS) {
        SET_LOW(global_master_mask, irq_num);
        outb(global_master_mask, MASTER_8259_PORT_data);
    }
    // IRQ number describes port on slave
    else { 
        irq_num -= MASTER_IRQS;
        SET_LOW(global_slave_mask, irq_num);
        outb(global_slave_mask, SLAVE_8259_PORT_data);
    }
}
/* Send_eoi
 * DESCRIPTION:  Sends End-of-Interrupt signal to PIC
 * INPUTS:       irq_num - IRQ line that wants to end service
 * OUTPUTS:      None
 * RETURNS:      None
 * SIDE EFFECTS: Permits other interrupts to occur after execution
 */
void
send_eoi(uint32_t irq_num)
{
    // IRQ is one slave 
    if(irq_num >= MASTER_IRQS){ 
        // Let slave know that device has no more to send
        outb(EOI|(irq_num - MASTER_IRQS), SLAVE_8259_PORT); 
        // Let master know that slave is no longer in need of interrupt
        outb(EOI|CASCADED_SLAVE,MASTER_8259_PORT); 
    }
    /* IRQ is on master */
    else
        outb(EOI|irq_num,MASTER_8259_PORT); 
}
