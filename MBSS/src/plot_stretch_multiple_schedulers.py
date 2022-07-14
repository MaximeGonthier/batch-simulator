# python3 plot_stretch_multiple_schedulers ${SCHEDULER_1} ${SCHEDULER_2} ${SCHEDULER_3} ...

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

job_list = []
name_algo_list = []

for i in range(2, len(sys.argv)):
	temp_job_list = []
	with open("outputs/" + sys.argv[1] + "_times_" + sys.argv[i] + ".txt") as f:
		line = f.readline()
		while line:
			r1, r2, r3, r4, r5 = line.split()
			j = Job(int(r1), float(r2), int(r3), int(r4), int(r5))
			temp_job_list.append(j)
			line = f.readline()
	f.close()
	temp_job_list.sort(key = operator.attrgetter("unique_id"))
	job_list.append(temp_job_list)
	name_algo_list.append(sys.argv[i])

x = []
y = []
data_size = []
sizes = []

for j in range (0, len(sys.argv) - 2):
	for i in range (0, len(temp_job_list)):
		x.append(job_list[j][i].subtime)
		y.append(job_list[j][i].time)
		data_size.append(job_list[j][i].data_type)
		sizes.append(job_list[j][i].size/1000)
	label_name = name_algo_list[j]
	# ~ plt.scatter(x, y, label=label_name, s=sizes, alpha=0.3)
	plt.scatter(x, y, label=label_name, s=sizes)

plt.xlabel("Submission times (sec)")
if (sys.argv[1] == "Stretch"):
	plt.ylabel("Flow stretch")
elif (sys.argv[1] == "Bounded_Stretch"):
	plt.ylabel("Bounded flow stretch")
else:
	print("Error type")
	exit(1)
plt.legend()
plt.savefig("plot.pdf")



# python3 plot_queue_times algo_reference (FCFS) algo_to_compare type (stretch, flow, queue)
		
# ~ plt.axhline(y = 0, color = 'black', linestyle = '-', alpha=0.2)
# ~ plt.axhline(y = -200, color = 'black', linestyle = '-', alpha=0.2)
# ~ plt.axhline(y = 200, color = 'black', linestyle = '-', alpha=0.2)

# ~ plt.scatter(x, y, c=data_size, label=data_size, s=sizes, alpha=0.3)

# ~ custom_lines = [Line2D([0], [0], color="darkblue", lw=4),
                # ~ Line2D([0], [0], color="green", lw=4),
                # ~ Line2D([0], [0], color="yellow", lw=4)]
# ~ plt.legend(custom_lines, ['128', '256', '1024'])

# ~ if sys.argv[3] == "stretch":
	# ~ plt.ylabel("% of flow stretch difference from FCFS")
# ~ elif sys.argv[3] == "queue":
	# ~ plt.ylabel("% of queue time difference from FCFS")
# ~ elif sys.argv[3] == "flow":
	# ~ plt.ylabel("% of flow time difference from FCFS")
# ~ else:
	# ~ print("Error type")
	# ~ exit(1)
# ~ plt.savefig("plot.pdf")
