# python3 src/main.py workload cluster scheduler

# TODO : Gérer les évictions ?

# Imports
from dataclasses import dataclass
import random
import sys
import operator
from read_input_files import *
from basic_functions import *
from scheduler import *
from filling_strategy import *

# Getting arguments
input_job_file = sys.argv[1]
input_node_file = sys.argv[2]
scheduler = sys.argv[3]
filling_strategy = sys.argv[4]
write_all_jobs = int(sys.argv[5]) # Si on veut faire un gantt chart il faut imprimer tous les jobs et mettre ca à 1

# Global structs and input files
@dataclass
class Job:
    unique_id: int
    subtime: int
    delay: int
    walltime: int
    cores: int
    data: int
    data_size: int
    start_time: int
    end_time: int
    end_before_walltime: bool
    node_used: None
    cores_used: list
@dataclass
class Node:
    unique_id: int
    memory: int
    bandwidth: float
    data: list
    cores: list
@dataclass
class Core:
    unique_id: int
    job_queue: list
    available_time: int
# ~ @dataclass
# ~ class DataLoaded:
    # ~ unique_id: int
    # ~ end_time: int
@dataclass
class To_print: # Struct used to know what to print later in csv
    job_unique_id: int
    job_subtime: int
    node_unique_id: int
    core_unique_id: list
    time: int
    time_used: int
    
job_list = []
available_job_list = []
scheduled_job_list = []
node_list = []
available_node_list = [] # Contient aussi les coeurs disponibles
to_print_list = []
t = 0 # Current time start at 0

def update_jobs2(node_list, t, scheduled_job_list, finished_jobs):
	# ~ if (
	for j in scheduled_job_list:
		if (j.start_time == t):
			transfer_time = compute_transfer_time(j.data, j.node_used.data, j.node_used.bandwidth, j.node_used.memory, j.data_size)
			j.end_time = j.start_time + min(j.delay + transfer_time, j.walltime)
			if (j.delay + transfer_time < j.walltime):
				j.end_before_walltime = True
			add_data_in_node(j.data, j.node_used.data, j.node_used.bandwidth, j.node_used.memory)
			print("Job", j.unique_id, "is starting at time", j.start_time, "and will end at time", j.end_time, "with a walltime ending at", j.walltime + j.start_time)
			
