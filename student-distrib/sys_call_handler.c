#include "sys_call_handler.h"
#define KERNEL_STACK _8Mb

unsigned long init_PCB_addr = _8Mb - _4Kb;

/*////////////////////////////////////////////////////////////////////////////*/
/* functions for stdio */
/*////////////////////////////////////////////////////////////////////////////*/
static int32_t stdio_open(const uint8_t * filename) {return 0;}
static int32_t stdio_close(int32_t fd) {return 0;}

static int32_t stdin_read(int32_t fd, void * buf, int32_t nbytes) {
    return terminal_read(buf, nbytes);
}
static int32_t stdin_write(int32_t fd, const char* buf, int32_t nbytes) {return -1;}
static int32_t stdout_write(int32_t fd, const char* buf, int32_t nbytes) {
    return terminal_write((const void *)buf, nbytes);
}
static int32_t stdout_read(int32_t fd, void * buf, int32_t nbytes) {return -1;}
/*////////////////////////////////////////////////////////////////////////////*/
/*////////////////////////////////////////////////////////////////////////////*/

static fops_t file_jump_table = {
    .open = &file_open,
    .close = &file_close,
    .read = &file_read,
    .write = &file_write
};

static fops_t dir_jump_table = {
    .open = &dir_open,
    .close = &dir_close,
    .read = &dir_read,
    .write = &dir_write
};

static fops_t stdin_j_table = {
    .open = &stdio_open,
    .close = &stdio_close,
    .read = &stdin_read,
    .write = &stdin_write
};

static fops_t stdout_j_table = {
    .open = &stdio_open,
    .close = &stdio_close,
    .read = &stdout_read,
    .write = &stdout_write
};

static fops_t rtc_jump_table = {
    .open = &rtc_open,
    .close = &rtc_close,
    .read = &rtc_read,
    .write = &rtc_write
};

static file_t stdin;
static file_t stdout;

/* int32_t color
 * inputs: none
 * output: 0 on success, -1 on failure
 * function: changes terminal text color
 */
int32_t color() {
    unsigned char buf[1];
    int response;
    terminal_write("0: RED\n", 7);
    terminal_write("1: BLUE\n", 8);
    terminal_write("2: GREEN\n", 9);
    terminal_write("3: PURPLE\n", 10);
    terminal_write("4: ORANGE\n", 10);
    terminal_write("5: WHITE\n", 9);
    terminal_write("6: RAINBOW\n", 11);
    terminal_write("ENTER DESIRED TEXT COLOR: ", 26);
    terminal_read((void *)buf, 1);
    response = buf[0] - '0';
    if (response > 6 || response < 0) {
        terminal_write("not a color\n", 12);
        return 0;
    }
    change_color(response);
    return 0;
}
/* int32_t HALT
 * inputs: status, to be expanded to 32 bits and returned to user
 * output: 0 dummy
 * function: frees up the process in memory, and resets to parent process
 */
int32_t HALT (uint8_t status) {
    PCB_t* process;
    PCB_t* parent;
    int i;

    process = get_PCB(); // get process to halt

    // Closes all the files
    for (i = 2; i < MAX_FILES; i++)
        CLOSE(i);



    if (process->parent_process == -1) {
        free_gucci(process->process_id); // allows us use id 0 again
        terminal_open();
        EXECUTE((const uint8_t *)"shell");
        return 0;
    }

    /* switch pages to parent process */
    unload_process(process->process_id, process->parent_process);

    /* get parent using process number */
    parent = (PCB_t *)(init_PCB_addr - (_4Kb * process->parent_process));

    tss.esp0 = _8Mb - (_4Kb * (parent->process_id)) - 4; // 4 is because last elem is not included 0 -> (N-1)
    asm volatile("movl %0, %%esp   \n\
                  movl %1, %%ebp   \n\
                  movl %2, %%eax   \n\
                  jmp halt_child   \n\
                 "
                 : /*no outputs*/
                 :"r" (process->esp_holder), "r"(process->ebp_holder), "r"((int32_t)status)
                 :"%esp", "%eax", "%ebp"
                );


    return 0;
}

/* int32_t EXECUTE
 * inputs: a string command to execute an ELF
 * output: 0 dummy
 * function: takes name of elf and possible arg, loads program into mem, makes a pcb and travels to ring 3
 */
