import part2
import numpy as np

data = np.zeros((10000, 6))

with open("normalized.txt", "r") as train:
        for i in range(10000):
                line = train.readline()
                line = line.split(" ")
                for j in range(len(line)):
                        data[i][j] = float(line[j])
layers = int(input("Choose 3 or 4 level network: "))
epochs = int(input("Choose number of epochs: "))
if layers == 3:
        part2.minibatch_3layer(data, epochs)
elif layers == 4:
        part2.minibatch_4layer(data, epochs)                                               
