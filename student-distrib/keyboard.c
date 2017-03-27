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
#define NULL 0x0
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
 * Description: updates cursor to given x and y coordinates, most likely screen_y screen_x
 * by Dark Fiber
 * http://wiki.osdev.org/Text_Mode_Cursor
 */
void update_cursor(int row, int col)
{
    unsigned short position=(row*SCREEN_WIDTH) + col;

    // cursor LOW port to vga INDEX register
    outb(0x0F, 0x3D4); // 0x3D4 is the address of the vga index register
    outb((unsigned char)(position&0xFF),0x3D5); // 0x3D5 is the data for the index register
    // cursor HIGH port to vga INDEX register
    outb(0x0E,0x3D4); // unamsk the cursort we just wrote to
    outb((unsigned char )((position>>8)&0xFF),0x3D5); // update the position to allow cursor to adapt to position
}

/* clear_kbd_buf()
 * DESCRIPTION: sets all elements in kbd buffer to the empty char
 * INPUTS: none
 * OUTPUTS: an empty kbd buffer
 * RETURN VALE: void
 */
void clear_kbd_buf(){
    int i;
    for(i = 0; i< BUFFER_LIMIT; i++)
        kbd_buffer[i] = ' ';
}

/* scroll()
 * DESCRIPTION: moves screen up one line and clears current line
 * INPUTS: none
 * OUTPUTS: a shifted screen
 * RETURN VALE: void
 */
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
 * Inputs: uint_8* c = character to print from system call
 * Return Value: void
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
 *   Inputs: uint_8* c = character to print from keyboard
 *   Return Value: void
 *	  Function: Output a character to the console
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

/*
 * void clear_SYS_CALL_MAP()
 * DESCRIPTION: clears the map for program to see where system has put entry vs user
 * INPUTS: none
 * OUTPUTS: a cleared(zeroed) sys call map
 * RETURN VALUE: void
 */
void clear_SYS_CALL_MAP(){
    int i,j;
    for(i = 0; i < SCREEN_WIDTH; i++){
        for(j = 0; j < SCREEN_HEIGHT; j++){
            SYS_CALL_MAP[i][j] = 0;
        }
    }
}

/*
 * void clear_frame_buf()
 * DESCRIPTION: clears the frame buffer that is written into vga mem
 * INPUTS: none
 * OUTPUTS: a cleared frame buffer
 * RETURN VALUE: void
 */
void clear_frame_buf(){
    int i;
    for(i = 0;i < SCREEN_AREA;i++){
        if(i%2 == 0)
            frame_buffer[i] = ' ';
        else
            frame_buffer[i] = GREEN;
    }
}

/*
 * void display_screen()
 * DESCRIPTION: writes frame buffer into vga memory
 * INPUTS: none
 * OUTPUTS: screen displays contents of buffer
 * RETURN VALUE: void
 */
void display_screen(){
    memcpy((void *)VGA_MEM,(const void *)frame_buffer,SCREEN_AREA);
}

/* void terminal_open()
 * INPUT: NONE
 * OUTPUT: NONE
 * RETURN VALUE: void
 * DESCRIPTION: allows pic to recognize keyboard inputs and also initializes frame buffer and tools for use in terminal
 */
void terminal_open() {
    /* index of screen we are displaying */
    screen_x = 0;
    screen_y = 0;

    /* set cursor to top left of screen */
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
    outb(KBD_IRQ_LINE, KEYBOARD_IRQ);
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

    /* invalid or keypress that shouldn't be put into kbd buffer (alt etc) */
    if(keypress == 0)
        return;

    /* check for control shift l */
    if(CONTROL_ON == 1 && keypress == 'L'){
        //char test[] = "aaaaaaaaaafj;dlsafjkdsfdlksajfkd;safkdjsa;fdjslakfjdsl;afdkjsa;fdjskajfdsa;fkdsajf;dsjafkdjkasjfdkl;afskldjsalfkjdsalfjdkslajflds;ajfldsjafkdjsal;fjdksa;fdjka;fjdksa;jfkldsjaflkdsjaf;dlkafkdjskafjdsalf;dajfklsajfkldjsalkfjsakl;fjsadl;fksajfds;afjkl;sdajfldksjafl;dsakjflsdajflk;dsaflkdsajfkldsa;kdsjakfljdsalfjdsla;fjdklsjafldsajfkldsa;f";
        //terminal_write((const void *)test,(int32_t)strlen(test));
        terminal_open();
        return;
    }

    /* we have hit our 128 keypress limit and next char is not a delete or newline */
    if(KEYPRESSES == BUFFER_LIMIT && keypress != '\n' && keypress != '\b')
        return;

    /* accept keyboard input and write to frame buffer */
    put_at_coord(keypress);

    /* update cursor at new screen_X screen_y value */
    update_cursor(screen_y,screen_x);

    /* write frame buffer into vga mem */
    display_screen();

    return;
}

