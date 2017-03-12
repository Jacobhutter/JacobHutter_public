#include "rtc.h"

void rtc_init() {
	enable_irq(RTC_IRQ);
	outb(RTC_ADDR, RTC_A);
	outb(RTC_DATA, RTC_A_INIT);
	outb(RTC_ADDR, RTC_B);
	outb(RTC_DATA, RTC_B_INIT);
	disable_irq(RTC_IRQ);
}