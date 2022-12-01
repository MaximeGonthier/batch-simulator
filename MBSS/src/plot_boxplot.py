# python3 src/plot_boxplot.py intput_file

# Import libraries
import matplotlib.pyplot as plt
import numpy as np
import sys
import pandas as pd

# ~ max_to_show = 4

df = pd.read_csv(sys.argv[1])
print("Opening file", sys.argv[1])

eft = list(df.iloc[:, 0])
score = list(df.iloc[:, 1])
opportunistic = list(df.iloc[:, 2])
eft_score = list(df.iloc[:, 3])

# ~ to_remove = []
# ~ for i in eft:
	# ~ if i > max_to_show:
		# ~ print("To remove", i)
		# ~ to_remove.append(i)
# ~ for i in to_remove:
	# ~ eft.remove(i)
	
# ~ to_remove = []
# ~ for i in score:
	# ~ if i > max_to_show:
		# ~ print("To remove", i)
		# ~ to_remove.append(i)
# ~ for i in to_remove:
	# ~ score.remove(i)
	
# ~ to_remove = []
# ~ for i in opportunistic:
	# ~ if i > max_to_show:
		# ~ print("To remove", i)
		# ~ to_remove.append(i)
# ~ for i in to_remove:
	# ~ opportunistic.remove(i)
	
# ~ to_remove = []
# ~ for i in eft_score:
	# ~ if i > max_to_show:
		# ~ print("To remove", i)
		# ~ to_remove.append(i)
# ~ for i in to_remove:
	# ~ eft_score.remove(i)

columns = [eft, score, opportunistic, eft_score]

fig, ax = plt.subplots()
# ~ box = ax.boxplot(columns, patch_artist=True, meanline=True, showmeans=True, whis=[0,100])
box = ax.boxplot(columns, patch_artist=True, meanline=True, showmeans=True, whis=1.5)
plt.xticks([1, 2, 3, 4], ["EFT", "SCORE", "OPPORTUNISTIC-SCORE MIX", "EFT-SCORE MIX"], rotation=8)
plt.axhline(y = 1, color = 'black', linestyle = "dotted")
ax.set_ylim(0, 2.5)
colors = ["#E50000","#00bfff","#ff9b15","#91a3b0"])
for patch, color in zip(box['boxes'], colors):
    patch.set_facecolor(color)
    
if sys.argv[1] == "outputs/scatter_mean_stretch_all_workloads.csv":
	filename = "plot/Boxplot/box_plot_mean_stretch_all_workloads.pdf"
else:
	filename = "plot/Boxplot/box_plot_mean_stretch_all_workloads_bf.pdf"

# ~ plt.xlabel('Sample days sorted by increasing stretch')
plt.ylabel('Stretch\'s speed-up')
plt.savefig(filename)
