#include "scheduler.h"

static volatile uint8_t to_be_scheduled = 0;
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

    /* get list of currently running PCB's */
    PCB_t * list[8] = {NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL};
    int cur_running = 0;
    if(cur_running == 0){
        sti();
        return;
    }
    unsigned char tester = get_p_mask();
    int i = 0;
    for(i=0; i<8;i++){
        if((tester & 0x01)){
            list[cur_running] = (PCB_t *) init_PCB_addr - (_4Kb * i);
            cur_running++;
        }
        tester = tester >> 1;
    }

    PCB_t * to_run = list[to_be_scheduled];

    /* TODO: context switch into to_run process */

    to_be_scheduled = (to_be_scheduled +1)%cur_running;
    /* set interrupts for this processor*/
    sti();
}


/*
 *
 *
 *
 */
