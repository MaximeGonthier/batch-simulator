# Imports
import operator
from print_functions import *
from dataclasses import dataclass
@dataclass
class Data:
    unique_id: int
    start_time: int
    nb_task_using_it: int

# Remove jobs rom the main job list. I do it outside the loop because I need to go through the list before deleting
def remove_jobs_from_list(list_to_update, job_to_remove): # TODO: simplifier en 1 seule boucle ?
	for j1 in job_to_remove:
		for j2 in list_to_update:
			if (j1.unique_id == j2.unique_id):
				list_to_update.remove(j2)
	return list_to_update

# Add data in the node
def add_data_in_node(data_unique_id, data_size, node_used, t, walltime):
	# ~ print("Adding", data_unique_id)
	data_is_on_node = False
	waiting_for_a_load_time = 0
	# Let's try to find it in the node
	for d in node_used.data:
		if (data_unique_id == d.unique_id): # It is already on node
			if (d.nb_task_using_it > 0): # And is still valid!
				# ~ if (d.end_time < t + walltime): # New end time for the data cause current job will hold it for longer
					# ~ d.end_time = t + walltime
					
				if (d.start_time > t): # The job will have to wait for the data to be loaded by another job before starting
					transfer_time = d.start_time - t
					waiting_for_a_load_time = d.start_time - t
					# ~ print("In add data:", waiting_for_a_load_time)
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
	return transfer_time, waiting_for_a_load_time

def remove_data_from_node(l):
	for j in l:
		for d in j.node_used.data:
			if (j.data == d.unique_id):
				d.nb_task_using_it -= 1
				# ~ j.node_used.data.remove(d)
				break
	
def print_csv(to_print_list, scheduler):
	max_queue_time = 0
	mean_queue_time = 0
	total_queue_time = 0
	max_flow = 0
	mean_flow = 0
	total_flow = 0
	total_transfer_time = 0
	total_waiting_for_a_load_time = 0
	total_waiting_for_a_load_time_and_transfer_time = 0
	makespan = 0
	core_time_used = 0
	for tp in to_print_list:
		# ~ print("print", tp.job_unique_id)
		core_time_used += tp.time_used*tp.job_cores
		# ~ total_queue_time += tp.time - tp.job_subtime
		total_queue_time += tp.job_start_time - tp.job_subtime
		# ~ print("Job", tp.job_unique_id, "waited", tp.job_start_time - tp.job_subtime)
		if (max_queue_time < tp.job_start_time - tp.job_subtime):
			max_queue_time = tp.job_start_time - tp.job_subtime
		# ~ total_flow += tp.time - tp.job_subtime + tp.time_used
		total_flow += tp.job_end_time - tp.job_subtime
		if (max_flow < tp.job_end_time - tp.job_subtime):
			max_flow = tp.job_end_time - tp.job_subtime
		total_transfer_time += tp.transfer_time - tp.waiting_for_a_load_time
		total_waiting_for_a_load_time += tp.waiting_for_a_load_time
		total_waiting_for_a_load_time_and_transfer_time += tp.transfer_time
		# ~ if (makespan < tp.time + tp.time_used):
		if (makespan < tp.job_end_time):
			# ~ makespan = tp.time + tp.time_used
			makespan = tp.job_end_time
	mean_queue_time = total_queue_time/len(to_print_list)
	mean_flow = total_flow/len(to_print_list)
	file_to_open = "outputs/Results_" + scheduler + ".csv"
	f = open(file_to_open, "a")
	
	if (scheduler == "Fcfs_with_a_score"):
		scheduler = "Fcfs-Score"
	elif (scheduler == "Fcfs_easybf"):
		scheduler = "Fcfs-EasyBf"
	elif (scheduler == "Fcfs_with_a_score_easy_bf"):
		scheduler = "Fcfs-Score-EasyBf"
	
	f.write("%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n" % (scheduler, str(len(to_print_list)), str(max_queue_time), str(mean_queue_time), str(total_queue_time), str(max_flow), str(mean_flow), str(total_flow), str(total_transfer_time), str(makespan), str(core_time_used), str(total_waiting_for_a_load_time), str(total_waiting_for_a_load_time_and_transfer_time)))
	f.close()

def get_start_time_and_update_avail_times_of_cores(t, choosen_core, walltime):
	start_time = t
	for c in choosen_core:
		if (c.available_time > start_time):
			start_time = c.available_time
	for c in choosen_core:
		c.available_time = start_time + walltime
	return start_time

# Return set of files that will be on node at a given time
def files_on_node_at_certain_time(predicted_time, node, current_time):
	file_on_node = []
	
	if (current_time == predicted_time):
		for d in node.data:
			if (d.nb_task_using_it > 0):
				file_on_node.append(d.unique_id)
				# ~ print("on node", node.unique_id, "there is", d.unique_id)
	else:
		for c in node.cores:
			for j in c.job_queue:
				# ~ print("Job is on node", node.unique_id, j.unique_id)
				# ~ print("For job", j.unique_id, "transfer done at", j.start_time + j.transfer_time, "end at", j.start_time + j.walltime)
				if j.start_time + j.transfer_time <= predicted_time and j.start_time + j.walltime >= predicted_time: # Data will be loaded at this time
					if j.data not in file_on_node:
						file_on_node.append(j.data)
						# ~ print(j.data , "is on node of", node.unique_id)
					break # Break because no other possibility on this core ?
	return file_on_node

