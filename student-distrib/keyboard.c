/* http://arjunsreedharan.org/post/99370248137/kernel-201-lets-write-a-kernel-with-keyboard */

#include "keyboard.h"
#include "lib.h"
#define VGA_CONVENTION 2
#define BUFFER_SIZE  128*VGA_CONVENTION
#define BUFFER_LIMIT 128
#define SCREEN_HEIGHT 25
#define SCREEN_WIDTH 80
#define VGA_MEM 0xB8000
#define GREEN 2
#define BLACK 0
#define SCREEN_AREA SCREEN_WIDTH*SCREEN_HEIGHT*VGA_CONVENTION
unsigned char old_kbd_buffer[BUFFER_LIMIT] = "";
unsigned char kbd_buffer[BUFFER_LIMIT]; // keyboard buffer of 128 bytes including new line
unsigned char frame_buffer[SCREEN_AREA];
unsigned char dummy_buffer[SCREEN_AREA];
volatile uint32_t INDEX = 0;
volatile uint32_t KEYPRESSES = 0;
volatile uint8_t OLD_KEYPRESSES = 0;
volatile uint32_t INTERRUPT_MAP[SCREEN_AREA/2];

void scroll(){
  int i;
  memcpy((void *)dummy_buffer+(SCREEN_WIDTH*VGA_CONVENTION),(const void *)frame_buffer,SCREEN_AREA-(SCREEN_WIDTH*VGA_CONVENTION));
  for(i = 0; i < SCREEN_WIDTH*VGA_CONVENTION; i++){
    if(i%2 == 0)
      dummy_buffer[i] = ' ';
    else
      dummy_buffer[i] = 0;
  }
  memcpy((void *)frame_buffer,(const void *)dummy_buffer, SCREEN_AREA);
  display_screen();

  INDEX = 0;
  KEYPRESSES = 0;
}
void clear_kbd_buf(){
    int i;
    for(i = 0; i< BUFFER_LIMIT; i++)
        kbd_buffer[i] = ' ';
}

void clear_frame_buf(){
    int i;
    for(i = 0;i < SCREEN_AREA;i++){
        if(i%2 == 0)
          frame_buffer[i] = ' ';
        else
          frame_buffer[i] = BLACK;
    }
}

void clear_INTERRUPT_MAP(){
    int i;
    for(i = 0; i <SCREEN_AREA/2; i++)
        INTERRUPT_MAP[i] = 0;
}

void insert_char(unsigned char keypress){
    frame_buffer[INDEX] = keypress;
    frame_buffer[INDEX+1] = GREEN;
}

void display_screen(){
    memcpy((void *)VGA_MEM,(const void *)frame_buffer,SCREEN_AREA);
}

/* void keyboard_open()
* INPUT: NONE
* OUTPUT: NONE
* RETURN VALUE: void
* DESCRIPTION: allows pic to recognize keyboard inputs
*/
void keyboard_open() {
    /* index of screen we are displaying */
    INDEX = 0;

    /* number of keypresses we have seen */
    KEYPRESSES = 0;

    /* lets keyboard write know what was previously put on screen */
    clear_INTERRUPT_MAP();

    /* clear the keyboard buffer */
    clear_kbd_buf();

    /* clear the frame buffer */
    clear_frame_buf();

    /*display the blank frame buffer*/
    display_screen();

    /*allow for interrupts from keyboard via APIC*/
    outb(kbd_irq_line, KEYBOARD_IRQ);
}

/* void keyboard_write(unsigned char keypress, uint8_t CONTROL_ON)
* INPUT: a char to write to keyboard and a flag to tell if control is on
* OUTPUT: NONE
* RETURN VALUE: void
* DESCRIPTION: writes char to frame buffer and displays upon a keyboard interrupt
*/
void keyboard_write(unsigned char keypress, uint8_t CONTROL_ON){

    int i;
    /* CONTROL SHIFT L seen */
    if(CONTROL_ON == 1 && keypress == 'L'){
        keyboard_open();
        return;
    }

    /* we have hit our 128 keypress limit and next char is not a delete or newline */
    if(KEYPRESSES == BUFFER_LIMIT && keypress != '\n' && keypress != '\b')
        return;


    /* if newline is seen, scroll and clear our current keyboard buffer */
    if(keypress == '\n'){
        memcpy((void *)old_kbd_buffer,(const void*)kbd_buffer,BUFFER_LIMIT);// save old kbd buffer
        OLD_KEYPRESSES = KEYPRESSES;
        scroll();
        clear_kbd_buf();
        clear_INTERRUPT_MAP();
        return;
    }


    /* if backspace is seen, check to see if at index zero and then remove */
    if(keypress == '\b'){
        if(INDEX == 0)
            return;
        /* is previous entry remnants of interrupt or keyboard press? */
        if(INTERRUPT_MAP[(INDEX/2) - 1] != 0){ // interrupt has happened and is last char
            frame_buffer[INDEX - 1] = BLACK;
            frame_buffer[INDEX - VGA_CONVENTION] = ' ';
            INTERRUPT_MAP[(INDEX/2) - 1] = 0; // show that space is no longer occupied by sys call char
            INDEX = INDEX - 2;
        }
        else{
            frame_buffer[INDEX - 1] = BLACK;
            frame_buffer[INDEX - VGA_CONVENTION] = ' ';
            kbd_buffer[KEYPRESSES - 1] = ' ';
            INDEX = INDEX - 2;
            KEYPRESSES--;
        }

        display_screen();
        return;
    }


    /* we have come to the end of a line on terminal, move screen down and continue typing until limit is hit */
    if(INDEX == SCREEN_WIDTH*VGA_CONVENTION){
        memcpy((void *)dummy_buffer,(const void *)frame_buffer,SCREEN_WIDTH*2); // copy over first row
        memcpy((void *)dummy_buffer+(SCREEN_WIDTH*4),(const void *)frame_buffer+(SCREEN_WIDTH*VGA_CONVENTION),SCREEN_AREA-(SCREEN_WIDTH*4)); // shift additonal row
        for(i = SCREEN_WIDTH*VGA_CONVENTION; i<SCREEN_WIDTH*4; i++){
            if(i%2 == 0)
                dummy_buffer[i] = ' ';
            else
                dummy_buffer[i] = BLACK;
        }
        memcpy((void *)frame_buffer,(const void *)dummy_buffer, SCREEN_AREA);
        display_screen();
    }


  kbd_buffer[KEYPRESSES] = keypress;
  KEYPRESSES++;
  insert_char(keypress);
  INDEX = INDEX + 2;
  display_screen();
}
/*extern int32_t ece391_write (int32_t fd, const void* buf, int32_t nbytes);*/

