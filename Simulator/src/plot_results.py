# python3 plot_results.py input_file nusers

import sys
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

input_file = sys.argv[1]
nusers = int(sys.argv[2])
output_name = "test"

print("input file", input_file, "nusers", nusers)

number_jobs_computed_before_credit_expiration = [0]*nusers # First tab cell is for user 0 then 1, etc...

data = pd.read_csv(input_file)
df=pd.DataFrame(data)
print(data)

Job_shared_id = list(df.iloc[:, 1])
Nlines = len(Job_shared_id) # Number of lines in the file without the header
User_id = list(df.iloc[:, 2])
New_credit = list(df.iloc[:, 5])
for i in range(0, Nlines):
	print(Job_shared_id[i], User_id[i], New_credit[i])
	if (New_credit[i] >= 0):
		number_jobs_computed_before_credit_expiration[User_id[i]] += 1

print("number_jobs_computed_before_credit_expiration:", number_jobs_computed_before_credit_expiration)

# Settings of the plot
bar_width = 0.2
separation_between_bars=0.4
x = [1*separation_between_bars, 2*separation_between_bars, 3*separation_between_bars, 4*separation_between_bars]

# Barplot
plt.bar(1*separation_between_bars, number_jobs_computed_before_credit_expiration[0], bar_width, color='blue') 
plt.bar(2*separation_between_bars, number_jobs_computed_before_credit_expiration[1], bar_width, color='green') 
plt.bar(3*separation_between_bars, number_jobs_computed_before_credit_expiration[2], bar_width, color='red') 
plt.bar(4*separation_between_bars, number_jobs_computed_before_credit_expiration[3], bar_width, color='orange') 

# Legend and labels
labels = ['Credit', 'Energy', 'Runtime', 'Random'] 
plt.xticks(x, labels, rotation ='horizontal') 
plt.ylabel("Number of jobs computed before credit expiration")
plt.locator_params(axis='y', nbins=4) 
plt.xlabel("User behavior")
# ~ plt.legend(["Credit", "Energy", "Runtime", "Random"], ncol=4, loc=(-0.022, -0.41))

# Saving plots
filename = "plot/" + output_name + ".pdf"
# ~ fig.set_size_inches(7, 3) # To resize
plt.savefig(filename, bbox_inches='tight')
