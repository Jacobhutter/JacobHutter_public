	#PARSE CODE
import astar
maze = []
start = (0, 0,) # x, y, f, parent
end = []


print("Input Maze\n")

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

dist_map = dict()
critical_points = end
critical_points.insert(0, start)

for i in range(0, len(critical_points)-1):
	for j in range(0, len(critical_points)-1):
		dist = astar.a_star(critical_points[i], critical_points[j], maze)
		dist_map[(critical_points[i], critical_points[j])] = dist
print dist_map

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
