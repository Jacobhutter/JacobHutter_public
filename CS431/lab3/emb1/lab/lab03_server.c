//
// CS 431 - Lab 03 Server Skeleton
// PC/Linux (Provided)
//

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <termios.h>
#include <unistd.h>
#include <sys/types.h>
#include <fcntl.h>
#include "pc_crc16.h"
#include "lab03.h"
#include "types.h"
int main(int argc, char* argv[])
{
	double troll_pct=0;		// Perturbation % for the troll (if needed)
	int ifd,ofd,troll=0;	// Input and Output file descriptors (serial/troll)
	char str[MSG_BYTES_MSG],opt, resp[2];	// String input
	struct termios oldtio, tio;	// Serial configuration parameters
	int VERBOSE = 0;		// Verbose output - can be overriden with -v

	// Command line options
	while ((opt = getopt(argc, argv, "t:v")) != -1) {
		switch (opt) {
			case 't':	troll = 1; 
					troll_pct = atof(optarg);
					break;
			case 'v':	VERBOSE = 1; break;
			default: 	break;
		}
	}

	printf("CS431 - Lab 03 Server\n(Enter a message to send.  Type \"quit\" to exit)\n");
	// ******************************************************
	// WRITE ME: Open the serial port (/dev/ttyS0) read-write
	// ******************************************************
	ifd = open("/dev/ttyS0", O_RDWR | O_NOCTTY | O_SYNC);
	if(ifd < 0)
		printf("error");
	// Start the troll if necessary
	if (troll)
	{
		// Open troll process (lab03_troll) for output only
		FILE * pfile;		// Process FILE for troll (used locally only)
		char cmd[128];		// Shell command

		snprintf(cmd, 128, "./lab03_troll -p%f %s", troll_pct, (VERBOSE) ? "-v" : "");

		pfile = popen(cmd, "w");
		if (!pfile) { perror("lab03_troll"); exit(-1); }
		ofd = fileno(pfile);
	}
	else ofd = ifd;		// Use the serial port for both input and output
	// ***********************************************************
 	// WRITE ME: Set up the serial port parameters and data format
	// ***********************************************************
	tcgetattr(ifd, &oldtio);
	cfsetispeed(&tio, B9600);
	cfsetospeed(&tio, B9600);
	tio.c_cflag &= ~CSIZE; // clear char size
	tio.c_cflag |= ( CLOCAL | CREAD | CS8 );
	tcsetattr(ifd, TCSANOW, &tio);
	while(1)
	{

		// ******************************************************************************
		// WRITE ME: Read a line of input (Hint: use fgetc(stdin) to read each character)
		// ******************************************************************************
		uint8_t len = 0; //string length
		char c;
		while(1){
		c = fgetc(stdin);
		if(c == '\n'){
			break;
		}
		str[len] = c;
		++len;
		}
		if (len ==4 && str[0] =='q' && str[1] =='u' && str[2] =='i' && str[3]=='t') 
			break;
		// ********************************************************
		// WRITE ME: Compute crc (only lowest 16 bits are returned)
		// ********************************************************
		uint16_t crc = pc_crc16(str, len);
		uint8_t crc1 = (char)((crc & 0xFF00)>>8);
		uint8_t crc2 = (char)(crc & 0x00FF);
		volatile int ack = 0;
		int attempts = 0;
		while (!ack)
		{	
			printf("Sending (attempt %d)...\n", ++attempts);
			// **********************
			// WRITE ME: Send message
			// **********************
			dprintf(ofd, "%c", 0); // send start byte
			dprintf(ofd, "%c", crc1); // send high byte of crc
			dprintf(ofd, "%c", crc2); // send low byte of crc
			dprintf(ofd, "%c", len); // send 8 bits of integer that is length of string??*/
			write(ofd, str, len);
		
			printf("Message sent, waiting for ack... ");

			
			// **************************************
			// WRITE ME: Wait for MSG_ACK or MSG_NACK
			// **************************************
			while(read(ifd, resp,1)<=0);
			//resp[0] = 0;
			//while(resp[0] == 0){
				//read(ifd,resp,1);
				//printf("%i\n",resp[1]);
			//}
			ack = resp[0];
			

			printf("%s\n", ack ? "ACK" : "NACK, resending");
		}
		printf("\n");
	}

	//
	// WRITE ME: Reset the serial port parameters
	//
	tcflush(ifd, TCIFLUSH);
	tcsetattr(ifd, TCSANOW, &oldtio); 
	//need to see what ifd and ofd to use


	// Close the serial port
	close(ifd);
	
	return 0;
}