int32_t EXECUTE (const uint8_t* command) {

    uint32_t start_point; // = get_start(file);
    uint32_t user_stack; // = _128Mb + _4Mb; //
    uint8_t cpy_buffer[BUFFER_LIMIT + 1]; // to accomodate for addtl null terminator
    int8_t *start_exe, *end_exe, *start_args, *end_args;
    int32_t len_exe, len_args;
    dentry_t file;
    unsigned long file_size, PCB_addr, parent_num;
    int process_num;
    PCB_t* parent_PCB;


    /* if command is NULL return fail */
    if (command == NULL)
        return -1;

    /* parse the executable file */
    start_exe = (int8_t*)command;
    start_exe = strxchr(start_exe, SPACE);
    if (*start_exe == TERMINATOR)
        return -1;

    end_exe = strchr(start_exe, SPACE);

    len_exe = end_exe - start_exe;
    memcpy((void*)cpy_buffer, (const void*)start_exe, len_exe);

    cpy_buffer[len_exe] = TERMINATOR;
    if (strncmp((const int8_t *)cpy_buffer, (const int8_t *)"color", 5) == 0) {
        color();
        return 0;
    }

    // Checks if file exists
    if (read_dentry_by_name(cpy_buffer, &file) == -1) {
        terminal_write((const void*) cpy_buffer, len_exe);
        terminal_write(": command not found\n", 20); // 20 is length of string
        return -1;
    }

    // Checks if executable
    if (check_ELF(file) == -1) {
        terminal_write((const void*) cpy_buffer, len_exe);
        terminal_write(": file not executable\n", 22); // 22 is length of string
        return -1;
    }
    file_size = get_file_size(file);

    /* parse the arguments */
    start_args = end_exe;
    start_args = strxchr(start_args, SPACE);

    end_args = strchr(start_args, TERMINATOR);

    len_args = end_args - start_args;
    memcpy((void*)cpy_buffer, (const void*)start_args, len_args);

    cpy_buffer[len_args] = TERMINATOR;


    /* Sets up new page for process */
    process_num = load_process();
    if (process_num == -1) {
        terminal_write("Error: Too many processes\n", 26); // 26 is length of string
        return -1;
    }

    load_file(file);

    // Get current process num
    parent_PCB = get_PCB();
    parent_num = (unsigned long)parent_PCB;
    parent_num /= _4Kb;
    parent_num = 255 - parent_num; // 255 is int max for 8 bit uinsigned int

    /* create new pcb for current task */
    PCB_t * process;

    // Gets address to place PCB for current process
    PCB_addr = init_PCB_addr - (_4Kb * process_num);
    process = (PCB_t *)PCB_addr;
    cur_process = process;

    // head process
    if (process_num == 0)
        process->parent_process = -1; // this is parent_process so say -1
    else
        process->parent_process = (int8_t)parent_num; // say shell is the parent

    process->file_descriptor[0] = stdin;
    process->file_descriptor[1] = stdout;
    process->mask = 0x3; // show that file_descriptor array has stdin and std out ie 00000011
    process->process_id = process_num; // Sets id
    memcpy((void*)(process->args), (const void*)cpy_buffer, len_args);
    process->args[len_args] = TERMINATOR;

    start_point = get_start(file);
    user_stack = _128Mb + _4Mb; //print

    /* put current esp and ebp into the pcb and tss*/
    asm volatile ("movl %%esp, %0  \n\
                   movl %%ebp, %1  \n\
                  "
                  :"=r" (process->esp_holder), "=r" (process->ebp_holder)
                 );

    tss.esp0 = _8Mb - (_4Kb * (process_num)) - 4; // account for inability to access last element of kernel page 0:79999... also esp will always be dependant on proces_num
    tss.ss0 = KERNEL_DS;

    /* http://wiki.osdev.org/Getting_to_Ring_3#Entering_Ring_3 */

    /*
     * according to intel manual:
     * IRET stack for privelage level switches:
     * SS(stack segment) -> 2B is user data segment
     * ESP(start of stack for user program) -> program image starts at 0x08048000,128mb plus 4mb pls 8 kb, so stack should start there?
     * EFLAGS -> remove from stack and alter to ensure trap flag is set saying we are in a user sys call, trap flag waits for int flag
     * CS -> user code segment 0x23
     * EIP -> from ELF
     * iret
     */

    asm volatile(
        "cli             \n\
                  movw $0x2B, %%ax \n\
                  movw %%ax, %%ds  \n\
                  push $0x2B       \n\
                  push %1          \n\
                  pushf            \n\
                  pop %%edx        \n\
                  or $0x200,%%edx  \n\
                  push %%edx       \n\
                  push $0x23       \n\
                  push %0          \n\
                  iret             \n\
                  "
        :
        : "r" (start_point), "r"(user_stack)
        : "%eax", "%edx"
    );
    asm volatile("halt_child:   \n\
                  leave         \n\
                  ret           \n\
                  "
                );

    return 0;

}

/* int32_t READ
 * inputs: a file descriptor to tell what kind of read, buf to read into, and num bytes to read
 * output: 0 dummy
 * function: takes a given pcb and reads using general fd pcb methods
 */
int32_t READ (int32_t fd, void* buf, int32_t nbytes) {
    
    // Invalid fd
    if (fd < 0 || fd > MAX_FILES - 1 || buf == NULL)
        return -1;

    if (cur_process->file_descriptor[fd].flags != IN_USE)
        return -1;

    return (cur_process->file_descriptor[fd]).operations->read(fd, buf, nbytes);
}

