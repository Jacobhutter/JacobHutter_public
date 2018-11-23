#include <p33Fxxxx.h>
//do not change the order of the following 3 definitions
#define FCY 12800000UL
#include <stdio.h>
#include <stdlib.h>
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

int SampleADC_X(){
    AD1CHS0bits.CH0SA = 0x9; //set ADC to Sample AN9 pin
    SETBIT(AD1CON1bits.SAMP); //start to sample
    while(!AD1CON1bits.DONE); //wait for conversion to finish
    CLEARBIT(AD1CON1bits.DONE); //MUST HAVE! clear conversion done bit
    return 0x0fff & ADC1BUF0; //return sample
}

int SampleADC_Y(){
    AD1CHS0bits.CH0SA = 0xF; //set ADC to Sample AN15 pin
    SETBIT(AD1CON1bits.SAMP); //start to sample
    while(!AD1CON1bits.DONE); //wait for conversion to finish
    CLEARBIT(AD1CON1bits.DONE); //MUST HAVE! clear conversion done bit
    return 0x0fff & ADC1BUF0; //return sample
}

void SetupTouch_X(){
    //set up the I/O pins E1, E2, E3 so that the touchscreen X-coordinate pin
    //connects to the ADC
    CLEARBIT(LATEbits.LATE1);
    SETBIT(LATEbits.LATE2);
    SETBIT(LATEbits.LATE3);
    //SETBIT(T2CONbits.TON); // start Timer
    __delay_ms(10);
   // CLEARBIT(T2CONbits.TON); // stop Timer
}

void SetupTouch_Y(){
    //set up the I/O pins E1, E2, E3 so that the touchscreen X-coordinate pin
    //connects to the ADC
    SETBIT(LATEbits.LATE1);
    CLEARBIT(LATEbits.LATE2);
    CLEARBIT(LATEbits.LATE3);
    //SETBIT(T2CONbits.TON); // start Timer
    __delay_ms(10);
    //CLEARBIT(T2CONbits.TON); // stop Timer
}

void SetupADC(){
    //disable ADC1
    CLEARBIT(AD1CON1bits.ADON);
    //initialize PIN

    SETBIT(TRISBbits.TRISB9); //set TRISB RB9 to input y axis
    CLEARBIT(AD1PCFGLbits.PCFG9); //set AD1 AN9 input pin as analog
    
    SETBIT(TRISBbits.TRISB15); //set TRISB RB15 to input x axis
    CLEARBIT(AD1PCFGLbits.PCFG15); //set AD1 BN15 input pin as analog


    //Configure AD1CON1
    SETBIT(AD1CON1bits.AD12B); //set 12b Operation Mode
    AD1CON1bits.FORM = 0; //set integer output
    AD1CON1bits.SSRC = 0x7; //set automatic conversion
    //Configure AD1CON2
    AD1CON2 = 0; //not using scanning sampling
    //Configure AD1CON3
    CLEARBIT(AD1CON3bits.ADRC); //internal clock source
    AD1CON3bits.SAMC = 0x1F; //sample-to-conversion clock = 31Tad
    AD1CON3bits.ADCS = 0x2; //Tad = 3Tcy (Time cycles)
    //Leave AD1CON4 at its default value
    //enable ADC
    SETBIT(AD1CON1bits.ADON);

    //set up the I/O pins E1, E2, E3 to be output pins
    CLEARBIT(TRISEbits.TRISE1); //I/O pin set to output
    CLEARBIT(TRISEbits.TRISE2); //I/O pin set to output
    CLEARBIT(TRISEbits.TRISE3); //I/O pin set to output
}

uint16_t * sort_me(uint16_t * arr){
    uint8_t i = 0,j=0;
    uint16_t temp;
    for(j = 0; j<5; j++){
        for(i = 0; i<4; i++){
            if(arr[i] > arr[i+1]){
                temp = arr[i+1];
                arr[i+1] = arr[i];
                arr[i] = temp;
            }
        }
    }
    return arr;
}

int main(){
    //Init LCD
    __C30_UART=1;
    lcd_initialize();
    led_initialize();
    lcd_clear();
    lcd_locate(0,0);
    lcd_printf("--- Lab 06 ---");
    lcd_locate(0,6);
    lcd_printf("Ball X position=");
    lcd_locate(0,7);
    lcd_printf("Ball Y position=");

    uint16_t X_touch_vals[5];
    uint16_t Y_touch_vals[5];
    uint16_t i = 0;
    SetupADC();
    while(1){
        
        SetupTouch_X();
        for (i = 0; i < 5; i++)
            Y_touch_vals[i] = SampleADC_Y();
        
        
        //setup x for sampling
        
        SetupTouch_Y();
        Nop();
        for (i = 0; i < 5; i++)
            X_touch_vals[i] = SampleADC_X();
        

        
        sort_me(X_touch_vals);
        sort_me(Y_touch_vals);
        lcd_locate(16,6);
        lcd_printf("%u ", 0x0fff & Y_touch_vals[2]);
        lcd_locate(16,7);
        lcd_printf("%u ", 0x0fff & X_touch_vals[2]);

        //spin to give time for LCD to update
        for(i = 0; i < 0x8FFF; i++);
    }
    return (int)0;
}
