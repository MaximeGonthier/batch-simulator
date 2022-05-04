# python3 src/main.py workload cluster scheduler

# TODO : Gérer les évictions ?

# Imports
from dataclasses import dataclass
import random
import sys
import operator
from read_input_files import *
from print_functions import *
from basic_functions import *
from scheduler import *
from filling_strategy import *
# ~ aaa = 0
# Getting arguments
input_job_file = sys.argv[1]
input_node_file = sys.argv[2]
scheduler = sys.argv[3]
# ~ filling_strategy = sys.argv[4]
write_all_jobs = int(sys.argv[4]) # Si on veut faire un gantt chart il faut imprimer tous les jobs et mettre ca à 1
# ~ aaa = int(0)
# Global structs and input files
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
@dataclass
class Node:
    unique_id: int
    memory: int
    bandwidth: float
    data: list
    cores: list
    n_available_cores: int
@dataclass
class Data:
    unique_id: int
    start_time: int
    nb_task_using_it: int
@dataclass
class Core:
    unique_id: int
    job_queue: list
    available_time: int
    running_job: None
@dataclass
class To_print: # Struct used to know what to print later in csv
    job_unique_id: int
    job_subtime: int
    node_unique_id: int
    core_unique_id: list
    time: int
    time_used: int
    transfer_time: int
    job_start_time: int
    job_end_time: int
    job_cores: int
    waiting_for_a_load_time: int
   
job_list = []
available_job_list = []
scheduled_job_list = []
to_print_list = []
# ~ node_list = []
# ~ available_node_list = [] # Contient aussi les coeurs disponibles

# Ce sont des listes de listes
# ~ sub_list = []
node_list =  [[] for _ in range(3)] # Nb of different sizes of memory
available_node_list =  [[] for _ in range(3)] # Nb of different sizes of memory

to_print_list = [] # TODO : utilisé ?
t = 0 # Current time start at 0

def start_jobs_single_job(t, j):
	if (j.start_time == t):
		transfer_time = 0
		waiting_for_a_load_time = 0
		if (j.data != 0):
			# Let's look if a data transfer is needed
			transfer_time, waiting_for_a_load_time = add_data_in_node(j.data, j.data_size, j.node_used, t, j.walltime)
		j.transfer_time = transfer_time
		j.waiting_for_a_load_time = waiting_for_a_load_time
		j.end_time = j.start_time + min(j.delay + transfer_time, j.walltime) # Attention le j.end time est mis a jour la!
		
		for c in j.cores_used:
			c.job_queue.remove(j)
			c.running_job = j
		
		if (j.delay + transfer_time < j.walltime):
			j.end_before_walltime = True
		# Remove from available cores used cores
		j.node_used.n_available_cores -= j.cores
	else:
		print("Error start job single job, time is", t, "and start time is", j.start_time)
		exit(1)

def start_jobs(t, scheduled_job_list):
	for j in scheduled_job_list:
		if (j.start_time == t):
			transfer_time = 0
			waiting_for_a_load_time = 0
			if (j.data != 0):
				# Let's look if a data transfer is needed
				transfer_time, waiting_for_a_load_time = add_data_in_node(j.data, j.data_size, j.node_used, t, j.walltime)
			j.transfer_time = transfer_time
			j.waiting_for_a_load_time = waiting_for_a_load_time
			j.end_time = j.start_time + min(j.delay + transfer_time, j.walltime) # Attention le j.end time est mis a jour la!
			if (j.delay + transfer_time < j.walltime):
				j.end_before_walltime = True
			print("Job", j.unique_id, "start at", t, "and will end at", j.end_time, j.end_before_walltime)
			# Remove from available cores used cores
			j.node_used.n_available_cores -= j.cores

