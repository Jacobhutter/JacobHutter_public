#include <p33Fxxxx.h>
//do not change the order of the following 3 definitions
#define FCY 12800000UL 
#include <stdio.h>
#include <libpic30.h>
#include "flex_serial.h"
#include "pc_crc16.h"
#include "lcd.h"
#include "crc16.h"
#include "led.h"

/* Initial configuration by EE */
// Primary (XT, HS, EC) Oscillator with PLL
_FOSCSEL(FNOSC_PRIPLL);

// OSC2 Pin Function: OSC2 is Clock Output - Primary Oscillator Mode: XT Crystal
_FOSC(OSCIOFNC_OFF & POSCMD_XT); 

// Watchdog Timer Enabled/disabled by user software
_FWDT(FWDTEN_OFF);

// Disable Code Protection
_FGS(GCP_OFF);  

volatile uint8_t t2Flag = 0;
uint32_t milisecs = 0;
uint16_t transfail = 0;

uint8_t get_char(){
    uint8_t ret;
    while (!uart2_getc(&ret) && t2Flag == 0){
    }
    return ret;

}


int main(){
	__C30_UART=1;
    uart2_init(9600);

    
    led_initialize();
    lcd_initialize();
    lcd_clear();
    lcd_locate(0,0);
    lcd_printf("----- Lab 3 -----");
    lcd_locate(0,1);
    lcd_printf("Recv fail:    0times");
    lcd_locate(0,2);
    lcd_printf("CRC:   ");
    lcd_locate(0,3);
    lcd_printf("Msg:   ");
    lcd_locate(4,3);

	//TODO: Setup 1 second timer for exiting out of a message of corrupted length
    //__builtin_write_OSCCONL(OSCCONL | 2);
    CLEARBIT(T2CONbits.TON);     // Disable Timer
    CLEARBIT(T2CONbits.TCS);    // Select internal instruction cycle clock
    CLEARBIT(T2CONbits.TGATE);  // Disable Gated Timer mode
    TMR2 = 0x00;                // Clear timer register
    T2CONbits.TCKPS = 0b11;     // Select 1:256 Prescaler
    CLEARBIT(IFS0bits.T2IF);    // Clear Timer2 interrupt status flag
    CLEARBIT(IEC0bits.T2IE);    // Disable Timer2 interrupt enable control bit
    PR2 = 100;              // Set timer period 4ms: //100 = .002 * 12.8*10^6 * 1/256
    IPC1bits.T2IP = 0x01;
    IFS0bits.T2IF = 0;          // Clear Timer2 Interrupt Flag
    IEC0bits.T2IE = 1;          // Enable Timer2 interrupt

    uint8_t high_crc = 0x00, low_crc = 0x00;
    uint8_t length = 0;
    uint8_t cur_char;
    uint8_t recieving = 0;
    uint16_t sent_CRC = 0x0000, calculated_CRC = 0x0000;
    char msg[256];
    uint8_t ack_sent = 0;
    uint16_t i = 0;
    

	while(1){
            cur_char = get_char();
            if (cur_char == 0x00 && recieving == 0){ //get start byte
                calculated_CRC = 0x0000;
                T2CONbits.TON = 1;      // Start Timer2
                IFS0bits.T2IF = 0;
                recieving = 1;

                high_crc = get_char(); // get high byte of crc
                low_crc = get_char(); // get low byte of crc
                sent_CRC = (high_crc << 8) | (low_crc & 0x00FF);

                length = get_char(); // get length
                for(i = 0; i< length && t2Flag == 0; i++){
                    msg[i] = get_char();
                    calculated_CRC = crc_update(calculated_CRC, msg[i]);
                }

                // Stop Timer2
                T2CONbits.TON = 0;
                TMR2 = 0x00; //Clear timer register
                t2Flag = 0;
                milisecs = 0;

                msg[i] = '\0';
                
                if(calculated_CRC != sent_CRC){
                    uart2_putc(0x00);
                    transfail ++;
                    // timer needs to continue if still expecting input
                    T2CONbits.TON = 1; 
                }else{ //success
                    uart2_putc(0x01);
                    ack_sent = 1;
                    T2CONbits.TON = 0;
                    IFS0bits.T2IF = 1;
                }

            }

            //update screen only if have finished attempting to recieve. 
            if (recieving == 1||t2Flag==1){
                recieving = 0; 
                if (ack_sent){
                    lcd_clear();
                    lcd_locate(0,0);
                    lcd_printf("----- Lab 3 -----");
                     lcd_locate(0,2);
                    lcd_printf("CRC:   0x%x", sent_CRC);
                    lcd_locate(0,3);
                    //Should we only print msg when it is correct?
                    lcd_printf("Msg:   %s", msg);
                    
                }
                lcd_locate(0,1);
                lcd_printf("Recv fail:    %dtimes", transfail);
                //for(i=0;i<256;i++) // flush msg
                    //msg[i] = '\0';
                
                if(ack_sent){
                    transfail = 0;
                    ack_sent = 0;
                }
                t2Flag = 0;
            }
            
        }
        return 0;
}


void __attribute__((__interrupt__)) _T2Interrupt(void){
    milisecs += 4;
    
    if (milisecs == 1000){
        TOGGLELED(LED1_PORT);
        //turn off timer, reset value to zero
        //T2CONbits.TON = 0;      // Stop Timer1
        //TMR2 = 0x00; //Clear timer register
        t2Flag = 1;//set flag of time expired
        milisecs = 0;
        uart2_putc(0x00);
        //transfail++;
        //lcd_locate(0,6);
        //lcd_printf("%d", transfail);
    }

    IFS0bits.T2IF = 0;        // clear the interrupt flag
}

