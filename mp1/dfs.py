f = open("./mazes/openMaze.txt", "r")

my_maze = []

# variables used for setting up the maze
start = 'P'
start_location = None
pellet = '.'
pellet_count = 0
pellet_locations = []


# reads every line into an array lines
lines = f.readlines()

for line in lines:
    row = []    # create a new row array
    line_delim = line.rstrip()  # remove any unecessary characters
    for c in line:
        if c == start:
            # store start location as a tuple
            start_location = (lines.index(line), line.index(c))
        if c == pellet:
            # store the number of pellets as well as their locations as a tuple
            pellet_count += 1
            pellet_locations.append((lines.index(line), line.index(c)))
        row.append(c)
    my_maze.append(row)


# used to test that setup of maze is correct
print start_location
print pellet_locations
print my_maze



f.close()

