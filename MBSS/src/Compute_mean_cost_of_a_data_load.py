# python3 src/Compute_mean_cost_of_a_data_load.py converted_workload %of128 %of256 %of1024
# Compute mean number of jobs using the same data*cost of loading mean data size (using mean core and mean size choosen)
# Can then be used to adapt multiplier of Fcfs_with_a_score

# Imports
import sys

# Inputs
input_job_file = sys.argv[1]
percentage_of_128 = int(sys.argv[2])/100
percentage_of_256 = int(sys.argv[3])/100
percentage_of_1024 = int(sys.argv[4])/100

# Variables
total_number_of_cores = 0
total_number_of_jobs = 0
total_size_of_data = 0

with open(input_job_file) as f:
	line = f.readline()
	while line:
		r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21, r22, r23, r24 = line.split() # Split it by whitespace
		
		total_number_of_cores += int(r11)
		total_number_of_jobs += 1
		total_number_of_data = int(r15)
		
		# ~ # Getting index of node_list depending on size if constraint is enabled
		# ~ if ((float(r17)*10)/(float(r11)*10) == 0.0):
			# ~ index_node = 0
		# ~ elif ((float(r17)*10)/(float(r11)*10) == 6.4):
			# ~ index_node = 0
		# ~ elif ((float(r17)*10)/(float(r11)*10) == 12.8):
			# ~ index_node = 1
		# ~ elif ((float(r17)*10)/(float(r11)*10) == 51.2):
			# ~ index_node = 2
		# ~ else:
			# ~ print("Error", (float(r17)*10)/(float(r11)*10), "is a wrong input job data size. Line is:", line)
			# ~ exit(1)
	
		line = f.readline()
f.close

mean_number_of_cores = total_number_of_cores/total_number_of_jobs
print("Mean number of cores per job is", mean_number_of_cores, " = ", total_number_of_cores, " / ", total_number_of_jobs)

mean_number_of_jobs_per_data = total_number_of_jobs/total_number_of_data
print("Mean number of jobs per data is", mean_number_of_jobs_per_data, " = ", total_number_of_jobs, " / ", total_number_of_data)

mean_size_of_data = mean_number_of_cores*percentage_of_128*6.4 + mean_number_of_cores*percentage_of_256*12.8 + mean_number_of_cores*percentage_of_1024*51.2
print("Mean size of data is", mean_size_of_data, " = ", mean_number_of_cores, " * ", percentage_of_128, " * 6.4 + ", mean_number_of_cores, " * ", percentage_of_256, " * 12.8 + ", mean_number_of_cores, " * ", percentage_of_1024, " * 51.2") 

mean_time_to_load_file = mean_size_of_data/0.1
print("Mean time to load a file is", mean_time_to_load_file, " = ", mean_size_of_data, " / 0.1")

mean_cost_of_1_data_over_all_jobs = mean_time_to_load_file*mean_number_of_jobs_per_data
print("Mean cost of 1 data knowing it's the first is", mean_cost_of_1_data_over_all_jobs, " = ", mean_time_to_load_file, " * ", mean_number_of_jobs_per_data)

mean_cost_of_1_data = ((mean_number_of_jobs_per_data - 1)/2 + 1)*mean_time_to_load_file
print("==> Mean cost of 1 data is", mean_cost_of_1_data, " = ((", mean_number_of_jobs_per_data, " - 1)/2 + 1)* ", mean_time_to_load_file, "<==")

# If I know the data size
print("==> Mean cost of 1 data knowing it's size S is X = ((", mean_number_of_jobs_per_data, " - 1)/2 + 1)* S/0.1 <==")

# Some examples
print("Some examples:")
print("==> S = 6.4 (min) -> X = ", ((mean_number_of_jobs_per_data - 1)/2 + 1)*(6.4/0.1))
print("==> S = 64 -> X = ", ((mean_number_of_jobs_per_data - 1)/2 + 1)*(64/0.1))
print("==> S = 128 -> X = ", ((mean_number_of_jobs_per_data - 1)/2 + 1)*(128/0.1))
print("==> S = 256 -> X = ", ((mean_number_of_jobs_per_data - 1)/2 + 1)*(256/0.1))
print("==> S = 1024 (max) -> X = ", ((mean_number_of_jobs_per_data - 1)/2 + 1)*(1024/0.1))

f.close
