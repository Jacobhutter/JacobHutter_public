#include "sound.h"
#define num_keys 128
uint32_t piano_board[num_keys] =
{
    0, 349, 0, 0, 0, 0, 0, 0, 0, 0,	/* 9 */
    0, 0, 0, 0, 0,	/* Backspace */
    0,			/* Tab */
    0, 139, 156, 0,	/* 19 */
    185, 208, 233, 0, 277, 311, 0, 0, 0,	/* Enter key */
    0,			/* 29   - Control */
    131, 147, 165, 175, 196, 220, 247, 261, 294, 330,	/* 39 */
    349 , '`', 0,		/* Left shift */
    0, 0, 0, 0, 0, 0, 0,			/* 49 */
    0, 0, 0, 0,   0,				/* Right shift */
    0,
    0,	/* Alt */
    0,	/* Space bar */
    0,	/* Caps lock */
    0,	/* 59 - F1 key ... > */
    0,   0,   0,   0,   0,   0,   0,   0,
    0,	/* < ... F10 */
    0,	/* 69 - Num lock*/
    0,	/* Scroll Lock */
    0,	/* Home key */
    0,	/* Up Arrow */
    0,	/* Page Up */
    0,
    0,	/* Left Arrow */
    0,
    0,	/* Right Arrow */
    0,
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

void play_sound(uint32_t nFrequence) {
   uint32_t Div;
   uint8_t tmp;

       //Set the PIT to the desired frequency
   Div = 1193180 / nFrequence;
   outb(0xb6,0x43);
   outb((uint8_t) (Div),0x42 );
   outb((uint8_t) (Div >> 8),0x42);

       //And play the sound using the PC speaker
   tmp = inb(0x61);
   if (tmp != (tmp | 3)) {
       outb((tmp | 3), 0x61);
   }
}

//make it shutup
void nosound() {
   uint8_t tmp = inb(0x61) & 0xFC;

   outb(tmp, 0x61);
}

volatile uint8_t ex = 0;
volatile uint8_t piano_flag = 0;

uint8_t get_p_flag(){
  return piano_flag;
}
void set_p_flag(){
  piano_flag = 1;
}
void piano(int8_t key){
  if(key < 0){
    nosound();
    return;
  }
  uint32_t note = piano_board[(uint8_t)key];
  if(note == '`'){
    nosound();
    piano_flag = 0;
    return;
  }
  if(note == 0)
    return;
  play_sound(note);

  return;
}
