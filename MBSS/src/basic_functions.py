# Imports
import operator
from print_functions import *
from dataclasses import dataclass
@dataclass
class Data:
    unique_id: int
    start_time: int
    end_time: int
    nb_task_using_it: int
    temp_interval_usage_time: list
    size: int

def get_current_intervals(node_list, t):
	for n in node_list:
		for d in n.data:
			d.temp_interval_usage_time.clear()
			if d.nb_task_using_it > 0:
				d.temp_interval_usage_time.append(t)
				if d.start_time < t:
					d.temp_interval_usage_time.append(t)
				else:
					d.temp_interval_usage_time.append(d.start_time)
				d.temp_interval_usage_time.append(d.end_time)
			elif d.nb_task_using_it == 0 and d.end_time >= t:
				d.temp_interval_usage_time.append(t)
				d.temp_interval_usage_time.append(t)
				d.temp_interval_usage_time.append(t)
	
# Remove jobs rom the main job list. I do it outside the loop because I need to go through the list before deleting
def remove_jobs_from_list(list_to_update, job_to_remove): # TODO: simplifier en 1 seule boucle ?
	for j1 in job_to_remove:
		for j2 in list_to_update:
			if (j1.unique_id == j2.unique_id):
				list_to_update.remove(j2)
	return list_to_update

# Add data in the node
def add_data_in_node(data_unique_id, data_size, node_used, t, end_time):
	# ~ print("Adding", data_unique_id)
	data_is_on_node = False
	waiting_for_a_load_time = 0
	# Let's try to find it in the node
	for d in node_used.data:
		if (data_unique_id == d.unique_id): # It is already on node
			# ~ if (d.nb_task_using_it > 0): # And is still valid!
			# ~ print(d.end_time)
			if (d.nb_task_using_it > 0 or d.end_time == t): # And is still valid!
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
			
			if d.end_time < end_time:
				d.end_time = end_time
			
			break
	
	if (data_is_on_node == False): # Need to load it
		transfer_time = data_size/node_used.bandwidth
		# Create a class Data for this node
		d = Data(data_unique_id, t + transfer_time, end_time, 1, list(), data_size)
		# ~ d = Data(data_unique_id, t + transfer_time, 1, list())
		node_used.data.append(d)
		
	if __debug__:
		print("Adding", data_unique_id, "s/e:", d.start_time, d.end_time, "on node", node_used.unique_id, "has a transfer time of", transfer_time, "at time", t)
		
	return transfer_time, waiting_for_a_load_time

def remove_data_from_node(l, t):
	for j in l:
		for d in j.node_used.data:
			if (j.data == d.unique_id):
				# ~ print("--", d.unique_id, "node", j.node_used.unique_id)
				d.nb_task_using_it -= 1
				
				if d.nb_task_using_it == 0:
					d.end_time = t
				
				# ~ print(d.nb_task_using_it)
				# ~ j.node_used.data.remove(d)
				break

def get_cores_non_available_cores(node_list, t):
	nb_non_available_cores = 0
	for n in node_list[0] + node_list[1] + node_list[2]:
		for c in n.cores:
			if c.available_time > t:
				nb_non_available_cores += 1
	nb_cores = len(node_list[0] + node_list[1] + node_list[2])*20
	return nb_cores, nb_non_available_cores

