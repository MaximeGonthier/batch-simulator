# Read job history files from /sw/share/slurm/rackham/accounting in the Rackham cluster
# Create jobs copying exactly these data
# Add data inputs depending on the arguments given by the user
# Divide in three the jobs sorted by submission time so you have 3 phases and can ignore phases 1 and 3.

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
DATA_ON_ALL_JOBS = int(sys.argv[4]) # 0 or 1

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
		if (str(r3) == "jobstate=COMPLETED" and int(str(r11)[6:]) <= 20 and int(str(r8)[4:]) - int(str(r7)[6:]) > 0): # DELAY MUST NOT BE 0! I don't know why but there are 0 seconds jobs with completed status
			if (len(str(r15)) > 17): # Mean that the walltime is superior to 10 days
				print("Error, size not dealt with")
				exit(1)
			elif (len(str(r15)) == 17): # Mean that the walltime is superior to 10 days
				walltime = int(str(r15)[6:8])*24*60*60 + int(str(r15)[9:11])*60*60 + int(str(r15)[12:14])*60 + int(str(r15)[15:17])
			elif (len(str(r15)) == 16): # Mean that the walltime is superior to 24h
				walltime = int(str(r15)[6:7])*24*60*60 + int(str(r15)[8:10])*60*60 + int(str(r15)[11:13])*60 + int(str(r15)[14:16])
			else:
				walltime = int(str(r15)[6:8])*60*60 + int(str(r15)[9:11])*60 + int(str(r15)[12:14])
			# Similarly walltime must not be 0
			if (walltime > 0):
				# ~ # And I don't want failed jobs with long walltimes
				w = Job(int(str(r9)[7:]), int(str(r8)[4:]) - int(str(r7)[6:]), walltime, int(str(r11)[6:]), str(r5)[9:], 0, 0, -1)
				workload.append(w)
				id_count += 1
			else:
				print("Error walltime is 0 ??")
				exit(1)
	line = f_input.readline()
f_input.close()

# Min sub time takes 0
workload.sort(key = operator.attrgetter("subtime"))
min_subtime = workload[0].subtime
# ~ nb_used_jobs = 0
# ~ nb_ignored_jobs=(int(sys.argv[5])*id_count)/100

# ~ print("There are", id_count - 1, "jobs and", id_count - nb_ignored_jobs*2, "will be evaluated")

# Getting data. 0 means no data
f_output = open("inputs/workloads/converted/" + FILENAME, "w")

if (workload[0].cores >= 5 or DATA_ON_ALL_JOBS == 1):
	workload[0].data = 1
	r = 0
	r = random.randint(0,99)
	size = 6.4
	if (r < PROBABILITY_OF_USING_256GB):
		size = 12.8
	elif (r < PROBABILITY_OF_USING_1TB + PROBABILITY_OF_USING_256GB):
		size = 51.2
	workload[0].data_size = size*workload[0].cores

nb_jobs_before_day_0 = 0
nb_jobs_day_0 = 0
nb_jobs_day_1 = 0
nb_jobs_day_2 = 0

if workload[0].subtime < first_time_day_0:
	workload[0].workload = -1
	nb_jobs_before_day_0 += 1
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
	print("Error time generation workload")
	exit(1)

f_output.write("{ id: %d subtime: %d delay: %d walltime: %d cores: %d user: %s data: %d data_size: %f workload: %d }\n" % (1, workload[0].subtime - min_subtime, workload[0].delay, workload[0].walltime, workload[0].cores, workload[0].user, workload[0].data, workload[0].data_size, workload[0].workload))
last_data = workload[0].data
last_size = workload[0].data_size
last_user = workload[0].user
last_subtime = workload[0].subtime
last_core = workload[0].cores
for i in range (1, id_count - 1):
	if (workload[i].cores >= 5 or DATA_ON_ALL_JOBS == 1):
		share_last_user = random.randint(0,99)
		if (last_user == workload[i].user and last_subtime + 800 >= workload[i].subtime and last_core == workload[i].cores): # Max 800 seconds between two jobs for them to use the same data and must use the same amount of cores and have the smae user
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

		
	# ~ if workload[i].subtime >= first_time_used_jobs and workload[i].subtime <= last_used_job:
		# ~ workload[i].workload = 1
		# ~ nb_used_jobs += 1
	# ~ elif workload[i].subtime > last_used_job:
		# ~ workload[i].workload = 2
	# ~ else:
		# ~ workload[i].workload = 0
	if workload[i].subtime < first_time_day_0:
		workload[i].workload = -1
		nb_jobs_before_day_0 += 1
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
		print("Error time generation workload")
		exit(1)
	
	f_output.write("{ id: %d subtime: %d delay: %d walltime: %d cores: %d user: %s data: %d data_size: %f workload: %d }\n" % (i + 1, workload[i].subtime - min_subtime, workload[i].delay, workload[i].walltime, workload[i].cores, workload[i].user, workload[i].data, workload[i].data_size, workload[i].workload))
f_output.close()

# ~ print("There are", id_count - 1, "jobs.", nb_used_jobs, "will be evaluated")
print("There are", id_count - 1, "jobs.", nb_jobs_before_day_0, "before day 0,", nb_jobs_day_0, "at day 0,", nb_jobs_day_1, "evaluated at day 1,", nb_jobs_day_2, "at day 2 and beyond.")
