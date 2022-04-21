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
    data: list
    data_sizes: list
    start_time: int
    end_time: int
    end_before_walltime: bool
    
# Schedule random available jobs on random nodes and cores, even if not available
def random_scheduler(available_job_list, node_list, t, available_node_list):
	job_to_remove = []
	for j in available_job_list:
		choosen_node = random.choices(node_list)[0]
		# ~ print(choosen_node)
		# ~ cores_not_selected_yet = choosen_node.cores
		print("required cores:", j.cores)
		choosen_core = random.sample(choosen_node.cores, j.cores)
		# ~ cores_not_selected_yet.remove(choosen_core)
		# ~ print(choosen_core)
		
		transfer_time = compute_transfer_time(j.data, choosen_node.data, choosen_node.bandwidth, choosen_node.memory, j.data_sizes)	
			
		if (j.delay + transfer_time < j.walltime):
			end_before_walltime = True
		else:
			end_before_walltime = False

		# Get start time
		start_time = t
		for c in choosen_core:
			if (c.available_time > t): # Look for max available time
				for c in choosen_core:
					if (c.available_time > start_time):
						start_time = c.available_time
				break
				
		end_time = start_time + min(j.delay + transfer_time, j.walltime)
		
		for c in choosen_core:
			c.available_time = start_time + j.walltime
			
		j.start_time = start_time
		j.end_time = end_time
		j.end_before_walltime = end_before_walltime
			
		for c in choosen_core:
			c.job_queue.append(j)
						
		add_data_in_node(j.data, choosen_node.data, choosen_node.bandwidth, choosen_node.memory)
			
		print("Job", j.unique_id, "will be computed on node", choosen_node.unique_id, "core(s)", choosen_core, "start at time", j.start_time, "and finish at time", j.end_time)

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
	print("end of random")
	remove_jobs_from_list(available_job_list, job_to_remove)
