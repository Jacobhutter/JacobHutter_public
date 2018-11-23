#ifndef FLEXMOTOR_H
#define	FLEXMOTOR_H
#include "led.h"
#include "lcd.h"
#include <math.h>
#include <stdlib.h>

void motor_init();
void motor_set_duty(uint8_t channel, uint16_t duty_us);



#endif	/* FLEXMOTOR_H */

