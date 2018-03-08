#2.1 Reflex Agent
red_piece = 1
blue_piece = -1
rows = 7
cols = 7
#rule #1
test1 = [[0, 0, 1, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 1, 1, 0, 0],
         [0, 1, 0, 1, 0, 0, 0],
         [0, -1, -1, -1, -1, 0, 0],
         [0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0]]

test2 = [[0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0],
         [-1, 1, 1, 1, 1, 0, 0],
         [-1, -1, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0]]

test3 = [[0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0],
         [0, 0, -1, 0, 0, 0, 0],
         [0, 0, 1, 1, 1, 0, 0],
         [0, -1, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0]]

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


def check_row(row, piece):
    count = 0
    pieces = []
    for x in range(len(row)):
        if(row[x] == piece):
            count += 1
            pieces.append(x)
        elif(row[x] == 0):
            count = 0;
        if((count >= 3) and (row[x - 3] == 0) and (row[x + 1] == 0)):
            if(x < 6):
                if(row[x - 3] == 0):
                    row[x - 3] = blue_piece
                    return row
                else:
                    if(row[x + 1] == 0):
                        row[x + 1] = blue_piece
                        return row
        elif(count >= 4):
            if(x < 6):
                if(row[x - 4] == 0):
                    row[x - 4] = blue_piece
                    return row
                else:
                    if(row[x + 1] == 0):
                        row[x + 1] = blue_piece
                        return row
    return pieces

def check_col(board, col, piece):
    count = 0
    pieces = []
    for x in range(len(board)):
        if(board[x][col] == piece):
            count += 1
            pieces.append(y)
        elif(board[x][col] == 0):
            count = 0
        if((count >= 3) and (board[x - 3][col] == 0) and (board[x + 1][col] == 0)):
            if(x < 6):
                if(board[x + 1][col] == 0):
                    board[x + 1][col] = blue_piece
                    return board
                elif(x > 2):
                    if(board[x - 3][col] == 0):
                        board[x - 3][col] = blue_piece
                        return board
            elif(x > 2):
                if(board[x - 3][col] == 0):
                    board[x - 3][col] = blue_piece
                    return board
        elif(count >= 4):
            if(x < 6):
                if(board[x + 1][col] == 0):
                    board[x + 1][col] = blue_piece
                    return board
                elif(x > 2):
                    if(board[x - 4][col] == 0):
                        board[x - 4][col] = blue_piece
                        return board
            elif(x > 2):
                if(board[x - 4][col] == 0):
                    board[x - 4][col] = blue_piece
                    return board
    return 0

def not_checked(val, list):
    for i in range(len(list)):
        if(list[i] == val):
            return 0
    return 1

def check_win(board):
    cols_checked = []
    for x in range(len(board)):
        for y in range(len(board[x])):
            if(board[x][y] == blue_piece):
                row_val = check_row(board[x], blue_piece)
                if(len(row_val) < 6):
                    print("At row " + str(x) + " the output is " + str(row_val))
                    for y in range(len(row_val)):
                        if(not_checked(row_val[y], cols_checked)):
                            print("Checking col " + str(row_val[y]))
                            cols_checked.append(row_val[y])
                            val = check_col(board, row_val[y], blue_piece)
                            if(val != 0):
                                board = val
                                return board
                #print(cols_checked)
                else:
                    board[x] = row_val
                    return board


def check_block(board):
    cols_checked = []
    for x in range(len(board)):
        for y in range(len(board[x])):
            if(board[x][y] == red_piece):
                row_val = check_row(board[x], red_piece)
                if(len(row_val) < 6):
                    print("At row " + str(x) + " the output is " + str(row_val))
                    for y in range(len(row_val)):
                        if(not_checked(row_val[y], cols_checked)):
                            print("Checking col " + str(row_val[y]))
                            cols_checked.append(row_val[y])
                            val = check_col(board, row_val[y], red_piece)
                            if(val != 0):
                                board = val
                                return board
                #print(cols_checked)
                else:
                    board[x] = row_val
                    return board

def getsum(block):
    sum = 0
    for i in range(len(block)):
        if(block[i][2] == red_piece):#
            sum += 1
    return sum

def verify_block(blocks, x_cord, y_cord):
    for i in range(len(blocks)):
        if((blocks[i][0] >= x_cord) or (blocks[i][1] >= y_cord)):
            return 1
    return 0



# Need a way to compare the smallest block size so that the biggest is not
def check_winblock(board):
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
    print "rows"
    for x in range(len(board)):
        seq = 0
        for y in range(len(board[x])):
            if(board[x][y] != blue_piece):#
                seq += 1
                block.append((x, y, board[x][y]))
                if(seq == 5):
                    seq = 0
                    val = getsum(block)
                    print "VAL: " + str(val)
                    if(max <= val):
                        if(verify_block(blocks, x, y)):
                            print max
                            max = val
                            blocks = []
                            blocks = block
                    block = []
        
            else:
                seq = 0
                block = []

    block = []
    seq = 0

    print "cols"
    for x in range(len(board)):
        for y in range(len(board[x])):
            if(board[y][x] != blue_piece):#
                seq += 1
                block.append((y, x, board[y][x]))
                if(seq == 5):
                    seq = 0
                    val = getsum(block)
                    if(max <= val):
                        if(verify_block(blocks, y, x)):
                            max = val
                            blocks = []
                            blocks = block
                    block = []
            else:
                seq = 0
                block = []

    for i in range(len(blocks)):
        x = blocks[i][0]
        y = blocks[i][1]
        if(board[x][y] == 0):
            board[x][y] = red_piece#
            return board


print
print("Test 1")
check_win(test1)
check_block(test1)
check_winblock(test1)
print_board(test1)

print
print("Test 2")
check_win(test2)
check_block(test2)
check_winblock(test2)
print_board(test2)

print
print("Test 3")
check_win(test3)
check_block(test3)
check_winblock(test3)
print_board(test3)

print
print("Test 4")
check_win(test4)
check_block(test4)
check_winblock(test4)
print_board(test4)

