import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

def affine_forward(a, w, b):
        z = np.add(np.dot(a, w), b)
        return z, a, w, b

def affine_backward(dz, a, w, b):
        da = np.dot(dz, np.transpose(w))
        dw = np.dot(np.transpose(a), dz)
        db = np.sum(dz, axis=0)
        return da, dw, db

def relu_forward(z):
        a = z * (z > 0)
        cache = z
        return a, cache

def relu_backward(da, cache):
        a = cache
        dz = da * (a > 0)
        return dz

def cross_entropy(f, y):
        n = len(y)
        l = 0
        for i in range(n):
                l += f[i, y[i]] - np.log(np.sum(np.exp(f[i])))
        l /= -n

        df = np.zeros((len(f), len(f[0])))
        for i in range(len(f)):
                exp_sum = np.sum(np.exp(f[i, :]))
                for j in range(len(f[0])):
                        df[i][j] = (0, 1)[j == y[i]] - np.exp(f[i][j]) / exp_sum
        df /= -n

        return l, df

#flnn - four layer neural network
def flnn(x, weights, biases, y, test):

        n = 0.1

        z1, acache1, wcache1, bcache1 = affine_forward(x, weights[0], biases[0])
        a1, rcache1 = relu_forward(z1)
        z2, acache2, wcache2, bcache2 = affine_forward(a1, weights[1], biases[1])
        a2, rcache2 = relu_forward(z2)
        z3, acache3, wcache3, bcache3 = affine_forward(a2, weights[2], biases[2])
        a3, rcache3 = relu_forward(z3)
        f, acache4, wcache4, bcache4 = affine_forward(a3, weights[3], biases[3])

        if test:
                return np.argmax(f, axis=1)

        loss, df = cross_entropy(f, y)
        da3, dw3, db3 = affine_backward(df, acache4, wcache4, bcache4)
        dz3 = relu_backward(da3, rcache3)
        da2, dw2, db2 = affine_backward(dz3, acache3, wcache3, bcache3)
        dz2 = relu_backward(da2, rcache2)
        da1, dw1, db1 = affine_backward(dz2, acache2, wcache2, bcache2)
        dz1 = relu_backward(da1, rcache1)
        dx, dw0, db0 = affine_backward(dz1, acache1, wcache1, bcache1)

        weights[0] -= n * dw0
        weights[1] -= n * dw1
        weights[2] -= n * dw2
        weights[3] -= n * dw3

        biases[0] -= n * db0
        biases[1] -= n * db1
        biases[2] -= n * db2
        biases[3] -= n * db3

        return loss

#tlnn - three layer neural network
def tlnn(x, weights, biases, y, test):

        n = 0.1

        z1, acache1, wcache1, bcache1 = affine_forward(x, weights[0], biases[0])
        a1, rcache1 = relu_forward(z1)
        z2, acache2, wcache2, bcache2 = affine_forward(a1, weights[1], biases[1])
        a2, rcache2 = relu_forward(z2)
        f, acache3, wcache3, bcache3 = affine_forward(a2, weights[2], biases[2])

        if test:
                return np.argmax(f, axis=1)

        loss, df = cross_entropy(f, y)
        da2, dw2, db2 = affine_backward(df, acache3, wcache3, bcache3)
        dz2 = relu_backward(da2, rcache2)
        da1, dw1, db1 = affine_backward(dz2, acache2, wcache2, bcache2)
        dz1 = relu_backward(da1, rcache1)
        dx, dw0, db0 = affine_backward(dz1, acache1, wcache1, bcache1)

        weights[0] -= n * dw0
        weights[1] -= n * dw1
        weights[2] -= n * dw2

        biases[0] -= n * db0
        biases[1] -= n * db1
        biases[2] -= n * db2

        return loss

def minibatch_4layer(data, epoch):
        w0 = np.random.rand(5, 256) - 0.5
        w1 = np.random.rand(256, 256) - 0.5
        w2 = np.random.rand(256, 256) - 0.5
        w3 = np.random.rand(256, 3) - 0.5
        weights = np.array([w0, w1, w2, w3])

        b0 = np.zeros(256)
        b1 = np.zeros(256)
        b2 = np.zeros(256)
        b3 = np.zeros(3)
        biases = np.array([b0, b1, b2, b3])

	print "Epoch\t\tLoss\t\t\tAccuracy"
	losses = []
	accuracies = []
        for e in range(epoch):
		test = 0
                np.random.shuffle(data)
                loss = 0
                for i in range(125, len(data) + 1, 125):
                        x = data[(i - 125):i, :5]
                        y = data[(i - 125):i, 5].astype(int)
                        loss += flnn(x, weights, biases, y, test)
		test = 1
		accuracy = 0
		for i in range(125, len(data), 125):
                	x = data[(i - 125):i, :5]
                	y = data[(i - 125):i, 5].astype(int)
                	choices = flnn(x, weights, biases, y, test)
			accuracy += 125 - np.count_nonzero(choices - y)
		print str(e) + "\t\t" + str(loss / 80) + "\t\t" + str(accuracy / 100.0) + "%"
		losses.append(loss / 80)
		accuracies.append(accuracy / 100.0)

	plt.figure(1)
	plt.subplot(221)
	plt.plot(range(epoch), losses)
	plt.subplot(222)
	plt.plot(range(epoch), accuracies)
	plt.savefig("plot.png")
        test = 1
        confusion = np.zeros((3, 3))

        for i in range(125, len(data), 125):
                x = data[(i - 125):i, :5]
                y = data[(i - 125):i, 5].astype(int)
                choices = flnn(x, weights, biases, y, test)
                for i in range(125):
                        confusion[int(y[i])][choices[i]] += 1

        for row in confusion:
                row /= np.sum(row)

        np.set_printoptions(suppress=True)
        print confusion
        print "Accuracy: ", str('%f' % ((confusion[0][0] + confusion[1][1] + confusion[2][2]) / .03)) + "%"
	plt.close()
	return weights, biases

def minibatch_3layer(data, epoch):
        w0 = np.random.rand(5, 256) - 0.5
        w1 = np.random.rand(256, 256) - 0.5
        w2 = np.random.rand(256, 3) - 0.5
        weights = np.array([w0, w1, w2])

        b0 = np.zeros(256)
        b1 = np.zeros(256)
        b2 = np.zeros(3)
        biases = np.array([b0, b1, b2])

        test = 0

        for e in range(epoch):
                print e
                np.random.shuffle(data)
                loss = 0
                for i in range(125, len(data) + 1, 125):
                        x = data[(i - 125):i, :5]
                        y = data[(i - 125):i, 5].astype(int)
                        loss += tlnn(x, weights, biases, y, test)
                print loss / 80

        test = 1
        confusion = np.zeros((3, 3))

        for i in range(125, len(data) + 1, 125):
                x = data[(i - 125):i, :5]
                y = data[(i - 125):i, 5].astype(int)
                choices = tlnn(x, weights, biases, y, test)
                for i in range(125):
                        confusion[int(y[i])][choices[i]] += 1

        for row in confusion:
                row /= np.sum(row)

        np.set_printoptions(suppress=True)
        print confusion
        print "Accuracy: ", str('%f' % ((confusion[0][0] + confusion[1][1] + confusion[2][2]) / .03)) + "%"

