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
write_all_jobs = int(sys.argv[4]) # 1 for gantt charts, 2 for distribution of queue times, 3 for cluster usage
constraint_on_sizes = int(sys.argv[5]) # To add or remove the constraint that some jobs can't be executed on certain nodes. 0 or 1.

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
    workload: int
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
end_times = []
# ~ nstart: int
# ~ node_list = []
# ~ available_node_list = [] # Contient aussi les coeurs disponibles

# Ce sont des listes de listes
# ~ sub_list = []
node_list =  [[] for _ in range(3)] # Nb of different sizes of memory
available_node_list =  [[] for _ in range(3)] # Nb of different sizes of memory

to_print_list = [] # TODO : utilisé ?
t = 0 # Current time start at 0

# ~ def start_jobs_single_job(t, j, scheduled_job_list, running_jobs):
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
		
		if (j.delay + transfer_time < j.walltime):
			j.end_before_walltime = True
		# Remove from available cores used cores
		# print("Job", j.unique_id, "start at", t, "and will end at", j.end_time, j.end_before_walltime)
		for c in j.cores_used:
			# ~ c.job_queue.remove(j)
			c.running_job = j
		
		running_jobs.append(j)
		scheduled_job_list.remove(j)
		
	else:
		print("Error start job single job, time is", t, "and start time is", j.start_time)
		exit(1)
	
	# ~ return scheduled_job_list, running_jobs
def start_jobs(t, scheduled_job_list, running_jobs, end_times, running_cores, running_nodes):
	jobs_to_remove = []
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
			
			end_times.append(j.end_time)
			
			if (write_all_jobs == 3):
				# Just for stats
				running_cores += j.cores
				if (j.node_used.n_available_cores == 20):
					running_nodes += 1
				j.node_used.n_available_cores -= j.cores

			if (j.delay + transfer_time < j.walltime):
				j.end_before_walltime = True
				
			if __debug__:
				print("Job", j.unique_id, "start at", t, "on node", j.node_used.unique_id, "and will end at", j.end_time,  "before walltime:", j.end_before_walltime, "transfer time is", transfer_time, "data was", j.data)
			
			for c in j.cores_used:
				c.running_job = j
			jobs_to_remove.append(j)
			running_jobs.append(j)
		else: # dans le cas où on a trié la liste par start times
			break
	if len(jobs_to_remove) > 0:
		scheduled_job_list = remove_jobs_from_list(scheduled_job_list, jobs_to_remove)
	return scheduled_job_list, running_jobs, end_times, running_cores, running_nodes

def end_jobs(t, scheduled_job_list, finished_jobs, affected_node_list, running_jobs, running_cores, running_nodes): # TODO plus besoin de scheduleed job list
	jobs_to_remove = []
	for j in running_jobs:
		if (j.end_time == t): # A job has finished, let's remove it from the cores, write its results and figure out if we need to fill
			finished_jobs += 1

			# Just printing, can remove
			if (finished_jobs%100 == 0):
				print(finished_jobs, "/", total_number_jobs, "| T =", t, "| Running =", len(running_jobs), "| Schedule =", len(scheduled_job_list))
			
			if __debug__:	
				print("Job", j.unique_id, "finished at time", t, "|", finished_jobs, "finished jobs")
			
			finished_job_list.append(j)
			
			if (write_all_jobs == 3):
				# Just for stats
				running_cores -= j.cores
				j.node_used.n_available_cores += j.cores
				if (j.node_used.n_available_cores == 20):
					running_nodes -= 1
			
			end_times.remove(j.end_time)
			
			core_ids = []
			for i in range (0, len(j.cores_used)):
				j.cores_used[i].job_queue.remove(j)
				j.cores_used[i].running_job = None
								
				# ~ if (j.end_before_walltime == True):
					# ~ j.cores_used[i].available_time = t
					
				core_ids.append(j.cores_used[i].unique_id)
			
			to_print_job_csv(j, j.node_used.unique_id, core_ids, t)

			if (j.end_before_walltime == True and j.node_used not in affected_node_list): # Need to backfill or shiftleft depending on the strategy OLD
				affected_node_list.append(j.node_used)
			jobs_to_remove.append(j)
						
	running_jobs = remove_jobs_from_list(running_jobs, jobs_to_remove)
						
	return finished_jobs, affected_node_list, finished_job_list, running_jobs, running_cores, running_nodes

