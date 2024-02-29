# Used to parse data from https://zenodo.org/records/3666632 files named emmy

# python3 src/parse_emmy_file_to_get_runtime_energy_data.py emmy_job_input_file emmy_power_input_file
# python3 src/parse_emmy_file_to_get_runtime_energy_data.py ../../ipdps20-paper-hpc-power-traces/data/cluster_characteristics/emmy/job_traces/rrze-traces-emmy-jobs-01.txt ../../ipdps20-paper-hpc-power-traces/data/cluster_characteristics/emmy/pwr_traces/rrze-traces-emmy-avg-pwr-01.txt inputs/workloads/emmy-1-raw

# Job input file look like this
# ~ 01/01/2019 00:01:33;Q;1033693.eadm;queue=route
# ~ 01/01/2019 00:01:33;Q;1033693.eadm;queue=devel
# ~ 01/01/2019 00:01:44;S;1033693.eadm Resource_List.nodes=4:ppn=40 Resource_List.walltime=00:59:00
# ~ 01/01/2019 00:28:07;E;1033693.eadm Resource_List.nodes=4:ppn=40 Resource_List.walltime=00:59:00 resources_used.walltime=00:26:03 account=e9f5a27c jobstr=362c9816

# Energy input file look like this
# ~ 1033693  average power consumption (CPU+DRAM)      :      163.7 W

import sys
import pandas as pd

job_input_file = sys.argv[1]
energy_input_file = sys.argv[2]
output_file = sys.argv[3]

get_nb_node_next_word = False
get_nb_node_next_char = False
check_next_char_for_more_than_9_nodes = False

total_number_of_jobs = 0
total_number_of_jobs_with_energy = 0

print("Job input file:", job_input_file)
print("Energy input file:", energy_input_file)

f = open(output_file, "w")
f.write("Power used per node, Job Id, Number of nodes used, Number of cores used, Requested Walltime, Runtime, Username\n")
found = False
with open(job_input_file, 'r') as file:
	for line in file:
		for word in line.split():				
			if (get_nb_node_next_word == True and found == True):
				get_nb_node_next_word = False
				for char in word:
					if check_next_char_for_more_than_9_nodes == True:
						check_next_char_for_more_than_9_nodes = False
						if (char != ":"):
							nb_nodes = nb_nodes*10 + int(char)
						print("Nb of nodes:", nb_nodes)
						f.write(str(nb_nodes) + ", ")
						print("Nb of cores:", nb_nodes*20)
						f.write(str(nb_nodes*20) + ", ")
						break
					if get_nb_node_next_char == True:
						get_nb_node_next_char = False
						if (char == "e"): # Skipping this line cause wrong value for number of nodes
							break
						check_next_char_for_more_than_9_nodes = True
						nb_nodes = int(char)
					if (char == "="):
						get_nb_node_next_char = True
			for char in word:
				if (char == "E"): # A terminated job, so getting info on number of nodes
					# ~ print(line)
					total_number_of_jobs += 1
					get_nb_node_next_word = True
					i = 11
					while word[i] != ".":
						i += 1
					job_id = word[11:i]
					found = False
					with open(energy_input_file, 'r') as file_power:
						for line_power in file_power:
							if found == True:
								break
							for word_power in line_power.split():
								if word_power == job_id:
									# ~ print(line_power)
									total_number_of_jobs_with_energy += 1
									found = True
									energy_used = line_power[len(word_power)+len("  average power consumption (CPU+DRAM)      :      "):len(line_power)-3]
									if (str(float(energy_used)) == "nan"):
										found = False
										break
									print("Energy used int:", float(energy_used), "Watts")
									print("Energy used:", energy_used, "Watts")
									f.write(str(float(energy_used)) + ", ")
									break
					if found == False:
						break
					else:
						print("Job Id:", job_id)
						f.write(str(job_id) + ", ")
					file_power.close()
					break
			if (word[0:23] == "Resource_List.walltime=" and found == True): # Getting info on runtime
				walltime = int(word[23])*10*3600 + int(word[24])*3600 + int(word[26])*10*60 + int(word[27])*60 + int(word[29])*10 + int(word[30])
				print("Walltime:", walltime, "Seconds")
				f.write(str(walltime) + ", ")
			if (word[0:24] == "resources_used.walltime=" and found == True): # Getting info on runtime
				runtime = int(word[24])*10*3600 + int(word[25])*3600 + int(word[27])*10*60 + int(word[28])*60 + int(word[30])*10 + int(word[31])
				print("Runtime:", runtime, "Seconds")
				f.write(str(runtime) + ", ")
			if (word[0:8] == "account=" and found == True): # Getting info on runtime
				username = word[8:17]
				print("Username:", username)
				f.write(str(username) + "\n")
				
file.close
f.close

print(total_number_of_jobs_with_energy, "/", total_number_of_jobs)
# ~ Application_name = list(df.iloc[:, 8])
# ~ Nlines = len(Application_name) # Number of lines in the file without the header
# ~ Endpoint_used = list(df.iloc[:, 16])
# ~ Endpoint_status = list(df.iloc[:, 12]) # WARM or WARMING, need to ignore WARMING
# ~ Energy = list(df.iloc[:, 13])
# ~ Runtime = list(df.iloc[:, 14])

# ~ nruns = 0
# ~ total_energy = 0
# ~ total_runtime = 0
# ~ current_application_name = ""
# ~ current_endpoint = ""
# ~ for i in range(0, Nlines):

# Printing the last read values
# ~ print(current_application_name, "-", current_endpoint, "-", total_energy/nruns, "-", total_runtime/nruns)
