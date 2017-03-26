/* http://arjunsreedharan.org/post/99370248137/kernel-201-lets-write-a-kernel-with-keyboard */

#include "keyboard.h"
#include "lib.h"
#define VGA_CONVENTION 2
#define BUFFER_SIZE  128*VGA_CONVENTION
#define BUFFER_LIMIT 128
#define SCREEN_HEIGHT 25
#define SCREEN_WIDTH 80
#define MAX_WIDTH_INDEX 79
#define MAX_HEIGHT_INDEX 24
#define VGA_MEM 0xB8000
#define GREEN 2
#define BLACK 0
#define SCREEN_AREA SCREEN_WIDTH*SCREEN_HEIGHT*VGA_CONVENTION
unsigned char old_kbd_buffer[BUFFER_LIMIT] = "";
unsigned char kbd_buffer[BUFFER_LIMIT]; // keyboard buffer of 128 bytes including new line
unsigned char frame_buffer[SCREEN_AREA];
unsigned char dummy_buffer[SCREEN_AREA];
volatile uint32_t KEYPRESSES;
volatile uint32_t OLD_KEYPRESSES;
volatile uint32_t INTERRUPT_MAP[SCREEN_AREA/2];
volatile uint8_t SYS_CALL_MAP[SCREEN_WIDTH][SCREEN_HEIGHT];
volatile uint32_t screen_x;
volatile uint32_t screen_y;

/* void update_cursor(int row, int col)
 * by Dark Fiber
 */
void update_cursor(int row, int col)
{
   unsigned short position=(row*80) + col;

   // cursor LOW port to vga INDEX register
   outb(0x0F, 0x3D4);
   outb((unsigned char)(position&0xFF),0x3D5);
   // cursor HIGH port to vga INDEX register
   outb(0x0E,0x3D4);
   outb((unsigned char )((position>>8)&0xFF),0x3D5);
}

void clear_kbd_buf(){
    int i;
    for(i = 0; i< BUFFER_LIMIT; i++)
        kbd_buffer[i] = ' ';
}

void scroll(){
    int i;
    memcpy((void *)dummy_buffer,(const void *)frame_buffer+(SCREEN_WIDTH*VGA_CONVENTION),SCREEN_AREA-(SCREEN_WIDTH*VGA_CONVENTION));

    for(i = SCREEN_AREA-(SCREEN_WIDTH*VGA_CONVENTION); i < SCREEN_AREA; i++){
        if(i%2 == 0)
            dummy_buffer[i] = ' ';
        else
            dummy_buffer[i] = GREEN;
    }

    memcpy((void *)frame_buffer,(const void *)dummy_buffer, SCREEN_AREA);
}

/*
* void system_at_coord(uint8_t c);
*   Inputs: uint_8* c = character to print
*   Return Value: void
*	Function: Output a character to the console
*/
void
system_at_coord(uint8_t c)
{
    if(c == '\n' || c == '\r') {
        if(screen_y == MAX_HEIGHT_INDEX){
            scroll();
        }
        else
            screen_y++;
        screen_x=0;
        display_screen();
        return;
    }


    if(c == '\b'){
        if(screen_x == 0){
            screen_x = MAX_WIDTH_INDEX;
            --screen_y;
        }
        else{
            screen_x--;
            screen_x %= SCREEN_WIDTH;
            screen_y = (screen_y + (screen_x / SCREEN_WIDTH)) % SCREEN_HEIGHT;
        }
        if(!SYS_CALL_MAP[screen_x][screen_y])
            KEYPRESSES--;
        *(uint8_t *)(frame_buffer + ((SCREEN_WIDTH*screen_y + screen_x) << 1)) = ' ';
        *(uint8_t *)(frame_buffer + ((SCREEN_WIDTH*screen_y + screen_x) << 1) + 1) = GREEN;
    }
    else{
        *(uint8_t *)(frame_buffer + ((SCREEN_WIDTH*screen_y + screen_x) << 1)) = c;
        *(uint8_t *)(frame_buffer + ((SCREEN_WIDTH*screen_y + screen_x) << 1) + 1) = GREEN;
        screen_x++;
        if(screen_x == SCREEN_WIDTH && screen_y == MAX_HEIGHT_INDEX){
            scroll();
            screen_y = MAX_HEIGHT_INDEX;
        }
        else
            screen_y = (screen_y + (screen_x / SCREEN_WIDTH)) % SCREEN_HEIGHT;
        screen_x %= SCREEN_WIDTH;
    }
    return;
}

