import pandas as pd
import numpy as np
from sklearn.naive_bayes import GaussianNB
from sklearn.model_selection import train_test_split

'''---'''
# Data Preprocessing
'''---'''

# Load data into data frames
df = pd.read_csv('PolicyLevel.csv', parse_dates=[1,2])
cl = pd.read_csv('ClaimLevel.csv', parse_dates=[1,2])

# Replace NaN dates to a legit date
df.CancelDate = np.where(df.CancelDate.notnull(),df.CancelDate.dt.strftime('%Y-%m-%d'),pd.to_datetime("2017-01-01").date())

# Convert to Data Frame
df['CancelDate'] = pd.to_datetime(df['CancelDate'])
# Count number of months between enroll data and cancel date/present date
df['months'] = ((df.CancelDate - df.EnrollDate)/ np.timedelta64(1, 'M')).astype(int)
# Calculate the total insurance paid
df['TotalPremium'] = df.MonthlyPremium * df.months
# Get the status of each policy
df['cancel'] = 0
pd.options.mode.chained_assignment = None

# Merge both the data sets and sort by Policy ID
merged = df.merge(cl, left_on='PolicyId', right_on='PolicyId', how='outer')
merged = merged.sort_values('PolicyId')

# Update the status of each Policy
for i in range(len(merged.CancelDate)):
    if merged.CancelDate[i] < merged.CancelDate[0]:
        merged.cancel[i] = 1

# Convert to the correct datatype (object to numeric) and replace NAs with 0s
merged['ClaimedAmount']=pd.to_numeric(merged.ClaimedAmount)
merged['ClaimedAmount'].fillna(0, inplace=True)
merged['PaidAmount'].fillna(0, inplace=True)
# Convert date to year: month format to get number of months easily
merged.ClaimDate = np.where(merged.ClaimDate.notnull(),
                      merged.ClaimDate.dt.strftime('%Y-%m'),
                      0)

# Group by Policy ID and evaluate Paid Amount, Claimed Amount, Number of Claims per month
clClaims = merged.groupby(['PolicyId','ClaimDate']).agg({'months':'first','cancel':'first','TotalPremium':'first','EnrollDate':'first','PolicyId':'first', 'ClaimedAmount':'sum','PaidAmount':'sum','PolicyId':'count'}).rename(columns={'PolicyId':'ClaimCount'}).reset_index()
# Get the number of months associated before claiming for insurance
clClaims['monthAsso'] = np.where(clClaims.ClaimDate!=0,((pd.to_datetime(clClaims.ClaimDate) - clClaims.EnrollDate)/ np.timedelta64(1, 'M')).astype(int),0)
for i in range(len(clClaims.monthAsso)):
    if clClaims.monthAsso[i] == 0:
        clClaims.ClaimCount[i] = 0

# Update the data frame by dropping duplicates
clClaimsNew = pd.merge(clClaims, merged['MonthlyPremium'].to_frame(), 'inner', left_on=clClaims['PolicyId'], right_on=merged['PolicyId'])
clClaimsNew = clClaimsNew.drop_duplicates(keep='first')
# Evaluate Premium paid until the claim date
clClaimsNew['PremiumUntil'] = clClaimsNew.monthAsso * clClaimsNew.MonthlyPremium
# Evaluate Value until the claim date
clClaimsNew['ValueUntil'] = 0
clClaimsNew = clClaimsNew.reset_index()
for i in range(len(clClaimsNew.PolicyId)):
    if i == 0:
        clClaimsNew.ValueUntil[i] = clClaimsNew.PremiumUntil[i] - clClaimsNew.PaidAmount[i]
    else:
        if clClaimsNew.PolicyId[i] != clClaimsNew.PolicyId[i-1]:
            clClaimsNew.ValueUntil[i] = clClaimsNew.PremiumUntil[i] - clClaimsNew.PaidAmount[i]
        else:
            clClaimsNew.ValueUntil[i] = clClaimsNew.ValueUntil[i-1] + clClaimsNew.MonthlyPremium[i] - clClaimsNew.PaidAmount[i]
# Evaluate Paid amount to Claimed amount ratio
clClaimsNew['PaidClaimedRatio'] = clClaimsNew.PaidAmount/clClaimsNew.ClaimedAmount
clClaimsNew['PaidClaimedRatio'].fillna(0, inplace=True)
clClaimsNew['EnrollDate'] = clClaimsNew['EnrollDate'].dt.strftime('%Y-%m')

status = clClaimsNew['cancel']
del clClaimsNew['cancel']

clClaimsNew['status']=status
PolicyId = clClaimsNew['PolicyId']

# Remove unrelated columns
y = clClaimsNew['status']
del clClaimsNew['status']
del clClaimsNew['ClaimDate']
del clClaimsNew['EnrollDate']
del clClaimsNew['PolicyId']
del clClaimsNew['index']


X = clClaimsNew
X = X.fillna(value=0)

'''---'''
# Training Data
'''---'''

# Create training and testing vars
sample_weight = np.random.RandomState(42).rand(y.shape[0])

X_train, X_test, y_train, y_test, sw_train, sw_test = train_test_split(X, y, sample_weight, test_size=0.2, random_state=42)
del X_test
del y_test

# Reorder Columns to match that of training data
clClaimsNew['status'] = y
clClaimsNew['PolicyId'] = PolicyId
X_test = clClaimsNew.where(clClaimsNew.status == 0)
X_test = X_test.groupby(['PolicyId']).agg({'TotalPremium':'first','ClaimedAmount':'sum','months':'first','PaidAmount':'sum','ClaimCount':'sum','monthAsso':'last','MonthlyPremium':'first','PremiumUntil':'last','ValueUntil':'last'}).reset_index()
X_test['PaidClaimedRatio'] = X_test['PaidAmount']/X_test['ClaimedAmount']
PolicyId = X_test['PolicyId']
# Taking the test data as Policy Ids which haven't been cancelled yet
X_test = X_test[['TotalPremium', 'ClaimedAmount', 'months','PaidAmount','ClaimCount','monthAsso','MonthlyPremium','PremiumUntil','ValueUntil','PaidClaimedRatio']]
X_test = X_test.fillna(value=0)

# Convert Policy ID to matrix
PolicyId = PolicyId.reset_index()
del PolicyId['index']
PolicyId = PolicyId.as_matrix()
PolicyId = PolicyId.astype(int)

# fit a gaussian naive bayes model
clf = GaussianNB()
model = clf.fit(X_train, y_train)
# Class predictions for test data
predictions = clf.predict(X_test)
# Probability predictions
prob_pos_clf = clf.predict_proba(X_test)[:, 1]
prob_pos_clf = prob_pos_clf.reshape(PolicyId.shape)

'''---'''
# Output
'''---'''
# Save the results to a csv file along with Policy ID
output = np.hstack((PolicyId, prob_pos_clf))
np.savetxt("probabililities.csv", output, delimiter=",")