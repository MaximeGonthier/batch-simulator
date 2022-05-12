# python3 src/plot_running_cores.py input_file title
# importing package
import matplotlib.pyplot as plt
import pandas as pd
import sys

data = pd.read_csv(sys.argv[1])
comparaison = sys.argv[2]
workload = sys.argv[3]
cluster = sys.argv[4]
scheduler = sys.argv[5]
firstjob = int(sys.argv[6])
lastjob = int(sys.argv[7])
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
	else:
		print("error")
		exit(1)
	plt.axhline(y = line, color = 'black', linestyle = '-', label = "Total number of cores")
	
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
	else:
		print("error")
		exit(1)
	plt.axhline(y = line, color = 'black', linestyle = '-', label = "Total number of nodes")
	
elif (comparaison == "Nb_scheduled_jobs"):
	Y_index = 2
	plot_title = "Number of jobs in the queue" + " " + scheduler
	Y_label = "Number of jobs in the queue"

else:
	print("Wrong comparison")
	exit(1)
	
df = pd.DataFrame(data)
  
# ~ X = list(df.iloc[:, 0])
Y = list(df.iloc[:, Y_index])
  
# Plot the data using bar() method
# ~ plt.bar(X, Y, color=["red", "green", "blue", "yellow", "cyan", "magenta"])
# ~ plt.bar(X, Y, color=["red", "green", "blue", "yellow", "cyan", "magenta", "orange", "pink", "purple"])
# ~ plt.xticks(rotation=60)
# ~ plt.title(plot_title)
# ~ plt.xlabel("Scheduler")
# ~ plt.ylabel("Seconds")
  
# Show the plot
# ~ plt.show()

# ~ filename = "plot/" + title + ".pdf"
# ~ plt.savefig(filename, bbox_inches='tight')


# ~ plt = data.plot(title=plot_title)
# ~ print(firstjob)
# ~ exit(1)
plt.axvline(x = firstjob, color = 'blue', linestyle = '-', label = "Submission time first job taken into account")
plt.axvline(x = lastjob, color = 'darkblue', linestyle = '-', label = "submission time last job taken into account")

plt.plot(Y)
plt.title(plot_title)
plt.xlabel("Time in seconds")
plt.ylabel(Y_label)
# ~ plt.axhline(y = 9720, color = 'black', linestyle = '-', label = "Total number of cores")

# ~ plt.axvline(x = 7729, color = 'r', linestyle = '-', label = "First job day 1")
# ~ plt.axvline(x = 966994, color = 'orange', linestyle = '-', label = "Last job day 1")

# ~ plt.axvline(x = 483742, color = 'g', linestyle = '-', label = "First job day 2")
# ~ plt.axvline(x = 1053602, color = 'palegreen', linestyle = '-', label = "Last job day 2")

# ~ plt.axvline(x = 0, color = 'b', linestyle = '-', label = "First job day 3")
# ~ plt.axvline(x = 1138639, color = 'lightblue', linestyle = '-', label = "Last job day 3")

if (comparaison != "Nb_scheduled_jobs"):
	plt.legend(loc = 'upper left')

filename = "plot/" + title + ".pdf"

# ~ plt.figure.savefig(filename)
plt.savefig(filename)
