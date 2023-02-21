# python3 src/compute_stretch_improvement.py date1 date2

# Imports
import numpy as np
import sys
import operator
from dataclasses import dataclass
from math import *

@dataclass
class Job:
    unique_id: int
    time: float
    data_type: int
    size: int
    subtime: int

x = []
y = []
data_size = []
sizes = []
job_list_algo_reference = []
job_list_algo_compare = []
date1=sys.argv[1]
date2=sys.argv[2]

# FCFS
file_fcfs = "data/Stretch_times_2022-" + date1 + "->2022-" + date2 + "_Fcfs.txt"
with open(file_fcfs) as f:
	line = f.readline()
	while line:
		r1, r2, r3, r4, r5, r6, r7 = line.split() 
		j = Job(int(r1), float(r2), int(r3), int(r4), int(r5))
		job_list_algo_reference.append(j)
		line = f.readline()
f.close()
job_list_algo_reference.sort(key = operator.attrgetter("unique_id"))

# EFT
file_input = "data/Stretch_times_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_x1_x0_x0_x0.txt"
file_output = "data/Stretch_improvement_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_x1_x0_x0_x0.txt"
f_output = open(file_output, "w")
with open(file_input) as f:
	line = f.readline()
	while line:
		r1, r2, r3, r4, r5, r6, r7 = line.split() 
		j = Job(int(r1), float(r2), int(r3), int(r4), int(r5))
		job_list_algo_compare.append(j)
		line = f.readline()
f.close()
job_list_algo_compare.sort(key = operator.attrgetter("unique_id"))
for i in range (0, len(job_list_algo_compare)):
	if job_list_algo_compare[i].time == 0 or job_list_algo_reference[i].time == 0: 
		print("error 0")
		exit
	f_output.write(str(job_list_algo_reference[i].time/job_list_algo_compare[i].time))
	f_output.write("\n")
f_output.close()
job_list_algo_compare.clear()

# LEA
file_input = "data/Stretch_times_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_x500_x1_x0_x0.txt"
file_output = "data/Stretch_improvement_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_x500_x1_x0_x0.txt"
f_output = open(file_output, "w")
with open(file_input) as f:
	line = f.readline()
	while line:
		r1, r2, r3, r4, r5, r6, r7 = line.split() 
		j = Job(int(r1), float(r2), int(r3), int(r4), int(r5))
		job_list_algo_compare.append(j)
		line = f.readline()
f.close()
job_list_algo_compare.sort(key = operator.attrgetter("unique_id"))
for i in range (0, len(job_list_algo_compare)):
	if job_list_algo_compare[i].time == 0 or job_list_algo_reference[i].time == 0: 
		print("error 0")
		exit
	f_output.write(str(job_list_algo_reference[i].time/job_list_algo_compare[i].time))
	f_output.write("\n")
f_output.close()
job_list_algo_compare.clear()

# LEO
file_input = "data/Stretch_times_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_x500_x1_x0_x0.txt"
file_output = "data/Stretch_improvement_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_x500_x1_x0_x0.txt"
f_output = open(file_output, "w")
with open(file_input) as f:
	line = f.readline()
	while line:
		r1, r2, r3, r4, r5, r6, r7 = line.split() 
		j = Job(int(r1), float(r2), int(r3), int(r4), int(r5))
		job_list_algo_compare.append(j)
		line = f.readline()
f.close()
job_list_algo_compare.sort(key = operator.attrgetter("unique_id"))
for i in range (0, len(job_list_algo_compare)):
	if job_list_algo_compare[i].time == 0 or job_list_algo_reference[i].time == 0: 
		print("error 0")
		exit
	f_output.write(str(job_list_algo_reference[i].time/job_list_algo_compare[i].time))
	f_output.write("\n")
f_output.close()
job_list_algo_compare.clear()

# LEM
file_input = "data/Stretch_times_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_mixed_strategy_x500_x1_x0_x0.txt"
file_output = "data/Stretch_improvement_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_mixed_strategy_x500_x1_x0_x0.txt"
f_output = open(file_output, "w")
with open(file_input) as f:
	line = f.readline()
	while line:
		r1, r2, r3, r4, r5, r6, r7 = line.split() 
		j = Job(int(r1), float(r2), int(r3), int(r4), int(r5))
		job_list_algo_compare.append(j)
		line = f.readline()
f.close()
job_list_algo_compare.sort(key = operator.attrgetter("unique_id"))
for i in range (0, len(job_list_algo_compare)):
	if job_list_algo_compare[i].time == 0 or job_list_algo_reference[i].time == 0: 
		print("error 0")
		exit
	f_output.write(str(job_list_algo_reference[i].time/job_list_algo_compare[i].time))
	f_output.write("\n")
