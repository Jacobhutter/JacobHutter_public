	#PARSE CODE
import astar
import itertools
maze = []
start = (0, 0,) # x, y, f, parent
end = []
with open("./mazes/customSearch.txt", 'r') as f1:
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

dist_map = dict()
critical_points = end
critical_points.insert(0, start)

for i in range(0, len(critical_points)):
	for j in range(0, len(critical_points)):
		dist = astar.a_star(critical_points[i], critical_points[j], maze)
		dist_map[(critical_points[i], critical_points[j])] = dist
		dist_map[(critical_points[j], critical_points[i])] = dist

#	https://github.com/CarlEkerot/held-karp/blob/master/held-karp.py

#	Reduced the problem to the Traveling Salesman Problem by creating an extra state.
#	The extra state has no weight to the start state and infinite weight to the nodes to touch.
#	The weights for the extra state are reversed going the other direction, so that any cycle from
#	the extra state back to itself will be a solution to our problem of touching each dot.

#	Used the Held-Karp Algorithm to optimize the TSP


C = {}

extra = (-1, -1)
dist_map[(extra, start)] = 0
dist_map[(start, extra)] = float('inf')

for node in critical_points[1:]:
	dist_map[(extra, node)] = float('inf')
	dist_map[(node, extra)] = 0
critical_points.insert(0, extra)

n = len(critical_points)

for k in range(1, n):
	C[(1 << k, k)] = (dist_map[(critical_points[0], critical_points[k])], 0)

for subset_size in range(2, n):
	for subset in itertools.combinations(range(1, n), subset_size):
		bits = 0

		for bit in subset:
			bits |= 1 << bit

		for k in subset:
			prev = bits & ~(1 << k)
			res = []

			for m in subset:
				if m == 0 or m == k:
					continue

				res.append((C[(prev, m)][0] + dist_map[(critical_points[m], critical_points[k])], m))

			C[(bits, k)] = min(res)

bits = (2 ** n - 1) - 1
res = []

for k in range(1, n):
	res.append((C[(bits, k)][0] + dist_map[(critical_points[k], critical_points[0])], k))

opt, parent = min(res)
opt -= 1
min_path = []

for i in range(n - 1):
	min_path.append(critical_points[parent])
	new_bits = bits & ~(1 << parent)
	_, parent = C[(bits, parent)]
	bits = new_bits

min_path = list(reversed(min_path))

print("\nMinimum Path Order (Coordinates): ")
print(min_path)

print("\nMinimum Path Length: ")
print(opt)

print("\nMinimum Path Order (Graph): ")
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
print("\n")
