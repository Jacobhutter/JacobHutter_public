#include "rtc.h"
#define RTC_TESTCASES 8

/* rtc_init()
 * DESCRIPTION:  Intitializes the real-time clock
 * INPUTS:       None
 * OUTPUTS:      None
 * RETURNS:      Zero, to guarantee success
 * SIDE EFFECTS: Intializes RTC to generate interrupts at 2 Hz
 *
 */
int32_t rtc_init() {
	uint32_t junk; // Sanity check to make sure that interrupts are enabled

	outb(RTC_A, RTC_ADDR);
	outb(RTC_A_INIT, RTC_DATA);
	outb(RTC_B, RTC_ADDR);
	outb(RTC_B_INIT, RTC_DATA);
	outb(RTC_C, RTC_ADDR);
	junk = inb(RTC_DATA); // sanity check
	enable_irq(RTC_IRQ);

	set_rtc_freq(RTC_INIT_FREQ);
	return 0;
}

int32_t rtc_read() {
	rtc_wait();
	return 0;
}

int32_t rtc_write(int32_t freq) {
	// quick trick to check if power of two
	if(freq >= RTC_INIT_FREQ && freq <= RTC_BASE_FREQ && (freq & (freq-1)) == 0) {
		set_rtc_freq(freq);
		return 0;
	} else {
		return -1;
	}
}

int32_t rtc_close() {
	return 0;
}

void test_rtc() {
	int freqs[RTC_TESTCASES] = {16, 2, 45, 1, 2048, -2, 8, 1024};
    int i, j; //testing for RTC driver

	for(i = 0; i < RTC_TESTCASES; i++) {
        if(rtc_write(freqs[i]) == 0) {
            for(j = 0; j < 16; j++) {
                (void)rtc_read();
                printf("%d ", j);
            }
        } else {
            printf("Invalid frequency!");
        }
        printf("\n");
    }
}