/* http://arjunsreedharan.org/post/99370248137/kernel-201-lets-write-a-kernel-with-keyboard */

#include "keyboard.h"

static unsigned char old_kbd_buffer1[BUFFER_LIMIT] = "",
        old_kbd_buffer2[BUFFER_LIMIT] = "",
                                        old_kbd_buffer3[BUFFER_LIMIT] = "";
static unsigned char* old_kbd_buffers[MAX_TASKS] = {old_kbd_buffer1, old_kbd_buffer2, old_kbd_buffer3};
static unsigned char keyboard_buffer1[BUFFER_LIMIT] = "",
        keyboard_buffer2[BUFFER_LIMIT] = "",
                keyboard_buffer3[BUFFER_LIMIT] = "";// keyboard buffer of 128 bytes including new line
static unsigned char* keyboard_buffers[MAX_TASKS] = {keyboard_buffer1, keyboard_buffer2, keyboard_buffer3};
static unsigned char frame_buffer1[SCREEN_AREA] __attribute__((aligned(4 * Kb)));
static unsigned char frame_buffer2[SCREEN_AREA] __attribute__((aligned(4 * Kb)));
static unsigned char frame_buffer3[SCREEN_AREA] __attribute__((aligned(4 * Kb)));
static unsigned char* frame_buffers[MAX_TASKS] = {frame_buffer1, frame_buffer2, frame_buffer3};
static unsigned char dummy_buffer1[SCREEN_AREA] = "",
        dummy_buffer2[SCREEN_AREA] = "",
                                     dummy_buffer3[SCREEN_AREA] = "";
static unsigned char* dummy_buffers[MAX_TASKS] = {dummy_buffer1, dummy_buffer2, dummy_buffer3};
static volatile uint32_t keypresses[MAX_TASKS] = {0, 0, 0};
static volatile uint32_t buffer_wait[MAX_TASKS] = {0, 0, 0};
static volatile uint32_t old_keypresses[MAX_TASKS] = {0, 0, 0};
static volatile uint32_t screen_x[MAX_TASKS] = {0, 0, 0};
static volatile uint32_t screen_y[MAX_TASKS] = {0, 0, 0};
static volatile uint8_t TEXT_C = GREEN;
static int r_array[] = {4, 6, 2, 1, 5};
static int r_index = 0;
static int RAINBOW = 0;
static volatile uint32_t cur_task = 0;



static volatile unsigned long curr_terminal = 0;
uint32_t vid_backpages[MAX_TERMINALS] = {0, 0, 0};

/*
* get_buf_add()
* Description: returns address of selected buffer
* input: select - what buffer to return
* output: none
* return value: address of buffer
*/
unsigned char * get_buf_add(uint8_t select) {
    return frame_buffers[select];
}

/*
* get_cur_term()
* Description: returns current terminal
* input: none
* output: none
* return value: current terminal
*/
uint8_t get_cur_term() {
    return curr_terminal;
}

/*
* change_color()
* Description: changes termianl color
* input: new_c - color index
* output: termianl color is differen
* return value: none
*/
void change_color(int new_c) {
    switch (new_c) {
    case 0:
        TEXT_C = 4;
        RAINBOW = 0;
        break;
    case 1:
        TEXT_C = 1;
        RAINBOW = 0;
        break;
    case 2:
        TEXT_C = 2;
        RAINBOW = 0;
        break;
    case 3:
        TEXT_C = 5;
        RAINBOW = 0;
        break;
    case 4:
        TEXT_C = 6;
        RAINBOW = 0;
        break;
    case 5:
        TEXT_C = 7;
        RAINBOW = 0;
        break;
    case 6:
        TEXT_C = 4;
        RAINBOW = 1;
        r_index = 0;
        break;
    default:
        break;
    }


}
/* void update_cursor(int row, int col)
 * Description: updates cursor to given x and y coordinates,
 * most likely screen_y screen_x
 * by Dark Fiber
 * http://wiki.osdev.org/Text_Mode_Cursor
 */
void update_cursor(int row, int col)
{
    unsigned short position = (row * SCREEN_WIDTH) + col;

    // cursor LOW port to vga INDEX register
    outb(0x0F, 0x3D4); // 0x3D4 is the address of the vga index register
    outb((unsigned char)(position & 0xFF), 0x3D5); // 0x3D5 is the data for the index register
    // cursor HIGH port to vga INDEX register
    outb(0x0E, 0x3D4); // unamsk the cursort we just wrote to
    outb((unsigned char )((position >> 8) & 0xFF), 0x3D5); // update the position to allow cursor to adapt to position
}

