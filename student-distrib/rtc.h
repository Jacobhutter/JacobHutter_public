#ifndef _RTC_H
#define _RTC_H

#include "lib.h"
#include "i8259.h"

#define RTC_IRQ     8

/* Ports to write to RTC */
#define RTC_ADDR    0x70
#define RTC_DATA    (RTC_ADDR + 1)

/* Addresses of registers to write into for RTC */
#define RTC_A       0x0A
#define RTC_B       0x0B
#define RTC_C       0x0C

/* Initial values of RTC internal registers
 * Starts clock and enables periodic and alarm interrupts
 * Alarm interrupts will be a possibility for extra credit
 */
#define RTC_A_INIT  0x2F
#define RTC_B_INIT  0x66

extern void rtc_init();

#endif
