# python3 src/plot_boxplot.py intput_file

# Import libraries
import matplotlib.pyplot as plt
import numpy as np
import sys
import pandas as pd

date1 = sys.argv[1]
date2 = sys.argv[2]
mode = sys.argv[3]

if (mode == "NO_BF"):
	file_to_open_eft = "data/Stretch_improvement_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_x1_x0_x0_x0.txt"
	file_to_open_lea = "data/Stretch_improvement_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_x500_x1_x0_x0.txt"
	file_to_open_leo = "data/Stretch_improvement_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_x500_x1_x0_x0.txt"
	file_to_open_lem = "data/Stretch_improvement_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_mixed_strategy_x500_x1_x0_x0.txt"
elif (mode == "BF"):
	file_to_open_eft = "data/Stretch_improvement_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_conservativebf_x1_x0_x0_x0.txt"
	file_to_open_lea = "data/Stretch_improvement_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_conservativebf_x500_x1_x0_x0.txt"
	file_to_open_leo = "data/Stretch_improvement_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_conservativebf_x500_x1_x0_x0.txt"
	file_to_open_lem = "data/Stretch_improvement_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_mixed_strategy_conservativebf_x500_x1_x0_x0.txt"
elif (mode == "NO_BF_TRANSFER"):
	file_to_open_eft = "data/Stretch_improvement_if_transfer_reduction_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_conservativebf_x1_x0_x0_x0.txt"
	file_to_open_lea = "data/Stretch_improvement_if_transfer_reduction_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_conservativebf_x500_x1_x0_x0.txt"
	file_to_open_leo = "data/Stretch_improvement_if_transfer_reduction_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_conservativebf_x500_x1_x0_x0.txt"
	file_to_open_lem = "data/Stretch_improvement_if_transfer_reduction_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_mixed_strategy_conservativebf_x500_x1_x0_x0.txt"

if (mode == "NO_BF_TRANSFER"):
	with open(file_to_open_eft, 'r') as fp:
		for count, line in enumerate(fp):
			pass
	print('Total Lines', count + 1)
	line_eft = count+1
	fp.close()
	with open(file_to_open_lea, 'r') as fp:
		for count, line in enumerate(fp):
			pass
	print('Total Lines', count + 1)
	line_lea = count+1
	fp.close()
	with open(file_to_open_leo, 'r') as fp:
		for count, line in enumerate(fp):
			pass
	print('Total Lines', count + 1)
	line_leo = count+1
	fp.close()
	with open(file_to_open_lem, 'r') as fp:
		for count, line in enumerate(fp):
			pass
	print('Total Lines', count + 1)
	line_lem = count+1
	fp.close()
else:
	with open(file_to_open_eft, 'r') as fp:
		for count, line in enumerate(fp):
			pass
	print('Total Lines', count + 1)
	fp.close()

df_eft = pd.read_csv(file_to_open_eft)
df_lea = pd.read_csv(file_to_open_lea)
df_leo = pd.read_csv(file_to_open_leo)
df_lem = pd.read_csv(file_to_open_lem)

font_size = 14

eft = list(df_eft.iloc[:, 0])
score = list(df_lea.iloc[:, 0])
opportunistic = list(df_leo.iloc[:, 0])
eft_score = list(df_lem.iloc[:, 0])
# ~ print(eft)
columns = [eft, score, opportunistic, eft_score]
# ~ columns = [eft, score, eft_score]
colors=["#E50000","#00bfff","#ff9b15","#91a3b0"]
# ~ colors=["#E50000","#00bfff","#91a3b0"]
fig, ax = plt.subplots()


# ~ size_extremity = 25 # Quartile
size_extremity = 12.5 # Octile
# ~ size_extremity = 6.25 # 16-tile
# ~ size_extremity = 3.125 # 32-tile
# ~ size_extremity = 1 # Percentile

# ~ box = plt.boxplot(columns, patch_artist=True, meanline=True, showmeans=True, whis=[size_extremity, 100 - size_extremity])
# ~ box = plt.boxplot(columns, patch_artist=True, whis=[size_extremity, 100 - size_extremity], showfliers=False)

box = plt.violinplot(columns, showmedians=True, showmeans=True, quantiles=[0.25,0.75])


c="#095228"

# ~ for boxes in box['boxes']:
	# ~ if (mode == "BF"):
		# ~ boxes.set(hatch = '/', color="white")
		
# ~ for median in box['medians']:
    # ~ median.set_color(c)
    # ~ median.set_linewidth(1.9)
# ~ for mean in box['means']:
    # ~ mean.set_color(c)
    # ~ mean.set_linewidth(1.9)



if (mode == "NO_BF"):
	plt.xticks([1, 2, 3, 4], ["EFT", "LEA", "LEO", "LEM"], fontsize=font_size)
	# ~ plt.xticks([1, 2, 3], ["EFT", "LEA", "LEM"], fontsize=font_size)
elif (mode == "BF"):
	plt.xticks([1, 2, 3, 4], ["EFT-BF", "LEA-BF", "LEO-BF", "LEM-BF"], fontsize=font_size)
elif (mode == "NO_BF_TRANSFER"):
	plt.xticks([1, 2, 3, 4], ["EFT-" + str(line_eft), "LEA-" + str(line_lea), "LEO-" + str(line_leo), "LEM-" + str(line_lem)], fontsize=font_size)
	
plt.axhline(y = 1, color = 'black', linestyle = "dotted", linewidth=4)


# Max Y
# ~ plt.ylim(0.95, 1.05)
plt.ylim(0, 2)
# ~ plt.ylim(0, 10)

plt.yticks(fontsize=font_size)
plt.rcParams['hatch.linewidth'] = 9

# ~ if (mode == "BF"):
	# ~ for patch, color in zip(box['boxes'], colors):
		# ~ patch.set_facecolor("white")
		# ~ patch.set_edgecolor(color)
# ~ else:
	# ~ for patch, color in zip(box['boxes'], colors):
		# ~ patch.set_facecolor(color)
		

if (mode == "NO_BF"):
	filename = "plot/Boxplot/box_plot_" + str(count + 1) + "_" + date1 + "-" + date2 + ".pdf"
	plt.ylabel('Stretch\'s improvement from FCFS', fontsize=font_size)
elif (mode == "NO_BF"):
	filename = "plot/Boxplot/box_plot_bf_" + str(count + 1) + "_" + date1 + "-" + date2 + ".pdf"
	plt.ylabel('Stretch\'s improvement from FCFS-BF', fontsize=font_size)
elif (mode == "NO_BF_TRANSFER"):
	filename = "plot/Boxplot/box_plot_transfer_" + date1 + "-" + date2 + ".pdf"
	plt.ylabel('Stretch\'s improvement from FCFS-BF', fontsize=font_size)


plt.savefig(filename, bbox_inches='tight')
