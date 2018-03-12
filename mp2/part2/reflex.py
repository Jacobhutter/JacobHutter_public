import numpy as np

#2.1 Reflex Agent
red_piece = 1
blue_piece = -1
rows = 7
cols = 7

#rule 1
test1 = [[0, 0, 1, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 1, 1, 0, 0],
         [0, 1, 0, 1, 0, 0, 0],
         [0, -1, -1, -1, -1, 0, 0],
         [0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0]]

#rule 2
test2 = [[0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0],
         [-1, 1, 1, 1, 1, 0, 0],
         [-1, -1, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0]]

#rule 3
test3 = [[0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0],
         [0, 0, -1, 0, 0, 0, 0],
         [0, 0, 1, 1, 1, 0, 0],
         [0, -1, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0]]

#rule 4
test4 = [[0, 0, 0, 0, 0, 0, 0],
         [0, 1, 1, 0, 0, 0, 0],
         [0, 1, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0],
         [0, 0, -1, 0, 0, -1, 0],
         [0, 0, 0, 0, 0, 0, 0],
         [0, -1, 0, 0, 0, 0, 0]]
#[row][col]
#print(test1[4][5])

#testing accessibility
'''
for x in range(len(test2)):
    for y in range(len(test2[x])):
        if(test2[x][y] == red_piece):
            print "red",
        elif(test2[x][y] == blue_piece):
            print "blue",
        else:
            print str(test2[x][y]),
    print
'''

def print_board(board):
    for x in range(len(board)):
        for y in range(len(board[x])):
            if(board[x][y] == red_piece):
                print "red   ",
            elif(board[x][y] == blue_piece):
                print "blue   ",
            else:
                print (str(board[x][y]) + "     "),
        print
#    for row in board:
#        print row

# Search given row and see if it is a winning row
# If row is a winner, return row coordinate
def check_row(row, piece, tol):
    count = 0
    open_end = 0
    for x in range(len(row)):
        if(row[x] == piece and count == 0 and x > 0):
	    open_end = 1
            count += 1
	elif(row[x] == piece):
	    count += 1
        elif(row[x] != piece):
            count = 0
	    open_end = 0
        if((count == tol) and tol == 3 and x < 6 and x >= tol):
	    if(x < 6):
		open_end += 1
	    if(open_end < 2 and tol == 3):
		continue
            if((row[x - 3] == 0) and (row[x + 1] == 0)):
                if(row[x - 3] == 0):
#                    print "first"
                    return x - 3
                else:
                    if(row[x + 1] == 0):
#                        print "second"
                        return x + 1

        elif(count == tol and tol == 4):
	    	if(x >= 4):
                	if(row[x - 4] == 0):
#                    		print "third"
				return x - 4
                if(x < 6):
                	if(row[x + 1] == 0):
#                        	print "fourth"
                        	return x + 1
    return -1

def check_col(cols, piece, tol):
    count = 0
    open_end = 0
    for y in range(len(cols)):
#        print "Y VAL: ", y
	if(cols[y] == piece and count == 0 and y > 0):
		open_end = 1
		count += 1
        elif(cols[y] == piece):
            count += 1
        elif(cols[y] != piece):
            count = 0
	    open_end = 0
        if((count == tol) and tol == 3 and y < 6):
            if(y < 6):
		open_end += 1
	    if(open_end < 2 and tol == 3):
		continue
	    if((cols[y - 3] == 0) and (cols[y + 1] == 0)):
                if(cols[y - 3] == 0):
#                    print "fifth"
                    return y - 3
                else:
#                    print "sixth"
                    return y + 1
        elif(count == tol and tol == 4):
            if(y < 6):
                if(cols[y + 1] == 0):
#                    print "seventh"
                    return y + 1
            if(y >= 4):
                if(cols[y - 4] == 0):
#                    print "ninth"
                    return y - 4
    return -1

def not_checked(val, list):
    for i in range(len(list)):
        if(list[i] == val):
            return 0
    return 1

