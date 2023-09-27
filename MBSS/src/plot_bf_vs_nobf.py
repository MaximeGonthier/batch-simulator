# python3 src/plot_bf_vs_nobf.py date1 date2

# Import libraries
import matplotlib.pyplot as plt
import numpy as np
import sys
import operator
import pandas as pd
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

date1 = sys.argv[1]
date2 = sys.argv[2]
font_size = 14
print(date1, date2)

file_to_open_fcfs = "data/Stretch_times_2022-" + date1 + "->2022-" + date2 + "_Fcfs.csv"
file_to_open_eft = "data/Stretch_times_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_x1_x0_x0_x0.csv"
file_to_open_lea = "data/Stretch_times_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_x500_x1_x0_x0.csv"
file_to_open_leo = "data/Stretch_times_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_x500_x1_x0_x0.csv"
file_to_open_lem = "data/Stretch_times_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_mixed_strategy_x500_x1_x0_x0.csv"

file_to_open_fcfs_bf = "data/Stretch_times_2022-" + date1 + "->2022-" + date2 + "_Fcfs_conservativebf.csv"
file_to_open_eft_bf = "data/Stretch_times_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_conservativebf_x1_x0_x0_x0.csv"
file_to_open_lea_bf = "data/Stretch_times_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_conservativebf_x500_x1_x0_x0.csv"
file_to_open_leo_bf = "data/Stretch_times_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_conservativebf_x500_x1_x0_x0.csv"
file_to_open_lem_bf = "data/Stretch_times_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_mixed_strategy_conservativebf_x500_x1_x0_x0.csv"
			
for k in range (0, 10):
	if k == 0:
		file_input = file_to_open_fcfs
	elif k == 1:
		file_input = file_to_open_eft
	elif k == 2:
		file_input = file_to_open_lea
	elif k == 3:
		file_input = file_to_open_leo
	elif k == 4:
		file_input = file_to_open_lem
	elif k == 5:
		file_input = file_to_open_fcfs_bf
	elif k == 6:
		file_input = file_to_open_eft_bf
	elif k == 7:
		file_input = file_to_open_lea_bf
	elif k == 8:
		file_input = file_to_open_leo_bf
	elif k == 9:
		file_input = file_to_open_lem_bf
		
	print("Open", file_input)
		
	data = pd.read_csv(file_input)
	df=pd.DataFrame(data)
	job_list = []
	unique_id = list(df.iloc[:, 0])
	time = list(df.iloc[:, 1])
	data_type = list(df.iloc[:, 2])
	size = list(df.iloc[:, 3])
	subtime = list(df.iloc[:, 4])
	cores = list(df.iloc[:, 5])
	transfertime = list(df.iloc[:, 6])
	user = list(df.iloc[:, 7])
	input_file = list(df.iloc[:, 8])
	core_time_used = list(df.iloc[:, 9])
	bounded_stretch = list(df.iloc[:, 10])
	total_nb_of_jobs = len(unique_id)

	for i in range(0, len(unique_id)):
		j = Job(unique_id[i], time[i], data_type[i], size[i], subtime[i], cores[i], transfertime[i], user[i], input_file[i], core_time_used[i], bounded_stretch[i])
		job_list.append(j)
	job_list.sort(key = operator.attrgetter("input_file"))
						
	last_data = -1
		
	sum_of_stretch = 0
	list_of_stretch = []
	n_user_session = 0
	
	for i in range (0, len(job_list)):
		if last_data != job_list[i].user:
			last_data = job_list[i].user
			if i != 0:
				n_user_session += 1
				list_of_stretch.append(sum_of_stretch)
			sum_of_stretch = job_list[i].time
			if i == len(job_list) - 1:
				n_user_session += 1
				list_of_stretch.append(sum_of_stretch)
		else:
			sum_of_stretch += job_list[i].time
			if i == len(job_list) - 1:
				n_user_session += 1
				list_of_stretch.append(sum_of_stretch)
	
	# ~ list_of_stretch.append(1)
	# ~ list_of_stretch.append(14)
	# ~ list_of_stretch.append(145)
	# ~ n_user_session = 3
	
	print("n_user_session =", n_user_session)
	
	if k == 0:
		total_stretch_fcfs = 0
		for i in range (0, len(list_of_stretch)):
			total_stretch_fcfs += list_of_stretch[i]
	elif k == 1:
		total_stretch_eft = 0
		for i in range (0, len(list_of_stretch)):
			total_stretch_eft += list_of_stretch[i]
	elif k == 2:
		total_stretch_lea = 0
		for i in range (0, len(list_of_stretch)):
			total_stretch_lea += list_of_stretch[i]
	elif k == 3:
		total_stretch_leo = 0
		for i in range (0, len(list_of_stretch)):
			total_stretch_leo += list_of_stretch[i]
	elif k == 4:
		total_stretch_lem = 0
		for i in range (0, len(list_of_stretch)):
			total_stretch_lem += list_of_stretch[i]
	elif k == 5:
		total_stretch_fcfs_bf = 0
		for i in range (0, len(list_of_stretch)):
			total_stretch_fcfs_bf += list_of_stretch[i]
	elif k == 6:
		total_stretch_eft_bf = 0
		for i in range (0, len(list_of_stretch)):
			total_stretch_eft_bf += list_of_stretch[i]
	elif k == 7:
		total_stretch_lea_bf = 0
		for i in range (0, len(list_of_stretch)):
			total_stretch_lea_bf += list_of_stretch[i]
	elif k == 8:
		total_stretch_leo_bf = 0
		for i in range (0, len(list_of_stretch)):
			total_stretch_leo_bf += list_of_stretch[i]
	elif k == 9:
		total_stretch_lem_bf = 0
		for i in range (0, len(list_of_stretch)):
			total_stretch_lem_bf += list_of_stretch[i]
				
	job_list.clear()
	list_of_stretch.clear()
	

