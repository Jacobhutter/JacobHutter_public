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
	static spinlock_t tux_lock; //  = SPIN_LOCK_UNLOCKED;
	static unsigned short disp; // current displayed char, 2 bytes
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
	disp = 0x0000; // hex displays are at 0

 	return 0;
 }


 int T_B(struct tty_struct* tty){
 	return 0;
 }


 int T_S_L(struct tty_struct* tty,unsigned long arg){
	 if(!tux.acknowledged)
	 	return -EINVAL;
	// low 16 bits of of arg contains our LED values
	unsigned long copy = arg;
	tux.disp = copy & tux.disp & 0x0000FFFF; // get lower 16 bits
	
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
