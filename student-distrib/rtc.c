#include "rtc.h"
#define RTC_TESTCASES 8
#define RTC_TESTNUMS  16
#define RTC_ERROR_LEN 18

/* rtc_init()
 * DESCRIPTION:  Intitializes the real-time clock
 * INPUTS:       None
 * OUTPUTS:      None
 * RETURNS:      None
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

int32_t rtc_open(const uint8_t* junk)
{
	return init_rtc_freq(RTC_INIT_FREQ);
}

/* rtc_read() - WRITE FUNCTION HEADER HERE
 * DESCRIPTION:  Pauses for the next RTC clock tick
 * INPUTS:       None
 * OUTPUTS:      None
 * RETURNS:      Zero, to guarantee success
 * SIDE EFFECTS: Forces caller to wait for next clock tick
 */
int32_t rtc_read(int32_t fd, void *buf, int32_t bytes) {
    PCB_t* process;
    file_t file;

    process = get_PCB();

    file = process->file_descriptor[fd];

	rtc_wait(file.file_position);
	return 0;
}

/* rtc_write() - WRITE FUNCTION HEADER HERE
 * DESCRIPTION:  Sets RTC clock frequency for process
 * INPUTS:       freq - RTC frequency, must be a power of two
 *                      between 2 and 1024 Hz, inclusive
 * OUTPUTS:      None
 * RETURNS:      Zero, if freq is valid; -1 else
 * SIDE EFFECTS: Changes RTC clock frequency
 */
int32_t rtc_write(int32_t fd, const char* buf, int32_t nbytes) {
    PCB_t* process;
    file_t file;
	int freq;
    
    process = get_PCB();

    file = process->file_descriptor[fd];

	memcpy(&freq, buf, nbytes);

	// quick trick to check if power of two
	if(freq >= RTC_INIT_FREQ && freq <= RTC_BASE_FREQ && (freq & (freq-1)) == 0) {
		set_rtc_freq(freq, file.file_position);
		return 0;
	} else {
		return -1;
	}
}

/* rtc_close()
 * DESCRIPTION:  De-allocates the slot given to the file descriptor
 * INPUTS:       fd - file descriptor
 * OUTPUTS:      None
 * RETURNS:      Zero
 * SIDE EFFECTS: None
 */
int32_t rtc_close(int32_t fd) {
	PCB_t* process;
    file_t file;

    process = get_PCB();

    file = process->file_descriptor[fd];

    set_rtc_freq(0, file.file_position);
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
        (void)rtc_read(0, 0, 0);
        terminal_write(&letter, SIZEOF_CHAR);
    }
    letter = '\n';
    terminal_write(&letter, SIZEOF_CHAR);

    // Should be no change at this transition
	for(i = 0; i < RTC_TESTCASES; i++) {
        if(rtc_write(0, (const char*)&freqs[i], 4) == 0) {
            for(j = 0; j < 16; j++) {
                letter = 'a' + j;
                (void)rtc_read(0, 0, 0);
                terminal_write(&letter, SIZEOF_CHAR);
            }
        } else {
            terminal_write((void*)err_message, RTC_ERROR_LEN*SIZEOF_CHAR);
        }
        letter = '\n';
    	terminal_write(&letter, SIZEOF_CHAR);
   	}
}