def print_csv(to_print_list, scheduler):
	# For distribution of flow and queue times on each job
	f_queue = open("outputs/Queue_times_" + scheduler + ".txt", "w")
	f_flow = open("outputs/Flow_times_" + scheduler + ".txt", "w")
	f_stretch= open("outputs/Stretch_times_" + scheduler + ".txt", "w")
	
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
	total_flow_stretch = 0
	total_flow_stretch_with_a_minimum = 0
	mean_flow_stretch = 0
	mean_flow_stretch_with_a_minimum = 0
	core_time_used = 0
	job_exceeding_minimum = 0
	for tp in to_print_list:
		
		# Flow stretch
		total_flow_stretch += (tp.job_end_time - tp.job_subtime)/tp.empty_cluster_time
		
		if tp.job_end_time - tp.job_start_time >= 300: # Ignore jobs of delay less that 5 minutes
			total_flow_stretch_with_a_minimum += (tp.job_end_time - tp.job_subtime)/tp.empty_cluster_time
			job_exceeding_minimum += 1
		
		# ~ print((tp.job_end_time - tp.job_subtime), tp.empty_cluster_time)
		
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
		
		# For distribution of flow and queue times on each job to show VS curves
		f_queue.write("%d %d %d %d %d\n" % (tp.job_unique_id, tp.job_start_time - tp.job_subtime, tp.data_type, tp.job_end_time - tp.job_start_time, tp.job_subtime))
		f_flow.write("%d %d %d %d %d\n" % (tp.job_unique_id, tp.job_end_time - tp.job_subtime, tp.data_type, tp.job_end_time - tp.job_start_time, tp.job_subtime))
		f_stretch.write("%d %d %d %d %d\n" % (tp.job_unique_id, (tp.job_end_time - tp.job_subtime)/tp.empty_cluster_time, tp.data_type, tp.job_end_time - tp.job_start_time, tp.job_subtime))
	
	f_queue.close()
	f_flow.close()
	f_stretch.close()
		
	# Compute mean values
	mean_queue_time = total_queue_time/len(to_print_list)
	mean_flow = total_flow/len(to_print_list)
	mean_flow_stretch = total_flow_stretch/len(to_print_list)
	mean_flow_stretch_with_a_minimum = total_flow_stretch_with_a_minimum/job_exceeding_minimum
	file_to_open = "outputs/Results_" + scheduler + ".csv"
	f = open(file_to_open, "a")
	
	# Simplify alorithms names
	if (scheduler == "Fcfs_with_a_score"):
		scheduler = "Fcfs-Score"
	elif (scheduler == "Fcfs_easybf"):
		scheduler = "Fcfs-EasyBf"
	elif (scheduler == "Fcfs_with_a_score_easy_bf"):
		scheduler = "Fcfs-Score-EasyBf"
	
	f.write("%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n" % (scheduler, str(len(to_print_list)), str(max_queue_time), str(mean_queue_time), str(total_queue_time), str(max_flow), str(mean_flow), str(total_flow), str(total_transfer_time), str(makespan), str(core_time_used), str(total_waiting_for_a_load_time), str(total_waiting_for_a_load_time_and_transfer_time), str(mean_flow_stretch)))
	f.close()
	
	# For flow stretch heat map
	file_to_open = "outputs/Stretch_" + scheduler + ".txt"
	f = open(file_to_open, "w")
	f.write("%s" % (str(mean_flow_stretch)))
	f.close()
	
	# For flow stretch with a minimum heat map
	file_to_open = "outputs/Stretch_with_a_minimum_" + scheduler + ".txt"
	f = open(file_to_open, "w")
	f.write("%s" % (str(mean_flow_stretch_with_a_minimum)))
	f.close()
	
	# For total flow heat map
	file_to_open = "outputs/Total_flow_" + scheduler + ".txt"
	f = open(file_to_open, "w")
	f.write("%s" % (str(total_flow)))
	f.close()

def get_start_time_and_update_avail_times_of_cores(t, choosen_core, walltime, nb_non_available_cores):
	start_time = t
	for c in choosen_core:
		if (c.available_time > start_time):
			start_time = c.available_time
	for c in choosen_core:
		
		# Test reduced complexity
		if c.available_time <= t:
			nb_non_available_cores += 1
		
		c.available_time = start_time + walltime
	return start_time, nb_non_available_cores

# ~ # Return set of files that will be on node at a given time
# ~ def files_on_node_at_certain_time(predicted_time, node, current_time):
	# ~ file_on_node = []
	
	# ~ if (current_time == predicted_time):
		# ~ for d in node.data:
			# ~ if (d.nb_task_using_it > 0):
				# ~ file_on_node.append(d.unique_id)
	# ~ else:
		# ~ for c in node.cores:
			# ~ for j in c.job_queue:
				# ~ if j.start_time + j.transfer_time <= predicted_time and j.start_time + j.walltime >= predicted_time: # Data will be loaded at this time
					# ~ if j.data not in file_on_node:
						# ~ file_on_node.append(j.data)
					# ~ break # Break because no other possibility on this core ?
	# ~ return file_on_node
	
