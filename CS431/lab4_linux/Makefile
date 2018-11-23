
LAB4 = lab4
LAB4_OBJS = $(LAB4).o linuxanalog.o

CC = gcc
CFLAGS = -I.. -g -Wall -lrt -lm

all : lab4 


lab4 : $(LAB4_OBJS)
	$(CC) $(CFLAGS) -o $(LAB4) $(LAB4_OBJS)

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

clean : 
	rm -f *.o $(LAB4)
