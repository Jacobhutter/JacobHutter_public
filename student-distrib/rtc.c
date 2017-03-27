#include "rtc.h"
#define RTC_TESTCASES 8
#define RTC_TESTNUMS  16
#define RTC_ERROR_LEN 18

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

/* rtc_read()
 * DESCRIPTION:  Pauses for the next RTC clock tick
 * INPUTS:       None
 * OUTPUTS:      None
 * RETURNS:      Zero, to guarantee success
 * SIDE EFFECTS: Forces caller to wait for next clock tick
 */
int32_t rtc_read() {
	rtc_wait();
	return 0;
}

/* rtc_write()
 * DESCRIPTION:  Sets RTC clock frequency for process
 * INPUTS:       freq - RTC frequency, must be a power of two
 *                      between 2 and 1024 Hz, inclusive
 * OUTPUTS:      None
 * RETURNS:      Zero, if freq is valid; -1 else
 * SIDE EFFECTS: Changes RTC clock frequency
 */
int32_t rtc_write(int32_t freq) {
	// quick trick to check if power of two
	if(freq >= RTC_INIT_FREQ && freq <= RTC_BASE_FREQ && (freq & (freq-1)) == 0) {
		set_rtc_freq(freq);
		return 0;
	} else {
		return -1;
	}
}

/* rtc_close()
 * DESCRIPTION:  Does nothing! RTC clock will not be allowed to shut down
 * INPUTS:       none
 * OUTPUTS:      None
 * RETURNS:      Zero
 * SIDE EFFECTS: None
 */
int32_t rtc_close() {
	return 0;
}

/* test_rtc()
 * DESCRIPTION:  Tests RTC clock by attempting to print a through p
 *               Runs one testcase at the initial frequency of 2 Hz
 *               Then eight testcases at various frequencies
 * INPUTS:       none
 * OUTPUTS:      If frequency is valid, letters a through p at the RTC frequency
 *               If invalid, prints an error message
 * RETURNS:      Zero
 * SIDE EFFECTS: Prints testcase lines to monitor
 */
void test_rtc() {
	int freqs[RTC_TESTCASES] = {2, 16, 45, 1, 2048, -2, 8, 1024};
    int i, j; 
    uint8_t letter;
    uint8_t err_message[RTC_ERROR_LEN] = "Invalid frequency!";

    // Checking for initial frequency
    for(j = 0; j < RTC_TESTNUMS; j++) {
        letter = 'a' + j;
        (void)rtc_read();
        terminal_write(&letter, SIZEOF_CHAR);
    }
    letter = '\n';
    terminal_write(&letter, SIZEOF_CHAR);

    // Should be no change at this transition
	for(i = 0; i < RTC_TESTCASES; i++) {
        if(rtc_write(freqs[i]) == 0) {
            for(j = 0; j < 16; j++) {
                letter = 'a' + j;
                (void)rtc_read();
                terminal_write(&letter, SIZEOF_CHAR);
            }
        } else {
            terminal_write((void*)err_message, RTC_ERROR_LEN*SIZEOF_CHAR);
        }
        letter = '\n';
    	terminal_write(&letter, SIZEOF_CHAR);
   	}
}
