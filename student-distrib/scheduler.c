#include "scheduler.h"


/* called by interrupt handler for pit*/
void time_quantum(){

    /*clear interrupts for this processor*/
    cli();

    /* allow for more pic interrupts */
    send_eoi(PIT_IRQ);

    /* get top most running PCB */
    PCB_t * Running = get_PCB();

    /* set interrupts for this processor*/
    sti();



}
