# Imports
from basic_functions import return_earliest_available_cores_and_start_time_specific_node
from print_functions import print_decision_in_scheduler

# Return sublist of node in which you can choose depending on the size of your file
def return_node_sublist_specific_sizes(node_list, size):
	if (size == 0): # Je peux choisir dans la liste entière
		return node_list[0] + node_list[1] + node_list[2]
	elif (size == 1): # Je peux choisir dans la 1 et la 2
		return node_list[1] + node_list[2]
	elif (size == 2): # Je peux choisir que dans la 2
		return node_list[2]

# Try to start a job immediatly on a certain sublist of node and return True or False depending on the succes.
# Can not delay a scheduled job
# backfill_big_node_mode = 0 : If I can start immediatly
# backfill_big_node_mode = 1 : If I can start immediatly and can't start on a smaller node before t + mean queue time - queue time (j)
def start_job_immediatly_specific_node_size(job, node_sublist, current_time, backfill_big_node_mode, mean_queue_time):
	for n in node_sublist:
		choosen_core, earliest_available_time = return_earliest_available_cores_and_start_time_specific_node(job.cores, n, current_time)
		if backfill_big_node_mode:
			threshold_for_a_start = current_time + mean_queue_time - (current_time - job.subtime) + job.walltime
		else:
			threshold_for_a_start = current_time
			
		if earliest_available_time <= threshold_for_a_start: # Ok I can start immediatly, schedule job and return true
			print("Can start imediatly job", job.unique_id)
			start_time = earliest_available_time
			job.node_used = n
			job.cores_used = choosen_core
			job.start_time = start_time
			job.end_time = start_time + job.walltime			
			for c in choosen_core:
				c.job_queue.append(job)
				c.available_time = start_time + job.walltime
			if __debug__:
				print_decision_in_scheduler(choosen_core, job, n)
			return True
	return False
