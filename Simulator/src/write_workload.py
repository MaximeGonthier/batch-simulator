# Write a workload that can be read by the simulator using the given information
# The file is written such that each function has a version varying from 1 to 64 cores

# python3 src/write_workload.py inputs/workloads/converted/8_functions_4_endpoints_64coresmax_8users_balance_weight 64 balance_weight null
# python3 src/write_workload.py inputs/workloads/converted/8_functions_4_endpoints_64coresmax_8users_randomize_weight 64 randomize_weight null
# python3 src/write_workload.py inputs/workloads/converted/8_functions_4_endpoints_8users_nocoresmax_meggy 1 default inputs/workloads/meggie-job-trace-extrapolated.csv

import sys
import random
import pandas as pd

output_file = sys.argv[1]
N_cores_max = int(sys.argv[2])
weight_mode = sys.argv[3] # mode can be "default", "balance_weight" or "randomize_weight" or "balance_nb_calls" or "reasonable_weight_and_randomized_nb_calls"
input_file_to_convert = sys.argv[4]

print("Start writting input workload", output_file, "with", N_cores_max, "cores max per function")

# Inputs (todo: put in a file or in the command line)
N_users = 8
users_names = ["credit", "energy", "runtime", "random", "worst", "theta", "midway", "faster"]
users = [0, 1, 2, 3, 4, 5, 6, 7]

N_endpoints = 4
endpoints = ["theta", "midway", "desktop", "faster"]

if input_file_to_convert == "null":
	N_functions = 8
	functions = ["dna_visualization", "graph_bfs", "compression", "graph_mst", "graph_pagerank", "thumbnailer", "video_processing", "matrix_multiplication"]

	functions_energy = [77504707.27793983, 68758460.13356707, 128376269.5872684, 39310823.241199575, 320855.01573796634, 26049.163892481432, 19418.193158867576, 29126.01410990111, 2035210.1192597179, 1604426.1169929204, 311793.53915526223, 441501.75291697815, 331064.0983167976, 17891.78976673046, 2067.7451183716457, 89927.31948552022, 556601.9681100284, 3797341.3195003867, 215822.19626410207, 52820.91098024907, 170871.4506777286, 192757.04248532493, 3098.2685187757015, 49955.55301169766, 1360923.3579691655, 514378.9972284643, 1235.6594092826049, 709703.6582531496, 141678.976716802, 39944.39337769104, 1234.298607881864, 17325.044379021456] # For 1 core, machine 1 function 1 then machine 2 function 1 etc...

	functions_runtime = [101.67077893333332, 16.88655387356321, 11.215356666666667, 16.26165022047244, 0.3367613666666669, 0.05395716091954025, 0.04365126666666667, 0.0740319166666667, 2.1600512677165358, 8.317617097701152, 0.25953086666666664, 0.5193908064516131, 0.35344628571428566, 0.04508554022988506, 0.026055333333333337, 0.13371996850393703, 0.49586137007874004, 25.516413712643686, 3.2942671333333338, 0.13769307086614174, 0.23925346031746036, 0.7611346206896551, 0.03761319999999999, 0.10517269291338592, 3.651324766129033, 1.0669071609195402, 0.5327948, 0.7629717716535436, 0.025724291666666677, 0.004052823529411765, 0.005676666666666667, 0.02578274193548387]
	
	functions_nodes = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