def check_lefttoright(board, piece, pos, tol):
    count = 0
    i = pos[0]
    j = pos[1]
    while((i >= 0 and i < 7) and (j >= 0 and j < 7)):
        if(piece == board[i][j] and count == 0 and i < 6 and j < 6 and i > 0 and j > 0):
                open_end = 1
                count += 1
	elif(piece == board[i][j]):
            count += 1
            if((count == tol) and tol == 3 and i < 6 and j > 0 and i - tol > 0 and j + tol < 7):
                if(board[i + 1][j - 1] == 0 and board[i - tol][j + tol] == 0):
                        if(i < 7 and j < 7 and i > 0 and j > 0):
                                open_end += 1
                        if(open_end < 2):
                                continue
#			print "tenth"
                        return i + 1, j - 1
            
            if(count == tol and tol == 4 and i < 6 and j > 0):
                if(board[i + 1][j - 1] == 0):
#                    print "eleventh"
                    return i + 1, j - 1
            if(count == tol and tol == 4 and i - tol >= 0 and j + tol < 7):
                if(board[i - tol][j + tol] == 0):
#                    print"twelvth"
                    return i - count, j + count
        else:
            count = 0
        
        i += 1
        j -= 1
    return -1, -1

def check_righttoleft(board, piece, pos, tol):
    count = 0
    i = pos[0]
    j = pos[1]
    open_end = 0
    while((i >= 0 and i < 7) and (j >= 0 and j < 7)):
#        print count
#        print "Loc: ", (i, j)
	if(piece == board[i][j] and count == 0 and i < 7 and j < 7 and i > 0 and j > 0):
		open_end = 1
		count += 1
        elif(piece == board[i][j]):
            count += 1
            if((count == tol) and tol == 3):
                if(board[i - 1][j - 1] == 0 and board[i + tol][j + tol] == 0):
                        if(i < 7 and j < 7 and i > 0 and j > 0):
                		open_end += 1
            		if(open_end < 2):
                		continue
#			print"thirteenth"
                        return i - 1, j - 1
            
            if(count == tol and tol == 4 and i > 0 and j > 0):
                if(board[i - 1][j - 1] == 0):
#                    print"fourteenth"
                    return i - 1, j - 1
            if(count == tol and tol == 4 and i + tol < 7 and j + tol <  7):
                if(board[i + tol][j + tol] == 0):
#                    print"fifteenth"
                    return i + tol, j + tol
        else:
            count = 0
	    open_end = 0
        i -= 1
        j -= 1
    return -1, -1

def check_diagonals(board, piece, pos, tol):
#    print pos
    ret = check_lefttoright(board, piece, pos, tol)
    if(ret[0] == -1 and ret[1] == -1):
        ret = check_righttoleft(board, piece, pos, tol)
#        print "right"
    return ret

# Checks for a winning move
def check_win(player, board, tol):
    cols_checked = []
    for x in range(len(board)):
        for y in range(len(board[x])):
            if(board[x][y] == player):
                col_val = check_row(board[x], player, tol)
                row_val = check_col(board[:, y], player, tol)
                ret = check_diagonals(board, player, (x, y),  tol)
                if(col_val != -1):
		    print x, col_val
                    return x, col_val
                elif(row_val != -1):
		    print row_val, y
                    return row_val, y
                elif(ret[0] >= 0 and ret[1] >= 0):
                    return ret
    return -1, -1

# Blocks opponents move

def check_block(player, board, tol):
    cols_checked = []
    for x in range(len(board)):
        for y in range(len(board[x])):
            if(board[x][y] == player):
#                print "X VAL: ", x
                col_val = check_row(board[x], player, tol)
                row_val = check_col(board[:, y], player, tol)
#                print "BOARD VALUE: ", board[:, y]
                ret = check_diagonals(board, player, (x, y),  tol)
#                print "Loc: ", (x, y)
#                print "Diag Pos: ", ret
                if(col_val != -1):
                    return x, col_val
                elif(row_val != -1):
                    return row_val, y
                elif(ret[0] >= 0 and ret[1] >= 0):
                    return ret
    return -1, -1

