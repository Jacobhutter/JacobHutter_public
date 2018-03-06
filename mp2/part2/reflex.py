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

test2 = [[0, 0, 1, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 1, 1, 0, 0],
         [0, 1, 0, 1, 0, 0, 0],
         [0, -1, -1, -1, -1, 0, 0],
         [0, 0, 0, 0, 0, 0, 0],
         [0, -1, 0, -1, 0, -1, 0]]

test3 = [[0, 0, 1, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 1, 1, 0, 0],
         [0, 1, 0, 1, 0, -1, 0],
         [0, 0, 0, 0, 0, -1, 0],
         [0, 0, 0, 0, 0, -1, 0],
         [0, -1, 0, -1, 0, -1, 0]]

test4 = [[0, 0, 1, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 1, 1, 1, 0],
         [0, 1, 0, 1, 0, 1, 0],
         [0, 0, 0, 0, 0, 1, 0],
         [0, 0, 0, 0, 0, 1, 0],
         [0, -1, 0, -1, 0, -1, 0]]
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
    for row in board:
        print row


def check_row(row, piece):
    count = 0
    pieces = []
    for x in range(len(row)):
        if(row[x] == piece):
            count += 1
            pieces.append(x)
        elif(row[x] == 0):
            count = 0;
        if(count >= 4):
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
        if(count >=4):
            if(x < 6):
                print(board[6][col])
                if(board[x + 1][col] == 0):
                    board[x + 1][col] = blue_piece
                    return board
            elif(x > 3):
                print(board[6][col])
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
                                break
                #print(cols_checked)
                else:
                    board[x] = row_val
                return board



print
print("TEST 1")
check_win(test1)
print
print("TEST 2")
check_win(test2)
print
print("TEST 3")
check_win(test3)
print_board(test3)
print
print("TEST 4")
#check_block(test4)
print_board(test4)