# Try to schedule immediatly in FCFS order without delaying first_job_in_queue
def easy_backfill_no_return(first_job_in_queue, t, node_list, l):
	# ~ print("Début de Easy BackFilling...")
	# ~ job_to_remove = []
	# ~ print_job_info_from_list(available_job_list, t)
	
	# ~ tab = [0] * (len(node_list) + 1)
	# ~ i = 0
	# ~ for n in node_list[0] + node_list[1] + node_list[2]:
		# ~ tab[i] = n.n_available_cores
		# ~ for c in n:
			# ~ for j in c.job_queue:
				# ~ if 
		# ~ i += 1
	# ~ print(tab[2])
	
	for j in l:
		if j != first_job_in_queue and j.start_time != t:
			if __debug__:
				print("Try to backfill", j.unique_id, "at time", t, "first job is", first_job_in_queue.unique_id)
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
				# ~ nb_possible_cores = 0

				# OLD
				# ~ nb = nb_available_cores(n, t)
				# ~ if nb >= j.cores: 
					# ~ print("On node", n.unique_id, "there are:", nb, "available cores and I use", j.cores) 
					# ~ # Need to make sure it won't delay first_job_in_queue
					# ~ # If it's the same node and the job is longer that start time of first_job_in_queue it might cause problems
					# ~ if (n == first_job_in_queue.node_used and t + j.walltime > first_job_in_queue.start_time):
						# ~ # Careful, you can't choose the same cores!
						# ~ for c in n.cores:
							# ~ if c.available_time <= t and c not in first_job_in_queue.cores_used:
								# ~ nb_possible_cores += 1
						# ~ if (nb_possible_cores >= j.cores): # Ok you can!
							# ~ choosen_node = n
							
							# ~ for c in choosen_node.cores:
								# ~ if c.available_time <= t and c not in first_job_in_queue.cores_used:
									# ~ choosen_core.append(c)
									
									
									# ~ c.job_queue.append(j)
									# ~ if (len(choosen_core) == j.cores):
										# ~ break
														
					# ~ else: # You can choose any free core
						# ~ choosen_node = n
						# ~ choosen_node.cores.sort(key = operator.attrgetter("available_time"))
						# ~ choosen_core = choosen_node.cores[0:j.cores]
						# ~ for c in choosen_core:
													
							# ~ c.job_queue.append(j)
							
							# ~ # Fix en carton
							# ~ # c.available_time = t
				
				# NEW			
				# ~ nb = nb_available_cores(n, t)
				# ~ if nb >= j.cores: 
					# ~ print("On node", n.unique_id, "there are:", nb, "available cores and I use", j.cores) 
					# Need to make sure it won't delay first_job_in_queue
					# If it's the same node and the job is longer that start time of first_job_in_queue it might cause problems
				same_node = False
				success = False
				if (n == first_job_in_queue.node_used and t + j.walltime > first_job_in_queue.start_time):
					same_node = True
					
				choosen_core, success = return_cores_not_running_a_job(n, j.cores, t, same_node, first_job_in_queue.cores_used)
						# ~ # Careful, you can't choose the same cores!
						# ~ for c in n.cores:
							# ~ if c.available_time <= t and c not in first_job_in_queue.cores_used:
								# ~ nb_possible_cores += 1
						# ~ if (nb_possible_cores >= j.cores): # Ok you can!
							# ~ choosen_node = n
							
							# ~ for c in choosen_node.cores:
								# ~ if c.available_time <= t and c not in first_job_in_queue.cores_used:
									# ~ choosen_core.append(c)
									
									
									# ~ c.job_queue.append(j)
									# ~ if (len(choosen_core) == j.cores):
										# ~ break
														
					# ~ else: # You can choose any free core
				if success == True:
					choosen_node = n
					# ~ choosen_node.cores.sort(key = operator.attrgetter("available_time"))
					# ~ choosen_core = choosen_node.cores[0:j.cores]
					for c in choosen_core:
													
						c.job_queue.append(j)
							
						# Fix en carton
						c.available_time = t
					
					# OLD
					# ~ if choosen_node != None:
					start_time = get_start_time_and_update_avail_times_of_cores(t, choosen_core, j.walltime) 
					j.node_used = choosen_node
					j.cores_used = choosen_core
					j.start_time = start_time
					j.end_time = start_time + j.walltime	
						
					for c in choosen_core:
						for j2 in c.job_queue:
							if j != j2:
								j2.start_time = c.available_time
								j2.end_time = j2.start_time + j.walltime	
								c.available_time = j2.end_time
									
						# ~ choosen_node.n_available_cores -= j.cores
						# ~ tab[n.unique_id] += j.cores
												
						# ~ available_job_list.remove(j)
						# ~ job_to_remove.append(j)
						# ~ scheduled_job_list.append(j)
					if __debug__:
						print_decision_in_scheduler(choosen_core, j, choosen_node)
						# ~ start_jobs_single_job(t, j)
						# ~ tab[n.unique_id] -= j.cores
						# ~ print_job_info_from_list(available_job_list, t)
					break
	# ~ available_job_list = remove_jobs_from_list(available_job_list, job_to_remove)
	# ~ print("Fin de Easy BackFilling...")
	# ~ return scheduled_job_list

