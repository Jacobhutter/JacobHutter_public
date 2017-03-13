/* Consult x86 ISA manual */
/* Appendix D */


#include "interrupt_handler.h"

uint32_t kbd_eoi = 1;

//https://github.com/arjun024/mkeykernel/blob/master/keyboard_map.h
unsigned char keyboard_map[128] =
{
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
};

void DIVIDE_ERROR() {
    bsod();
    printf("DIVIDE_ERROR");
    cli(); // dont want keyboard to interfere
    while(1);
}

void RESERVED() {
    printf("RESERVED");
    while (1);

}

void NMI_INTERRUPT() {
    printf("NMI_INTERRUPT");
    while (1) {
    }
}

void BREAKPOINT() {
    printf("BREAKPOINT");
    while(1) {
    }
}

void OVERFLOW() {
    printf("OVERFLOW");
    while (1) {
    }
}

void BOUND_RANGE_EXCEEDED() {
    printf("BOUND_RANGE_EXCEEDED");
    while (1) {
    }
}

void INVALID_OPCODE() {
    printf("INVALID_OPCODE");
    while (1) {
    }
}

void DEVICE_NOT_AVAILABLE() {
    printf("DEVICE_NOT_AVAILABLE");
    while (1) {
    }
}

void DOUBLE_FAULT() {
    printf("DOUBLE_FAULT");
    while (1) {
    }
}

void COPROCESSOR_SEGMENT_OVERRUN() {
    printf("COPROCESSOR_SEGMENT_OVERRUN");
    while (1) {
    }
}

void INVALID_TSS() {
    printf("INVALID_TSS");
    while (1) {
    }
}

void SEGMENT_NOT_PRESENT() {
    printf("SEGMENT_NOT_PRESENT");
    while (1) {
    }
}

void STACK_SEGMENT_FAULT() {
    printf("STACK_SEGMENT_FAULT");
    while (1) {
    }

}

void GENERAL_PROTECTION() {
    printf("GENERAL_PROTECTION");
    while (1) {
    }

}

void PAGE_FAULT() {
    unsigned long regVal;
    printf("PAGE_FAULT");
    asm("movl %%cr2, %0;" : "=r" (regVal) : );
    // Prints Address that caused fault
    if (regVal == 0)
        printf(" Tried to access NULL pointer");
    else
        printf(" Address 0x%x caused PAGE_FAULT\n", regVal);
    while(1) {
    }
}

void FLOATING_POINT_ERROR() {
    printf("FLOATING_POINT_ERROR");
    while (1) {
    }
}

void ALIGNMENT_CHECK() {
    printf("ALIGNMENT_CHECK");
    while (1) {
    }
}

void MACHINE_CHECK() {
    printf("MACHINE_CHECK");
    while (1) {
    }
}

void FLOATING_POINT_EXCEPTION() {
    printf("FLOATING_POINT_EXCEPTION");
    while (1) {
    }
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

    // mask only the periodic interrupt bit
    uint32_t period_mask = 0x00000040;

    reg_c = inb(RTC_DATA);
    if((reg_c & period_mask) != 0) {

        // we have found a periodic interrupt
        //test_interrupts();
    }
    send_eoi(RTC_IRQ);
}
#define KEYBOARD_ADDR 0x64
#define KEYBOARD_PORT 0x60

void KEYBOARD() {
    // write eoi
    unsigned char status;
    char key;

    send_eoi(kbd_eoi); // 1 is the irq for keyboard

    status = inb(KEYBOARD_ADDR);
    if(status & 0x01){
        key = inb(KEYBOARD_PORT);
        if(key < 0)
            return;
        putc(keyboard_map[(uint32_t) key]);
    }
}

void SYSTEM_CALL() {
  printf("SYSTEM CALL\n");
  while(1);

}