/*
 * terminal_write
 * INPUTS: const void * buf, int32_t nbytes
 * OUTPUTS: prints unlimited chars to buffer
 * RETURN VALUE: fail -1 or the number of bytes written
 * DESCRIPTION: Takes a buffer of size nybtes and writes it to the frame buffer without altering current kbd operations
 */
int32_t terminal_write(const void* buf, int32_t nbytes){

    /* check for invalid entries */
    if(nbytes < 0 || buf == NULL)
        return -1;

    int32_t retval = 0;
    int i;

    /* for each buffer entry up to nbytes, place into frame buffer and mark location as placed by sys call */
    for(i = 0; i < nbytes; i++){
        SYS_CALL_MAP[screen_x][screen_y] = 1;
        system_at_coord(((unsigned char*)buf)[i]);
        retval++;
    }


    update_cursor(screen_y,screen_x);
    display_screen();

    return retval;
}


/*
 * terminal_read
 * INPUTS: void * buf, int32_t nbytes
 * OUTPUTS: copies over the smaller of nybtes or OLD_KEYPRESSES to the provided buffer from kbd buffer, not screen
 * RETURN VALUE: number of bytes read or -1 on failure
 * DESCRIPTION: reads through kbd buffer and writes to given buffer of the smaller of two options and also clears the OLD_KEYPRESSES;
 */
int32_t terminal_read(void* buf, int32_t nbytes){

    /* check for valid entry */
    if(nbytes < 0 || nbytes > BUFFER_LIMIT || buf == NULL)
        return -1;

    /* demand new entry from user upon call to read (first case scenario) */
    OLD_KEYPRESSES = 0;

    /* wait for user to hit enter */
    while(OLD_KEYPRESSES == 0);

    /* move the kbd buffer over to the given buffer with length min(OLD_KEYPRESSES,nbytes) */
    memcpy(buf,(const void *)old_kbd_buffer,nbytes > OLD_KEYPRESSES? OLD_KEYPRESSES : nbytes);

    /* initializes return value */
    int32_t retval = 0;
    retval = nbytes > OLD_KEYPRESSES? OLD_KEYPRESSES : nbytes;

    /* flush OLD_KEYPRESSES to demand new entry for each read */
    OLD_KEYPRESSES = 0;

    return retval;
}

/*
 * test_terminal()
 * INPUTS: none
 * OUTPUTS: a fun program
 * RETURN VALUE: void
 * DESCRIPTION: a program to test the effectiveness of terminal driver
 */
void test_terminal(){
    int t_length = -1;
    unsigned char sol_buf[BUFFER_LIMIT];
    char test_buf[] = "What is your name? \n";
    terminal_write((const void*)test_buf,(int32_t)strlen(test_buf));

    t_length = terminal_read((void *)test_buf,(int32_t)BUFFER_LIMIT); // read up to one buffer size
    unsigned char new_test_buf[] = " sounds like a great name! What is your favorite color?\n";
    terminal_write((const void *)test_buf,(int32_t)t_length);
    terminal_write((const void *)new_test_buf,(int32_t)strlen((int8_t *)new_test_buf));

    t_length = terminal_read((void *)test_buf,(int32_t)BUFFER_LIMIT);
    terminal_write((const void *)test_buf,(int32_t)t_length);
    unsigned int color_length = t_length;
    terminal_write((const void *)" has ",(int32_t)5); // 5 is the length of the string " has "

    if(color_length >= 10){ // if 10 then we need to handle another digit to print to screen
        sol_buf[1] = (color_length%10) + '0'; // i to a, so shift using mod 10
        sol_buf[0] = (color_length/10) + '0'; // then take off a digit using /10
        t_length = 2; //digit length is 2 rather than one
    }
    else{
        sol_buf[0] = color_length + '0'; // if only one digit then its just one
        t_length = 1;
    }

    memcpy((void *)sol_buf + t_length, (const void *)" letters in it, there are ",26); // 26 is the length of the string
    int j,i,sol = 26; // 26 is the number of letters in the alphabet
    if(color_length == 0)
        sol = 0;
    while(color_length>1){
        sol *= 26; // computing x ^ 26
        color_length--;
    }

    i = 1;
    int count = 1;
    while(1){ // how many digits is sol?
        if(sol - i > 0){
            i *= 10; // shifting i to isolate only one digit at a time
            count++;
        }
        else
            break;
    }
    i /= 10; // because of while loop we need to shift the incrementor back one
    j = 1;
    count--;
    for(j = 0; j < count; j++){
        sol_buf[t_length + j + 26] = (sol / i) + '0'; // inside square brackets is calculation of buffer char location
        sol %= i;
        i /= 10; // shift incrementor
    }
    memcpy((void *)sol_buf + t_length+26+count, (const void *)" different words to make out of that many letters! \n",50); // 50 is the length of the string
    terminal_write((const void *)sol_buf,t_length+26 + count + 50); // 50 is th length of the above string, 26 is the original string
}
