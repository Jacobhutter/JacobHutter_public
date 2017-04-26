#include "timer.h"
#define RTC_TESTCASES 8
#define RTC_TESTNUMS  16
#define RTC_ERROR_LEN 18

#define PIT_CH0     0x40
#define PIT_CMD_REG 0x43

#define PIT_CMD_START 0x36
#define PIT_CTR_LOW   0x00
#define PIT_CTR_HIGH  0x00 // A reload value of zero --> interrupts at 18.2 Hz

/* pit_init()
 * INSERT FUNCTION HEADER HERE.
 */

void pit_init() {
    outb(PIT_CMD_START, PIT_CMD_REG);
    outb(PIT_CTR_LOW, PIT_CH0);
    outb(PIT_CTR_HIGH, PIT_CH0);
    enable_irq(PIT_IRQ);
}



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

/* rtc_open(const uint8_t* junk)
 * DESCRIPTION:  Allocates new RTC clock for file descriptor
 * INPUTS:       junk - filename (but not needed for function)
 * OUTPUTS:      Index of RTC clock to store into file_position
 * RETURNS:      None
 * SIDE EFFECTS: Consumes one available RTC clock
 *
 */

int32_t rtc_open(const uint8_t* junk)
{
	return init_rtc_freq(RTC_INIT_FREQ);
}

/* rtc_read(int32_t fd, void *buf, int32_t bytes)
 * DESCRIPTION:  Pauses for the next RTC clock tick
 * INPUTS:       fd - file descriptor to obtain index to examine for ticks
 *               buf, bytes - junk that don't do anything
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

/* rtc_write(int32_t fd, const char* buf, int32_t nbytes)
 * DESCRIPTION:  Sets RTC clock frequency for process
 * INPUTS:       fd - file descriptor to obtain index to examine for ticks
 *               buf - region in memory that holds frequency to set RTC
 *               nbytes - size of memory, in bytes, that contains frequency
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

/* rtc_close(int32_t fd)
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
