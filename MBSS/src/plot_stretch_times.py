# python3 plot_stretch_times.py date1 date2 algo axex(cores ...)

# Imports
import matplotlib.pyplot as plt
import numpy as np
import sys
import operator
from dataclasses import dataclass
from matplotlib.lines import Line2D
from math import *

@dataclass
class Job:
    unique_id: int
    time: float # stretch improvement
    size: int # durée
    subtime: int 
    cores: int # 1-20
    transfertime: int # 64 par core

date1 = sys.argv[1]
date2 = sys.argv[2]
algo = sys.argv[3]
axex = sys.argv[4]

x = []
y = []
# ~ data_size = []
# ~ sizes = []
job_list = []

file_to_open = "data/Stretch_improvement_2022-" + date1 + "->2022-" + date2 + "_" + algo + ".txt"

font_size = 14

with open(file_to_open) as f:
	line = f.readline()
	while line:
		r1, r2, r3, r4, r5, r6 = line.split() 
		j = Job(int(r1), float(r2), int(r3), int(r4), int(r5), int(r6))
		job_list.append(j)
		line = f.readline()	
f.close()

if axex == "subtime":
	job_list.sort(key = operator.attrgetter("subtime"))
elif axex == "cores":
	job_list.sort(key = operator.attrgetter("cores"))
elif axex == "size":
	job_list.sort(key = operator.attrgetter("size"))
elif axex == "transfertime":
	job_list.sort(key = operator.attrgetter("transfertime"))
else:
	print("axex", axex, "pas géré")
	exit

	
for i in range (0, len(job_list)):
	if axex == "subtime":
		x.append(job_list[i].subtime)
	elif axex == "cores":
		x.append(job_list[i].cores)
	elif axex == "size":
		x.append(job_list[i].size)
	elif axex == "transfertime":
		x.append(job_list[i].transfertime)
	y.append(job_list[i].time)
fig, ax = plt.subplots()

# ~ workload = sys.argv[5]

# ~ if (workload == "2022-03-26->2022-03-26_V10000"):
	# ~ ax.set_yticks([1, 10, 20, 30, 40])
	# ~ ax.set_yticklabels(["1", "10", "20", "30", "40"], fontsize=font_size)
# ~ elif (workload == "2022-07-16->2022-07-16_V10000"):
	# ~ ax.set_yticks([0, 0.5, 1, 1.5, 2])
	# ~ ax.set_yticklabels(["0", "0.5", "1", "1.5", "2"], fontsize=font_size)
	# ~ ax.set_ylim(0,2)
# ~ else:
	# ~ print("not dealt with")
	# ~ exit()

# ~ ax.set_xticks([job_list[0].subtime, job_list[0].subtime + 21600, job_list[0].subtime + 21600*2, job_list[0].subtime + 21600*3, job_list[len(job_list)-1].subtime])
# ~ ax.set_xticklabels(["00:00", "06:00", "12:00", "18:00", "00:00"], fontsize=font_size)

ax.axhline(y = 1, color = 'black', linestyle = '-', alpha=0.2)

# ~ # Couleur en fonction de la stratégie
# ~ algo = sys.argv[4]
# ~ print("algo is:", algo)
if (algo == "Fcfs_with_a_score_x1_x0_x0_x0"):
	color_choosen = "#E50000"
elif (algo == "Fcfs_with_a_score_x500_x1_x0_x0"):
	color_choosen = "#00bfff"
elif (algo == "Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_x500_x1_x0_x0"):
	color_choosen = "#ff9b15"
elif (algo == "Fcfs_with_a_score_mixed_strategy_x500_x1_x0_x0"):
	color_choosen = "#91a3b0"
else:
	print("error scheduler in plot queue times")
	exit()
	

# Couleur en fonction de la stratégie
# ~ ax.scatter(x, y, color=color_choosen, s=sizes, alpha=0.3)
ax.scatter(x, y, color=color_choosen, s=2, alpha=0.3)

# ~ circles = [Line2D([0], [0], marker='o', color=color_choosen, label='20000 sec', markerfacecolor=color_choosen, markersize=(sqrt(20000)/2)/4, alpha=0.3, linestyle="None"),
# ~ Line2D([0], [0], marker='o', color=color_choosen, label='5000 sec', markerfacecolor=color_choosen, markersize=(sqrt(5000)/2)/4, alpha=0.3, linestyle="None"),
# ~ Line2D([0], [0], marker='o', color=color_choosen, label='1000 sec', markerfacecolor=color_choosen, markersize=(sqrt(1000)/2)/4, alpha=0.3, linestyle="None")]

# ~ line1 = Line2D([], [], color=color_choosen, marker='o', markersize=(sqrt(20000)/2)/4, markerfacecolor=color_choosen, alpha=0.3, linestyle="None")
# ~ line2 = Line2D([], [], color=color_choosen, marker='o', markersize=(sqrt(5000)/2)/4, markerfacecolor=color_choosen, alpha=0.3, linestyle="None")
# ~ line3 = Line2D([], [], color=color_choosen, marker='o', markersize=(sqrt(1000)/2)/4, markerfacecolor=color_choosen, alpha=0.3, linestyle="None")
# ~ plt.legend((line1, line2, line3), ('20000 sec', '5000 sec', '1000 sec'), loc='upper right', fontsize=font_size)

if axex == "size":
	plt.xlim(0, 15000)
	
ax.set_yscale('log')

# ~ plt.legend(handles=circles, loc='upper right')

plt.xlabel(axex, fontsize=font_size)
# ~ if sys.argv[3] == "stretch":
plt.ylabel("Stretch\'s improvement from FCFS", fontsize=font_size)
# ~ elif sys.argv[3] == "queue":
	# ~ plt.ylabel("% of queue time difference from FCFS", fontsize=font_size)
# ~ elif sys.argv[3] == "flow":
	# ~ plt.ylabel("% of flow time difference from FCFS", fontsize=font_size)
# ~ else:
	# ~ print("Error type")
	# ~ exit(1)

plt.savefig("plot/Stretch_times/Stretch_times_improvement_" + axex + "_" + date1 + "_"+ date2 + "_" + algo + ".pdf")
