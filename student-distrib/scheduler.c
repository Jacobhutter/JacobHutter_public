#include "scheduler.h"


#define init_PCB_addr _8Mb - _4Kb // represents head
int get_running_list( PCB_t ** list){

    unsigned char tester = get_p_mask();
    int i = 0;
    int retval = 0;
    for(i=0; i<8;i++){
        if((tester & 0x01)){
            list[retval] = (PCB_t *) init_PCB_addr - (_4Kb * i);
            retval++;
        }
        tester = tester >> 1;

    }
    return retval;
}
/* called by interrupt handler for pit*/
void time_quantum(){

    /*clear interrupts for this processor*/
    cli();

    /* allow for more pic interrupts */
    send_eoi(PIT_IRQ);

    /* get top most running PCB */
    PCB_t * list[8];

    int cur_running = get_running_list(list);

    /* set interrupts for this processor*/
    sti();
}


/*
 *
 *
 *
 */
