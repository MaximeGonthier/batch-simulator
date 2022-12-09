# python3 src/plot_boxplot.py intput_file

# Import libraries
import matplotlib.pyplot as plt
import numpy as np
import sys
import pandas as pd

df = pd.read_csv(sys.argv[1])
print("Opening file", sys.argv[1])

font_size = 14

eft = list(df.iloc[:, 0])
score = list(df.iloc[:, 1])
opportunistic = list(df.iloc[:, 2])
eft_score = list(df.iloc[:, 3])

# ~ print("LEA:", score)
# ~ print("LEO:", opportunistic)
# ~ print("LEM:", eft_score)

columns = [eft, score, opportunistic, eft_score]
colors=["#E50000","#00bfff","#ff9b15","#91a3b0"]
fig, ax = plt.subplots()

# ~ print(columns)
# ~ plt.figure(figsize=(6, 4))
# Octile
# ~ box = ax.boxplot(columns, patch_artist=True, meanline=True, showmeans=True, whis=[12.5, 87.5])
box = plt.boxplot(columns, patch_artist=True, meanline=True, showmeans=True, whis=[12.5, 87.5])

# Idk what-ile
# ~ box = ax.boxplot(columns, patch_artist=True, meanline=True, showmeans=True, whis=[15, 85])

# Quartile
# ~ box = ax.boxplot(columns, patch_artist=True, meanline=True, showmeans=True, whis=[25, 75])

c="#095228"

# ~ plt.rcParams['hatch.color'] = "white"

for boxes in box['boxes']:
	if sys.argv[1] != "outputs/scatter_mean_stretch_all_workloads.csv":
		# ~ boxes.set(color='white', linewidth=1)
		# ~ boxes.set_edgecolor(color="black")
		# ~ boxes.set_hatch('/')
		
		# ~ boxes.set(color='black', linewidth=2)
		# change fill color
		# ~ boxes.set(facecolor = 'green')
		# change hatch
		# ~ boxes.set(hatch = '/', color='white')
		boxes.set(hatch = '/', color="white")
		# ~ boxes.set(edgecolor = 'black')
		# ~ boxes.set(hatch = '/', color='white')
		# ~ boxes.set(color='blue', linewidth=2)
	# ~ else:
		# ~ boxes.set_edgecolor(color="black")
		
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


print([item.get_ydata()[1] for item in box['whiskers']])
# ~ print([item.get_ydata()[1] for item in box['boxes']])
# ~ print(box['boxes'][0].get_ydata()[1])
# ~ print(median)
# ~ print(mean)



if sys.argv[1] == "outputs/scatter_mean_stretch_all_workloads.csv":
	plt.xticks([1, 2, 3, 4], ["EFT", "LEA", "LEO", "LEM"], fontsize=font_size)
else:
	plt.xticks([1, 2, 3, 4], ["EFT-BF", "LEA-BF", "LEO-BF", "LEM-BF"], fontsize=font_size)
	
plt.axhline(y = 1, color = 'black', linestyle = "dotted", linewidth=4)


# ~ plt.axhline(y = 1.35, color = 'black')
# ~ plt.axhline(y = 0.85, color = 'black')

# Max Y
# ~ ax.set_ylim(0, 2.5)
# ~ ax.set_ylim(0, 3.15)
plt.ylim(0, 3.15)
plt.yticks(fontsize=font_size)

plt.rcParams['hatch.linewidth'] = 9

if sys.argv[1] != "outputs/scatter_mean_stretch_all_workloads.csv":
	for patch, color in zip(box['boxes'], colors):
		patch.set_facecolor("white")
		patch.set_edgecolor(color)
else:
	for patch, color in zip(box['boxes'], colors):
		patch.set_facecolor(color)
		# ~ patch.set_edgecolor(color)
		
if sys.argv[1] == "outputs/scatter_mean_stretch_all_workloads.csv":
	filename = "plot/Boxplot/box_plot_mean_stretch_all_workloads.pdf"
	plt.ylabel('Stretch\'s improvement from FCFS', fontsize=font_size)
else:
	filename = "plot/Boxplot/box_plot_mean_stretch_all_workloads_bf.pdf"
	plt.ylabel('Stretch\'s improvement from FCFS-BF', fontsize=font_size)
# ~ plt.legend(loc ="upper left")

# ~ fig.subplots_adjust(left=0, bottom=-1, right=1, top=1, wspace=0, hspace=0)
# ~ fig.subplots_adjust(hspace=0, wspace=0)

plt.savefig(filename, bbox_inches='tight')