else:	
	data = pd.read_csv(input_file_to_convert)
	df = pd.DataFrame(data)
		
	print("Runtimes")
	desktop_runtime = df.iloc[:, 5]
	print(desktop_runtime[2])
	faster_runtime = df.iloc[:, 6]
	print(faster_runtime[2])
	midway_runtime = df.iloc[:, 7]
	print(midway_runtime[2])
	theta_runtime = df.iloc[:, 8]
	print(theta_runtime[2])
	
	N_functions = len(desktop_runtime) - 2
	print("N_fucntions:", N_functions)
	
	print("Nodes")
	desktop_nodes = df.iloc[:, 9]
	print(desktop_nodes[2])
	faster_nodes = df.iloc[:, 10]
	print(faster_nodes[2])
	midway_nodes = df.iloc[:, 11]
	print(midway_nodes[2])
	theta_nodes = df.iloc[:, 12]
	print(theta_nodes[2])
	
	print("Energy")
	desktop_energy = df.iloc[:, 13]
	print(desktop_energy[2])
	faster_energy = df.iloc[:, 14]
	print(faster_energy[2])
	midway_energy = df.iloc[:, 15]
	print(midway_energy[2])
	theta_energy = df.iloc[:, 16]
	print(theta_energy[2])
	
	cores = df.iloc[:, 17]

	functions_runtime = []	
	functions_energy = []	
	functions_nodes = []
	functions_cores = []
	functions = []
	for i in range (0, N_functions):
		functions.append(i)
		functions_runtime.append(float(theta_runtime[i+2]))
		functions_runtime.append(float(midway_runtime[i+2]))
		functions_runtime.append(float(desktop_runtime[i+2]))
		functions_runtime.append(float(faster_runtime[i+2]))
		# ~ functions_energy.append(str(float(theta_energy[i+2])*float(theta_runtime[i+2])*1000000))
		# ~ functions_energy.append(str(float(midway_energy[i+2])*float(midway_runtime[i+2])*1000000))
		# ~ functions_energy.append(str(float(desktop_energy[i+2])*float(desktop_runtime[i+2])*1000000))
		# ~ functions_energy.append(str(float(faster_energy[i+2])*float(faster_runtime[i+2])*1000000))
		functions_energy.append(theta_energy[i+2])
		functions_energy.append(midway_energy[i+2])
		functions_energy.append(desktop_energy[i+2])
		functions_energy.append(faster_energy[i+2])
		functions_nodes.append(theta_nodes[i+2])
		functions_nodes.append(midway_nodes[i+2])
		functions_nodes.append(desktop_nodes[i+2])
		functions_nodes.append(faster_nodes[i+2])
		functions_cores.append(int(cores[i+2]))
		functions_cores.append(int(cores[i+2]))
		functions_cores.append(int(cores[i+2]))
		functions_cores.append(int(cores[i+2]))
	# ~ print("functions_runtime:", functions_runtime)
	# ~ print("functions_nodes:", functions_nodes)
	# ~ print("functions_energy:", functions_energy)

# To get total energy he did avg_power*Ncores*duration + idle*nnodes*duration -> need to facto Nnodes in main for the idle power!!!
# ~ Total energy colomn is in joule including idle but not tdp.So need to add tdp for runtime*nb of nodes but not idle. Need to consider that in main when computing energy used
# ~ carbon = energy credit * (intensity + carbon rate)

# Writing in a file format
# { id: 0 subtime: 0 delay: 15 walltime: 15 cores: 20 user: credit data: 1 data_size: 0 workload: 1 start_time_from_history: 0 start_node_from_history: 0 duration_on_machine: 101.67077893333332 16.88655387356321 11.215356666666667 16.26165022047244 energy_on_machine: 77504707.27793983 68758460.13356707 128376269.5872684 39310823.241199575 function_name: dna_visualization }

# Todo add more calls to shorter function
mean_runtime_functions = [0]*N_functions
for i in range (0, N_functions):
	for j in range (0, N_endpoints):
		mean_runtime_functions[i] += functions_runtime[i*N_endpoints+j]
	mean_runtime_functions[i] = mean_runtime_functions[i]/N_endpoints

# ~ print("Mean runtime are", mean_runtime_functions)
max_mean_runtime = max(mean_runtime_functions)
print("Max runtime is", max_mean_runtime)

i_cores = 1
i_user = 0
i_functions = 0
nb_functions = 0
f = open(output_file, "w")

