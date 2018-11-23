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
uint8_t seconds = 0;
uint8_t minutes = 0;
uint16_t milliseconds = 0;
uint8_t counter = 0;
volatile uint8_t button_flag = 0;
uint16_t hundred_nanoseconds = 0;
void main(){
	//Init LCD
	__C30_UART=1;	
	lcd_initialize();
        led_initialize();

	lcd_clear();
	lcd_locate(0,0);
	lcd_printf("Jacob Hutter\n");
        lcd_locate(0,1);
        lcd_printf("Elijah Baird\n");
        lcd_locate(0,2);
        lcd_printf("---------------------\n");
        lcd_locate(0,3);

        __builtin_write_OSCCONL(OSCCONL | 2);
        T1CONbits.TON = 0; //Disable Timer
        T1CONbits.TCS = 1; //Select external clock
        T1CONbits.TSYNC = 0; //Disable Synchronization
        T1CONbits.TCKPS = 0b00; //Select 1:1 Prescaler
        TMR1 = 0x00; //Clear timer register
        PR1 = 32767; //Load the period value
        IPC0bits.T1IP = 0x01; // Set Timer1 Interrupt Priority Level
        IFS0bits.T1IF = 0; // Clear Timer1 Interrupt Flag
        IEC0bits.T1IE = 1;// Enable Timer1 interrupt
        

        CLEARBIT(T2CONbits.TON);     // Disable Timer
        CLEARBIT(T2CONbits.TCS);    // Select internal instruction cycle clock
        CLEARBIT(T2CONbits.TGATE);  // Disable Gated Timer mode
        TMR2 = 0x00;                // Clear timer register
        T2CONbits.TCKPS = 0b11;     // Select 1:256 Prescaler
        CLEARBIT(IFS0bits.T2IF);    // Clear Timer2 interrupt status flag
        CLEARBIT(IEC0bits.T2IE);    // Disable Timer2 interrupt enable control bit
        PR2 = 50;                 // Set timer period 2ms: // 100= 2*10^-3 * 12.8*10^6 * 1/256
        IPC1bits.T2IP = 0x01;
        IFS0bits.T2IF = 0;          // Clear Timer2 Interrupt Flag
        IEC0bits.T2IE = 1;          // Enable Timer2 interrupt


        T3CONbits.TON = 0;     // Disable Timer
        T3CONbits.TCS = 0;    // Select internal instruction cycle clock
        T3CONbits.TGATE = 0;  // Disable Gated Timer mode
        T3CONbits.TCKPS = 0b00;     // Select 1:1 Prescaler
        TMR3 = 0x00;                // Clear timer register
        IFS0bits.T3IF = 0;    // Clear Timer3 interrupt status flag
        IEC0bits.T3IE = 0;    // Disable Timer3 interrupt enable control bit
        IPC2bits.T3IP = 0x01;
        IFS0bits.T3IF = 0;      // Clear Timer3 Interrupt Flag
        IEC0bits.T3IE = 0;      // Enable Timer3 interrupt

        
        T1CONbits.TON = 1;      // Start Timer1
        T2CONbits.TON = 1;      /* Turn Timer 2 on */
        T3CONbits.TON = 1;      /* Turn Timer 3 on */

        

        AD1PCFGHbits.PCFG20 = 1;  //ADC1 Port Configuration Register High Channel 20
        Nop();
        TRISEbits.TRISE8 = 1;    //PortE Pin 8 I/O Configuration
        Nop();
        IEC1bits.INT1IE = 1;     //Interrupt Enable Control Register 1                            //External Interrupt 1 Enable bit
        IPC5bits.INT1IP = 1;    //Interrupt Priority Control Register 5    //External Interrupt 1 Priority bits
        IFS1bits.INT1IF = 0;    //Interrupt Flag Status Register 1
        INTCON2bits.INT1EP = 1;



        uint32_t iterate_me = 0;
        uint16_t loop_time = 0;
	while(1){
            TMR3 = 0x00;
            TOGGLELED(LED4_PORT);
            if(iterate_me % 2000 == 0){
                if (milliseconds >= 1000 ){
                    seconds++;
                    milliseconds = 0;
                 }
                 if(seconds >= 60){
                    minutes++;
                    seconds = 0;
                }
                lcd_locate(0,3);
                lcd_printf("%i%i:%i%i.%u%u%u ", minutes/10, minutes%10, seconds/10,
                seconds%10, milliseconds/100, (milliseconds/10) % 10, milliseconds%10);
                lcd_locate(0,4);
                lcd_printf("%u", TMR3);
                loop_time = TMR3/12800;
                lcd_locate(0,5);
                lcd_printf("0.%u%u%u%u", (loop_time/1000)%10,(loop_time/100)%10,(loop_time/10)%10 ,loop_time%10);
            }
            iterate_me++;
            
	}
}


void __attribute__((__interrupt__)) _T1Interrupt(void){
    TOGGLELED(LED2_PORT)        // Increment a global counter
    IFS0bits.T1IF = 0;        // clear the interrupt flag
}

void __attribute__((__interrupt__)) _INT1Interrupt(void){
    seconds = 0;
    milliseconds = 0;
    minutes = 0;
    IFS1bits.INT1IF = 0; //Interrupt Flag Status Register 1
}

void __attribute__((__interrupt__)) _T2Interrupt(void){
    milliseconds++;
    if(milliseconds % 2 == 0)
        TOGGLELED(LED1_PORT)        // Increment a global counter
    IFS0bits.T2IF = 0;        // clear the interrupt flag
}

void __attribute__((__interrupt__)) _T3Interrupt(void){// never entered
    IFS0bits.T3IF = 0;        // clear the interrupt flag
}


