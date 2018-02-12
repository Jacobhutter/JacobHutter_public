import sys
import astar
import itertools
import copy
from collections import defaultdict
import heapq

class successor:
	def __init__(self, loc):
		self.f = 0
		self.g = 0
		self.h = 0
		self.u = 0
		self.location = loc
		self.parent = []
		self.unvisited = set()

	def __lt__(self, other):
		if self.f < other.f:
			return True
		elif self.f == other.f and self.h < other.h:
			return True
		return False

def mst(critical_points, dist_map):
    edges = []
    subgraph = []
    distance = 0

    for i in range(len(critical_points)):
        for j in range(i,len(critical_points)):
            if(i != j):
                edges.append((dist_map[(critical_points[i], critical_points[j])], critical_points[i], critical_points[j])) # distance, startpoint, endpoint

    edges.sort(key=lambda x: x[0]) # sort by distance
    add_flag = 0

    for e in range(len(edges)):
        add_flag = 0
        if not (edges[e][1] in subgraph):
            subgraph.append(edges[e][1])
            add_flag = 1
        if not (edges[e][2] in subgraph):
            subgraph.append(edges[e][2])
            add_flag = 1
        if add_flag:
            distance += edges[e][0]
        if len(subgraph) == len(critical_points):
            break

    return distance


def nearest_unvisited(loc1, critical_points, dist_map):
    global_min = sys.maxint

    if(len(critical_points) == 0):
	return 0

    for i in range(len(critical_points)):
        if dist_map[(loc1, critical_points[i])] < global_min:
            global_min = dist_map[(loc1, critical_points[i])]

    return global_min

def mst_heuristic(start, end, maze):

	#SEARCH CODE

    nodes_explored = 0
    start_successor = successor(start)
    start_successor.unvisited = list(end)
    found_end = 0
    start_successor.distance = 0
    open_list = []
    heapq.heappush(open_list, start_successor)
    closed_list = []

    dist_map = dict()
    critical_points = end
    critical_points.insert(0, start)

    for i in range(0, len(critical_points)):
    	for j in range(0, len(critical_points)):
    		dist = astar.a_star(critical_points[i], critical_points[j], maze)
    		dist_map[(critical_points[i], critical_points[j])] = dist
    		dist_map[(critical_points[j], critical_points[i])] = dist

    # https://www.geeksforgeeks.org/a-search-algorithm/
    global_cost = sys.maxint
    ret_path = []
    best_state = defaultdict(lambda: None)
    while(open_list):
	nodes_explored += 1
    	q = heapq.heappop(open_list) # pick out minimum f
    	q_successors = []

        # check goal state
		#print(q.h)
		#print(q.f)
		#print("Global Cost: " + str(global_cost))

        if not q.unvisited:
	    closed_list.append(q)
	    if q.f < global_cost:
		print(q.f)
		global_cost = q.f
		ret_path = copy.copy(q.parent)
		ret_path.append(q.location)
	    	for x in open_list:
			if x.f >= global_cost:
				open_list.remove(x)
		heapq.heapify(open_list)
	    if not open_list:
		break
	    else:
		continue

        # generate successors
        for i in range(len(q.unvisited)):
            q_successors.append(successor(q.unvisited[i]))

    	for s in q_successors:

    		s.parent = copy.copy(q.parent)
		s.parent.append(q.location)
		s.unvisited = set()
		s.unvisited = copy.copy(q.unvisited)
		s.unvisited.remove(s.location)

    		s.g = q.g + dist_map[(q.location, s.location)]
    		s.h = mst(s.unvisited, dist_map)
			#s.u = nearest_unvisited(s.location, s.unvisited, dist_map)
    		s.f = s.g + s.h# + s.u

    		#check for lower f entries already open
		if global_cost <= s.f:
			continue
		curr_best = best_state[(tuple(s.unvisited), s.location)]
		if curr_best == None:
			best_state[(tuple(s.unvisited), s.location)] = s
			heapq.heappush(open_list, s)
		elif best_state[(tuple(s.unvisited), s.location)].g > s.g:
			#try:
			#	print('test') 
				#open_list.remove(best_state[(tuple(s.unvisited), s.location)])
				#heapq.heapify(open_list)
			#except ValueError:
			#	pass
			best_state[(tuple(s.unvisited), s.location)] = s
			heapq.heappush(open_list, s)
		
    return maze, global_cost, ret_path, nodes_explored

maze = []
start = (0, 0,) # x, y, f, parent
end = []
with open(sys.argv[1], 'r') as f1:
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

maze, cost, min_path, nodes_explored = mst_heuristic(start, end, maze)
print("\nMinimum Path Length: ")
print(cost)
print("\nMinimum Path Order (Coordinates): ")
print(min_path)
print("\nMinimum Path Order (Graph): \n")
print("\nNodes Explored: \n")
print(nodes_explored)
maze[start[0]][start[1]] = -5
char = 0
charset = []

for i in range(1, 10):
	charset.append(str(i))

alphabet = map(chr, range(97, 123))
for letter in alphabet:
	charset.append(letter)

alphabet = map(chr, range(65, 91))
for letter in alphabet:
        charset.append(letter)

for i in range(1, len(min_path)):
	maze[min_path[i][0]][min_path[i][1]] = ord(charset[char])
	char += 1

for line in maze:
    string = ''
    for num in line:
        if(num == -1):
            string += '%'
	elif(num == -5):
	    string += '0'
        elif(num > 0):
            string += chr(num)
        else:
            string += ' '
    print(string)
