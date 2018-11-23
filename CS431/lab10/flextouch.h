#ifndef FLEXTOUCH_H
#define	FLEXTOUCH_H
#include "led.h"
#include "lcd.h"
#include "types.h"
#include <p33Fxxxx.h>
#define FCY 12800000UL
#include <libpic30.h>


void touch_init();
void touch_select_dim(uint8_t select);
int SampleADC_Y();
int SampleADC_X();
#endif	/* FLEXTOUCH_H */

