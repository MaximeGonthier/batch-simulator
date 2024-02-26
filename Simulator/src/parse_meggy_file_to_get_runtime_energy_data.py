# Used to parse data from https://zenodo.org/records/3666632 files named emmy

# python3 src/parse_meggy_file_to_get_runtime_energy_data.py meggie_job_input_file meggie_power_input_file
# python3 src/parse_meggy_file_to_get_runtime_energy_data.py ../../ipdps20-paper-hpc-power-traces/data/cluster_characteristics/meggie/job_traces/rrze-traces-meggie-jobs-01.txt ../../ipdps20-paper-hpc-power-traces/data/cluster_characteristics/meggie/pwr_traces/rrze-traces-meggie-avg-pwr-01.txt inputs/workloads/meggie-1-raw

# Job input file look like this
# ~ JobID|Submit|Start|End|ReqNodes|Timelimit|Elapsed|User|JobName|
# ~ 349988|2018-12-31T08:27|2018-12-31T08:27|2019-01-01T08:27|7|1-00:00|1-00:00|5c8e3240|b7ef4ccd
# ~ 349989|2018-12-31T08:27|2018-12-31T08:27|2019-01-01T08:27|7|1-00:00|1-00:00|5c8e3240|b7ef4ccd

# Energy input file look like this
# ~ 349988	average chip RAPL-power                   :      110.5 W
# ~ 349988	average dram RAPL-power                   :        8.8 W
# ~ 349989	average chip RAPL-power                   :      106.6 W
# ~ 349989	average dram RAPL-power                   :        9.0 W

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
f.write("Power used per node, Job Id, Number of nodes used, Number of cores used, Runtime\n")

with open(job_input_file, 'r') as file:
	next(file)
	for line in file:
		total_number_of_jobs += 1
		# ~ i = 0
		# ~ while i != 7:
		
		job_id = str(line[0:6])
		# ~ f.write(job_id + ", ")
		
		found = False
		with open(energy_input_file, 'r') as file_power:
			for line_power in file_power:
				if found == True:
					break
				for word_power in line_power.split():
					# ~ print(word_power)
					if word_power == job_id:
						total_number_of_jobs_with_energy += 1
						found = True
						energy_used = line_power[len(word_power)+len("	average chip RAPL-power                   :      "):len(line_power)-3]
						if (str(float(energy_used)) == "nan"):
							found = False
							break
						f.write(str(float(energy_used)) + ", ")
						break
			# ~ if found == False:
				# ~ break
			if found == True:
				f.write(str(job_id) + ", ")
			file_power.close()
			# ~ break
		
		if found == True:
			end_of_nodes_digit = 0
			# ~ if line[58:59] != "|":
			nodes_used = int(line[58:59])
			end_of_nodes_digit = 59
			if line[59:60] != "|":
				nodes_used = nodes_used*10
				nodes_used += int(line[59:60])
				end_of_nodes_digit = 60
			f.write(str(nodes_used) + ", ")
			f.write(str(nodes_used*20) + ", ")
			i = 1
			while line[end_of_nodes_digit+i:end_of_nodes_digit+1+i] != "|":
				i += 1
			start_of_runtime = i+end_of_nodes_digit+1
			i += 1	
			while line[end_of_nodes_digit+i:end_of_nodes_digit+1+i] != "|":
				i += 1
			end_of_runtime = i+end_of_nodes_digit
			# ~ print(str(line[start_of_runtime:end_of_runtime]))
			runtime = 0
			if (len(line[start_of_runtime:end_of_runtime]) > 5):
				runtime = 24*60*60*int(line[start_of_runtime:start_of_runtime+1]) + 10*60*int(line[start_of_runtime+2:start_of_runtime+3]) + 60*int(line[start_of_runtime+3:start_of_runtime+4]) + 10*int(line[start_of_runtime+5:start_of_runtime+6]) + int(line[start_of_runtime+6:start_of_runtime+7])
			else:
				runtime = 10*60*int(line[start_of_runtime:start_of_runtime+1]) + 60*int(line[start_of_runtime+1:start_of_runtime+2]) + 10*int(line[start_of_runtime+3:start_of_runtime+4]) + int(line[start_of_runtime+4:start_of_runtime+5])
			f.write(str(runtime) + "\n")
			
		# ~ runtime = str(line[])
		
						# ~ break
					# ~ if get_nb_node_next_char == True:
						# ~ get_nb_node_next_char = False
						# ~ if (char == "e"): # Skipping this line cause wrong value for number of nodes
							# ~ break
						# ~ check_next_char_for_more_than_9_nodes = True
						# ~ nb_nodes = int(char)
					# ~ if (char == "="):
						# ~ get_nb_node_next_char = True
			# ~ for char in word:
				# ~ if (char == "E"): # A terminated job, so getting info on number of nodes
					# ~ total_number_of_jobs += 1
					# ~ get_nb_node_next_word = True
					# ~ i = 11
					# ~ while word[i] != ".":
						# ~ i += 1
					# ~ job_id = word[11:i]
					# ~ found = False
					# ~ with open(energy_input_file, 'r') as file_power:
						# ~ for line_power in file_power:
							# ~ if found == True:
								# ~ break
							# ~ for word_power in line_power.split():
								# ~ if word_power == job_id:
									# ~ total_number_of_jobs_with_energy += 1
									# ~ found = True
									# ~ energy_used = line_power[len(word_power)+len("  average power consumption (CPU+DRAM)      :      "):len(line_power)-3]
									# ~ if (str(float(energy_used)) == "nan"):
										# ~ found = False
										# ~ break
									# ~ print("Energy used int:", float(energy_used), "Watts")
									# ~ print("Energy used:", energy_used, "Watts")
									# ~ f.write(str(float(energy_used)) + ", ")
									# ~ break
					# ~ if found == False:
						# ~ break
					# ~ else:
						# ~ print("Job Id:", job_id)
						# ~ f.write(str(job_id) + ", ")
					# ~ file_power.close()
					# ~ break
			# ~ if (word[0:24] == "resources_used.walltime=" and found == True): # Getting info on runtime
				# ~ runtime = int(word[24])*10*3600 + int(word[25])*3600 + int(word[27])*10*60 + int(word[28])*60 + int(word[30])*10 + int(word[31])
				# ~ print("Runtime:", runtime, "Seconds")
				# ~ f.write(str(runtime) + "\n")

file.close
f.close

print(total_number_of_jobs_with_energy, "/", total_number_of_jobs)
