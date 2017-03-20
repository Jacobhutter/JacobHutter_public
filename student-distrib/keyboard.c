/* http://arjunsreedharan.org/post/99370248137/kernel-201-lets-write-a-kernel-with-keyboard */

#include "keyboard.h"
#include "lib.h"
#define buffer_size 128*2
#define screen_height 25
#define screen_width 80
#define vga_mem 0xB8000
#define GREEN 2
#define screen_area screen_width*screen_height*2
unsigned char kbd_buffer[128*2]; // keyboard buffer of 128 bytes including new line
unsigned char frame_buffer[25*80*2];
unsigned char dummy_buffer[25*80*2];
volatile uint8_t wait = 0;

volatile int index;

void scroll(){
  int i;
  memcpy((void *)dummy_buffer+(screen_width*2),(const void *)frame_buffer,screen_area-(screen_width*2));
  for(i = 0; i < screen_width*2; i++){
    if(i%2 == 0)
      dummy_buffer[i] = ' ';
    else
      dummy_buffer[i] = 0;
  }
  memcpy((void *)frame_buffer,(const void *)dummy_buffer, screen_area);
  display_screen();
  index = 0;
}
void clear_kbd_buf(){
 int i;
 for(i = 0; i< buffer_size; i++){
   if(i%2 == 0)
     kbd_buffer[i] = ' ';
   else
     kbd_buffer[i] = GREEN;
 }
}
void buffer_to_screen(){
  memcpy((void *)frame_buffer,(const void *)kbd_buffer, index);
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
    for(i = 0; i < buffer_size; i++){
      if(i %2 == 0)
        kbd_buffer[i] = ' '; // char
      else
        kbd_buffer[i] = GREEN; // color
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

void keyboard_write(unsigned char keypress, uint8_t CONTROL_ON){

  int i;
  if(CONTROL_ON == 1 && keypress == 'L'){
      keyboard_open();
      return;
  }
  if(index == buffer_size && keypress != '\n' && keypress != '\b'){
    wait = 0; // release lock
    return;
}
  if(index == screen_width*2){
    memcpy((void *)dummy_buffer+(screen_width*4),(const void *)frame_buffer+(screen_width*2),screen_area-(screen_width*4));
    for(i = screen_width*2; i<screen_width*4; i++){
      if(i%2 == 0)
        dummy_buffer[i] = ' ';
      else
        dummy_buffer[i] = 0;
    }
    memcpy((void *)frame_buffer,(const void *)dummy_buffer, screen_area);
    display_screen();
  }

  if(keypress == '\n'){
    scroll();
    clear_kbd_buf();
    wait = 0; // release lock
    return;
  }
  if(keypress == '\b'){ // if sent in \b
    if(index == 0){ // first check if we are at index zero so no crash
        wait = 0; // release lock
        return;
  }
    kbd_buffer[index-2] = ' '; // insert the blank char
    buffer_to_screen(); // insert the buffer onto the screen
    display_screen(); // display the screen
    index = index - 2; // update the index count for the kbd buffer
    wait = 0; // release lock
    return;
  }
  kbd_buffer[index] = keypress;
  index = index + 2;
  buffer_to_screen();
  display_screen();
  wait = 0; // release lock
}
/*extern int32_t ece391_write (int32_t fd, const void* buf, int32_t nbytes);*/

int32_t terminal_write(const void* buf, int32_t nbytes){
    while(!wait);
    wait = 1;
    return 0;
}

/*extern int32_t ece391_read (int32_t fd, void* buf, int32_t nbytes);*/

int32_t terminal_read(void* buf, int32_t nbytes){
  return 0;
}
