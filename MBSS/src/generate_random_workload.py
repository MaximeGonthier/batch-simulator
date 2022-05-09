# Generate a random with random jobs
# python3 src/generate_workload.py Nb_XS Nb_S Nb_M Nb_L Nb_XL Nb_XXL Nb_jobs_first_iteration N_iterations
# { id: 1 priority: 0 delay: 5 res: 1 subtime: 0 walltime: 20 data: [11,12,13] }

# Imports
import random
import sys

XS = int(sys.argv[1])
S = int(sys.argv[2])
M = int(sys.argv[3])
L = int(sys.argv[4])
XL = int(sys.argv[5])
XXL = int(sys.argv[6])
N_jobs_first_workload = int(sys.argv[7])
N_workloads = int(sys.argv[8])

for i in range (0, N_workloads):
	filename = "inputs/workloads/workload_" + str(i+1) + ".txt"
	f = open(filename, "w")
	for j in range (0, N_jobs_first_workload*(i+1)):
		unique_id = j + 1
		priority = 0
		delay = random.randint(5, 15)
		res = 1
		subtime = random.randint(0, 15)
		walltime = random.randint(10, 30)
		f.write("{ id: %d priority: %d delay: %d res: %d subtime: %d walltime: %d data: [" % (unique_id, priority, delay, res, subtime, walltime))
		number_data = random.randint(1, 5)
		
		# Définis si il aura des gros ou des petits fichiers
		data_size = random.randint(0, 99)
		if (data_size < XS):
			for k in range (0, number_data - 1):
				f.write("%d," % random.randint(0, 9))
			f.write("%d] }\n" % random.randint(0, 9))
		elif (data_size < XS + S):
			for k in range (0, number_data - 1):
				f.write("%d," % random.randint(10, 19))
			f.write("%d] }\n" % random.randint(10, 19))
		elif (data_size < XS + S + M):
			for k in range (0, number_data - 1):
				f.write("%d," % random.randint(20, 29))
			f.write("%d] }\n" % random.randint(20, 29))
		elif (data_size < XS + S + M + L):
			for k in range (0, number_data - 1):
				f.write("%d," % random.randint(30, 39))
			f.write("%d] }\n" % random.randint(30, 39))
		elif (data_size < XS + S + M + L + XL):
			for k in range (0, number_data - 1):
				f.write("%d," % random.randint(40, 49))
			f.write("%d] }\n" % random.randint(40, 49))
		elif (data_size < XS + S + M + L + XL + XXL):
			for k in range (0, number_data - 1):
				f.write("%d," % random.randint(50, 59))
			f.write("%d] }\n" % random.randint(50, 59))
		else:
			print("Erreur workload creation")
			exit
	print(filename, "created!")
	f.close()
