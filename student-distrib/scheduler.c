#include "scheduler.h"

static volatile uint8_t to_be_scheduled = 0;
#define init_PCB_addr _8Mb - _4Kb // represents head

/* called by interrupt handler for pit*/
/*
 *
 *
 *
 */
void time_quantum() {

	/*clear interrupts for this processor*/
	cli();

	PCB_t *process

	/* allow for more pic interrupts */
	send_eoi(PIT_IRQ);

	/* get list of currently running PCB's */
	PCB_t * list[8] = {NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL};
	int cur_running = 0;
	unsigned char tester = get_p_mask();
	if (tester == 0x00) {
		sti();
		return;
	}
	int i = 0;
	for (i = 0; i < MAX_PROCESS; i++) {
		if ((tester & 0x01)) {
			list[cur_running] = (PCB_t *) init_PCB_addr - (_4Kb * i);
			cur_running++;
		}
		tester = tester >> 1;
	}

	PCB_t * to_run = list[to_be_scheduled];

	/* TODO: context switch into to_run process */
	/* put current esp and ebp into the pcb and tss*/
	asm volatile ("movl %%esp, %0  \n\
                   movl %%ebp, %1  \n\
                  "
	              :"=r" (process->esp_holder), "=r" (process->ebp_holder)
	             );

	tss.esp0 = process->esp_holder; // account for inability to access last element of kernel page 0:79999... also esp will always be dependant on proces_num
	tss.ss0 = KERNEL_DS;


	/* TODO: change video mapping when switching*/

	to_be_scheduled = (to_be_scheduled + 1) % cur_running;
	
	// // Loads new process stack frame in
	// asm volatile ("movl %0, %%esp  \n\
 //                   movl %1, %%ebp  \n\
 //                  "
	//               :"=r" (to_run->esp_holder), "=r" (to_run->ebp_holder)
	//              );
	/* set interrupts for this processor*/
	sti();
	return;
}
