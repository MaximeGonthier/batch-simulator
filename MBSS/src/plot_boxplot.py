# python3 src/plot_boxplot.py intput_file

# Import libraries
import matplotlib.pyplot as plt
import numpy as np
import sys
import pandas as pd

df = pd.read_csv(sys.argv[1])
print("Opening file", sys.argv[1])

eft = list(df.iloc[:, 0])
score = list(df.iloc[:, 1])
opportunistic = list(df.iloc[:, 2])
eft_score = list(df.iloc[:, 3])

# ~ print(eft_score)

columns = [eft, score, opportunistic, eft_score]
colors=["#E50000","#00bfff","#ff9b15","#91a3b0"]
fig, ax = plt.subplots()

# ~ print(columns)

# Octile
box = ax.boxplot(columns, patch_artist=True, meanline=True, showmeans=True, whis=[12.5, 87.5])

# Idk what-ile
# ~ box = ax.boxplot(columns, patch_artist=True, meanline=True, showmeans=True, whis=[15, 85])

# Quartile
# ~ box = ax.boxplot(columns, patch_artist=True, meanline=True, showmeans=True, whis=[25, 75])

c="#095228"

for boxes in box['boxes']:
	if sys.argv[1] != "outputs/scatter_mean_stretch_all_workloads.csv":
		boxes.set(color='white', linewidth=1)
		boxes.set_hatch('/')
for median in box['medians']:
    # ~ median.set_color('green')
    median.set_color(c)
    median.set_linewidth(1.9)
    # ~ print(median)
for mean in box['means']:
    # ~ mean.set_color('green')
    mean.set_color(c)
    mean.set_linewidth(1.9)
    # ~ print(mean)

# ~ print(median)
# ~ print(mean)

if sys.argv[1] == "outputs/scatter_mean_stretch_all_workloads.csv":
	plt.xticks([1, 2, 3, 4], ["EFT", "LEA", "LEO", "LEM"])
else:
	plt.xticks([1, 2, 3, 4], ["EFT-BF", "LEA-BF", "LEO-BF", "LEM-BF"])
	
plt.axhline(y = 1, color = 'black', linestyle = "dotted")

# Max Y
# ~ ax.set_ylim(0, 2.5)
ax.set_ylim(0, 3.15)

plt.rcParams['hatch.linewidth'] = 5
for patch, color in zip(box['boxes'], colors):
    patch.set_facecolor(color)
    
if sys.argv[1] == "outputs/scatter_mean_stretch_all_workloads.csv":
	filename = "plot/Boxplot/box_plot_mean_stretch_all_workloads.pdf"
	plt.ylabel('Stretch\'s speed-up from FCFS')
else:
	filename = "plot/Boxplot/box_plot_mean_stretch_all_workloads_bf.pdf"
	plt.ylabel('Stretch\'s speed-up from FCFS-BF')
# ~ plt.legend(loc ="upper left")
plt.savefig(filename)
