# python3 plot_finish_time.py input_file nusers output_name

import sys
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

sns.set_style('darkgrid', {'axes.facecolor': '.9'})
sns.set_context("paper")

input_file = sys.argv[1]
nusers = int(sys.argv[2])
output_name = sys.argv[3]
mode = sys.argv[4] # Between finish times or energy consumed
n_iteration = int(sys.argv[5])
credit_or_carbon = sys.argv[6]

# ~ if credit_or_carbon == "carbon":
	# ~ sns.set_style(rc = {'axes.facecolor': 'gray'})
line_style = "solid"
if credit_or_carbon == "carbon":
	line_style = "dashed"

print("Plotting", mode, "with input file", input_file, "and", nusers, "users")

# List of list for X and Y of each user
X = []
Y = []
for i in range (0, nusers):
	X.append([])
	Y.append([])

loop = 1

for k in range(1, loop + 1):
	if n_iteration > 1:
		input_file_iteration_i = input_file[:-4] + "_" + str(k) + ".csv"
	else:
		input_file_iteration_i = input_file[:-4] + ".csv"
	
	data = pd.read_csv(input_file_iteration_i)
	df = pd.DataFrame(data)

	if mode == "finish_times_core_hours_Y_axis_energy_consumed_X_axis" or mode == "finish_times_submission_order_X_axis":
		sorted_df = df # Don't sort
	else:
		sorted_df = df.sort_values(by=' Job_end_time') # Sort by end time to easily count when each job has finished

	User_id = list(sorted_df.iloc[:, 2])
	Nlines = len(User_id) # Number of lines in the file without the header
	New_credit = list(sorted_df.iloc[:, 5])
	Job_end_time = list(sorted_df.iloc[:, 6])

	Evaluated_column_X = []
	Evaluated_column_Y = []
	evaluated_metric_Y= 0

	if mode == "finish_times_core_hours_Y_axis":
		Evaluated_column_Y = list(sorted_df.iloc[:, 10]) # mean completion time
	elif mode == "energy_consumed":
		Evaluated_column_Y = list(sorted_df.iloc[:, 7]) # Energy used in watt hours
	elif mode == "finish_times_core_hours_Y_axis_energy_consumed_X_axis":
		Evaluated_column_Y = list(sorted_df.iloc[:, 8]) # Core hours used
		Evaluated_column_X = list(sorted_df.iloc[:, 7]) # Energy used in watt hours
		
	# Getting the data for each user and plotting it's results
	for i in range (0, nusers):
		evaluated_metric_Y = 0
		evaluated_metric_X = 0
		submission_order = 0
		for j in range(0, Nlines):
			if (User_id[j] == i):
				if (New_credit[j] > 0 and mode == "finish_times"):
					evaluated_metric_Y += 1
					X[User_id[j]].append(Job_end_time[j])
					Y[User_id[j]].append(evaluated_metric_Y)
				elif (New_credit[j] > 0 and mode == "finish_times_submission_order_X_axis"):
					evaluated_metric_Y += 1
					X[User_id[j]].append(submission_order)
					Y[User_id[j]].append(evaluated_metric_Y)
				elif (New_credit[j] > 0 and mode == "finish_times_core_hours_Y_axis"):
					evaluated_metric_Y += Evaluated_column_Y[j]
					X[User_id[j]].append(Job_end_time[j])
					Y[User_id[j]].append(evaluated_metric_Y)
				# ~ elif (New_credit[j] > 0 and mode == "energy_consumed"):
				# ~ elif (mode == "energy_consumed"):
				elif (New_credit[j] > 0 and mode == "energy_consumed"):
					evaluated_metric_Y += Evaluated_column_Y[j]/1000
					# ~ X[User_id[j]].append(Job_end_time[j])
					evaluated_metric_X += 1
					X[User_id[j]].append(evaluated_metric_X)
					Y[User_id[j]].append(evaluated_metric_Y)
				elif mode == "finish_times_core_hours_Y_axis_energy_consumed_X_axis":
					evaluated_metric_Y += Evaluated_column_Y[j]
					evaluated_metric_X += Evaluated_column_X[j]
					X[User_id[j]].append(evaluated_metric_X)
					Y[User_id[j]].append(evaluated_metric_Y)
			submission_order += 1

