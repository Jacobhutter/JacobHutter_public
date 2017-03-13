//
//  keyboard.h
//  
//
//  Created by Cameron Long on 3/10/17.
//
//

#ifndef keyboard_h
#define keyboard_h
#include "lib.h"
#include "x86_desc.h"

#define EOI 0x20
#define MASTER_PIC 0x20
#define KEYBOARD_DATA 0x60
#define KEYBOARD_ADDR 0x64
#define KEYBOARD_IRQ 0x21

void keyboard_init();
void keyboard_handler();



#endif /* keyboard_h */
