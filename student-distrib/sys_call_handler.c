#include "sys_call_handler.h"

int32_t HALT (uint8_t status){
    terminal_write((const void *)"test halt",(int32_t)9);
    return 0;
}
int32_t EXECUTE (const uint8_t* command){
    return 0;
}
int32_t READ (int32_t fd, void* buf, int32_t nbytes){
    return 0;
}
int32_t WRITE (int32_t fd, const void* buf, int32_t nbytes){
    return 0;
}
int32_t OPEN (const uint8_t* filename){
    return 0;
}
int32_t CLOSE (int32_t fd){
    return 0;
}
int32_t GETARGS (uint8_t* buf, int32_t nbytes){
    return 0;
}
int32_t VIDMAP (uint8_t** screen_start){
    return 0;
}
int32_t SET_HANDLER (int32_t signum, void* handler_address){
    return 0;
}
int32_t SIGRETURN (void){
    return 0;
}
