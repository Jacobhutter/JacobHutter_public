from random import *
import sys
import numpy as np

def generate_random_graph():
    N = input("Choose an N between 3 and 8: ")
    f = open("random_mazes.txt", "a+")
    for i in range(5):
        for j in range(N):
            x = randint(0, 4)
            x = chr(ord('A') + x)
            f.write(x+ ' ')
        f.write('\n')
    f.write('///////////////////////////////////////\n')
    f.close()
generate_random_graph()
