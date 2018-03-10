import numpy as np
from minimax import minimax_play
from alphabeta import alphabeta_play

def checkwin(board):
	ret = check_rows(board)
	if(ret == 0):
		ret = check_cols(board)
	if(ret == 0):
		ret = check_diagonals(board)
	return ret

def check_rows(board):
        count = 0
	piece = 0
        for i in range(len(board)):
    		row = board[i]
	for x in range(len(row)):
        	if(piece == 0 or (piece == row[x] and row[x] != 0)):
			piece = row[x] 
	    		count += 1
			if(count == 5):
				return piece
        	else:
			piece = row[x]
            		if(row[x] != 0):
				count = 1
			else:
				count = 0
		
def check_cols(board):
        count = 0
	piece = 0
        for i in range(len(board[0])):
        	col = board[:][i]
        for x in range(len(col)):
		if(piece == 0 or (piece == col[x] and col[x] != 0)):
                        piece = col[x]
                        count += 1
                        if(count == 5):
                                return piece
                else:
                        piece = col[x]
                        if(col[x] != 0):
                                count = 1
                        else:
                                count = 0

def check_lefttoright(board, pos):
	count = 0
	piece = 0
	i = pos[0]
	j = pos[1]
	while(i >= 0 and i < 7 and j >= 0 and j < 7):
		if(piece == board[i][j] and piece != 0):
			count += 1
			if(count == 5):
				return piece
		else:
			piece = board[i][j]
			if(board[i][j] != 0):
				count = 1
			else:
				count = 0
		i += 1
		j -= 1

def check_righttoleft(board, pos):
        count = 0
        piece = 0
        i = pos[0]
        j = pos[1]
        while(i >= 0 and i < 7 and j >= 0 and j < 7):
                if(piece == board[i][j] and piece != 0):
                        count += 1
                        if(count == 5):
                                return piece
                else:
                        piece = board[i][j]
                        if(board[i][j] != 0):
                                count = 1
                        else:
                                count = 0
                i -= 1
                j -= 1

def check_diagonals(board):
	ret = check_lefttoright(board, (0, 4))
	if(ret == 0):
		ret = check_lefttoright(board, (0, 5))
	if(ret == 0):
                ret = check_lefttoright(board, (0, 6))
	if(ret == 0):
                ret = check_lefttoright(board, (1, 6))
	if(ret == 0):
                ret = check_lefttoright(board, (2, 6))
	if(ret == 0):
                ret = check_righttoleft(board, (4, 6))
	if(ret == 0):
                ret = check_righttoleft(board, (5, 6))
	if(ret == 0):
                ret = check_righttoleft(board, (6, 6))
	if(ret == 0):
                ret = check_righttoleft(board, (6, 5))
	if(ret == 0):
                ret = check_righttoleft(board, (6, 4))
	return ret
	

board = np.zeros((7, 7))
win = 0
player = 1
plays = 0
while not win and plays < 49:
	pos = alphabeta_play(player, board)
	board[pos[0]][pos[1]] = player
	plays += 1
	win = checkwin(board)
	player *= -1
	for row in board:
		print(row)
	print('\n')
print(win)	
