#include "flextouch.h"


void touch_init(){
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

void touch_select_dim(uint8_t select){
    if(select == 1) {
        //set up the I/O pins E1, E2, E3 so that the touchscreen X-coordinate pin
        //connects to the ADC
        CLEARBIT(LATEbits.LATE1);
        SETBIT(LATEbits.LATE2);
        SETBIT(LATEbits.LATE3);
        __delay_ms(10);
    }
    else{
        //set up the I/O pins E1, E2, E3 so that the touchscreen X-coordinate pin
        //connects to the ADC
        SETBIT(LATEbits.LATE1);
        CLEARBIT(LATEbits.LATE2);
        CLEARBIT(LATEbits.LATE3);
        __delay_ms(10);
    }
}

int SampleADC_Y(){
    AD1CHS0bits.CH0SA = 0x9; //set ADC to Sample AN9 pin
    SETBIT(AD1CON1bits.SAMP); //start to sample
    while(!AD1CON1bits.DONE); //wait for conversion to finish
    CLEARBIT(AD1CON1bits.DONE); //MUST HAVE! clear conversion done bit
    return 0x0fff & ADC1BUF0; //return sample
}

int SampleADC_X(){
    AD1CHS0bits.CH0SA = 0xF; //set ADC to Sample AN15 pin
    SETBIT(AD1CON1bits.SAMP); //start to sample
    while(!AD1CON1bits.DONE); //wait for conversion to finish
    CLEARBIT(AD1CON1bits.DONE); //MUST HAVE! clear conversion done bit
    return 0x0fff & ADC1BUF0; //return sample
}


