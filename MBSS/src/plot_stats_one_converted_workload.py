# Compute and plot stat of a converted workload
# { id: 1 subtime: 0 delay: 388923 walltime: 388800 cores: 20 user: marvin data: 1 data_size: 128.000000 workload: -2 start_time_from_history: 3164092 start_node_from_history: 337 }

import sys
import pandas as pd
from matplotlib import pyplot as plt
import numpy as np
from matplotlib.lines import Line2D

FILENAME = sys.argv[1]

f_input = open("inputs/workloads/converted/" + FILENAME, "r")
f_output_subtime_all = open("outputs/" + FILENAME + "_subtime_all", "w")
f_output_delay_all = open("outputs/" + FILENAME + "_delay_all", "w")
f_output_cores_all = open("outputs/" + FILENAME + "_cores_all", "w")
f_output_data_size_all = open("outputs/" + FILENAME + "_data_size_all", "w")
f_output_subtime_evaluated = open("outputs/" + FILENAME + "_subtime_evaluated", "w")
f_output_delay_evaluated = open("outputs/" + FILENAME + "_delay_evaluated", "w")
f_output_cores_evaluated = open("outputs/" + FILENAME + "_cores_evaluated", "w")
f_output_data_size_evaluated = open("outputs/" + FILENAME + "_data_size_evaluated", "w")
f_output_number_jobs_each_workload = open("outputs/" + FILENAME + "_number_jobs_each_workload.csv", "w")
f_output_number_jobs_each_workload.write("Jobs started before T=0, Jobs submitted but not started before T=0, Jobs submitted on day 0, Jobs evaluated, Jobs submitted after the last evaluated jobs\n")
f_output_subtime_128 = open("outputs/" + FILENAME + "_subtime_128", "w")
f_output_subtime_256 = open("outputs/" + FILENAME + "_subtime_256", "w")
f_output_subtime_1024 = open("outputs/" + FILENAME + "_subtime_1024", "w")

nb_minus_2 = 0
nb_minus_1 = 0
nb_0 = 0
nb_1 = 0
nb_2 = 0

line = f_input.readline()
while line:
	r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21, r22, r23, r24 = line.split()
	
	f_output_subtime_all.write("%d\n" % int(str(r5)))
	f_output_delay_all.write("%d\n" % int(str(r7)))
	f_output_cores_all.write("%d\n" % int(str(r11)))
	
	if (float(str(r17)) == 0.0):
		index_node = 128
	elif ((float(str(r17))*10)/(int(str(r11))*10) == 6.4):
		index_node = 128
	elif ((float(str(r17))*10)/(int(str(r11))*10) == 12.8):
		index_node = 256
	elif ((float(str(r17))*10)/(int(str(r11))*10) == 51.2):
		index_node = 1024
	else:
		print(line)
		print(float(str(r17)), int(str(r11)))
		print("Error:", ((float(str(r17)))/(int(str(r11)))))
		exit(1)
	
	if (index_node == 128):
		f_output_subtime_128.write("%d\n" % int(str(r5)))
	elif (index_node == 256):
		f_output_subtime_256.write("%d\n" % int(str(r5)))
	else:
		f_output_subtime_1024.write("%d\n" % int(str(r5)))
	
	f_output_data_size_all.write("%d\n" % index_node)
	
	if (int(str(r19)) == 1):
		f_output_subtime_evaluated.write("%d\n" % int(str(r5)))
		f_output_delay_evaluated.write("%d\n" % int(str(r7)))
		f_output_cores_evaluated.write("%d\n" % int(str(r11)))
		f_output_data_size_evaluated.write("%d\n" % index_node)
	
	if (int(str(r19)) == -2):
		nb_minus_2 += 1
	elif (int(str(r19)) == -1):
		nb_minus_1 += 1
	elif (int(str(r19)) == 0):
		nb_0 += 1
	elif (int(str(r19)) == 1):
		nb_1 += 1
	elif (int(str(r19)) == 2):
		nb_2 += 1
		
	line = f_input.readline()
f_output_number_jobs_each_workload.write("%d,%d,%d,%d,%d" % (nb_minus_2, nb_minus_1, nb_0, nb_1, nb_2))
f_input.close()
f_output_subtime_all.close()
f_output_delay_all.close()
f_output_cores_all.close()
f_output_data_size_all.close()
f_output_subtime_evaluated.close()
f_output_delay_evaluated.close()
f_output_cores_evaluated.close()
f_output_data_size_evaluated.close()
f_output_number_jobs_each_workload.close()

# Plotting

