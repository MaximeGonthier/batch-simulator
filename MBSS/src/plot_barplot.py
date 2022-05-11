# importing package
import matplotlib.pyplot as plt
import pandas as pd
import sys

data = pd.read_csv("outputs/Results_" + sys.argv[1] + ".csv")
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
else:
	print("Wrong comparison")
	exit(1)

df = pd.DataFrame(data)
  
X = list(df.iloc[:, 0])
Y = list(df.iloc[:, Y_index])
  
# Plot the data using bar() method
# ~ plt.bar(X, Y, color=["red", "green", "blue", "yellow", "cyan", "magenta"])
plt.bar(X, Y, color=["red", "green", "blue", "yellow", "cyan", "magenta", "orange", "pink", "purple", "grey", "dodgerblue"])
plt.xticks(rotation=60)
plt.title(plot_title)
plt.xlabel("Scheduler")
plt.ylabel("Seconds")
  
# Show the plot
# ~ plt.show()

filename = "plot/" + title + ".pdf"
# ~ plt.figure.savefig(filename)
plt.savefig(filename, bbox_inches='tight')
