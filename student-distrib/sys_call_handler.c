#include "sys_call_handler.h"

#define KERNEL_STACK _8Mb

unsigned long init_PCB_addr = _8Mb - _4Kb;

/*////////////////////////////////////////////////////////////////////////////*/
                    /* functions for stdio */
/*////////////////////////////////////////////////////////////////////////////*/
int32_t stdio_open(const uint8_t * filename){return -1;}
int32_t stdio_close(int32_t fd){return -1;}
int32_t stdin_read(int32_t fd,void * buf,int32_t nbytes){return -1;}
int32_t stdin_write(int32_t fd, const char* buf, int32_t nbytes){
    return terminal_write((const void *)buf,nbytes);
}
int32_t stdout_write(int32_t fd,const char* buf,int32_t nbytes){return -1;}
int32_t stdout_read(int32_t fd,void * buf,int32_t nbytes){
    return terminal_read(buf,nbytes);
}
/*////////////////////////////////////////////////////////////////////////////*/
/*////////////////////////////////////////////////////////////////////////////*/

static const fops_t file_jump_table = {
    .open = &file_open,
    .close = &file_close,
    .read = &file_read,
    .write = &file_write
};

static const fops_t dir_jump_table = {
    .open = &dir_open,
    .close = &dir_close,
    .read = &dir_read,
    .write = &dir_write
};

int32_t HALT (uint8_t status) {
    PCB_t* process;
    PCB_t* parent;


    process = get_PCB(); // get process to halt


    // TODO: Make it restart shell instead
    if(process->parent_process == -1){
        terminal_write((const void *)"tried to halt head",(int32_t)18);
        return -1;
    }

    /* switch pages to parent process */
    unload_process(process->parent_process);

    /* get parent using process number */
    parent = (PCB_t *)(init_PCB_addr - (_4Kb * process->parent_process));

    tss.esp0 = _8Mb - (_4Kb * (parent->process_id)) - 4;
    asm volatile("movl %0, %%esp   \n\
                  movl %1, %%ebp   \n\
                  movl %2, %%eax   \n\
                  jmp halt_child   \n\
                 "
                 : /*no outputs*/
                 :"r" (process->esp_holder), "r"(process->ebp_holder), "r"((int32_t)status)
                 :"%esp","%eax","%ebp"
                 );

    return 0;
}

