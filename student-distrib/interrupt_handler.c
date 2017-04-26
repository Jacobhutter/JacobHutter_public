/* Consult x86 ISA manual */
/* Appendix D */


#include "interrupt_handler.h"
#include "keyboard.h"

#define MAX_CLOCKS 8
//https://github.com/arjun024/mkeykernel/blob/master/keyboard_map.h
/*
* keyboard_map()
* Description: taken from the link above on how to incorporate keyboard into os,
*              describes the key press scan code to characters
* input: index
* output: none
* return value: unsigned char for the character for that scan code
*/
unsigned char keyboard_map[3][128] =
{{
    0,  27, '1', '2', '3', '4', '5', '6', '7', '8',	/* 9 */
    '9', '0', '-', '=', '\b',	/* Backspace */
    '\t',			/* Tab */
    'q', 'w', 'e', 'r',	/* 19 */
    't', 'y', 'u', 'i', 'o', 'p', '[', ']', '\n',	/* Enter key */
    0,			/* 29   - Control */
    'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';',	/* 39 */
    '\'', '`',   0,		/* Left shift */
    '\\', 'z', 'x', 'c', 'v', 'b', 'n',			/* 49 */
    'm', ',', '.', '/',   0,				/* Right shift */
    '*',
    0,	/* Alt */
    ' ',	/* Space bar */
    0,	/* Caps lock */
    0,	/* 59 - F1 key ... > */
    0,   0,   0,   0,   0,   0,   0,   0,
    0,	/* < ... F10 */
    0,	/* 69 - Num lock*/
    0,	/* Scroll Lock */
    0,	/* Home key */
    0,	/* Up Arrow */
    0,	/* Page Up */
    '-',
    0,	/* Left Arrow */
    0,
    0,	/* Right Arrow */
    '+',
    0,	/* 79 - End key*/
    0,	/* Down Arrow */
    0,	/* Page Down */
    0,	/* Insert Key */
    0,	/* Delete Key */
    0,   0,   0,
    0,	/* F11 Key */
    0,	/* F12 Key */
    0,	/* All other keys are undefined */
},
{
    0,  27, '1', '2', '3', '4', '5', '6', '7', '8',	/* 9 */
    '9', '0', '-', '=', '\b',	/* Backspace */
    '\t',			/* Tab */
    'Q', 'W', 'E', 'R',	/* 19 */
    'T', 'Y', 'U', 'I', 'O', 'P', '[', ']', '\n',	/* Enter key */
    0,			/* 29   - Control */
    'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', ';',	/* 39 */
    '\'', '`',   0,		/* Left shift */
    '\\', 'Z', 'X', 'C', 'V', 'B', 'N',			/* 49 */
    'M', ',', '.', '/',   0,				/* Right shift */
    '*',
    0,	/* Alt */
    ' ',	/* Space bar */
    0,	/* Caps lock */
    0,	/* 59 - F1 key ... > */
    0,   0,   0,   0,   0,   0,   0,   0,
    0,	/* < ... F10 */
    0,	/* 69 - Num lock*/
    0,	/* Scroll Lock */
    0,	/* Home key */
    0,	/* Up Arrow */
    0,	/* Page Up */
    '-',
    0,	/* Left Arrow */
    0,
    0,	/* Right Arrow */
    '+',
    0,	/* 79 - End key*/
    0,	/* Down Arrow */
    0,	/* Page Down */
    0,	/* Insert Key */
    0,	/* Delete Key */
    0,   0,   0,
    0,	/* F11 Key */
    0,	/* F12 Key */
    0,	/* All other keys are undefined */
},{
    0,  27, '!', '@', '#', '$', '%', '^', '&', '*',	/* 9 */
    '(', ')', '_', '+', '\b',	/* Backspace */
    '\t',			/* Tab */
    'Q', 'W', 'E', 'R',	/* 19 */
    'T', 'Y', 'U', 'I', 'O', 'P', '{', '}', '\n',	/* Enter key */
    0,			/* 29   - Control */
    'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', ':',	/* 39 */
    '\"', '~',   0,		/* Left shift */
    '|', 'Z', 'X', 'C', 'V', 'B', 'N',			/* 49 */
    'M', '<', '>', '?',   0,				/* Right shift */
    '*',
    0,	/* Alt */
    ' ',	/* Space bar */
    0,	/* Caps lock */
    0,	/* 59 - F1 key ... > */
    0,   0,   0,   0,   0,   0,   0,   0,
    0,	/* < ... F10 */
    0,	/* 69 - Num lock*/
    0,	/* Scroll Lock */
    0,	/* Home key */
    0,	/* Up Arrow */
    0,	/* Page Up */
    '-',
    0,	/* Left Arrow */
    0,
    0,	/* Right Arrow */
    '+',
    0,	/* 79 - End key*/
    0,	/* Down Arrow */
    0,	/* Page Down */
    0,	/* Insert Key */
    0,	/* Delete Key */
    0,   0,   0,
    0,	/* F11 Key */
    0,	/* F12 Key */
    0,	/* All other keys are undefined */
}};

