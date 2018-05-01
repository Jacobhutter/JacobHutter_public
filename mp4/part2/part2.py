import numpy as np

def affine_forward(a, w, b):
    z = np.zeros((len(a), len(w[0])))
    cache = np.array([a, w, b])
    for i in range(len(a)):
        for j in range(len(w[0])):
            for k in range(len(a[0])):
                z[i, j] += a[i, k] * w[k, j] + b[j]
    return z, cache

def affine_backward(dz, cache):
    a = cache[0]
    w = cache[1]
    b = cache[2]

    da = np.zeros((len(dz), len(w)))
    for i in range(len(dz)):
        for k in range(len(w)):
            for j in range(len(dz[0])):
                da[i, k] += dz[i, j] * w[k, j]

    dw = np.zeros((len(a[0]), len(dz[0])))
    for k in range(len(a[0])):
        for j in range(len(dz[0])):
            for i in range(len(a)):
                dw[k, j] += a[i, k] * dz[i, j]

    db = np.zeros(len(dz[0]))
    for j in range(len(dz[0])):
        for i in range(len(dz)):
            db[j] += dz[i, j]

    return da, dw, db
#flnn - four layer neural network
def flnn(x, weights, biases, y, test):

    n = 0.1

    z1, acache1 = affine_forward(x, weights[0], biases[0])
    a1, rcache1 = relu_forward(z1)
    z2, acache2 = affine_forward(a1, weights[1], biases[1])
    a2, rcache2 = relu_forward(z2)
    z3, acache3 = affine_forward(a2, weights[2], biases[2])
    a3, rcache3 = relu_forward(z3)
    f, acache4 = affine_forward(a3, weights[3], biases[3])

    #if test == true:
        #classifications = argmax over all classes in logits for each example
        #return classifications

    loss, df = cross_entropy(f, y)
    da3, dw3, db3 = affine_backward(df, acache4)
    dz3 = relu_backward(da3, rcache3)
    da2, dw2, db2 = affine_backward(df, acache3)
    dz2 = relu_backward(da2, rcache2)
    da1, dw1, db1 = affine_backward(df, acache2)
    dz1 = relu_backward(da1, rcache1)
    dx, dw0, db0 = affine_backward(dz1, acache1)

    weights[0] -= n * dw0
    weights[1] -= n * dw1
    weights[2] -= n * dw2
    weights[3] -= n * dw3

    biases[0] -= n * db0
    biases[1] -= n * db1
    biases[2] -= n * db2
    biases[3] -= n * db3

    return loss

def minibatchGD(data, epoch):
    weights = np.random()
    biases = np.zeros((4, 256))
    for e in range(epoch):
