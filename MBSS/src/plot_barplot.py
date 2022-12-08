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

font_size = 14

title = workload + "_" + comparaison + "_" + cluster

if (percentages_mode == 0 or percentages_mode == 3 or percentages_mode == 4):	
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
	elif (comparaison == "Number_of_data_reuse"):
		Y_index = 25
		plot_title = "Number of data re-use"
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
	elif (comparaison == "Number_of_data_reuse"):
		# ~ Y_index = 5
		# ~ plot_title = "Mean Bounded Stretch"
		exit(1)
	else:
		print("Wrong comparison")
		exit(1)

df = pd.DataFrame(data)

X = list(df.iloc[:, 0])
Y = list(df.iloc[:, Y_index])

# Pour renommer les algos
if (percentages_mode == 0 or percentages_mode == 3 or percentages_mode == 4):
	X[0] = "FCFS"
	X[1] = "FCFS-BF"
	X[2] = "EFT"
	X[3] = "EFT-BF"
	X[4] = "LEA"
	X[5] = "LEA-BF"
	X[6] = "LEO"
	X[7] = "LEO-BF"
	X[8] = "LEM"
	X[9] = "LEM-BF"
else: # Cas pourcentage amélioration
	X[0] = "EFT"
	X[1] = "LEA"
	X[2] = "LEO"
	X[3] = "LEM"
	
# Pour afficher toutes les strats faire 4 en percentages_mode
# ~ plt.bar(X, Y[0, 2, 4], color=["red", "green", "darkblue", "lightblue", "magenta", "yellow", "orange", "pink", "purple", "grey", "dodgerblue", "gold", "deeppink", "saddlebrown", "beige", "darkolivegreen", "black", "red", "red", "red", "orange", "orange", "orange", "orange", "orange"])
# ~ if (comparaison == "Number_of_data_reuse"):
	# ~ plt.bar(X, int(sys.argv[7]), color="lightgray", hatch="-", edgecolor="white")

plt.rcParams['hatch.linewidth'] = 5

# Pour diviser en 2 BF/NON BF
if (percentages_mode == 0): # Non BF
	Y_non_bf = [Y[2*i] for i in range(len(Y)//2)]
	X_non_bf = [X[2*i] for i in range(len(X)//2)]
	if (comparaison == "Number_of_data_reuse"):
		plt.bar(X_non_bf, int(sys.argv[7]), color="lightgray", hatch="-", edgecolor="white")
	plt.bar(X_non_bf, Y_non_bf, color=["#4c0000","#E50000","#00bfff","#ff9b15","#91a3b0"])
elif (percentages_mode == 3): # BF
	Y_bf = [Y[2*i+1] for i in range(len(Y)//2)]
	X_bf = [X[2*i+1] for i in range(len(X)//2)]
	if (comparaison == "Number_of_data_reuse"):
		plt.bar(X_bf, int(sys.argv[7]), color="lightgray", hatch="-", edgecolor="white")
	plt.bar(X_bf, Y_bf, color=["#4c0000","#E50000","#00bfff","#ff9b15","#91a3b0"], hatch="/", edgecolor="white")
elif (percentages_mode == 4): # BF and NON BF on same plot
	if (comparaison == "Number_of_data_reuse"):
		plt.bar(X, int(sys.argv[7]), color="lightgray", hatch="-", edgecolor="white")
	# ~ hatches = ['','/','','/','','/','','/','','/']
	hatches = ['','.','','.','','.','','.','','.']
	colors=["#4c0000","#4c0000","#E50000","#E50000","#00bfff","#00bfff","#ff9b15","#ff9b15","#91a3b0","#91a3b0"]
	print(hatches)
	for i in range(len(X)):
		# ~ plt.bar(X[i], Y[i], color=colors[i], hatch=hatches[i], edgecolor="white")
		plt.scatter(X[i], Y[i], color=colors[i], hatch=hatches[i], edgecolor="white", s=220)
else:
	plt.bar(X, Y, color=["#E50000","#00bfff","#ff9b15","#91a3b0"])



# ~ plt.xticks(rotation=90)
# ~ plt.title(plot_title)
# ~ plt.xlabel("Scheduler")
	
if (percentages_mode == 0 or percentages_mode == 3 or percentages_mode == 4):
	print("Print", plot_title)
	print(Y)
	if (comparaison == "Nb_Upgraded_Jobs"):
		plt.ylabel("Number of upgraded jobs")
	elif (comparaison == "Mean_Stretch"):
		plt.axhline(y = 1, color = 'black', linestyle = "dotted", linewidth=2)
		plt.ylabel("Mean stretch")
	elif (comparaison == "Number_of_data_reuse"):
		plt.ylabel("Number of jobs re-using a file")
	else:
		plt.ylabel("Seconds")
elif (percentages_mode == 1):
	print("Print speedup compared to FCFS")
	# ~ print(Y)
	plt.ylabel("Speedup compared to FCFS")
	plt.axhline(y = 1, color = 'black', linestyle = "dotted")
elif (percentages_mode == 2):
	print("Print speedup compared to FCFS BF")
	# ~ print(Y)
	plt.ylabel("Speedup compared to FCFS with BF")
	plt.axhline(y = 1, color = 'black', linestyle = "dotted")
  
# Show the plot
if (skip_row == 1):
	filename = "plot/" + title + "_skip_maximum_use.pdf"
else:	
	if (percentages_mode == 3):
		filename = "plot/BF_" + title + ".pdf"
	elif (percentages_mode == 4):
		filename = "plot/BF_AND_NON_BF_" + title + ".pdf"
	else:
		filename = "plot/" + title + ".pdf"
plt.savefig(filename, bbox_inches='tight')

