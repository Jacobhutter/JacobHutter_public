import distmap as d
import numpy as np
import sys

# index with [row][col]
graph = [[-1, 'A', 'E', 'D', 'C', 'A', -1],
         [-1, 'B', 'E', 'A', 'C', 'D', -1],
         [-1, 'B', 'A', 'B', 'C', 'E', -1],
         [-1, 'D', 'A', 'D', 'B', 'D', -1],
         [-1, 'B', 'E', 'C', 'B', 'D', -1]]

class successor:
    def __init__(self, loc):
        self.progression_column_indices = np.array([0, 0, 0, 0, 0])
        self.f = 0
        self.g = 0
        self.h = 0
        self.location = loc
        self.parent = -1
        self.distance = 0
        self.cost = 0
        self.row_move = 0

def check_equal(l1, l2):
    for i in range(len(l1)):
        if l1[i] != l2[i]:
            return 0
    return 1

def check_done( l ):
    for i in range(len(l)):
        if l[i] != 5:
            return 0
    print'success'
    return 1


def letters_in_a_row_heuristic_plus( node ):
    letter_hash = { -1  : 0, 'A' : 0, 'B' : 0, 'C' : 0, 'D' : 0, 'E' : 0}
    max_freq = 0
    dist = 0
    target_letter = graph[node.location[0]][node.location[1]]
    for i in range(5):
        cur_let = graph[i][node.progression_column_indices[i] + 1]
        if cur_let == -1:
            continue
        letter_hash[graph[i][node.progression_column_indices[i]+1]] += 1
    for key in letter_hash:
        if letter_hash[key] > 1:
            max_freq += letter_hash[key]
            dist += d.dist(target_letter, key)

    return (5 - max_freq) + dist



def fewest_stops():
    start_successor = successor((0, 0))
    start_successor.progression_column_indices = np.array([0, 0, 0, 0, 0])
    open_list = []
    closed_list = []
    open_list.append(start_successor)
    while(open_list):
        cur = min(open_list, key = lambda t: t.f) # priority queue
        open_list.remove(cur)

        if check_done(cur.progression_column_indices):
            break

        cur_successors = []
        x = cur.location[0]
        y = cur.location[1]

        # check row 0
        if(cur.progression_column_indices[0] < 5):
            s = successor((0, cur.progression_column_indices[0] + 1))
            s.progression_column_indices = np.array([0,0,0,0,0])
            s.progression_column_indices += cur.progression_column_indices
            s.progression_column_indices[0] += 1
            s.row_move = 0
            cur_successors.append(s)


        # check row 1
        if(cur.progression_column_indices[1] < 5):

            s = successor((1, cur.progression_column_indices[1] + 1))
            s.progression_column_indices = np.array([0,0,0,0,0])
            s.progression_column_indices += cur.progression_column_indices
            s.progression_column_indices[1] += 1
            s.row_move = 1
            cur_successors.append(s)

        # check row 2
        if(cur.progression_column_indices[2] < 5):

            s = successor((2, cur.progression_column_indices[2] + 1))
            s.progression_column_indices = np.array([0,0,0,0,0])
            s.progression_column_indices += cur.progression_column_indices
            s.progression_column_indices[2] += 1
            s.row_move = 2
            cur_successors.append(s)


        # check row 3
        if(cur.progression_column_indices[3] < 5):

            s = successor((3, cur.progression_column_indices[3] + 1))
            s.progression_column_indices = np.array([0,0,0,0,0])
            s.progression_column_indices += cur.progression_column_indices
            s.progression_column_indices[3] += 1
            s.row_move = 3
            cur_successors.append(s)


        # check row 4
        if(cur.progression_column_indices[4] < 5):
            s = successor((4, cur.progression_column_indices[4] + 1))
            s.progression_column_indices = np.array([0,0,0,0,0])
            s.progression_column_indices += cur.progression_column_indices
            s.progression_column_indices[4] += 1
            s.row_move = 4
            cur_successors.append(s)

        for s in cur_successors:
            target_letter = graph[s.location[0]][s.location[1]]
            prev_letter = graph[cur.location[0]][s.location[1]]
            for i in range(5):
                letter = graph[i][s.progression_column_indices[i] + 1]
                if target_letter == letter and i != s.row_move:
                    s.progression_column_indices[i] += 1 # all reachable factories from our own free move if same letter
            s.cost = cur.cost + d.dist(prev_letter, target_letter)
            s.parent = cur
            s.distance = cur.distance + 1
            s.g = cur.g + cur.distance + 1
            s.h = letters_in_a_row_heuristic_plus(s)
            s.f = s.g + s.h


			#check for lower f entries already open
            if [x for x in open_list if check_equal(x.progression_column_indices, s.progression_column_indices) and x.f <= s.f]:
                continue
            else:
                open_list.append(s)

        closed_list.append(cur)

    print cur.distance
    print cur.cost
    while(cur.parent != -1):
        print(cur.location, cur.progression_column_indices, cur.cost)
        cur = cur.parent

print("starting graph traversal \n")
end_node = fewest_stops()
print("ended traversal \n")
