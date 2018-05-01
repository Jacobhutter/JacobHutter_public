import numpy as np
with open("dataset.txt", "r") as data:
	state = np.zeros((10000, 6))
	for i in range(10000):
		line = data.readline()
		line = line.split(" ")
		for j in range(6):
			state[i][j] = float(line[j])
	for i in range(5):
		std = np.std(state[:, i])
		mean = np.mean(state[:, i])
		state[:, i] -= mean
		state[:, i] /= std
		print np.std(state[:, i]), np.mean(state[:, i])
	normal = open("normalized.txt", "w")
	for i in range(10000):
		line = str(state[i][0])
		for val in state[i, 1:]:
			line += " " + str(val)
		normal.write(line + "\n")
