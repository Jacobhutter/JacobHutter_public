#include "linuxanalog.h"
#include <time.h>
#include <stdio.h>
#include <string.h>
#include <signal.h>
#include <stdlib.h>
#include <math.h>

volatile uint16_t outputLOW_value, outputHIGH_value;
uint8_t highLow = 0; 	//currently outputing low part of wave = 0, currently outputing high = 1 

void sig_handler(){
	if (highLow){ //switch to low output
		dac(outputLOW_value);
	} else {
		dac(outputHIGH_value);
	}
	
	//flip output
	highLow ^= 0x1;
}

void calculate_output_value(double voltage_low, double voltage_high){
	
	outputLOW_value =  0x0FFF & (uint16_t)(voltage_low*409.6 + 2048);
	
	outputHIGH_value = 0x0FFF & (uint16_t)(voltage_high*409.6 + 2048);
	
	if(voltage_high == 5.0)
		outputHIGH_value = 0x0FFF;
}


double calculate_res(){
	struct timespec res;
	double freq;
	while (0 != clock_getres(CLOCK_REALTIME, &res));
	freq = 1/((float)res.tv_nsec / 1000000000.0 + (float)res.tv_sec);
	return freq;
}


void get_input(double * user_input){
	double sv, ev, maxFreq, f;
	maxFreq = calculate_res();
	printf("Enter Voltage #1 (-5 to +5 volts, other to quit): ");	
	scanf("%lf", &sv);
	printf("Enter Voltage #2 (-5 to +5 volts, other to quit): ");	
	scanf("%lf", &ev);
	printf("Enter Frequency (0 to %lfhz, other to quit): ", maxFreq);	
	scanf("%lf", &f);
	user_input [0] = sv; //Start Voltage
	user_input [1] = ev; //End Voltage
	user_input [2] = f;
	return;
} 

void setup_timer_interrupt(double freq){
	struct sigaction action;
	
	memset(&action, 0, sizeof(struct sigaction));
	
	action.sa_handler = sig_handler;
	if(sigaction(SIGUSR1, &action, NULL) != 0){
		perror("SIGUSR1");
		exit(1);
	}

}

void setup_timer(float freq){
	timer_t timer2;
	struct sigevent timer2_event;
	
	//clear the structure and configure
	memset(&timer2_event, 0, sizeof(timer2_event));
	timer2_event.sigev_notify = SIGEV_SIGNAL;
	timer2_event.sigev_signo = SIGUSR1;
	
	//create a new timer that will send the SIGUSR1 signal
	if (timer_create(CLOCK_REALTIME, &timer2_event, &timer2) != 0){
		// If there is an error, print a message
		perror("timer_create\n");
		exit(1);
	}
	
	// set interupt rate. 
	struct itimerspec timer2_time;
	
	//
	
	timer2_time.it_value.tv_sec = 2; // 2 seconds
	timer2_time.it_value.tv_nsec = 500000000; // 0.5 seconds (5e8 nanoseconds)
	timer2_time.it_interval.tv_sec = (time_t)(floor((1/freq))); // zero unless freq = 1 
	timer2_time.it_interval.tv_nsec = (long)(floor(((1/freq) *1000000000))); 
	
	//Schedule the time
	if (timer_settime(timer2, 0, &timer2_time, NULL) != 0){
		perror("timer_settime");
		exit(1);
	}
		
}


int main(){
	double user_input[3];
	get_input(user_input);
	calculate_output_value(user_input[0], user_input[1]);
	das1602_initialize();
	setup_timer(user_input[2]*2); // setup the timer with the user specified frequency
	setup_timer_interrupt(user_input[2]*2);
	uint32_t counter = 0;
	while (1){
	// Output the count value after every 100 million loops.
		if ((counter % 100000000) == 0)
			printf("Counter: %lu\n", counter);
		counter++;
	}
	return 0;
	
}
