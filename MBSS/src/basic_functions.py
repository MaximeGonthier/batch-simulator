# ~ from dataclasses import dataclass
# ~ @dataclass
# ~ class To_print: # Struct used to know what to print later in csv
    # ~ job_unique_id: int
    # ~ job_subtime: int
    # ~ node_unique_id: int
    # ~ core_unique_id: int
    # ~ time: int
    # ~ time_used: int
    
# Just compute the time it takes to transfer all data not on node. TODO : deal with eviction ?
def compute_transfer_time(job_data, node_data, bandwidth, memory, job_data_size):
	transfer_time = 0
	if (job_data not in node_data and job_data != 0):
		# ~ transfer_time += job_data_size//bandwidth
		transfer_time += job_data_size/bandwidth
	print("Transfer time:", transfer_time)
	return transfer_time

# Remove jobs rom the main job list. I do it outside the loop because I need to go through the list before deleting
def remove_jobs_from_list(available_job_list, job_to_remove): # TODO: simplifier en 1 seule boucle ?
	for j1 in job_to_remove:
		for j2 in available_job_list:
			if (j1.unique_id == j2.unique_id):
				available_job_list.remove(j2)

# Add data in the node. TODO : deal with eviction when a job is not currently running on it
def add_data_in_node(job_data, node_data, bandwidth, memory):
	if (job_data not in node_data):
		node_data.append(job_data)

# Update nodes list if they are available at current time
# ~ def update_nodes():
	# ~ print("here t =", t)
	# ~ for n in node_list:
		# ~ print("here t =", t, "n avail = ", n.available_time)
		# ~ if (t == n.available_time):
			# ~ print("now available", n)
			# ~ available_node_list.append(n)

# ~ def remove_from_available(available_node_list, choosen_node, choosen_core):
	# ~ temp_node = choosen_node
	# ~ temp_node.cores.remove(choosen_node.cores[choosen_core])
	# ~ available_node_list[choosen_node.unique_id].cores.remove(choosen_node.cores[choosen_core])
	# ~ available_node_list.remove(choosen_node)
	
# ~ def print_csv():
	# ~ max_queue_time = 0
	# ~ mean_queue_time = 0
	# ~ total_queue_time = 0
	# ~ max_flow = 0
	# ~ mean_flow = 0
	# ~ total_flow = 0
	# ~ total_transfer_time = 0
	# ~ makespan = 0
	# ~ core_time_used = 0
	# ~ for tp in to_print_list:
		# ~ core_time_used += tp.time_used
		# ~ total_queue_time += tp.time - tp.job_subtime
		# ~ if (max_queue_time < tp.time - tp.job_subtime):
			# ~ max_queue_time = tp.time - tp.job_subtime
		# ~ total_flow += tp.time - tp.job_subtime + tp.time_used
		# ~ if (max_flow < tp.time - tp.job_subtime + tp.time_used):
			# ~ max_flow = tp.time - tp.job_subtime + tp.time_used
		# ~ total_transfer_time += tp.transfer_time
		# ~ if (makespan < tp.time + tp.time_used):
			# ~ makespan = tp.time + tp.time_used
	# ~ mean_queue_time = total_queue_time/len(to_print_list)
	# ~ mean_flow = total_flow/len(to_print_list)
	# ~ file_to_open = "outputs/Results_" + scheduler + ".txt"
	# ~ f = open(file_to_open, "a")
	# ~ f.write("%s %s %s %s %s %s %s %s %s %s\n" % (str(len(to_print_list)), str(max_queue_time), str(mean_queue_time), str(total_queue_time), str(max_flow), str(mean_flow), str(total_flow), str(total_transfer_time), str(makespan), str(core_time_used)))
	# ~ f.close()
