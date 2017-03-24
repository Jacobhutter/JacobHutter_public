#include "rtc.h"

/* rtc_init()
 * DESCRIPTION:  Intitializes the real-time clock
 * INPUTS:       None
 * OUTPUTS:      None
 * RETURNS:      None
 * SIDE EFFECTS: Intializes RTC to generate interrupts at 2 Hz
 *
 */
void rtc_init() {
	uint32_t junk; // Sanity check to make sure that interrupts are enabled

	outb(RTC_A, RTC_ADDR);
	outb(RTC_A_INIT, RTC_DATA);
	outb(RTC_B, RTC_ADDR);
	outb(RTC_B_INIT, RTC_DATA);
	outb(RTC_C, RTC_ADDR);
	junk = inb(RTC_DATA); // sanity check
	enable_irq(RTC_IRQ);
}
