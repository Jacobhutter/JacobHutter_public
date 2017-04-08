#include "sys_call_handler.h"

#define KERNEL_STACK _8Mb

unsigned long init_PCB_addr = _8Mb - _4Kb;

int32_t stdio_open(const uint8_t * filename){return -1;}
int32_t stdio_close(int32_t fd){return -1;}
int32_t stdin_read(int32_t fd,void * buf,int32_t nbytes){return -1;}
int32_t stdout_write(int32_t fd,const char* buf,int32_t nbytes){return -1;}

int32_t HALT (uint8_t status) {
    terminal_write((const void *)"test halt", (int32_t)9);
    return 0;
}

int32_t EXECUTE (const uint8_t* command) {

    /* Tests the algorithm used to parse the command */
    int i = 0;
    uint8_t * arg;
    int8_t to_execute[BUFFER_LIMIT + 1]; // to accomodate for addtl null terminator
    uint8_t* start = command;
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
    
    terminal_write("Gucci\n", 6);
    
    /* TODO: Load file */

    /* create new pcb for current task */
    PCB_t * process;

    /* set task equal to task address at the current page */
    // PCB_ADDR -= _8Kb; // get next available address to place a PCB in kernel page
    // process = PCB_ADDR;

    // Gets address to place PCB for current process
    PCB_addr = init_PCB_addr - (_4Kb * process_num);
    process = PCB_addr;

    file_t stdin; // initialize std int
    stdin.file_position = 0;
    stdin.operations.open = &stdio_open;
    stdin.operations.close = &stdio_close;
    stdin.operations.read = &stdin_read;
    stdin.operations.write = &WRITE;

    file_t stdout; // initialize stdout
    stdin.file_position = 1;
    stdout.operations.open = &stdio_open;
    stdout.operations.close = &stdio_close;
    stdout.operations.write = &stdout_write;
    stdout.operations.read = &READ;

    process->file_descriptor[0] = stdin;
    process->file_descriptor[1] = stdout;
    process->mask = 0x3; // show that file_descriptor has stdin and std out
    process->process_id = process_num; // Sets id

    /* if open slot available, find it and occupy it */
    /* uint8_t dynamic_mask = 0x01;
    for (i = 0; i < 8; i++) {
        if (!(dynamic_mask & process_cont.mask)) {
            process_cont.mask = process_cont.mask | dynamic_mask; // add process to list
            process_t cur_running;
            // init process
            process_cont.file_descriptor[i] = cur_running;
            break;
        }
        dynamic_mask = dynamic_mask << 1;
    }*/

    // terminal_write(to_execute, strlen(to_execute));
    // terminal_write("\n", 1);

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