for i in range (0, N_functions*N_users*N_cores_max):
	required_multiplier_for_balance = 1
	if weight_mode == "balance_weight" or weight_mode == "randomize_weight":
		required_multiplier_for_balance = int(max_mean_runtime/mean_runtime_functions[i_functions])
	elif weight_mode == "reasonable_weight_and_randomized_nb_calls":
		required_multiplier_for_balance = max(1, int(10/mean_runtime_functions[i_functions]))
	else:
		required_multiplier_for_balance = 1
	# ~ print("Weight multiplier is", required_multiplier_for_balance)
	
	nb_of_repetition = 1
	if weight_mode == "balance_weight" or weight_mode == "default":
		nb_of_repetition = 1
	elif weight_mode == "reasonable_weight_and_randomized_nb_calls":
		nb_of_repetition = random.randint(0, 10)
	elif weight_mode == "balance_nb_calls":
		nb_of_repetition = int(max_mean_runtime/mean_runtime_functions[i_functions])
	else:
		nb_of_repetition = random.randint(0, 10)
	# ~ print("Number of repetition is", nb_of_repetition)
	
	if input_file_to_convert == "null":
		for k in range (0, nb_of_repetition*N_users):
			nb_functions += 1
			f.write("{ id: " + str(i) + " subtime: " + str(0) + " delay: " + str(0) + " walltime: " + str(0) + " cores: " + str(i_cores) + " user: " + str(users[i_user]) + " data: " + str(0) + " data_size: " + str(0) + " workload: " + str(0) + " start_time_from_history: " + str(0) + " start_node_from_history: " + str(0) + " duration_on_machine: ")
			for j in range (0, N_endpoints):
				f.write(str((functions_runtime[i_functions*N_endpoints+j])*required_multiplier_for_balance) + " ")
			f.write("energy_on_machine: ")
			for j in range (0, N_endpoints):
				f.write(str((functions_energy[i_functions*N_endpoints+j])*required_multiplier_for_balance) + " ")
			f.write("nodes: ")
			for j in range (0, N_endpoints):
				f.write(str(1) + " ")
			f.write("function_name: " + functions[i_functions] + " }\n")
		
		# Loop on users first then on cores then on fucntions
			i_user += 1
			if (i_user == N_users):
				i_user = 0
				
		i_cores += 1
		if (i_cores == (N_cores_max+1)):
			i_cores = 1
			i_functions += 1
		if i_functions == N_functions:
			break
	else:
		for k in range (0, nb_of_repetition*N_users):
			nb_functions += 1
			f.write("{ id: " + str(i) + " subtime: " + str(0) + " delay: " + str(0) + " walltime: " + str(0) + " cores: " + str(functions_cores[i_functions*N_endpoints+j]) + " user: " + str(users[i_user]) + " data: " + str(0) + " data_size: " + str(0) + " workload: " + str(0) + " start_time_from_history: " + str(0) + " start_node_from_history: " + str(0) + " duration_on_machine: ")
			for j in range (0, N_endpoints):
				f.write(str((functions_runtime[i_functions*N_endpoints+j])*required_multiplier_for_balance) + " ")
			f.write("energy_on_machine: ")
			for j in range (0, N_endpoints):
				f.write(str((functions_energy[i_functions*N_endpoints+j])*required_multiplier_for_balance) + " ")
			f.write("nodes: ")
			for j in range (0, N_endpoints):
				f.write(str((functions_nodes[i_functions*N_endpoints+j])) + " ")
			f.write("function_name: " + str(functions[i_functions]) + " }\n")
		
		# Loop on users first then on cores then on fucntions
			i_user += 1
			if (i_user == N_users):
				i_user = 0
				
		i_cores += 1
		if (i_cores == (N_cores_max+1)):
			i_cores = 1
			i_functions += 1
		if i_functions == N_functions:
			break
f.close()

# Randomize functions calls

print("Total number of functions call is", nb_functions)
print("Finished writting input workload")

# Randomize but let users together
# ~ with open(output_file, "r") as file:
	# ~ lines = []
	# ~ groups = []
	# ~ groups = list(zip(file, file, file, file, file, file, file, file))
	# ~ for line in file:
		# ~ lines.append(line[:-1])
		# ~ if len(lines) > 3:
			# ~ groups.append(lines)
			# ~ lines = []
	# ~ random.shuffle(groups)

# ~ with open(output_file, "w") as file:
	# ~ file.write("".join([''.join(g) for g in groups]))
# ~ print("Finished randomizing input workload")

import os
print("File Size is :", os.stat(output_file).st_size/1000000, "megabytes")