# Print in a csv file the results of this job allocation
def to_print_job_csv(job, node_used, core_ids, time):	
	time_used = job.end_time - job.start_time
	
	if (job.workload == 1):	
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
job_list = read_workload(input_job_file, job_list, constraint_on_sizes, write_all_jobs)

total_number_cores = (len(node_list) + 1)*20

finished_jobs = 0
total_number_jobs = len(job_list)
new_job = False
new_core = False
running_jobs = []

# Just for stats
running_cores = 0
running_nodes = 0

if (write_all_jobs == 3):
	title = "outputs/Stats_" + scheduler + ".csv"
	f_stats = open(title, "w")
	f_stats.write("Used cores,Used nodes,Scheduled jobs\n")

# Variant for FCFS with a score
multiplier = 1
multiplier_nb_copy = 1
if (scheduler == "Fcfs_with_a_score_x1_x1"):
	multiplier = 1
elif (scheduler == "Fcfs_with_a_score_x1.5_x1"):
	multiplier = 1.5
elif (scheduler == "Fcfs_with_a_score_x2_x1"):
	multiplier = 2
elif (scheduler == "Fcfs_with_a_score_x2.5_x1"):
	multiplier = 2.5
elif (scheduler == "Fcfs_with_a_score_x3_x1"):
	multiplier = 3
elif (scheduler == "Fcfs_with_a_score_x3.5_x1"):
	multiplier = 3.5
elif (scheduler == "Fcfs_with_a_score_x4_x1"):
	multiplier = 4
elif (scheduler == "Fcfs_with_a_score_x4.5_x1"):
	multiplier = 4.5
elif (scheduler == "Fcfs_with_a_score_x5_x1"):
	multiplier = 5
elif (scheduler == "Fcfs_with_a_score_x1_x1.5"):
	multiplier = 1
	multiplier_nb_copy = 1.5
elif (scheduler == "Fcfs_with_a_score_x1_x2"):
	multiplier = 1
	multiplier_nb_copy = 2
elif (scheduler == "Fcfs_with_a_score_x1_x2.5"):
	multiplier = 1
	multiplier_nb_copy = 2.5
elif (scheduler == "Fcfs_with_a_score_x1_x3"):
	multiplier = 1
	multiplier_nb_copy = 3
	

