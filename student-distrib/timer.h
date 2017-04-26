/* rtc.h - Defines used in working with RTC
 * vim:ts=4 noexpandtab
 */

#ifndef _RTC_H
#define _RTC_H

#include "lib.h"
#include "i8259.h"
#include "interrupt_handler.h"
#include "keyboard.h"
#include "types.h"
#include "sys_call_handler.h"

#define PIT_IRQ     0
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
#define RTC_A_INIT  0x26
#define RTC_B_INIT  0x66
#define RTC_BASE_FREQ  1024 /* to virtualize RTC */
#define RTC_INIT_FREQ  2

extern void pit_init();
extern void rtc_init();
extern int32_t rtc_open(const uint8_t* junk);
extern int32_t rtc_read(int32_t fd, void *buf, int32_t bytes);
extern int32_t rtc_write (int32_t fd, const char* buf, int32_t nbytes);
extern int32_t rtc_close(int32_t fd);
extern void test_rtc();

#endif