int32_t EXECUTE (const uint8_t* command) {

    uint32_t start_point; // = get_start(file);
    uint32_t user_stack; // = _128Mb + _4Mb; //
    uint8_t to_execute[BUFFER_LIMIT + 1]; // to accomodate for addtl null terminator
    uint8_t* start = (uint8_t *)command;
    uint8_t* end;
    dentry_t file;
    unsigned long file_size, PCB_addr, parent_num;
    int process_num;
    PCB_t* parent_PCB;


    /* if command is NULL return fail */
    if (command == NULL)
        return -1;

    /* seperate out command vs args */
    while (*start != TERMINATOR && *start == SPACE)
        start++;

    if (*start == TERMINATOR)
        return -1;

    end = start;

    while (*end != TERMINATOR && *end != SPACE)
        end++;

    memcpy((void*)to_execute, (const void*)command, end - start);

    to_execute[end - start] = TERMINATOR;

    // Checks if file exists
    if (read_dentry_by_name(to_execute, &file) == -1) {
        terminal_write((const void*) to_execute, end - start);
        terminal_write(": command not found\n", 20);
        return -1;
    }

    // Checks if executable
    if (check_ELF(file) == -1) {
        terminal_write((const void*) to_execute, end - start);
        terminal_write(": file not executable\n", 22);
        return -1;
    }
    file_size = get_file_size(file);

    /* Sets up new page for process */
    process_num = load_process();
    if (process_num == -1) {
        terminal_write("Error: Too many processes\n", 26);
        return -1;
    }

    load_file(file);

    // Get current process num
    parent_PCB = get_PCB();
    parent_num = (unsigned long)parent_PCB;
    parent_num /= _4Kb;
    parent_num = 255 - parent_num;

    /* create new pcb for current task */
    PCB_t * process;


    // Gets address to place PCB for current process
    PCB_addr = init_PCB_addr - (_4Kb * process_num);
    process = (PCB_t *)PCB_addr;

    // head process
    if(process_num == 0)
        process->parent_process = -1; // this is parent_process so say -1
    else
        process->parent_process = (int8_t)parent_num; // say shell is the parent

    file_t stdin; // initialize std int
    stdin.file_position = -1;
    stdin.operations.open = &stdio_open;
    stdin.operations.close = &stdio_close;
    stdin.operations.read = &stdin_read;
    stdin.operations.write = &stdin_write;
    stdin.flags = IN_USE;

    file_t stdout; // initialize stdout
    stdin.file_position = -1;
    stdout.operations.open = &stdio_open;
    stdout.operations.close = &stdio_close;
    stdout.operations.write = &stdout_write;
    stdout.operations.read = &stdout_read;
    stdout.flags = IN_USE;

    process->file_descriptor[0] = stdin;
    process->file_descriptor[1] = stdout;
    process->mask = 0x3; // show that file_descriptor array has stdin and std out
    process->process_id = process_num; // Sets id

    start_point = get_start(file);
    user_stack = _128Mb + _4Mb; //

    /* put current esp and ebp into the pcb and tss*/
    asm volatile ("movl %%esp, %0  \n\
                   movl %%ebp, %1  \n\
                  "
                 :"=r" (process->esp_holder),"=r" (process->ebp_holder)
                 );

    tss.esp0 = _8Mb - (_4Kb * (process_num)) - 4; // account for inability to access last element of kernel page 0:79999... also esp will always be dependant on proces_num
    tss.ss0 = KERNEL_DS;

    /* http://wiki.osdev.org/Getting_to_Ring_3#Entering_Ring_3 */

    /*
    * according to intel manual:
    * IRET stack for privelage level switches:
    * SS(stack segment) -> 2B is user data segment
    * ESP(start of stack for user program) -> program image starts at 0x08048000,128mb plus 4mb pls 8 kb, so stack should start there?
    * EFLAGS -> remove from stack and alter to ensure trap flag is set saying we are in a user sys call
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
                  : "%eax","%edx"
              );
    asm volatile("halt_child:");
    //terminal_write("here!",5);
    //while(1);
    asm volatile("leave         \n\
                  ret           \n\
                  ");
   //terminal_write("arrived in execute",18);
   //while(1);

    return 0;

}
int32_t READ (int32_t fd, void* buf, int32_t nbytes) {

    unsigned long regVal;
    PCB_t* process;

    // Gets top of process stack
    asm("movl %%esp, %0;" : "=r" (regVal) : );
    // Gets top of process
    process = (PCB_t *)(regVal & _4Kb_MASK);

    // stdin
    if (fd == 0)
        return terminal_read(buf,nbytes);

    // stdout
    if (fd == 1)
        return -1;

    return (process->file_descriptor[fd]).operations.read(fd, buf, nbytes);
}
int32_t WRITE (int32_t fd, const void* buf, int32_t nbytes) {
    unsigned long regVal;
    PCB_t* process;

    // Gets top of process stack
    asm("movl %%esp, %0;" : "=r" (regVal) : );
    // Gets top of process
    process = (PCB_t *)(regVal & _4Kb_MASK);

    // stdin
    if (fd == 0)
        return -1;

    // stdout
    if (fd == 1)
        return terminal_write(buf,nbytes);



    return (process->file_descriptor[fd]).operations.write(fd, buf, nbytes);
}
int32_t OPEN (const uint8_t* filename) {
    unsigned long regVal;
    uint8_t mask = 0x01;
    int i, fd;
    PCB_t* process;
    dentry_t file;
    file_t new_entry;

    if (read_dentry_by_name(filename, &file) == -1)
        return -1;

    // Gets top of process stack
    asm("movl %%esp, %0;" : "=r" (regVal) : );
    // Gets top of process
    process = (PCB_t *)(regVal & _4Kb_MASK);

    for (i = 0; i < 8; i++) {
        if ((process->mask & (mask << i)) == 0)
            break;
        // All files in use
        if (i == 7)
            return -1;
    }
    fd = i;

    // Sets file as in use
    process->mask |= (mask << fd);

    switch (file.file_type) {
        case 0: break; // Need to fix RTC functions

        case 1:
            new_entry.operations = dir_jump_table;
            break;

        case 2:
            new_entry.operations = file_jump_table;
            break;
    }

    new_entry.inode = file.i_node_num;
    new_entry.file_position = 0;
    new_entry.flags = 0;

    process->file_descriptor[fd] = new_entry;

    return fd;
}
int32_t CLOSE (int32_t fd) {
    PCB_t* process;
    unsigned long regVal;
    uint8_t mask = 0x01;

    // Gets top of process stack
    asm("movl %%esp, %0;" : "=r" (regVal) : );
    // Gets top of process
    process = (PCB_t *)(regVal & _4Kb_MASK);

    // Clears bit at fd
    process->mask &= ~(mask << fd);

    return 0;
}
int32_t GETARGS (uint8_t* buf, int32_t nbytes) {
    return 0;
}
int32_t VIDMAP (uint8_t** screen_start) {
    return 0;
}
int32_t SET_HANDLER (int32_t signum, void* handler_address) {
    return 0;
}
int32_t SIGRETURN (void) {
    return 0;
}

PCB_t * get_PCB() {
    unsigned long regVal;

    // Gets top of process stack
    asm("movl %%esp, %0;" : "=r" (regVal) : );
    // Gets top of process stack
    return (PCB_t *)(regVal & _4Kb_MASK);;

}
