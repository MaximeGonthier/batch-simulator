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
sorted_df = df.sort_values(by=' Job_end_time') # Sort by end time to easily count when each job has finished

User_id = list(sorted_df.iloc[:, 2])
Nlines = len(User_id) # Number of lines in the file without the header
New_credit = list(sorted_df.iloc[:, 5])
Job_end_time = list(sorted_df.iloc[:, 6])

Evaluated_column = []
evaluated_metric= 0

if mode == "finish_times":
	Evaluated_column = list(sorted_df.iloc[:, 6])
elif mode == "energy_consumed":
	Evaluated_column = list(sorted_df.iloc[:, 7])
else:
	print("ERROR: Wrong mode")
	exit(1)


# Settings of the plot
width = 2
colors = ["#00a1de", "#009b3a", "#c60c30", "#f9461c", "#e27ea6", "#f9e300", "#62361b", "#522398"]

# Getting the data for each user and plotting it's results
for i in range (0, nusers):
	X = []
	Y = []
	evaluated_metric = 0
	for j in range(0, Nlines):
		if (User_id[j] == i):
			if (New_credit[j] > 0):
				if mode == "finish_times":
					evaluated_metric += 1
				elif mode == "energy_consumed":
					evaluated_metric += Evaluated_column[j]
				X.append(Job_end_time[j])
				Y.append(evaluated_metric)
	plt.plot(X, Y, color=colors[i], linewidth=width)

if mode == "finish_times":
	plt.axhline(y=(Nlines/nusers), color='black', linestyle="dotted", linewidth=width)  # Total number of jobs given to each user

# Legend and labels
if mode == "finish_times":#c60c30
	plt.ylabel("Number of jobs completed")
elif mode == "energy_consumed":
	plt.ylabel("Total energy used (Watt-hours)")
	
plt.xlabel("Time (s)")
plt.legend(['Credit', 'Energy', 'EFT', 'Random', 'Worst', 'Theta', 'Midway', 'Faster'], ncol=4, loc=(-0.022, -0.2))

# Saving plots
if mode == "finish_times":
	filename = "plot/" + output_name + "_finish_times.pdf"
elif mode == "energy_consumed":
	filename = "plot/" + output_name + "_energy_consumed.pdf"

# ~ fig.set_size_inches(7, 3) # To resize
plt.savefig(filename, bbox_inches='tight')
