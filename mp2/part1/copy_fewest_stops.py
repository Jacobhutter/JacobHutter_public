import distmap as d
import numpy as np
import sys
N = 8
# index with [row][col]
graph = [[-1, 'E', 'D', 'E', 'D', 'C', 'A', 'C', 'E', -1],
         [-1, 'D', 'D', 'C', 'C', 'A', 'B', 'D', 'B', -1],
         [-1, 'A', 'A', 'A', 'C', 'B', 'A', 'A', 'A', -1],
         [-1, 'C', 'A', 'C', 'A', 'C', 'B', 'A', 'B', -1],
         [-1, 'B', 'D', 'E', 'C', 'D', 'C', 'C', 'D', -1]]

class successor:
    def __init__(self, loc):
        self.progression_column_indices = np.array([0, 0, 0, 0, 0])
        self.f = 0
        self.g = 0
        self.h = 0
        self.location = loc
        self.parent = -1
        self.distance = 0
        self.row_move = 0

def check_equal(l1, l2):
    for i in range(len(l1)):
        if l1[i] != l2[i]:
            return 0
    return 1

def check_done( l ):
    for i in range(len(l)):
        if l[i] != N:
            return 0
    print'success'
    return 1


def letters_in_a_row_heuristic( node ):
    letter_hash = { -1  : 0, 'A' : 0, 'B' : 0, 'C' : 0, 'D' : 0, 'E' : 0}
    max_freq = 0
    for i in range(5):
        cur_let = graph[i][node.progression_column_indices[i] + 1]
        if cur_let == -1:
            continue
        letter_hash[graph[i][node.progression_column_indices[i]+1]] += 1
    for key in letter_hash:
        if letter_hash[key] > 1:
            max_freq += letter_hash[key]
    return 5 - max_freq



def fewest_stops():
    nodes_expanded = 0
    start_successor = successor((0, 0))
    start_successor.progression_column_indices = np.array([0, 0, 0, 0, 0])
    open_list = []
    closed_list = []
    open_list.append(start_successor)
    while(open_list):
        cur = min(open_list, key = lambda t: t.f) # priority queue
        open_list.remove(cur)
        nodes_expanded += 1
        if check_done(cur.progression_column_indices):
            break

        cur_successors = []
        x = cur.location[0]
        y = cur.location[1]

        # check row 0
        if(cur.progression_column_indices[0] < N):
            s = successor((0, cur.progression_column_indices[0] + 1))
            s.progression_column_indices = np.array([0,0,0,0,0])
            s.progression_column_indices += cur.progression_column_indices
            s.progression_column_indices[0] += 1
            s.row_move = 0
            cur_successors.append(s)


        # check row 1
        if(cur.progression_column_indices[1] < N):

            s = successor((1, cur.progression_column_indices[1] + 1))
            s.progression_column_indices = np.array([0,0,0,0,0])
            s.progression_column_indices += cur.progression_column_indices
            s.progression_column_indices[1] += 1
            s.row_move = 1
            cur_successors.append(s)

        # check row 2
        if(cur.progression_column_indices[2] < N):

            s = successor((2, cur.progression_column_indices[2] + 1))
            s.progression_column_indices = np.array([0,0,0,0,0])
            s.progression_column_indices += cur.progression_column_indices
            s.progression_column_indices[2] += 1
            s.row_move = 2
            cur_successors.append(s)


        # check row 3
        if(cur.progression_column_indices[3] < N):

            s = successor((3, cur.progression_column_indices[3] + 1))
            s.progression_column_indices = np.array([0,0,0,0,0])
            s.progression_column_indices += cur.progression_column_indices
            s.progression_column_indices[3] += 1
            s.row_move = 3
            cur_successors.append(s)


        # check row 4
        if(cur.progression_column_indices[4] < N):
            s = successor((4, cur.progression_column_indices[4] + 1))
            s.progression_column_indices = np.array([0,0,0,0,0])
            s.progression_column_indices += cur.progression_column_indices
            s.progression_column_indices[4] += 1
            s.row_move = 4
            cur_successors.append(s)

        for s in cur_successors:
            target_letter = graph[s.location[0]][s.location[1]]
            for i in range(5):
                letter = graph[i][s.progression_column_indices[i] + 1]
                if target_letter == letter and i != s.row_move:
                    s.progression_column_indices[i] += 1 # all reachable factories from our own free move if same letter
            s.parent = cur
            s.distance = cur.distance + 1
            s.g = cur.g + cur.distance + 1
            s.h = letters_in_a_row_heuristic(s)
            s.f = s.g + s.h


			#check for lower f entries already open
            if [x for x in open_list if check_equal(x.progression_column_indices, s.progression_column_indices) and x.f <= s.f]:
                continue
            elif [x for x in closed_list if check_equal(x.progression_column_indices, s.progression_column_indices) and x.f <= s.f]:
		 		continue
            else:
                open_list.append(s)

        closed_list.append(cur)

    print 'stops: ', cur.distance, 'nodes_expanded: ', nodes_expanded
    while(cur.parent != -1):
        print(cur.location, cur.progression_column_indices, graph[cur.location[0]][cur.location[1]])
        cur = cur.parent

print("starting graph traversal \n")
end_node = fewest_stops()
print("ended traversal \n")
