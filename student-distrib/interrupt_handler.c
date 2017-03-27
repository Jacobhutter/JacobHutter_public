/* Consult x86 ISA manual */
/* Appendix D */


#include "interrupt_handler.h"
#include "keyboard.h"
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
    'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', ';',	/* 39 */
    '\'', '"',   0,		/* Left shift */
    '\\', 'Z', 'X', 'C', 'V', 'B', 'N',			/* 49 */
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

static volatile int32_t ticks_limit;
static volatile int32_t rtc_wait_status = 0;

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
        printf(" Address 0x%x caused PAGE_FAULT\n", regVal);
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

// ADD HELPER FUNCTION DEFINITION HERE.
void set_rtc_freq(int32_t freq) {
    ticks_limit = RTC_BASE_FREQ / freq;
}

// ADD HELPER FUNCTION DEFINITION HERE.
void rtc_wait() {
    rtc_wait_status = 1;
    while(rtc_wait_status);
}

/* RTC() (Handler)
 * DESCRIPTION:  Handler function called by RTC interrupt
 * INPUTS:       None
 * OUTPUTS:      Calls test_interrupts, which floods screen
 * RETURNS:      None
 * SIDE EFFECTS: Sends EOI to PIC to end interrupt
 */
void RTC() {
    uint32_t reg_c;
    static uint32_t ticks = -1;

    // mask only the periodic interrupt bit
    uint32_t period_mask = 0x00000040;

    reg_c = inb(RTC_DATA);
    if((reg_c & period_mask) != 0) {
        
        ticks++;

        if(ticks % ticks_limit == 0) {
            rtc_wait_status = 0;
        }
        if(ticks >= RTC_BASE_FREQ) {
            ticks = 0;
        }
    }
    send_eoi(RTC_IRQ);
}



uint32_t CAPS_ON = 0;
uint32_t RSHIFT_ON = 0; // BOIIIIIIIIII
uint32_t LSHIFT_ON = 0; // BOIIIIIIIIII
uint8_t DECISION;
uint8_t CONTROL_ON = 0;
/*
* KEYBOARD()
* DESCRIPTION: sends output to screen when key is pressed,
* INPUTS : NONE
* OUTPUTS : PRINTS TO SCREEN
* RETURN VALUE: NONE
* http://arjunsreedharan.org/post/99370248137/kernel-201-lets-write-a-kernel-with-keyboard
*/
void KEYBOARD() {
    // write eoi
    unsigned char status;
    char key;
    status = inb(KEYBOARD_ADDR); // get status of interrupt

    if(status & ODD_MASK){ // check odd
            key = inb(KEYBOARD_PORT);
            if(key == CONTROL)
                CONTROL_ON = 1;
            if((uint8_t)key == 157)
                CONTROL_ON = 0;
            if(key == CAPS_LOCK){
                CAPS_ON += 1;
                CAPS_ON %= 2;
                send_eoi(kbd_eoi); // 1 is the irq for keyboard
                return;
            }
            if(key == RIGHT_SHIFT){
                RSHIFT_ON += 1;
                RSHIFT_ON %= 2;
                send_eoi(kbd_eoi); // 1 is the irq for keyboard
                return;
            }
            if(key == LEFT_SHIFT){
                LSHIFT_ON += 1;
                LSHIFT_ON %= 2;
                send_eoi(kbd_eoi); // 1 is the irq for keyboard
                return;
            }
            if((uint8_t)key == _RIGHT_SHIFT){ // release of RIGHT_SHIFT is a negative number
                RSHIFT_ON -= 1;
                send_eoi(kbd_eoi); // 1 is the irq for keyboard
                return;
            }
            if((uint8_t)key == _LEFT_SHIFT){ // release of LEFT_SHIFT is a negative number
                LSHIFT_ON -= 1;
                send_eoi(kbd_eoi); // 1 is the irq for keyboard
                return;
            }
            DECISION  = RSHIFT_ON|LSHIFT_ON ? SHIFT_ON : CAPS_ON; // if RSHIFT_on or LSHIFT_ON assign a 2 else assign a 0 or 1 based on caps lock
            if(key < 0){ // filter out upstroke
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
