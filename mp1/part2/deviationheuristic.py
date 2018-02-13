import sys
import astar
import itertools
import copy
import math

class successor:
    def __init__(self, loc):
        self.distance = 0
        self.location = loc
        self.parent = []

# calculate furthest from mean
def deviation(critical_points, loc1, dist_map):
    distances = []
    g_sum = 0
    global_dist = 0
    global_loc = 0
    for p in range(len(critical_points)):
        distances.append(dist_map[(loc1, critical_points[p])])
        g_sum += dist_map[(loc1, critical_points[p])]
    g_mean = g_sum / len(distances) # find mean
    for p in range(len(distances)):
        d = abs(distances[p] - g_mean)
        if d > global_dist:
            if distances[p] <= g_mean or global_dist == 0:
                global_dist = d
                global_loc = critical_points[p]

    return global_loc

def deviation_heuristic(start, end, maze):
    dist_map = dict()
    critical_points = end
    critical_points.insert(0, start)
    preprocessing = 0
    for i in range(0, len(critical_points)):
    	for j in range(0, len(critical_points)):
    		dist, cost = astar.a_star(critical_points[i], critical_points[j], maze)
    		preprocessing += cost
		dist_map[(critical_points[i], critical_points[j])] = dist
    		dist_map[(critical_points[j], critical_points[i])] = dist
    critical_points.remove(start)
    cur_loc = start
    cur = successor(start)
    nodes_explored = 0
    while(critical_points):
        deviant = deviation(critical_points, cur.location, dist_map)
	nodes_explored += 1
        if deviant == 0:
            break
        deviant = successor(deviant)
        deviant.parent = copy.copy(cur.parent)
	deviant.parent.append(cur.location)
        deviant.distance = cur.distance +  dist_map[(cur.location, deviant.location)]
        critical_points.remove(deviant.location)
        cur = deviant
    sol_dist = cur.distance
    sol = cur.parent
    sol.append(cur.location)
    cur = set(end) - set(sol)
    for loc in cur:
    	sol.append(loc)
    sol_dist += dist_map[(sol[-2], sol[1])]
    
    return sol_dist, sol, nodes_explored, preprocessing

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

cost, min_path, nodes_explored, preprocessing = deviation_heuristic(start, end, maze)
min_path.insert(0, start)
print("\nMinimum Path Length: ")
print(cost)
print("\nMinimum Path Order (Coordinates): ")
print(min_path)
print("\nNodes Explored in Preprocessing: \n")
print(preprocessing)
print("\nNodes Explored at Top Level: \n")
print(nodes_explored)
print("\nTotal Nodes Explored: \n")
print(nodes_explored + preprocessing)
print("\nMinimum Path Order (Graph): \n")
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

alphabet = map(chr, range(128, 165))
for letter in alphabet:
        charset.append(letter)
for i in range(1, len(min_path)):
    maze[min_path[i][0]][min_path[i][1]] = ord(charset[char])
    if(char < len(charset) - 1):
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
