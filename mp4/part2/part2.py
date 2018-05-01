import numpy as np

def affine_forward(a, w, b):
    z = np.dot(a, w)
    for j in range(len(b)):
	z[:, j] += b[j]
    return z, a, w, b

def affine_backward(dz, a, w, b):
    da = np.dot(dz, np.transpose(w))
    dw = np.dot(np.transpose(a), dz)
    db = np.zeros(len(dz[0]))
    for j in range(len(dz[0])):
	db[j] = np.sum(dz[:, j])

    return da, dw, db

def relu_forward(z):
	a = np.zeros((len(z), len(z[0])))
	cache = z

	for i in range(len(z)):
		for j in range(len(z[0])):
			if z[i][j] < 0:
				a[i][j] = 0
			else:
				a[i][j] = z[i][j]
	return a, cache

def relu_backward(da, cache):
	dz = np.zeros((len(da), len(da[0])))
	
	for i in range(len(da)):
		for j in range(len(da[0])):
			if cache[i][j] < 0:
				dz[i][j] = 0
			else:
				dz[i][j] = da[i][j]

	return dz

def cross_entropy(f, y):
    n = len(y)
    line_loss = np.zeros(len(y))
    for i in range(len(y)):
	correct = f[i, int(y[i])]
	incorrect = 0
	for k in range(3):
	    incorrect += np.exp(f[i, k])
	incorrect = np.log(incorrect)
	line_loss[i] = correct - incorrect
    l = -1 * np.mean(line_loss)
    df = np.zeros((len(f), len(f[0])))
    for i in range(len(f)):
	exp_sum = np.sum(np.exp(f[i, :]))
	for j in range(len(f[0])):
	    if j == y[i]:
		df[i][j] = 1
	    else:
		df[i][j] = 0
	    df[i][j] -= np.exp(f[i][j]) / exp_sum
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
        choices = []
	for row in f:
		choice = 0
		if f[1] > f[0]:
			choice = 1
		if f[2] > f[1]:
			choice = 2
		choices.append(choice)
	return choices

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
        choices = []
	for row in f:
		choice = 0
		if f[1] > f[0]:
			choice = 1
		if f[2] > f[1]:
			choice = 2
		choices.append(choice)
	return choices

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

    test = 0

    for e in range(epoch):
	print e
	np.random.shuffle(data)
	for i in range(128, len(data), 128):
	    x = data[(i - 128):i, :5]
	    y = data[(i - 128):i, 5]
	    loss = flnn(x, weights, biases, y, test)

    test = 1
    confusion = np.zeros((3, 3))
    for i in range(128, len(data), 128):
	    x = data[(i - 128):i, :5]
	    y = data[(i - 128):i, 5]
	    choices = flnn(x, weights, biases, y, test)
	    for i in range(128):
		confusion[int(y[i])][choices[i]] += 1

    print confusion

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
	for i in range(128, len(data), 128):
	    x = data[(i - 128):i, :5]
	    y = data[(i - 128):i, 5]
	    loss = tlnn(x, weights, biases, y, test)

    test = 1
    confusion = np.zeros((3, 3))
    for i in range(128, len(data), 128):
	    x = data[(i - 128):i, :5]
	    y = data[(i - 128):i, 5]
	    choices = tlnn(x, weights, biases, y, test)
	    for i in range(128):
		confusion[int(y[i])][choices[i]] += 1

    print confusion









