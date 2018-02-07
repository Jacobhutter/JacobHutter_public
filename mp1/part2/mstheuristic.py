import sys
import astar
import itertools
class successor:
	def __init__(self, loc):
		self.f = 0
		self.g = 0
		self.h = 0
		self.location = loc
		self.parent = -1
		self.distance = -1

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
    for i in range(len(critical_points)):
        if loc1 != critical_points[i] and dist_map[(loc1, critical_points[i])] < global_min:
            global_min = dist_map[(loc1, critical_points[i])]
    return global_min

def mst_heuristic(start, end, maze):

	#SEARCH CODE
    start_successor = successor(start)
    found_end = 0
    start_successor.distance = 0
    open_list = []
    closed_list = []
    open_list.append(start_successor)

    dist_map = dict()
    critical_points = end
    critical_points.insert(0, start)
    for i in range(0, len(critical_points)):
    	for j in range(0, len(critical_points)):
    		dist = astar.a_star(critical_points[i], critical_points[j], maze)
    		dist_map[(critical_points[i], critical_points[j])] = dist
    		dist_map[(critical_points[j], critical_points[i])] = dist

    iterations = 0
    # https://www.geeksforgeeks.org/a-search-algorithm/
    while(open_list):
    	q = min(open_list, key = lambda t: t.f) # pick out minimum f
        if q.location in critical_points:
            critical_points.remove(q.location)
    	open_list.remove(q)
    	q_successors = []

        # check goal state
        if not critical_points:
            break

        if q in closed_list:
            continue

        # generate successors
        for i in range(len(critical_points)):
            q_successors.append(successor(critical_points[i]))

    	for s in q_successors:
    		s.parent = q
    		s.distance = q.distance + dist_map[(q.location, s.location)]
    		s.g = q.g + dist_map[(q.location, s.location)]
    		s.h = mst(critical_points, dist_map) + nearest_unvisited(q.location, critical_points, dist_map) + nearest_unvisited(start, critical_points, dist_map)
    		s.f = s.g + s.h

    		#check for lower f entries already open
    		if [x for x in open_list if x.location == s.location and x.f <= s.f]:
    			continue
    	 	else:
    	 		open_list.append(s)
        maze[q.location[0]][q.location[1]] = iterations
        print q.location[0], q.location[1], iterations
        iterations += 1
    	closed_list.append(q)
    return maze


maze = []
start = (0, 0,) # x, y, f, parent
end = []
f = open("./outputs/output.txt", 'w')
with open("./mazes/tinySearch.txt", 'r') as f1:
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

maze = mst_heuristic(start, end, maze)
print maze
for line in maze:
    string = ''
    for num in line:
        if(num == -1):
            string += '%'
        elif(num == -1):
            string += '0'
        elif(num > 0):
            string += '1'
        else:
            string += ' '
    print(string + '\n')
f.write("\n")
