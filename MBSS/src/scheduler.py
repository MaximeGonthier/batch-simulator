# Imports
from basic_functions import *
import random
    
# Schedule random available jobs on random nodes and cores, even if not available
def random_scheduler(job_list, node_list, t):
	job_to_remove = []
	for j in job_list:
		if (j.subtime <= t):
			choosen_node = random.choices(node_list)[0]
			choosen_core = random.randint(0, 19)
			# ~ transfer_time = compute_transfer_time(j.data, choosen_node.data, choosen_node.bandwidth, choosen_node.memory, j.data_sizes)
			print("Job", j.unique_id, "will be computed on node", choosen_node.unique_id, "core", choosen_core)
			
			choosen_node.cores[choosen_core].job_queue.append(j)
			
			# ~ add_data_in_node(j.data, choosen_node.data, choosen_node.bandwidth, choosen_node.memory)
			# ~ time_used = min(j.delay + transfer_time, j.walltime)
			# ~ start_time = max(choosen_node.available_time, j.subtime)
			# ~ to_print_job_csv(j, choosen_node[0], start_time, transfer_time, time_used) # Careful, here the available time of the previous job (or the sub time for the start) is the time of start of the current job. That's why I put it before changing
			# ~ choosen_node.predicted_available_time[choosen_core] += time_used
			# ~ choosen_node.real_available_time[choosen_core] += time_used
			job_to_remove.append(j)
	remove_jobs_from_list(job_list, job_to_remove)