def check_wb(player, row):
    count = 0
    ret = -1
    nxt = 0
    for i in range(len(row)):
	if i < 4:
		if row[i + 1] == player:
			if row[i] == 0 and ret == -1:
				ret = i
			nxt = 1
	if row[i] == player * -1:
		return -1, -1
	elif row[i] == player:
		nxt = 1
		count += 1
	elif row[i] == 0 and nxt and ret == -1:
		ret = i
    return count, ret	

def getsum(block, player):
    sum = 0
    for i in range(len(block)):
        if(block[i][2] == player):#
            sum += 1
    return sum

def verify_block(blocks, x_cord, y_cord):
    for i in range(len(blocks)):
        if((blocks[i][0] >= x_cord) or (blocks[i][1] >= y_cord)):
            return 1
    return 0



# Need a way to compare the smallest block size so that the biggest is
def check_winblock(player, board):
    val = 0
    winpos = []
    for i in range(len(board)):
	for j in range(3):
		count, pos = check_wb(player, board[i,j:j+5])
		if count > val:
			val = count
			winpos = []
			winpos.append((i, j + pos))
		elif count == val:
			winpos.append((i, j + pos))
    for i in range(len(board[0])):
	for j in range(3):
		count, pos = check_wb(player, board[j:j+5, i])
		if count > val:
			val = count
			winpos = []
			winpos.append((j + pos, i))
		if count == val:
			winpos.append((j + pos, i))
    dtu = [(0, 2), (0, 1), (2, 1), (0, 0), (1, 1), (2, 2), (1, 0), (2, 1), (2, 0)]
    utd = [(6, 2), (6, 1), (5, 2), (6, 0), (5, 1), (4, 2), (5, 0), (4, 1), (4, 0)]
    for pos in dtu:
	diag = []
	for i in range(5):
    		diag.append(board[pos[0] + i][pos[1] + i])
	count, loc = check_wb(player, diag)
	if count > val:
		val = count
		winpos = []
		winpos.append((pos[0] + loc, pos[1] + loc))
	elif count == val:
		winpos.append((pos[0] + loc, pos[1] + loc))
    for pos in utd:
	diag = []
	for i in range(5):
		diag.append(board[pos[0] - i][pos[1] + i])
	count, loc = check_wb(player, diag)
	if count > val:
		val = count
		winpos = []
		winpos.append((pos[0] - loc, pos[1] + loc))
	elif count == val:
		winpos.append((pos[0] - loc, pos[1] + loc))
    return min(winpos, key = lambda t: t[1] * 10 + t[0])
	
def reflex_play(player, board):
    rule1 = check_win(player, board, 4)
    rule2 = check_block(player * -1, board, 4)
    rule3 = check_block(player * -1, board, 3)
    rule4 = check_winblock(player, board)
    if(rule1[0] >= 0 and rule1[1] >= 0):
#	print rule1
#        print "Moved for a win!"
        return rule1, 0
    elif(rule2[0] >= 0 and rule2[1] >= 0):
#	print rule2
#        print "Moved for a block"
        return rule2, 0
    elif(rule3[0] >= 0 and rule3[1] >= 0):
#	print rule3
#        print "Moved for a block sooner"
        return rule3, 0
    elif(rule4[0] >= 0 and rule4[1] >= 0):
#        print rule4
        return rule4, 0
    else:
#        print "DEFAULT MOVE BAD RULE 4"
        return (0, 0), 0
'''
#### MAIN ####
board = np.zeros((7, 7))

#for i in range(len(test4)):
#    for j in range(len(test4[i])):
#        if(test4 != 0):
#            board[i][j] = test4[i][j]

board[1][1] = red_piece
board[5][5] = blue_piece
win = 0
player = 1
plays = 0
while not win and plays < 49:
    print "Turn: " + str(plays)
    print "Player: " + str(player)
    pos = play(player, board)
    print pos
    board[pos[0]][pos[1]] = player
    plays += 1
    win = checkwin(board)
    print "Winner: " + str(win)
    player *= -1
    for row in board:
        print(row)
    print('\n')
print(win)
'''

