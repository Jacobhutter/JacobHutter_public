from random import *
import sys
import numpy as np

def generate_random_graph():
    N = int(input("Choose an N between 3 and 8: "))
    f = open("random_mazes.txt", "a+")
    for i in range(5):
        prev_letter = 'z'
        for j in range(N):
            x = randint(0, 4)
            x = chr(ord('A') + x)
            while(x == prev_letter): # prevent two letters in a row
                x = randint(0, 4)
                x = chr(ord('A') + x)
            prev_letter = x
            f.write(x+ ' ')
        f.write('\n')
    f.write('///////////////////////////////////////\n')
    f.close()
generate_random_graph()
