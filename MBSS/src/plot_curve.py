# python3 src/plot_curve.py file
# importing package
import matplotlib.pyplot as plt
import pandas as pd
import sys

# ~ skip_row = int(sys.argv[4])
# ~ if (skip_row == 0):
	# ~ data = pd.read_csv(sys.argv[5])
# ~ else:
	# ~ data = pd.read_csv(sys.argv[5], skiprows=[6])
# ~ workload = sys.argv[1]
# ~ comparaison = sys.argv[2]
# ~ cluster = sys.argv[3]

# ~ title = workload + "_" + comparaison + "_" + cluster

# ~ if (comparaison == "Maximum_queue_time"):
	# ~ Y_index = 2
	# ~ plot_title = "Maximum Queue Time"
# ~ elif (comparaison == "Mean_queue_time"):
	# ~ Y_index = 3
	# ~ plot_title = "Mean Queue Time"
# ~ elif (comparaison == "Total_queue_time"):
	# ~ Y_index = 4
	# ~ plot_title = "Total Queue Time"
# ~ elif (comparaison == "Maximum_flow"):
	# ~ Y_index = 5
	# ~ plot_title = "Maximum Flow"
# ~ elif (comparaison == "Mean_flow"):
	# ~ Y_index = 6
	# ~ plot_title = "Mean Flow"
# ~ elif (comparaison == "Total_flow"):
	# ~ Y_index = 7
	# ~ plot_title = "Total Flow"
# ~ elif (comparaison == "Transfer_time"):
	# ~ Y_index = 8
	# ~ plot_title = "Transfer Time"
# ~ elif (comparaison == "Makespan"):
	# ~ Y_index = 9
	# ~ plot_title = "Makespan"
# ~ elif (comparaison == "Core_time_used"):
	# ~ Y_index = 10
	# ~ plot_title = "Core time used"
# ~ elif (comparaison == "Waiting_for_a_load_time"):
	# ~ Y_index = 11
	# ~ plot_title = "Waiting for a load time"
# ~ elif (comparaison == "Total_waiting_for_a_load_time_and_transfer_time"):
	# ~ Y_index = 12
	# ~ plot_title = "Total waiting for a load time and transfer time"
# ~ else:
	# ~ print("Wrong comparison")
	# ~ exit(1)

# ~ df = pd.DataFrame(data)
  
# ~ X = list(df.iloc[:, 0])
# ~ Y = list(df.iloc[:, Y_index])

X = []
Y = []
i = 0
j = 0
with open(sys.argv[1]) as f:
	line = f.readline()
	while line:
		# ~ r1 = line.split() 
		X.append(i)
		j += 1
		i = j*int(sys.argv[2])
		Y.append(float(line))
		line = f.readline()
f.close()


# Plot the data using bar() method
# ~ plt.bar(X, Y, color=["red", "green", "blue", "yellow", "cyan", "magenta"])
# ~ plt.bar(X, Y, color=["red", "green", "blue", "yellow", "cyan", "magenta", "orange", "pink", "purple", "grey", "dodgerblue", "gold", "deeppink", "saddlebrown", "beige", "darkolivegreen", "black", "red", "red", "red", "orange", "orange", "orange", "orange", "orange"])
# ~ plt.bar(X, Y)
# ~ plt.bar(X, Y)
# ~ plt.xticks(rotation=90)
# ~ plt.title(plot_title)
plt.plot(X, Y)
plt.yscale("log")
plt.xlabel("Multiplier_" + sys.argv[3])
plt.ylabel("Flow stretch")
  
# Show the plot
# ~ plt.show()
# ~ if (skip_row == 1):
	# ~ filename = "plot/" + title + "_skip_maximum_use.pdf"
# ~ else:	
	# ~ filename = "plot/" + title + ".pdf"
# ~ plt.figure.savefig(filename)
plt.savefig("plot.pdf", bbox_inches='tight')