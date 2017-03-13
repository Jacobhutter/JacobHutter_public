//
//  interrupt_handler.h
//
//
//  Created by Cameron Long on 3/9/17.
//
//

#ifndef interrupt_handler_h
#define interrupt_handler_h

#include "lib.h"
#include "i8259.h"
#include "rtc.h"

extern void DIVIDE_ERROR();
extern void RESERVED();
extern void NMI_INTERRUPT();
extern void BREAKPOINT();
extern void OVERFLOW();
extern void BOUND_RANGE_EXCEEDED();
extern void INVALID_OPCODE();
extern void DEVICE_NOT_AVAILABLE();
extern void DOUBLE_FAULT();
extern void COPROCESSOR_SEGMENT_OVERRUN();
extern void INVALID_TSS();
extern void SEGMENT_NOT_PRESENT();
extern void STACK_SEGMENT_FAULT();
extern void GENERAL_PROTECTION();
extern void PAGE_FAULT();
extern void FLOATING_POINT_ERROR();
extern void ALIGNMENT_CHECK();
extern void MACHINE_CHECK();
extern void FLOATING_POINT_EXCEPTION();
extern void RTC();
extern void KEYBOARD();
extern void SYSTEM_CALL();

#endif /* interrupt_handler_h */
