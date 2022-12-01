# python3 src/plot_running_cores.py input_file title
# importing package
# plot stats on cluster usage
import matplotlib.pyplot as plt
import pandas as pd
import sys
import numpy as np
import datetime as dt
import matplotlib.dates as mdates

data = pd.read_csv(sys.argv[1])
comparaison = sys.argv[2]
workload = sys.argv[3]
cluster = sys.argv[4]
scheduler = sys.argv[5]
first_job_before_day_0 = int(sys.argv[6])
first_job_day_0 = int(sys.argv[7])
first_job_day_1 = int(sys.argv[8])
first_job_day_2 = int(sys.argv[9])
day = sys.argv[11]
month = sys.argv[12]
year = sys.argv[13]
precision_mode = sys.argv[14]
print("Opening", sys.argv[1], "precision mode is", precision_mode)

# ~ print(day + "-" + month + "-" + year)

# ~ print(first_job_before_day_0, first_job_day_0, first_job_day_1, first_job_day_2)
mode = int(sys.argv[10]) # 0 normal, 1 reduced

if (mode == 0):
	title = workload + "_" + scheduler + "_" + comparaison + "_" + cluster
else:
	title = workload + "_" + scheduler + "_" + comparaison + "_Reduced_" + cluster

if (comparaison == "Used_cores"):
	Y_index = 0
	plot_title = "Used cores" + " " + scheduler
	Y_label = "Number of cores used"
	if (cluster == "41_128_3_256_1_1024"):
		line = 900
	elif (cluster == "95_128_4_256_1_1024"):
		line = 2000
	elif (cluster == "182_128_16_256_2_1024"):
		line = 4000
	elif (cluster == "450_128_32_256_4_1024"):
		line = 9720
	elif (cluster == "675_128_48_256_6_1024"):
		line = 14580
	else:
		print("error")
		exit(1)
	plt.axhline(y = line, color = 'black', linestyle = '-', label = "Total number of cores")
	plt.gca().set_ylim(bottom=0)
elif (comparaison == "Used_nodes"):
	Y_index = 1
	plot_title = "Used nodes" + " " + scheduler
	Y_label = "Number of cores"
	if (cluster == "41_128_3_256_1_1024"):
		line = 45
	elif (cluster == "95_128_4_256_1_1024"):
		line = 100
	elif (cluster == "182_128_16_256_2_1024"):
		line = 200
	elif (cluster == "450_128_32_256_4_1024"):
		line = 486
	elif (cluster == "675_128_48_256_6_1024"):
		line = 729
	else:
		print("error")
		exit(1)
	plt.axhline(y = line, color = 'black', linestyle = '-', label = "Total number of nodes")
	plt.gca().set_ylim(bottom=0)
elif (comparaison == "Nb_scheduled_jobs"):
	Y_index = 2
	plot_title = "Number of jobs in the queue" + " " + scheduler
	Y_label = "Number of jobs in the queue"
else:
	print("Wrong comparison")
	exit(1)
	
df = pd.DataFrame(data)

if (comparaison != "Used_nodes"):
	# X = list(df.iloc[:, 0])
	Y = list(df.iloc[:, Y_index])
	# plt.axvline(x = first_job_before_day_0, color = 'yellow', linestyle = '-', label = "Submission time first job before day 0")
	# plt.axvline(x = first_job_day_0, color = 'green', linestyle = '-', label = "Submission time first job day 0")
	plt.axvline(x = first_job_day_1, color = 'orange', linestyle = '-', label = "Submission time first job day 1")
	plt.axvline(x = first_job_day_2, color = 'red', linestyle = '-', label = "Submission time first job day 2 and beyond")
	plt.title(plot_title)
	plt.xlabel("Time in seconds")
	plt.ylabel(Y_label)
	plt.plot(Y)
