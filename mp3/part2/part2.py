
import matplotlib.pyplot as plt
import numpy as np

#Initialize weights to shape of 10 x 1024. Still choosing between np.zeros and np.random.rand, leaning toward rand
#weights = np.random.rand(10, 1025) * 2 - 1
weights = np.zeros((10, 1025))

#sgn(x) takes in the feature vector x and returns the index of the closest weight vector classification
def sgn(x):
	currmax = 0
	maxidx = 0
	for i in range(len(weights)):
		temp = np.dot(weights[i], x)
		if temp > currmax:
			currmax = temp
			maxidx = i	
	return maxidx

n = 1		#n is the learning rate
#epoch = 18	#epoch is the number of iterations through the training set

#Create train[] which is a 2D numpy array of all of the training feature vectors
trainset = open("digitdata/optdigits-orig_train.txt", "r")
train = np.zeros((1026))
line = trainset.readline()
for i in range(32):
	for j in range(len(line) - 1):
		train[j +  (i * 32)] = 1 if int(line[j]) > 0 else -1 #Using {-1, 1} since we subtract on a misclassification
	line = trainset.readline()
	train[1024] = 1
	train[1025] = int(line[1])
line = trainset.readline()
while line:
	x = np.zeros(1026)
	for i in range(32):
		for j in range(len(line) - 1):
			x[j +  (i * 32)] = 1 if int(line[j]) > 0 else -1 #Using {-1, 1} since we subtract on a misclassification
		line = trainset.readline()
	x[1024] = 1
	x[1025] = int(line[1])
	train = np.vstack([train, x])
	line = trainset.readline()

#Perform Training
print "\nTraining\n\n# of Epochs\tAccuracy\n"
trainacc = 0
for x in train:
	if sgn(x[:1025]) == x[1025]:
		trainacc += 1.0
print "0\t\t", trainacc / len(train) * 100
e = 0
while trainacc / len(train) * 100 != 100:
	trainacc = 0
	order = np.arange(len(train))	#Randomize ordering of training set so each iteration is different
	#np.random.shuffle(order)
	for idx in order:
		x = train[idx]
		guess = sgn(x[:1025])
		real = x[1025]
		if guess != real:
			weights[guess] -= n*x[:1025]
			weights[int(real)] += n*x[:1025]
	for idx in order:
		x = train[idx]
		guess = sgn(x[:1025])
                real = x[1025]
                if guess == real:
			trainacc += 1.0
	print e + 1, "\t\t", trainacc / len(train) * 100 #Print accuracy after each iteration
	e += 1

#Perform Testing
test = open("digitdata/optdigits-orig_test.txt", "r")
line = test.readline()
testcount = 0
testacc = 0
conf = np.zeros((10, 10))
while line:
        x = np.zeros(1025)
        for i in range(32):
                for j in range(len(line) - 1):
                        x[j +  (i * 32)] = 1 if int(line[j]) > 0 else -1
                line = test.readline()
	x[1024] = 1
        guess = sgn(x)
        real = int(line[1])
	conf[guess][real] += 1
	if guess == real:
		testacc += 1.0
	testcount += 1.0
        line = test.readline()
for i in range(len(conf)):
	conf[:, i] /= np.sum(conf[:, i])
print "\nConfusion Matrix:\n\n", np.around(conf, 3)
test.close()
print "\nOverall Test Accuracy:", testacc / testcount * 100, "%\n"
for i in range(10):
	digit = np.zeros((32, 32))
	for line in range(32):
		digit[line, :] = weights[i, line * 32 : (line + 1) * 32]
	plt.imshow(digit, cmap='hot')
	plt.show()
