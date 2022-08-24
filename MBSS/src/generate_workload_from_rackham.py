# Read job history files from /sw/share/slurm/rackham/accounting in the Rackham cluster
# Create jobs copying exactly these data
# Add data inputs depending on the arguments given by the user
# 2nd version, day -1 started like history if they started before day 0, other jobs scheduled and only day 1 evaluated

# Imports
import sys
from math import *
# ~ from math import *
import random
import operator
from dataclasses import dataclass

# To sort by subtime
@dataclass
class Job:
    subtime: int
    delay: int
    walltime: int
    cores: int
    user: str
    data: int
    data_size: float
    workload: int
    start_time_from_history: int
    start_node_from_history: int
    
# Args
FILENAME = sys.argv[1] # FILE 1
PROBABILITY_OF_USING_256GB = int(sys.argv[2]) # 0-100
PROBABILITY_OF_USING_1TB = int(sys.argv[3]) # 0-100
DATA_ON_ALL_JOBS = int(sys.argv[4]) # 0 or 1
# ~ VERSION = int(sys.argv[5]) # 1 or 2
VARIANCE = int(sys.argv[5])
    
# Get start of first and last job times that will be considered in terms of submission times
f_start_end = open("outputs/start_end_date_evaluated_jobs.txt", "r")
line = f_start_end.readline()
r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15 = line.split()
first_time_day_0 = int(str(r8)[4:])
line = f_start_end.readline()
r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15 = line.split()
last_time_day_0 = int(str(r8)[4:])
line = f_start_end.readline()
r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15 = line.split()
first_time_day_1 = int(str(r8)[4:])
line = f_start_end.readline()
r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15 = line.split()
last_time_day_1 = int(str(r8)[4:])
line = f_start_end.readline()
r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15 = line.split()
first_time_day_2 = int(str(r8)[4:])
f_start_end.close()
print("Time of first job day 0", first_time_day_0)
print("Time of last job day 0", last_time_day_0)
print("Time of first job day 1", first_time_day_1)
print("Time of last job day 1", last_time_day_1)
print("Time of first job day 2", first_time_day_2)

