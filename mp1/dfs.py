#	PARSE CODE

maze = []
start = (0, 0)
end = []

print("Input Maze\n")

with open("./mazes/openMaze.txt", 'r') as f1:
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

print("\n")        
print("Start Node: (" + str(start[0]) + ", " + str(start[1]) + ")")
print("End Node: (" + str(end[0][0]) + ", " + str(end[0][1]) + ")")
print("\n")

#	SEARCH CODE

dfs = []
dfs.append(start)
nodes = 0

while(dfs):
	curr = dfs.pop()
	nodes += 1
	x = curr[0]
	y = curr[1]
	if(x > 0):
		if(maze[x - 1][y] == 0):
			maze[x - 1][y] = int(maze[x][y]) + 1.1
			dfs.append((x - 1, y))
		elif(maze[x - 1][y] == -5):
			maze[x - 1][y] = int(maze[x][y]) + 1.1
			nodes += 1
			break

	if(x < len(maze) - 1):
		if(maze[x + 1][y] == 0):
                        maze[x + 1][y] = int(maze[x][y]) + 1.2
                        dfs.append((x + 1, y))
                elif(maze[x + 1][y] == -5):
                        maze[x + 1][y] = int(maze[x][y]) + 1.2
                        nodes += 1
			break
	if(y > 0):
		if(maze[x][y - 1] == 0):
                        maze[x][y - 1] = int(maze[x][y]) + 1.3
                        dfs.append((x, y - 1))
                elif(maze[x][y - 1] == -5):
                        maze[x][y - 1] = int(maze[x][y]) + 1.3
                        nodes += 1
			break
	if(y < len(maze[0]) - 1):
		if(maze[x][y + 1] == 0):
                        maze[x][y + 1] = int(maze[x][y]) + 1.4
                        dfs.append((x, y + 1))
                elif(maze[x][y + 1] == -5):
                        maze[x][y + 1] = int(maze[x][y]) + 1.4
                        nodes += 1
			break

#	OUTPUT CODE

print("Nodes Explored Maze: \n")
for line in maze:
        string = ''
        for num in line:
                if(num > 0):
                        string += ' 1'
                else:
                        string += str(num)
        print(string)
print("\n")

maze[start[0]][start[1]] = -5
reverse = []
reverse.append(end[0][0])
reverse.append(end[0][1])
end_dist = maze[reverse[0]][reverse[1]]
while(reverse[0] != start[0] or reverse[1] != start[1]):
	mod = maze[reverse[0]][reverse[1]] % 1.0
	maze[reverse[0]][reverse[1]] = -7
	if(mod <= 0.15):
		reverse[0] += 1
	elif(mod <= 0.25):
		reverse[0] -= 1
	elif(mod <= 0.35):
		reverse[1] += 1
	else:
		reverse[1] -= 1
		
for line in maze:
        string = ''
        for num in line:
		if(num == -1): 
                        string += '%'
		elif(num == -5):
			string += 'P'
		elif(num == -7):
			string += '.'
		else:
			string += ' '
        print(string)

print("\nDistance to End: " + str(int(end_dist)))
print("Nodes Explored: " + str(nodes))
