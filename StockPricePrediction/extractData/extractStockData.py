import requests
import csv
import numpy as np
from sklearn.svm import SVR

filename = 'stockData.csv'

def getData(company):
    url = 'http://www.google.com/finance/historical?q=NASDAQ%3A'+company+'&output=csv'
    r = requests.get(url, stream=True)
    if r.status_code != 400:
        with open(filename, 'wb') as f:
            for block in r:
                f.write(block)
        return True

dates = []
prices = []

def sortData():
    with open(filename, 'r') as csvF:
        csvFR = csv.reader(csvF)
        next(csvFR) # skip first row
        for row in csvFR:
            dates.append(int(row[0].split('-')[0]))
            prices.append(float(row[1])) # opening price

dates = np.reshape(dates,(len(dates),1))