static volatile int32_t ticks_limit[MAX_CLOCKS] = {0, 0, 0, 0, 0, 0, 0, 0};
static volatile int32_t rtc_wait_status[MAX_CLOCKS] = {0, 0, 0, 0, 0, 0, 0, 0};

/* DIVIDE_ERROR()
* INPUTS : NONE
* OUTPUTS : PRINTS TO SCREEN
* DESCRIPTION: spins in here infinitely when user throws exception
*/
void DIVIDE_ERROR() {
  /*asm volatile(
    : "pushal"
  );*/

    bsod();
    printf("DIVIDE_ERROR");
    cli(); // dont want keyboard to interfere
    /*asm volatile(
      : "popal"
      : "iret"
    );*/
    while(1);
}
/* RESERVED()
* INPUTS : NONE
* OUTPUTS : PRINTS TO SCREEN
* DESCRIPTION: spins in here infinitely when user throws exception
*/
void RESERVED() {
    printf("RESERVED");
    while (1);

}
/* NMI_INTERRUPT()
* INPUTS : NONE
* OUTPUTS : PRINTS TO SCREEN
* DESCRIPTION: spins in here infinitely when user throws exception
*/
void NMI_INTERRUPT() {
    printf("NMI_INTERRUPT");
    while (1) {
    }
}
/* BREAKPOINT()
* INPUTS : NONE
* OUTPUTS : PRINTS TO SCREEN
* DESCRIPTION: spins in here infinitely when user throws exception
*/
void BREAKPOINT() {
    printf("BREAKPOINT");
    while(1) {
    }
}
/* OVERFLOW()
* INPUTS : NONE
* OUTPUTS : PRINTS TO SCREEN
* DESCRIPTION: spins in here infinitely when user throws exception
*/
void OVERFLOW() {
    printf("OVERFLOW");
    while (1) {
    }
}
/* BOUND_RANGE_EXCEEDED()
* INPUTS : NONE
* OUTPUTS : PRINTS TO SCREEN
* DESCRIPTION: spins in here infinitely when user throws exception
*/
void BOUND_RANGE_EXCEEDED() {
    printf("BOUND_RANGE_EXCEEDED");
    while (1) {
    }
}
/* INVALID_OPCODE()
* INPUTS : NONE
* OUTPUTS : PRINTS TO SCREEN
* DESCRIPTION: spins in here infinitely when user throws exception
*/
void INVALID_OPCODE() {
    printf("INVALID_OPCODE");
    while (1) {
    }
}
/* DEVICE_NOT_AVAILABLE()
* INPUTS : NONE
* OUTPUTS : PRINTS TO SCREEN
* DESCRIPTION: spins in here infinitely when user throws exception
*/
void DEVICE_NOT_AVAILABLE() {
    printf("DEVICE_NOT_AVAILABLE");
    while (1) {
    }
}
/* DOUBLE_FAULT()
* INPUTS : NONE
* OUTPUTS : PRINTS TO SCREEN
* DESCRIPTION: spins in here infinitely when user throws exception
*/
void DOUBLE_FAULT() {
    printf("DOUBLE_FAULT");
    while (1) {
    }
}
/* COPROCESSOR_SEGMENT_OVERRUN()
* INPUTS : NONE
* OUTPUTS : PRINTS TO SCREEN
* DESCRIPTION: spins in here infinitely when user throws exception
*/
void COPROCESSOR_SEGMENT_OVERRUN() {
    printf("COPROCESSOR_SEGMENT_OVERRUN");
    while (1) {
    }
}
/* INVALID_TSS()
* INPUTS : NONE
* OUTPUTS : PRINTS TO SCREEN
* DESCRIPTION: spins in here infinitely when user throws exception
*/
void INVALID_TSS() {
    printf("INVALID_TSS");
    while (1) {
    }
}
/* SEGMENT_NOT_PRESENT()
* INPUTS : NONE
* OUTPUTS : PRINTS TO SCREEN
* DESCRIPTION: spins in here infinitely when user throws exception
*/
void SEGMENT_NOT_PRESENT() {
    printf("SEGMENT_NOT_PRESENT");
    while (1) {
    }
}
/* STACK_SEGMENT_FAULT()
* INPUTS : NONE
* OUTPUTS : PRINTS TO SCREEN
* DESCRIPTION: spins in here infinitely when user throws exception
*/
void STACK_SEGMENT_FAULT() {
    printf("STACK_SEGMENT_FAULT");
    while (1) {
    }

}
/* GENERAL_PROTECTION()
* INPUTS : NONE
* OUTPUTS : PRINTS TO SCREEN
* DESCRIPTION: spins in here infinitely when user throws exception
*/
void GENERAL_PROTECTION() {
    bsod();
    printf("GENERAL_PROTECTION");

    while (1) {
    }

}
/* PAGE_FAULT()
* INPUTS : NONE
* OUTPUTS : PRINTS TO SCREEN
* DESCRIPTION: spins in here infinitely when user throws exception
*/
void PAGE_FAULT() {
    unsigned long regVal;
    bsod();
    printf("PAGE_FAULT");
    asm("movl %%cr2, %0;" : "=r" (regVal) : );
    // Prints Address that caused fault
    if (regVal == 0)
        printf(" Tried to access NULL pointer");
    else
        printf(" Address 0x%#x caused PAGE_FAULT\n", regVal);
    cli(); // dont want keyboard to interfere
    while(1) {
    }
}
/* FLOATING_POINT_ERROR()
* INPUTS : NONE
* OUTPUTS : PRINTS TO SCREEN
* DESCRIPTION: spins in here infinitely when user throws exception
*/
void FLOATING_POINT_ERROR() {
    printf("FLOATING_POINT_ERROR");
    while (1) {
    }
}
/* ALIGNMENT_CHECK()
* INPUTS : NONE
* OUTPUTS : PRINTS TO SCREEN
* DESCRIPTION: spins in here infinitely when user throws exception
*/
void ALIGNMENT_CHECK() {
    printf("ALIGNMENT_CHECK");
    while (1) {
    }
}
/* MACHINE_CHECK()
* INPUTS : NONE
* OUTPUTS : PRINTS TO SCREEN
* DESCRIPTION: spins in here infinitely when user throws exception
*/
void MACHINE_CHECK() {
    printf("MACHINE_CHECK");
    while (1) {
    }
}
/* FLOATING_POINT_EXCEPTION()
* INPUTS : NONE
* OUTPUTS : PRINTS TO SCREEN
* DESCRIPTION: spins in here infinitely when user throws exception
*/
void FLOATING_POINT_EXCEPTION() {
    printf("FLOATING_POINT_EXCEPTION");
    while (1) {
    }
}
/* PIT()
 * INSERT SCHEDULER LOGIC HERE.
 */
