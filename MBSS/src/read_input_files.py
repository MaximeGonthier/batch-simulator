# Imports
from dataclasses import dataclass
@dataclass
class Job:
    unique_id: int
    subtime: int
    delay: int
    walltime: int
    cores: int
    data: int
    data_size: float
    index_node_list: int
    start_time: int
    end_time: int
    end_before_walltime: bool
    node_used: None
    cores_used: list
    transfer_time: int
    waiting_for_a_load_time: int
    workload: int
@dataclass
class Node:
    unique_id: int
    memory: int
    bandwidth: float
    data: list
    cores: list
    n_available_cores: int
@dataclass
class Core:
    unique_id: int
    job_queue: list
    available_time: int
    running_job: None

def read_cluster(input_node_file, node_list, available_node_list):
	with open(input_node_file) as f:
		line = f.readline()
		while line:
			r1, r2, r3, r4, r5, r6, r7, r8, r9, r10 = line.split()
			core_list = []
			for i in range (0, int(r9)):
				c = Core(i, list(), 0, None)
				core_list.append(c)
			n = Node(int(r3), int(r5), float(r7), list(), core_list, len(core_list))
			# ~ node_list.append(n)
			# ~ available_node_list.append(n)
			if (int(r5) == 128):
				node_list[0].append(n)
				available_node_list[0].append(n)
			elif (int(r5) == 256):
				node_list[1].append(n)
				available_node_list[1].append(n)
			elif (int(r5) == 1024):
				node_list[2].append(n)
				available_node_list[2].append(n)
			else:
				print("Error, wrong input cluster memory size")
				exit
			line = f.readline()
		f.close
	return node_list, available_node_list

def read_workload(input_job_file, constraint_on_sizes, write_all_jobs):
	
	nb_job_to_evaluate = 0
	
	job_list = []
	# ~ job_list_0 = []
	# ~ job_list_1 = []
	# ~ job_list_2 = []
	
	if (write_all_jobs == 3):
		first_before_0 = False
		first_day_0 = False
		first_day_1 = False
		first_day_2 = False
		first_subtime_before_0 = 0
		first_subtime_day_0 = 0
		first_subtime_day_1 = 0
		first_subtime_day_2 = 0
	
	# ~ first_subtime_to_plot = 0
	# ~ last_subtime_to_plot = 0
	
	with open(input_job_file) as f:
		line = f.readline()
		while line:
			r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20 = line.split() # split it by whitespace
			
			# Getting index of node_list depending on size if constraint is enabled
			if (constraint_on_sizes != 0):
				if ((float(r17)*10)/(float(r11)*10) == 0.0):
					index_node = 0
				elif ((float(r17)*10)/(float(r11)*10) == 6.4):
					index_node = 0
				elif ((float(r17)*10)/(float(r11)*10) == 12.8):
					index_node = 1
				elif ((float(r17)*10)/(float(r11)*10) == 51.2):
					index_node = 2
				else:
					print("Error", (float(r17)*10)/(float(r11)*10), "is a wrong input job data size. Line is:", line)
					exit
			else:
				index_node = 0
			
			# To get number of jobs to evaluate
			if (int(r19) == 1):
				nb_job_to_evaluate += 1
				
			# ~ # To compute stats on cluster usage
			# ~ if (write_all_jobs == 3 and (first_job_slice_to_evaluate == 0 or first_job_slice_to_evaluate == 1)):
				# ~ if (int(r19) == -1 and first_job_slice_to_evaluate == 0):
					# ~ first_job_slice_to_evaluate = 1
					# ~ first_subtime_to_plot = int(r5)
				# ~ elif (int(r19) == 1 and first_job_slice_to_evaluate == 1):
					# ~ last_subtime_to_plot = int(r5)
				# ~ elif (int(r19) == 2 and first_job_slice_to_evaluate == 1):
					# ~ first_job_slice_to_evaluate = 2
			# To compute stats on cluster usage
			if write_all_jobs == 3:
				if int(r19) == -1 and first_before_0 == False:
					first_before_0 = True
					first_subtime_before_0 = int(r5)
				elif int(r19) == 0 and first_day_0 == False:
					first_day_0 = True
					first_subtime_day_0 = int(r5)
				elif int(r19) == 1 and first_day_1 == False:
					first_day_1 = True
					first_subtime_day_1 = int(r5)
				elif int(r19) == 2 and first_day_2 == False:
					first_day_2 = True
					first_subtime_day_2 = int(r5)
			
			j = Job(int(r3), int(r5), int(r7), int(r9), int(r11), int(r15), float(r17), index_node, 0, 0, False, None, list(), 0, 0, int(r19))
			
			# ~ if int(r19) == 0:
				# ~ job_list_0.append(j)
			# ~ elif int(r19) == 1:
				# ~ job_list_1.append(j)
			# ~ elif int(r19) == 2:
				# ~ job_list_2.append(j)
			# ~ else:
				# ~ print("Error read")
				# ~ exit(1)
			job_list.append(j)
			
			line = f.readline()	
			
		f.close
	
	if write_all_jobs == 3:
		f = open("outputs/Start_end_evaluated_slice.txt", "w")
		f.write("%d %d %d %d" %(first_subtime_before_0, first_subtime_day_0, first_subtime_day_1, first_subtime_day_2))
		f.close()
	
	return job_list, nb_job_to_evaluate
	# ~ return job_list, first_subtime_to_plot, nb_job_to_evaluate
	# ~ return job_list_0, job_list_1, job_list_2, first_subtime_to_plot, nb_job_to_evaluate