# Return transfer time and return if the file is being loaded
def is_my_file_on_node_at_certain_time_and_transfer_time (predicted_time, node, current_time, current_data, current_data_size):
	
		# ~ for n in nodes:
	# ~ print("Get transfer time")
	for d in node.data:
			# ~ print("Data", d.unique_id, "is on node", n.unique_id, "and has", len(d.temp_interval_usage_time), "intervals")
		if d.unique_id == current_data and len(d.temp_interval_usage_time) > 0:
			# ~ print(d.unique_id, "is on node", n.unique_id, "but at time", predicted_time, "?")
			i = 0
			while i < len(d.temp_interval_usage_time):
				# ~ print("Checking", d.temp_interval_usage_time[i], "|", d.temp_interval_usage_time[i + 1], "|", d.temp_interval_usage_time[i + 2])
				if d.temp_interval_usage_time[i] <= predicted_time and d.temp_interval_usage_time[i + 1] <= predicted_time and predicted_time <= d.temp_interval_usage_time[i + 2]:
					return 0, False
				elif d.temp_interval_usage_time[i] <= predicted_time and predicted_time <= d.temp_interval_usage_time[i + 2]:
					return d.temp_interval_usage_time[i + 1] - current_time, True
				i += 3
			break	
	return current_data_size/node.bandwidth, False
	
	# ~ for c in node.data:
		# ~ for j in c.job_queue:
			# ~ if j.data == current_data:
				# ~ if j.start_time + j.transfer_time <= predicted_time and j.start_time + j.walltime >= predicted_time: # Data will be loaded at this time
					# ~ return 0, False
				# ~ elif j.start_time <= predicted_time and j.start_time + j.walltime >= predicted_time: # Data is being loaded at this time
					# ~ return j.start_time + j.transfer_time - current_time, True
	# ~ return current_data_size/node.bandwidth, False
	
	# ~ for c in node.cores:
		# ~ for j in c.job_queue:
			# ~ if j.data == current_data:
				# ~ if j.start_time + j.transfer_time <= predicted_time and j.start_time + j.walltime >= predicted_time: # Data will be loaded at this time
					# ~ return 0, False
				# ~ elif j.start_time <= predicted_time and j.start_time + j.walltime >= predicted_time: # Data is being loaded at this time
					# ~ return j.start_time + j.transfer_time - current_time, True
	# ~ return current_data_size/node.bandwidth, False

def size_files_ended_at_before_certain_time(predicted_time, data_list, current_data, percentage_occupied):
	#NEW with % of space you take
	size_file_ended = 0
	# ~ print("Start of size_files_ended_at_before_certain_time")
	for d in data_list:
		if d.unique_id != current_data and len(d.temp_interval_usage_time) > 0:
			# ~ print("Checking", d.temp_interval_usage_time[len(d.temp_interval_usage_time) - 1])
			if predicted_time >= d.temp_interval_usage_time[len(d.temp_interval_usage_time) - 1]:
				size_file_ended += d.size
				# ~ print("Add", d.size)
	# ~ print("Total size of data on node ending before my EAT is:", size_file_ended, "but I return", percentage_occupied, "of it:", size_file_ended*percentage_occupied)
	return size_file_ended*percentage_occupied

# ~ def size_files_ended_at_certain_time(predicted_time, node, current_data):
	# OLD
	# ~ print("Not coded, un-comment it.")
	# ~ exit(1)
	# ~ size_file_ended = 0
	# ~ already_counted = []
	# ~ for c in cores:
		# ~ for j in c.job_queue:
			# ~ if j.start_time + j.walltime == predicted_time and j.data != current_data and j.data not in already_counted: # Data will end at this time
				# ~ print("File", j.data, "of size", j.data_size, "end at time", predicted_time)
				# ~ size_file_ended += j.data_size
				# ~ already_counted.append(j.data)
				# ~ break
	# ~ return size_file_ended

