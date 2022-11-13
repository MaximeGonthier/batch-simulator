# importing package
import matplotlib.pyplot as plt
import pandas as pd
import sys

skip_row = int(sys.argv[4])
if (skip_row == 0):
	data = pd.read_csv(sys.argv[5])
else:
	data = pd.read_csv(sys.argv[5], skiprows=[6])
workload = sys.argv[1]
comparaison = sys.argv[2]
cluster = sys.argv[3]

percentages_mode = int(sys.argv[6])

title = workload + "_" + comparaison + "_" + cluster

if (percentages_mode == 0):	
	if (comparaison == "Maximum_queue_time"):
		Y_index = 2
		plot_title = "Maximum Queue Time"
	elif (comparaison == "Mean_queue_time"):
		Y_index = 3
		plot_title = "Mean Queue Time"
	elif (comparaison == "Total_queue_time"):
		Y_index = 4
		plot_title = "Total Queue Time"
	elif (comparaison == "Maximum_flow"):
		Y_index = 5
		plot_title = "Maximum Flow"
	elif (comparaison == "Mean_flow"):
		Y_index = 6
		plot_title = "Mean Flow"
	elif (comparaison == "Total_flow"):
		Y_index = 7
		plot_title = "Total Flow"
	elif (comparaison == "Transfer_time"):
		Y_index = 8
		plot_title = "Transfer Time"
	elif (comparaison == "Makespan"):
		Y_index = 9
		plot_title = "Makespan"
	elif (comparaison == "Core_time_used"):
		Y_index = 10
		plot_title = "Core time used"
	elif (comparaison == "Waiting_for_a_load_time"):
		Y_index = 11
		plot_title = "Waiting for a load time"
	elif (comparaison == "Total_waiting_for_a_load_time_and_transfer_time"):
		Y_index = 12
		plot_title = "Total waiting for a load time and transfer time"
	elif (comparaison == "Mean_Stretch"):
		Y_index = 13
		plot_title = "Mean Stretch"
	elif (comparaison == "Mean_Stretch_With_a_Minimum"):
		Y_index = 14
		plot_title = "Mean Bounded Stretch"
	elif (comparaison == "Max_Stretch"):
		Y_index = 15
		plot_title = "Max Stretch"
	elif (comparaison == "Max_Stretch_With_a_Minimum"):
		Y_index = 16
		plot_title = "Max Bounded Stretch"
	elif (comparaison == "Nb_Upgraded_Jobs"):
		Y_index = 17
		plot_title = "Nb Upgraded Jobs"
	elif (comparaison == "Mean_Stretch_128"):
		Y_index = 19 # Car il y a large queue time job que je plot pas mais qui est dans la data
		plot_title = "Mean Stretch 128 jobs"
	elif (comparaison == "Mean_Stretch_256"):
		Y_index = 20
		plot_title = "Mean Stretch 256 jobs"
	elif (comparaison == "Mean_Stretch_1024"):
		Y_index = 21
		plot_title = "Mean Stretch 1024 jobs"
	elif (comparaison == "Mean_Stretch_With_a_Minimum_128"):
		Y_index = 22
		plot_title = "Mean Bounded Stretch 128 jobs"
	elif (comparaison == "Mean_Stretch_With_a_Minimum_256"):
		Y_index = 23
		plot_title = "Mean Bounded Stretch 256 jobs"
	elif (comparaison == "Mean_Stretch_With_a_Minimum_1024"):
		Y_index = 24
		plot_title = "Mean Bounded Stretch 1024 jobs"
	else:
		print("Wrong comparison")
		exit(1)
else:
	if (comparaison == "Maximum_queue_time"):
		Y_index = 1
		plot_title = "Maximum Queue Time"
	elif (comparaison == "Total_flow"):
		Y_index = 2
		plot_title = "Total Flow"
	elif (comparaison == "Total_waiting_for_a_load_time_and_transfer_time"):
		Y_index = 3
		plot_title = "Total waiting for a load time and transfer time"
	elif (comparaison == "Mean_Stretch"):
		Y_index = 4
		plot_title = "Mean Stretch"
	elif (comparaison == "Mean_Stretch_With_a_Minimum"):
		Y_index = 5
		plot_title = "Mean Bounded Stretch"
	else:
		print("Wrong comparison")
		exit(1)

df = pd.DataFrame(data)

X = list(df.iloc[:, 0])
Y = list(df.iloc[:, Y_index])
# ~ Y_percentage = list(df.iloc[:, Y_index])
# ~ ((v1-v2)/(-v2))*100 avec v2 valeur de fcfs
  
# Plot the data using bar() method
plt.bar(X, Y, color=["red", "green", "darkblue", "lightblue", "magenta", "yellow", "orange", "pink", "purple", "grey", "dodgerblue", "gold", "deeppink", "saddlebrown", "beige", "darkolivegreen", "black", "red", "red", "red", "orange", "orange", "orange", "orange", "orange"])
# ~ plt.bar(X, Y)
# ~ plt.bar(X, Y)
plt.xticks(rotation=90)
plt.title(plot_title)
plt.xlabel("Scheduler")
# ~ if (comparaison == "Nb_Upgraded_Jobs"):
	# ~ plt.ylabel("Number of upgraded jobs")
	
if (percentages_mode == 0):
	if (comparaison == "Nb_Upgraded_Jobs"):
		plt.ylabel("Number of upgraded jobs")
	elif (comparaison == "Mean_Stretch"):
		plt.ylabel("Difference ratio with a schedule on an empty cluster")
	else:
		plt.ylabel("Seconds")
# ~ elif (percentages_mode == 1):
	# ~ plt.ylabel("% difference with fcfs (the lower the better)")
# ~ elif (percentages_mode == 2):
else:
	plt.ylabel("% difference with fcfs conservative bf (the lower the better)")
  
# Show the plot
# ~ plt.show()
if (skip_row == 1):
	filename = "plot/" + title + "_skip_maximum_use.pdf"
else:	
	filename = "plot/" + title + ".pdf"
# ~ plt.figure.savefig(filename)
plt.savefig(filename, bbox_inches='tight')
