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
						f.write(str(nb_nodes) + ", ")
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
									f.write(str(float(energy_used)) + ", ")
									break
					if found == False:
						break
					else:
						f.write(str(job_id) + ", ")
					file_power.close()
					break
			if (word[0:23] == "Resource_List.walltime=" and found == True): # Getting info on runtime
				walltime = int(word[23])*10*3600 + int(word[24])*3600 + int(word[26])*10*60 + int(word[27])*60 + int(word[29])*10 + int(word[30])
				f.write(str(walltime) + ", ")
			if (word[0:24] == "resources_used.walltime=" and found == True): # Getting info on runtime
				runtime = int(word[24])*10*3600 + int(word[25])*3600 + int(word[27])*10*60 + int(word[28])*60 + int(word[30])*10 + int(word[31])
				f.write(str(runtime) + ", ")
			if (word[0:8] == "account=" and found == True): # Getting info on runtime
				username = word[8:17]
				f.write(str(username) + "\n")
				found = False
				
file.close
f.close