# Start of simulation
first_job_in_queue = None
while(total_number_jobs != finished_jobs):
	# Get the set of available jobs at time t
	# Jobs are already sorted by subtime so I can simply stop wit ha break
	to_remove = []
	for j in job_list:
		if (j.subtime == t):
			available_job_list.append(j)
			scheduled_job_list.append(j) # Cause they will end up here anyway
			to_remove.append(j)
		elif (j.subtime > t):
			if (len(to_remove) > 0):
				remove_jobs_from_list(job_list, to_remove)
			break
	
	# New jobs are available! Schedule them
	if (len(available_job_list) > 0):
		if __debug__:	
			print(len(available_job_list), "new jobs at time", t)
			
		if (scheduler == "Random"):
			random.shuffle(available_job_list)
			random_scheduler(available_job_list, node_list, t)
			
		# ~ elif (scheduler == "Fcfs_with_a_score" or scheduler == "Fcfs_with_a_score_variant"):
		elif (scheduler[0:19] == "Fcfs_with_a_score_x"):
			fcfs_with_a_score_scheduler(available_job_list, node_list, t, multiplier, multiplier_nb_copy)
			
		elif (scheduler == "Fcfs"):
			fcfs_scheduler(available_job_list, node_list, t)
			
		elif (scheduler == "Fcfs_big_job_first"):
			fcfs_scheduler_big_job_first(available_job_list, node_list, t)
			
		elif (scheduler == "Fcfs_backfill_big_nodes"):
			fcfs_scheduler_backfill_big_nodes(available_job_list, node_list, t)
				
		elif (scheduler == "Fcfs_easybf"):
			if (first_job_in_queue == None):
				first_job_in_queue = available_job_list[0]
			else:
				first_job_in_queue = scheduled_job_list[0]
			fcfs_scheduler(available_job_list, node_list, t)
			easy_backfill_no_return(first_job_in_queue, t, node_list, available_job_list)

		elif (scheduler == "Fcfs_with_a_score_easy_bf"):
			if (first_job_in_queue == None):
				first_job_in_queue = available_job_list[0]
			else:
				first_job_in_queue = scheduled_job_list[0]
			fcfs_with_a_score_scheduler(available_job_list, node_list, t, multiplier, multiplier_nb_copy)
			easy_backfill_no_return(first_job_in_queue, t, node_list, available_job_list)
			
		elif (scheduler == "Common_file_packages_with_a_score"):
			common_file_packages_with_a_score(available_job_list, node_list, t, total_number_cores)
				
		elif (scheduler == "Maximum_use_single_file"):
			while(len(available_job_list) > 0):
				# ~ print(len(available_job_list))
				available_job_list = maximum_use_single_file_scheduler(available_job_list, node_list, t)
		else:
			print("Wrong scheduler in arguments")
			exit(1)
		available_job_list.clear()
	
	# Get ended job. Inform if a filing is needed. Compute file transfers needed.	
	affected_node_list = []	
	finished_job_list = []	
	old_finished_jobs = finished_jobs
	
	if t in end_times:
		finished_jobs, affected_node_list, finished_job_list, running_jobs, running_cores, running_nodes = end_jobs(t, scheduled_job_list, finished_jobs, affected_node_list, running_jobs, running_cores, running_nodes)
	
	if (len(affected_node_list) > 0): # A core has been liberated earlier so go schedule everything
		
		# Reset all cores and jobs
		if (scheduler != "Maximum_use_single_file"):
			reset_cores(node_list[0] + node_list[1] + node_list[2], t)
		
		if __debug__:
			print("Reschedule...")
			
		if (scheduler == "Random"):
			random_scheduler(scheduled_job_list, node_list, t)
			
		# ~ elif (scheduler == "Fcfs_with_a_score" or scheduler == "Fcfs_with_a_score_variant"):
		elif (scheduler[0:19] == "Fcfs_with_a_score_x"):
			fcfs_with_a_score_scheduler(scheduled_job_list, node_list, t, multiplier, multiplier_nb_copy)
			
		elif (scheduler == "Fcfs"):
			fcfs_scheduler(scheduled_job_list, node_list, t)
			
		elif (scheduler == "Fcfs_big_job_first"):
			fcfs_scheduler_big_job_first(scheduled_job_list, node_list, t)
			
		elif (scheduler == "Fcfs_backfill_big_nodes"):
			fcfs_scheduler_backfill_big_nodes(scheduled_job_list, node_list, t)
			
		elif (scheduler == "Maximum_use_single_file"):
			reset_cores(affected_node_list, t)
			maximum_use_single_file_re_scheduler(scheduled_job_list, t, affected_node_list)
			
		elif (scheduler == "Common_file_packages_with_a_score"):
			common_file_packages_with_a_score(scheduled_job_list, node_list, t, total_number_cores)
			
		if __debug__:
			print("End of reschedule")
	
	# Ones with backfill
	if (old_finished_jobs < finished_jobs):
		if (scheduler == "Fcfs_easybf"):
			if (len(scheduled_job_list) > 0):
				first_job_in_queue = scheduled_job_list[0]
				# ~ print("First job is", first_job_in_queue.unique_id)
				if len(affected_node_list) > 0:
					fcfs_scheduler(scheduled_job_list, node_list, t)
			easy_backfill_no_return(first_job_in_queue, t, node_list, scheduled_job_list)
			
		elif (scheduler == "Fcfs_with_a_score_easy_bf"):
			if (len(scheduled_job_list) > 0):
				first_job_in_queue = scheduled_job_list[0]
				# ~ print("First job is", first_job_in_queue.unique_id)
				if len(affected_node_list) > 0:
					fcfs_with_a_score_scheduler(scheduled_job_list, node_list, t, multiplier, multiplier_nb_copy)
			easy_backfill_no_return(first_job_in_queue, t, node_list, scheduled_job_list)
			
	# Get started jobs
	if (len(scheduled_job_list) > 0):
		scheduled_job_list.sort(key = operator.attrgetter("start_time"))
		if (scheduled_job_list[0].start_time == t):
			scheduled_job_list, running_jobs, end_times, running_cores, running_nodes = start_jobs(t, scheduled_job_list, running_jobs, end_times, running_cores, running_nodes)
	
	# Let's remove finished jobs copy of data but after the start job so the one finishing and starting consecutivly don't load it twice
	if len(finished_job_list) > 0:
		remove_data_from_node(finished_job_list)
	
	# Print cores used
	if (write_all_jobs == 3):
		f_stats.write("%d,%d,%d\n" % (running_cores, running_nodes, len(scheduled_job_list)))
	
	# Time is advancing
	t += 1

if (write_all_jobs == 3):
	f_stats.close()

# Print results in a csv file
print("Computing and writing results...")
print_csv(to_print_list, scheduler)
