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

# ~ print(day + "-" + month + "-" + year)

print(first_job_before_day_0, first_job_day_0, first_job_day_1, first_job_day_2)
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
	# L'écriture se fais ainsi:	fprintf(f_stats, "%d,%d,%d,%d,%d,%d\n", running_cores, running_nodes, nb_jobs_in_queue, running_nodes_workload_minus_2, nb_cores_in_queue, nb_cores_from_workload_1_in_queue);
	
	# ~ dates = ['07/15/2022','07/16/2022','07/17/2022']
	# ~ x = [dt.datetime.strptime(d,'%m/%d/%Y').date() for d in dates]
	# ~ y = list(df.iloc[:, Y_index + 1])
	# ~ plt.gca().xaxis.set_major_formatter(mdates.DateFormatter('%m/%d/%Y'))
	# ~ plt.gca().xaxis.set_major_locator(mdates.DayLocator())
	# ~ plt.plot(x,y)
	# ~ plt.gcf().autofmt_xdate()
	
	# ~ np.random.seed(1)

	# ~ N = 1267933
	# ~ y = list(df.iloc[:, Y_index + 1])

	# ~ now = dt.datetime.now()
	# ~ then = now + dt.timedelta(days=1267933)
	# ~ days = mdates.drange(now,then,dt.timedelta(days=1))

	# ~ plt.gca().xaxis.set_major_formatter(mdates.DateFormatter('%Y-%m-%d'))
	# ~ plt.gca().xaxis.set_major_locator(mdates.DayLocator(interval=100))
	# ~ plt.plot(days,y)
	# ~ plt.gcf().autofmt_xdate()
	# ~ plt.show()
	
	Y1 = list(df.iloc[:, Y_index + 1])
	Y2 = list(df.iloc[:, Y_index + 3 + 1])
	Y3 = list(df.iloc[:, Y_index + 4 + 1])
	Y4 = list(df.iloc[:, Y_index + 2 + 1])
	fig, ax1 = plt.subplots()

	if (mode == 0):
		ax1.plot(Y1, 'b-', label='Used cores by all jobs')
		ax1.plot(Y2, 'b-', label='Cores in queue from all jobs jobs', linestyle = "dashed")
		ax1.plot(Y3, 'r-', label='Cores in queue from evaluated jobs', linestyle = "dashed")
		ax1.plot(Y4, "r-", label='Used cores by evaluated jobs')
		str_day_list = [str(int(day)-1) + "/" + month + "/" + year, day + "/" + month + "/" + year, str(int(day)+1) + "/" + month + "/" + year]
	else: # mode reduced
		ax1.plot(Y1[:84600*3], 'b-', label='Used cores by all jobs')
		ax1.plot(Y2[:84600*3], 'b-', label='Cores in queue from all jobs jobs', linestyle = "dashed")
		ax1.plot(Y3[:84600*3], 'r-', label='Cores in queue from evaluated jobs', linestyle = "dashed")
		ax1.plot(Y4[:84600*3], "r-", label='Used cores by evaluated jobs')
		str_day_list = [str(int(day)-1) + "/" + month + "/" + year, day + "/" + month + "/" + year, str(int(day)+1) + "/" + month + "/" + year]
	
	ax1.set_xticks([0, 86400, 86400*2])
	ax1.set_xticklabels(str_day_list, rotation = 90)
	plt.axvline(x = 86400, color = 'orange', linestyle = "dotted")
	plt.axvline(x = 86400*2, color = 'orange', linestyle = "dotted")
		
	plt.axhline(y = 486*20, color = 'black', linestyle = "dotted", label = "Total number of cores")
	ax1.set_xlabel('Time in seconds')
	ax1.set_ylabel(Y_label, color='b')
	plt.legend()
	
filename = "plot/" + title + ".pdf"

plt.savefig(filename, bbox_inches='tight')
