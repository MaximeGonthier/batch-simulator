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

title = workload + "_" + comparaison + "_" + cluster

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

df = pd.DataFrame(data)
  
X = list(df.iloc[:, 0])
Y = list(df.iloc[:, Y_index])
  
# Plot the data using bar() method
plt.bar(X, Y, color=["red", "green", "blue", "yellow", "cyan", "magenta", "orange", "pink", "purple", "grey", "dodgerblue", "gold", "deeppink", "saddlebrown", "beige", "darkolivegreen", "black", "red", "red", "red", "orange", "orange", "orange", "orange", "orange"])
# ~ plt.bar(X, Y)
# ~ plt.bar(X, Y)
plt.xticks(rotation=90)
plt.title(plot_title)
plt.xlabel("Scheduler")
plt.ylabel("Seconds")
  
# Show the plot
# ~ plt.show()
if (skip_row == 1):
	filename = "plot/" + title + "_skip_maximum_use.pdf"
else:	
	filename = "plot/" + title + ".pdf"
# ~ plt.figure.savefig(filename)
plt.savefig(filename, bbox_inches='tight')
