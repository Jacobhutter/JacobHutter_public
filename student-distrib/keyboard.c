/* http://arjunsreedharan.org/post/99370248137/kernel-201-lets-write-a-kernel-with-keyboard */

#include "keyboard.h"
#include "lib.h"
#define buffer_size 128
#define screen_height 25
#define screen_width 80
#define vga_mem 0xB8000
#define green 2
#define screen_area screen_width*screen_height*2
unsigned char kbd_buffer[128*2]; // keyboard buffer of 128 bytes including new line
unsigned char frame_buffer[25*80*2];
volatile int index;

void buffer_to_screen(){
  memcpy((void *)frame_buffer+(screen_area-(screen_width*2)),(const void *)kbd_buffer, index);
}
void display_screen(){
  memcpy((void *)vga_mem,(const void *)frame_buffer,screen_area);
}
/* void keyboard_open()
* INPUT: NONE
* OUTPUT: NONE
* RETURN VALUE: void
* DESCRIPTION: allows pic to recognize keyboard inputs
*/
void keyboard_open() {
    index = 0;
    int i =0;
    for(i = 0; i < buffer_size*2; i++){
      if(i %2 == 0)
        kbd_buffer[i] = ' '; // char
      else
        kbd_buffer[i] = green; // color
    }
    for(i =0; i<screen_area;i++){
      if(i%2==0)
        frame_buffer[i]=' '; // character part of 2byte system
      else
        frame_buffer[i]=0; // color part of 2byte system
    }
    display_screen();
    outb(kbd_irq_line, KEYBOARD_IRQ); // enables irq of keyboard
}

void keyboard_write(unsigned char keypress){
  kbd_buffer[index] = keypress;
  index = index + 2;
  buffer_to_screen();
  display_screen();
}
