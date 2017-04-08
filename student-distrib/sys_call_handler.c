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

int32_t HALT (uint8_t status) {
    terminal_write((const void *)"test halt", (int32_t)9);
    return 0;
}

int32_t EXECUTE (const uint8_t* command) {

    /*parse the command */
    //uint8_t * arg;
    uint8_t to_execute[BUFFER_LIMIT + 1]; // to accomodate for addtl null terminator
    uint8_t* start = (uint8_t *)command;
    uint8_t* end;
    dentry_t file;
    unsigned long file_size, PCB_addr;
    int process_num;


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
    if (!check_ELF(file)) {
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

    /* TODO: Load file */
    // load_file(file);

    /* create new pcb for current task */
    PCB_t * process;

    // Gets address to place PCB for current process
    PCB_addr = init_PCB_addr - (_4Kb * process_num);
    process = (PCB_t *)PCB_addr;

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
    process->mask = 0x3; // show that file_descriptor has stdin and std out
    process->process_id = process_num; // Sets id

    /* put current esp and ebp into the pcb and tss*/
    asm volatile ("movl %%esp, %0  \n\
                   movl %%ebp, %1  \n\
                  "
                 :"=r" (process->esp_holder),"=r" (process->ebp_holder)
                 );
    tss.esp0 = _8Mb - 4; // account for inability to access last element of kernel page 0:79999...
    tss.ss0 = KERNEL_CS;
    terminal_write("Gucci\n", 6);
    /* TODO: initiate context switch*/

    /*http://wiki.osdev.org/Getting_to_Ring_3#Entering_Ring_3*/
    asm volatile(" \
    cli; \
    mov $0x23, %eax; \
    mov %ax, %ds; \
    mov %ax, %es; \
    mov %ax, %fs; \
    mov %ax, %gs; \
                  \
    mov %esp, %eax; \
    pushl $0x23; \
    pushl %eax; \
    pushf; \
    pushl $0x1B; \
    /* push eip */
    iret; \
    ");
    return 0;
}
int32_t READ (int32_t fd, void* buf, int32_t nbytes) {
    return 0;
}
int32_t WRITE (int32_t fd, const void* buf, int32_t nbytes) {
    return 0;
}
int32_t OPEN (const uint8_t* filename) {
    return 0;
}
int32_t CLOSE (int32_t fd) {
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