/* clear_kbd_buf()
 * DESCRIPTION: sets all elements in kbd buffer to the empty char
 * INPUTS: term - terminal buffer index to clear
 * OUTPUTS: an empty kbd buffer
 * RETURN VALE: void
 */
static void clear_kbd_buf(uint32_t term) {
    int i;
    for (i = 0; i < BUFFER_LIMIT; i++)
        keyboard_buffers[term][i] = ' ';
}

/* scroll()
 * DESCRIPTION: moves screen up one line and clears current line
 *              to be called by a system call
 * INPUTS: buf_idx - index of buffer to select for scrolling
 * OUTPUTS: a shifted screen
 * RETURN VALE: void
 */
static void scroll(uint32_t buf_idx) {
    int i;
    memcpy((void *)dummy_buffers[buf_idx],
           (const void *)(frame_buffers[buf_idx]) +
           (SCREEN_WIDTH * VGA_CONVENTION),
           SCREEN_AREA - (SCREEN_WIDTH * VGA_CONVENTION));

    for (i = SCREEN_AREA - (SCREEN_WIDTH * VGA_CONVENTION); i < SCREEN_AREA; i++) {
        if (i % 2 == 0)
            dummy_buffers[buf_idx][i] = ' ';
        else
            dummy_buffers[buf_idx][i] = TEXT_C;
    }

    memcpy((void *)(frame_buffers[buf_idx]),
           (const void *)dummy_buffers[buf_idx], SCREEN_AREA);
}


/*
 * void system_at_coord(uint8_t c);
 * Inputs: uint_8* c = character to print from system call
 * Return Value: void
 *  Function: Output a character to the console
 */
static void
system_at_coord(uint8_t c)
{
    uint32_t buffer_idx = cur_task_index;
    if (c == '\n' || c == '\r') {
        if (screen_y[buffer_idx] == MAX_HEIGHT_INDEX) {
            scroll(buffer_idx);
        }
        else
            screen_y[buffer_idx]++;
        screen_x[buffer_idx] = 0;
        if (buffer_idx == curr_terminal)
            display_screen();
        return;
    }


    if (c == '\b') {
        if (screen_x[buffer_idx] == 0) {
            screen_x[buffer_idx] = MAX_WIDTH_INDEX;
            screen_y[buffer_idx]--;
        }
        else {
            screen_x[buffer_idx]--;
            screen_x[buffer_idx] %= SCREEN_WIDTH;
            screen_y[buffer_idx] = (screen_y[buffer_idx] +
                                    (screen_x[buffer_idx] / SCREEN_WIDTH)) % SCREEN_HEIGHT;
        }
        *(uint8_t *)(frame_buffers[buffer_idx] +
                     ((SCREEN_WIDTH * screen_y[buffer_idx] + screen_x[buffer_idx]) << 1)) = ' ';
        *(uint8_t *)(frame_buffers[buffer_idx] +
                     ((SCREEN_WIDTH * screen_y[buffer_idx] + screen_x[buffer_idx]) << 1) + 1) = TEXT_C;
    }
    else {
        *(uint8_t *)(frame_buffers[buffer_idx] +
                     ((SCREEN_WIDTH * screen_y[buffer_idx] + screen_x[buffer_idx]) << 1)) = c;
        *(uint8_t *)(frame_buffers[buffer_idx] +
                     ((SCREEN_WIDTH * screen_y[buffer_idx] + screen_x[buffer_idx]) << 1) + 1) = TEXT_C;
        screen_x[buffer_idx]++;
        if (screen_x[buffer_idx] == SCREEN_WIDTH && screen_y[buffer_idx] == MAX_HEIGHT_INDEX) {
            scroll(buffer_idx);
            screen_y[buffer_idx] = MAX_HEIGHT_INDEX;
        }
        else
            screen_y[buffer_idx] = (screen_y[buffer_idx] +
                                    (screen_x[buffer_idx] / SCREEN_WIDTH)) % SCREEN_HEIGHT;
        screen_x[buffer_idx] %= SCREEN_WIDTH;
    }
    return;
}

