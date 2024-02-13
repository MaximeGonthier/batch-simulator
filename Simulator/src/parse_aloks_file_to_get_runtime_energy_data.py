# python3 parse_aloks_file_to_get_runtime_energy_data.py alok's_input_file
# python3 Simulator/src/parse_aloks_file_to_get_runtime_energy_data.py ../Chicago/Alok/sebs_task_energy.csv > sebs_task_energy_parsed.txt

import sys
import pandas as pd

input_file = sys.argv[1]

print("Alok's input file:", input_file)

number_jobs_computed_before_credit_expiration = [0]*3 # First tab cell is for user 0 then 1, etc...

data = pd.read_csv(input_file)
df=pd.DataFrame(data)

Application_name = list(df.iloc[:, 8])
Nlines = len(Application_name) # Number of lines in the file without the header
Endpoint_used = list(df.iloc[:, 16])
Endpoint_status = list(df.iloc[:, 12]) # WARM or WARMING, need to ignore WARMING
Energy = list(df.iloc[:, 13])
Runtime = list(df.iloc[:, 14])

nruns = 0
total_energy = 0
total_runtime = 0
current_application_name = ""
current_endpoint = ""
for i in range(0, Nlines):
	if (current_application_name != Application_name[i]):
		if (current_application_name != ""):
			print(current_application_name, "-", current_endpoint, "-", total_energy/nruns, "-", total_runtime/nruns)
		current_application_name = Application_name[i]
		current_endpoint = Endpoint_used[i]
		nruns = 0
		total_energy = 0
		total_runtime = 0
	if (Endpoint_status[i] == "WARM" or (Endpoint_status[i] == "WARMING" and current_application_name == "graph_mst" and current_endpoint == "theta") or (Endpoint_status[i] == "WARMING" and current_application_name == "graph_bfs" and current_endpoint == "midway")): # Special cases with the ands because in some cases it's only WARMING and never WARM
		total_energy += Energy[i]
		total_runtime += Runtime[i]
		nruns += 1
# Printing the last read values
print(current_application_name, "-", current_endpoint, "-", total_energy/nruns, "-", total_runtime/nruns)


# ~ print("number_jobs_computed_before_credit_expiration:", number_jobs_computed_before_credit_expiration)

# ~ # Settings of the plot
# ~ bar_width = 0.2
# ~ separation_between_bars=0.4
# ~ x = [1*separation_between_bars, 2*separation_between_bars, 3*separation_between_bars, 4*separation_between_bars]
