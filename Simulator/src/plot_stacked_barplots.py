# import necessary libraries
import pandas as pd
import sys
import matplotlib.pyplot as plt
import seaborn as sns

sns.set_theme(style='whitegrid', context='paper', font_scale=1.75, rc={'axes.facecolor': 'white', 'figure.figsize':(7,4)})

input_file = sys.argv[1]
nusers = int(sys.argv[2])
output_name = sys.argv[3]
mode = sys.argv[4]
n_iteration = int(sys.argv[5])
credit_or_carbon = sys.argv[6]

hatch_style = ""
if credit_or_carbon == "carbon":
	hatch_style = "//"

nmachines = 4

measured_metric_0 = [0]*nmachines 
measured_metric_1 = [0]*nmachines 
measured_metric_2 = [0]*nmachines
measured_metric_3 = [0]*nmachines 
measured_metric_4 = [0]*nmachines 
measured_metric_5 = [0]*nmachines 
measured_metric_6 = [0]*nmachines 
measured_metric_7 = [0]*nmachines 
measured_metric_8 = [0]*nmachines
measured_metric_9 = [0]*nmachines 

# ~ Job_unique_id, Job_shared_id, User_id, Selected_endpoint, Credit_lost, New_credit, Job_end_time, Energy_used_watt_hours, Number_of_cores_hours_used, Queue_time, Mean_duration_on_machines, Number_of_cores_used
# ~ 336, 0, 0, 2, 0.034658, 1199.965342, 1.278849, 0.007840, 0.006039, 0.000000, 9.716979, 17

for j in range(1, n_iteration+1):
	if n_iteration > 1:
		input_file_iteration_i = input_file[:-4] + "_" + str(j) + ".csv"
	else:
		input_file_iteration_i = input_file[:-4] + ".csv"

	data = pd.read_csv(input_file_iteration_i)
	df = pd.DataFrame(data)
	
	User_id = list(df.iloc[:, 2])
	Selected_endpoint = list(df.iloc[:, 3])
	Nlines = len(User_id) # Number of lines in the file without the header
	New_credit = list(df.iloc[:, 5])
	Energy_used = list(df.iloc[:, 7])
	Queue_time = list(df.iloc[:, 9])
	Mean_completion_time = list(df.iloc[:, 10])
	Number_of_cores_used = list(df.iloc[:, 11])

	for i in range(0, Nlines):
		# ~ measured_metric[Selected_endpoint[i]][User_id[i]] += Mean_completion_time[i]
		if (User_id[i] == 0):
			measured_metric_0[Selected_endpoint[i]] += 1
		elif (User_id[i] == 1):
			measured_metric_1[Selected_endpoint[i]] += 1
		elif (User_id[i] == 2):
			measured_metric_2[Selected_endpoint[i]] += 1
		elif (User_id[i] == 3):
			measured_metric_3[Selected_endpoint[i]] += 1
		elif (User_id[i] == 4):
			measured_metric_4[Selected_endpoint[i]] += 1
		elif (User_id[i] == 5):
			measured_metric_5[Selected_endpoint[i]] += 1
		elif (User_id[i] == 6):
			measured_metric_6[Selected_endpoint[i]] += 1
		elif (User_id[i] == 7):
			measured_metric_7[Selected_endpoint[i]] += 1
		elif (User_id[i] == 8):
			measured_metric_8[Selected_endpoint[i]] += 1
		elif (User_id[i] == 9):
			measured_metric_9[Selected_endpoint[i]] += 1
		