f_input = open("inputs/workloads/raw/" + FILENAME, "r")
line = f_input.readline()
id_count = 1
workload = []	
while line:
	if (len(line.split()) != 15):
		print("Line:", line, "is wrong!!")
	else:
		r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15 = line.split()
		# ~ if (str(r3) == "jobstate=COMPLETED" and int(str(r11)[6:]) <= 20 and int(str(r8)[4:]) - int(str(r7)[6:]) > 0): # DELAY MUST NOT BE 0! I don't know why but there are 0 seconds jobs with completed status
		if (str(r3) != "jobstate=CANCELLED"): # I just don't do CANCELLED jobs
			if (len(str(r15)) > 17): # Mean that the walltime is superior to 100 days
				print("Error, size not dealt with")
				exit(1)
			elif (len(str(r15)) == 17): # Mean that the walltime is superior to 10 days
				walltime = int(str(r15)[6:8])*24*60*60 + int(str(r15)[9:11])*60*60 + int(str(r15)[12:14])*60 + int(str(r15)[15:17])
			elif (len(str(r15)) == 16): # Mean that the walltime is superior to 24h
				walltime = int(str(r15)[6:7])*24*60*60 + int(str(r15)[8:10])*60*60 + int(str(r15)[11:13])*60 + int(str(r15)[14:16])
			else:
				walltime = int(str(r15)[6:8])*60*60 + int(str(r15)[9:11])*60 + int(str(r15)[12:14])
			
			if (int(str(r8)[4:]) - int(str(r7)[6:]) < 0):
				print("Error délai")
				exit(1)
			# 2min d'overhead sur les jobs
			delai = int(str(r8)[4:]) - int(str(r7)[6:]) + 120
				
			# Similarly walltime must not be 0
			if (walltime > 0):
				if (int(str(r11)[6:]) > 20): # If it's a multinode job I divide it.
					# ~ print(line)
					# ~ print("Cores =", int(str(r11)[6:]))
					nb_jobs_a_creer = ceil(int(str(r11)[6:])/20)
					# ~ print("nb_jobs_a_creer =", nb_jobs_a_creer)
					l1 = 8
					l2 = 8
					k = 0
					while k < nb_jobs_a_creer:
						# ~ print("la")
						# ~ node_from_history = [] # I need to get the node from history cause it's in the format [node-node] or [node,node] depending on if it's one by one or a serie of consecutive nodes
						# ~ node_from_history.append(str(r10)[l:l+1])
						# ~ print("append", str(r10)[l:l+1])
						# ~ l += 1
						while str(r10)[l2:l2+1] != "-" and str(r10)[l2:l2+1] != "]" and str(r10)[l2:l2+1] != ",":
							l2 += 1
						node_from_history = str(r10)[l1:l2]
						# ~ print("Node in this multi node job", node_from_history)
						w = Job(int(str(r9)[7:]), delai, walltime, 20, str(r5)[9:], 0, 0, -1, int(str(r7)[6:]), int(node_from_history))
						workload.append(w)
						id_count += 1
						
						if str(r10)[l2:l2+1] == "-": # Cas particulier on on prend des noeuds consécutifs
							# ~ print("Cas -")
							l1 = l2 + 1
							l2 += 1
							debut = int(node_from_history)
							while str(r10)[l2:l2+1] != "-" and str(r10)[l2:l2+1] != "]" and str(r10)[l2:l2+1] != ",":
								l2 += 1
							fin = int(str(r10)[l1:l2])
							for m in range (debut + 1, fin + 1):
								# ~ print("Node in this multi node job", m)
								w = Job(int(str(r9)[7:]), delai, walltime, 20, str(r5)[9:], 0, 0, -1, int(str(r7)[6:]), m)
								workload.append(w)
								id_count += 1
								k += 1 # For counter up there on number of jobs to create
							# ~ print("exit")
							# ~ exit(1)
						# ~ else:
						# Increment for next node indication
						l1 = l2 + 1
						l2 += 1
						k += 1
						
				else:
					# ~ print(line)
					
					# Si le node n'est pas précisé j'en choisis un au hasard entre 0 et 486
					if (len(str(r10)) == 6):
						nodes_from_hist = random.randint(0, 485)
					else:
						nodes_from_hist = int(str(r10)[7:])

					w = Job(int(str(r9)[7:]), delai, walltime, int(str(r11)[6:]), str(r5)[9:], 0, 0, -1, int(str(r7)[6:]), nodes_from_hist)
					workload.append(w) # Append the job in our workload
					id_count += 1
			else:
				print("Error walltime is 0.")
				exit(1)
					
	line = f_input.readline()
f_input.close()

# Min sub time takes 0
workload.sort(key = operator.attrgetter("subtime"))
min_subtime = workload[0].subtime

# ~ print("There are", id_count - 1, "jobs and", id_count - nb_ignored_jobs*2, "will be evaluated")

# Getting data. 0 means no data
if (VARIANCE != 0):
	f_output = open("inputs/workloads/converted/" + FILENAME + "_V" + str(VARIANCE), "w")
else:
	f_output = open("inputs/workloads/converted/" + FILENAME, "w")

n_128_data = 0
n_256_data = 0
n_1024_data = 0

if (workload[0].cores >= 5 or DATA_ON_ALL_JOBS == 1):
	workload[0].data = 1
	r = 0
	r = random.randint(0,99)
	size = 6.4
	if (r < PROBABILITY_OF_USING_1TB):
		n_1024_data += 1
		size = 51.2
	elif (r >= PROBABILITY_OF_USING_1TB and r < PROBABILITY_OF_USING_1TB + PROBABILITY_OF_USING_256GB):
		n_256_data += 1
		size = 12.8
	else:
		n_128_data += 1
	workload[0].data_size = size*workload[0].cores

nb_jobs_started_before_day_0 = 0
nb_jobs_not_started_but_submitted_before_day_0 = 0
nb_jobs_day_0 = 0
nb_jobs_day_1 = 0
nb_jobs_day_2 = 0

# First jobs
if workload[0].start_time_from_history < first_time_day_0:
	workload[0].workload = -2
	nb_jobs_started_before_day_0 += 1
elif workload[0].subtime < first_time_day_0:
	workload[0].workload = -1
	nb_jobs_not_started_but_submitted_before_day_0 += 1
