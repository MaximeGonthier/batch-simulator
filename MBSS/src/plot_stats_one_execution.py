# python3 src/plot_running_cores.py input_file title
# importing package
# plot stats on cluster usage
import matplotlib.pyplot as plt
import pandas as pd
import sys
import numpy as np

data = pd.read_csv(sys.argv[1])
comparaison = sys.argv[2]
workload = sys.argv[3]
cluster = sys.argv[4]
scheduler = sys.argv[5]
first_job_before_day_0 = int(sys.argv[6])
first_job_day_0 = int(sys.argv[7])
first_job_day_1 = int(sys.argv[8])
first_job_day_2 = int(sys.argv[9])
title = workload + "_" + scheduler + "_" + comparaison + "_" + cluster

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
	Y_label = "Number of nodes used"
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
	Y1 = list(df.iloc[:, Y_index])
	Y2 = list(df.iloc[:, Y_index + 1])
	fig, ax1 = plt.subplots()
	ax2 = ax1.twinx()
	ax1.plot(Y1, 'b-')
	ax2.plot(Y2, 'g-')
	ax1.set_ylim([0, 500])
	# ~ ax2.set_ylim([0, NULL])
	plt.axvline(x = first_job_day_1, color = 'orange', linestyle = '-', label = "Submission time first job day 1")
	plt.axvline(x = first_job_day_2, color = 'red', linestyle = '-', label = "Submission time first job day 2 and beyond")
	ax1.set_xlabel('Time in seconds')
	ax1.set_ylabel(Y_label, color='b')
	ax2.set_ylabel('Nb of jobs in the queue', color='g')

filename = "plot/" + title + ".pdf"

plt.savefig(filename)
