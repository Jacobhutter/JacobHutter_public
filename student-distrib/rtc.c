#include "rtc.h"

void rtc_init() {
	uint32_t junk;

	outb(RTC_A, RTC_ADDR);
	outb(RTC_A_INIT, RTC_DATA);
	outb(RTC_B, RTC_ADDR);
	outb(RTC_B_INIT, RTC_DATA);
	outb(RTC_C, RTC_ADDR);
	junk = inb(RTC_DATA);
	enable_irq(RTC_IRQ);
}
