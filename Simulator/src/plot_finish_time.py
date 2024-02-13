# python3 plot_finish_time.py input_file nusers output_name

import sys
import pandas as pd
import matplotlib.pyplot as plt

input_file = sys.argv[1]
nusers = int(sys.argv[2])
output_name = sys.argv[3]

print("Plotting finish times with input file", input_file, "and", nusers, "users")

data = pd.read_csv(input_file)
df=pd.DataFrame(data)
print(data)
sorted_df = df.sort_values(by=' Job_end_time') # Sort by end time to easily count when each job has finished

User_id = list(sorted_df.iloc[:, 2])
Nlines = len(User_id) # Number of lines in the file without the header
New_credit = list(sorted_df.iloc[:, 5])
Job_end_time = list(sorted_df.iloc[:, 6])

# Credit
X_credit = []
Y_credit = []
number_job_completed_at_that_time = 0
for i in range(0, Nlines):
	if (User_id[i] == 0):
		if (New_credit[i] > 0):
			number_job_completed_at_that_time += 1
			X_credit.append(Job_end_time[i])
			Y_credit.append(number_job_completed_at_that_time)
			
# Energy
X_energy = []
Y_energy = []
number_job_completed_at_that_time = 0
for i in range(0, Nlines):
	if (User_id[i] == 1):
		if (New_credit[i] > 0):
			number_job_completed_at_that_time += 1
			X_energy.append(Job_end_time[i])
			Y_energy.append(number_job_completed_at_that_time)

# EFT
X_eft = []
Y_eft = []
number_job_completed_at_that_time = 0
for i in range(0, Nlines):
	if (User_id[i] == 2):
		if (New_credit[i] > 0):
			number_job_completed_at_that_time += 1
			X_eft.append(Job_end_time[i])
			Y_eft.append(number_job_completed_at_that_time)

# Random
X_random = []
Y_random = []
number_job_completed_at_that_time = 0
for i in range(0, Nlines):
	if (User_id[i] == 3):
		if (New_credit[i] > 0):
			number_job_completed_at_that_time += 1
			X_random.append(Job_end_time[i])
			Y_random.append(number_job_completed_at_that_time)

# Settings of the plot
width = 2

# Plot
plt.plot(X_credit, Y_credit, color='blue', linewidth=width) 
plt.plot(X_energy, Y_energy, color='green', linewidth=width) 
plt.plot(X_eft, Y_eft, color='red', linewidth=width) 
plt.plot(X_random, Y_random, color='orange', linewidth=width) 
plt.axhline(y=(Nlines/nusers), color='black', linestyle="dotted", linewidth=width)  # Total number of jobs given to each user


# Legend and labels
# ~ labels = ['Credit', 'Energy', 'Earliest Finish Time (EFT)', 'Random'] 
# ~ plt.xticks(x, labels, rotation ='horizontal') 
plt.ylabel("Number of jobs completed")
# ~ plt.locator_params(axis='y', nbins=10, integer=True) 
# ~ plt.locator_params(axis='x', nbins=10, integer=True) 
plt.xlabel("Time (s)")
plt.legend(["Credit", "Energy", "Earliest Finish Time (EFT)", "Random"], ncol=4, loc=(-0.022, -0.2))

# Saving plots
filename = "plot/" + output_name + "_finish_times.pdf"
# ~ fig.set_size_inches(7, 3) # To resize
plt.savefig(filename, bbox_inches='tight')
