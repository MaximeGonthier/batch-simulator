# python3 plot_stretch_multiple_schedulers ${SCHEDULER_1} ${SCHEDULER_2} ${SCHEDULER_3} ...

# Imports
import matplotlib.pyplot as plt
import numpy as np
import sys
import operator
from dataclasses import dataclass

@dataclass
class Job:
    unique_id: int
    time: int
    data_type: int

job_list = []
name_algo_list = []

for i in range(1, len(sys.argv)):
	temp_job_list = []
	with open("outputs/Stretch_times_" + sys.argv[i] + ".txt") as f:
		line = f.readline()
		while line:
			r1, r2, r3 = line.split() 
			j = Job(int(r1), int(r2), int(r3))
			temp_job_list.append(j)
			line = f.readline()
	f.close()
	temp_job_list.sort(key = operator.attrgetter("unique_id"))
	job_list.append(temp_job_list)
	name_algo_list.append(sys.argv[i])

x = []
y = []
data_size = []

for j in range (0, len(sys.argv) - 1):
	for i in range (0, len(temp_job_list)):
		x.append(job_list[j][i].unique_id)
		y.append(job_list[j][i].time)
		data_size.append(job_list[j][i].data_type)	
	label_name = name_algo_list[j]
	plt.scatter(x, y, label=label_name, s=5)

plt.xlabel("Jobs ids")
plt.ylabel("Stretch of flow ratio")
plt.legend()
plt.savefig("plot.pdf")
