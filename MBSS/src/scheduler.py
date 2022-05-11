# Imports
from basic_functions import *
from print_functions import *
import random
from dataclasses import dataclass
import operator
import math

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
    waiting_for_a_load_time: int
    workload: int
    
# Schedule random available jobs on random nodes and cores, even if not available
# The numbers here indicate the minimum you must do in a scheduler. In other scheduler there are more steps but they are optional.
def random_scheduler(available_job_list, node_list, t):
	
	# 1. Declare a list of job to remove and loop on available jobs
	# ~ job_to_remove = []
	for j in available_job_list:

		# 2. Choose a node, different list depending on file size
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
		# ~ print(choosen_core[0].available_time)
		# 5. Update jobs info and add job in choosen cores
		j.node_used = choosen_node
		j.cores_used = choosen_core
		j.start_time = start_time
		j.end_time = start_time + j.walltime			
		for c in choosen_core:
			c.job_queue.append(j)
									
		# Just for printing in terminal. Can be removed.
		# ~ print(choosen_core[0].job_queue[0].unique_id)
		# ~ print(choosen_core[0].job_queue[0].end_time)
		# ~ print("T =", t)
		if __debug__:
			print_decision_in_scheduler(choosen_core, j, choosen_node)
		
		# 6. Add job in list to remove
		# ~ job_to_remove.append(j)
		
		# ~ scheduled_job_list.append(j)
	
	# 7. Remove jobs from list
	# ~ available_job_list.clear()
	# ~ return scheduled_job_list
	
# Compute a score for each node.
# For each node, A = compute the earliest available time to host job j.
# For each node, B = compute the time it will take to load all the files from j not yet in memory.
# For each node, C = compute the amount of data that will need to be evicted to load all the files from j not yet in memory. These files will need to be re loaded for other jobs.
# Score = A + B + (C/BW)
# Schedule j on the node with the lowest score and on the cores available the earliest.
def fcfs_with_a_score_scheduler(l, node_list, t, variant):
	
	# 1. Declare a list of job to remove and loop on available jobs
	for j in l:
				
		# 2. Choose a node
		# 2.1. Different list depending on file size
		if (j.index_node_list == 0): # Je peux choisir dans la liste entière
			nodes_to_choose_from = node_list[0] + node_list[1] + node_list[2]
		elif (j.index_node_list == 1): # Je peux choisir dans la 1 et la 2
			nodes_to_choose_from = node_list[1] + node_list[2]
		elif (j.index_node_list == 2): # Je peux choisir que dans la 2
			nodes_to_choose_from = node_list[2]
					
		min_score = -1
			
		for n in nodes_to_choose_from:
									
			# 2.2. Sort cores by available times
			n.cores.sort(key = operator.attrgetter("available_time"))
				
			# 2.3. Get the earliest available time from the number of cores required by the job and add it to the score
			earliest_available_time = n.cores[j.cores - 1].available_time # -1 because tab start at 0
			earliest_available_time = max(t, earliest_available_time)
			# ~ print("Earliest time for node", n.unique_id, "is", earliest_available_time)
				
			# 2.4. Compute the time to load all data. For this look at the data that will be available at the earliest available time of the node
			if j.data == 0:
				time_to_load_file = 0
			else:
				# ~ print("earliest time is", earliest_available_time, "and t is", t)
				files_on_node = files_on_node_at_certain_time(earliest_available_time, n, t)
				# ~ print(files_on_node)
				# ~ print(j.data)
				if j.data in files_on_node:
					time_to_load_file = 0
				else:
					time_to_load_file = j.data_size/n.bandwidth
				# ~ print("Time to load is", time_to_load_file, "on node", n.unique_id)
				
			# 2.5. Get the amount of files that will be lost because of this load by computing the amount of data that end at the earliest time only on the supposely choosen cores, excluding current file of course
			size_files_ended = size_files_ended_at_certain_time(earliest_available_time, n.cores[0:j.cores], j.data)
			time_to_reload_evicted_files = size_files_ended/n.bandwidth
			
			# Compute node's score
			if (variant == 0):	
				score = earliest_available_time + time_to_load_file + time_to_reload_evicted_files
			elif (variant == 1):	
				score = earliest_available_time + 2*time_to_load_file + 2*time_to_reload_evicted_files
			else:
				print("Error variant fcfs with a score")
				exit(1)
			
			# 2.6. Get minimum score
			if min_score == -1:
				min_score = score
				choosen_node = n
			elif min_score > score:
				min_score = score
				choosen_node = n
					
		# ~ print("Min score for job", j.unique_id, "is", min_score, "with node", choosen_node.unique_id)
								
		# 3. Choose a core
		choosen_core = choosen_node.cores[0:j.cores]

		# 4. Get start time and update available times of the cores
		start_time = get_start_time_and_update_avail_times_of_cores(t, choosen_core, j.walltime) 
		
		# 5. Update jobs info and add job in choosen cores
		j.node_used = choosen_node
		j.cores_used = choosen_core
		j.start_time = start_time
		j.end_time = start_time + j.walltime			
		for c in choosen_core:
			c.job_queue.append(j)
									
		if __debug__:
			print_decision_in_scheduler(choosen_core, j, choosen_node)
		
		# 6. Add job in list to remove
		# ~ job_to_remove.append(j)
		
		# ~ scheduled_job_list.append(j)
		
	# 7. Remove jobs from list
	# ~ available_job_list.clear()
	# ~ return scheduled_job_list
	# ~ return l

