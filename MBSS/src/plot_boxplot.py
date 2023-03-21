# python3 src/plot_boxplot.py date1 date2 mode1(byuser or byjob or bybatch) mode2(NO_BF or BF or NO_BF_TRANSFER) detail(core_time,stretch) count_improvement_equal_at_1(0 or 1) boxplot_or_hist(boxplot or hist)

# Import libraries
import matplotlib.pyplot as plt
import numpy as np
import sys

# ~ import plotly.graph_objects as go
# ~ import plotly.express as px
import seaborn as sns

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
mode1 = sys.argv[3]
font_size = 14

if mode1 == "bybatch" or mode1 == "byuser":
	mode2 = sys.argv[4]
	detail = sys.argv[5]
	count_improvement_equal_at_1 = int(sys.argv[6])
	boxplot_or_hist = sys.argv[7]

	if (mode2 == "NO_BF"):
		file_to_open_fcfs = "data/Stretch_times_2022-" + date1 + "->2022-" + date2 + "_Fcfs.csv"
		file_to_open_eft = "data/Stretch_times_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_x1_x0_x0_x0.csv"
		file_to_open_lea = "data/Stretch_times_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_x500_x1_x0_x0.csv"
		file_to_open_leo = "data/Stretch_times_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_x500_x1_x0_x0.csv"
		file_to_open_lem = "data/Stretch_times_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_mixed_strategy_x500_x1_x0_x0.csv"
	elif (mode2 == "BF"):
		file_to_open_fcfs = "data/Stretch_times_2022-" + date1 + "->2022-" + date2 + "_Fcfs_conservativebf.csv"
		file_to_open_eft = "data/Stretch_times_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_conservativebf_x1_x0_x0_x0.csv"
		file_to_open_lea = "data/Stretch_times_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_conservativebf_x500_x1_x0_x0.csv"
		file_to_open_leo = "data/Stretch_times_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_conservativebf_x500_x1_x0_x0.csv"
		file_to_open_lem = "data/Stretch_times_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_mixed_strategy_conservativebf_x500_x1_x0_x0.csv"
	
	data = pd.read_csv(file_to_open_fcfs)
	df=pd.DataFrame(data)
	job_list_algo_reference = []
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
	for i in range(0, len(unique_id)):
		j = Job(unique_id[i], time[i], data_type[i], size[i], subtime[i], cores[i], transfertime[i], user[i], input_file[i], core_time_used[i], bounded_stretch[i])
		job_list_algo_reference.append(j)
	job_list_algo_reference.sort(key = operator.attrgetter("input_file"))
	
	for k in range (0, 4):
		if k == 0:
			file_input = file_to_open_eft
		elif k == 1:
			file_input = file_to_open_lea
		elif k == 2:
			file_input = file_to_open_leo
		elif k == 3:
			file_input = file_to_open_lem
			
		data = pd.read_csv(file_input)
		df=pd.DataFrame(data)
		job_list_algo_compare = []
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
			job_list_algo_compare.append(j)
		job_list_algo_compare.sort(key = operator.attrgetter("input_file"))
		
		last_data = -1
		
		sum_of_core_time_used = 0
		sum_of_core_time_used_reference = 0
		list_of_core_time_used = []
		list_of_core_time_used_reference = []
		
		if mode1 == "bybatch":
			for i in range (0, len(job_list_algo_compare)):
				if last_data != job_list_algo_compare[i].input_file:
					last_data = job_list_algo_compare[i].input_file
					if i != 0:
						list_of_core_time_used.append(sum_of_core_time_used)
						list_of_core_time_used_reference.append(sum_of_core_time_used_reference)
					if detail == "core_time":
						sum_of_core_time_used = job_list_algo_compare[i].core_time_used
						sum_of_core_time_used_reference = job_list_algo_reference[i].core_time_used
					elif detail == "stretch":
						sum_of_core_time_used = job_list_algo_compare[i].time
						sum_of_core_time_used_reference = job_list_algo_reference[i].time
					elif detail == "bounded_stretch":
						sum_of_core_time_used = job_list_algo_compare[i].bounded_stretch
						sum_of_core_time_used_reference = job_list_algo_reference[i].bounded_stretch
					elif detail == "transfer_time":
						sum_of_core_time_used = job_list_algo_compare[i].transfertime
						sum_of_core_time_used_reference = job_list_algo_reference[i].transfertime
					if i == len(job_list_algo_compare) - 1:
						list_of_core_time_used.append(sum_of_core_time_used)
						list_of_core_time_used_reference.append(sum_of_core_time_used_reference)
				else:
					if detail == "core_time":
						sum_of_core_time_used += job_list_algo_compare[i].core_time_used
						sum_of_core_time_used_reference += job_list_algo_reference[i].core_time_used
					elif detail == "stretch":
						sum_of_core_time_used += job_list_algo_compare[i].time
						sum_of_core_time_used_reference += job_list_algo_reference[i].time
					elif detail == "bounded_stretch":
						sum_of_core_time_used += job_list_algo_compare[i].bounded_stretch
						sum_of_core_time_used_reference += job_list_algo_reference[i].bounded_stretch
					elif detail == "transfer_time":
						sum_of_core_time_used += job_list_algo_compare[i].transfertime
						sum_of_core_time_used_reference += job_list_algo_reference[i].transfertime
					if i == len(job_list_algo_compare) - 1:
						list_of_core_time_used.append(sum_of_core_time_used)
						list_of_core_time_used_reference.append(sum_of_core_time_used_reference)
		elif mode1 == "byuser":
			for i in range (0, len(job_list_algo_compare)):
				if last_data != job_list_algo_compare[i].user:
					last_data = job_list_algo_compare[i].user
					if i != 0:
						list_of_core_time_used.append(sum_of_core_time_used)
						list_of_core_time_used_reference.append(sum_of_core_time_used_reference)
					if detail == "core_time":
						sum_of_core_time_used = job_list_algo_compare[i].core_time_used
						sum_of_core_time_used_reference = job_list_algo_reference[i].core_time_used
					elif detail == "stretch":
						sum_of_core_time_used = job_list_algo_compare[i].time
						sum_of_core_time_used_reference = job_list_algo_reference[i].time
					elif detail == "bounded_stretch":
						sum_of_core_time_used = job_list_algo_compare[i].bounded_stretch
						sum_of_core_time_used_reference = job_list_algo_reference[i].bounded_stretch
					elif detail == "transfer_time":
						sum_of_core_time_used = job_list_algo_compare[i].transfertime
						sum_of_core_time_used_reference = job_list_algo_reference[i].transfertime
					if i == len(job_list_algo_compare) - 1:
						list_of_core_time_used.append(sum_of_core_time_used)
						list_of_core_time_used_reference.append(sum_of_core_time_used_reference)
				else:
					if detail == "core_time":
						sum_of_core_time_used += job_list_algo_compare[i].core_time_used
						sum_of_core_time_used_reference += job_list_algo_reference[i].core_time_used
					elif detail == "stretch":
						sum_of_core_time_used += job_list_algo_compare[i].time
						sum_of_core_time_used_reference += job_list_algo_reference[i].time
					elif detail == "bounded_stretch":
						sum_of_core_time_used += job_list_algo_compare[i].bounded_stretch
						sum_of_core_time_used_reference += job_list_algo_reference[i].bounded_stretch
					elif detail == "transfer_time":
						sum_of_core_time_used += job_list_algo_compare[i].transfertime
						sum_of_core_time_used_reference += job_list_algo_reference[i].transfertime
					if i == len(job_list_algo_compare) - 1:
						list_of_core_time_used.append(sum_of_core_time_used)
						list_of_core_time_used_reference.append(sum_of_core_time_used_reference)
		
		if boxplot_or_hist == "boxplot":
			count_total = 0
			count_different_from_1 = 0
			core_time_used_improvement = []
			for i in range (0, len(list_of_core_time_used_reference)):
				improvement = list_of_core_time_used_reference[i]/list_of_core_time_used[i]
				
				# Pour ne pas plot les job dont la différence est de strictement moins de 1%
				if count_improvement_equal_at_1 == 1 or improvement <= 0.99 or improvement >= 1.01:
					core_time_used_improvement.append(improvement)
					count_different_from_1 += 1
				count_total+=1
			
			if mode1 == "byuser":
				print("Total number of users:", count_total, "| Total number of jobs:", total_nb_of_jobs)
			elif mode1 == "bybatch":
				print("Total number of batch:", count_total, "| Total number of jobs:", total_nb_of_jobs)
			
			if k == 0:
				core_time_used_improvement_eft = []
				for i in range (0, len(core_time_used_improvement)):
					core_time_used_improvement_eft.append(core_time_used_improvement[i])
				pourcentage_plot_eft = (count_different_from_1*100)/count_total
			elif k == 1:
				core_time_used_improvement_lea = []
				for i in range (0, len(core_time_used_improvement)):
					core_time_used_improvement_lea.append(core_time_used_improvement[i])
				pourcentage_plot_lea = (count_different_from_1*100)/count_total
			elif k == 2:
				core_time_used_improvement_leo = []
				for i in range (0, len(core_time_used_improvement)):
					core_time_used_improvement_leo.append(core_time_used_improvement[i])
				pourcentage_plot_leo = (count_different_from_1*100)/count_total
			elif k == 3:
				core_time_used_improvement_lem = []
				for i in range (0, len(core_time_used_improvement)):
					core_time_used_improvement_lem.append(core_time_used_improvement[i])
				pourcentage_plot_lem = (count_different_from_1*100)/count_total
		else: # Cas hist
			total_core_time_used = 0
			for i in range (0, len(list_of_core_time_used_reference)):
				total_core_time_used += list_of_core_time_used[i]
			if k == 0:
				total_core_time_used_eft = total_core_time_used
				total_core_time_used_fcfs = 0
				for i in range (0, len(list_of_core_time_used_reference)):
					total_core_time_used_fcfs += list_of_core_time_used_reference[i]
			elif k ==1:
				total_core_time_used_lea = total_core_time_used	
			elif k ==2:
				total_core_time_used_leo = total_core_time_used	
			elif k ==3:
				total_core_time_used_lem = total_core_time_used	
				
		job_list_algo_compare.clear()
		list_of_core_time_used.clear()
		list_of_core_time_used_reference.clear()
		if boxplot_or_hist == "boxplot":
			core_time_used_improvement.clear()
	
	if boxplot_or_hist == "boxplot":
		columns = [core_time_used_improvement_eft, core_time_used_improvement_lea, core_time_used_improvement_leo, core_time_used_improvement_lem]
		colors=["#E50000","#00bfff","#ff9b15","#91a3b0"]
	else:
		columns = [total_core_time_used_fcfs/(60*60), total_core_time_used_eft/(60*60), total_core_time_used_lea/(60*60), total_core_time_used_leo/(60*60), total_core_time_used_lem/(60*60)]
		colors=["#4c0000", "#E50000","#00bfff","#ff9b15","#91a3b0"]
		print(columns)	
		
	fig, ax = plt.subplots()
	if boxplot_or_hist == "boxplot":
		fig = sns.boxplot(data=columns, whis=[12.5, 100 - 12.5], palette=colors)
	else:
		if (mode2 == "NO_BF"):
			fig = plt.bar(["FCFS", "EFT", "LEA", "LEO", "LEM"], columns, color=colors)
		else:
			fig = plt.bar(["FCFS-BF", "EFT-BF", "LEA-BF", "LEO-BF", "LEM-BF"], columns, color=colors)
	
	# box = plt.violinplot(columns, showmedians=True, showmeans=True)

	if boxplot_or_hist == "boxplot":
		if (count_improvement_equal_at_1 == 0):
			if (mode2 == "NO_BF"):
				plt.xticks([0, 1, 2, 3], ["EFT_" + str(pourcentage_plot_eft)[0:2] + "%", "LEA_" + str(pourcentage_plot_lea)[0:2] + "%", "LEO_" + str(pourcentage_plot_leo)[0:2] + "%", "LEM_" + str(pourcentage_plot_lem)[0:2] + "%"], fontsize=font_size)
			elif (mode2 == "BF"):
				plt.xticks([0, 1, 2, 3], ["EFT-BF_" + str(pourcentage_plot_eft)[0:2] + "%", "LEA-BF_" + str(pourcentage_plot_lea)[0:2] + "%", "LEO-BF_" + str(pourcentage_plot_leo)[0:2] + "%", "LEM-BF_" + str(pourcentage_plot_lem)[0:2] + "%"], fontsize=font_size)
		else:
			if (mode2 == "NO_BF"):
				plt.xticks([0, 1, 2, 3], ["EFT", "LEA", "LEO", "LEM"], fontsize=font_size)
			elif (mode2 == "BF"):
				plt.xticks([0, 1, 2, 3], ["EFT-BF", "LEA-BF", "LEO-BF", "LEM-BF"], fontsize=font_size)
		plt.axhline(y = 1, color = 'black', linestyle = "dotted", linewidth=2)

		# Max Y
		plt.ylim(0.5, 2)
	
		if (mode2 == "NO_BF"):
			filename = "plot/Boxplot/" + mode1 + "/box_plot_" + detail +"_" + date1 + "-" + date2 + "_" + str(count_improvement_equal_at_1) + ".pdf"
			if detail == "stretch":
				plt.ylabel('Stretch time\'s improvement from FCFS', fontsize=font_size)
			elif detail == "bounded_stretch":
				plt.ylabel('Bounded stretch time\'s improvement from FCFS', fontsize=font_size)
			elif detail == "core_time":
				plt.ylabel('Core time\'s improvement from FCFS', fontsize=font_size)
		elif (mode2 == "BF"):
			filename = "plot/Boxplot/" + mode1 + "/box_plot_bf_" + detail + "_" + date1 + "-" + date2 + "_" + str(count_improvement_equal_at_1) + ".pdf"
			plt.ylabel('Core time\'s improvement from FCFS-BF', fontsize=font_size)
	else:
		# ~ plt.ylim(700000,740000)
		if (mode2 == "NO_BF"):
			filename = "plot/Boxplot/" + mode1 + "/hist_" + detail +"_" + date1 + "-" + date2 + ".pdf"
		else:
			filename = "plot/Boxplot/" + mode1 + "/hist_bf_" + detail +"_" + date1 + "-" + date2 + ".pdf"
		if detail == "core_time":
			plt.ylabel('Total core time (hours)', fontsize=font_size)
		elif detail == "transfer_time":
			plt.ylabel('Total transfer time (hours)', fontsize=font_size)
			
	plt.savefig(filename, bbox_inches='tight')
		

