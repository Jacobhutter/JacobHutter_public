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

void timer2_setup(){
    //setup Timer 2
    CLEARBIT(T2CONbits.TON); // Disable Timer
    CLEARBIT(T2CONbits.TCS); // Select internal instruction cycle clock
    CLEARBIT(T2CONbits.TGATE); // Disable Gated Timer mode
    TMR2 = 0x00; // Clear timer register
    T2CONbits.TCKPS = 0b10; // Select 1:64 Prescaler
    IFS0bits.T2IF = 0;          // Clear Timer2 Interrupt Flag
    IEC0bits.T2IE = 1;          // Enable Timer2 interrupt
    PR2 = 4000; // Set timer period 20ms 4000= 20*10^-3 * 12.8*10^6 * 1/64
}

void OCX_set(uint16_t pwm){
    //setup OC8
    CLEARBIT(TRISDbits.TRISD7); /* Set OC8 as output */
    OC8R = pwm; /* Set the initial duty cycle to 1.5ms*/
    OC8RS = pwm; /* Load OCRS: next pwm duty cycle */
    OC8CON = 0x0006; /* Set OC8: PWM, no fault check, Timer2 */
}

void OCY_set(uint16_t pwm){
    //setup OC8
    CLEARBIT(TRISDbits.TRISD6); /* Set OC7 as output */
    OC7R = pwm; /* Set the initial duty cycle to 1.5ms*/
    OC7RS = pwm; /* Load OCRS: next pwm duty cycle */
    OC7CON = 0x0006; /* Set OC7: PWM, no fault check, Timer2 */
}

int SampleADC_X(){
    AD2CHS0bits.CH0SA = 0x004; //set ADC to Sample AN20 pin
    SETBIT(AD2CON1bits.SAMP); //start to sample
    while(!AD2CON1bits.DONE); //wait for conversion to finish
    CLEARBIT(AD2CON1bits.DONE); //MUST HAVE! clear conversion done bit
    return 0x0fff & ADC2BUF0; //return sample
}

int SampleADC_Y(){
    AD2CHS0bits.CH0SA = 0x005; //set ADC to Sample AN20 pin
    SETBIT(AD2CON1bits.SAMP); //start to sample
    while(!AD2CON1bits.DONE); //wait for conversion to finish
    CLEARBIT(AD2CON1bits.DONE); //MUST HAVE! clear conversion done bit
    return 0x0fff & ADC2BUF0; //return sample
}

void SetupADC(){
    //disable ADC
    CLEARBIT(AD2CON1bits.ADON);
    //initialize PIN
    SETBIT(TRISBbits.TRISB4); //set TRISB RB4 to input
    CLEARBIT(AD2PCFGLbits.PCFG4); //set AD1 AN4 input pin as analog

    SETBIT(TRISBbits.TRISB5); //set TRISB RB5 to input
    CLEARBIT(AD2PCFGLbits.PCFG5); //set AD1 AN5 input pin as analog
    //Configure AD1CON1
    CLEARBIT(AD2CON1bits.AD12B); //set 10b Operation Mode
    AD2CON1bits.FORM = 0; //set integer output
    AD2CON1bits.SSRC = 0x7; //set automatic conversion
    //Configure AD1CON2
    AD2CON2 = 0; //not using scanning sampling
    //Configure AD2CON3
    CLEARBIT(AD2CON3bits.ADRC); //internal clock source
    AD2CON3bits.SAMC = 0x1F; //sample-to-conversion clock = 31Tad
    AD2CON3bits.ADCS = 0x2; //Tad = 3Tcy (Time cycles)
    //Leave AD2CON4 at its default value
    //enable ADC
    SETBIT(AD2CON1bits.ADON);
}

uint16_t pwm_x = 3700, pwm_y =3700;
void main(){
    //Init LCD
    __C30_UART=1;
    lcd_initialize();
    led_initialize();
    //SetupOC(); // turns on servo???
    SetupADC();

    SETBIT(AD1PCFGHbits.PCFG20); //
    Nop(); // allow for extra clock cycles
    SETBIT(TRISEbits.TRISE8); //
    Nop();
    SETBIT(TRISDbits.TRISD10);
    Nop();
    lcd_clear();
    lcd_locate(0,0);
    lcd_printf("--- Lab 05 ---");
    lcd_locate(0,1);
    lcd_printf("Joystick max X= ");
    uint8_t press_counter1 = 0;
    uint8_t press_counter2 = 0;
    uint8_t button_mask = 0x03;
    uint32_t i = 0;
    uint8_t step_counter = 0;
    uint16_t max_x = 0, min_x = 0, max_y = 0, min_y = 0;
    float cur_x = 0, cur_y =0, range =0;
    timer2_setup(); // setup 20ms clock with interrupts enabled
    while(1){
        if(i%5000 == 0){
            switch(step_counter){
                case 0:
                case 1:
                    lcd_locate(16,step_counter+1);
                    lcd_printf("%d ",0x03FF & SampleADC_X());
                    break;
                case 2:
                case 3:
                    lcd_locate(16,step_counter+1);
                    lcd_printf("%d ",0x03FF & SampleADC_Y());
                    break;
                case 4:
                    range = (max_x - min_x);
                    cur_x = (SampleADC_X() - min_x) / range;
                    pwm_x = 4000 - (((cur_x *1.2) + 0.9)*200);
                    lcd_locate(16,step_counter+1);
                    lcd_printf("%u ", pwm_x);
                    SETBIT(T2CONbits.TON); /* Turn Timer 2 on */
                    break;
                case 5:
                    range = (max_y - min_y);
                    cur_y = (SampleADC_Y() - min_y) / range;
                    pwm_y = 4000 - (((cur_y*1.2)+0.9)*200);
                    lcd_locate(16,step_counter+1);
                    lcd_printf("%u ", pwm_y);
                    break;
                case 6:
                    CLEARBIT(T2CONbits.TON); /* Turn Timer 2 off */
                    break;
                default:
                    break;
            }
        }
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
            lcd_locate(9,6);
            if((button_mask & 0x01)){
                switch(step_counter){
                    case 0:
                        max_x = 0x03FF & SampleADC_X();
                        lcd_locate(0,2);
                        lcd_printf("Joystick min X= ");
                        step_counter++;
                        break;
                    case 1:
                        min_x = 0x03FF & SampleADC_X();
                        lcd_locate(0,3);
                        lcd_printf("Joystick max Y= ");
                        step_counter++;
                        break;
                   case 2:
                        max_y = 0x03FF & SampleADC_Y();
                        lcd_locate(0,4);
                        lcd_printf("Joystick min Y= ");
                        step_counter++;
                        break;
                   case 3:
                        min_y = 0x03FF & SampleADC_Y();
                        lcd_locate(0,5);
                        lcd_printf("Pulse width X? ");
                        step_counter++;
                        break;
                   case 4:
                       lcd_locate(0,6);
                       lcd_printf("Pulse width Y? ");
                       step_counter++;
                       break;
                  case 5:
                       step_counter++;
                       break;
                   default:
                        break;
                }
            }
            button_mask ^= 0x01; // toggle bit mask
        }
        i++;
    }
    return (int)0;
}

void __attribute__((__interrupt__)) _T2Interrupt(void){
    OCX_set(pwm_x); // send inverted ms
    OCY_set(pwm_y); // send inverted ms
    IFS0bits.T2IF = 0;        // clear the interrupt flag
}




