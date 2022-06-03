# python3 plot_queue_times algo_reference algo_to_compare

# Imports
import matplotlib.pyplot as plt
import numpy as np
import sys
import operator
from dataclasses import dataclass
from matplotlib.lines import Line2D

@dataclass
class Job:
    unique_id: int
    time: int
    data_type: int

x = []
y = []
data_size = []
job_list_algo_reference = []
job_list_algo_compare = []

type_label = int(sys.argv[3])

with open(sys.argv[1]) as f:
	line = f.readline()
	while line:
		r1, r2, r3 = line.split() 
		j = Job(int(r1), int(r2), int(r3))
		job_list_algo_reference.append(j)
		line = f.readline()
f.close()
job_list_algo_reference.sort(key = operator.attrgetter("unique_id"))

with open(sys.argv[2]) as f:
	line = f.readline()
	while line:
		r1, r2, r3 = line.split() 
		j = Job(int(r1), int(r2), int(r3))
		job_list_algo_compare.append(j)
		line = f.readline()
f.close()
job_list_algo_compare.sort(key = operator.attrgetter("unique_id"))

for i in range (0, len(job_list_algo_compare)):
	job_list_algo_reference[i].time = job_list_algo_reference[i].time - job_list_algo_compare[i].time

for i in range (0, len(job_list_algo_compare)):
	x.append(job_list_algo_reference[i].unique_id)
	y.append(job_list_algo_reference[i].time)
	data_size.append(job_list_algo_reference[i].data_type)	
	
plt.axhline(y = 0, color = 'black', linestyle = '-')

plt.scatter(x, y, c=data_size, label=data_size)

custom_lines = [Line2D([0], [0], color="darkblue", lw=4),
                Line2D([0], [0], color="green", lw=4),
                Line2D([0], [0], color="yellow", lw=4)]
plt.legend(custom_lines, ['128', '256', '1024'])

plt.xlabel("Jobs ids")
if type_label == 1:
	plt.ylabel("Stretch of flow ratio difference from FCFS")
else:
	plt.ylabel("Time (seconds) difference from FCFS")
plt.savefig("plot.pdf")
