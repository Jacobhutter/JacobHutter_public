import numpy as np
from minimax import minimax_play
from alphabeta import alphabeta_play
from util import utility

def checkwin(board):
	ret = check_rows(board)
	if(ret == 0):
		ret = check_cols(board)
	if(ret == 0):
		ret = check_diagonals(board)
	return ret

def check_rows(board):
        for i in range(len(board)):
		count = 0
		piece = 0
    		row = board[i]
		for x in row:
        		if(piece == x and piece != 0):
	    			count += 1
				if(count == 5):
					print 'row winner'
					return piece
        		else:
				piece = x
            			if(x != 0):
					count = 1
				else:
					count = 0
	return 0
		
def check_cols(board):
        for i in range(len(board[0])):
		count = 0
		piece = 0
		col = board[:, i]
        	for x in col:
			if(piece == x and piece != 0):
                        	count += 1
                        	if(count == 5):
					print col
					print 'col winner'
                                	return piece
                	else:
                        	piece = x
                        	if(x != 0):
                                	count = 1
                        	else:
                                	count = 0
	return 0

def check_lefttoright(board, pos):
	count = 0
	piece = 0
	i = pos[0]
	j = pos[1]
	while(i >= 0 and i < 7 and j >= 0 and j < 7):
		if(piece == board[i][j] and piece != 0):
			count += 1
			if(count == 5):
				print 'ltr winner'
				return piece
		else:
			piece = board[i][j]
			if(board[i][j] != 0):
				count = 1
			else:
				count = 0
		i += 1
		j -= 1
	return 0

def check_righttoleft(board, pos):
        count = 0
        piece = 0
        i = pos[0]
        j = pos[1]
        while(i >= 0 and i < 7 and j >= 0 and j < 7):
                if(piece == board[i][j] and piece != 0):
                        count += 1
                        if(count == 5):
				print 'rtl winner'
                                return piece
                else:
                        piece = board[i][j]
                        if(board[i][j] != 0):
                                count = 1
                        else:
                                count = 0
                i -= 1
                j -= 1
	return 0

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
out = []
for i in range(7):
	row = []
	for j in range(7):
		row.append(' . ')
	out.append(row)
win = 0
player = 1
plays = 0
chars1 = []
for i in range(65, 91):
	chars1.append(chr(i))
chars2 = []
for i in range(97, 123):
	chars2.append(chr(i))
print '\nMinimax (Red) vs. Alpha-Beta (Blue)\n'
print 'Move\tRed Nodes Expanded\tBlue Nodes Expanded'
nodesout = []
while not win and plays < 49:
	temp = str(int((plays / 2)) + 1)
	#Red
	pos, nodes = minimax_play(player, board)
	board[pos[0]][pos[1]] = player
	plays += 1
	temp += '\t\t' + str(nodes)
	out[pos[0]][pos[1]] = ' ' + chars2[plays / 2] + ' '
	win = checkwin(board)
	player *= -1
	if win or plays >= 49:
		nodesout.append(temp)
		break
	#Blue
	pos, nodes = alphabeta_play(player, board)
        board[pos[0]][pos[1]] = player
        plays += 1
	temp += '\t\t\t' + str(nodes)
	out[pos[0]][pos[1]] = ' ' + chars1[(plays - 1) / 2] + ' '
        win = checkwin(board)
        player *= -1
	nodesout.append(temp)
for line in nodesout:
	print line
print ''
for row in out:
	temp = ''
	for char in row:
		temp += char
	print temp
if win == 1:
	print '\nRed Wins\n'
elif win == -1:
	print '\nBlue Wins\n'	
else:
	print '\nThe Game Ended in a Draw\n'
