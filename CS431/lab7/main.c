#include <p33Fxxxx.h>
//do not change the order of the following 3 definitions
#define FCY 12800000UL
#include <stdio.h>
#include <stdlib.h>
#include <libpic30.h>
#include "led.h"
#include "lcd.h"
#include <math.h>

/* Initial configuration by EE */
// Primary (XT, HS, EC) Oscillator with PLL
_FOSCSEL(FNOSC_PRIPLL);

// OSC2 Pin Function: OSC2 is Clock Output - Primary Oscillator Mode: XT Crystal
_FOSC(OSCIOFNC_OFF & POSCMD_XT);

// Watchdog Timer Enabled/disabled by user software
_FWDT(FWDTEN_OFF);

// Disable Code Protection
_FGS(GCP_OFF);

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
    SETBIT(T2CONbits.TON); /* Turn Timer 2 on */
}

void timer1_setup(){
    //setup Timer 2
    CLEARBIT(T1CONbits.TON); // Disable Timer
    CLEARBIT(T1CONbits.TCS); // Select internal instruction cycle clock
    CLEARBIT(T1CONbits.TGATE); // Disable Gated Timer mode
    TMR1 = 0x00; // Clear timer register
    T1CONbits.TCKPS = 0b10; // Select 1:64 Prescaler
    IFS0bits.T1IF = 0;          // Clear Timer2 Interrupt Flag
    IEC0bits.T1IE = 1;          // Enable Timer2 interrupt
    PR1 = 10000; // Set timer period 50ms 10000= 50*10^-3 * 12.8*10^6 * 1/64
    SETBIT(T1CONbits.TON); /* Turn Timer 1 on */
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

uint16_t pwm_x = 3700, pwm_y = 3600;
uint16_t max_x = 3032, min_x = 295;
uint16_t mid_x = ((3032 - 295)/2);
uint8_t t1flag = 0;
int force_low = -3000;
int force_high = 3000;
void findPwm(int force){
    if(force < force_low)
        force = force_low;
    if(force > force_high)
        force = force_high;

    unsigned int pos_force = force + abs(force_low);
    float ratio = (float)pos_force/(force_high-force_low);
    ratio = (ratio*(2.1-.9) + .9); //
    ratio = (ratio/20)*4000;
    pwm_x = 4000-(int)ratio;
    
}


int main(){
    double Kp = 1.5;
    double Kd = 0.50;
    double Ki = 0.5;
    //Init LCD
    __C30_UART=1;
    lcd_initialize();
    led_initialize();
    lcd_clear();
    lcd_locate(0,0);
    lcd_printf("--- Lab 07 ---");
    lcd_locate(0,1);
    lcd_printf("F_x: ");
    lcd_locate(0,2);
    lcd_printf("I_x: ");
    lcd_locate(0,3);
    lcd_printf("D_x: ");
    lcd_locate(0,4);
    lcd_printf("P_x: ");
    lcd_locate(0,5);
    lcd_printf("Set_x: %u", mid_x);
    lcd_locate(0,6);
    lcd_printf("Ki:%f", Ki);
    lcd_locate(0,7);
    lcd_printf("Kp:%f", Kp);
    lcd_locate(8,7);
    lcd_printf(",Kd:%f", Kd);



    uint16_t X_touch_vals[5];
    uint32_t print_count = 0;
    uint16_t Xposition_buf[3];
    uint8_t circular_index = 0, i = 0;
    int16_t x_deriv;
    int16_t x_pos = 0;
    long int x_int = 0;
    int F_x = 0;

    SetupADC();     // setup adc to sample touch screen
    timer2_setup(); // setup timer2 20ms but do not start
    timer1_setup(); // setup timer1 50ms and start
    SetupTouch_X();

    while(1){
        if(print_count % 1000 == 0){
            lcd_locate(5,1);
            lcd_printf("%d     ", F_x);
            lcd_locate(5,2);
            lcd_printf("%ld     ", x_int);
            lcd_locate(5,3);
            lcd_printf("%d     ", x_deriv);
            lcd_locate(5,4);
            lcd_printf("%u ", Xposition_buf[circular_index]);

        }
        if(t1flag){
            for (i = 0; i < 5; i++)
                X_touch_vals[i] = SampleADC_X();
            sort_me(X_touch_vals);
            Xposition_buf[circular_index] = X_touch_vals[2];
            x_pos = Xposition_buf[circular_index] - mid_x;
            x_deriv = (Xposition_buf[circular_index] -  Xposition_buf[(circular_index - 1 + 3)%3])
                    / 0.05;
            x_int -= ((int)mid_x - (int)Xposition_buf[circular_index]) * 0.05;
            circular_index = (++circular_index%3); // assign position
            t1flag = 0;

            //Calculate next force
            F_x = (int32_t)(-Kp * (float)x_pos - Kd * x_deriv - Ki * x_int);
            findPwm(F_x);
            //ouptut Next force on servo
        }
        print_count++;
    }
    return (int)0;
}

uint16_t t2count = 0;
void __attribute__((__interrupt__)) _T2Interrupt(void){
    if(t2count < 10){
        t2count++;
        OCY_set(pwm_y); // push board to the right
    }
    else
        OCY_set(0); // stop y direction servos
    OCX_set(pwm_x); // send inverted ms
    IFS0bits.T2IF = 0;        // clear the interrupt flag
}

void __attribute__((__interrupt__)) _T1Interrupt(void){
    t1flag = 1;
    IFS0bits.T1IF = 0;        // clear the interrupt flag
}

