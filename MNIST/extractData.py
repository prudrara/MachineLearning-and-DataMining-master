#original code form http://pjreddie.com/projects/mnist-in-csv/

import os

def convert(inputFile, outputFile, n, b):
    # b: number of bits
    # n: number of rows 
    f = open(inputFile, "rb")
    o = open(outputFile, "w")
    
    f.read(b)

    data = []
    if b == 16:
        for i in range(n):
            row = []
            for j in range(28*28):
                row.append(ord(f.read(1)))
            data.append(row)

    elif b == 8:
        for i in range(n):
            row = list('{0:010b}'.format(ord(f.read(1))))
            data.append(row)
        
    for row in data:
        o.write(",".join(str(cell) for cell in row)+"\n")
    f.close()
    o.close()

path= os.getcwd()
head,tail= os.path.split(path)
path= head

convert(os.path.join(os.path.join(path,"MNIST"),"train-images-idx3-ubyte"), "mnist_train_data.csv", 60000, 16)
convert(os.path.join(os.path.join(path,"MNIST"),"train-labels-idx1-ubyte"), "mnist_train_labels.csv", 60000, 8)
convert(os.path.join(os.path.join(path,"MNIST"),"t10k-images-idx3-ubyte"), "mnist_test_data.csv", 10000, 16)
convert(os.path.join(os.path.join(path,"MNIST"),"t10k-labels-idx1-ubyte"), "mnist_test_labels.csv", 10000, 8)
