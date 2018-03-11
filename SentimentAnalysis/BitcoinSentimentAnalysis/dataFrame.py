# create dataframe from text files
import glob
import pandas as pd
import os
import matplotlib.pyplot as plt
import seaborn.apionly as sns

#path = r'/home/prithvi/git_work/GetOldTweets-python'
path = os.getcwd()
allFiles = glob.glob(path + "/bitcoinTweets_*.txt")
frame = pd.DataFrame()

list_ = []
for i,file_ in enumerate(allFiles):
    df = pd.read_csv(file_, sep = '::', engine = 'python', header=None)
    df['month'] = i+16
    list_.append(df)
frame = pd.concat(list_)
frame.columns=['tweets','sentiment','date']
#print frame


frame['sentiment']=frame['sentiment'].astype('category')
sns.set()


plt.figure()

sns.countplot(x='sentiment',hue='date',data=frame,palette="Greens_d")
#grouped = frame.groupby('month')
'''
for name,group in grouped:
    print name
    print group
    group.hist(by='month', column='fare')
'''
#frame.hist(by='month', column='sentiment')
plt.show()
#frame.sentiment.groupby('month').value_counts().plot.bar(stacked=True)
#plt.show()
