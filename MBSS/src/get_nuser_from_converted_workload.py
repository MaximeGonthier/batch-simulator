# python3 src/get_nuser_from_converted_workload.py

# Import libraries
# ~ import matplotlib.pyplot as plt
# ~ import numpy as np
# ~ import sys
# ~ import seaborn as sns

# ~ import operator
# ~ import pandas as pd
from dataclasses import dataclass
from math import *

@dataclass
class Job: # Id Stretch Datatype Length Subtime, Ncores, TransferTime, user, input_file, core_time_used
    unique_id: int
    time: float # stretch
    data_type: int # 0
    size: int # durée
    subtime: int 
    cores: int # 1-20
    transfertime: int # 64 par core
    user: int # Attention unique id ne trie pas par user! uique id c'est par endtime donc faut que je recolleles morceaux en récupérant les users qui ont les memes fichiers et meme user pour by batch
    input_file: int
    core_time_used: int
    bounded_stretch: float

# List of files I will be analyzing. If I add workloads just add it here.
file_list = []
file_list.append("inputs/workloads/converted/2022-02-21->2022-02-27_V10000")
file_list.append("inputs/workloads/converted/2022-07-11->2022-07-17_V10000")
file_list.append("inputs/workloads/converted/2022-09-05->2022-09-11_V10000")
file_list.append("inputs/workloads/converted/2022-10-10->2022-10-16_V10000")
file_list.append("inputs/workloads/converted/2022-01-10->2022-01-16_V10000")
file_list.append("inputs/workloads/converted/2022-02-07->2022-02-13_V10000")
file_list.append("inputs/workloads/converted/2022-03-28->2022-04-03_V10000")
file_list.append("inputs/workloads/converted/2022-10-17->2022-10-23_V10000")
file_list.append("inputs/workloads/converted/2022-10-24->2022-10-30_V10000")
file_list.append("inputs/workloads/converted/2022-12-12->2022-12-18_V10000")
file_list.append("inputs/workloads/converted/2022-01-03->2022-01-09_V10000")
file_list.append("inputs/workloads/converted/2022-10-03->2022-10-09_V10000")

nb_job_workload_minus_2 = 0
nb_job_workload_minus_1 = 0
nb_job_workload_0 = 0
nb_job_workload_1 = 0
nb_job_workload_2 = 0
user_list = []
nb_distinct_user = 0
nb_batch_of_users = 0

for i in range(len(file_list)):
	print("Reading", file_list[i])
	with open(file_list[i]) as f_input:
		line = f_input.readline()
		last_user = ""
		while line:
			r1, r2, job_id, r4, subtime, r6, delay, r8, walltime, r10, cores, r12, user, r14, data, r16, data_size, r18, workload, r20, r21, r22, r23, r24 = line.split()
			# { id: 1 subtime: 0 delay: 808260 walltime: 864000 cores: 2 user: mjbit data: 1 data_size: 12.800000 workload: -2 start_time_from_history: 232740 start_node_from_history: 39 }

			if int(workload) == -2:
				nb_job_workload_minus_2 += 1
			elif int(workload) == -1:
				nb_job_workload_minus_1 += 1
			elif int(workload) == 0:
				nb_job_workload_0 += 1
			elif int(workload) == 1:
				nb_job_workload_1 += 1
			elif int(workload) == 2:
				nb_job_workload_2 += 1
			else:
				print("Error workload is", workload)
			
			if user not in user_list:
				nb_distinct_user += 1
				user_list.append(user)

			if (user != last_user):
				nb_batch_of_users += 1
				last_user = user
								
			line = f_input.readline()
	f_input.close()

print("\n##### Stats #####:")
print("Nb of jobs started before the evaluated week:", nb_job_workload_minus_2)
print("Nb of jobs submitted before the evaluated week:", nb_job_workload_minus_1)
print("Nb of scheduled jobs before the evaluated week:", nb_job_workload_0)
print("Nb of evaluated jobs:", nb_job_workload_1)
print("Nb of scheduled jobs after the evaluated week:", nb_job_workload_2)
print("Total number of jobs:", nb_job_workload_minus_2 + nb_job_workload_minus_1 + nb_job_workload_0 + nb_job_workload_1 + nb_job_workload_2)
print("Number of distinct users:", nb_distinct_user)
print("Number of batch of users:", nb_batch_of_users)
