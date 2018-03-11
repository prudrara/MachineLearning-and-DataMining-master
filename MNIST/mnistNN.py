import random
import numpy as np
from numpy import genfromtxt

# New class style (since python 2.2)
# https://stackoverflow.com/questions/54867/what-is-the-difference-between-old-style-and-new-style-classes-in-python

class NeuralNet(object):
    def __init__(self, layer_sizes):
        self.num_layers = len(layer_sizes)
        self.layer_sizes = layer_sizes
        self.biases = [np.random.randn(y,1) for y in layer_sizes[1:]]
        self.weights = [np.random.randn(y,x) for x,y in zip(layer_sizes[:-1],layer_sizes[1:])]

    def feedForward(self, out):
        for b,w in zip(self.biases, self.weights):
            out = sigmoid(np.dot(w,out) + b)
        return out

    def stocGradDesc(self, training_data, epochs, mini_batch_size, eta, testing_data=None):
        if testing_data: n_test = len(testing_data)
        n = len(training_data)
        for j in xrange(epochs):
            #random.shuffle(training_data)
            mini_batches = [training_data[k:k+mini_batch_size] for k in xrange(0,n,mini_batch_size)]
            for mini_batch in mini_batches:
                self.update_mini_batch(mini_batch,eta)
            if testing_data: 
                print "Epoch {0}: {1} / {2}".format(j, self.evaluate(testing_data), n_test)
            else:
                print "Epoch {0} complete".format(j)

    def update_mini_batch(self, mini_batch, eta):
        nabla_b = [np.zeros(b.shape) for b in self.biases]
        nabla_w = [np.zeros(w.shape) for w in self.weights]
        for x, y in mini_batch:
            delta_nabla_b, delta_nabla_w = self.backprop(x, y)
            nabla_b = [nb+dnb for nb, dnb in zip(nabla_b, delta_nabla_b)]
            nabla_w = [nw+dnw for nw, dnw in zip(nabla_w, delta_nabla_w)]
        self.weights = [w-(eta/len(mini_batch))*nw
                        for w, nw in zip(self.weights, nabla_w)]
        self.biases = [b-(eta/len(mini_batch))*nb
                       for b, nb in zip(self.biases, nabla_b)]

    def backprop(self, x, y):
        nabla_b = [np.zeros(b.shape) for b in self.biases]
        nabla_w = [np.zeros(w.shape) for w in self.weights]
        # feedforward
        activation = x
        activations = [x] # list to store all the activations, layer by layer
        zs = [] # list to store all the z vectors, layer by layer
        for b, w in zip(self.biases, self.weights):
            z = np.dot(w, activation)+b
            zs.append(z)
            activation = sigmoid(z)
            activations.append(activation)
        # backward pass
        delta = self.cost_derivative(activations[-1], y)*sigmoidDerivative(zs[-1])
        nabla_b[-1] = delta
        nabla_w[-1] = np.dot(delta, activations[-2].transpose())
        for l in xrange(2, self.num_layers):
            z = zs[-l]
            sp = sigmoidDerivative(z)
            delta = np.dot(self.weights[-l+1].transpose(), delta) * sp
            nabla_b[-l] = delta
            nabla_w[-l] = np.dot(delta, activations[-l-1].transpose())
        return (nabla_b, nabla_w)

    def evaluate(self, testing_data):
        test_results = [(np.argmax(self.feedForward(x)), y)
                        for (x, y) in testing_data]
        return sum(int(x == y) for (x, y) in test_results)

    def cost_derivative(self, output_activations, y):
        return (output_activations-y)

def getInt(arr):
    b = [int(i) for j in arr for i in j]
    o = 0
    for bit in b:
        o = (o << 1) | bit
    return o

    # TypeError: 'NoneType' object is not iterable
    # This error arises when no brackets are specified around the return variables.
    # This is because the output is expected to be a tuple but we wonr be returning a tuple if no brackets.

def sigmoid(z):
    return 1.0/(1.0 + np.exp(-z))

def sigmoidDerivative(z):
    return sigmoid(z)*(1-sigmoid(z))





