/* tuxctl-ioctl.c
 *
 * Driver (skeleton) for the mp2 tuxcontrollers for ECE391 at UIUC.
 *
 * Mark Murphy 2006
 * Andrew Ofisher 2007
 * Steve Lumetta 12-13 Sep 2009
 * Puskar Naha 2013
 */

#include <asm/current.h>
#include <asm/uaccess.h>

#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/module.h>
#include <linux/fs.h>
#include <linux/sched.h>
#include <linux/file.h>
#include <linux/miscdevice.h>
#include <linux/kdev_t.h>
#include <linux/tty.h>
#include <linux/spinlock.h>

#include "tuxctl-ld.h"
#include "tuxctl-ioctl.h"
#include "mtcp.h"
#define u_intmax 255
#define debug(str, ...) \
	printk(KERN_DEBUG "%s: " str, __FUNCTION__, ## __VA_ARGS__)

/* ********************************************* */
void store_buttons(unsigned char b, unsigned char c);
 int T_I(struct tty_struct* tty);
 int T_B(struct tty_struct* tty, unsigned long arg);
 int T_S_L(struct tty_struct* tty,unsigned long arg);
/* ********************************************* */
#define led_on_mask 0x000F0000
#define decimal_on_mask 0x0F000000
#define get_first_hex 0x0000000F
#define get_second_hex 0x000000F0
#define get_third_hex 0x00000F00
#define get_fourth_hex 0x0000F000
#define offset1 4
#define offset2 8
#define offset3 12
#define add_dec 0x10
unsigned char disp_info[16] = {0xE7, 0x06, 0xCB, 0x8F, 0x2E, 0xAD, 0xED, 0x86, 0xEF, 0xAF,
0xEE, 0x6D, 0xE1, 0x4F, 0xE9, 0xE8}; // 7 seven segment display info from LED_SETs


// struct for controller
typedef struct controller{
	 int button_result;
	 bool do_not_enter;
	 int acknowledged;
	 unsigned char led_on;
	 unsigned char decimal;
	 spinlock_t tux_lock; //  = SPIN_LOCK_UNLOCKED;
	 unsigned char disp[4]; // current displayed char, 4 bytes

}controller_t;
controller_t tux;


/************************ Protocol Implementation *************************/
/* tuxctl_handle_packet()
 * IMPORTANT : Read the header for tuxctl_ldisc_data_callback() in
 * tuxctl-ld.c. It calls this function, so all warnings there apply
 * here as well.
 */

void tuxctl_handle_packet (struct tty_struct* tty, unsigned char* packet)
{
	unsigned char a;
	unsigned char b;
	unsigned char c;
	a = packet[0]; /* Avoid printk() sign extending the 8-bit */
		if(tux.do_not_enter){ // if busy processing previous request do not enter
			if(a == MTCP_ACK)
				tux.acknowledged--;
		 	return;
}


    a = packet[0]; /* Avoid printk() sign extending the 8-bit */
    b = packet[1]; /* values when printing them. */
    c = packet[2];
		if(a == MTCP_RESET){
		if(!tux.do_not_enter){
			tux.do_not_enter = true;
			tux.acknowledged = 4; // expecting four acks from the following functions
			T_I(tty); // re-initialize tux, assume ack is true, but after need to check
			T_S_L(tty,0); // set leds, will exit if not enough acks come from previous init
			tux.do_not_enter = false;
    }
			return;
		}

  //  printk("packet : %x %x %x\n", a, b, c);


		if(a == MTCP_ACK){
			tux.acknowledged--;
		  return;
		}

		if(a == MTCP_BIOC_EVENT){
		//printk("event packet recieved \n");
		tux.do_not_enter = true; // do not allow other packets while processing
			store_buttons(b,c); // get button pressed
		tux.do_not_enter = false;
		}
		// add more responses?
		return;

}


/*
* void store_buttons(unsigned char cbastart, unsigned char rldu)
* description: takes button when bioc_event occurs and stores into global var to be requested by user
* input: first and second half of arg
* output: none
* side_effects: when being run, doesnt allow addiontoal events
*/
void store_buttons(unsigned char cbastart, unsigned char rldu){
		cbastart = ~cbastart;
		rldu = ~rldu;
	/*
	; 	Packet format:
	;		Byte 0 - MTCP_BIOC_EVENT
	;		byte 1  +-7-----4-+-3-+-2-+-1-+---0---+
	;			| 1 X X X | C | B | A | START |
	;			+---------+---+---+---+-------+
	;		byte 2  +-7-----4-+---3---+--2---+--1---+-0--+
	;			| 1 X X X | right | down | left | up |
	;			+---------+-------+------+------+----+
	*/
	// must get into RLDUCBASTART
	tux.button_result = 0x0000; // fill with zeroes 2 byte int
	tux.button_result |= cbastart & 0x0F; // filter out everything besides CBASTART
	tux.button_result |= (rldu & 0x08) << 4; // filter everything besides right and move over
	tux.button_result |= (rldu & 0x02) << 5; // take left and put it in place
	tux.button_result |= (rldu & 0x04) << 3; // take down and put it in place
	tux.button_result |= (rldu & 0x01) << 4; // take up and put it in place
	//printk("%i is button result \n ",tux.button_result);
	return;
}
/******** IMPORTANT NOTE: READ THIS BEFORE IMPLEMENTING THE IOCTLS ************
 *                                                                            *
 * The ioctls should not spend any time waiting for responses to the commands *
 * they send to the controller. The data is sent over the serial line at      *
 * 9600 BAUD. At this rate, a byte takes approximately 1 millisecond to       *
 * transmit; this means that there will be about 9 milliseconds between       *
 * the time you request that the low-level serial driver send the             *
 * 6-byte SET_LEDS packet and the time the 3-byte ACK packet finishes         *
 * arriving. This is far too long a time for a system call to take. The       *
 * ioctls should return immediately with success if their parameters are      *
 * valid.                                                                     *
 *                                                                            *
 ******************************************************************************/
 unsigned char init_buf[2] = {MTCP_BIOC_ON,MTCP_LED_USR};

 /*
 * int T_I(struct tty_struct* tty)
 * description: initiates the tux controller
 * inputs: tty struct
 * outputs: 0 on success
 * side_effects: sets leds to all zero and outs to board, expects acks
 */
 int T_I(struct tty_struct* tty){
	//printk("entering T_I \n");
	tux.tux_lock = SPIN_LOCK_UNLOCKED; // initialize spin lock
	tuxctl_ldisc_put(tty,&init_buf[0],1); // enter user mode, leds display what ever is in set
	tuxctl_ldisc_put(tty,&init_buf[1],1); // enable button interrupt, will need spin locks from now on

	// assume ack comes here-ish to reset tux.acknowledged
	tux.disp[0] = 0x00; // hex displays are at 0
	tux.disp[1] = 0x00;
	tux.disp[2] = 0x00;
	tux.disp[3] = 0x00;
	//T_S_L(tty,0xFFFFFFFF);
 	return 0;
 }

 /*
 * int T_B(struct tty_struct* tty, unsigned long arg)
 * description: upon request from user, takes the last button pressed and returns it in a convenient format
 * input: tty struct and argument to copy data over to
 * output 0 on success
 * side_effects: locks out those spamming to retrieve info
 */
 int T_B(struct tty_struct* tty, unsigned long arg){
	 unsigned long flags;
	 int invalid;

	if(arg == 0x00000000) // null check
		return -EINVAL;

	spin_lock_irqsave(&tux.tux_lock,flags); // lock
		invalid = copy_to_user((int*)arg,&tux.button_result, sizeof(int)); // copy to user
	spin_unlock_irqrestore(&tux.tux_lock,flags); // unlock

	if(invalid != 0) // copy_to_user returns 0 if done correctly
		return -EINVAL;

 	return 0;
 }

/*
* int T_S_L(struct tty_struct* tty,unsigned long arg)
* description: sets leds based on arguments, must reformat
* inputs: tty struct and an unsigned long arg that contains our leds
* outputs: 0 on success
* side effects: sets leds
*/
 int T_S_L(struct tty_struct* tty,unsigned long arg){
	 int i = 0;
	 unsigned char select = 0x01; // mask for going through decimal and LED on
	 unsigned char package_user[1] = {MTCP_LED_USR};
	 unsigned char package[6] = {MTCP_LED_SET,0x0F,0x00,0x00,0x00,0x00}; // initialize package to zero except the constant first inputs
	 if(tux.acknowledged > 2)
		return -EINVAL;
	 tux.disp[0] = disp_info[(arg&0x0000000F)]; // get first digit using masking based on argrument formant
	 tux.disp[1] = disp_info[(arg&0x000000F0)>>4]; // get second digit using masking based on argrument formant
	 tux.disp[2] = disp_info[(arg&0x00000F00)>>8]; // get third digit using masking based on argrument formant
	 tux.disp[3] = disp_info[(arg&0x0000F000)>>12]; // get fourth digit using masking based on argrument formant



	 tux.decimal = (unsigned char)((decimal_on_mask& arg) >> 24); // get section of decimal to see which are on using mask and shift
	 // get led_on
 		tux.led_on = (unsigned char)((led_on_mask & arg) >> 16); // get section of led to see which leds are on using mask and shift


	tuxctl_ldisc_put(tty,&package_user[0],1); // enter user mode, leds display what ever is in set ack 3


  package[2] = tux.disp[0];
	package[3] = tux.disp[1];
	package[4] = tux.disp[2];
	package[5] = tux.disp[3];
	for(i =0; i <4; i++){ // four possible leds
		if(tux.decimal & select)
			package[2+i] |= add_dec; // if dec on then for that led in package, add the critical bit
		if(!(tux.led_on & select))
			package[2+i] = 0x00; // else set that led to 0
		select = select << 1; // move to see if another led or decimal is on
	}
	tuxctl_ldisc_put(tty,&package[0],6); // send over all data to be displayed ack 4

 	return 0;
 }



 /*
 * int
 * tuxctl_ioctl (struct tty_struct* tty, struct file* file,
 *	      unsigned cmd, unsigned long arg)
 * description: dispatches sub funtions based on second argument of ioctl call
 * inputs: tty struct and a file pointer and a command and argument
 * outputs: 0 on success, -EINVAL on failure
 * side effects:
 */
int
tuxctl_ioctl (struct tty_struct* tty, struct file* file,
	      unsigned cmd, unsigned long arg)
{
    switch (cmd) {
	case TUX_INIT:
		return T_I(tty);
	case TUX_BUTTONS:
		return T_B(tty,arg);
	case TUX_SET_LED:
		return T_S_L(tty,arg);
	case TUX_LED_ACK:
		return 0;
	case TUX_LED_REQUEST:
		return 0;
	case TUX_READ_LED:
		return 0;
	default:
	    return -EINVAL;
    }
}