def end_jobs(t, scheduled_job_list, finished_jobs, affected_node_list):
	jobs_to_remove = []
	for j in scheduled_job_list:
		if (j.end_time == t): # A job has finished, let's remove it from the cores, write its results and figure out if we need to fill
			finished_jobs += 1

			# Just printing, can remove
			if (finished_jobs%100 == 0):
				print(finished_jobs, "/", total_number_jobs, "T =", t, end = "")
				if (finished_jobs%70 == 1):
					print("  ~~~~ \\(°.°)/ ~~~~")
				elif (finished_jobs%60 == 1):
					print("  ~~~~ \\(°-°)/ ~~~~")
				elif (finished_jobs%50 == 1):
					print("  ~~~~ \\(°o°)/ ~~~~")
				elif (finished_jobs%40 == 1):
					print("  #### \\(°O°)/ ####")
				elif (finished_jobs%30 == 1):
					print("  ~~~~ /(°o°)\\ ~~~~")
				elif (finished_jobs%20 == 1):
					print("  ~~~~ /(°-°)\\ ~~~~")
				elif (finished_jobs%10 == 1):
					print("  ~~~~ /(°.°)\\ ~~~~")
					
			print("Job", j.unique_id, "finished at time", t, finished_jobs, "finished jobs")
			
			finished_job_list.append(j)
			
			core_ids = []
			for i in range (0, len(j.cores_used)):
				# ~ j.cores_used[i].job_queue.remove(j)
				j.cores_used[i].running_job = None
								
				# ~ if (j.end_before_walltime == True):
					# ~ j.cores_used[i].available_time = t
					
				core_ids.append(j.cores_used[i].unique_id)
						
			to_print_job_csv(j, j.node_used.unique_id, core_ids, t)

			if (j.end_before_walltime == True and j.node_used not in affected_node_list): # Need to backfill or shiftleft depending on the strategy OLD
				affected_node_list.append(j.node_used)
			jobs_to_remove.append(j)
			# Add cores
			j.node_used.n_available_cores += j.cores
	scheduled_job_list = remove_jobs_from_list(scheduled_job_list, jobs_to_remove)
						
	return finished_jobs, affected_node_list, finished_job_list

# Try to schedule immediatly in FCFS order without delaying first_job_in_queue
def easy_backfill(first_job_in_queue, t, node_list, available_job_list, scheduled_job_list):
	# ~ print("Début de Easy BackFilling...")
	job_to_remove = []
	# ~ print_job_info_from_list(available_job_list, t)
	for j in available_job_list:
		# ~ print("Try to backfill", j.unique_id, "at time", t, "first job is", first_job_in_queue.unique_id)
		# ~ choosen_node = None
		# ~ nb_possible_cores = 0
		# ~ choosen_core = []
		if (j.index_node_list == 0): # Je peux choisir dans la liste entière
			nodes_to_choose_from = node_list[0] + node_list[1] + node_list[2]
		elif (j.index_node_list == 1): # Je peux choisir dans la 1 et la 2
			nodes_to_choose_from = node_list[1] + node_list[2]
		elif (j.index_node_list == 2): # Je peux choisir que dans la 2
			nodes_to_choose_from = node_list[2]
		for n in nodes_to_choose_from:
			choosen_node = None
			choosen_core = []
			nb_possible_cores = 0
			if n.n_available_cores >= j.cores: 
				# ~ print("On node", n.unique_id, ":", n.n_available_cores, j.cores) 
				# Need to make sure it won't delay first_job_in_queue
				# If it's the same node and the job is longer that start time of first_job_in_queue it might cause problems
				if (n == first_job_in_queue.node_used and t + j.walltime > first_job_in_queue.start_time):
					# Careful, you can't choose the same cores!
					# ~ print("same node")
					for c in n.cores:
						if c.available_time <= t and c not in first_job_in_queue.cores_used:
							nb_possible_cores += 1
					if (nb_possible_cores >= j.cores): # Ok you can!
						choosen_node = n
						# ~ print("node choosen is the same as first j")
						for c in choosen_node.cores:
							if c.available_time <= t and c not in first_job_in_queue.cores_used:
								choosen_core.append(c)
								
								# ~ if (j.unique_id == 19848 or j.unique_id == 20143 or j.unique_id == 21407):
									# ~ print("In bf same node at time", t, "Added on node", choosen_node.unique_id, "core", c.unique_id)
								
								c.job_queue.append(j)
								if (len(choosen_core) == j.cores):
									break										
				else: # You can choose any free core
					# ~ print("free node")
					choosen_node = n
					choosen_node.cores.sort(key = operator.attrgetter("available_time"))
					choosen_core = choosen_node.cores[0:j.cores]
					for c in choosen_core:
												
						c.job_queue.append(j)
						
						# Fix en carton
						c.available_time = t
						
				if choosen_node != None:
					start_time = get_start_time_and_update_avail_times_of_cores(t, choosen_core, j.walltime) 
					j.node_used = choosen_node
					j.cores_used = choosen_core
					j.start_time = start_time
					j.end_time = start_time + j.walltime							
					# ~ available_job_list.remove(j)
					job_to_remove.append(j)
					scheduled_job_list.append(j)
					# ~ print_decision_in_scheduler(choosen_core, j, choosen_node)
					start_jobs_single_job(t, j)
					# ~ print_job_info_from_list(available_job_list, t)
					break
	available_job_list = remove_jobs_from_list(available_job_list, job_to_remove)
	# ~ print("Fin de Easy BackFilling...")
	return scheduled_job_list