def get_nb_valid_copy_of_a_file(predicted_time, nodes, current_data):
	nb_of_copy = 0
	
	for n in nodes:
		for d in n.data:
			# ~ print("Data", d.unique_id, "is on node", n.unique_id, "and has", len(d.temp_interval_usage_time), "intervals")
			if d.unique_id == current_data and len(d.temp_interval_usage_time) > 0:
				# ~ print(d.unique_id, "is on node", n.unique_id, "but at time", predicted_time, "?")
				i = 0
				while i < len(d.temp_interval_usage_time):
					# ~ print("Checking", d.temp_interval_usage_time[i], "|", d.temp_interval_usage_time[i + 2])
					if d.temp_interval_usage_time[i] <= predicted_time and predicted_time <= d.temp_interval_usage_time[i + 2]:
						nb_of_copy += 1
						# ~ print("++")
						break
					i += 3
				break	
	return nb_of_copy

# Return the number of copy of a file at a certain time in the future
# ~ def get_nb_valid_copy_of_a_file(predicted_time, nodes, current_data):
	# ~ nb_of_copy = 0
	# ~ need_to_break = False
	# ~ for n in nodes:
		# ~ print(n.unique_id)
		# ~ if current_data in n.data:
			# ~ exit(1)
		# ~ for d in n.data:
			# ~ if d.unique_id == current_data:
				# ~ nb_of_copy += 1
				# ~ break
			# ~ print(d.unique_id, d.nb_task_using_it, d.start_time)
	# ~ exit(1)
		# ~ for c in n.cores:
			# ~ for j in c.job_queue:
				# ~ if j.data == current_data:
					# ~ if j.start_time <= predicted_time and j.start_time + j.walltime >= predicted_time: # Data will be loaded at this time
						# ~ nb_of_copy += 1
						# ~ # We can go on the next node now
						# ~ need_to_break = True
						# ~ break
			# ~ if need_to_break == True:
				# ~ need_to_break = False
				# ~ break
	# ~ print(nb_of_copy)
	# ~ return nb_of_copy
	
# Return the number of copy of a file at a certain time in the future
# ~ def get_nb_valid_copy_of_each_file(nodes):
	# ~ nb_of_copy = 0
	# ~ need_to_break = False
	# ~ list_of_files_all_node = []
	# ~ for n in nodes:
		# ~ for d in n.data:
			# ~ if d.nb_task_using_it > 1:
				# ~ list_of_files_all_node.append(d.unique_id)
	# ~ return list_of_files_all_node		
	# ~ for i in list_of_files_all_node:
		
	# ~ couple = (i, list_of_files_all_node.count(i))
	# ~ unique_file_all_node.append(couple)
	
		# ~ print(n.unique_id)
		# ~ if current_data in n.data:
			# ~ exit(1)
		# ~ for d in n.data:
			# ~ if d.unique_id == current_data:
				# ~ nb_of_copy += 1
				# ~ break
			# ~ print(d.unique_id, d.nb_task_using_it, d.start_time)
	# ~ exit(1)
		# ~ for c in n.cores:
			# ~ for j in c.job_queue:
				# ~ if j.start_time <= predicted_time and j.start_time + j.walltime >= predicted_time: # Data will be loaded at this time
					# ~ if j.data not in list_of_files_one_node:
						# ~ list_of_files_one_node.append(j.data)
					# ~ break
		# ~ list_of_files_all_node.append(list_of_files_one_node)
	
	# ~ for i in list_of_files_all_node:
		# ~ if list_of_files_all_node[i] not in unique_file_all_node:
			# ~ unique_file_all_node.append(list_of_files_all_node[i], list_of_files_all_node.count(i))
	
	# ~ return unique_file_all_node
					# ~ nb_of_files_on_nodes.append(j.data)
				# ~ if j.data == current_data:
					# ~ if j.start_time <= predicted_time and j.start_time + j.walltime >= predicted_time: # Data will be loaded at this time
						# ~ nb_of_copy += 1
						# ~ # We can go on the next node now
						# ~ need_to_break = True
						# ~ break
			# ~ if need_to_break == True:
				# ~ need_to_break = False
				# ~ break
	# ~ print(nb_of_copy)
	# ~ return nb_of_copy

	
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
	
	if __debug__:
		print_decision_in_scheduler(choosen_core, j, choosen_node)
		
	return scheduled_job_list

