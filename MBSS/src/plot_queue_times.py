# python3 plot_queue_times algo_to_compare algo_reference Stretch_or_time(1 or 0)

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
    time: float
    data_type: int
    size: int

x = []
y = []
data_size = []
sizes = []
job_list_algo_reference = []
job_list_algo_compare = []

type_label = int(sys.argv[3])

with open(sys.argv[1]) as f:
	line = f.readline()
	while line:
		r1, r2, r3, r4 = line.split() 
		j = Job(int(r1), int(r2), int(r3), int(r4))
		job_list_algo_reference.append(j)
		line = f.readline()
f.close()
job_list_algo_reference.sort(key = operator.attrgetter("unique_id"))

with open(sys.argv[2]) as f:
	line = f.readline()
	while line:
		r1, r2, r3, r4 = line.split() 
		j = Job(int(r1), int(r2), int(r3), int(r4))
		job_list_algo_compare.append(j)
		line = f.readline()
f.close()
job_list_algo_compare.sort(key = operator.attrgetter("unique_id"))

for i in range (0, len(job_list_algo_compare)):
	if job_list_algo_compare[i].time == 0:
		job_list_algo_compare[i].time = 1
	# ~ print("(job_list_algo_reference[i].time*100)/job_list_algo_compare[i].time - 100", job_list_algo_reference[i].time, job_list_algo_compare[i].time)
	job_list_algo_reference[i].time = (job_list_algo_reference[i].time*100)/job_list_algo_compare[i].time - 100
	# ~ diff = job_list_algo_reference[i].time - job_list_algo_compare[i].time
	# ~ job_list_algo_reference[i].time = (diff*100)/
	
	print("Job id:", job_list_algo_reference[i].unique_id, "% diff:", job_list_algo_reference[i].time)
	
for i in range (0, len(job_list_algo_compare)):
	x.append(job_list_algo_reference[i].unique_id)
	y.append(job_list_algo_reference[i].time)
	data_size.append(job_list_algo_reference[i].data_type)	
	sizes.append(job_list_algo_reference[i].size/1000)	
	
plt.axhline(y = 0, color = 'black', linestyle = '-')

plt.scatter(x, y, c=data_size, label=data_size, s=sizes)

custom_lines = [Line2D([0], [0], color="darkblue", lw=4),
                Line2D([0], [0], color="green", lw=4),
                Line2D([0], [0], color="yellow", lw=4)]
plt.legend(custom_lines, ['128', '256', '1024'])

plt.xlabel("Jobs ids")
if type_label == 1:
	plt.ylabel("% of flow stretch difference from FCFS")
else:
	plt.ylabel("Queue time (seconds) difference from FCFS")
plt.savefig("plot.pdf")
