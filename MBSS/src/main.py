# python3 src/main.py workload cluster scheduler

# TODO : Gérer les évictions
# TODO : Tracer la distirbution des queue times
# TODO : Faire des workloads avec des % de certains type de tâches

# Imports
from dataclasses import dataclass
import random
import sys

# Getting arguments
input_job_file = sys.argv[1]
input_node_file = sys.argv[2]
scheduler = sys.argv[3]

# Global structs and input files
@dataclass
class Job:
    unique_id: int
    priority: int
    delay: int
    res: int
    subtime: int
    walltime: int
    data: list
@dataclass
class Node:
    unique_id: int
    memory: int
    bandwidth: int
    available_time: int # Time t at which the node will be available
    data: list
@dataclass
class To_print: # Struct used to know what to print later in csv
    job_unique_id: int
    job_subtime: int
    node_unique_id: int
    time: int
    transfer_time: int
    time_used: int
job_list = []
node_list = []
available_node_list = []
to_print_list = []
t = 0 # Current time start at 0

# Print in a csv file the results of this job allocation
def to_print_job_csv(job, node, time, transfer_time, time_used):
	tp = To_print(job.unique_id, job.subtime, node.unique_id, time, transfer_time, time_used)
	to_print_list.append(tp)
	
def print_csv():
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
	file_to_open = "outputs/Results_" + scheduler + ".txt"
	f = open(file_to_open, "a")
	f.write("%s %s %s %s %s %s %s %s %s %s\n" % (str(len(to_print_list)), str(max_queue_time), str(mean_queue_time), str(total_queue_time), str(max_flow), str(mean_flow), str(total_flow), str(total_transfer_time), str(makespan), str(core_time_used)))
	f.close()

# Remove jobs rom the main job list. I do it outside the loop because I need to go through the list before deleting
def remove_jobs_from_list(job_to_remove):
	for j1 in job_to_remove:
		for j2 in job_list:
			if (j1.unique_id == j2.unique_id):
				job_list.remove(j2)
	
# Update nodes list if they are available at current time
def update_nodes():
	for n in node_list:
		if (t == n.available_time):
			available_node_list.append(n)
	
# Schedule jobs on random available nodes
def random_available_scheduler():
	job_to_remove = []
	for j in job_list:
		if (j.subtime <= t and len(available_node_list) > 0):
			choosen_node = random.choices(available_node_list)
			# ~ print("Node", choosen_node[0].unique_id, "was choosen for job", j.unique_id, "at time", t)
			transfer_time = compute_transfer_time(j.data, choosen_node[0].data, choosen_node[0].bandwidth, choosen_node[0].memory)
			add_data_in_node(j.data, choosen_node[0].data, choosen_node[0].bandwidth, choosen_node[0].memory)
			time_used = min(j.delay, j.walltime) + transfer_time
			choosen_node[0].available_time = t + time_used
			job_to_remove.append(j)
			to_print_job_csv(j, choosen_node[0], t, transfer_time, time_used)
			available_node_list.remove(choosen_node[0])
	remove_jobs_from_list(job_to_remove)
	
# Schedule jobs on random available nodes
def firstcomefirstserve_available_scheduler():
	job_to_remove = []
	for j in job_list:
		if (j.subtime <= t and len(available_node_list) > 0):
			choosen_node = available_node_list
			# ~ print("Node", choosen_node[0].unique_id, "was choosen for job", j.unique_id, "at time", t)
			print(available_node_list)
			transfer_time = compute_transfer_time(j.data, choosen_node[0].data, choosen_node[0].bandwidth, choosen_node[0].memory)
			add_data_in_node(j.data, choosen_node[0].data, choosen_node[0].bandwidth, choosen_node[0].memory)
			time_used = min(j.delay, j.walltime) + transfer_time
			choosen_node[0].available_time = t + time_used
			job_to_remove.append(j)
			to_print_job_csv(j, choosen_node[0], t, transfer_time, time_used)
			available_node_list.remove(choosen_node[0])
	remove_jobs_from_list(job_to_remove)
	
# Schedule jobs on random nodes, even if not available
def random_scheduler():
	job_to_remove = []
	for j in job_list:
		if (j.subtime <= t):
			choosen_node = random.choices(node_list)
			# ~ print("Node", choosen_node[0].unique_id, "was choosen for job", j.unique_id)
			transfer_time = compute_transfer_time(j.data, choosen_node[0].data, choosen_node[0].bandwidth, choosen_node[0].memory)
			add_data_in_node(j.data, choosen_node[0].data, choosen_node[0].bandwidth, choosen_node[0].memory)
			time_used = min(j.delay, j.walltime) + transfer_time
			start_time = max(choosen_node[0].available_time, j.subtime)
			to_print_job_csv(j, choosen_node[0], start_time, transfer_time, time_used) # Careful, here the available time of the previous job (or the sub time for the start) is the time of start of the current job. That's why I put it before changing
			choosen_node[0].available_time += time_used
			job_to_remove.append(j)
	remove_jobs_from_list(job_to_remove)

# Just compute the time it takes to transfer all data not on node. TODO : deal with eviction ?
def compute_transfer_time(job_data, node_data, bandwidth, memory):
	transfer_time = 0
	for d in job_data:
		if (d not in node_data):
			transfer_time += data_sizes[d]//bandwidth
	return transfer_time

# Add data in the node. TODO : deal with eviction
def add_data_in_node(job_data, node_data, bandwidth, memory):
	# ~ print("Adding...")
	for d in job_data:
		if (d not in node_data):
			node_data.append(d)
	
# Read input files
with open(input_job_file) as f:
	line = f.readline()
	while line:
		r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16 = line.split() # split it by whitespace
		j = Job(int(r3), int(r5), int(r7), int(r9), int(r11), int(r13), list())
		# Adding data in the list of data of the job
		i = 1
		while (i < len(str(r15))):
			c = ""
			while (str(r15)[i] != "," and str(r15)[i] != "]"):
				c += str(r15)[i]
				i += 1
			i += 1
			j.data.append(int(c))
		job_list.append(j)
		line = f.readline()	
f.close
		
with open(input_node_file) as f:
	line = f.readline()
	while line:
		r1, r2, r3, r4, r5, r6, r7, r8 = line.split()
		n = Node(int(r3), int(r5), int(r7), 0, list())
		node_list.append(n)
		available_node_list.append(n)
		line = f.readline()
f.close
		
with open("inputs/data_sizes.txt") as f:
    number_different_data = len(f.readlines())
f.close
data_sizes = [0 for x in range(number_different_data)]
with open("inputs/data_sizes.txt") as f:
	line = f.readline()
	while line:
		r1, r2 = line.split()
		data_sizes[int(r1)] = int(r2)
		line = f.readline()
f.close

# Printing
# ~ print("List of nodes :\n", node_list)
# ~ print("List of available nodes :\n", available_node_list)
# ~ print("List of jobs :\n", job_list)
print("Scheduler is:", scheduler)

# Starting a schedule
while(len(job_list) > 0):
	if (scheduler == "Random-Available"):
		random_available_scheduler()
	elif (scheduler == "Random"):
		random_scheduler()
	elif (scheduler == "First-Come-First-Serve"):
		firstcomefirstserve_available_scheduler()
	else:
		perror("Wrong scheduler in arguments")
	# ~ print("List of jobs at time", t, ":\n", job_list)
	t += 1
	update_nodes()

# ~ print("List of nodes after schedule :\n", node_list)
# ~ print("List of available nodes after schedule :\n", available_node_list)

# Pint results in a csv file
print("Computing and writing results...")
print_csv()
