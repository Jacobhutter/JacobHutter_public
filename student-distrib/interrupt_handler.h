/* interrupt_handler.h - Defines used in handling interrupts
 * vim:ts=4 noexpandtab
 */

#ifndef interrupt_handler_h
#define interrupt_handler_h

#include "lib.h"
#include "i8259.h"
#include "rtc.h"
#define KEYBOARD_ADDR 0x64
#define KEYBOARD_PORT 0x60
#define ODD_MASK 0x01
#define CAPS_LOCK 58
#define LEFT_SHIFT 42
#define RIGHT_SHIFT 54
#define _RIGHT_SHIFT 182
#define _LEFT_SHIFT 170
#define SHIFT_ON 2
#define kbd_eoi 1
#define CONTROL 29

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