/*
 * void put_at_coord(uint8_t c);
 *   Inputs: uint_8* c = character to print from keyboard
 *   Return Value: void
 *    Function: Output a character to the console
 */
static void
put_at_coord(uint8_t c)
{
    uint32_t buffer_idx = curr_terminal;
    if (c == '\n' || c == '\r') {
        if (screen_y[buffer_idx] == MAX_HEIGHT_INDEX) {
            scroll(buffer_idx);
        }
        else
            screen_y[buffer_idx]++;
        /* when enter is pressed, we need to store our state for terminal read */
        old_keypresses[buffer_idx] = keypresses[buffer_idx];
        memcpy((void *)old_kbd_buffers[buffer_idx], (const void *)keyboard_buffers[buffer_idx], BUFFER_LIMIT);
        buffer_wait[buffer_idx] = 0;

        screen_x[buffer_idx] = 0;
        keypresses[buffer_idx] = 0; // no keypresses recoreded
        clear_kbd_buf(buffer_idx); // clear the keyboard buffer
        if (buffer_idx == cur_task_index)
            display_screen();
        return;
    }


    if (c == '\b' && keypresses[buffer_idx] > 0) {
        keypresses[buffer_idx]--;
        keyboard_buffers[buffer_idx][keypresses[buffer_idx]] = ' ';

        if (screen_x[buffer_idx] == 0) {
            screen_x[buffer_idx] = MAX_WIDTH_INDEX;
            screen_y[buffer_idx]--;
        }
        else {
            screen_x[buffer_idx]--;
            screen_x[buffer_idx] %= SCREEN_WIDTH;
            screen_y[buffer_idx] = (screen_y[buffer_idx] +
                                    (screen_x[buffer_idx] / SCREEN_WIDTH)) % SCREEN_HEIGHT;
        }
        *(uint8_t *)(frame_buffers[buffer_idx] +
                     ((SCREEN_WIDTH * screen_y[buffer_idx] + screen_x[buffer_idx]) << 1)) = ' ';
        *(uint8_t *)(frame_buffers[buffer_idx] +
                     ((SCREEN_WIDTH * screen_y[buffer_idx] + screen_x[buffer_idx]) << 1) + 1) = TEXT_C;
    }
    else if (c != '\b') {
        *(uint8_t *)(frame_buffers[buffer_idx] +
                     ((SCREEN_WIDTH * screen_y[buffer_idx] + screen_x[buffer_idx]) << 1)) = c;
        *(uint8_t *)(frame_buffers[buffer_idx] +
                     ((SCREEN_WIDTH * screen_y[buffer_idx] + screen_x[buffer_idx]) << 1) + 1) = TEXT_C;
        screen_x[buffer_idx]++;
        if (screen_x[buffer_idx] == SCREEN_WIDTH && screen_y[buffer_idx] == MAX_HEIGHT_INDEX) {
            scroll(buffer_idx);
            screen_y[buffer_idx] = MAX_HEIGHT_INDEX;
        }
        else
            screen_y[buffer_idx] = (screen_y[buffer_idx] +
                                    (screen_x[buffer_idx] / SCREEN_WIDTH)) % SCREEN_HEIGHT;
        screen_x[buffer_idx] %= SCREEN_WIDTH;
        keyboard_buffers[buffer_idx][keypresses[buffer_idx]] = c;
        keypresses[buffer_idx]++;

    }
    return;
}



/*
 * void clear_frame_buf()
 * DESCRIPTION: clears the frame buffer that is written into vga mem
 * INPUTS: buf_idx - index of buffer to clear
 * OUTPUTS: a cleared frame buffer
 * RETURN VALUE: void
 */
static void clear_frame_buf(uint32_t buf_idx) {
    int i;
    for (i = 0; i < SCREEN_AREA; i++) {
        if (i % 2 == 0)
            frame_buffers[buf_idx][i] = ' ';
        else
            frame_buffers[buf_idx][i] = TEXT_C;
    }
}

/*
 * void clear_all_frame_buf()
 * DESCRIPTION: clears all the frame buffer that is written into vga mem
 * INPUTS: none
 * OUTPUTS: a cleared frame buffer
 * RETURN VALUE: none
 */
void clear_all_frame_buf() {
    int i, j;
    for (j = 0; j < 3; j++) {
        for (i = 0; i < SCREEN_AREA; i++) {
            if (i % 2 == 0)
                frame_buffers[j][i] = ' ';
            else
                frame_buffers[j][i] = TEXT_C;
        }
    }
}

