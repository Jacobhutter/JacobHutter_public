#include "flexmotor.h"

void motor_init(){
  //setup Timer 2
  CLEARBIT(T2CONbits.TON); // Disable Timer
  CLEARBIT(T2CONbits.TCS); // Select internal instruction cycle clock
  CLEARBIT(T2CONbits.TGATE); // Disable Gated Timer mode
  TMR2 = 0x00; // Clear timer register
  T2CONbits.TCKPS = 0b10; // Select 1:64 Prescaler
  IFS0bits.T2IF = 0;          // Clear Timer2 Interrupt Flag
  IEC0bits.T2IE = 0;          // Enable Timer2 interrupt
  PR2 = 4000; // Set timer period 20ms 4000= 20*10^-3 * 12.8*10^6 * 1/64
  SETBIT(T2CONbits.TON); /* Turn Timer 2 on */
  CLEARBIT(TRISDbits.TRISD7); /* Set OC8 as output */
  CLEARBIT(TRISDbits.TRISD6); /* Set OC7 as output */

  OC7CON = 0x0006; /* Set OC7: PWM, no fault check, Timer2 */
  OC8CON = 0x0006; /* Set OC8: PWM, no fault check, Timer2 */
    
}

void motor_set_duty(uint8_t channel, uint16_t duty_us){
    float ratio = (duty_us/20)*4;
    duty_us = 4000 - (int)ratio;
    if(channel == 1){
        //setup OC8
        
        OC8R = duty_us; /* Set the initial duty cycle to 1.5ms*/
        OC8RS = duty_us; /* Load OCRS: next pwm duty cycle */
        
    }
    else{
        //setup OC8
        
        OC7R = duty_us; /* Set the initial duty cycle to 1.5ms*/
        OC7RS = duty_us; /* Load OCRS: next pwm duty cycle */
        
    }
}