f_output.close()
job_list_algo_compare.clear()

job_list_algo_reference.clear()


# FCFS BF
file_fcfs = "data/Stretch_times_2022-" + date1 + "->2022-" + date2 + "_Fcfs_conservativebf.txt"
with open(file_fcfs) as f:
	line = f.readline()
	while line:
		r1, r2, r3, r4, r5, r6, r7 = line.split() 
		j = Job(int(r1), float(r2), int(r3), int(r4), int(r5))
		job_list_algo_reference.append(j)
		line = f.readline()
f.close()
job_list_algo_reference.sort(key = operator.attrgetter("unique_id"))

# EFT BF
file_input = "data/Stretch_times_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_conservativebf_x1_x0_x0_x0.txt"
file_output = "data/Stretch_improvement_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_conservativebf_x1_x0_x0_x0.txt"
f_output = open(file_output, "w")
with open(file_input) as f:
	line = f.readline()
	while line:
		r1, r2, r3, r4, r5, r6, r7 = line.split() 
		j = Job(int(r1), float(r2), int(r3), int(r4), int(r5))
		job_list_algo_compare.append(j)
		line = f.readline()
f.close()
job_list_algo_compare.sort(key = operator.attrgetter("unique_id"))
for i in range (0, len(job_list_algo_compare)):
	if job_list_algo_compare[i].time == 0 or job_list_algo_reference[i].time == 0: 
		print("error 0")
		exit
	f_output.write(str(job_list_algo_reference[i].time/job_list_algo_compare[i].time))
	f_output.write("\n")
f_output.close()
job_list_algo_compare.clear()

# LEA BF
file_input = "data/Stretch_times_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_conservativebf_x500_x1_x0_x0.txt"
file_output = "data/Stretch_improvement_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_conservativebf_x500_x1_x0_x0.txt"
f_output = open(file_output, "w")
with open(file_input) as f:
	line = f.readline()
	while line:
		r1, r2, r3, r4, r5, r6, r7 = line.split() 
		j = Job(int(r1), float(r2), int(r3), int(r4), int(r5))
		job_list_algo_compare.append(j)
		line = f.readline()
f.close()
job_list_algo_compare.sort(key = operator.attrgetter("unique_id"))
for i in range (0, len(job_list_algo_compare)):
	if job_list_algo_compare[i].time == 0 or job_list_algo_reference[i].time == 0: 
		print("error 0")
		exit
	f_output.write(str(job_list_algo_reference[i].time/job_list_algo_compare[i].time))
	f_output.write("\n")
f_output.close()
job_list_algo_compare.clear()

# LEO BF
file_input = "data/Stretch_times_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_conservativebf_x500_x1_x0_x0.txt"
file_output = "data/Stretch_improvement_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_conservativebf_x500_x1_x0_x0.txt"
f_output = open(file_output, "w")
with open(file_input) as f:
	line = f.readline()
	while line:
		r1, r2, r3, r4, r5, r6, r7 = line.split() 
		j = Job(int(r1), float(r2), int(r3), int(r4), int(r5))
		job_list_algo_compare.append(j)
		line = f.readline()
f.close()
job_list_algo_compare.sort(key = operator.attrgetter("unique_id"))
for i in range (0, len(job_list_algo_compare)):
	if job_list_algo_compare[i].time == 0 or job_list_algo_reference[i].time == 0: 
		print("error 0")
		exit
	f_output.write(str(job_list_algo_reference[i].time/job_list_algo_compare[i].time))
	f_output.write("\n")
f_output.close()
job_list_algo_compare.clear()

# LEM BF
file_input = "data/Stretch_times_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_mixed_strategy_conservativebf_x500_x1_x0_x0.txt"
file_output = "data/Stretch_improvement_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_mixed_strategy_conservativebf_x500_x1_x0_x0.txt"
f_output = open(file_output, "w")
with open(file_input) as f:
	line = f.readline()
	while line:
		r1, r2, r3, r4, r5, r6, r7 = line.split() 
		j = Job(int(r1), float(r2), int(r3), int(r4), int(r5))
		job_list_algo_compare.append(j)
		line = f.readline()
f.close()
job_list_algo_compare.sort(key = operator.attrgetter("unique_id"))
for i in range (0, len(job_list_algo_compare)):
	if job_list_algo_compare[i].time == 0 or job_list_algo_reference[i].time == 0: 
		print("error 0")
		exit
	f_output.write(str(job_list_algo_reference[i].time/job_list_algo_compare[i].time))
	f_output.write("\n")
f_output.close()
job_list_algo_compare.clear()

job_list_algo_reference.clear()