elif workload[0].subtime >= first_time_day_0 and workload[0].subtime <= last_time_day_0:
	workload[0].workload = 0
	nb_jobs_day_0 +=1
elif workload[0].subtime >= first_time_day_1 and workload[0].subtime <= last_time_day_1:
	workload[0].workload = 1
	nb_jobs_day_1 +=1
elif workload[0].subtime > last_time_day_1:
	workload[0].workload = 2
	nb_jobs_day_2 +=1
else:
	print("Error time generation workload is", workload[0].subtime)
	exit(1)

f_output.write("{ id: %d subtime: %d delay: %d walltime: %d cores: %d user: %s data: %d data_size: %f workload: %d start_time_from_history: %d start_node_from_history: %d }\n" % (1, workload[0].subtime - min_subtime, workload[0].delay, workload[0].walltime, workload[0].cores, workload[0].user, workload[0].data, workload[0].data_size, workload[0].workload, workload[0].start_time_from_history - min_subtime, workload[0].start_node_from_history))

last_data = workload[0].data
last_size = workload[0].data_size
last_user = workload[0].user
last_subtime = workload[0].subtime
last_core = workload[0].cores



for i in range (1, id_count - 1):
	if (workload[i].cores >= 5 or DATA_ON_ALL_JOBS == 1):
		if (last_user == workload[i].user and last_subtime + 800 >= workload[i].subtime and last_core == workload[i].cores): # Max 800 seconds between two jobs for them to use the same data and must use the same amount of cores and have the smae user
			workload[i].data = last_data
			workload[i].data_size = last_size
			last_subtime = workload[i].subtime
		else:
			workload[i].data = last_data + 1
			r = 0
			r = random.randint(0,99)
			size = 6.4
			if (r < PROBABILITY_OF_USING_1TB):
				n_1024_data += 1
				size = 51.2
			elif (r >= PROBABILITY_OF_USING_1TB and r < PROBABILITY_OF_USING_1TB + PROBABILITY_OF_USING_256GB):
				n_256_data += 1
				size = 12.8
			else:
				n_128_data += 1

			workload[i].data_size = size*workload[i].cores
			last_size = workload[i].data_size
			last_data = workload[i].data
			last_user = workload[i].user
			last_subtime = workload[i].subtime
			last_core = workload[i].cores

	if workload[i].start_time_from_history < first_time_day_0:
		workload[i].workload = -2
		nb_jobs_started_before_day_0 += 1
	elif workload[i].subtime < first_time_day_0:
		workload[i].workload = -1
		nb_jobs_not_started_but_submitted_before_day_0 += 1
	elif workload[i].subtime >= first_time_day_0 and workload[i].subtime <= last_time_day_0:
		workload[i].workload = 0
		nb_jobs_day_0 +=1
	elif workload[i].subtime >= first_time_day_1 and workload[i].subtime <= last_time_day_1:
		workload[i].workload = 1
		nb_jobs_day_1 +=1
	elif workload[i].subtime > last_time_day_1:
		workload[i].workload = 2
		nb_jobs_day_2 +=1
	else:
		print("Error time generation workload is", workload[i].subtime)
		workload[i].workload = 1
		nb_jobs_day_1 +=1
	
	f_output.write("{ id: %d subtime: %d delay: %d walltime: %d cores: %d user: %s data: %d data_size: %f workload: %d start_time_from_history: %d start_node_from_history: %d }\n" % (i + 1, workload[i].subtime - min_subtime, workload[i].delay, workload[i].walltime, workload[i].cores, workload[i].user, workload[i].data, workload[i].data_size, workload[i].workload, workload[i].start_time_from_history - min_subtime, workload[i].start_node_from_history))
f_output.close()

print("There are", id_count - 1, "jobs.", nb_jobs_started_before_day_0, "started before day 0,", nb_jobs_not_started_but_submitted_before_day_0, "submitted but not started before day 0,", nb_jobs_day_0, "at day 0,", nb_jobs_day_1, "evaluated at day 1,", nb_jobs_day_2, "at day 2 and beyond.")
print("There are", n_128_data, "different data of size 128", n_256_data, "different data of size 256", n_1024_data, "of size 1024")
