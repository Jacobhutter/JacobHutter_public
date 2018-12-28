import part2
import numpy as np

with open("weights", "r") as w_in:
        weights = np.load(w_in)
with open("biases", "r") as b_in:
        biases = np.load(b_in)

def get_move(discrete_paddle, ball_pos, ball_speed):
	ball_x = ((ball_pos[0] + ball_pos[2]) / 2) / 500
	ball_y = ((ball_pos[1] + ball_pos[3]) / 2) / 500

	ball_vx = ball_speed[0] / 500
	ball_vy = ball_speed[1] / 500
	
	x = np.array([ball_x, ball_y, ball_vx, ball_vy, discrete_paddle])	
	return (-1 * part2.flnn(x, weights, biases, 0, 1) 

data = np.zeros((10000, 6))

with open("normalized.txt", "r") as train:
        for i in range(10000):
                line = train.readline()
                line = line.split(" ")
                for j in range(len(line)):
                        data[i][j] = float(line[j])

test = 1
confusion = np.zeros((3, 3))
for i in range(125, len(data), 125):
	x = data[(i - 125):i, :5]
	y = data[(i - 125):i, 5].astype(int)
	choices = part2.flnn(x, weights, biases, y, test)
	for i in range(125):
		confusion[int(y[i])][choices[i]] += 1
total_accuracy = str('%f' % ((confusion[0][0] + confusion[1][1] + confusion[2][2]) / 100)) + "%"
for row in confusion:
	row /= np.sum(row)

np.set_printoptions(suppress=True)
print confusion
print "Accuracy: ", total_accuracy