/*
 * void display_screen()
 * DESCRIPTION: writes frame buffer into vga memory
 * INPUTS: none
 * OUTPUTS: screen displays contents of buffer
 * RETURN VALUE: void
 */
void display_screen() {
    memcpy((void *)VGA_MEM, (const void *)frame_buffers[curr_terminal],
           SCREEN_AREA);
}

/*
 * void refresh_terminal(uint32_t index)
 * INPUT: index - terminal index to clear
 * OUTPUT: None
 * RETURNS: void
 * DESCRIPTION: refreshes the terminal at speicified index
 */

static void refresh_terminal(uint32_t index) {

    /*(unsigned char *)frame_buffer1 = (unsigned char *)(_136Mb + 4*Kb);
    (unsigned char *)frame_buffer2 = (unsigned char *)(_136Mb + 8*Kb);
    (unsigned char *)frame_buffer3 = (unsigned char *)(_136Mb + 12*Kb);*/
    int i;
    /* index of screen we are displaying */
    screen_x[index] = 0;
    screen_y[index] = 0;

    for (i = 0; i < MAX_TERMINALS; i++)
        vid_backpages[i] = (uint32_t)frame_buffers[i];

    /* set cursor to top left of screen */
    if (index == curr_terminal)
        update_cursor(screen_y[index], screen_x[index]);

    /* number of keypresses we have seen */
    old_keypresses[index] = 0;
    keypresses[index] = 0;

    /* clear the keyboard buffer */
    clear_kbd_buf(index);

    /* clear the frame buffer */
    clear_frame_buf(index);

    /*display the blank frame buffer*/
    if (index == curr_terminal)
        display_screen();

    /*allow for interrupts from keyboard via APIC*/
    enable_irq(KBD_IRQ_LINE);
}

/* void terminal_open()
 * INPUT: NONE
 * OUTPUT: NONE
 * RETURN VALUE: void
 * DESCRIPTION: allows pic to recognize keyboard inputs and also initializes
 * frame buffer and tools for use in terminal
 */
void terminal_open() {

    /*(unsigned char *)frame_buffer1 = (unsigned char *)(_136Mb + 4*Kb);
    (unsigned char *)frame_buffer2 = (unsigned char *)(_136Mb + 8*Kb);
    (unsigned char *)frame_buffer3 = (unsigned char *)(_136Mb + 12*Kb);*/
    refresh_terminal(cur_task);
}

/* void keyboard_write(unsigned char keypress, uint8_t CONTROL_ON)
 * INPUT: a char to write to keyboard and a flag to tell if control is on
 * OUTPUT: NONE
 * RETURN VALUE: void
 * DESCRIPTION: writes char to frame buffer and displays upon a keyboard interrupt
 */
void keyboard_write(unsigned char keypress, uint8_t CONTROL_ON) {

    /* CONTROL SHIFT L seen */
    if (keypress == '\b' && screen_x[curr_terminal] == 0 && keypresses[curr_terminal] == 0) {
        return;
    }

    /* invalid or keypress that shouldn't be put into kbd buffer (alt etc) */
    if (keypress == 0)
        return;

    /* check for control shift l */
    if (CONTROL_ON == 1 && keypress == 'L') {
        //terminal_write((const void *)test,(int32_t)strlen(test));
        refresh_terminal(curr_terminal);
        //terminal_write((const void *)PROMPT, (int32_t)7); //write a prompt with length 7 chars
        return;
    }

    /* we have hit our 128 keypress limit and next char is not a delete or newline */
    if (keypresses[curr_terminal] == BUFFER_LIMIT && keypress != '\n' && keypress != '\b')
        return;

    /* user is not requesting keyboard strokes - must reject */
    if (buffer_wait[curr_terminal] == 0)
        return;

    /* accept keyboard input and write to frame buffer */
    put_at_coord(keypress);
    if (RAINBOW) {
        TEXT_C = r_array[r_index];
        r_index = (r_index + 1) % 5;
    }

    /* update cursor at new screen_X screen_y value */
    if (cur_task_index == curr_terminal)
        update_cursor(screen_y[curr_terminal], screen_x[curr_terminal]);

    /* write frame buffer into vga mem */
    if (cur_task_index == curr_terminal)
        display_screen();

    return;
}

