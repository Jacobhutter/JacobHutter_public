import part2
import numpy as np

data = np.zeros((10000, 6))

with open("normalized.txt", "r") as train:
        for i in range(10000):
                line = train.readline()
                line = line.split(" ")
                for j in range(len(line)):
                        data[i][j] = float(line[j])

with open("weights", "r") as w_in:
	weights = np.load(w_in)
with open("biases", "r") as b_in:
	biases = np.load(b_in)

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

