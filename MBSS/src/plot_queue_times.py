# python3 plot_queue_times algo_reference (FCFS) algo_to_compare type (stretch, flow, queue)

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
    time: float
    data_type: int
    size: int
    subtime: int

x = []
y = []
data_size = []
sizes = []
job_list_algo_reference = []
job_list_algo_compare = []


font_size = 14

with open(sys.argv[1]) as f:
	line = f.readline()
	while line:
		# ~ print(line)
		r1, r2, r3, r4, r5= line.split() 
		j = Job(int(r1), float(r2), int(r3), int(r4), int(r5))
		job_list_algo_reference.append(j)
		line = f.readline()
f.close()
job_list_algo_reference.sort(key = operator.attrgetter("unique_id"))
print("First subtime is", job_list_algo_reference[0].subtime)
print("Last subtime is", job_list_algo_reference[len(job_list_algo_reference)-1].subtime)
with open(sys.argv[2]) as f:
	line = f.readline()
	while line:
		r1, r2, r3, r4, r5 = line.split() 
		j = Job(int(r1), float(r2), int(r3), int(r4), int(r5))
		job_list_algo_compare.append(j)
		line = f.readline()
f.close()
job_list_algo_compare.sort(key = operator.attrgetter("unique_id"))

for i in range (0, len(job_list_algo_compare)):
	if job_list_algo_compare[i].time == 0 and job_list_algo_reference[i].time == 0: 
		percentage_difference = 1
	elif job_list_algo_compare[i].time == 0:
		percentage_difference = 2
	elif  job_list_algo_reference[i].time == 0: 
		percentage_difference = 0
	else:
		percentage_difference =job_list_algo_reference[i].time/job_list_algo_compare[i].time
		
	
	# ~ print("Job:", job_list_algo_reference[i].unique_id, "FCFS:", job_list_algo_reference[i].time, "Algo1:", job_list_algo_compare[i].time, "%:", percentage_difference, "Delay:", job_list_algo_reference[i].size)
	
	job_list_algo_reference[i].time = percentage_difference
	
for i in range (0, len(job_list_algo_compare)):
	x.append(job_list_algo_reference[i].subtime)
	y.append(job_list_algo_reference[i].time)
	data_size.append(job_list_algo_reference[i].data_type)	
	# ~ sizes.append(job_list_algo_reference[i].size/1000)	
	sizes.append(sqrt(job_list_algo_reference[i].size)/2)
	# ~ print(job_list_algo_reference[i].size)
fig, ax = plt.subplots()

workload = sys.argv[5]

if (workload == "2022-03-26->2022-03-26_V10000"):
	ax.set_yticks([1, 10, 20, 30, 40])
	ax.set_yticklabels(["1", "10", "20", "30", "40"], fontsize=font_size)
elif (workload == "2022-07-16->2022-07-16_V10000"):
	ax.set_yticks([0, 0.5, 1, 1.5, 2])
	ax.set_yticklabels(["0", "0.5", "1", "1.5", "2"], fontsize=font_size)
	ax.set_ylim(0,2)
else:
	ax.set_yticks([0, 0.5, 1, 1.5, 2, 2.5, 3, 3.5])
	ax.set_yticklabels(["0", "0.5", "1", "1.5", "2", "2.5", "3", "3.5"], fontsize=font_size)
	ax.set_ylim(0.1,4)

ax.set_xticks([job_list_algo_reference[0].subtime, job_list_algo_reference[0].subtime + 86400, job_list_algo_reference[0].subtime + 86400*2, job_list_algo_reference[0].subtime + 86400*3, job_list_algo_reference[0].subtime + 86400*4, job_list_algo_reference[0].subtime + 86400*5, job_list_algo_reference[0].subtime + 86400*6])
ax.set_xticklabels(["03/10", "04/10", "05/10", "06/10", "07/10", "08/10", "09/10"], fontsize=font_size)

ax.axhline(y = 1, color = 'black', linestyle = '-', alpha=0.2)

# Couleur en fonction de la stratégie
algo = sys.argv[4]
print("algo is:", algo)
if (algo == "EFT"):
	color_choosen = "#E50000"
elif (algo == "LEA"):
	color_choosen = "#00bfff"
elif (algo == "LEO"):
	color_choosen = "#ff9b15"
elif (algo == "LEM"):
	color_choosen = "#91a3b0"
else:
	print("error scheduler in plot queue times")
	exit()
	
# Couleur en fonction du type de donnée
# ~ ax.scatter(x, y, c=data_size, s=sizes, alpha=0.3)

# Couleur en fonction de la stratégie
ax.scatter(x, y, color=color_choosen, s=sizes, alpha=0.3)
# ~ print(sizes)

# ~ circles = [Line2D([0], [0], marker='o', color=color_choosen, label='20000 sec', markerfacecolor=color_choosen, markersize=(sqrt(20000)/2)/4, alpha=0.3, linestyle="None"),
# ~ Line2D([0], [0], marker='o', color=color_choosen, label='5000 sec', markerfacecolor=color_choosen, markersize=(sqrt(5000)/2)/4, alpha=0.3, linestyle="None"),
# ~ Line2D([0], [0], marker='o', color=color_choosen, label='1000 sec', markerfacecolor=color_choosen, markersize=(sqrt(1000)/2)/4, alpha=0.3, linestyle="None")]

line1 = Line2D([], [], color=color_choosen, marker='o', markersize=(sqrt(20000)/2)/4, markerfacecolor=color_choosen, alpha=0.3, linestyle="None")
line2 = Line2D([], [], color=color_choosen, marker='o', markersize=(sqrt(5000)/2)/4, markerfacecolor=color_choosen, alpha=0.3, linestyle="None")
line3 = Line2D([], [], color=color_choosen, marker='o', markersize=(sqrt(1000)/2)/4, markerfacecolor=color_choosen, alpha=0.3, linestyle="None")
plt.legend((line1, line2, line3), ('20000 sec', '5000 sec', '1000 sec'), loc='upper right', fontsize=font_size)


# ~ plt.legend(handles=circles, loc='upper right')

plt.xlabel("Submission times (days)", fontsize=font_size)
if sys.argv[3] == "stretch":
	plt.ylabel("Stretch\'s improvement from FCFS", fontsize=font_size)
elif sys.argv[3] == "queue":
	plt.ylabel("% of queue time difference from FCFS", fontsize=font_size)
elif sys.argv[3] == "flow":
	plt.ylabel("% of flow time difference from FCFS", fontsize=font_size)
else:
	print("Error type")
	exit(1)

# ~ plt.savefig("plot/Stretch_times/Stretch_times_FCFS_" + algo + "_" + workload + "_450_128_32_256_4_1024.pdf")
plt.savefig("plot/Stretch_times/Stretch_times_FCFS_" + algo + "_" + workload + "_450_128_32_256_4_1024.png")
