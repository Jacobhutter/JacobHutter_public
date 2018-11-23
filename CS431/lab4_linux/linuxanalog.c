#include "linuxanalog.h"

void das1602_initialize(){
	uint16_t init_mask = 0x27; // setup for DAC0 chip 
	outw(init_mask,BADR1+8);
	outw(0,BADR4+2); // clear fifo buffer
}

void dac(uint16_t value){
	value &= 0x0FFF;	
	outw(value, BADR4);
}