def update_jobs(node_list, t, scheduled_job_list, finished_jobs):
	# ~ print("Update jobs t =", t, "list =", len(scheduled_job_list))
	need_to_fill = False
	jobs_to_remove = []
	# ~ if (t == 36000 or t == 35999):
		# ~ print(scheduled_job_list[0].unique_id, scheduled_job_list[0].end_time)
		# ~ print(scheduled_job_list[1].unique_id, scheduled_job_list[0].end_time)
		# ~ print(scheduled_job_list[2].unique_id, scheduled_job_list[0].end_time)
		# ~ print(scheduled_job_list[3].unique_id, scheduled_job_list[0].end_time)
		# ~ print(scheduled_job_list[4].unique_id, scheduled_job_list[0].end_time)
		# ~ print(scheduled_job_list[5].unique_id, scheduled_job_list[0].end_time)
	for j in scheduled_job_list:
		# ~ if (j.start_time == t):
			# ~ transfer_time = compute_transfer_time(j.data, j.node_used.data, j.node_used.bandwidth, j.node_used.memory, j.data_size)
			# ~ j.end_time = j.start_time + min(j.delay + transfer_time, j.walltime)
			# ~ if (j.delay + transfer_time < j.walltime):
				# ~ j.end_before_walltime = True
			# ~ add_data_in_node(j.data, j.node_used.data, j.node_used.bandwidth, j.node_used.memory)
			# ~ print("Job", j.unique_id, "is starting at time", j.start_time, "and will end at time", j.end_time, "with a walltime ending at", j.walltime + j.start_time)
		# ~ elif (j.end_time == t): # A job has finished, let's remove it from the cores, write its results and figure out if we need to fill
		if (j.end_time == t): # A job has finished, let's remove it from the cores, write its results and figure out if we need to fill
			# ~ if (j.data != 0): # TODO a corriger
				# ~ print("want to remove", j.data, "from node", j.node_used.unique_id)
				# ~ j.node_used.data.remove(j.data)
			finished_jobs += 1
			print("Job", j.unique_id, "finished at time", t, finished_jobs, "finished jobs")
			core_ids = []
			for i in range (0, len(j.cores_used)):
				j.node_used.cores[j.cores_used[i].unique_id].job_queue.remove(j)
				if (j.end_before_walltime == True):
					j.node_used.cores[j.cores_used[i].unique_id].available_time = t
				core_ids.append(j.cores_used[i].unique_id)
			to_print_job_csv(j, j.node_used.unique_id, core_ids, t)

			# ~ if (j.cores > 1):
				# ~ for c2 in n.cores:
					# ~ if (j in c2.job_queue):
								# ~ core_ids.append(c2.unique_id)
								# ~ c2.job_queue.remove(j)
								# ~ c2.available_time = t
						# ~ to_print_job_csv(j, n.unique_id, j.cores_used, t)
					# ~ else:
						# ~ core_ids.append(c.unique_id)
						# ~ to_print_job_csv(j, n.unique_id, j.cores_used, t)
						# ~ c.job_queue.remove(j)
						# ~ c.available_time = t
			if (j.end_before_walltime == True and need_to_fill == False): # Need to backfill or shiftleft depending on the strategy OLD
				need_to_fill = True
			jobs_to_remove.append(j)
	remove_jobs_from_list(scheduled_job_list, jobs_to_remove)
						
	# ~ for n in node_list:
		# ~ for c in n.cores:
			# ~ if (len(c.job_queue) > 0):
				# ~ transfer_time = 0
				# ~ if (c.job_queue[0].start_time == t): # A job has started, let's compute the amount of transfers needed
					# ~ transfer_time = compute_transfer_time(c.job_queue[0].data, n.data, n.bandwidth, n.memory, c.job_queue[0].data_size)
					# ~ c.job_queue[0].end_time = c.job_queue[0].start_time + min(c.job_queue[0].delay + transfer_time, c.job_queue[0].walltime)
					# ~ if (c.job_queue[0].delay + transfer_time < c.job_queue[0].walltime):
						# ~ c.job_queue[0].end_before_walltime = True
					# ~ add_data_in_node(c.job_queue[0].data, n.data, n.bandwidth, n.memory)
					# ~ print("Job", c.job_queue[0].unique_id, "is starting at time", c.job_queue[0].start_time, "and will end at time", c.job_queue[0].end_time, "with a walltime ending at", c.job_queue[0].walltime + c.job_queue[0].start_time)
					# ~ # Let's remove it from the cores
					# ~ cores_to_removes = []
					# ~ for i in range (0, len(c.job_queue[0].cores_used)):
						# ~ print("Removed from core", c.job_queue[0].cores_used[i].unique_id)
						# ~ n.cores[c.job_queue[0].cores_used[i].unique_id].job_queue.remove(c.job_queue[0])
				
	# ~ elif (j.end_time == t): # A job has finished, let's remove it from the cores, write its results and figure out if we need to fill
					# ~ if (j.data != 0):
						# ~ n.data.remove(j.data)
					# ~ finished_jobs += 1
					# ~ print(j.unique_id, "finished at time", t)
					#core_ids = []
					# ~ if (j.cores > 1):
						# ~ for c2 in n.cores:
							# ~ if (j in c2.job_queue):
								# ~ core_ids.append(c2.unique_id)
								# ~ c2.job_queue.remove(j)
								# ~ c2.available_time = t
						# ~ to_print_job_csv(j, n.unique_id, j.cores_used, t)
					# ~ else:
						# ~ core_ids.append(c.unique_id)
						# ~ to_print_job_csv(j, n.unique_id, j.cores_used, t)
						# ~ c.job_queue.remove(j)
						# ~ c.available_time = t
					# ~ if (j.end_before_walltime == True and need_to_fill == False): # Need to backfill or shiftleft depending on the strategy OLD
						# ~ need_to_fill = True
	return finished_jobs, need_to_fill