def size_files_ended_at_certain_time(predicted_time, cores, current_data):
	size_file_ended = 0
	# ~ if (current_time == predicted_time):
		# ~ for d in node.data:
			# ~ if (d.nb_task_using_it > 0):
				# ~ if d.unique_id != current_data:
					# ~ size_file_ended +=
	# ~ else:
	already_counted = []
	for c in cores:
		for j in c.job_queue:
			if j.start_time + j.walltime == predicted_time and j.data != current_data and j.data not in already_counted: # Data will end at this time
				size_file_ended += j.data_size
				already_counted.append(j.data)
				break
	return size_file_ended
	
# Schedule a job earliest available node and write start time and add job in queues
def schedule_job_on_earliest_available_cores(j, node_list, t, scheduled_job_list):
	if (j.index_node_list == 0): # Je peux choisir dans la liste entière
		nodes_to_choose_from = node_list[0] + node_list[1] + node_list[2]
	elif (j.index_node_list == 1): # Je peux choisir dans la 1 et la 2
		nodes_to_choose_from = node_list[1] + node_list[2]
	elif (j.index_node_list == 2): # Je peux choisir que dans la 2
		nodes_to_choose_from = node_list[2]
					
	min_time = -1	
	for n in nodes_to_choose_from:
		n.cores.sort(key = operator.attrgetter("available_time"))
		earliest_available_time = n.cores[j.cores - 1].available_time # -1 because tab start at 0	
		earliest_available_time = max(t, earliest_available_time) # A core can't be available before t. This happens when a node is idling						
		if min_time == -1:
			min_time = earliest_available_time
			choosen_node = n
		elif min_time > earliest_available_time:
			min_time = earliest_available_time
			choosen_node = n
													
	choosen_core = choosen_node.cores[0:j.cores]
	# ~ start_time = get_start_time_and_update_avail_times_of_cores(t, choosen_core, j.walltime) 
	start_time = min_time
	j.node_used = choosen_node
	j.cores_used = choosen_core
	j.start_time = start_time
	j.end_time = start_time + j.walltime	
			
	for c in choosen_core:
		c.job_queue.append(j)
		c.available_time = start_time + j.walltime
	
	scheduled_job_list.append(j)
	
	# ~ if __debug__:
		# ~ print_decision_in_scheduler(choosen_core, j, choosen_node)
		
	return scheduled_job_list

def return_earliest_available_cores_and_start_time_specific_node(cores_asked, node, t):
	node.cores.sort(key = operator.attrgetter("available_time"))
	earliest_available_time = node.cores[cores_asked - 1].available_time	
	earliest_available_time = max(t, earliest_available_time)
	choosen_core = choosen_node.cores[0:cores_asked]		
	return choosen_core, earliest_available_time
	
# Schedule a job earliest available node and write start time and add job in queues
def schedule_job_on_earliest_available_cores_no_return(j, node_list, t):
	if (j.index_node_list == 0): # Je peux choisir dans la liste entière
		nodes_to_choose_from = node_list[0] + node_list[1] + node_list[2]
	elif (j.index_node_list == 1): # Je peux choisir dans la 1 et la 2
		nodes_to_choose_from = node_list[1] + node_list[2]
	elif (j.index_node_list == 2): # Je peux choisir que dans la 2
		nodes_to_choose_from = node_list[2]
					
	min_time = -1	
	for n in nodes_to_choose_from:
		n.cores.sort(key = operator.attrgetter("available_time"))
		earliest_available_time = n.cores[j.cores - 1].available_time # -1 because tab start at 0	
		earliest_available_time = max(t, earliest_available_time) # A core can't be available before t. This happens when a node is idling						
		if min_time == -1:
			min_time = earliest_available_time
			choosen_node = n
		elif min_time > earliest_available_time:
			min_time = earliest_available_time
			choosen_node = n
													
	choosen_core = choosen_node.cores[0:j.cores]
	# ~ start_time = get_start_time_and_update_avail_times_of_cores(t, choosen_core, j.walltime) 
	start_time = min_time
	j.node_used = choosen_node
	j.cores_used = choosen_core
	j.start_time = start_time
	j.end_time = start_time + j.walltime			
	for c in choosen_core:
		c.job_queue.append(j)
		c.available_time = start_time + j.walltime
		
	# ~ if __debug__:
		# ~ print_decision_in_scheduler(choosen_core, j, choosen_node)

def reset_cores(l, t):
	for n in l:
		for c in n.cores:
			c.job_queue.clear()
			if c.running_job != None:
				c.available_time = c.running_job.start_time + c.running_job.walltime
				c.job_queue.append(c.running_job)
			else:
				c.available_time = t
			
# ~ def nb_available_cores(n, t):
	# ~ nb = 20
	# ~ for c in n.cores:
		# ~ c.job_queue.sort(key = operator.attrgetter("start_time"))
		# ~ for j in c.job_queue:
			# ~ if j.start_time <= t and j.end_time >= t: # A job is running right now
				# ~ print(j.unique_id, "runs at", t, "on node", n.unique_id)
				# ~ nb -= 1
				# ~ break
	# ~ return nb

def return_cores_not_running_a_job(node, nb_cores_to_return, t, critical_node, first_job_in_queue_cores):
	cores_to_return = []
	for c in node.cores:
		cant_add = False
		for j in c.job_queue:
			if ((j.start_time <= t and j.end_time >= t) or (critical_node == True and c in first_job_in_queue_cores)): # A job is running right now or it's the first job
				cant_add = True
				break
		if cant_add == False:
			cores_to_return.append(c)
			if len(cores_to_return) == nb_cores_to_return:
				return cores_to_return, True
	return cores_to_return, False
