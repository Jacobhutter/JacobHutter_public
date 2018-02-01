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
    for c in line_delim:
        if c == start:
            # store start location as a tuple
            start_location = (lines.index(line), line.index(c))
        if c == pellet:
            # store the number of pellets as well as their locations as a tuple
            pellet_count += 1
            pellet_locations.append((lines.index(line), line.index(c)))
        row.append(c)
    my_maze.append(row)

class bot:
    location = start_location

    def move_up(self):
        current_y = self.location[0]
        current_x = self.location[1]

        current_y -= 1

        self.location = (current_y, current_x)

    def move_down(self):
        current_y = self.location[0]
        current_x = self.location[1]

        current_y += 1

        self.location = (current_y, current_x)

    def move_right(self):
        current_y = self.location[0]
        current_x = self.location[1]

        current_x += 1

        self.location = (current_y, current_x)

    def move_left(self):
        current_y = self.location[0]
        current_x = self.location[1]

        current_x -= 1

        self.location = (current_y, current_x)

pacman = bot()
stack = list()
stack.append(pacman.location)
while stack:
    cur_location = stack.pop()
#print "Starting Location:" + str(start_location)
#
## Move in a circle
#pacman.move_down()
#pacman.move_right()
#pacman.move_up()
#pacman.move_left()
#
#
#print "Ending Location:" + str(pacman.location)



# used to test that setup of maze is correct
print start_location
print pellet_locations
print my_maze



f.close()
