import csv
import numpy as np
from sklearn import datasets, linear_model
from sklearn.metrics import mean_squared_error, r2_score

reader = csv.reader(open("slump_test.csv", "rb"), delimiter=",")
x = list(reader)
data = np.array(x).astype("float")

# alternative
# numpy.loadtxt(open("test.csv", "rb"), delimiter=",", skiprows=1)

noutputs = 3

nr, nc = data.shape
train = data[0:np.int(4*nr/5),:]
test = data[np.int(4*nr/5)+1:,:]

trainX = train[:,0:nc-noutputs-1]
trainY = train[:,nc-noutputs:]
testX = test[:,0:nc-noutputs-1]
testY = test[:,nc-noutputs:]

# Create linear regression object
regr = linear_model.LinearRegression()

# Train the model using the training sets
regr.fit(trainX, trainY)

# Make predictions using the testing set
pred = regr.predict(testX)

# The coefficients
#print('Coefficients: \n', regr.coef_)
# The mean squared error
print("Mean squared error: %.2f"
      % mean_squared_error(testY, pred))
# Explained variance score: 1 is perfect prediction
#print('Variance score: %.2f' % r2_score(testY, pred))
