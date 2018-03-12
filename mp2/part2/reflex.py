import numpy as np
from gomoku import checkwin

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
for x in range(len(test2)):
    for y in range(len(test2[x])):
        if(test2[x][y] == red_piece):
            print "red",
        elif(test2[x][y] == blue_piece):
            print "blue",
        else:
            print str(test2[x][y]),
    print


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
    for x in range(len(row)):
        if(row[x] == piece):
            count += 1
        elif(row[x] != piece):
            count = 0
        
        if((count >= tol) and tol == 3 and x < 6 and x >= tol):
            if((row[x - 3] == 0) and (row[x + 1] == 0)):
                if(row[x - 3] == 0):
                    print "first"
                    return x - 3
                else:
                    if(row[x + 1] == 0):
                        print "second"
                        return x + 1

        elif(count >= tol):
            if(x < 6):
                if(row[x - 4] == 0):
                    print "third"
                    return x - 4
                else:
                    if(row[x + 1] == 0):
                        print "fourth"
                        return x + 1
    return -1

def check_col(cols, piece, tol):
    count = 0
    for y in range(len(cols)):
#        print "Y VAL: ", y
        if(cols[y] == piece):
            count += 1
        elif(cols[y] != piece):
            count = 0
        if((count >= tol) and tol == 3 and y < 6):
            if((cols[y - 3] == 0) and (cols[y + 1] == 0)):
                if(cols[y + 1] == 0):
                    print "fifth"
                    return y + 1
                else:
                    print "sixth"
                    return y - 3
        elif(count >= tol):
            if(y < 6):
                if(cols[y + 1] == 0):
                    print "seventh"
                    return y + 1
                elif(y > 2):
                    if(cols[y - 4] == 0):
                        print "eighth"
                        return y - 4
            elif(y > 2):
                if(cols[y - 4] == 0):
                    print "ninth"
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
        if(piece == board[i][j]):
            count += 1
            
            if((count >= tol) and tol == 3 and i < 6 and j > 0 and i - tol > 0 and j + tol < 7):
                if(board[i + 1][j - 1] == 0 and board[i - tol][j + tol] == 0):
                        print "tenth"
                        return i + 1, j - 1
            
            elif(count >= tol and i < 6 and j > 0):
                if(board[i + 1][j - 1] == 0):
                    print "eleventh"
                    return i + 1, j - 1
            elif(count >= tol and i - tol > 0 and j + tol < 7):
                if(board[i - tol][j + tol] == 0):
                    print"twelvth"
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
    while((i >= 0 and i < 7) and (j >= 0 and j < 7)):
#        print count
#        print "Loc: ", (i, j)
        if(piece == board[i][j]):
            count += 1
            if((count >= tol) and tol == 3):
                if(board[i - 1][j - 1] == 0 and board[i + tol][j + tol] == 0):
                        print"thirteenth"
                        return i - 1, j - 1
            
            elif(count >= tol and i > 0 and j > 0):
                if(board[i - 1][j - 1] == 0):
                    print"fourteenth"
                    return i - 1, j - 1
            elif(count >= tol and i < count and j < count):
                if(board[i + tol][j + tol] == 0):
                    print"fifteenth"
                    return i + tol, j + tol
        else:
            count = 0
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
                    return x, col_val
                elif(row_val != -1):
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
    cols_checked = []
    blocks = []
    blocks.append((6, 6, 0))
    blocks.append((6, 6, 0))
    blocks.append((6, 6, 0))
    blocks.append((6, 6, 0))
    blocks.append((6, 6, 0))
    block = []
    seq = 0
    max = 0
    
# 3 iterations for horizontal
# 3 iterations for vertical
# 3 iterations for right to left
# 3 iterations for left to right
    
    
    for x in range(len(board)):
        seq = 0
        for i in range(3):
            block = []
            seq = 0
            for y in range(5):
                    if(board[x][y + i] != player * -1):#
                        seq += 1
                        block.append((x, y + i, board[x][y + i]))
                        if(seq == 5):
                            seq = 0
                            val = getsum(block, player)
                            if(max <= val):
                                if(verify_block(blocks, x, y + i)):
                                    max = val
                                    blocks = []
                                    blocks = block
                            block = []
                    else:
                        seq = 0
                        block = []


    block = []
    seq = 0

    for x in range(len(board)):
        seq = 0
        for i in range(3):
            block = []
            seq = 0
            for y in range(5):
                    if(board[y + i][x] != player * -1):#
                        seq += 1
                        block.append((y + 1, x, board[y][x]))
                        if(seq == 5):
                            seq = 0
                            val = getsum(block, player)
                            if(max <= val):
                                if(verify_block(blocks, y + 1, x)):
                                    max = val
                                    blocks = []
                                    blocks = block
                            block = []
                    else:
                        seq = 0
                        block = []

    x_cord = 0
    y_cord = 0

    for i in range(3):
        x_cord = 0
        y_cord = 0
        while(x_cord >= 0 and x_cord < 7 and y_cord >= 0 and y_cord < 7):
            if(player * -1 != board[x_cord + i][y_cord + i]):
                seq += 1
                block.append((x_cord + i, y_cord + i, board[x_cord + i][y_cord + i]))
                if(seq == 5):
                    seq = 0
                    val = getsum(block, player)
                    if(max <= val):
                        if(verify_block(blocks, x_cord + i, y_cord + i)):
                            max = val
                            blocks = []
                            blocks = block
                    block = []
            else:
                seq = 0
                block = []
            x_cord +=1
            y_cord +=1

#    block = []
#    block = upper_RtoL(max)
#
#    if(!block.empty()):
#        # compare to blocks
#
#    block = []
#    block = lower_RtoL(max)
#
#    if(!block.empty()):
#        # compare to blocks
#
#    block = []
#    block = upper_LtoR(max)
#
#    if(!block.empty()):
#        # compare to blocks
#
#    block = []
#    block = lower_LtoR(max)
#
#    if(!block.empty()):
#        # compare to blocks
    print blocks
    for i in range(len(blocks)):
        x = blocks[i][0]
        y = blocks[i][1]
        if(board[x][y] == 0):
            return x, y
    return -1, -1

def play(player, board):
    rule1 = check_win(player, board, 4)
    rule2 = check_block(player * -1, board, 4)
    rule3 = check_block(player * -1, board, 3)
    rule4 = check_winblock(player, board)
    if(rule1[0] != -1 and rule1[1] != -1):
        print "Moved for a win!"
        return rule1
    elif(rule2[0] != -1 and rule2[1] != -1):
        print "Moved for a block"
        return rule2
    elif(rule3[0] != -1 and rule3[1] != -1):
        print "Moved for a block sooner"
        return rule3
    elif(rule4[0] != -1 and rule4[1] != -1):
        print "Made best move"
        return rule4
    else:
        print "DEFAULT MOVE BAD RULE 4"
        return 0, 0

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