# Print in a csv file the results of this job allocation
def to_print_job_csv(job, node_used, core_ids, time):
	time_used = job.end_time - job.start_time
	tp = To_print(job.unique_id, job.subtime, node_used, core_ids, time, time_used, job.transfer_time, job.start_time, job.end_time, job.cores, job.waiting_for_a_load_time)
	to_print_list.append(tp)
		
	if (write_all_jobs == 1): # For gantt charts
		file_to_open = "outputs/Results_all_jobs_" + scheduler + ".csv"
		f = open(file_to_open, "a")
		f.write("%d,%d,delay,%f,%d,%f,1,COMPLETED_SUCCESSFULLY,%f,%f,%f,%f,%f,%f," % (job.unique_id, job.unique_id, job.subtime, job.cores, job.walltime, job.start_time, time_used, job.end_time, job.start_time, job.end_time, 1))
				
		if (len(core_ids) > 1):
			core_ids.sort()
			for i in range (0, len(core_ids)):
			# ~ for i in core_ids:
				if (i == len(core_ids) - 1):
					f.write("%d" % (node_used*20 + core_ids[i]))
				else:
					# ~ print(node_used)
					# ~ print(len(core_ids))
					# ~ print(i)
					# ~ f.write("%d-" % (node_used*20 + core_ids[i]))
					f.write("%d " % (node_used*20 + core_ids[i]))
		else:
			f.write("%d" % (node_used*20 + core_ids[0]))
		f.write(",-1,\"\"\n")
		f.close()
	elif (write_all_jobs == 2): # For distribution of queue times
		file_to_open = "outputs/Distribution_queue_times_" + scheduler + ".txt"
		f = open(file_to_open, "a")
		f.write("%d\n" % (job.start_time - job.subtime))
		f.close()

# Read cluster
node_list, available_node_list = read_cluster(input_node_file, node_list, available_node_list)

# Read workload
job_list = read_workload(input_job_file, job_list)

finished_jobs = 0
total_number_jobs = len(job_list)
new_job = False
new_core = False

