	#PARSE CODE
import astar
import itertools
maze = []
start = (0, 0,) # x, y, f, parent
end = []
with open("./mazes/custom.txt", 'r') as f1:
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
combos = itertools.permutations(critical_points[1:])
min = -1
min_path = []
for perm in combos:
	temp = dist_map[(start, perm[0])]
	for i in range(1, len(perm)):
		temp += dist_map[(perm[i-1], perm[i])]
	if(min < 0 or temp < min):
		min = temp
		min_path = perm
print("\nMinimum Path Order: ")
print(min_path)
print("\nMinimum Path Length: ")
print(min)
print("\nMinimum Path Order: ")
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
for i in range(len(min_path)):
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