void PIT() {
    //terminal_write("boi",3);
    send_eoi(PIT_IRQ);
}


/* init_rtc_freq()
 * DESCRIPTION:  Obtain a slot in RTC simulation
 *               Error checking is handled in rtc_write()
 * INPUTS:       frequency of emulated RTC to start at
 * OUTPUTS:      None
 * RETURNS:      Index of clock allocated to fd; -1 if no slots available
 * SIDE EFFECTS: Changes the total number of ticks needed to unset
 *               rtc_wait_status
 * NOTE:         May be refactored later to allow multiple processes
 *               to have different RTC frequencies
 */
int32_t init_rtc_freq(int32_t freq) {
    int i;
    for(i = 0; i < MAX_CLOCKS; i++) {
        if(ticks_limit[i] == 0) {
            ticks_limit[i] = RTC_BASE_FREQ / freq;
            return i;
        }
    }
    return -1;
}

/* init_rtc_freq()
 * DESCRIPTION:  Change frequency of an RTC clot
 * INPUTS:       freq - frequency of emulated RTC to start at
 *                      if 0, releases RTC slot
 *               slot - internal slot number to change
 * OUTPUTS:      None
 * RETURNS:      None
 * SIDE EFFECTS: Changes the total number of ticks needed to unset
 *               rtc_wait_status
 * NOTE:         May be refactored later to allow multiple processes
 *               to have different RTC frequencies
 */
void set_rtc_freq(int32_t freq, int32_t slot) {
    if(freq == 0) {
        ticks_limit[slot] = 0;
        rtc_wait_status[slot] = 0;
    } else {
        ticks_limit[slot] = RTC_BASE_FREQ / freq;
    }
}

/* rtc_wait()
 * DESCRIPTION:  Wait for next RTC interrupt
 * INPUTS:       slot - index of rtc_wait_status to wait for
 * OUTPUTS:      None
 * RETURNS:      None
 * SIDE EFFECTS: Forces caller to wait for RTC interrupt
 */
void rtc_wait(unsigned long slot) {
    rtc_wait_status[slot] = 1;
    while(rtc_wait_status[slot]);
}

/* RTC() (Handler)
 * DESCRIPTION:  Handler function called by RTC interrupt
 *               RTC hardware frequency will always be kept at 1024 Hz
 *               Function will count ticks to simulate a kernel freq
 * INPUTS:       None
 * OUTPUTS:      None
 * RETURNS:      None
 * SIDE EFFECTS: Sends EOI to PIC to end interrupt
 *               Increments file scope tick counter
 */
