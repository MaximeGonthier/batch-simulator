# python3 plot_barplots.py input_file nusers output_name
# The input file look like this: Job_unique_id, Job_shared_id, User_id, Selected_endpoint, Credit_lost, New_credit, Job_end_time, Energy_used_watt_hours

import sys
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

sns.set_style('darkgrid', {'axes.facecolor': '.9'})
sns.set_context("paper")

input_file = sys.argv[1]
nusers = int(sys.argv[2])
output_name = sys.argv[3]
mode = sys.argv[4] # Either plotting total energy consumed or number of jobs computed
n_iteration = int(sys.argv[5])
credit_or_carbon = sys.argv[6]

hatch_style = ""
if credit_or_carbon == "carbon":
	hatch_style = "//"


measured_metric = [0]*nusers # First tab cell is for user 0 then 1, etc...

print("Plotting", mode, "with input file", input_file, "and", nusers, "users", n_iteration, "iterations")

for j in range(1, n_iteration+1):
	
	if n_iteration > 1:
		input_file_iteration_i = input_file[:-4] + "_" + str(j) + ".csv"
	else:
		input_file_iteration_i = input_file[:-4] + ".csv"

	data = pd.read_csv(input_file_iteration_i)
	df=pd.DataFrame(data)

	Job_shared_id = list(df.iloc[:, 1])
	Nlines = len(Job_shared_id) # Number of lines in the file without the header
	# ~ print("Nlines:", Nlines)
	User_id = list(df.iloc[:, 2])
	New_credit = list(df.iloc[:, 5])
	Energy_used = list(df.iloc[:, 7])
	Queue_time = list(df.iloc[:, 9])
	Mean_completion_time = list(df.iloc[:, 10])
	Number_of_cores_used = list(df.iloc[:, 11])
	Carbon_used = list(df.iloc[:, 12])

	if mode == "total_energy":
		for i in range(0, Nlines):
			measured_metric[User_id[i]] += Energy_used[i]/1000
	elif mode == "queue_time":
		for i in range(0, Nlines):
			measured_metric[User_id[i]] += Queue_time[i]
	elif mode == "carbon_used":
		for i in range(0, Nlines):
			measured_metric[User_id[i]] += Carbon_used[i]/1000
	elif mode == "nb_jobs_completed":
		for i in range(0, Nlines):
			if (New_credit[i] >= 0):
				measured_metric[User_id[i]] += 1
	elif mode == "nb_jobs_completed_in_mean_core_hours":
		for i in range(0, Nlines):
			if (New_credit[i] >= 0):
				measured_metric[User_id[i]] += (Mean_completion_time[i]/3600)*Number_of_cores_used[i]
	else:
		print("ERROR: Wrong mode in plot_batrplots.py")
		
for j in range(0, nusers):
	measured_metric[j] = measured_metric[j]/n_iteration

# Settings of the plot
bar_width = 0.2
separation_between_bars=0.3

# ~ x = [1*separation_between_bars, 2*separation_between_bars, 3*separation_between_bars, 4*separation_between_bars, 5*separation_between_bars, 6*separation_between_bars, 7*separation_between_bars, 8*separation_between_bars, 9*separation_between_bars]
# ~ x = [1*separation_between_bars, 2*separation_between_bars, 3*separation_between_bars, 4*separation_between_bars, 5*separation_between_bars, 6*separation_between_bars, 7*separation_between_bars, 8*separation_between_bars, 9*separation_between_bars, 10*separation_between_bars]
# ~ colors = ["#00a1de", "#009b3a", "#c60c30", "#62361b", "#e27ea6", "#f9e300", "#f9461c", "#522398", "#123456"]
# ~ colors = ["#00a1de", "#009b3a", "#c60c30", "#62361b", "#e27ea6", "#f9e300", "#f9461c", "#020202", "#522398", "#123456"]

# Not plotting Random and Worst and the 3 machines
if mode == "total_energy" or mode == "carbon_used":
	x = [1*separation_between_bars, 2*separation_between_bars, 3*separation_between_bars, 4*separation_between_bars]
	colors = ["#00a1de", "#009b3a", "#c60c30", "#f9461c"]
