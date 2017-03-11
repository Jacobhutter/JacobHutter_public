#include "keyboard.h"
#define irq_kbd 1 // keyboard is irq line 1
void keyboard_init(){
  enable_irq(irq_kbd);
}