for i in range(0, nmachines):
	measured_metric_0[i] = measured_metric_0[i]/1000
	measured_metric_1[i] = measured_metric_1[i]/1000
	measured_metric_2[i] = measured_metric_2[i]/1000
	measured_metric_3[i] = measured_metric_3[i]/1000
	measured_metric_4[i] = measured_metric_4[i]/1000
	measured_metric_5[i] = measured_metric_5[i]/1000
	measured_metric_6[i] = measured_metric_6[i]/1000
	measured_metric_7[i] = measured_metric_7[i]/1000
	measured_metric_8[i] = measured_metric_8[i]/1000
	measured_metric_9[i] = measured_metric_9[i]/1000
	
	measured_metric_0[i] = measured_metric_0[i]/n_iteration
	measured_metric_1[i] = measured_metric_1[i]/n_iteration
	measured_metric_2[i] = measured_metric_2[i]/n_iteration
	measured_metric_3[i] = measured_metric_3[i]/n_iteration
	measured_metric_4[i] = measured_metric_4[i]/n_iteration
	measured_metric_5[i] = measured_metric_5[i]/n_iteration
	measured_metric_6[i] = measured_metric_6[i]/n_iteration
	measured_metric_7[i] = measured_metric_7[i]/n_iteration
	measured_metric_8[i] = measured_metric_8[i]/n_iteration
	measured_metric_9[i] = measured_metric_9[i]/n_iteration
	
print(measured_metric_0[3])
print(measured_metric_0[0]+measured_metric_0[1]+measured_metric_0[2]+measured_metric_0[3])
# create DataFrame
# ~ df = pd.DataFrame({'Theta': [measured_metric_0[0], measured_metric_1[0], measured_metric_2[0], measured_metric_3[0], measured_metric_4[0], measured_metric_5[0], measured_metric_6[0], measured_metric_7[0], measured_metric_8[0]],
                   # ~ 'IC': [measured_metric_0[1], measured_metric_1[1], measured_metric_2[1], measured_metric_3[1], measured_metric_4[1], measured_metric_5[1], measured_metric_6[1], measured_metric_7[1], measured_metric_8[1]],
                   # ~ 'Desktop': [measured_metric_0[2], measured_metric_1[2], measured_metric_2[2], measured_metric_3[2], measured_metric_4[2], measured_metric_5[2], measured_metric_6[2], measured_metric_7[2], measured_metric_8[2]],
                   # ~ 'Faster': [measured_metric_0[3], measured_metric_1[3], measured_metric_2[3], measured_metric_3[3], measured_metric_4[3], measured_metric_5[3], measured_metric_6[3], measured_metric_7[3], measured_metric_8[3]]},
                  # ~ index=["Credit", "Energy", "EFT", "Random", "Worst", "Theta", "IC", "Faster", "Mixed"])
df = pd.DataFrame({'Theta': [measured_metric_0[0], measured_metric_1[0], measured_metric_8[0], measured_metric_2[0], measured_metric_9[0]],
                   'IC': [measured_metric_0[1], measured_metric_1[1], measured_metric_8[1], measured_metric_2[1], measured_metric_9[1]],
                   'Desktop': [measured_metric_0[2], measured_metric_1[2], measured_metric_8[2], measured_metric_2[2], measured_metric_9[2]],
                   'FASTER': [measured_metric_0[3], measured_metric_1[3], measured_metric_8[3], measured_metric_2[3], measured_metric_9[3]]},
                  index=["Greedy", "Energy", "Mixed", "EFT", "Runtime"])

# Plot settings
colors = ["#5875A4", "#CC8963", "#5F9E6E", "#B55D60"]

# create stacked bar chart for monthly temperatures
df.plot(kind='bar', stacked=True, color=colors, hatch=hatch_style)

# labels for x & y axis
# ~ plt.locator_params(axis='y', nbins=4, integer=True) 
# ~ plt.xlabel('Policy')
plt.ylabel('Thoushands of jobs')
plt.xticks(rotation=360)

plt.legend(['Theta', 'IC', 'Desktop', 'FASTER'], ncol=4, loc=(-0.1, -0.32))

# Saving plot
mode_name = ""
filename = "plot/" + output_name + mode_name + "_stacked_barplot.pdf"
plt.savefig(filename, bbox_inches='tight')