else: # Not plotting Random and Worst
	x = [1*separation_between_bars, 2*separation_between_bars, 3*separation_between_bars, 4*separation_between_bars, 5*separation_between_bars, 6*separation_between_bars, 7*separation_between_bars]
	colors = ["#00a1de", "#009b3a", "#c60c30", "#f9461c", "#e27ea6", "#f9e300", "#62361b"]

# ~ for i in range (0, nusers):
	# ~ plt.bar((i+1)*separation_between_bars, measured_metric[i], bar_width, color=colors[i])

# Not plotting Random and Worst and the 3 machines
if mode == "total_energy" or mode == "carbon_used":
	i = 0
	plt.bar((i+1)*separation_between_bars, measured_metric[0], bar_width, color=colors[i], hatch=hatch_style)
	i = 1
	plt.bar((i+1)*separation_between_bars, measured_metric[1], bar_width, color=colors[i], hatch=hatch_style)
	i = 2 # Putting mixed after energy
	plt.bar((i+1)*separation_between_bars, measured_metric[8], bar_width, color=colors[i], hatch=hatch_style)
	i = 3
	plt.bar((i+1)*separation_between_bars, measured_metric[2], bar_width, color=colors[i], hatch=hatch_style)
else:
	i = 0
	plt.bar((i+1)*separation_between_bars, measured_metric[0], bar_width, color=colors[i], hatch=hatch_style)
	i = 1
	plt.bar((i+1)*separation_between_bars, measured_metric[1], bar_width, color=colors[i], hatch=hatch_style)
	i = 2 # Putting mixed after energy
	plt.bar((i+1)*separation_between_bars, measured_metric[8], bar_width, color=colors[i], hatch=hatch_style)
	i = 3
	plt.bar((i+1)*separation_between_bars, measured_metric[2], bar_width, color=colors[i], hatch=hatch_style)
	i = 4
	plt.bar((i+1)*separation_between_bars, measured_metric[5], bar_width, color=colors[i], hatch=hatch_style) # Not plotting random and worst
	i = 5
	plt.bar((i+1)*separation_between_bars, measured_metric[6], bar_width, color=colors[i], hatch=hatch_style)
	i = 6
	plt.bar((i+1)*separation_between_bars, measured_metric[7], bar_width, color=colors[i], hatch=hatch_style)

# Legend and labels
# ~ labels = ['Credit', 'Energy', 'EFT', 'Random', 'Worst', 'Theta', 'IC', 'Faster', 'Mixed'] 
# ~ labels = ['Credit', 'Energy', 'EFT', 'Random', 'Worst', 'Theta', 'IC', 'Desktop', 'Faster', 'Mixed']

if mode == "queue_time":
	plt.ylim(0, measured_metric[5]/4)
	
# Not plotting Random and Worst
if mode == "total_energy" or mode == "carbon_used":
	labels = ['Credit', 'Energy', 'Mixed', 'EFT']
else: 
	labels = ['Credit', 'Energy', 'Mixed', 'EFT', 'Theta', 'IC', 'Faster'] 

plt.xticks(x, labels, rotation ='horizontal')

if mode == "total_energy":
	plt.ylabel("Energy consumed over full workload (KWh)")
	mode_name = "_energy_used"
elif mode == "nb_jobs_completed":
	plt.ylabel("Number of jobs completed")
	mode_name = "_nb_jobs_completed"
elif mode == "nb_jobs_completed_in_mean_core_hours":
	plt.ylabel("Mean core-hours completed")
	mode_name = "_nb_jobs_completed_in_mean_core_hours"
elif mode == "queue_time":
	plt.ylabel("Total queue time full workload (s)")
	mode_name = "_queue_time"
elif mode == "carbon_used":
	plt.ylabel("Total carbon consumed (kgCO2)")
	mode_name = "_carbon_used"
	
# Control grid on Y-axis
# ~ plt.locator_params(axis='y', nbins=4, integer=True)

plt.xlabel("User behavior")

# Saving plots
filename = "plot/" + output_name + mode_name + "_barplot.pdf"
plt.savefig(filename, bbox_inches='tight')
