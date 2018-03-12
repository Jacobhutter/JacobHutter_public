import sys

def check(row):
        ret = 0
        open_end = 0
        curr = 0
        piece = 0
        for x in row:
                if(x == piece and piece != 0):
                        curr *= 10
                        if(abs(curr) == 10000):
                                if x < 0:
					return -sys.maxsize
				else:
					return sys.maxsize
                else:
                        if(x == 0):
                                open_end += 1
                                ret += curr * open_end
                                open_end = 1
                        else:
                                ret += curr * open_end
                        curr = x
                        piece = x
        if len(row) < 5:
                ret /= 4
        return ret

def utility(board):
        ret = 0
        for row in board:
		tmp = check(row)
		if tmp >= sys.maxint:
                	return sys.maxint
        	elif tmp <= -sys.maxint:
                	return -sys.maxint
                ret += tmp
        for i in range(len(board[0])):
        	tmp = check(board[:, i])
                if tmp >= sys.maxint:
                        return sys.maxint
                elif tmp <= -sys.maxint:
                        return -sys.maxint
                ret += tmp
	i = 0
        for j in range(7):
                diag = []
                while(j >= 0):
                        diag.append(board[i][j])
                        j -= 1
                        i += 1
                i = 0
        	tmp = check(diag)
                if tmp >= sys.maxint:
                        return sys.maxint
                elif tmp <= -sys.maxint:
                        return -sys.maxint
                ret += tmp
	j = 6
        for i in range(7):
                diag = []
                temp = i
                while(i < 7):
                        diag.append(board[i][j])
                        j -= 1
                        i += 1
                j = 6
                i = temp
        	tmp = check(diag)
                if tmp >= sys.maxint:
                        return sys.maxint
                elif tmp <= -sys.maxint:
                        return -sys.maxint
                ret += tmp
	i = 1
        for j in range(7):
                diag = []
                while(j >= 0):
                        diag.append(board[i][j])
                        j -= 1
                        i -= 1
                i = 0
        	tmp = check(diag)
                if tmp >= sys.maxint:
                        return sys.maxint
                elif tmp <= -sys.maxint:
                        return -sys.maxint
                ret += tmp
	j = 6
        for i in range(1, 7):
                diag = []
                temp = i
                while(i >= 0):
                        diag.append(board[i][j])
                        j -= 1
                        i -= 1
                j = 6
                i = temp
        	tmp = check(diag)
                if tmp >= sys.maxint:
                        return sys.maxint
                elif tmp <= -sys.maxint:
                        return -sys.maxint
                ret += tmp
	return ret
