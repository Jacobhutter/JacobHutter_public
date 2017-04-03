#include "sys_call_handler.h"

int32_t HALT (uint8_t status) {
    terminal_write((const void *)"test halt", (int32_t)9);
    return 0;
}

#define TERMINATOR '\0'
#define SPACE ' '
PCB_t process_cont;

int32_t EXECUTE (const uint8_t* command) {
    /* Tests the algorithm used to parse the command */
    // terminal_write((const void *)command, strlen(command));
    // terminal_write("\n", 1);

    int i = 0;
    uint8_t * arg;
    int8_t to_execute[BUFFER_LIMIT + 1]; // to accomodate for addtl null terminator
    uint8_t* start = command;
    uint8_t* end;
    dentry_t file;
    unsigned long file_size;

    if (!command)
        return -1;

    while (*start != TERMINATOR && *start == SPACE)
        start++;

    if (*start == TERMINATOR)
        return -1;

    end = start;

    while (*end != TERMINATOR && *end != SPACE)
        end++;

    memcpy((void*)to_execute, (const void*)command, end - start);

    to_execute[end - start] = TERMINATOR;

    if (read_dentry_by_name(to_execute, &file) == -1)
        return -1;

    file_size = get_file_size(file);

    /* TODO: Set up paging and load file */
    load_shell();

    /* are we at our limit for processes */
    if (process_cont.mask = 0xFF)
        return -1;

    /* if open slot available, find it and occupy it */
    uint8_t dynamic_mask = 0x01;
    for (i = 0; i < 8; i++) {
        if (!(dynamic_mask & process_cont.mask)) {
            process_cont.mask = process_cont.mask | dynamic_mask; // add process to list
            process_t cur_running;
            // init process
            process_cont.file_descriptor[i] = cur_running;
            break;
        }
        dynamic_mask = dynamic_mask << 1;
    }

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
