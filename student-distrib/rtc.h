#ifndef _RTC_H
#define _RTC_H

#include "lib.h" 
#include "i8259.h"

#define RTC_IRQ     8
#define RTC_ADDR    0x70
#define RTC_DATA    (RTC_ADDR + 1)
#define RTC_A       0x0A
#define RTC_B       0x0B
#define RTC_C       0x0C
#define RTC_A_INIT  0x2F
#define RTC_B_INIT  0x6E

extern void rtc_init();

#endif