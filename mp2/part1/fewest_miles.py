import distmap as d
import numpy as np
import sys
N = 5
letter_hash = {0: 'A', 1: 'B', 2: 'C', 3: 'D', 4: 'E'}
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
        self.letter = -1
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


def immediate_distance_heuristic( node ):
    node_letter = node.letter
    min_dist = 1934
    min_remaining_moves = sum(np.subtract([5,5,5,5,5], node.progression_column_indices))
    letter_hash = {0: 'A', 1: 'B', 2: 'C', 3: 'D', 4: 'E'}
    for i in range(5):
        cur_dist = d.dist(node_letter, letter_hash[i])
        if(cur_dist < min_dist and cur_dist != 0):
            min_dist = cur_dist
    return min_dist

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

def fewest_miles():
    nodes_expanded = 0
    start_successor = successor((0, 0))
    start_successor.progression_column_indices = np.array([0, 0, 0, 0, 0])
    open_list = []
    closed_list = []
    open_list.append(start_successor)
    while(open_list):
        nodes_expanded += 1
        cur = min(open_list, key = lambda t: t.f) # priority queue
        open_list.remove(cur)

        if check_done(cur.progression_column_indices):
            break

        cur_successors = []
        x = cur.location[0]
        y = cur.location[1]

        # generate successors
        for letter in range(5): # For each letter
            s = successor((cur.location[0], cur.location[1]))
            s.letter = letter_hash[letter]
            s.progression_column_indices = np.array([0,0,0,0,0])
            s.progression_column_indices += cur.progression_column_indices
            for i in range(5): # Each row progression
                if letter_hash[letter] == graph[i][cur.progression_column_indices[i] + 1]:
                    s.progression_column_indices[i] += 1
                    s.location = (i, cur.progression_column_indices[i] + 1)
            cur_successors.append(s)


        for s in cur_successors:
            target_letter = s.letter
            prev_letter = cur.letter
            if prev_letter == target_letter:
                continue
            s.parent = cur
            s.distance = cur.distance + d.dist(prev_letter, target_letter)
            s.g = cur.distance + d.dist(prev_letter, target_letter)
            s.h = immediate_distance_heuristic(s) + letters_in_a_row_heuristic(s)
            s.f = s.g + s.h

    		#check for lower f entries already open
            if [x for x in open_list if check_equal(x.progression_column_indices, s.progression_column_indices) and x.letter == s.letter and x.f <= s.f]:
                continue
            elif [x for x in closed_list if check_equal(x.progression_column_indices, s.progression_column_indices) and x.f <= s.f]:
                continue
            else:
                open_list.append(s)

        closed_list.append(cur)

    print 'distance: ', cur.distance, 'nodes_expanded: ', nodes_expanded
    while(cur.parent != -1):
        print(cur.location, cur.progression_column_indices, cur.distance, cur.letter)
        cur = cur.parent

print("starting graph traversal \n")
end_node = fewest_miles()
print("ended traversal \n")
