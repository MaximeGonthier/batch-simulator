# python3 plot_finish_time.py input_file nusers output_name

import sys
import pandas as pd
import matplotlib.pyplot as plt

input_file = sys.argv[1]
nusers = int(sys.argv[2])
output_name = sys.argv[3]
mode = sys.argv[4] # Between finish times or energy consumed

print("Plotting", mode, "with input file", input_file, "and", nusers, "users")

data = pd.read_csv(input_file)
df=pd.DataFrame(data)
print(data)

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
	Evaluated_column_Y = list(sorted_df.iloc[:, 8]) # Core hours used
elif mode == "energy_consumed":
	Evaluated_column_Y = list(sorted_df.iloc[:, 7]) # Energy used in watt hours
elif mode == "finish_times_core_hours_Y_axis_energy_consumed_X_axis":
	Evaluated_column_Y = list(sorted_df.iloc[:, 8]) # Core hours used
	Evaluated_column_X = list(sorted_df.iloc[:, 7]) # Energy used in watt hours
	
# Settings of the plot
width = 2
colors = ["#00a1de", "#009b3a", "#c60c30", "#f9461c", "#e27ea6", "#f9e300", "#62361b", "#522398"]

# Getting the data for each user and plotting it's results
for i in range (0, nusers):
	X = []
	Y = []
	evaluated_metric_Y = 0
	evaluated_metric_X = 0
	submission_order = 0
	for j in range(0, Nlines):
		if (User_id[j] == i):
			if (New_credit[j] > 0 and mode == "finish_times"):
				evaluated_metric_Y += 1
				X.append(Job_end_time[j])
				Y.append(evaluated_metric_Y)
			elif (New_credit[j] > 0 and mode == "finish_times_submission_order_X_axis"):
				evaluated_metric_Y += 1
				X.append(submission_order)
				Y.append(evaluated_metric_Y)
			elif (New_credit[j] > 0 and mode == "finish_times_core_hours_Y_axis"):
				evaluated_metric_Y += Evaluated_column_Y[j]
				X.append(Job_end_time[j])
				Y.append(evaluated_metric_Y)
			elif mode == "energy_consumed":
				evaluated_metric_Y += Evaluated_column_Y[j]
				X.append(Job_end_time[j])
				Y.append(evaluated_metric_Y)
			# ~ elif New_credit[j] > 0 and mode == "finish_times_core_hours_Y_axis_energy_consumed_X_axis":
			elif mode == "finish_times_core_hours_Y_axis_energy_consumed_X_axis":
				evaluated_metric_Y += Evaluated_column_Y[j]
				evaluated_metric_X += Evaluated_column_X[j]
				X.append(evaluated_metric_X)
				Y.append(evaluated_metric_Y)
		submission_order += 1
	plt.plot(X, Y, color=colors[i], linewidth=width)

if mode == "finish_times":
	plt.axhline(y=(Nlines/nusers), color='black', linestyle="dotted", linewidth=width)  # Total number of jobs given to each user

# Legend and labels
if mode == "finish_times":
	plt.ylabel("Number of jobs completed")
	plt.xlabel("Completion Time (s)")
elif mode == "finish_times_core_hours_Y_axis":
	plt.ylabel("Number of core-hours used")
	plt.xlabel("Completion Time (s)")
elif mode == "energy_consumed":
	plt.ylabel("Total energy used (Watt-hours) even after end of credit")
	plt.xlabel("Completion Time (s)")
elif mode == "finish_times_core_hours_Y_axis_energy_consumed_X_axis":
	plt.ylabel("Core-hours")
	plt.xlabel("Watt-hours")
	
plt.legend(['Credit', 'Energy', 'EFT', 'Random', 'Worst', 'Theta', 'Midway', 'Faster'], ncol=4, loc=(-0.022, -0.3))

# Saving plots
# ~ if mode == "finish_times":
	# ~ filename = "plot/" + output_name + "_finish_times.pdf"
# ~ elif mode == "finish_times_core_hours_Y_axis":
	# ~ filename = "plot/" + output_name + "_finish_times_core_hours_Y_axis.pdf"
# ~ elif mode == "energy_consumed":
filename = "plot/" + output_name + "_" + mode + ".pdf"

# ~ fig.set_size_inches(7, 3) # To resize
plt.savefig(filename, bbox_inches='tight')
