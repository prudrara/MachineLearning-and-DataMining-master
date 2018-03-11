import matplotlib as mpl
import numpy as np
import matplotlib.pyplot as plt

data = np.genfromtxt('bitcoin.csv', delimiter=' ', names=['x1', 'x2'])


fig, ax1 = plt.subplots()
t = np.arange(1, 55, 1)
s1 = data['x1']
ax1.plot(t, s1, 'b-')
ax1.set_xlabel('time (s)')
# Make the y-axis label, ticks and tick labels match the line color.
ax1.set_ylabel('popularity', color='b')
ax1.tick_params('y', colors='b')

ax2 = ax1.twinx()
s2 = data['x2']
ax2.plot(t, s2, 'r-')
ax2.set_ylabel('price', color='r')
ax2.tick_params('y', colors='r')

fig.tight_layout()
plt.show()