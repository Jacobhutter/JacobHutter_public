from random import *
import sys

N = input("Choose an N between 3 and 8: ")

for i in range(5):
    for j in range(N):
        x = randint(0, 4)
        x = chr(ord('A') + x)
        print x,
    print '\n'
