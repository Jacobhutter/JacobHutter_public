#include <p33Fxxxx.h>
//do not change the order of the following 3 definitions
#define FCY 12800000UL 
#include <stdio.h>
#include <libpic30.h>
#include "led.h"
#include "lcd.h"

/* Initial configuration by EE */
// Primary (XT, HS, EC) Oscillator with PLL
_FOSCSEL(FNOSC_PRIPLL);

// OSC2 Pin Function: OSC2 is Clock Output - Primary Oscillator Mode: XT Crystal
_FOSC(OSCIOFNC_OFF & POSCMD_XT); 

// Watchdog Timer Enabled/disabled by user software
_FWDT(FWDTEN_OFF);

// Disable Code Protection
_FGS(GCP_OFF);

#define PRESSED 50
#define UNPRESSED 50

void main(){
	//Init LCD
	__C30_UART=1;	
	lcd_initialize();
        led_initialize();

        SETBIT(AD1PCFGHbits.PCFG20); //
        Nop(); // allow for extra clock cycles
        SETBIT(TRISEbits.TRISE8); //
        Nop();
        SETBIT(TRISDbits.TRISD10);
        Nop();
	lcd_clear();
	lcd_locate(0,0);
	lcd_printf("Jacob Hutter\n");
        lcd_locate(0,1);
        lcd_printf("Elijah Baird\n");
        lcd_locate(0,2);
        lcd_printf("Rohan Kasiviswanathan\n");
        lcd_locate(0,3);
        lcd_printf("---------------------\n");
        lcd_locate(0,7);
        lcd_printf("Counter: 0x0, 0");
        uint32_t i = 0;
        uint8_t press_counter1 = 0;
        uint8_t button_counter = 0;
        uint8_t press_counter2 = 0;
        uint8_t button_mask = 0x03;
	while(1){
            if((i%25000) == 0)
                TOGGLELED(LED4_PORT);

            if (PORTEbits.RE8 == 0 && (button_mask & 0x01))
                press_counter1++;
            else if (PORTEbits.RE8 == 1 && !(button_mask & 0x01))
                press_counter1++;
            else
                press_counter1 = 0;

            if (PORTDbits.RD10 == 0 && (button_mask & 0x02))
                press_counter2++;
            else if (PORTDbits.RD10 == 1 && !(button_mask & 0x02))
                press_counter2++;
            else
                press_counter2 = 0;

            if(press_counter1 >= PRESSED){
                lcd_locate(9,7);
                if((button_mask & 0x01)){
                    button_counter++;
                    lcd_printf("0x%x, %d   ",button_counter, button_counter);
                }
                TOGGLELED(LED1_PORT);
                button_mask ^= 0x01; // toggle bit mask
            }

            if(press_counter2 >= PRESSED){
                button_mask ^= 0x02; // toggle bit mask
                TOGGLELED(LED2_PORT);
            }

            if(button_mask == 0x00 || button_mask == 0x3){
                CLEARLED(LED3_PORT);
            }
            else
                SETLED(LED3_PORT);


            i++;
	}
}