def return_earliest_available_cores_and_start_time_specific_node(cores_asked, node, t):
	node.cores.sort(key = operator.attrgetter("available_time"))
	earliest_available_time = node.cores[cores_asked - 1].available_time	
	earliest_available_time = max(t, earliest_available_time)
	choosen_core = node.cores[0:cores_asked]		
	return choosen_core, earliest_available_time
	
# Schedule a job earliest available node and write start time and add job in queues
def schedule_job_on_earliest_available_cores_no_return(j, node_list, t, nb_non_available_cores):
	if (j.index_node_list == 0): # Je peux choisir dans la liste entière
		nodes_to_choose_from = node_list[0] + node_list[1] + node_list[2]
		# ~ nodes_to_choose_from = node_list[0]
	elif (j.index_node_list == 1): # Je peux choisir dans la 1 et la 2
		nodes_to_choose_from = node_list[1] + node_list[2]
		# ~ nodes_to_choose_from = node_list[1]
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
	# start_time = get_start_time_and_update_avail_times_of_cores(t, choosen_core, j.walltime) 
	start_time = min_time
	j.node_used = choosen_node
	j.cores_used = choosen_core
	j.start_time = start_time
	j.end_time = start_time + j.walltime			
	for c in choosen_core:
		c.job_queue.append(j)
		
		# Test reduced complexity
		if c.available_time <= t:
			nb_non_available_cores += 1
			
		c.available_time = start_time + j.walltime
		
	if __debug__:
		print_decision_in_scheduler(choosen_core, j, choosen_node)
	
	return nb_non_available_cores
	
# Schedule a job earliest available node and write start time and add job in queues
def schedule_job_on_earliest_available_cores_no_return_no_use_bigger_nodes(j, node_list, t, nb_non_available_cores):
	if (j.index_node_list == 0):
		nodes_to_choose_from = node_list[0]
		# ~ nodes_to_choose_from = node_list[0]
	elif (j.index_node_list == 1):
		nodes_to_choose_from = node_list[1]
		# ~ nodes_to_choose_from = node_list[1]
	elif (j.index_node_list == 2):
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
	# start_time = get_start_time_and_update_avail_times_of_cores(t, choosen_core, j.walltime) 
	start_time = min_time
	j.node_used = choosen_node
	j.cores_used = choosen_core
	j.start_time = start_time
	j.end_time = start_time + j.walltime			
	for c in choosen_core:
		c.job_queue.append(j)
		
		# Test reduced complexity
		if c.available_time <= t:
			nb_non_available_cores += 1
			
		c.available_time = start_time + j.walltime
		
	if __debug__:
		print_decision_in_scheduler(choosen_core, j, choosen_node)
	
	return nb_non_available_cores

# Same but from a specific node list		
def schedule_job_on_earliest_available_cores_specific_sublist_node_no_return(j, sublist_node, t, nb_non_available_cores):					
	min_time = -1	
	for n in sublist_node:
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
	# start_time = get_start_time_and_update_avail_times_of_cores(t, choosen_core, j.walltime) 
	start_time = min_time
	j.node_used = choosen_node
	j.cores_used = choosen_core
	j.start_time = start_time
	j.end_time = start_time + j.walltime			
	for c in choosen_core:
		c.job_queue.append(j)
		
		# Test reduced complexity
		if c.available_time <= t:
			nb_non_available_cores += 1
		
		c.available_time = start_time + j.walltime
		
	if __debug__:
		print_decision_in_scheduler(choosen_core, j, choosen_node)
		
	return nb_non_available_cores

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