/*
* void put_at_coord(uint8_t c);
*   Inputs: uint_8* c = character to print
*   Return Value: void
*	Function: Output a character to the console
*/
void
put_at_coord(uint8_t c)
{
    if(c == '\n' || c == '\r') {
        if(screen_y == MAX_HEIGHT_INDEX){
            scroll();
        }
        else
            screen_y++;
        /* when enter is pressed, we need to store our state for terminal read */
        OLD_KEYPRESSES = KEYPRESSES;
        memcpy((void *)old_kbd_buffer,(const void *)kbd_buffer,BUFFER_LIMIT);

        screen_x=0;
        KEYPRESSES = 0; // no keypresses recoreded
        clear_kbd_buf(); // clear the keyboard buffer
        display_screen();
        return;
    }


    if(c == '\b'){
        if(!SYS_CALL_MAP[screen_x][screen_y]){
            KEYPRESSES--;
            kbd_buffer[KEYPRESSES] = ' ';
        }

        if(screen_x == 0){
            screen_x = MAX_WIDTH_INDEX;
            --screen_y;
        }
        else{
            screen_x--;
            screen_x %= SCREEN_WIDTH;
            screen_y = (screen_y + (screen_x / SCREEN_WIDTH)) % SCREEN_HEIGHT;
        }
        *(uint8_t *)(frame_buffer + ((SCREEN_WIDTH*screen_y + screen_x) << 1)) = ' ';
        *(uint8_t *)(frame_buffer + ((SCREEN_WIDTH*screen_y + screen_x) << 1) + 1) = GREEN;
    }
    else{
        *(uint8_t *)(frame_buffer + ((SCREEN_WIDTH*screen_y + screen_x) << 1)) = c;
        *(uint8_t *)(frame_buffer + ((SCREEN_WIDTH*screen_y + screen_x) << 1) + 1) = GREEN;
        screen_x++;
        if(screen_x == SCREEN_WIDTH && screen_y == MAX_HEIGHT_INDEX){
            scroll();
            screen_y = MAX_HEIGHT_INDEX;
        }
        else
            screen_y = (screen_y + (screen_x / SCREEN_WIDTH)) % SCREEN_HEIGHT;
        screen_x %= SCREEN_WIDTH;
        kbd_buffer[KEYPRESSES] = c;
        KEYPRESSES++;

    }
    return;
}

void clear_SYS_CALL_MAP(){
    int i,j;
    for(i = 0; i < SCREEN_WIDTH; i++){
        for(j = 0; j < SCREEN_HEIGHT; j++){
            SYS_CALL_MAP[i][j] = 0;
        }
    }
}


void clear_frame_buf(){
    int i;
    for(i = 0;i < SCREEN_AREA;i++){
        if(i%2 == 0)
          frame_buffer[i] = ' ';
        else
          frame_buffer[i] = GREEN;
    }
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
    screen_x = 0;
    screen_y = 0;

    update_cursor(screen_y,screen_x);

    /* number of keypresses we have seen */
    OLD_KEYPRESSES = 0;
    KEYPRESSES = 0;

    /* lets program know whether a char was placed by user or sys call */
    clear_SYS_CALL_MAP();

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

    /* CONTROL SHIFT L seen */
    if(keypress == '\b' && screen_x == 0 && KEYPRESSES == 0){
        return;
    }

    if(CONTROL_ON == 1 && keypress == 'L'){
        //char test[] = "aaaaaaaaaafj;dlsafjkdsfdlksajfkd;safkdjsa;fdjslakfjdsl;afdkjsa;fdjskajfdsa;fkdsajf;dsjafkdjkasjfdkl;afskldjsalfkjdsalfjdkslajflds;ajfldsjafkdjsal;fjdksa;fdjka;fjdksa;jfkldsjaflkdsjaf;dlkafkdjskafjdsalf;dajfklsajfkldjsalkfjsakl;fjsadl;fksajfds;afjkl;sdajfldksjafl;dsakjflsdajflk;dsaflkdsajfkldsa;kdsjakfljdsalfjdsla;fjdklsjafldsajfkldsa;f";
        //terminal_write((const void *)test,(int32_t)strlen(test));
        keyboard_open();
        return;
    }

    /* we have hit our 128 keypress limit and next char is not a delete or newline */
    if(KEYPRESSES == BUFFER_LIMIT && keypress != '\n' && keypress != '\b')
        return;


    put_at_coord(keypress);
    update_cursor(screen_y,screen_x);
    display_screen();
    return;
}

/*
* terminal_write
* INPUTS: const void * buf, int32_t nbytes
* OUTPUTS: prints unlimited chars to buffer
* RETURN VALUE: success 0 or fail -1
* DESCRIPTION: Takes a buffer of size nybtes and writes it to the frame buffer without altering current kbd operations
*/
int32_t terminal_write(const void* buf, int32_t nbytes){
    if(nbytes <= 0)
        return -1;

    int i;
    for(i = 0; i < nbytes; i++){
        SYS_CALL_MAP[screen_x][screen_y] = 1; // mark position as placed by sys call
        system_at_coord(((unsigned char*)buf)[i]);
    }
    update_cursor(screen_y,screen_x);
    display_screen();

    return 0;
}

/*extern int32_t ece391_read (int32_t fd, void* buf, int32_t nbytes);*/

int32_t terminal_read(void* buf, int32_t nbytes){

  if(nbytes < 0 || nbytes > BUFFER_LIMIT)
    return -1; // valid entry?
  while(OLD_KEYPRESSES == 0);

  memcpy(buf,(const void *)old_kbd_buffer,nbytes > OLD_KEYPRESSES? OLD_KEYPRESSES : nbytes);
  int32_t retval = 0;
  retval = nbytes > OLD_KEYPRESSES? OLD_KEYPRESSES : nbytes;
  OLD_KEYPRESSES = 0; // reset user entry
  return retval;
}

void test_terminal(){
    int t_length = -1;
    unsigned char sol_buf[128];
    unsigned char test_buf[] = "What is your name? \n";
    terminal_write((const void*)test_buf,(int32_t)20);
    //while(t_length == -1)
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
