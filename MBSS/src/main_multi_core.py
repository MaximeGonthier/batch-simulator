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
    data_size: float
    index_node_list: int
    start_time: int
    end_time: int
    end_before_walltime: bool
    node_used: None
    cores_used: list
    transfer_time: int
@dataclass
class Node:
    unique_id: int
    memory: int
    bandwidth: float
    data: list
    cores: list
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
@dataclass
class To_print: # Struct used to know what to print later in csv
    job_unique_id: int
    job_subtime: int
    node_unique_id: int
    core_unique_id: list
    time: int
    time_used: int
    transfer_time: int
    
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

def start_jobs(t, scheduled_job_list, finished_jobs):
	for j in scheduled_job_list:
		if (j.start_time == t):
			transfer_time = 0
			if (j.data != 0):
				# Let's look if a data transfer is needed
				transfer_time = add_data_in_node(j.data, j.data_size, j.node_used, t, j.walltime)
			j.transfer_time = transfer_time
			j.end_time = j.start_time + min(j.delay + transfer_time, j.walltime)
			if (j.delay + transfer_time < j.walltime):
				j.end_before_walltime = True
			print("Job", j.unique_id, "is starting at time", j.start_time, "and will end at time", j.end_time, "with a walltime ending at", j.walltime + j.start_time)
	# ~ # Just printing
	# ~ if (node_list[0][0].data != None):
		# ~ print("End of data", node_list[0][0].data[0].unique_id, "on node", node_list[0][0].unique_id, "is", node_list[0][0].data[0].end_time)
			
def end_jobs(t, scheduled_job_list, finished_jobs, affected_node_list):
	jobs_to_remove = []
	for j in scheduled_job_list:
		if (j.end_time == t): # A job has finished, let's remove it from the cores, write its results and figure out if we need to fill
			finished_jobs += 1
			print("Job", j.unique_id, "finished at time", t, finished_jobs, "finished jobs")
			
			finished_job_list.append(j)
			
			core_ids = []
			for i in range (0, len(j.cores_used)):
				
				# OLD
				# ~ print("Try to remove from core", j.node_used.cores[j.cores_used[i].unique_id].unique_id, "node", j.node_used.unique_id)
				# ~ j.node_used.cores[j.cores_used[i].unique_id].job_queue.remove(j)
				
				# NEW
				j.cores_used[i].job_queue.remove(j)
				# ~ print_job_queue_in_cores_specific_node(node_list[0][0])
				
				if (j.end_before_walltime == True):
					j.node_used.cores[j.cores_used[i].unique_id].available_time = t
				core_ids.append(j.cores_used[i].unique_id)
			to_print_job_csv(j, j.node_used.unique_id, core_ids, t)

			if (j.end_before_walltime == True): # Need to backfill or shiftleft depending on the strategy OLD
				affected_node_list.append(j.node_used)
			jobs_to_remove.append(j)
	remove_jobs_from_list(scheduled_job_list, jobs_to_remove)
						
	return finished_jobs, affected_node_list, finished_job_list

# Print in a csv file the results of this job allocation
def to_print_job_csv(job, node_used, core_ids, time):
	time_used = job.end_time - job.start_time
	tp = To_print(job.unique_id, job.subtime, node_used, core_ids, time, time_used, job.transfer_time)
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

# Read cluster
node_list, available_node_list = read_cluster(input_node_file, node_list, available_node_list)

# Read workload
job_list = read_workload(input_job_file, job_list)
# ~ print("Job list:", job_list, "\n")

# Init before Schedule for some schedulers. Ils sont déjà triées par subtime
if (scheduler == "Fcfs_with_a_score"):
	job_list.sort(key = operator.attrgetter("subtime")) # Pour trier la liste selon le subtime et choisir toujours en premier le job soumis il y a le plus longtemps

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
		if (scheduler == "Random"):
			random.shuffle(available_job_list)
			random_scheduler(available_job_list, node_list, t)
		elif (scheduler == "Fcfs_with_a_score"):
			fcfs_with_a_score_scheduler(available_job_list, node_list, t)
		else:
			print("Wrong scheduler in arguments")
			exit
	
	# Get ended job. Inform if a fiiling is needed. Compute file transfers needed.	
	affected_node_list = []	
	finished_job_list = []	
	finished_jobs, affected_node_list, finished_job_list = end_jobs(t, scheduled_job_list, finished_jobs, affected_node_list)
	

	# TODO backfill strategy
	if (len(affected_node_list) and total_number_jobs != finished_jobs): # At least one job has ended before it's walltime
		# Filling
		if (filling_strategy == "ShiftLeft"):
			ShiftLeft(affected_node_list, t)
		elif (filling_strategy == "BackFill"):
			BackFill(affected_node_list, t)
		elif (filling_strategy != "NoFilling"):
			print("No filling.")
		else:
			exit
	
	# Get started jobs	
	start_jobs(t, scheduled_job_list, finished_jobs)
	
	# Let's remove finished jobs copy of data but after the start job so the one finishing and starting consecutivly don't load it twice
	remove_data_from_node(finished_job_list)
	
	# To update datas in nodes
	# ~ update_nodes() # TODO : do this for available nodes ?
	
	# Time is advancing
	t += 1

# Print results in a csv file
print("Computing and writing results...")
print_csv(to_print_list, scheduler)
