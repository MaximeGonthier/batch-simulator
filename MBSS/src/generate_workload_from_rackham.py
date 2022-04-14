# Read job history files from /sw/share/slurm/rackham/accounting in the Rackham cluster
# Create jobs copying exactly these data
# Add data inputs depending on the arguments given by the user

# Imports
import sys

# Args
PERCENTAGE_OF_JOB_WITH_DATA = int(sys.argv[1]) # 0-100. Give the percentage of jobs that will have data inputs
NUMBER_OF_SHARED_DATA_PER_JOB = int(sys.argv[2]) # A job have shared and individual data
NUMBER_OF_INDIVIDUAL_DATA_PER_JOB = int(sys.argv[3])
TRANSFER_TIME_COMPARED_TO_JOB_DURATION = int(sys.argv[4]) # 0-100. Percentage of the job duration that is transfer time
# TODO : récupérer le cluster aussi pour la BW
filename = sys.argv[5]

f_input = open("inputs/workloads/raw/" + filename, "r")
f_output = open("inputs/workloads/converted/" + filename, "w")

id_count = 1

line = f_input.readline()
while line:
	r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15 = line.split()
	if (str(r3) == "jobstate=COMPLETED"):
		# ~ walltime = int(str(r15)[7])*60*60
		walltime = 1
		print(str(r15)[7])
		f_output.write("{ id: %d subtime: %d delay: %d walltime: %d cores: %d data: [" % (id_count, int(str(r9)[7:]), int(str(r8)[4:]) - int(str(r7)[6:]), walltime, int(str(r11)[6:])))
		f_output.write("\n")
		id_count += 1
	line = f_input.readline()
# ~ int(str(r15)[6:7])*10*60*60 + int(str(r15)[7:8])*60*60 + int(str(r15)[9:10])*10*60 + int(str(r15)[10:11])*60 + int(str(r15)[12:13])*10 + int(str(r15)[13:14])
