#ifndef scheduler_h
#define scheduler_h
#include "timer.h"
#include "interrupt_handler.h"
#include "keyboard.h"
#include "sys_call_handler.h"
#include "x86_desc.h"
#define Kb 1024

extern void time_quantum();
#endif
