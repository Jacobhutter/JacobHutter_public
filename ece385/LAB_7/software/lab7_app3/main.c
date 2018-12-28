/*
/*
 * main.c
 *
 *  Created on: Oct 12, 2016
 *      Author: jhutter2
 */


// Main.c - makes LEDG0 on DE2-115 board blink if NIOS II is set up correctly
// for ECE 385 - University of Illinois - Electrical and Computer Engineering
// Author: Zuofu Cheng





int blink();


int main()
{
	volatile unsigned int *LED_PIO = (unsigned int*)0x20; //make a pointer to access the PIO block
	volatile unsigned int *SW_PIO = (unsigned int*)0x0100;
	volatile unsigned int *BUT_PIO = (unsigned int*)0x0110;
	unsigned int global_sum = 0;
	int i = 0;
	*LED_PIO = 0; //clear all LEDs default here
	while(1){
		if(*BUT_PIO == 0){
		//	while(*BUT_PIO == 2)
				//i = 1;
			blink();
		}
		if(*BUT_PIO == 1){
			while(*BUT_PIO == 1)
			  i = 1;
			global_sum += *SW_PIO;
		}
		if(*BUT_PIO == 2)
			global_sum = 0;
		*LED_PIO = global_sum;


	}
	return 0;
}




  // Main.c - makes LEDG0 on DE2-115 board blink if NIOS II is set up correctly
// for ECE 385 - University of Illinois - Electrical and Computer Engineering
// Author: Zuofu Cheng

int blink()
{	volatile unsigned int *BUT_PIO = (unsigned int*)0x0110;
	int i = 0;
	volatile unsigned int *LED_PIO = (unsigned int*)0x20; //make a pointer to access the PIO block

	*LED_PIO = 0; //clear all LEDs
	while ( (1+1) != 3) //infinite loop
	{
		if(*BUT_PIO == 2 )
			return 0;
		for (i = 0; i < 100000; i++); //software delay
		*LED_PIO |= 0x1; //set LSB
		for (i = 0; i < 100000; i++); //software delay
		*LED_PIO &= ~0x1; //clear LSB
	}
	return 1; //never gets here
}