int32_t terminal_write(const void* buf, int32_t nbytes){
    if(nbytes <= 0)
        return -1;

    int i,j;
    for(i = 0; i<nbytes; i++){
        if(INDEX != 0 && (INDEX%(SCREEN_WIDTH*VGA_CONVENTION)) == 0){
            int modulate = INDEX/(SCREEN_WIDTH*VGA_CONVENTION); // number of rows offset
            memcpy((void *)dummy_buffer + (2*SCREEN_WIDTH)*(modulate - 1),(const void *)frame_buffer+((2*SCREEN_WIDTH)*(modulate - 1)),SCREEN_WIDTH*2); // copy over first row
            memcpy((void *)dummy_buffer+(SCREEN_WIDTH*2)*(modulate + 1),(const void *)frame_buffer+(SCREEN_WIDTH*VGA_CONVENTION)*(modulate),SCREEN_AREA-(SCREEN_WIDTH*2)*(modulate + 1)); // shift additonal row
            for(j = (SCREEN_WIDTH*VGA_CONVENTION)*(modulate); j<((SCREEN_WIDTH*2)*(modulate+1)); j++){
                if(j%2 == 0)
                    dummy_buffer[j] = ' ';
                else
                    dummy_buffer[j] = BLACK;
            }
            memcpy((void *)frame_buffer,(const void *)dummy_buffer, SCREEN_AREA);
        }
        INTERRUPT_MAP[(INDEX/2)+i] = 1; // map current index to show that it was filled by interrupt
        if(((unsigned char *)buf)[i] == '\n'){
            scroll();
            clear_kbd_buf();
            clear_INTERRUPT_MAP();
            OLD_KEYPRESSES = 0; // make user enter in fresh entry
            int k = 0;
            for(k = 0; k< BUFFER_LIMIT; k++)
              old_kbd_buffer[k] = ' ';
        }
        else{
            insert_char(((unsigned char *)buf)[i]);
            INDEX += 2;
        }
    }
    display_screen();

    return 0;
}

/*extern int32_t ece391_read (int32_t fd, void* buf, int32_t nbytes);*/

int32_t terminal_read(void* buf, int32_t nbytes){
  if(nbytes < 0 || nbytes > BUFFER_LIMIT)
    return -1; // valid entry?
  if(OLD_KEYPRESSES == 0)
    return -1; // no entry was made by user
  memcpy(buf,(const void *)old_kbd_buffer,nbytes > OLD_KEYPRESSES? OLD_KEYPRESSES : nbytes);
  int32_t retval = 0;
  retval = nbytes > OLD_KEYPRESSES? OLD_KEYPRESSES : nbytes;
  return retval;
}

void test_terminal(){
    int t_length=-1;
    unsigned char sol_buf[128];
    unsigned char test_buf[] = "What is your name? \n";
    terminal_write((const void*)test_buf,(int32_t)20);
    while(t_length == -1)
        t_length = terminal_read((void *)test_buf,(int32_t)128); // read up to one buffer size
    unsigned char new_test_buf[] = " sounds like a great name! What is your favorite color?\n";
    terminal_write((const void *)test_buf,(int32_t)t_length);
    terminal_write((const void *)new_test_buf,(int32_t)strlen((int8_t *)new_test_buf));
    t_length = -1;
    while(t_length == -1)
        t_length = terminal_read((void *)test_buf,(int32_t)128);
    terminal_write((const void *)test_buf,(int32_t)t_length);
    unsigned int color_length = t_length;
    terminal_write((const void *)" has ",(int32_t)5);
    if(color_length >= 10){
        sol_buf[1] = (color_length%10) + '0'; // i to a
        sol_buf[0] = (color_length/10) + '0';
        t_length = 2;
    }
    else{
        sol_buf[0] = color_length + '0';
        t_length = 1;
    }
    memcpy((void *)sol_buf + t_length, (const void *)" letters in it, there are ",26);
    int j,i,sol = 26;
    if(color_length == 0)
        sol = 0;
    while(color_length>1){
        sol *= 26;
        color_length--;
    }
    i = 1;
    int count = 1;
    while(1){ // how many digits is sol?
        if(sol - i > 0){
            i *= 10;
            count++;
        }
        else
            break;
    }
    i /= 10;
    j = 1;
    count--;
    for(j = 0; j < count; j++){
        sol_buf[t_length + j + 26] = (sol / i) + '0';
        sol %= i;
        i /= 10;
    }
    memcpy((void *)sol_buf + t_length+26+count, (const void *)" different words to make out of that many letters! \n",50);
    terminal_write((const void *)sol_buf,t_length+26 + count + 50);
}