# Subtimes
# ~ plt.hold(True)
data1 = pd.read_csv("outputs/" + FILENAME + "_subtime_all")
data1bis = pd.read_csv("outputs/" + FILENAME + "_subtime_evaluated")
# ~ plt.hist(data1, align="mid", bins=20, alpha=0.5)
# ~ bins=np.histogram(np.hstack((data1,data1bis)), bins=40)[1] #get the bin edges
plt.hist(data1, align="mid")
plt.hist(data1bis, align="mid")
plt.title("Distribution of subtimes on a log scale")
plt.xlabel("Subtime (seconds)")
plt.ylabel("#Occurrences")
custom_lines = [Line2D([0], [0], color="orange", lw=4),
                Line2D([0], [0], color="blue", lw=4)]
plt.legend(custom_lines, ['Evaluated jobs', 'All jobs'])
plt.yscale('log')
plt.savefig("plot/Distribution/" + FILENAME + "_subtime" + ".pdf")
plt.close()

# Delay
data2 = pd.read_csv("outputs/" + FILENAME + "_delay_all")
plt.hist(data2, align="mid")
data2 = pd.read_csv("outputs/" + FILENAME + "_delay_evaluated")
plt.title("Distribution of jobs' durations on a log scale")
plt.xlabel("Jobs' durations (seconds)")
plt.ylabel("#Occurrences")
custom_lines = [Line2D([0], [0], color="orange", lw=4),
                Line2D([0], [0], color="blue", lw=4)]
plt.legend(custom_lines, ['Evaluated jobs', 'All jobs'])
plt.hist(data2, align="mid")
plt.yscale('log')
plt.savefig("plot/Distribution/" + FILENAME + "_delay" + ".pdf")
plt.close()

# Cores
data3 = pd.read_csv("outputs/" + FILENAME + "_cores_all")
plt.hist(data3, align="mid")
data3 = pd.read_csv("outputs/" + FILENAME + "_cores_evaluated")
plt.title("Distribution of the number of cores per job on a log scale")
plt.xlabel("Number of cores per job")
plt.ylabel("#Occurrences")
custom_lines = [Line2D([0], [0], color="orange", lw=4),
                Line2D([0], [0], color="blue", lw=4)]
plt.legend(custom_lines, ['Evaluated jobs', 'All jobs'])
plt.hist(data3, align="mid")
plt.yscale('log')
plt.savefig("plot/Distribution/" + FILENAME + "_cores" + ".pdf")
plt.close()

# Data size
data4 = pd.read_csv("outputs/" + FILENAME + "_data_size_all")
plt.hist(data4, align="mid")
data4 = pd.read_csv("outputs/" + FILENAME + "_data_size_evaluated")
plt.title("Distribution of the number of jobs needing a certain node size on a linear scale")
plt.xlabel("Number of jobs needing a certain node size")
plt.ylabel("#Occurrences")
plt.xticks([128,256,1024])
custom_lines = [Line2D([0], [0], color="orange", lw=4),
                Line2D([0], [0], color="blue", lw=4)]
plt.legend(custom_lines, ['Evaluated jobs', 'All jobs'])
plt.hist(data4, align="mid")
# plt.yscale('log')
plt.savefig("plot/Distribution/" + FILENAME + "_data_size" + ".pdf")
plt.close()

# Subtimes but with jobs' sizes
data5 = pd.read_csv("outputs/" + FILENAME + "_subtime_all")
plt.hist(data5, align="mid", color="blue")
data5 = pd.read_csv("outputs/" + FILENAME + "_subtime_128")
plt.hist(data5, align="mid", color="red")
data5 = pd.read_csv("outputs/" + FILENAME + "_subtime_256")
plt.hist(data5, align="mid", color="green")
data5 = pd.read_csv("outputs/" + FILENAME + "_subtime_1024")
plt.hist(data5, align="mid", color="yellow")
plt.title("Distribution of subtimes on a log scale with node's size requirement")
plt.xlabel("Subtime (seconds)")
plt.ylabel("#Occurrences")
custom_lines = [Line2D([0], [0], color="blue", lw=4),
				Line2D([0], [0], color="red", lw=4),
				Line2D([0], [0], color="green", lw=4),
                Line2D([0], [0], color="yellow", lw=4)]
plt.legend(custom_lines, ['All jobs', '128 jobs', '256 jobs', '1024 jobs'])
plt.yscale('log')
plt.savefig("plot/Distribution/" + FILENAME + "_subtime_with_nodes_size" + ".pdf")
plt.close()
