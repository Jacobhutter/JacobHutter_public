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
	return abs(loc2[0] - loc1[0]) + abs(loc2[1] - loc1[1])


def a_star(start, end, maze):

		#SEARCH CODE
	start_successor = successor(start)
	found_end = 0
	start_successor.distance = 0
	open_list = []
	closed_list = []
	open_list.append(start_successor)
	nodes_explored = 0
	# https://www.geeksforgeeks.org/a-search-algorithm/
	while(open_list):
		q = min(open_list, key = lambda t: t.f) # pick out minimum f
		open_list.remove(q)
		nodes_explored += 1
		q_successors = []
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
			s.h = manhattan_distance(s.location, end)
			s.f = s.g + s.h

			if(s.location == end):
				return s.distance, nodes_explored

			#check for lower f entries already open
			if [x for x in open_list if x.location == s.location and x.f <= s.f]:
				continue
		 	#check for lower f entries already closed
			elif [x for x in closed_list if x.location == s.location and x.f <= s.f]:
		 		continue
		 	else:
		 		open_list.append(s)

		closed_list.append(q)

