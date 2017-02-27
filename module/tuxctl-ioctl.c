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

#define debug(str, ...) \
	printk(KERN_DEBUG "%s: " str, __FUNCTION__, ## __VA_ARGS__)

/************************ Protocol Implementation *************************/

typedef struct{
	static bool do_not_enter = false;
	static bool acknowledged = false;
	static unsigned char led_on;
	static unsigned char decimal;
	static spinlock_t tux_lock; //  = SPIN_LOCK_UNLOCKED;
	static unsigned char disp[4]; // current displayed char, 4 bytes
	static unsigned char disp_info[16] = {0xE7, 0x06, 0xCB, 0x8F, 0x2E, 0xAD, 0xED, 0x86, 0xEF, 0xAE,
	0xEE, 0x6D, 0xE1, 0x4F, 0xE9, 0xE8}; // 7 seven segment display info from LED_SET
}tux_t;
tux_t tux;
/* tuxctl_handle_packet()
 * IMPORTANT : Read the header for tuxctl_ldisc_data_callback() in
 * tuxctl-ld.c. It calls this function, so all warnings there apply
 * here as well.
 */
void tuxctl_handle_packet (struct tty_struct* tty, unsigned char* packet)
{
		if(tux.do_not_enter)
			return;
    unsigned a, b, c;

    a = packet[0]; /* Avoid printk() sign extending the 8-bit */
    b = packet[1]; /* values when printing them. */
    c = packet[2];

    //printk("packet : %x %x %x\n", a, b, c);
		if(a == MTCP_RESET){
			T_I(tty);
			if(tux.acknowledged){
				T_S_L(tty,tux.disp);
			}
			return;
		}
		if(a == MTCP_ACK){
			tux.acknowledged = true;
			return;
		}
		if(a == MTCP_BIOC_EVENT){
			T_B(tty);
		}
		// add more responses?
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
 int T_I(struct tty_struct* tty){
	tux.tux_lock = SPIN_LOCK_UNLOCKED;

	tuxctl_ldisc_put(tty,&MTCP_LED_USR,1); // enter user mode, leds display what ever is in set
	tuxctl_ldisc_put(tty,&MTCP_BIOC_ON,1); // enable button interrupt, will need spin locks from now on
	tux.disp[0] = 0x00; // hex displays are at 0
	tux.disp[1] = 0x00;
	tux.disp[2] = 0x00;
	tux.disp[2] = 0x00;
 	return 0;
 }


 int T_B(struct tty_struct* tty){
 	return 0;
 }


 int T_S_L(struct tty_struct* tty,unsigned long arg){
	 if(!tux.acknowledged)
	 	return -EINVAL;
	// low 16 bits of of arg contains our LED values
	unsigned long copy;
	unsigned char package[6];
	package[0] = MTCP_LED_USR;
	tux.disp[0] = (unsigned char)(copy & 0x000000F); // extract lower bits
	tux.disp[1] = (unsigned char)((copy & 0x00000F0) >> 4);
	tux.disp[2] = (unsigned char)((copy & 0x0000F00) >> 8);
	tux.disp[3] = (unsigned char)((copy & 0x000F000) >> 16);


	// get led_on
	copy = 0x000F0000 & arg; // get leds on
	tux.led_on = (unsigned char)(copy >> 16);

	// get decimal
	copy = 0x0F000000 & arg;
	tux.decimal = (unsigned char)(copy >> 24);

	tuxctl_ldisc_put(tty,&MTCP_LED_USR,1); // enter user mode, leds display what ever is in set
	unsigned char mask = 0x01;
	package[1] = 0x0F; // second arg shows we want 4 leds on, controller expects 4 following led sets
	int i;
	for(i = 0; i<4; i++){
		if(tux.led_on & mask){
				package[2+i] = tux.disp_info[tux.disp[i]]; // display certain hex char
			if(tux.decimal & mask){
				package[2+i] = package[2+i] | 0x10;
			}
		}
		else{
				package[2+i] = 0x00;
		}

	}
	tuxctl_ldisc_put(tty,package,6); // send over all data to be displayed
	tux.acknowledged = 0;
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
		return T_B(tty);
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