# Print in a csv file the results of this job allocation
def to_print_job_csv(job, node_id, core_ids, time):
	time_used = job.end_time - job.start_time
	tp = To_print(job.unique_id, job.subtime, node_id, core_ids, time, time_used)
	to_print_list.append(tp)
		
	if (write_all_jobs == 1):
		file_to_open = "outputs/Results_all_jobs_" + scheduler + ".csv"
		f = open(file_to_open, "a")
		f.write("%d,%d,delay,%f,%d,%f,1,COMPLETED_SUCCESSFULLY,%f,%f,%f,%f,%f,%f," % (job.unique_id, job.unique_id, job.subtime, job.cores, job.walltime, job.start_time, time_used, job.end_time, job.start_time, job.end_time, 1))
				
		if (len(core_ids) > 1):
			core_ids.sort()
			for i in range (0, len(core_ids)):
			# ~ for i in core_ids:
				if (i == len(core_ids) - 1):
					f.write("%d" % (node_id*20 + core_ids[i]))
				else:
					# ~ print(node_id)
					# ~ print(len(core_ids))
					# ~ print(i)
					# ~ f.write("%d-" % (node_id*20 + core_ids[i]))
					f.write("%d " % (node_id*20 + core_ids[i]))
		else:
			f.write("%d" % (node_id*20 + core_ids[0]))
		f.write(",-1,\"\"\n")
		
		f.close()

# Read cluster
node_list, available_node_list = read_cluster(input_node_file, node_list, available_node_list)
print("Node list:", node_list, "\n")

# Read workload
job_list = read_workload(input_job_file, job_list)
print("Job list:", job_list, "\n")

# Init before Schedule for some schedulers. Ils sont déjà triées par subtime
# ~ if (scheduler == "FCFS"):
	# ~ job_list.sort(key = operator.attrgetter("subtime")) # Pour trier la liste selon le subtime et choisir toujours en premier le job soumis il y a le plus longtemps

finished_jobs = 0
total_number_jobs = len(job_list)

# Starting simulation
while(total_number_jobs != finished_jobs):
	job_to_remove = []
	
	# Get the set of available jobs at time t
	for j in job_list:
		if (j.subtime <= t):
			available_job_list.append(j)
			scheduled_job_list.append(j) # Because we know they will all be scheduled anyway
			job_to_remove.append(j)	
	remove_jobs_from_list(job_list, job_to_remove)
	
	# Schedule all those jobs
	while(len(available_job_list) > 0):
		print("t =", t, "et il y a", len(available_job_list), "available jobs")
		if (scheduler == "Random"):
			random.shuffle(available_job_list)
			random_scheduler(available_job_list, node_list, t, available_node_list)
		else:
			print("Wrong scheduler in arguments")
			exit
	
	# Get started and ended job. Inform if a fiiling is needed. Compute file transfers needed.		
	finished_jobs, need_to_fill = update_jobs(node_list, t, scheduled_job_list, finished_jobs)
	
	# ~ update_nodes() # TODO : do this for available nodes ?

	# TODO backfill strategy
	if (need_to_fill == True and total_number_jobs != finished_jobs): # At least one job has ended before it's walltime
		# Filling
		if (filling_strategy == "ShiftLeft"):
			ShiftLeft(node_list, t)
		elif (filling_strategy == "BackFill"):
			BackFill(cores_used, j, node_list)
		elif (filling_strategy != "NoFilling"):
			print("No filling.")
		else:
			exit
			
	update_jobs2(node_list, t, scheduled_job_list, finished_jobs)
	
	# Time is advancing
	t += 1

# Print results in a csv file
print("Computing and writing results...")
# ~ print_csv()
