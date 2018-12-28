def human_play(player, board):
	for i in range(len(board) - 1, -1, -1):
		temp = ''	
		for val in board[i]:
			if val == -1:
				temp += ' b '
			elif val == 1:
				temp += ' r '
			else:
				temp += ' . '
		print temp
	print 'Player Move:'
        inpt = 0
        while not inpt:
                xin = 0
                while not xin:
                        x = input('Row: ')
                        if int(x) > 6 or int(x) < 0:
                                print 'Invalid Input. Try Again'
                        else:
                                xin = 1
                yin = 0
                while not yin:
                        y = input('Col: ')
                        if int(y) > 6 or int(y) < 0:
                                print 'Invalid Input. Try Again'
                        else:
                                yin = 1
                if board[x][y] == 0:
                        inpt = 1
                        pos = (x, y)
		else:
			print 'That space has already been played. Try Again.'
	return pos
