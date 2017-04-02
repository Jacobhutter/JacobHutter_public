#include "sys_call_handler.h"

int32_t HALT (uint8_t status){
    terminal_write((const void *)"test halt",(int32_t)9);
    return 0;
}

#define TERMINATOR '\0'
#define SPACE ' '

int32_t EXECUTE (const uint8_t* command){
  terminal_write((const void *)command,strlen(command));
  terminal_write("\n",1);
  int i = 0;
  	uint8_t * arg;
  	int8_t to_execute[BUFFER_LIMIT+1]; // to accomodate for addtl null terminator
	uint8_t* start = command;
  	uint8_t* end;

  if(!command)
    return -1;

    while(*start != TERMINATOR && *start == SPACE)
        start++;

    	if(*start == TERMINATOR)
        return -1;

    	end = start;

    	while(*end != TERMINATOR && *end != SPACE)
        end++;

    	memcpy((void*)to_execute, (const void*)command, end-start);

    	to_execute[end-start] = TERMINATOR;
  terminal_write(to_execute,strlen(to_execute));
  terminal_write("\n",1);

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