/* int32_t WRITE
 * inputs: a file descriptor to tell what kind of write, buf to write from, and num bytes to write
 * output: 0 dummy
 * function: takes a given pcb and writes using general fd pcb methods
 */
int32_t WRITE (int32_t fd, const void* buf, int32_t nbytes) {

    // Invalid fd
    if (fd < 0 || fd > MAX_FILES - 1 || buf == NULL)
        return -1;

    if (cur_process->file_descriptor[fd].flags != IN_USE)
        return -1;

    return (cur_process->file_descriptor[fd]).operations->write(fd, buf, nbytes);
}

/* int32_t OPEN
 * inputs: a filename to open
 * output: fd of file, -1 on bad
 * function: takes a given pcb and opens a dentry to get inode
 */
int32_t OPEN (const uint8_t* filename) {
    uint8_t mask = 0x01; // bitwise mask
    int i, fd;
    PCB_t* process;
    dentry_t file;
    file_t new_entry;

    if (read_dentry_by_name(filename, &file) == -1)
        return -1;

    process = get_PCB();

    for (i = 0; i < MAX_FILES; i++) {
        if ((process->mask & (mask << i)) == 0)
            break;
        // All files in use
        if (i == MAX_FILES - 1)
            return -1;
    }
    fd = i;

    // Sets file as in use
    process->mask |= (mask << fd);

    switch (file.file_type) {
    case 0:
        new_entry.operations = &rtc_jump_table;
        break;

    case 1:
        new_entry.operations = &dir_jump_table;
        break;

    case 2:
        new_entry.operations = &file_jump_table;
        break;
    }

    new_entry.inode = file.i_node_num;
    new_entry.file_position = new_entry.operations->open(filename);
    new_entry.flags = IN_USE;

    process->file_descriptor[fd] = new_entry;

    return fd;
}

/* int32_t CLOSE
 * inputs: a file descriptor to tell what to close
 * output: 0 dummy
 * function: gets current pcb and declares it free in our global mask
 */
int32_t CLOSE (int32_t fd) {
    PCB_t* process;
    uint8_t mask = 0x01;

    process = get_PCB();

    // Invalide fd
    if (fd < 2 || fd > MAX_FILES - 1)
        return -1;

    if (process->file_descriptor[fd].flags != IN_USE)
        return -1;

    // Clears bit at fd
    process->mask &= ~(mask << fd);

    // Marks not in use
    process->file_descriptor[fd].flags = 0;

    (void)(process->file_descriptor[fd]).operations->close(fd);

    return 0;
}

/* int32_t GETARGS
 * inputs: buf - buffer to copy
 *         nbytes - amount of bytes to read
 * output: 0 on success, -1 on failure
 * function: gets arguments of input
 */
int32_t GETARGS (uint8_t* buf, int32_t nbytes) {
    PCB_t* process = get_PCB();
    (void)strncpy((int8_t*)buf, (const int8_t*)(process->args), nbytes);
    return 0;
}

/* int32_t VIDMAP
 * inputs: screen_start - where to write 
 * output: 0 on success, -1 on failure
 * function: allows user to write to vidmem
 */
#define VIDMAP_LOC _128Mb + _8Mb
int32_t VIDMAP (uint8_t** screen_start) {
    /* check to see if start is within user program image */
    if (screen_start < (uint8_t **)_128Mb) { // before program image start
        //terminal_write("flag1",5);
        return -1;
    }
    if (screen_start > (uint8_t **)(_128Mb + _4Mb - 4)) { // after program image start
        //terminal_write("flag2",5);
        return -1;
    }

    /* we built the page for user access to vid memory in kernel.c */
    *screen_start = (uint8_t *)VIDMAP_LOC;

    /* http://wiki.osdev.org/Printing_To_Screen */

    // program image is _8Mb so map video mem at 128 + 8 mb = _136MB

    return VIDMAP_LOC;

}
/* int32_t SET_HANDLER
 * inputs:
 * output:
 * function:
 */
int32_t SET_HANDLER (int32_t signum, void* handler_address) {
    return -1;
}

/* int32_t SIGRETURN
 * inputs:
 * output:
 * function:
 */
int32_t SIGRETURN (void) {
    return -1;
}

/* PCB_t get_PCB
 * inputs: none
 * output: a pointer to the top pcb currently at use
 * function: looks at the top of the pcb stack and returns the base pointer
 */
PCB_t * get_PCB() {
    unsigned long regVal;

    // Gets top of process stack
    asm("movl %%esp, %0;" : "=r" (regVal) : );
    // Gets top of process stack
    return (PCB_t *)(regVal & _4Kb_MASK);;

}

/* init_stdio
 * inputs: none
 * outputs: none
 * function: initializes the rest of the file categories besides fops
 */
void init_stdio() {
    stdin.file_position = -1;
    stdin.operations = &stdin_j_table;
    stdin.flags = IN_USE;

    stdout.file_position = -1;
    stdout.operations = &stdout_j_table;
    stdout.flags = IN_USE;

    return;
}
