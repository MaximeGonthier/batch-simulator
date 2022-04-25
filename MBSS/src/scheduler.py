# Imports
from basic_functions import *
import random
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
    
# Schedule random available jobs on random nodes and cores, even if not available
def random_scheduler(available_job_list, node_list, t):
	job_to_remove = []
	for j in available_job_list:

		if (j.index_node_list == 0): # Je peux choisir dans la liste entière
			choosen_node = random.choice(node_list[0] + node_list[1] + node_list[2])
		elif (j.index_node_list == 1): # Je peux choisir dans la 1 et la 2
			choosen_node = random.choice(node_list[1] + node_list[2])
		elif (j.index_node_list == 2): # Je peux choisir que dans la 2
			choosen_node = random.choice(node_list[2])

		choosen_core = random.sample(choosen_node.cores, j.cores)

		# Get start time
		start_time = t
		for c in choosen_core:
			if (c.available_time > t): # Look for max available time
				for c in choosen_core:
					if (c.available_time > start_time):
						start_time = c.available_time
				break
				
		# ~ end_time = start_time + min(j.delay + transfer_time, j.walltime)
		
		for c in choosen_core:
			c.available_time = start_time + j.walltime
		
		j.node_used = choosen_node
		j.cores_used = choosen_core
		j.start_time = start_time
		j.end_time = start_time + j.walltime
		# ~ j.end_before_walltime = end_before_walltime
			
		for c in choosen_core:
			c.job_queue.append(j)
						
		# ~ add_data_in_node(j.data, choosen_node.data, choosen_node.bandwidth, choosen_node.memory)
			
		# Just for printing in terminal. Can be removed.
		core_ids = []
		for i in range (0, len(choosen_core)):
			core_ids.append(choosen_core[i].unique_id)
		core_ids.sort()
		# ~ print("Job", j.unique_id, "will be computed on node", choosen_node.unique_id, "core(s)", core_ids, "start at time", j.start_time, "and is predicted to finish at time", j.end_time)

		# Remove from available cores TODO : deal with multicore
		# ~ remove_from_available(available_node_list, choosen_node, choosen_core)
		# ~ print(node_list)
		# ~ time_used = min(j.delay + transfer_time, j.walltime)
		# ~ start_time = max(choosen_node.available_time, j.subtime)
		# ~ to_print_job_csv(j, choosen_node[0], start_time, transfer_time, time_used) # Careful, here the available time of the previous job (or the sub time for the start) is the time of start of the current job. That's why I put it before changing
		# ~ choosen_node.predicted_available_time[choosen_core] += time_used
		# ~ choosen_node.real_available_time[choosen_core] += time_used
		job_to_remove.append(j)
	# ~ available_job_list.remove(j)
	remove_jobs_from_list(available_job_list, job_to_remove)
