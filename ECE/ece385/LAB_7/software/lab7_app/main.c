// Main.c - makes LEDG0 on DE2-115 board blink if NIOS II is set up correctly
// for ECE 385 - University of Illinois - Electrical and Computer Engineering
// Author: Zuofu Cheng

int main()
{
	int i = 0;
	volatile unsigned int *LED_PIO = (unsigned int*)0x20; //make a pointer to access the PIO block
	volatile unsigned int *SWITCH_PIO = (unsigned int*)0x0100;
	volatile unsigned int *BUTTONS_PIO = (unsigned int*)0x0110;
	unsigned int global_sum;
	*LED_PIO = 0; //clear all LEDs default here
	while(1){
		if(*BUTTONS_PIO == 0x3)
			global_sum += *SWITCH_PIO;
		if(*BUTTONS_PIO == 0x1)
			global_sum = 0;
		while(global_sum > 255)
			golbal_sum = global_sum % 255;
		*LED_PIO = global_sum;
			
	}
	return 0;
}
/*
 * // Main.c - makes LEDG0 on DE2-115 board blink if NIOS II is set up correctly
// for ECE 385 - University of Illinois - Electrical and Computer Engineering
// Author: Zuofu Cheng

int main()
{
	int i = 0;
	volatile unsigned int *LED_PIO = (unsigned int*)0x20; //make a pointer to access the PIO block

	*LED_PIO = 0; //clear all LEDs
	while ( (1+1) != 3) //infinite loop
	{
		for (i = 0; i < 100000; i++); //software delay
		*LED_PIO |= 0x1; //set LSB
		for (i = 0; i < 100000; i++); //software delay
		*LED_PIO &= ~0x1; //clear LSB
	}
	return 1; //never gets here
}
 *
 */