print(total_stretch_fcfs)
print(total_stretch_eft)
print(total_stretch_lea)
print(total_stretch_leo)
print(total_stretch_lem)
print(total_stretch_fcfs_bf)
print(total_stretch_eft_bf)
print(total_stretch_lea_bf)
print(total_stretch_leo_bf)
print(total_stretch_lem_bf)

markers=["x", "o", "x", "o", "x", "o", "x", "o", "x", "o"]
colors=["#4c0000","#4c0000","#E50000","#E50000","#00bfff","#00bfff","#ff9b15","#ff9b15","#91a3b0","#91a3b0"]

fig, ax = plt.subplots()

Y = []
Y.append(total_stretch_fcfs/n_user_session)
Y.append(total_stretch_fcfs_bf/n_user_session)
Y.append(total_stretch_eft/n_user_session)
Y.append(total_stretch_eft_bf/n_user_session)
Y.append(total_stretch_lea/n_user_session)
Y.append(total_stretch_lea_bf/n_user_session)
Y.append(total_stretch_leo/n_user_session)
Y.append(total_stretch_leo_bf/n_user_session)
Y.append(total_stretch_lem/n_user_session)
Y.append(total_stretch_lem_bf/n_user_session)
X = ["FCFS", "FCFS-BF", "EFT", "EFT-BF", "LEA", "LEA-BF", "LEO", "LEO-BF", "LEM", "LEM-BF"]
for i in range(len(X)):
	fig = plt.scatter(X[i], Y[i], color=colors[i], s=200, marker=markers[i])
	# ~ fig.set_size_inches(6, 3)
	
ax.set_xticklabels(X, rotation = 45, ha="right")
		
# Max Y
# ~ plt.ylim(0.3, 2)
	
plt.ylabel('Mean stretch by user\'s session', fontsize=font_size)
plt.xticks([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], ["FCFS", "FCFS-BF", "EFT", "EFT-BF", "LEA", "LEA-BF", "LEO", "LEO-BF", "LEM", "LEM-BF"], fontsize=font_size)
filename = "plot/byuser/Mean_stretch_with_and_without_bf_" + date1 + "-" + date2 + ".pdf"

# ~ fig.set_size_inches(6, 3)

ax.figure.set_size_inches(6, 3)

plt.savefig(filename, bbox_inches='tight')
	
