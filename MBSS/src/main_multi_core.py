# python3 src/main.py workload cluster scheduler

# TODO : Gérer les évictions ?

# Imports
from dataclasses import dataclass
import random
import sys
import operator
from read_input_files import *

# Getting arguments
input_job_file = sys.argv[1]
input_node_file = sys.argv[2]
scheduler = sys.argv[3]
# ~ write_all_jobs = int(sys.argv[4]) # Si on veut faire un gantt chart il faut imprimer tout les jobs et mettre ca à 1

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
@dataclass
class Node:
    unique_id: int
    memory: int
    bandwidth: int
    available_time: int # Time t at which the node will be available
    data: list
# ~ @dataclass
# ~ class To_print: # Struct used to know what to print later in csv
    # ~ job_unique_id: int
    # ~ job_subtime: int
    # ~ node_unique_id: int
    # ~ time: int
    # ~ transfer_time: int
    # ~ time_used: int
job_list = []
node_list = []
available_node_list = []
# ~ to_print_list = []
t = 0 # Current time start at 0

# Read cluster
node_list, available_node_list = read_cluster(input_node_file, node_list, available_node_list)
print("Node list:", node_list)
print("Available node list:", available_node_list)

# Read workload
job_list = read_workload(input_job_file, job_list)
print("Job list:", job_list)

# Init before Schedule for some schedulers
if (scheduler == "FCFS"):
	job_list.sort(key = operator.attrgetter("subtime")) # Pour trier la liste selon le subtime et choisir toujours en premier le job soumis il y a le plus longtemps

# Starting simulation
# ~ while(len(job_list) > 0):
	# ~ if (scheduler == "Random-Available"):
		# ~ random.shuffle(job_list) # Shuffle before each iteration so we choose random jobs from the available jobs
		# ~ random_available_scheduler()
	# ~ elif (scheduler == "Random"):
		# ~ random.shuffle(job_list)
		# ~ random_scheduler()
	# ~ elif (scheduler == "First-Come-First-Serve"):
		# ~ firstcomefirstserve_available_scheduler()
	# ~ elif (scheduler == "First-Come-First-Serve-Data-Aware"):
		# ~ firstcomefirstservedataaware_available_scheduler()
	# ~ elif (scheduler == "First-Come-First-Serve-Non-Dynamic"):
		# ~ firstcomefirstserve_available_scheduler_non_dynamic()
	# ~ elif (scheduler == "Max-Data-Reuse"):
		# ~ maximizedatarreuse_scheduler()
	# ~ else:
		# ~ print("Wrong scheduler in arguments")
		# ~ exit
	# ~ t += 1
	# ~ update_nodes()
