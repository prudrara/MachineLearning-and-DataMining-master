Download the data set in KNNdata.mat. This MATLAB file contain three variables:
X, Y , and Xtest. X is 1,200 objects, each defined by 8 features. Y is the label of
each X (there are 3 classes). Xtest is 240 test vectors for which you do NOT have the
label (I have the label, but will not release it to you).
Part 1) Build a k-nearest neighbor (KNN) classifier that uses the leave-one-out cross
validation approach to determine best value for k. Your submission should be in the
form of a MATLAB function with the following inputs / outputs (I/O):
• [prediction, bestk, errors] = myKNN(X, Y, Xtest, k)
• X is [N × d] matrix of training data
• Y is [N × 1] vector of training labels
• Xtest is [N test × d] matrix of test data
• k is a [N k × 1] vector of candidate k values
• prediction is a [N test × 1] vector of label predictions for Xtest
• bestk is the value k chosen by the leave-one-out cross validation
• errors is a [N k × 1] vector of the number of errors found at each k in the
cross-validation
Part 2) Build a weighted KNN classifier, including a method for determining the best
λ parameter in the weighting function (use the weighting function described in the
class notes). Your submission should be in the form of a MATLAB function with the
following I/O:
• [prediction, bestlambda] = myWKNN(X, Y, Xtest)
• Inputs and outputs are the same as the myKNN function
