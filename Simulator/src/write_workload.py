# Write a workload that can be read by the simulator using the given information
# The file is written such that each function has a version varying from 1 to 64 cores

# python3 src/write_workload.py output_file
# python3 src/write_workload.py inputs/workloads/converted/8_functions_4_endpoints_64coresmax
import sys

output_file = sys.argv[1]

# Inputs (todo: put in a file or in the command line)
N_users = 4
users = ["credit", "energy", "runtime", "random"]

N_endpoints = 4
endpoints = ["theta", "midway", "desktop", "faster"]

N_functions = 8
functions = ["dna_visualization", "graph_bfs", "compression", "graph_mst", "graph_pagerank", "thumbnailer", "video_processing", "matrix_multiplication"]

functions_energy = [77504707.27793983, 68758460.13356707, 128376269.5872684, 39310823.241199575, 320855.01573796634, 26049.163892481432, 19418.193158867576, 29126.01410990111, 2035210.1192597179, 1604426.1169929204, 311793.53915526223, 441501.75291697815, 331064.0983167976, 17891.78976673046, 2067.7451183716457, 89927.31948552022, 556601.9681100284, 3797341.3195003867, 215822.19626410207, 52820.91098024907, 170871.4506777286, 192757.04248532493, 3098.2685187757015, 49955.55301169766, 1360923.3579691655, 514378.9972284643, 1235.6594092826049, 709703.6582531496, 141678.976716802, 39944.39337769104, 1234.298607881864, 17325.044379021456] # For 1 core, per machine first and then function by function, machine and functions sorted like in endpoints tab

functions_runtime = [101.67077893333332, 16.88655387356321, 11.215356666666667, 16.26165022047244, 0.3367613666666669, 0.05395716091954025, 0.04365126666666667, 0.0740319166666667, 2.1600512677165358, 8.317617097701152, 0.25953086666666664, 0.5193908064516131, 0.35344628571428566, 0.04508554022988506, 0.026055333333333337, 0.13371996850393703, 0.49586137007874004, 25.516413712643686, 3.2942671333333338, 0.13769307086614174, 0.23925346031746036, 0.7611346206896551, 0.03761319999999999, 0.10517269291338592, 3.651324766129033, 1.0669071609195402, 0.5327948, 0.7629717716535436, 0.025724291666666677, 0.004052823529411765, 0.005676666666666667, 0.02578274193548387]

N_cores_max = 64

# Writing in a file
# ~ { id: 0 subtime: 0 delay: 15 walltime: 15 cores: 20 user: credit data: 1 data_size: 0 workload: 1 start_time_from_history: 0 start_node_from_history: 0 duration_on_machine: 101.67077893333332 16.88655387356321 11.215356666666667 16.26165022047244 energy_on_machine: 77504707.27793983 68758460.13356707 128376269.5872684 39310823.241199575 function_name: dna_visualization }

i_cores = 1
i_user = 0
i_functions = 0
f = open(output_file, "w")
for i in range (0, N_functions*N_users*N_cores_max):
	f.write("{ id: " + str(i) + " subtime: " + str(0) + " delay: " + str(0) + " walltime: " + str(0) + " cores: " + str(i_cores) + " user: " + users[i_user] + " data: " + str(0) + " data_size: " + str(0) + " workload: " + str(0) + " start_time_from_history: " + str(0) + " start_node_from_history: " + str(0) + " duration_on_machine: ")
	for j in range (0, N_endpoints):
		f.write(str(functions_runtime[i_functions*N_endpoints+j]) + " ")
	f.write("energy_on_machine: ")
	for j in range (0, N_endpoints):
		f.write(str(functions_energy[i_functions*N_endpoints+j]) + " ")
	f.write("function_name: " + functions[i_functions] + " }\n")
	i_cores += 1
	if (i_cores == 65):
		i_cores = 1
		i_user += 1
	if (i_user == N_users):
		i_user = 0
		i_functions += 1
f.close()
