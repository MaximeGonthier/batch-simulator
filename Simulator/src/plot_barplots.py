# python3 plot_barplots.py input_file nusers output_name
# The input file look like this: Job_unique_id, Job_shared_id, User_id, Selected_endpoint, Credit_lost, New_credit, Job_end_time, Energy_used_watt_hours

import sys
import pandas as pd
import matplotlib.pyplot as plt

input_file = sys.argv[1]
nusers = int(sys.argv[2])
output_name = sys.argv[3]
mode = sys.argv[4] # Either plotting total energy consumed or number of jobs computed

measured_metric = [0]*nusers # First tab cell is for user 0 then 1, etc...

data = pd.read_csv(input_file)
df=pd.DataFrame(data)

Job_shared_id = list(df.iloc[:, 1])
Nlines = len(Job_shared_id) # Number of lines in the file without the header
User_id = list(df.iloc[:, 2])
New_credit = list(df.iloc[:, 5])
Energy_used = list(df.iloc[:, 7])

if mode == "total_energy":
	for i in range(0, Nlines):
		measured_metric[User_id[i]] += Energy_used[i]
elif mode == "nb_jobs_completed":
	for i in range(0, Nlines):
		if (New_credit[i] >= 0):
			measured_metric[User_id[i]] += 1
else:
	print("ERROR: Wrong mode in plot_batrplots.py")

# ~ print("number_jobs_computed_before_credit_expiration:", number_jobs_computed_before_credit_expiration)

# Settings of the plot
bar_width = 0.2
separation_between_bars=0.3
x = [1*separation_between_bars, 2*separation_between_bars, 3*separation_between_bars, 4*separation_between_bars, 5*separation_between_bars, 6*separation_between_bars, 7*separation_between_bars, 8*separation_between_bars]
colors = ["#00a1de", "#009b3a", "#c60c30", "#62361b", "#e27ea6", "#f9e300", "#f9461c", "#522398"]

# Barplot
for i in range (0, nusers):
	plt.bar((i+1)*separation_between_bars, measured_metric[i], bar_width, color=colors[i])

# Legend and labels
# ~ labels = ['Credit', 'Energy', 'Earliest Finish Time (EFT)', 'Random'] 
labels = ['Credit', 'Energy', 'EFT', 'Random', 'Worst', 'Theta', 'Midway', 'Faster'] 
plt.xticks(x, labels, rotation ='horizontal')

if mode == "total_energy":
	plt.ylabel("Energy consumed (watt-hours) even after credit exp")
	mode_name = "_energy_used"
elif mode == "nb_jobs_completed":
	plt.ylabel("Number of jobs computed before credit expiration")
	mode_name = "_nb_jobs_completed"
	
plt.locator_params(axis='y', nbins=4, integer=True) 
plt.xlabel("User behavior")

# Saving plots
filename = "plot/" + output_name + mode_name + "_barplot.pdf"
# ~ fig.set_size_inches(7, 3) # To resize
plt.savefig(filename, bbox_inches='tight')