# Just return choosen node and cores
def return_choice_fcfs_with_a_score_scheduler_single_job(j, node_list, t, variant):
	
	if (j.index_node_list == 0): # Je peux choisir dans la liste entière
		nodes_to_choose_from = node_list[0] + node_list[1] + node_list[2]
	elif (j.index_node_list == 1): # Je peux choisir dans la 1 et la 2
		nodes_to_choose_from = node_list[1] + node_list[2]
	elif (j.index_node_list == 2): # Je peux choisir que dans la 2
		nodes_to_choose_from = node_list[2]
					
	min_score = -1
			
	for n in nodes_to_choose_from:
									
		# 2.2. Sort cores by available times
		n.cores.sort(key = operator.attrgetter("available_time"))
				
		# 2.3. Get the earliest available time from the number of cores required by the job and add it to the score
		earliest_available_time = n.cores[j.cores - 1].available_time # -1 because tab start at 0
		earliest_available_time = max(t, earliest_available_time)
		# ~ print("Earliest time for node", n.unique_id, "is", earliest_available_time)
				
		# 2.4. Compute the time to load all data. For this look at the data that will be available at the earliest available time of the node
		if j.data == 0:
			time_to_load_file = 0
		else:
			# ~ print("earliest time is", earliest_available_time, "and t is", t)
			files_on_node = files_on_node_at_certain_time(earliest_available_time, n, t)
			# ~ print(files_on_node)
			# ~ print(j.data)
			if j.data in files_on_node:
				time_to_load_file = 0
			else:
				time_to_load_file = j.data_size/n.bandwidth
			# ~ print("Time to load is", time_to_load_file, "on node", n.unique_id)
				
		# 2.5. Get the amount of files that will be lost because of this load by computing the amount of data that end at the earliest time only on the supposely choosen cores, excluding current file of course
		size_files_ended = size_files_ended_at_certain_time(earliest_available_time, n.cores[0:j.cores], j.data)
		time_to_reload_evicted_files = size_files_ended/n.bandwidth
			
		# Compute node's score
		if (variant == 0):	
			score = earliest_available_time + time_to_load_file + time_to_reload_evicted_files
		elif (variant == 1):	
			score = earliest_available_time + 2*time_to_load_file + 2*time_to_reload_evicted_files
		else:
			print("Error variant fcfs with a score")
			exit(1)
		
		# 2.6. Get minimum score
		if min_score == -1:
			min_score = score
			choosen_node = n
		elif min_score > score:
			min_score = score
			choosen_node = n
					
	# ~ print("Min score for job", j.unique_id, "is", min_score, "with node", choosen_node.unique_id)
								
	# 3. Choose a core
	choosen_core = choosen_node.cores[0:j.cores]
	
	return choosen_node, choosen_core

# Reschedule on same node task from affected node
def maximum_use_single_file_re_scheduler(l, t, affected_node_list):
	for j in l:
		if j.node_used in affected_node_list: # Need to rescheule this job
			j.node_used.cores.sort(key = operator.attrgetter("available_time"))
			earliest_available_time = j.node_used.cores[j.cores - 1].available_time 
			earliest_available_time = max(t, earliest_available_time)
			
			choosen_core = j.node_used.cores[0:j.cores]

			# 4. Get start time and update available times of the cores
			start_time = get_start_time_and_update_avail_times_of_cores(t, choosen_core, j.walltime) 
		
			# 5. Update jobs info and add job in choosen cores
			# ~ j.node_used = choosen_node
			j.cores_used = choosen_core
			j.start_time = start_time
			j.end_time = start_time + j.walltime			
			for c in choosen_core:
				c.job_queue.append(j)
									
			# Just for printing in terminal. Can be removed.
			if __debug__:
				print_decision_in_scheduler(choosen_core, j, j.node_used)

