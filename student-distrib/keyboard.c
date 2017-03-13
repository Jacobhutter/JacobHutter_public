//
//  keyboard.c
//  
//
//  Created by Cameron Long on 3/10/17.
//
// http://arjunsreedharan.org/post/99370248137/kernel-201-lets-write-a-kernel-with-keyboard

#include "keyboard.h"

void keyboard_init() {
    
    outb(1, KEYBOARD_IRQ);
}

