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
         [0, -1, -1, -1, -1, 0],
         [0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0]]

test2 = [[0, 0, 1, 0, 0, 0, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0],
         [0, 0, 0, 1, 1, 0, 0, 0],
         [0, 1, 0, 1, 0, 0, 0, 0],
         [0, -1, -1, -1, -1, 0, 0],
         [0, 0, 0, 0, 0, 0, 0, 0],
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

def check_row(row):
    count = 0
    pieces = []
    for x in range(len(row)):
        if(row[x] == blue_piece):
            count += 1
            pieces.append(x)
        elif(row[x] == 0):
            count = 0;
        if(count >= 4):
            if(x < 6):
                if(row[x + 1] == 0):
                    row[x + 1] = blue_piece
                    return row
                else:
                    if(row[x - 4] == 0):
                        row[x - 4] = blue_piece
                        return row
    return pieces

def check_win(board):
    for x in range(len(test1)):
        for y in range(len(test1[x])):
            if(board[x][y] == blue_piece):
                val = check_row(board[x])
                if(len(val) < 7):
                    print("At row " + str(x) + " the output is " + str(val))
                else:
                    board[x] = val
                break
    return board

print
print("TEST 1")
check_win(test1)
print
print("TEST 2")
check_win(test2)
print(test2)
