import sys

class successor:
	def __init__(self, loc):
		self.f = 0
		self.g = 0
		self.h = 0
		self.location = loc
		self.parent = -1
		self.distance = -1

def manhattan_distance(loc1, loc2):
	return abs(loc1[0] - loc2[0]) + abs(loc1[1] - loc2[0])

#	PARSE CODE

maze = []
start = (0, 0,) # x, y, f, parent
end = []




print("Input Maze\n")

with open("./mazes/mediumSearch.txt", 'r') as f1:
	x = 0
        for line in f1:
                row = []
		y = 0
                for char in line:
                        if(char == '%'):
                                row.append(-1)
                        elif(char == 'P'):
                                row.append(0)
				start = (x, y)
                        elif(char == '.'):
                                row.append(-5)
				end.append((x, y))
                        else:
                                row.append(0)
			y += 1
                maze.append(row)
		x += 1

for line in maze:
	string = ''
        for num in line:
		if(num >= 0):
                	string += ' '
		string += str(num)
        print(string)
len_end = len(end)
for a in range(0,len_end):
	print("\n")
	print("Start Node: (" + str(start[0]) + ", " + str(start[1]) + ")")
	print("End Node:")
	print(end)
	print("\n")
	global_min = sys.maxint
	global_end = 0
	for i in range(0,len(end)-1):
		end_loc = (end[i][0], end[i][1])
			#SEARCH CODE
		start_successor = successor(start)
		found_end = 0
		start_successor.distance = 0
		open_list = []
		closed_list = []
		open_list.append(start_successor)
		nodes = 0
		maze[start[0]][start[1]] = 1
		# open list contains triple (y,x,f)
		# https://www.geeksforgeeks.org/a-search-algorithm/
		while(open_list):
			q = min(open_list, key = lambda t: t.f) # pick out minimum f
			open_list.remove(q)
			q_successors = []
			nodes += 1
			x = q.location[0]
			y = q.location[1]

			#check above
			if maze[x-1][y] != -1:
				q_successors.append(successor((x-1, y)))

			#check right
			if maze[x][y+1] != -1:
				q_successors.append(successor((x, y+1)))

			#check left
			if maze[x][y-1] != -1:
				q_successors.append(successor((x, y-1)))

			#check below
			if maze[x+1][y] != -1:
				q_successors.append(successor((x+1, y)))

			for s in q_successors:
				s.parent = q
				s.distance = q.distance + 1
				s.g = q.g + q.distance+1
				s.h = manhattan_distance(s.location, end_loc)
				s.f = s.g + s.h

				if(s.location == end_loc):
					found_end = 1
					break

				#check for lower f entries already open
				if [x for x in open_list if x.location == s.location and x.f <= s.f]:
					continue
			 	#check for lower f entries already closed
				elif [x for x in closed_list if x.location == s.location and x.f <= s.f]:
			 		continue
			 	else:
			 		open_list.append(s)

			closed_list.append(q)

			if found_end == 1:
				if s.distance < global_min:
					global_min = s.distance
					global_end = s
				break
		#	OUTPUT CODE
	cur = global_end

	if(not isinstance(cur, int)):
		start = cur.location
		end.remove(cur.location) # remove that list from ends
		maze[global_end.location[0]][global_end.location[1]] = 70
		print global_end.location
		while cur.parent != -1:
			cur = cur.parent
			x = cur.location[0]
			y = cur.location[1]
			maze[x][y] = 69


	for line in maze:
	        string = ''
	        for num in line:
			if(num == -1):
	                    string += '%'
			elif(num == -5):
				string += 'P'
			elif(num == 69):
				string += '.'
			elif(num == 70):
				string += 'X'
			else:
				string += ' '
	        print(string)

#print("\nDistance to End: " + str(int(global_end.distance)))
