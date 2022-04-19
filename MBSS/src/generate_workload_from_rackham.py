# Read job history files from /sw/share/slurm/rackham/accounting in the Rackham cluster
# Create jobs copying exactly these data
# Add data inputs depending on the arguments given by the user

# Imports
import sys
import random

# Args
PERCENTAGE_OF_JOB_WITH_DATA = int(sys.argv[1]) # 0-100. Give the percentage of jobs that will have data inputs
NUMBER_OF_SHARED_DATA_PER_JOB = int(sys.argv[2]) # A job have shared and individual data
NUMBER_OF_INDIVIDUAL_DATA_PER_JOB = int(sys.argv[3])
INDIVIDUAL_JOB_TRANSFER_TIME_COMPARED_TO_JOB_DURATION = int(sys.argv[4]) # 0-100. Percentage of the job duration that is transfer time
NUMBER_DIFFERENT_SHARED_DATA = int(sys.argv[5]) # The more different data, the less the data share among jobs
# TODO : récupérer le cluster aussi pour la BW
FILENAME = sys.argv[6]

f_input = open("inputs/workloads/raw/" + FILENAME, "r")
f_output = open("inputs/workloads/converted/" + FILENAME, "w")

id_count = 1

print(PERCENTAGE_OF_JOB_WITH_DATA, "% of jobs have data. If a job has data it has", NUMBER_OF_INDIVIDUAL_DATA_PER_JOB, "individual data and", NUMBER_OF_SHARED_DATA_PER_JOB, "shared data. Loading 1 unique data takes", INDIVIDUAL_JOB_TRANSFER_TIME_COMPARED_TO_JOB_DURATION, "% of the job duration. Loading 1 shared data takes ???% of the job duration. There are", NUMBER_DIFFERENT_SHARED_DATA, "different shared data.")

# Generates data sizes randomly for now
size = NUMBER_DIFFERENT_SHARED_DATA + 1
tab_of_sizes = [0] * size
for i in range (1, NUMBER_DIFFERENT_SHARED_DATA + 1):
	tab_of_sizes[i] = random.randint(500, 2000)
	
# Read the file first to get the min of submission time and then reduce the submission time
line = f_input.readline()
min_subtime = -1
while line:
	r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15 = line.split()
	if ((min_subtime > int(str(r9)[7:]) or min_subtime == -1) and str(r3) == "jobstate=COMPLETED"):
		min_subtime = int(str(r9)[7:])
	line = f_input.readline()
f_input.seek(0, 0) # Reset le fichier au début

line = f_input.readline()
while line:
	r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15 = line.split()
	if (str(r3) == "jobstate=COMPLETED"):
		if (len(str(r15)) == 16): # Mean that the walltime is superior to 24h
			walltime = int(str(r15)[6:7])*24*60*60 + int(str(r15)[8:10])*60*60 + int(str(r15)[11:13])*60 + int(str(r15)[14:16])
		else:
			walltime = int(str(r15)[6:8])*60*60 + int(str(r15)[9:11])*60 + int(str(r15)[12:14])
		f_output.write("{ id: %d subtime: %d delay: %d walltime: %d cores: %d data: [" % (id_count, int(str(r9)[7:]) - min_subtime, int(str(r8)[4:]) - int(str(r7)[6:]), walltime, int(str(r11)[6:])))
		
		# Printing and creating data dependencies
		has_data = random.randint(0, 99)
		if (has_data < PERCENTAGE_OF_JOB_WITH_DATA):
			for i in range (0, NUMBER_OF_INDIVIDUAL_DATA_PER_JOB):
				f_output.write(" %d" % 0) # 0 pour donnée unique du job. Ce qui est important c'est sa taille ensuite
			shared_data_sizes = [0] * NUMBER_OF_SHARED_DATA_PER_JOB
			for i in range (0, NUMBER_OF_SHARED_DATA_PER_JOB):
				# Randomly pick a data for now
				shared_data = random.randint(1, NUMBER_DIFFERENT_SHARED_DATA)
				shared_data_sizes[i] = tab_of_sizes[shared_data]
				f_output.write(" %d" % shared_data)
			f_output.write(" ] data_sizes: [")
			for i in range (0, NUMBER_OF_INDIVIDUAL_DATA_PER_JOB):
				transfer_time = (INDIVIDUAL_JOB_TRANSFER_TIME_COMPARED_TO_JOB_DURATION*(int(str(r8)[4:]) - int(str(r7)[6:])))/100
				f_output.write(" %d" % transfer_time) # % du job précisé en argument d'entrées
			for i in range (0, NUMBER_OF_SHARED_DATA_PER_JOB):
				transfer_time = shared_data_sizes[i]
				f_output.write(" %d" % transfer_time) # % du job précisé en argument d'entrées
			f_output.write(" ] }\n")
		else:
			f_output.write("] data_sizes: [] }\n")
		id_count += 1
	line = f_input.readline()