void RTC() {
    uint32_t reg_c;
    static uint32_t ticks = -1;
    int i;
    // mask only the periodic interrupt bit
    uint32_t period_mask = 0x00000040;

    send_eoi(RTC_IRQ);
    reg_c = inb(RTC_DATA);
    if((reg_c & period_mask) != 0) {
        ticks++;
        for(i = 0; i < MAX_CLOCKS; i++) {
            if(ticks_limit[i] != 0 && ticks % ticks_limit[i] == 0) {
                rtc_wait_status[i] = 0;
            }
            if(ticks >= RTC_BASE_FREQ) {
                ticks = 0;
            }
        }

    }

}



uint32_t CAPS_ON = 0;
uint32_t RSHIFT_ON = 0; // BOIIIIIIIIII
uint32_t LSHIFT_ON = 0; // BOIIIIIIIIII
uint8_t DECISION;
uint8_t CONTROL_ON = 0;
uint32_t ALT_ON = 0;

/*
* KEYBOARD()
* DESCRIPTION: sends output to screen when key is pressed,
* INPUTS : NONE
* OUTPUTS : PRINTS TO SCREEN
* RETURN VALUE: NONE
* http://arjunsreedharan.org/post/99370248137/kernel-201-lets-write-a-kernel-with-keyboard
*/
#define NUM_ENTRIES 128
void KEYBOARD() {
    // write eoi
    unsigned char status;
    uint8_t key;
    status = inb(KEYBOARD_ADDR); // get status of interrupt
    //char special_char;
    if(status & ODD_MASK){ // check odd
            key = inb(KEYBOARD_PORT);
            // if(key > (unsigned char)NUM_ENTRIES){ // check for out of range scancodes
            //     send_eoi(kbd_eoi);
            //     return;
            // }
            if(key == CONTROL){
                CONTROL_ON = 1;
                send_eoi(kbd_eoi); // 1 is the irq for keyboard
                return;
            }
            if(key == _CONTROL){
                CONTROL_ON = 0;
                send_eoi(kbd_eoi); // 1 is the irq for keyboard
                return;
            }
            if(key == CAPS_LOCK){
                CAPS_ON += 1; // this method allows us to track keyrpesses but not releases
                CAPS_ON %= 2;
                send_eoi(kbd_eoi); // 1 is the irq for keyboard
                return;
            }
            if(key == RIGHT_SHIFT){
                RSHIFT_ON = 1;
                send_eoi(kbd_eoi); // 1 is the irq for keyboard
                return;
            }
            if(key == LEFT_SHIFT){

                LSHIFT_ON = 1;
                send_eoi(kbd_eoi); // 1 is the irq for keyboard
                return;
            }
            if(key == _RIGHT_SHIFT){ // release of RIGHT_SHIFT is a negative number

                RSHIFT_ON = 0;
                send_eoi(kbd_eoi); // 1 is the irq for keyboard
                return;
            }
            if(key == _LEFT_SHIFT){ // release of LEFT_SHIFT is a negative number

                LSHIFT_ON = 0;
                send_eoi(kbd_eoi); // 1 is the irq for keyboard
                return;
            }
            if(key == LEFT_ALT) {
                ALT_ON = 1;
                send_eoi(kbd_eoi);
                return;
            }
            if(key == _LEFT_ALT) {
                ALT_ON = 0;
                send_eoi(kbd_eoi);
                return;
            }
            if(key >= F_ONE && key <= F_THREE && ALT_ON) {
                //terminal_write("Terminal switch", 16);
                //special_char = key - F_ONE + '1';
                //terminal_write(&special_char, 1);
                switch_terms(key - F_ONE);
                send_eoi(kbd_eoi);
                return;
            }
            DECISION  = RSHIFT_ON|LSHIFT_ON ? SHIFT_ON : CAPS_ON; // if RSHIFT_on or LSHIFT_ON assign a 2 else assign a 0 or 1 based on caps lock
            if(key >= 128){ // filter out upstroke
                send_eoi(kbd_eoi); // 1 is the irq for keyboard
                return;
            }
            keyboard_write(keyboard_map[DECISION][(uint32_t) key],CONTROL_ON);
        }
        send_eoi(kbd_eoi); // 1 is the irq for keyboard

}
/*
* SYSTEM_CALL()
* DESCRIPTION: prints system call
* INPUTS : NONE
* OUTPUTS : PRINTS TO SCREEN
* RETURN VALUE: NONE
*/
void SYSTEM_CALL() {
  printf("SYSTEM CALL\n");
  while(1);

}
