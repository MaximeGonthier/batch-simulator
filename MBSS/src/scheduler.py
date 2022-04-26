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
    transfer_time: int
    
# Schedule random available jobs on random nodes and cores, even if not available
def random_scheduler(available_job_list, node_list, t):
	
	# 1. Declare a lits of job to remove and loop on available jobs
	job_to_remove = []
	for j in available_job_list:

		# 2. Choose a node
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
									
		# ~ # Just for printing in terminal. Can be removed.
		# ~ core_ids = []
		# ~ for i in range (0, len(choosen_core)):
			# ~ core_ids.append(choosen_core[i].unique_id)
		# ~ core_ids.sort()
		# ~ print("Job", j.unique_id, "will be computed on node", choosen_node.unique_id, "core(s)", core_ids, "start at time", j.start_time, "and is predicted to finish at time", j.end_time)
		
		# 6. Add job in list to remove
		job_to_remove.append(j)
	
	# 7. Remove jobs from list
	remove_jobs_from_list(available_job_list, job_to_remove)
