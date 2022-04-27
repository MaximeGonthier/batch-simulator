# Imports
from basic_functions import *
from print_functions import *
import random
from dataclasses import dataclass
import operator

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
    
# Schedule random available jobs on random nodes and cores, even if not available
# The numbers here indicate the minimum you must do in a scheduler. In other scheduler there are more steps but they are optional.
def random_scheduler(available_job_list, node_list, t):
	
	# 1. Declare a list of job to remove and loop on available jobs
	job_to_remove = []
	for j in available_job_list:

		# 2. Choose a node, different list depending on file size
		if (j.index_node_list == 0): # Je peux choisir dans la liste entière
			choosen_node = random.choice(node_list[0] + node_list[1] + node_list[2])
		elif (j.index_node_list == 1): # Je peux choisir dans la 1 et la 2
			choosen_node = random.choice(node_list[1] + node_list[2])
		elif (j.index_node_list == 2): # Je peux choisir que dans la 2
			choosen_node = random.choice(node_list[2])
			
		# 3. Choose a core
		choosen_core = random.sample(choosen_node.cores, j.cores)

		# 4. Get start time and update available times of the cores
		start_time = get_start_time_and_update_avail_times_of_cores(t, choosen_core, j.walltime) 
		
		# 5. Update jobs info and add job in choosen cores
		j.node_used = choosen_node
		j.cores_used = choosen_core
		j.start_time = start_time
		j.end_time = start_time + j.walltime			
		for c in choosen_core:
			c.job_queue.append(j)
									
		# Just for printing in terminal. Can be removed.
		# ~ print_decision_in_scheduler(choosen_core, j, choosen_node)
		
		# 6. Add job in list to remove
		job_to_remove.append(j)
	
	# 7. Remove jobs from list
	remove_jobs_from_list(available_job_list, job_to_remove)
	
# Compute a score for each node.
# For each node, A = compute the earliest available time to host job j.
# For each node, B = compute the time it will take to load all the files from j not yet in memory.
# For each node, C = compute the amount of data that will need to be evicted to load all the files from j not yet in memory. These files will need to be re loaded for other jobs.
# Score = A + B + (C/BW)
# Schedule j on the node with the lowest score and on the cores available the earliest.
def fcfs_with_a_score_scheduler(available_job_list, node_list, t):
	
	# 1. Declare a list of job to remove and loop on available jobs
	job_to_remove = []
	for j in available_job_list:
				
		# 2. Choose a node
		# 2.1. Different list depending on file size
		if (j.index_node_list == 0): # Je peux choisir dans la liste entière
			nodes_to_choose_from = node_list[0] + node_list[1] + node_list[2]
		elif (j.index_node_list == 1): # Je peux choisir dans la 1 et la 2
			nodes_to_choose_from = node_list[1] + node_list[2]
		elif (j.index_node_list == 2): # Je peux choisir que dans la 2
			nodes_to_choose_from = node_list[2]
					
		min_score = -1
			
		for n in nodes_to_choose_from:
									
			# 2.2. Sort cores by available times
			n.cores.sort(key = operator.attrgetter("available_time"))
				
			# 2.3. Get the earliest available time from the number of cores required by the job and add it to the score
			earliest_available_time = n.cores[j.cores - 1].available_time # -1 because tab start at 0
			# ~ print("Earliest time for node", n.unique_id, "is", earliest_available_time)
				
			# 2.4. Compute the time to load all data. For this look at the data that will be available at the earliest available time of the node
			if j.data == 0:
				time_to_load_file = 0
			else:
				files_on_node = files_on_node_at_certain_time(earliest_available_time, n)
				if j.data in files_on_node:
					time_to_load_file = 0
				else:
					time_to_load_file = j.data_size/n.bandwidth
				# ~ print("Time to load is", time_to_load_file)
				
			# 2.5. Get the amount of files that will be lost because of this load by computing the amount of data that end at the earliest time only on the supposely choosen cores, excluding current file of course
			size_files_ended = size_files_ended_at_certain_time(earliest_available_time, n.cores[0:j.cores], j.data)
			time_to_reload_evicted_files = size_files_ended/n.bandwidth
			# ~ print("Time to reload", time_to_reload_evicted_files)
				
			score = earliest_available_time + time_to_load_file + time_to_reload_evicted_files
			# ~ print("Score of node is", score)
			
			# 2.6. Get minimum score
			if min_score == -1:
				min_score = score
				choosen_node = n
			elif min_score > score:
				min_score = score
				choosen_node = n
					
		# ~ print("Min score for job", j.unique_id, "is", min_score, "with node", choosen_node.unique_id)
								
		# 3. Choose a core
		choosen_core = choosen_node.cores[0:j.cores]

		# 4. Get start time and update available times of the cores
		start_time = get_start_time_and_update_avail_times_of_cores(t, choosen_core, j.walltime) 
		
		# 5. Update jobs info and add job in choosen cores
		j.node_used = choosen_node
		j.cores_used = choosen_core
		j.start_time = start_time
		j.end_time = start_time + j.walltime			
		for c in choosen_core:
			c.job_queue.append(j)
									
		# Just for printing in terminal. Can be removed.
		# ~ print_decision_in_scheduler(choosen_core, j, choosen_node)
		
		# 6. Add job in list to remove
		job_to_remove.append(j)
		
	# 7. Remove jobs from list
	remove_jobs_from_list(available_job_list, job_to_remove)
