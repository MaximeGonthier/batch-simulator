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

# Getting arguments
input_job_file = sys.argv[1]
input_node_file = sys.argv[2]
scheduler = sys.argv[3]
write_all_jobs = int(sys.argv[4]) # Si on veut faire un gantt chart il faut imprimer tout les jobs et mettre ca à 1

# Global structs and input files
@dataclass
class Job:
    unique_id: int
    subtime: int
    delay: int
    walltime: int
    cores: int
    data: list
    data_sizes: list
    start_time: int
    end_time: int
    end_before_walltime: bool
@dataclass
@dataclass
class Node:
    unique_id: int
    memory: int
    bandwidth: int
    data: list
    cores: list
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
    
job_list = []
available_job_list = []
node_list = []
available_node_list = [] # Contient aussi les coeurs disponibles
to_print_list = []
t = 0 # Current time start at 0

# TODO gérer strat to the left et filling ici
def update_jobs(node_list, t, job_list, finished_jobs):
	for n in node_list:
		for c in n.cores:
			for j in c.job_queue:
				if (j.end_time == t): # TODO : gérér multi core et remove les jobs des queue des cores
					finished_jobs += 1
					print(j.unique_id, "finished at time", t)
					core_ids = []
					if (j.cores > 1):
						for c2 in n.cores:
							if (j in c2.job_queue):
								core_ids.append(c2.unique_id)
								c2.job_queue.remove(j)
						to_print_job_csv(j, n.unique_id, core_ids, t)
					else:
						core_ids.append(c.unique_id)
						to_print_job_csv(j, n.unique_id, core_ids, t)
						c.job_queue.remove(j)
					
					# ~ if (c.job_queue[i].end_before_walltime == True) # TODO : Il faut tout shift vers la gauche
	return finished_jobs

# Print in a csv file the results of this job allocation
def to_print_job_csv(job, node_id, core_ids, time):
	time_used = job.end_time - job.start_time
	tp = To_print(job.unique_id, job.subtime, node_id, core_ids, time, time_used)
	to_print_list.append(tp)
		
	if (write_all_jobs == 1):
		file_to_open = "outputs/Results_all_jobs_" + scheduler + ".csv"
		f = open(file_to_open, "a")
		f.write("%d,%d,delay,%f,%d,%f,1,COMPLETED_SUCCESSFULLY,%f,%f,%f,%f,%f,%f," % (job.unique_id, job.unique_id, job.subtime, job.cores, job.walltime, job.start_time, time_used, job.end_time, job.start_time, job.end_time, 1))
		
		print(core_ids)
		
		if (len(core_ids) > 1):
			core_ids.sort()
			for i in core_ids:
				if (i == len(core_ids) - 1):
					f.write("%d" % (node_id*2 + core_ids[i]))
				else:
					f.write("%d-" % (node_id*2 + core_ids[i]))
		else:
			f.write("%d" % (node_id*2 + core_ids[0]))
		f.write(",-1,\"\"\n")
		
		f.close()

# Read cluster
node_list, available_node_list = read_cluster(input_node_file, node_list, available_node_list)
print("Node list:", node_list, "\n")

# Read workload
job_list = read_workload(input_job_file, job_list)
print("Job list:", job_list, "\n")

# Init before Schedule for some schedulers
if (scheduler == "FCFS"):
	job_list.sort(key = operator.attrgetter("subtime")) # Pour trier la liste selon le subtime et choisir toujours en premier le job soumis il y a le plus longtemps

finished_jobs = 0
total_number_jobs = len(job_list)

# Starting simulation
while(total_number_jobs != finished_jobs):
	# ~ print ("t =", t, "et il y a", finished_jobs, "finished jobs")
	for j in job_list:
		if (j.subtime <= t):
			available_job_list.append(j)
			job_list.remove(j)
			
	while(len(available_job_list) > 0):
		print("t =", t, "et il y a", len(available_job_list), "available jobs")
		if (scheduler == "Random"):
			random.shuffle(available_job_list)
			random_scheduler(available_job_list, node_list, t, available_node_list)
		else:
			print("Wrong scheduler in arguments")
			exit
		# ~ print("Node List")
		# ~ print(node_list)
		# ~ print("Available Node List")
		# ~ print(available_node_list)
		
	t += 1
	# ~ update_nodes()
	# TODO backfill strategy
	finished_jobs = update_jobs(node_list, t, job_list, finished_jobs)

# Print results in a csv file
print("Computing and writing results...")
# ~ print_csv()
