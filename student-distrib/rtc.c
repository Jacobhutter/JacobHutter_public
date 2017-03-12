#include "rtc.h"

void rtc_init() {
	uint32_t junk;

	outb(RTC_ADDR, RTC_A);
	outb(RTC_DATA, RTC_A_INIT);
	outb(RTC_ADDR, RTC_B);
	outb(RTC_DATA, RTC_B_INIT);
	outb(RTC_ADDR, RTC_C);
	junk = inb(RTC_DATA);
	enable_irq(RTC_IRQ);
	//disable_irq(RTC_IRQ);
}