# Find the file shared the most among available jobs. Schedule all jobs using this file on a node using this file with most available cores.
# Then repeat until the list of available jobs is empty.
# For jobs with no file they will be schedule after on the earlieast available node
def maximum_use_single_file_scheduler(l, node_list, t):
	
	# 1. Find the file shared the most among available jobs
	# ~ print_job_info_from_list(available_job_list, t)
	file_distribution = []
	for j in l:
		file_distribution.append(j.data)
	counter = 0
	most_shared_file = file_distribution[0]
	for i in file_distribution:
		curr_frequency = file_distribution.count(i)
		# ~ print(curr_frequency, i)
		if(curr_frequency > counter and i != 0):
			counter = curr_frequency
			most_shared_file = i
	# ~ print("Most shared file is", most_shared_file)
	# get an example job for cores asked and index
	for j in l:
		if (j.data == most_shared_file):
			j_example = j
			break

	# If no file is shared, I just schedule all available jobs on eariest available times
	if (most_shared_file == 0):
		# ~ print("Most shared file  is 0, zut...")
		for j in l:
			# ~ scheduled_job_list = schedule_job_on_earliest_available_cores(j, node_list, t, scheduled_job_list)
			schedule_job_on_earliest_available_cores_no_return(j, node_list, t)
		l.clear()
		# ~ return scheduled_job_list
		return l
				
	# 2. Choose a node
	if (j_example.index_node_list == 0): # Je peux choisir dans la liste entière
		nodes_to_choose_from = node_list[0] + node_list[1] + node_list[2]
	elif (j_example.index_node_list == 1): # Je peux choisir dans la 1 et la 2
		nodes_to_choose_from = node_list[1] + node_list[2]
	elif (j_example.index_node_list == 2): # Je peux choisir que dans la 2
		nodes_to_choose_from = node_list[2]
		
	# 2.1. Find the set of node using this file at the predicted earliest start time of the node.
	min_earliest_available_time = -1
	choosen_node = None
	for n in nodes_to_choose_from:
		# 2.2. Sort cores by available times
		n.cores.sort(key = operator.attrgetter("available_time"))
				
		# 2.3. Get the earliest available time from the number of cores required by the job
		earliest_available_time = n.cores[j_example.cores - 1].available_time # -1 because tab start at 0
		earliest_available_time = max(t, earliest_available_time)

		# 2.4. Look if the file choosen will be available at earliest available time
		files_on_node = files_on_node_at_certain_time(earliest_available_time, n, t)
		
		# 2.5 Look for node with earliest time and file loaded
		if most_shared_file in files_on_node:
			if min_earliest_available_time == -1:
				min_earliest_available_time = earliest_available_time
				choosen_node = n
			elif min_earliest_available_time > earliest_available_time:
				min_earliest_available_time = earliest_available_time
				choosen_node = n
		
	# Means that the file is not in any node. So schedule all jobs using file on earliest available node only.
	if (choosen_node == None):
		# ~ print("Choosen node is None :/ The file is not anywhere at time t")
		min_earliest_available_time = -1
		for n in nodes_to_choose_from:
			n.cores.sort(key = operator.attrgetter("available_time"))
			earliest_available_time = n.cores[j_example.cores - 1].available_time # -1 because tab start at 0
			earliest_available_time = max(t, earliest_available_time)
			if min_earliest_available_time == -1:
				min_earliest_available_time = earliest_available_time
				choosen_node = n
			elif min_earliest_available_time > earliest_available_time:
				min_earliest_available_time = earliest_available_time
				choosen_node = n
		# ~ print("Choosen node after None is", choosen_node.unique_id)
	# ~ else:
		# ~ print("Choosen node is", choosen_node.unique_id, "it uses the choosen file!")
	
	job_to_remove = [] # Here I need it because I don't always schedule everything in one call of maximum_use_single_file_scheduler
	
	# Schedule all jobs using file on choosen node
	for j in l:
		
		if j.data == most_shared_file: # We need to schedule it
			
			# 3. Choose a core for each job using this data
			choosen_node.cores.sort(key = operator.attrgetter("available_time"))
			choosen_core = choosen_node.cores[0:j_example.cores]

			# 4. Get start time and update available times of the cores
			start_time = get_start_time_and_update_avail_times_of_cores(t, choosen_core, j.walltime) 
		
			# 5. Update jobs info and add job in choosen cores
			j.node_used = choosen_node
			j.cores_used = choosen_core
			j.start_time = start_time
			j.end_time = start_time + j.walltime			
			for c in choosen_core:
				c.job_queue.append(j)
									
			# Just for printing in terminal. Can be removed.
			if __debug__:
				print_decision_in_scheduler(choosen_core, j, choosen_node)
		
			# 6. Add job in list to remove
			job_to_remove.append(j)
			
			# ~ scheduled_job_list.append(j)
		
	# 7. Remove jobs from list
	l = remove_jobs_from_list(l, job_to_remove)
	# ~ exit(1)
	# ~ return scheduled_job_list
	return l

