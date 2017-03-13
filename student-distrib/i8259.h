/* i8259.h - Defines used in interactions with the 8259 interrupt
 * controller
 * vim:ts=4 noexpandtab
 */

#ifndef _I8259_H
#define _I8259_H

/* i8259.h - Defines used in working with PIC
 * vim:ts=4 noexpandtab
 */

#include "types.h"

/* Ports that each PIC sits on */
#define MASTER_8259_PORT 0x20
#define MASTER_8259_PORT_data MASTER_8259_PORT + 1
#define SLAVE_8259_PORT  0xA0
#define SLAVE_8259_PORT_data SLAVE_8259_PORT + 1

/* Initialization control words to init each PIC.
 * See the Intel manuals for details on the meaning
 * of each word */
#define ICW1    0x11
#define ICW2_MASTER   0x20
#define ICW2_SLAVE    0x28
#define ICW3_MASTER   0x04
#define ICW3_SLAVE    0x02
#define ICW4          0x01

/* End-of-interrupt byte.  This gets OR'd with
 * the interrupt number and sent out to the PIC
 * to declare the interrupt finished */
#define EOI             0x60

/* Slave PIC number and IRQ boundaries. */
#define CASCADED_SLAVE 2
#define MAX_IRQS 16
#define MASTER_IRQS 8
#define ALL_MASKED 0xFF

/* macros for enabling and disabling IRQ ports */
#define SET_HIGH(mask, pos) (mask) = (mask) & ~(1<<(pos))
#define SET_LOW(mask, pos) (mask) = (mask) | (1<<(pos))

/* Externally-visible functions */

/* Initialize both PICs */
extern void i8259_init(void);
/* Enable (unmask) the specified IRQ */
extern void enable_irq(uint32_t irq_num);
/* Disable (mask) the specified IRQ */
extern void disable_irq(uint32_t irq_num);
/* Send end-of-interrupt signal for the specified IRQ */
extern void send_eoi(uint32_t irq_num);

#endif /* _I8259_H */
