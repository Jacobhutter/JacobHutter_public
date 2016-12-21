import numpy as np
import itertools
import os
import re
t = open("testpair.c", 'w')
with open("pair.c") as f:
	for line in f:
		if(line.startswith("int findpair(int array[],int start, int end){")):
			t.write("int findpair(int array[],int start, int end){\n");
			for line in f:
				t.write(line);
