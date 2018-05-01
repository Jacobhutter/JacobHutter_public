import part2
import numpy as np

data = np.zeros((10000, 6))
with open("normalized.txt", "r") as train:
	for i in range(10000):
		line = train.readline()
		line = line.split(" ")
		for j in range(len(line)):
			data[i][j] = float(line[j])	
part2.minibatch_3layer(data, 300)
