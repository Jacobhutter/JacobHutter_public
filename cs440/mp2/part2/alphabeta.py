import sys
import copy
import numpy as np
from util import utility

pos = (-1, -1)
nodes = 0

def alphabeta_play(player, board):
	global nodes
	global pos
	nodes = 0
	board *= player	
	abmaxval(1, board, 0, -sys.maxsize, sys.maxsize)	
	board *= player
	return pos, nodes

def abmaxval(player, board, count, a, b):
	global nodes
	global pos
	ut = utility(board)
	if ut == sys.maxsize or ut == -sys.maxsize:
		return ut
	high = -sys.maxsize
	loc = (-1, -1)
	for i in range(len(board)):
                for j in range(len(board[0])):
			if(board[i][j] != 0):
				continue	
			temp = np.copy(board)
			temp[i][j] = player
			curr = abminval(player * -1, temp, count + 1, a, b)
			if(curr == sys.maxsize):
				high = sys.maxsize
				loc = (i, j)
			elif(curr == -sys.maxsize):
				if(loc == (-1, -1)):
					loc = (i, j)
			elif(curr > high):
				high = curr
				loc = (i, j)
			if(high >= b):
				pos = loc
				return high
			a = max(a, high)
	if(loc == (-1, -1)):
                return 0
	nodes += 1
	pos = loc
	return high

def abminval(player, board, count, a, b):
	global nodes
	global pos
	if(count == 3):
		return utility(board)
	ut = utility(board)
        if ut == sys.maxsize or ut == -sys.maxsize:
                return ut
	low = sys.maxsize
        loc = (-1, -1)
        for i in range(len(board)):
                for j in range(len(board[0])):
                        if(board[i][j] != 0):
                                continue
                        temp = np.copy(board)
                        temp[i][j] = player
                        curr = abmaxval(player, temp, count + 1, a, b)
			if(curr == -sys.maxsize):
				low = -sys.maxsize
				loc = (i, j)
                        elif(curr == sys.maxsize):
				if(loc == (-1, -1)):
					loc = (i, j)
			elif(curr < low):
                                low = curr
                                loc = (i, j)
			if(low <= a):
				pos = loc
				return low
			b = min(b, low)
	if(loc == (-1, -1)):
                return 0
	nodes += 1
	pos = loc
	return low