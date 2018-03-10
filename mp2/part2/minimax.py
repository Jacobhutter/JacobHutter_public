import sys
import copy
import numpy as np

def utility(board):
	ret = 0
	curr = 1
	piece = 0
	for row in board:
		for x in row:
			if(x == piece and piece != 0):
				curr *= 10
				if(curr == 100000):
					return x * float('inf')
			else:
				curr *= x
				if(x != 0):
					curr /= 3
				piece = x
				ret += curr
				curr = 1
	for i in range(len(board[0])):
		col = board[:][i]
		for x in col:
                        if(x == piece and piece != 0):
                                curr *= 10
                                if(curr == 100000):
                                        return x * float('inf')
                        else:
                                curr *= x
                                if(x != 0):
                                        curr /= 3
                                piece = x
                                ret += curr
                                curr = 1
		 	
	return ret

def minimax_play(player, board):
	high, pos = maxval(player, board, 1)
	print('play')
	return pos

def maxval(player, board, count):
	if(count == 3):
		return utility(board)
	high = float('-inf')
	pos = (-1, -1)
	for i in range(len(board)):
                for j in range(len(board[0])):
			if(board[i][j] != 0):
				continue	
			temp = np.copy(board)
			temp[i][j] = player
			curr = minval(player, temp, count + 1)
			if(curr > high):
				high = curr
				pos = (i, j)
	if(pos == (-1, -1)):
                return 0
	return high, pos

def minval(player, board, count):
	low = float('inf')
        pos = (-1, -1)
        for i in range(len(board)):
                for j in range(len(board[0])):
                        if(board[i][j] != 0):
                                continue
                        temp = np.copy(board)
                        temp[i][j] = player
                        curr = maxval(player, temp, count + 1)
                        if(curr < low):
                                low = curr
                                pos = (i, j)
	if(pos == (-1, -1)):
                return 0
	return low, pos


print('test')
					
		