def fcfs(available_job_list, node_list, t, scheduled_job_list):
	for j in available_job_list:
		scheduled_job_list = schedule_job_on_earliest_available_cores(j, node_list, t, scheduled_job_list)
	available_job_list.clear()
	return scheduled_job_list
	
def fcfs_scheduler(l, node_list, t):
	# ~ i = 0
	for j in l:
		# ~ i += 1
		# ~ if i > 100:
			# ~ break
		schedule_job_on_earliest_available_cores_no_return(j, node_list, t)

def common_file_packages_with_a_score(l, node_list, t, total_number_cores):
	# Find all jobs using the same file as the first job in the queue. 
	# The job list is sorted by submission time so it's easy, I can just take all 
	# consecutive job in the list with the same data and one the data change it's a new package.
	# Still need to deal with 0 data jobs that is not in order in the list
	print("Start of common_file_packages_with_a_score")
	list_of_packages = []
	temp = l
	number_cores_asked = 0
	
	while (len(temp) > 0):
		new_package = []
		data_first_job = l[0].data
		print("First data is", data_first_job)
		
		job_to_remove = []
		# Get all jobs with this data, even if it's 0
		for j in l:
			if j.data == data_first_job:
				new_package.append(j)
				number_cores_asked += j.cores
				job_to_remove.append(j)
			else:
				if data_first_job != 0:
					break # Because data shares are consecutive and it's sorted by submission time
		list_of_packages.append(new_package)
		temp = remove_jobs_from_list(temp, job_to_remove)

	# Just printing
	i = 1
	for p in list_of_packages:
		print("Jobs of package number", i)
		for j in p:
			print(j.unique_id)
		i += 1
	print("Number of asked cores", number_cores_asked, "Total number of cores is", total_number_cores)
	
	# Divide
	max_number_cores_asked_by_package = math.ceil(number_cores_asked/total_number_cores)

	print("A package can have up to", max_number_cores_asked_by_package, "cores asked")
		
	# Compute score just like in Fcfs_with_a_score but with packages. The benefit of not loading a file is only counted once.
	# Choose node
	cores_asked_current_package = 0
	for p in list_of_packages:
		for j in p:
			# For the first job of the sub package you get the node. Then you only get earliest available cores
			if (cores_asked_current_package == 0):
				choosen_node, choosen_core = return_choice_fcfs_with_a_score_scheduler_single_job(j, node_list, t, 0)
			elif (cores_asked_current_package <= max_number_cores_asked_by_package):
				# Schedule on the same node as previously but different cores probably so need to get the cores
				choosen_core, earliest_available_time = return_earliest_available_cores_and_start_time_specific_node(j.cores, choosen_node, t)
			
			# TODO : a opti et get earliest time for first job as well
			start_time = get_start_time_and_update_avail_times_of_cores(t, choosen_core, j.walltime) 
			j.node_used = choosen_node
			j.cores_used = choosen_core
			j.start_time = start_time
			j.end_time = start_time + j.walltime			
			for c in choosen_core:
				c.job_queue.append(j)
			cores_asked_current_package += j.cores
			if (cores_asked_current_package > max_number_cores_asked_by_package):
				# Getting on a new sub_package
				cores_asked_current_package = 0

	
	exit(1)
