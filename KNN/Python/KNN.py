# KNN in python
import scipy.io as sio
import numpy as np
from sklearn.metrics import accuracy_score

mat_contents = sio.loadmat('KNNdata.mat')
Xtrain = mat_contents['Xtrain']
Xtest = mat_contents['Xtest']
Ytrain = mat_contents['Ytrain']

from sklearn.model_selection import train_test_split, cross_val_score

# split into train and test
X_train, X_test, y_train, y_test = train_test_split(Xtrain, Ytrain, test_size=0.2, random_state=42)


from sklearn.neighbors import KNeighborsClassifier


# creating odd list of K for KNN
myList = list(range(1,50))

# subsetting just the odd ones
neighbors = filter(lambda x: x % 2 != 0, myList)

# empty list that will hold cv scores
cv_scores = []

# perform 10-fold cross validation
for k in neighbors:
    knn = KNeighborsClassifier(n_neighbors=k)
    scores = cross_val_score(knn, X_train, y_train.ravel(), cv=30, scoring='accuracy')
    cv_scores.append(scores.mean())
print cv_scores
# changing to misclassification error
MSE = [1 - x for x in cv_scores]

# determining best k
optimal_k = neighbors[MSE.index(min(MSE))]
print "The optimal number of neighbors is %d" % optimal_k

# instantiate learning model
knn = KNeighborsClassifier(n_neighbors=optimal_k)

# fitting the model
knn.fit(Xtrain, Ytrain.ravel())

# predict the response
pred = knn.predict(Xtest)
print pred