import matplotlib.pyplot as plt
import matplotlib
import pandas as pd
import numpy as np
import sys

nb_sample = 41

data = pd.read_csv(sys.argv[1])
df = pd.DataFrame(data)
if sys.argv[2] == "EFT" or sys.argv[2] == "EFT-CONSERVATIVE-BF":
	y_index = 0
	scheduler = "EFT"
elif sys.argv[2] == "SCORE" or sys.argv[2] == "SCORE-CONSERVATIVE-BF":
	y_index = 1
	scheduler = "SCORE"
elif sys.argv[2] == "OPPORTUNISTIC-SCORE-MIX" or sys.argv[2] == "OPPORTUNISTIC-SCORE-MIX-CONSERVATIVE-BF":
	y_index = 2
	scheduler = "OPPORTUNISTIC-SCORE MIX"
elif sys.argv[2] == "EFT-SCORE-MIX" or sys.argv[2] == "EFT-SCORE-MIX-CONSERVATIVE-BF":
	y_index = 3
	scheduler = "EFT-SCORE MIX"
	y_index_eft = 0
	y_index_score = 1
	y_index_opportunistic = 2
else:
	print("Error name of scheduler when calling scatter_plot.py")
	exit

x = [0] * nb_sample

for i in range (1, nb_sample + 1):
	x[i - 1] = i

y = list(df.iloc[:, y_index])
print("y: ", y)
plt.axhline(y = 1, color = 'black', linestyle = "dotted", linewidth = 4)

# scatter de base
# ~ y = sorted(y)
# ~ plt.scatter(x, y, s = 100, c = "blue")

# scatter avec log scale
# ~ y = sorted(y)
# ~ fig1, ax1 = plt.subplots()
# ~ ax1.axhline(y = 1, color = 'black', linestyle = "dotted", linewidth = 4)
# ~ ax1.scatter(x, y, s = 100, c = "blue")
# ~ ax1.set_yscale('log')
# ~ ax1.set_yticks([1, 2, 3, 4, 5, 6, 7])
# ~ ax1.get_yaxis().set_major_formatter(matplotlib.ticker.ScalarFormatter())

# scatter avec couleurs sur 1
num_colors = 2
cmap = matplotlib.colors.LinearSegmentedColormap.from_list("", ["green", "green"])
cmap.set_under('red')
y = sorted(y)
plt.scatter(x, y, c=y, cmap=cmap, vmin=1)

# barplot de différntes stratégies en 1 seul plot
# ~ y_eft = list(df.iloc[:, y_index_eft])
# ~ y_score = list(df.iloc[:, y_index_score])
# ~ y_opportunistic = list(df.iloc[:, y_index_opportunistic])
# ~ print(y_eft)
# ~ print(y_score)
# ~ print(y_opportunistic)
# ~ y_eft_sorted = [x_sort for _,x_sort in sorted(zip(y,y_eft))]
# ~ y_score_sorted = [x_sort for _,x_sort in sorted(zip(y,y_score))]
# ~ y_opportunistic_sorted = [x_sort for _,x_sort in sorted(zip(y,y_opportunistic))]
# ~ y = sorted(list(df.iloc[:, y_index]))
# ~ print("y sorted:", y)
# ~ print("y eft sorted:", y_eft_sorted)
# ~ print("y score sorted:", y_score_sorted)
# ~ print("y opportunistic sorted:", y_opportunistic_sorted)
# ~ barWidth = 0.2
# ~ r1 = range(len(y))
# ~ r2 = [x + barWidth for x in r1]
# ~ r3 = [x + barWidth*2 for x in r1]
# ~ r4 = [x + barWidth*3 for x in r1]
# ~ plt.bar(r1, y, width = barWidth, color = ['red' for i in y], linewidth = 2, label="EFT-SCORE MIX")
# ~ plt.bar(r2, y_eft, width = barWidth, color = ['blue' for i in y], linewidth = 2, label="EFT")
# ~ plt.bar(r3, y_score, width = barWidth, color = ['green' for i in y], linewidth = 2, label="SCORE")
# ~ plt.bar(r4, y_opportunistic, width = barWidth, color = ['orange' for i in y], linewidth = 2, label="OPPORTUNISTIC-SCORE MIX")
# ~ plt.ylim(top = 5)
# ~ plt.legend()

if sys.argv[1] == "outputs/scatter_mean_stretch_all_workloads.csv":
	filename = "plot/Scatter/scatter_mean_stretch_all_workloads_" + sys.argv[2] + ".pdf"
	plt.title(scheduler)
else:
	filename = "plot/Scatter/scatter_mean_stretch_all_workloads_bf_" + sys.argv[2] + ".pdf"
	plt.title(scheduler + " CONSERVATIVE BF")

plt.xlabel('Sample days sorted by increasing stretch')
plt.ylabel('Stretch\'s speed-up')
plt.savefig(filename)