else:
	
	used_cores = list(df.iloc[:, 1])
	used_nodes = list(df.iloc[:, 2])
	used_nodes_evaluated_jobs = list(df.iloc[:, 4])
	cores_in_queue = list(df.iloc[:, 5])
	cores_in_queue_evaluated_jobs = list(df.iloc[:, 6])
	nodes_loading_a_file = list(df.iloc[:, 7])
	used_cores_evaluated_jobs = list(df.iloc[:, 8])
	cores_loading_a_file = list(df.iloc[:, 9])
	fig, axs = plt.subplots(2, 1, sharex=True)
	fig.subplots_adjust(hspace=0)
	
	for i in range (0, len(used_cores)):
		if used_cores[i] == 0:
			used_cores[i] = float('nan')
	for i in range (0, len(used_nodes)):
		if used_nodes[i] == 0:
			used_nodes[i] = float('nan')
	for i in range (0, len(used_nodes_evaluated_jobs)):
		if used_nodes_evaluated_jobs[i] == 0:
			used_nodes_evaluated_jobs[i] = float('nan')
	for i in range (0, len(used_cores_evaluated_jobs)):
		if used_cores_evaluated_jobs[i] == 0:
			used_cores_evaluated_jobs[i] = float('nan')
	for i in range (0, len(nodes_loading_a_file)):
		if nodes_loading_a_file[i] == 0:
			nodes_loading_a_file[i] = float('nan')
	for i in range (0, len(cores_loading_a_file)):
		if cores_loading_a_file[i] == 0:
			cores_loading_a_file[i] = float('nan')
	for i in range (0, len(cores_in_queue)):
		if cores_in_queue[i] == 486*20:
			cores_in_queue[i] = float('nan')
		else:
			cores_in_queue[i] -= 9720
	for i in range (0, len(cores_in_queue_evaluated_jobs)):
		if cores_in_queue_evaluated_jobs[i] == 486*20:
			cores_in_queue_evaluated_jobs[i] = float('nan')
		else:
			cores_in_queue_evaluated_jobs[i] -= 9720

	if (precision_mode == "node_by_node"):
		if (mode == 0): # mode full
			axs[1].plot(used_nodes, 'b-', label='All jobs')
			axs[0].plot(cores_in_queue, 'b-', label='All jobs', linestyle = "dashed")
			axs[0].plot(cores_in_queue_evaluated_jobs, 'r-', label='Evaluated jobs', linestyle = "dashed")
			axs[1].plot(used_nodes_evaluated_jobs, "r-", label='Evaluated jobs')
			axs[1].plot(nodes_loading_a_file, "gray", label='Waiting for a file')
			str_day_list = [str(int(day)-1) + "/" + month + "/" + year, day + "/" + month + "/" + year, str(int(day)+1) + "/" + month + "/" + year]
		else: # mode reduced
			axs[1].plot(used_nodes[:84600*3], 'b-', label='All jobs')
			axs[0].plot(cores_in_queue[:84600*3], 'b-', label='All jobs', linestyle = "dashed")
			axs[0].plot(cores_in_queue_evaluated_jobs[:84600*3], 'r-', label='Evaluated jobs', linestyle = "dashed")
			axs[1].plot(used_nodes_evaluated_jobs[:84600*3], "r-", label='Evaluated jobs')
			axs[1].plot(nodes_loading_a_file[:84600*3], "gray", label='Waiting for a file')
			str_day_list = [str(int(day)-1) + "/" + month + "/" + year, day + "/" + month + "/" + year, str(int(day)+1) + "/" + month + "/" + year]
	elif (precision_mode == "core_by_core"):
		if (mode == 0): # mode full
			axs[1].plot(used_cores, 'b-', label='All jobs')
			axs[0].plot(cores_in_queue, 'b-', label='All jobs', linestyle = "dashed")
			axs[0].plot(cores_in_queue_evaluated_jobs, 'r-', label='Evaluated jobs', linestyle = "dashed")
			axs[1].plot(used_cores_evaluated_jobs, "r-", label='Evaluated jobs')
			axs[1].plot(cores_loading_a_file, "gray", label='Waiting for a file')
			str_day_list = [str(int(day)-1) + "/" + month + "/" + year, day + "/" + month + "/" + year, str(int(day)+1) + "/" + month + "/" + year]
		else: # mode reduced
			axs[1].plot(used_cores[:84600*3], 'b-', label='All jobs')
			axs[0].plot(cores_in_queue[:84600*3], 'b-', label='All jobs', linestyle = "dashed")
			axs[0].plot(cores_in_queue_evaluated_jobs[:84600*3], 'r-', label='Evaluated jobs', linestyle = "dashed")
			axs[1].plot(used_cores_evaluated_jobs[:84600*3], "r-", label='Evaluated jobs')
			axs[1].plot(cores_loading_a_file[:84600*3], "gray", label='Waiting for a file')
			str_day_list = [str(int(day)-1) + "/" + month + "/" + year, day + "/" + month + "/" + year, str(int(day)+1) + "/" + month + "/" + year]
	else:
		print("Wrong precision mode.")
		exit
		
	axs[0].set_xticks([0, 86400, 86400*2])
	axs[0].set_xticklabels(str_day_list, rotation = 90)
	plt.axvline(x = 86400, color = 'orange', linestyle = "dotted")
	plt.axvline(x = 86400*2, color = 'orange', linestyle = "dotted")
		
	plt.axhline(y = 486*20, color = 'black', linestyle = "dotted", label = "Total number of cores")
	# ~ axs[0].set_xlabel('Time in seconds')
	axs[0].set_ylabel("In queue")
	axs[1].set_ylabel("Running")
	# ~ axs[1] = axs[0].twiny()  #
	# ~ axs[1].set_ylabel("Number of cores used")
	fig.text(-0.03, 0.5, 'Number of cores', va='center', rotation='vertical')
	axs[0].legend(loc="upper left")
	axs[1].legend(loc="upper left")
	# ~ axs[1] = axs[0].twiny()  #
	
filename = "plot/Cluster_usage/" + title + "_" + precision_mode + ".pdf"

plt.savefig(filename, bbox_inches='tight')
