# python3 plot_heatmap.py input_file N X Y

# Imports
import matplotlib.pyplot as plt
import numpy as np
import sys
import seaborn as sns

# ~ uniform_data = np.random.rand(10, 12)
# ~ ax = sns.heatmap(uniform_data, linewidth=0.5)
# ~ min_value = 
a = []
i = 0
temp = []
N = int(sys.argv[2])
PAS = int(sys.argv[5])
type_plot = sys.argv[6]
with open(sys.argv[1]) as f:
	line = f.readline()
	min_value = float(line)
	min_x = 0
	min_y = 0
	current_x = 0
	current_y = 0
	while line:
		
		i += 1
		
		temp.append(float(line))
		
		if min_value > float(line):
			min_value = float(line)
			min_x = current_x
			min_y = current_y
			print("New min", min_value, min_x, min_y)
			
		if i%N == 0:
			a.append(temp)
			temp = []
			current_y += 1
			current_x = 0
		else:
			current_x += 1
		
		line = f.readline()
f.close()

print(a)

cmap = sns.cm.rocket_r

# ~ num_ticks = N
# ~ # the index of the position of yticks
# ~ yticks = np.linspace(0, len(depth_list) - 1, num_ticks, dtype=np.int)
# ~ # the content of labels of these yticks
# ~ yticklabels = [depth_list[idx] for idx in yticks]

if (type_plot == "Max_Flow" or type_plot == "Total_Flow"):
	ax = sns.heatmap(a,
					 annot=True, # Pour écrire les valuers
					 cmap = cmap)
else:
	ax = sns.heatmap(a,
					 annot=True, # Pour écrire les valuers
					 fmt = '.3f',
					 cmap = cmap)
                 
# ~ ax.set_yticks(yticks)

ax.add_patch(plt.Rectangle((min_x, min_y), 1, 1, fc='none', ec='gold', lw=5, clip_on=False))

short_cols = []
index = 0
for i in range(0, N):
	index = PAS*i
	short_cols.append(index)
	# ~ index = PAS*i
ax.set_xticklabels(short_cols)
ax.set_yticklabels(short_cols)

plt.xticks()
plt.yticks()
plt.title(type_plot)
plt.ylabel(sys.argv[3])
plt.xlabel(sys.argv[4])
# ~ plt.legend()
plt.savefig("plot.pdf")