# Settings of the plot
width = 2

if mode == "energy_consumed" or mode == "finish_times_core_hours_Y_axis":
	colors = ["#00a1de", "#009b3a", "#c60c30", "#f9461c", "#020202"]
else: # Not plotting Random and Worst
	colors = ["#00a1de", "#009b3a", "#c60c30", "#f9461c", "#020202", "#e27ea6", "#f9e300", "#62361b"]

# ~ for i in range(0, nusers):
	# ~ plt.plot(X[i], Y[i], color=colors[i], linewidth=width)

if mode == "energy_consumed" or mode == "finish_times_core_hours_Y_axis":
	i = 0
	plt.plot(X[i], Y[i], color=colors[i], linewidth=width, linestyle=line_style)
	i = 1
	plt.plot(X[i], Y[i], color=colors[i], linewidth=width, linestyle=line_style)
	i = 2 # Putting mixed after energy
	plt.plot(X[8], Y[8], color=colors[i], linewidth=width, linestyle=line_style)
	i = 3
	plt.plot(X[2], Y[2], color=colors[i], linewidth=width, linestyle=line_style)
	i = 4
	plt.plot(X[9], Y[9], color=colors[i], linewidth=width, linestyle=line_style)
else:
	i = 0
	plt.plot(X[i], Y[i], color=colors[i], linewidth=width, linestyle=line_style)
	i = 1
	plt.plot(X[i], Y[i], color=colors[i], linewidth=width, linestyle=line_style)
	i = 2 # Putting mixed after energy
	plt.plot(X[8], Y[8], color=colors[i], linewidth=width, linestyle=line_style)
	i = 3
	plt.plot(X[2], Y[2], color=colors[i], linewidth=width, linestyle=line_style)
	i = 4
	plt.plot(X[9], Y[9], color=colors[i], linewidth=width, linestyle=line_style)
	i = 5
	plt.plot(X[5], Y[5], color=colors[i], linewidth=width, linestyle=line_style)
	i = 6
	plt.plot(X[6], Y[6], color=colors[i], linewidth=width, linestyle=line_style)
	i = 7
	plt.plot(X[7], Y[7], color=colors[i], linewidth=width, linestyle=line_style)

# ~ if mode == "finish_times":
	# ~ plt.axhline(y=(Nlines/nusers), color='black', linestyle="dotted", linewidth=width)  # Total number of jobs given to each user

# Legend and labels
if mode == "finish_times":
	plt.ylabel("Number of jobs completed")
	plt.xlabel("Completion Time (s)")
elif mode == "finish_times_core_hours_Y_axis":
	plt.ylabel("Mean core-hours completed full workload")
	plt.xlabel("Completion Time (s)")
elif mode == "energy_consumed":
	plt.ylabel("Energy used (KWh)")
	# ~ plt.xlabel("Completion Time (s)")
	plt.xlabel("Number of jobs completed")
elif mode == "finish_times_core_hours_Y_axis_energy_consumed_X_axis":
	plt.ylabel("Core-hours used full workload")
	plt.xlabel("Energy consumed full workload (Wh)")
	
if mode == "energy_consumed" or mode == "finish_times_core_hours_Y_axis":
	plt.legend(['Credit', 'Energy', 'Mixed', 'EFT', 'Runtime'], ncol=5, loc=(0.1, -0.24))
else: 
	plt.legend(['Credit', 'Energy', 'Mixed', 'EFT', 'Runtime', 'Theta', 'IC', 'Faster'], ncol=4, loc=(0.1, -0.24))

filename = "plot/" + output_name + "_" + mode + ".pdf"

plt.savefig(filename, bbox_inches='tight')