/*
 * terminal_write
 * INPUTS: const void * buf, int32_t nbytes
 * OUTPUTS: prints unlimited chars to buffer
 * RETURN VALUE: fail -1 or the number of bytes written
 * DESCRIPTION: Takes a buffer of size nybtes and writes it to the frame
 * buffer without altering current kbd operations
 */
int32_t terminal_write(const void* buf, int32_t nbytes) {

    /* check for invalid entries */
    if (nbytes < 0 || buf == NULL)
        return -1;

    int32_t retval = 0;
    int i;

    /* for each buffer entry up to nbytes, place into frame buffer
    and mark location as placed by sys call */
    for (i = 0; i < nbytes; i++) {
        system_at_coord(((unsigned char*)buf)[i]);
        if (RAINBOW) {
            TEXT_C = r_array[r_index];
            r_index = (r_index + 1) % 5;
        }
        retval++;
    }

    if (cur_task_index == curr_terminal)
        update_cursor(screen_y[cur_task_index], screen_x[cur_task_index]);
    if (cur_task_index == curr_terminal)
        display_screen();

    return retval;
}


/*
 * terminal_read
 * INPUTS: void * buf, int32_t nbytes
 * OUTPUTS: copies over the smaller of nybtes or old_keypresses to the provided
 * buffer from kbd buffer, not screen
 * RETURN VALUE: number of bytes read or -1 on failure
 * DESCRIPTION: reads through kbd buffer and writes to given buffer of the
 * smaller of two options and also clears the old_keypresses;
 */
int32_t terminal_read(void* buf, int32_t nbytes) {

    /* check for valid entry */
    if (nbytes < 0 || buf == NULL)
        return -1;

    /* demand new entry from user upon call to read (first case scenario) */
    old_keypresses[cur_task_index] = 0;

    /* wait for user to hit enter */
    buffer_wait[cur_task_index] = 1;
    while (buffer_wait[cur_task_index] == 1);

    /* move the kbd buffer over to the given buffer with length min(old_keypresses,nbytes) */
    memcpy(buf, (const void *)old_kbd_buffers[cur_task_index],
           nbytes > old_keypresses[cur_task_index] ? old_keypresses[cur_task_index] + 1 : nbytes + 1);

    /* initializes return value */
    int32_t retval = 0;
    retval = nbytes > old_keypresses[cur_task_index] ? old_keypresses[cur_task_index] : nbytes;
    ((unsigned char *)buf)[retval] = '\n';
    retval++;
    /* flush old_keypresses to demand new entry for each read */
    old_keypresses[cur_task_index] = 0;

    return retval;
}

/*
 * switch_terms
 * INPUTS: direction - which terminal to open
 * OUTPUTS: none
 * RETURN VALUE: none
 * DESCRIPTION: switches the terminal to the one specified by direction
 */
void switch_terms(int8_t direction) {
    //cli();

    /* store current frame buffer at a slave page */
    //memcpy((void *)_136Mb + ((curr_terminal+1) *4*Kb),(const void *)frame_buffer,4*Kb);

    /* store cursor location */
    //x_holder[curr_terminal] = screen_x;
    //y_holder[curr_terminal] = screen_y;

    /* store keypresses */
    //key_holder[curr_terminal] = keypresses;

    /* change to the next terminal */

    curr_terminal = direction;

    // TODO: switch PCB to next shell and string of child processes

    /* copy from slave page of new terminal to our current page */
    //memcpy((void *)frame_buffer,(const void *)(_136Mb + ((curr_terminal+1) *4*Kb)),4*Kb); // load image from new slave page

    update_cursor(screen_y[curr_terminal], screen_x[curr_terminal]);

    /* push frame buffer to vga mem */
    display_screen(curr_terminal);
    //change_process_vid_mem(curr_terminal, cur_task);

    //sti();
}

/*
 * update_term
 * INPUTS: task_id - the task to update
 * OUTPUTS: none
 * RETURN VALUE: none
 * DESCRIPTION: updates terminal screen if needed
 */
void update_term(uint32_t task_id) {

    if (task_id == curr_terminal) {
        update_cursor(screen_y[curr_terminal], screen_x[curr_terminal]);
        display_screen(curr_terminal);
    }
    //change_process_vid_mem(curr_terminal, task_id);
    cur_task = task_id;
}