elif mode1 == "byjob":
	if (mode2 == "NO_BF"):
		file_to_open_eft = "data/Stretch_improvement_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_x1_x0_x0_x0.txt"
		file_to_open_lea = "data/Stretch_improvement_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_x500_x1_x0_x0.txt"
		file_to_open_leo = "data/Stretch_improvement_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_x500_x1_x0_x0.txt"
		file_to_open_lem = "data/Stretch_improvement_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_mixed_strategy_x500_x1_x0_x0.txt"
	elif (mode2 == "BF"):
		file_to_open_eft = "data/Stretch_improvement_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_conservativebf_x1_x0_x0_x0.txt"
		file_to_open_lea = "data/Stretch_improvement_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_conservativebf_x500_x1_x0_x0.txt"
		file_to_open_leo = "data/Stretch_improvement_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_conservativebf_x500_x1_x0_x0.txt"
		file_to_open_lem = "data/Stretch_improvement_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_mixed_strategy_conservativebf_x500_x1_x0_x0.txt"
	elif (mode2 == "NO_BF_TRANSFER"):
		file_to_open_eft = "data/Stretch_improvement_if_transfer_reduction_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_conservativebf_x1_x0_x0_x0.txt"
		file_to_open_lea = "data/Stretch_improvement_if_transfer_reduction_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_conservativebf_x500_x1_x0_x0.txt"
		file_to_open_leo = "data/Stretch_improvement_if_transfer_reduction_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_conservativebf_x500_x1_x0_x0.txt"
		file_to_open_lem = "data/Stretch_improvement_if_transfer_reduction_2022-" + date1 + "->2022-" + date2 + "_Fcfs_with_a_score_mixed_strategy_conservativebf_x500_x1_x0_x0.txt"

	count=0
	if (mode2 == "NO_BF_TRANSFER"):
		with open(file_to_open_eft, 'r') as fp:
			for count, line in enumerate(fp):
				pass
		print('Total Lines', count + 1)
		line_eft = count+1
		fp.close()
		with open(file_to_open_lea, 'r') as fp:
			for count, line in enumerate(fp):
				pass
		print('Total Lines', count + 1)
		line_lea = count+1
		fp.close()
		with open(file_to_open_leo, 'r') as fp:
			for count, line in enumerate(fp):
				pass
		print('Total Lines', count + 1)
		line_leo = count+1
		fp.close()
		with open(file_to_open_lem, 'r') as fp:
			for count, line in enumerate(fp):
				pass
		print('Total Lines', count + 1)
		line_lem = count+1
		fp.close()
	else:
		with open(file_to_open_eft, 'r') as fp:
			for count, line in enumerate(fp):
				pass
		print('Total Lines', count + 1)
		fp.close()

	df_eft = pd.read_csv(file_to_open_eft)
	df_lea = pd.read_csv(file_to_open_lea)
	df_leo = pd.read_csv(file_to_open_leo)
	df_lem = pd.read_csv(file_to_open_lem)

	eft = list(df_eft.iloc[:, 0])
	score = list(df_lea.iloc[:, 0])
	opportunistic = list(df_leo.iloc[:, 0])
	eft_score = list(df_lem.iloc[:, 0])
	# ~ print(eft)
	columns = [eft, score, opportunistic, eft_score]
	# ~ columns = [eft, score, eft_score]
	colors=["#E50000","#00bfff","#ff9b15","#91a3b0"]
	# ~ colors=["#E50000","#00bfff","#91a3b0"]
	fig, ax = plt.subplots()


	# ~ size_extremity = 25 # Quartile
	size_extremity = 12.5 # Octile
	# ~ size_extremity = 6.25 # 16-tile
	# ~ size_extremity = 3.125 # 32-tile
	# ~ size_extremity = 1 # Percentile

	# ~ box = plt.boxplot(columns, patch_artist=True, meanline=True, showmeans=True, whis=[size_extremity, 100 - size_extremity])
	# ~ box = plt.boxplot(columns, patch_artist=True, whis=[size_extremity, 100 - size_extremity], showfliers=False)

	box = plt.violinplot(columns, showmedians=True, showmeans=True)


	c="#095228"

	# ~ for boxes in box['boxes']:
		# ~ if (mode2 == "BF"):
			# ~ boxes.set(hatch = '/', color="white")
			
	# ~ for median in box['medians']:
		# ~ median.set_color(c)
		# ~ median.set_linewidth(1.9)
	# ~ for mean in box['means']:
		# ~ mean.set_color(c)
		# ~ mean.set_linewidth(1.9)



	if (mode2 == "NO_BF"):
		plt.xticks([1, 2, 3, 4], ["EFT", "LEA", "LEO", "LEM"], fontsize=font_size)
		# ~ plt.xticks([1, 2, 3], ["EFT", "LEA", "LEM"], fontsize=font_size)
	elif (mode2 == "BF"):
		plt.xticks([1, 2, 3, 4], ["EFT-BF", "LEA-BF", "LEO-BF", "LEM-BF"], fontsize=font_size)
	elif (mode2 == "NO_BF_TRANSFER"):
		plt.xticks([1, 2, 3, 4], ["EFT-" + str(line_eft), "LEA-" + str(line_lea), "LEO-" + str(line_leo), "LEM-" + str(line_lem)], fontsize=font_size)
		
	plt.axhline(y = 1, color = 'black', linestyle = "dotted", linewidth=4)


	# Max Y
	# ~ plt.ylim(0.95, 1.05)
	plt.ylim(0, 2)
	# ~ plt.ylim(0, 10)

	plt.yticks(fontsize=font_size)
	plt.rcParams['hatch.linewidth'] = 9

	# ~ if (mode2 == "BF"):
		# ~ for patch, color in zip(box['boxes'], colors):
			# ~ patch.set_facecolor("white")
			# ~ patch.set_edgecolor(color)
	# ~ else:
		# ~ for patch, color in zip(box['boxes'], colors):
			# ~ patch.set_facecolor(color)
			

	if (mode2 == "NO_BF"):
		filename = "plot/Boxplot/box_plot_" + str(count + 1) + "_" + date1 + "-" + date2 + ".pdf"
		plt.ylabel('Stretch\'s improvement from FCFS', fontsize=font_size)
	elif (mode2 == "NO_BF"):
		filename = "plot/Boxplot/box_plot_bf_" + str(count + 1) + "_" + date1 + "-" + date2 + ".pdf"
		plt.ylabel('Stretch\'s improvement from FCFS-BF', fontsize=font_size)
	elif (mode2 == "NO_BF_TRANSFER"):
		filename = "plot/Boxplot/box_plot_transfer_" + date1 + "-" + date2 + ".pdf"
		plt.ylabel('Stretch\'s improvement from FCFS-BF', fontsize=font_size)


	plt.savefig(filename, bbox_inches='tight')
