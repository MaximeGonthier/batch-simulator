# Just compute the time it takes to transfer all data not on node. TODO : deal with eviction ?
def compute_transfer_time(job_data, node_data, bandwidth, memory, job_data_sizes):
	transfer_time = 0
	i = 0
	for d in job_data:
		if (d not in node_data):
			transfer_time += job_data_sizes[i]//bandwidth
		i += 1
	print("Transfer time:", transfer_time)
	return transfer_time

# Remove jobs rom the main job list. I do it outside the loop because I need to go through the list before deleting
def remove_jobs_from_list(job_list, job_to_remove):
	for j1 in job_to_remove:
		for j2 in job_list:
			if (j1.unique_id == j2.unique_id):
				job_list.remove(j2)

# Add data in the node. TODO : deal with eviction
def add_data_in_node(job_data, node_data, bandwidth, memory):
	for d in job_data:
		if (d not in node_data):
			node_data.append(d)
