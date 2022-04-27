# Imports
from dataclasses import dataclass
@dataclass
class Data:
    unique_id: int
    start_time: int
    nb_task_using_it: int

# Remove jobs rom the main job list. I do it outside the loop because I need to go through the list before deleting
def remove_jobs_from_list(available_job_list, job_to_remove): # TODO: simplifier en 1 seule boucle ?
	for j1 in job_to_remove:
		for j2 in available_job_list:
			if (j1.unique_id == j2.unique_id):
				available_job_list.remove(j2)

# Add data in the node. TODO : deal with eviction when a job is not currently running on it
def add_data_in_node(data_unique_id, data_size, node_used, t, walltime):
	# ~ print("Adding", data_unique_id)
	
	data_is_on_node = False
	
	# Let's try to find it in the node
	for d in node_used.data:
		if (data_unique_id == d.unique_id): # It is already on node
			if (d.nb_task_using_it > 0): # And is still valid!
				# ~ if (d.end_time < t + walltime): # New end time for the data cause current job will hold it for longer
					# ~ d.end_time = t + walltime
					
				if (d.start_time > t): # The job will have to wait for the data to be loaded by another job before starting
					transfer_time = d.start_time - t
				else:
					transfer_time = 0 # No need to wait to start the job, data is already fully loaded
			else: # Need to reload it
				# ~ print("Data", data_unique_id, "is not on node anymore need to reload it")
				transfer_time = data_size/node_used.bandwidth
				d.start_time = t + transfer_time
			data_is_on_node = True
			d.nb_task_using_it += 1
			break
	
	if (data_is_on_node == False): # Need to load it
		transfer_time = data_size/node_used.bandwidth
		# Create a class Data for this node
		d = Data(data_unique_id, t + transfer_time, 1)
		node_used.data.append(d)
	
	# ~ print("Adding", data_unique_id, "on node", node_used.unique_id, "has a transfer time of", transfer_time, "at time", t)
	return transfer_time

def remove_data_from_node(finished_job_list):
	for j in finished_job_list:
		for d in j.node_used.data:
			if (j.data == d.unique_id):
				d.nb_task_using_it -= 1
				break
	
	# ~ if (job_data not in node_used.data):
		# ~ job_data.end_time = time_last_used
		# ~ node_used.data.append(job_data)
		# ~ print("New data", job_data.unique_id, "in node", node_used.unique_id, "will end at time", job_data.end_time)
	# ~ else:
		# ~ for d in node_used.data:
			# ~ if (d.unique_id == job_data.unique_id):
				# ~ if (time_last_used > d.end_time):
					# ~ d.end_time = time_last_used
				# ~ break
		# ~ # just printing a supprimer
		# ~ for d in node_used.data:
			# ~ if (d.unique_id == job_data.unique_id):
				# ~ print("End of data", job_data.unique_id, "on node", node_used.unique_id, "is", d.end_time)
				# ~ break
	
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
	
def print_csv(to_print_list, scheduler):
	max_queue_time = 0
	mean_queue_time = 0
	total_queue_time = 0
	max_flow = 0
	mean_flow = 0
	total_flow = 0
	total_transfer_time = 0
	makespan = 0
	core_time_used = 0
	for tp in to_print_list:
		core_time_used += tp.time_used
		total_queue_time += tp.time - tp.job_subtime
		if (max_queue_time < tp.time - tp.job_subtime):
			max_queue_time = tp.time - tp.job_subtime
		total_flow += tp.time - tp.job_subtime + tp.time_used
		if (max_flow < tp.time - tp.job_subtime + tp.time_used):
			max_flow = tp.time - tp.job_subtime + tp.time_used
		total_transfer_time += tp.transfer_time
		if (makespan < tp.time + tp.time_used):
			makespan = tp.time + tp.time_used
	mean_queue_time = total_queue_time/len(to_print_list)
	mean_flow = total_flow/len(to_print_list)
	file_to_open = "outputs/Results_" + scheduler + ".csv"
	f = open(file_to_open, "a")
	# ~ f.write("%s %s %s %s %s %s %s %s %s %s %s\n" % (scheduler, str(len(to_print_list)), str(max_queue_time), str(mean_queue_time), str(total_queue_time), str(max_flow), str(mean_flow), str(total_flow), str(total_transfer_time), str(makespan), str(core_time_used)))
	f.write("%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n" % (scheduler, str(len(to_print_list)), str(max_queue_time), str(mean_queue_time), str(total_queue_time), str(max_flow), str(mean_flow), str(total_flow), str(total_transfer_time), str(makespan), str(core_time_used)))
	f.close()

def get_start_time_and_update_avail_times_of_cores(t, choosen_core, walltime):
	start_time = t
	for c in choosen_core:
		if (c.available_time > t): # Look for max available time
			for c in choosen_core:
				if (c.available_time > start_time):
					start_time = c.available_time
			break
					
	for c in choosen_core:
		c.available_time = start_time + walltime
	
	return start_time

# Return set of files that will be on node at a given time
def files_on_node_at_certain_time(time, node):
	file_on_node = []
	for c in node.cores:
		for j in c.job_queue:
			if j.start_time + j.transfer_time <= time and j.walltime >= time: # Data will be loaded at this time
				if j.data not in file_on_node:
					file_on_node.append(j.data)
				break # Break because no other possibility on this core ?
	return file_on_node

def size_files_ended_at_certain_time(time, cores, current_data):
	size_file_ended = 0
	for c in cores:
		for j in c.job_queue:
			if j.walltime == time and j.data != current_data: # Data will end at this time
				size_file_ended += j.data_size
				break
	return size_file_ended
	
# Return earliest available node as well as it's starting time
def get_earliest_available_node_and_time(set_of_node, cores_asked)
	min_earliest_available_time = -1
	choosen_node = None
	for n in set_of_node:
		# 1. sSort cores by available times
		n.cores.sort(key = operator.attrgetter("available_time"))
				
		# 2. Get the earliest available time from the number of cores required by the job
		earliest_available_time = n.cores[cores_asked - 1].available_time # -1 because tab start at 0
						
		# 3. Compute the min
		if min_earliest_available_time == -1:
			min_earliest_available_time = earliest_available_time
			choosen_node = n
		elif min_earliest_available_time > earliest_available_time:
			min_earliest_available_time = earliest_available_time
			choosen_node = n
	return choosen_node, earliest_available_time
