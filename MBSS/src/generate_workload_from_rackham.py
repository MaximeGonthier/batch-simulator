# Read job history files from /sw/share/slurm/rackham/accounting in the Rackham cluster
# Create jobs copying exactly these data
# Add data inputs depending on the arguments given by the user
# Can be used with an option to take into consideration 3 inputs files instead of 1.
# With 3 inputs file, they are concatenated and input files 1 and 3 won't be counted later by the scheduler.

# Imports
import sys
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
    
# Args
FILENAME = sys.argv[1] # FILE 1
PROBABILITY_OF_USING_256GB = int(sys.argv[2]) # 0-100
PROBABILITY_OF_USING_1TB = int(sys.argv[3]) # 0-100
MERGE_3_FILES = int(sys.argv[4]) # 0 or 1

if (MERGE_3_FILES == 1):
	FILENAME_BEFORE = sys.argv[5] # FILE before main file
	FILENAME_AFTER = sys.argv[6] # FILE after main file
	f_input_before = open("inputs/workloads/raw/" + FILENAME_BEFORE, "r")
	f_input_after = open("inputs/workloads/raw/" + FILENAME_AFTER, "r")

f_input = open("inputs/workloads/raw/" + FILENAME, "r")

id_count = 1
workload = []	

# Read the file first to get a struct to sort by submission time
if (MERGE_3_FILES == 1):
	line = f_input_before.readline()
	while line:
		r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15 = line.split()
		if (str(r3) == "jobstate=COMPLETED" and int(str(r11)[6:]) <= 20):
			if (len(str(r15)) == 17): # Mean that the walltime is superior to 10 days
				walltime = int(str(r15)[6:8])*24*60*60 + int(str(r15)[9:11])*60*60 + int(str(r15)[12:14])*60 + int(str(r15)[15:17])
			if (len(str(r15)) == 16): # Mean that the walltime is superior to 24h
				walltime = int(str(r15)[6:7])*24*60*60 + int(str(r15)[8:10])*60*60 + int(str(r15)[11:13])*60 + int(str(r15)[14:16])
			else:
				walltime = int(str(r15)[6:8])*60*60 + int(str(r15)[9:11])*60 + int(str(r15)[12:14])
			w = Job(int(str(r9)[7:]), int(str(r8)[4:]) - int(str(r7)[6:]), walltime, int(str(r11)[6:]), str(r5)[9:], 0, 0, 0)
			workload.append(w)
			id_count += 1
		line = f_input_before.readline()
	f_input_before.close()
	
line = f_input.readline()
while line:
	r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15 = line.split()
	if (str(r3) == "jobstate=COMPLETED" and int(str(r11)[6:]) <= 20):
		if (len(str(r15)) == 17): # Mean that the walltime is superior to 10 days
			walltime = int(str(r15)[6:8])*24*60*60 + int(str(r15)[9:11])*60*60 + int(str(r15)[12:14])*60 + int(str(r15)[15:17])
		if (len(str(r15)) == 16): # Mean that the walltime is superior to 24h
			walltime = int(str(r15)[6:7])*24*60*60 + int(str(r15)[8:10])*60*60 + int(str(r15)[11:13])*60 + int(str(r15)[14:16])
		else:
			walltime = int(str(r15)[6:8])*60*60 + int(str(r15)[9:11])*60 + int(str(r15)[12:14])
		w = Job(int(str(r9)[7:]), int(str(r8)[4:]) - int(str(r7)[6:]), walltime, int(str(r11)[6:]), str(r5)[9:], 0, 0, 1)
		workload.append(w)
		id_count += 1
	line = f_input.readline()
f_input.close()

if (MERGE_3_FILES == 1):
	line = f_input_after.readline()
	while line:
		r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15 = line.split()
		if (str(r3) == "jobstate=COMPLETED" and int(str(r11)[6:]) <= 20):
			if (len(str(r15)) == 17): # Mean that the walltime is superior to 10 days
				walltime = int(str(r15)[6:8])*24*60*60 + int(str(r15)[9:11])*60*60 + int(str(r15)[12:14])*60 + int(str(r15)[15:17])
			if (len(str(r15)) == 16): # Mean that the walltime is superior to 24h
				walltime = int(str(r15)[6:7])*24*60*60 + int(str(r15)[8:10])*60*60 + int(str(r15)[11:13])*60 + int(str(r15)[14:16])
			else:
				walltime = int(str(r15)[6:8])*60*60 + int(str(r15)[9:11])*60 + int(str(r15)[12:14])
			w = Job(int(str(r9)[7:]), int(str(r8)[4:]) - int(str(r7)[6:]), walltime, int(str(r11)[6:]), str(r5)[9:], 0, 0, 2)
			workload.append(w)
			id_count += 1
		line = f_input_after.readline()
	f_input_after.close()

# Min sub time takes 0
workload.sort(key = operator.attrgetter("subtime"))
min_subtime = workload[0].subtime

# Getting data. 0 means no data
f_output = open("inputs/workloads/converted/" + FILENAME, "w")
if (workload[0].cores >= 5):
	workload[0].data = 1
	r = 0
	r = random.randint(0,99)
	size = 6.4
	if (r < PROBABILITY_OF_USING_256GB):
		size = 12.8
	elif (r < PROBABILITY_OF_USING_1TB + PROBABILITY_OF_USING_256GB):
		size = 51.2
	workload[0].data_size = size*workload[0].cores
f_output.write("{ id: %d subtime: %d delay: %d walltime: %d cores: %d user: %s data: %d data_size: %f workload: %d }\n" % (1, workload[0].subtime - min_subtime, workload[0].delay, workload[0].walltime, workload[0].cores, workload[0].user, workload[0].data, workload[0].data_size, workload[0].workload))
last_data = workload[0].data
last_size = workload[0].data_size
last_user = workload[0].user
last_subtime = workload[0].subtime
last_core = workload[0].cores
for i in range (1, id_count - 1):
	if (workload[i].cores >= 5):
		share_last_user = random.randint(0,99)
		if (last_user == workload[i].user and last_subtime + 100 >= workload[i].subtime and last_core == workload[i].cores): # Max 30 seconds between two jobs for them to use the same data and must use the same amount of cores and have the smae user
			workload[i].data = last_data
			workload[i].data_size = last_size
			last_subtime = workload[i].subtime
		else:
			workload[i].data = last_data + 1
			r = 0
			r = random.randint(0,99)
			size = 6.4
			if (r < PROBABILITY_OF_USING_256GB):
				size = 12.8
			elif (r < PROBABILITY_OF_USING_1TB + PROBABILITY_OF_USING_256GB):
				size = 51.2
			workload[i].data_size = size*workload[i].cores
			last_size = workload[i].data_size
			last_data = workload[i].data
			last_user = workload[i].user
			last_subtime = workload[i].subtime
			last_core = workload[i].cores
	f_output.write("{ id: %d subtime: %d delay: %d walltime: %d cores: %d user: %s data: %d data_size: %f workload: %d }\n" % (i + 1, workload[i].subtime - min_subtime, workload[i].delay, workload[i].walltime, workload[i].cores, workload[i].user, workload[i].data, workload[i].data_size, workload[i].workload))
f_output.close()