# Starting simulation TODO simplifier en 1 seule fonction
if (scheduler == "Easy_bf_fcfs_fcfs" or scheduler == "Fcfs_with_a_score_easy_bf"):
	first_job_in_queue = None
	while(total_number_jobs != finished_jobs):
		job_to_remove = []
		new_job = False
		# Get the set of available jobs at time t. Jobs are already sorted by subtime so I can simply stop with a break
		for j in job_list:
			if (j.subtime == t):
				new_job = True
				available_job_list.append(j)
				job_to_remove.append(j)	
			elif (j.subtime > t):
				break
		job_list = remove_jobs_from_list(job_list, job_to_remove)
		
		if (new_job == True):
			# Easy Backfill and Schedule if first job does not exist yet.
			if (first_job_in_queue == None):
				first_job_in_queue = available_job_list[0]
				if (scheduler == "Easy_bf_fcfs_fcfs"):
					scheduled_job_list = schedule_job_on_earliest_available_cores(first_job_in_queue, node_list, t, scheduled_job_list)
				elif (scheduler == "Fcfs_with_a_score_easy_bf"):
					scheduled_job_list = single_job_fcfs_with_a_score_scheduler(first_job_in_queue, node_list, t, scheduled_job_list)
				else:
					print("Error scheduler")
					exit(1)
				available_job_list.remove(first_job_in_queue)
			scheduled_job_list = easy_backfill(first_job_in_queue, t, node_list, available_job_list, scheduled_job_list)
					
		# Get ended job. Inform if a filing is needed. Compute file transfers needed.	
		affected_node_list = []	
		finished_job_list = []	
		
		old_finished_jobs = finished_jobs
		
		finished_jobs, affected_node_list, finished_job_list = end_jobs(t, scheduled_job_list, finished_jobs, affected_node_list)
		
		if (finished_jobs > old_finished_jobs): # A core has been liberated so go schedule					
			if (first_job_in_queue.start_time <= t): # First job is running
				# ~ print("first_job_in_queue is running or finished at time", t)
				if (len(available_job_list) != 0):
					# ~ print("first_job_in_queue is running or finished at time", t)
					first_job_in_queue = available_job_list[0]
					if (scheduler == "Easy_bf_fcfs_fcfs"):
						scheduled_job_list = schedule_job_on_earliest_available_cores(first_job_in_queue, node_list, t, scheduled_job_list)
					elif (scheduler == "Fcfs_with_a_score_easy_bf"):
						scheduled_job_list = single_job_fcfs_with_a_score_scheduler(first_job_in_queue, node_list, t, scheduled_job_list)
					else:
						print("Error scheduler")
						exit(1)
					available_job_list.remove(first_job_in_queue)
			else: # Else try to reschedule it earlier
				scheduled_job_list.remove(first_job_in_queue)
				for i in range (0, len(first_job_in_queue.cores_used)): # Delete what was reserved first
					first_job_in_queue.cores_used[i].job_queue.remove(first_job_in_queue)
					# ~ if (len(first_job_in_queue.cores_used[i].job_queue) > 0):
						# ~ print("running...")
					if (first_job_in_queue.cores_used[i].running_job != None):
						first_job_in_queue.cores_used[i].available_time = first_job_in_queue.cores_used[i].running_job.start_time + first_job_in_queue.cores_used[i].running_job.walltime
					else:
						first_job_in_queue.cores_used[i].available_time = t
				# ~ print("Try to reschedule first_job_in_queue", first_job_in_queue.unique_id)
				if (scheduler == "Easy_bf_fcfs_fcfs"):
					scheduled_job_list = schedule_job_on_earliest_available_cores(first_job_in_queue, node_list, t, scheduled_job_list)
				elif (scheduler == "Fcfs_with_a_score_easy_bf"):
					scheduled_job_list = single_job_fcfs_with_a_score_scheduler(first_job_in_queue, node_list, t, scheduled_job_list)
				else:
					print("Error scheduler")
					exit(1)				
				# ~ if (first_job_in_queue.start_time == t):
					# ~ start_jobs_single_job(t, first_job_in_queue)
					
			if (len(available_job_list) > 0):
				scheduled_job_list = easy_backfill(first_job_in_queue, t, node_list, available_job_list, scheduled_job_list)
		
		if (first_job_in_queue != None):
			if (first_job_in_queue.start_time == t):
				# ~ print("Start for first job", first_job_in_queue.unique_id, "at t =", t)
				start_jobs_single_job(t, first_job_in_queue)
						
		# Let's remove finished jobs copy of data but after the start job so the one finishing and starting consecutivly don't load it twice
		remove_data_from_node(finished_job_list)
		t += 1 # Tic, Tac ...
else:
	while(total_number_jobs != finished_jobs):
		# ~ job_to_remove = []
		
		# Get the set of available jobs at time t
		# Jobs are already sorted by subtime so I can simply stop wit ha break
		for j in job_list:
			if (j.subtime == t):
				available_job_list.append(j)
				# ~ job_to_remove.append(j)	
			elif (j.subtime > t):
				break
		# ~ job_list = remove_jobs_from_list(job_list, job_to_remove)
		
		# New jobs are available!
		if (len(available_job_list) > 0):
			if (scheduler == "Random"):
				random.shuffle(available_job_list)
				scheduled_job_list = random_scheduler(available_job_list, node_list, t, scheduled_job_list)
			elif (scheduler == "Fcfs_with_a_score"):
				scheduled_job_list = fcfs_with_a_score_scheduler(available_job_list, node_list, t, scheduled_job_list)
			elif (scheduler == "Maximum_use_single_file"):
				while(len(available_job_list) > 0):
					scheduled_job_list = maximum_use_single_file_scheduler(available_job_list, node_list, t, scheduled_job_list)
			else:
				print("Wrong scheduler in arguments")
				exit
		
		# Get ended job. Inform if a filing is needed. Compute file transfers needed.	
		affected_node_list = []	
		finished_job_list = []	
		finished_jobs, affected_node_list, finished_job_list = end_jobs(t, scheduled_job_list, finished_jobs, affected_node_list)
		
		# TODO backfill strategy
		if (len(affected_node_list) > 0 and total_number_jobs != finished_jobs): # At least one job has ended before it's walltime
			# Filling
			ShiftLeft(affected_node_list, t)
			# ~ ShiftLeft2(affected_node_list, t)
		
		# Get started jobs	
		start_jobs(t, scheduled_job_list)
		
		# Let's remove finished jobs copy of data but after the start job so the one finishing and starting consecutivly don't load it twice
		remove_data_from_node(finished_job_list)
		
		# To update datas in nodes
		# update_nodes() # TODO : do this for available nodes ?
		
		# Time is advancing
		t += 1

# Print results in a csv file
print("Computing and writing results...")
print_csv(to_print_list, scheduler)
