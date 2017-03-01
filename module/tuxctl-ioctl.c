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
/*
typedef struct status_bar{
    int level;
    int fruit_remaining;
    int total;
} status_bar_t;
status_bar_t bar;*/

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
		if(tux.do_not_enter) // if busy processing previous request do not enter
			return;



    a = packet[0]; /* Avoid printk() sign extending the 8-bit */
    b = packet[1]; /* values when printing them. */
    c = packet[2];

    //printk("packet : %x %x %x\n", a, b, c);
		if(a == MTCP_RESET){
			tux.do_not_enter = true;
			tux.acknowledged = 4; // expect 4 acks for this reset function
			T_I(tty); // re-initialize tux, assume ack is true, but after need to check
			T_S_L(tty,0); // set leds, will exit if not enough acks come from previous init
			tux.do_not_enter = false;
			return;
		}

		if(a == MTCP_ACK){
			tux.acknowledged--;
		  return;
		}

		if(a == MTCP_BIOC_EVENT){
		tux.do_not_enter = true; // do not allow other packets while processing
			store_buttons(b,c); // get button pressed
		tux.do_not_enter = false;
		}
		// add more responses?
		return;

}


/*
*
*
*
*
*
*
*
*
*/
void store_buttons(unsigned char cbastart, unsigned char rldu){
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
 unsigned char init_buf[2] = {MTCP_LED_USR,MTCP_BIOC_ON};
 /*
 * int T_I(struct tty_struct* tty)
 *
 *
 *
 *
 *
 */
 int T_I(struct tty_struct* tty){
	tux.tux_lock = SPIN_LOCK_UNLOCKED; // initialize spin lock
	tuxctl_ldisc_put(tty,&init_buf[0],1); // enter user mode, leds display what ever is in set
	tuxctl_ldisc_put(tty,&init_buf[1],1); // enable button interrupt, will need spin locks from now on
	// assume ack comes here-ish to reset tux.acknowledged
	tux.disp[0] = 0x00; // hex displays are at 0
	tux.disp[1] = 0x00;
	tux.disp[2] = 0x00;
	tux.disp[3] = 0x00;
 	return 0;
 }

 /*
 * int T_B(struct tty_struct* tty, unsigned long arg)
 *
 *
 *
 *
 *
 */
 int T_B(struct tty_struct* tty, unsigned long arg){
	 unsigned long flags;
	 int invalid;

	if(arg == 0x00000000) // null check
		return -EINVAL;

	spin_lock_irqsave(&tux.tux_lock,flags); // lock
		invalid = copy_to_user((int*)arg,&tux.button_result, sizeof(int)); // copy to user
	spin_unlock_irqrestore(&tux.tux_lock,flags); // unlock

	if(invalid != 0)
		return -EINVAL;

 	return 0;
 }

/*
* int T_S_L(struct tty_struct* tty,unsigned long arg)
*
*
*
*
*
*/

 int T_S_L(struct tty_struct* tty,unsigned long arg){
	 unsigned char package_user[1] = {MTCP_LED_USR};
	 unsigned char package[6] = {MTCP_LED_SET,0x0F,0x00,0x00,0x00,0x00};
	 unsigned char select = 0x01;
	 int i;
	 if(tux.acknowledged > 2) // check to see if acks have arrived
	 	return 0;
	// low 16 bits of of arg contains our LED values
	tux.disp[0] = (unsigned char)(arg & get_first_hex); // extract lower bits
	tux.disp[1] = (unsigned char)((arg & get_second_hex) >> offset1);
	tux.disp[2] = (unsigned char)((arg & get_third_hex) >> offset2);
	tux.disp[3] = (unsigned char)((arg & get_fourth_hex) >> offset3);

	// get led_on
	tux.led_on = (unsigned char)((led_on_mask & arg) >> 16);

	// get decimal
	tux.decimal = (unsigned char)((decimal_on_mask& arg) >> 24);

	tuxctl_ldisc_put(tty,&package_user[0],1); // enter user mode, leds display what ever is in set ack 3

	for(i = 2; i<6; i++){
		bool flag1 = (bool)(tux.led_on & select);
		bool flag2 = (bool)(tux.decimal & select);
		if(flag1){
				package[i] = disp_info[tux.disp[i-2]]; // display certain hex char
				if(flag2)
					package[i] = package[i] | add_dec; // add in decimal
				else
					continue;
		}
		else{
				package[i] = 0x00; // give nothing
		}
		select = select << 1; // move mask over one
	}

	tuxctl_ldisc_put(tty,package,6); // send over all data to be displayed ack 4

 	return 0;
 }

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
	  tux.acknowledged = 2; // expect 2 acks from tsl
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
