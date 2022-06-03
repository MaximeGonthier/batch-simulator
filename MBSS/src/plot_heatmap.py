# python3 plot_heatmap.py input_file date N

# Imports
import matplotlib.pyplot as plt
import numpy as np
import sys
import seaborn as sns

# ~ uniform_data = np.random.rand(10, 12)
# ~ ax = sns.heatmap(uniform_data, linewidth=0.5)

a = []
i = 0
temp = []
N = int(sys.argv[3])
with open(sys.argv[1]) as f:
	line = f.readline()
	while line:
		
		i += 1
		
		temp.append(float(line))
		
		if i%N == 0:
			a.append(temp)
			temp = []
		
		line = f.readline()
f.close()

print(a)

# ~ plt.imshow(a, cmap='hot', interpolation='nearest')
ax = sns.heatmap(a, linewidth=0.5)

plt.xticks(range(N))
plt.yticks(range(N))
plt.title("Flow stretch ratio")
plt.ylabel(sys.argv[5])
plt.xlabel(sys.argv[4])
# ~ plt.legend()
plt.savefig("plot.pdf")


