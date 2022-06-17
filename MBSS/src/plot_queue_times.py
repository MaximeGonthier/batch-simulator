# python3 plot_queue_times algo_reference (FCFS) algo_to_compare type (stretch, flow, queue)

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
    subtime: int

x = []
y = []
data_size = []
sizes = []
job_list_algo_reference = []
job_list_algo_compare = []

# ~ type_label = int(sys.argv[3])

with open(sys.argv[1]) as f:
	line = f.readline()
	while line:
		r1, r2, r3, r4, r5= line.split() 
		j = Job(int(r1), int(r2), int(r3), int(r4), int(r5))
		job_list_algo_reference.append(j)
		line = f.readline()
f.close()
job_list_algo_reference.sort(key = operator.attrgetter("unique_id"))

with open(sys.argv[2]) as f:
	line = f.readline()
	while line:
		r1, r2, r3, r4, r5 = line.split() 
		j = Job(int(r1), int(r2), int(r3), int(r4), int(r5))
		job_list_algo_compare.append(j)
		line = f.readline()
f.close()
job_list_algo_compare.sort(key = operator.attrgetter("unique_id"))

for i in range (0, len(job_list_algo_compare)):
	if job_list_algo_compare[i].time == 0 and job_list_algo_reference[i].time == 0: 
		percentage_difference = 0
	elif job_list_algo_compare[i].time == 0 or job_list_algo_reference[i].time == 0: 
		percentage_difference = 200
	else:
		percentage_difference = 100 * ( abs(job_list_algo_reference[i].time - job_list_algo_compare[i].time) / ( (job_list_algo_reference[i].time + job_list_algo_compare[i].time) / 2 ) )
		
	if job_list_algo_reference[i].time > job_list_algo_compare[i].time:
		percentage_difference = percentage_difference*-1
	
	print("Job:", job_list_algo_reference[i].unique_id, "FCFS:", job_list_algo_reference[i].time, "Algo1:", job_list_algo_compare[i].time, "%:", percentage_difference)
	
	job_list_algo_reference[i].time = percentage_difference
	# ~ diff = job_list_algo_reference[i].time - job_list_algo_compare[i].time
	# ~ job_list_algo_reference[i].time = (diff*100)/
	
	# ~ print("Job id:", job_list_algo_reference[i].unique_id, "% diff:", job_list_algo_reference[i].time)
	
for i in range (0, len(job_list_algo_compare)):
	# ~ x.append(job_list_algo_reference[i].unique_id)
	x.append(job_list_algo_reference[i].subtime)
	y.append(job_list_algo_reference[i].time)
	data_size.append(job_list_algo_reference[i].data_type)	
	sizes.append(job_list_algo_reference[i].size/1000)	
	
plt.axhline(y = 0, color = 'black', linestyle = '-', alpha=0.2)
plt.axhline(y = -200, color = 'black', linestyle = '-', alpha=0.2)
plt.axhline(y = 200, color = 'black', linestyle = '-', alpha=0.2)

plt.scatter(x, y, c=data_size, label=data_size, s=sizes, alpha=0.3)

custom_lines = [Line2D([0], [0], color="darkblue", lw=4),
                Line2D([0], [0], color="green", lw=4),
                Line2D([0], [0], color="yellow", lw=4)]
plt.legend(custom_lines, ['128', '256', '1024'])

plt.xlabel("Submission times (sec)")
if sys.argv[3] == "stretch":
	plt.ylabel("% of flow stretch difference from FCFS")
elif sys.argv[3] == "queue":
	plt.ylabel("% of queue time difference from FCFS")
elif sys.argv[3] == "flow":
	plt.ylabel("% of flow time difference from FCFS")
else:
	print("Error type")
	exit(1)
plt.savefig("plot.pdf")
