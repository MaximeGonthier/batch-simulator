import sys
import argparse
import csv
import statistics

import pandas as pd
from matplotlib import pyplot as plt
import numpy as np

# ~ def calculate_median(l):
    # ~ l = sorted(l)
    # ~ l_len = len(l)
    # ~ if l_len < 1:
        # ~ return None
    # ~ if l_len % 2 == 0 :
        # ~ return ( l[(l_len-1)/2] + l[(l_len+1)/2] ) / 2.0
    # ~ else:
        # ~ return l[(l_len-1)/2]

# ~ input_data = sys.argv[1]
# ~ output_data = open("data/Percentages_to_fcfs_" + sys.argv[2], "w")
if (int(sys.argv[2]) == 1):
	if (sys.argv[3] == "mediane"):
		output_data_bf = open("data/Percentages_to_fcfs_bf_all_workloads_mediane", "w")
	else:
		output_data_bf = open("data/Percentages_to_fcfs_bf_all_workloads_mean", "w")
else:
	if (sys.argv[3] == "mediane"):
		output_data_bf = open("data/Percentages_to_fcfs_all_workloads_mediane", "w")
	else:
		output_data_bf = open("data/Percentages_to_fcfs_all_workloads_mean", "w")
firstline = True
fcfsline = True
fcfsbfline = True
pair = True
eftline = True
output_data_bf.write("Scheduler, Maximum queue time, Total flow, Total transfer time, Stretch, Stretch with a minimum\n")

# ~ if (int(sys.argv[2]) == 1): # bf
sum_max_queue_time = [[], [], [], []]
sum_total_flow = [[], [], [], []]
sum_transfer_time = [[], [], [], []]
sum_stretch = [[], [], [], []]
sum_stretch_with_min = [[], [], [], []]
# ~ algo = [[], [], [], []]
# ~ else:
	# ~ sum_max_queue_time = [[], [], [], [], [], [], []]
	# ~ sum_total_flow = [[], [], [], [], [], [], []]
	# ~ sum_transfer_time = [[], [], [], [], [], [], []]
	# ~ sum_stretch = [[], [], [], [], [], [], []]
	# ~ sum_stretch_with_min = [[], [], [], [], [], [], []]
	# ~ algo = [[], [], [], [], [], [], []]

nargs = float(sys.argv[1])
nargs2 = int(sys.argv[1])

if (sys.argv[3] == "mean"):
	if (int(sys.argv[2]) == 1):
		scatter_mean_stretch_all_workloads = open("outputs/scatter_mean_stretch_all_workloads_bf.csv", "w")
		scatter_mean_stretch_all_workloads.write("EFT CONSERVATIVE BF,SCORE CONSERVATIVE BF,OPPORTUNISTIC-SCORE MIX CONSERVATIVE BF,EFT-SCORE MIX CONSERVATIVE BF\n")
	else:
		scatter_mean_stretch_all_workloads = open("outputs/scatter_mean_stretch_all_workloads.csv", "w")
		scatter_mean_stretch_all_workloads.write("EFT,SCORE,OPPORTUNISTIC-SCORE MIX,EFT-SCORE MIX\n")

row_index = 0
print("Number of files:", nargs)
for i in range(0, nargs2):
	mycsv = csv.reader(open(sys.argv[i + 4]))
	print("Read " + sys.argv[i + 4] + "...")
	firstline = True
	j = 0
	row_index = 0
	for row in mycsv:
		if firstline:
			firstline = False
			continue
		sum_max_queue_time[j].append(float(row[1]))
		sum_total_flow[j].append(float(row[2]))
		sum_transfer_time[j].append(float(row[3]))
		sum_stretch[j].append(float(row[4]))
		sum_stretch_with_min[j].append(float(row[5]))
		
		# for scatter plot later on
		if (sys.argv[3] == "mean"):
			if (row_index < 3):
				scatter_mean_stretch_all_workloads.write(str(float(row[4])) + ",")
			else:
				scatter_mean_stretch_all_workloads.write(str(float(row[4])))
		row_index = row_index + 1
		
		j += 1
	
	if (sys.argv[3] == "mean"):
		scatter_mean_stretch_all_workloads.write("\n")


	# ~ for i in sum_stretch:
		# ~ for j in i:
			# ~ scatter_mean_stretch_all_workloads.write()

if (sys.argv[3] == "mean"):
	scatter_mean_stretch_all_workloads.close()

print(sum_stretch)

if (sys.argv[3] == "mediane"):
	# Mediane
	if (int(sys.argv[2]) == 1): # bf
		output_data_bf.write("EFT CONSERVATIVE BF" + "," + str(statistics.median(sum_max_queue_time[0])) + "," + str(statistics.median(sum_total_flow[0])) + "," + str(statistics.median(sum_transfer_time[0])) + "," + str(statistics.median(sum_stretch[0])) + "," + str(statistics.median(sum_stretch_with_min[0])) + "\n")
		output_data_bf.write("SCORE CONSERVATIVE BF"  + "," + str(statistics.median(sum_max_queue_time[1])) + "," + str(statistics.median(sum_total_flow[1])) + "," + str(statistics.median(sum_transfer_time[1])) + "," + str(statistics.median(sum_stretch[1])) + "," + str(statistics.median(sum_stretch_with_min[1]))  + "\n")
		output_data_bf.write("OPPORTUNISTIC-SCORE MIX CONSERVATIVE BF"  + "," + str(statistics.median(sum_max_queue_time[2])) + "," + str(statistics.median(sum_total_flow[2])) + "," + str(statistics.median(sum_transfer_time[2])) + "," + str(statistics.median(sum_stretch[2])) + "," + str(statistics.median(sum_stretch_with_min[2]))  +"\n")
		# ~ output_data_bf.write("EFT-SCORE MIX NON DYNAMIC TH100 CONSERVATIVE BF"  + "," + str(statistics.median(sum_max_queue_time[3])) + "," + str(statistics.median(sum_total_flow[3])) + "," + str(statistics.median(sum_transfer_time[3])) + "," + str(statistics.median(sum_stretch[3])) + "," + str(statistics.median(sum_stretch_with_min[3]))  + "\n")
		output_data_bf.write("EFT-SCORE MIX CONSERVATIVE BF"  + "," + str(statistics.median(sum_max_queue_time[3])) + "," + str(statistics.median(sum_total_flow[3])) + "," + str(statistics.median(sum_transfer_time[3])) + "," + str(statistics.median(sum_stretch[3])) + "," + str(statistics.median(sum_stretch_with_min[3]))  + "\n")
	else:
		output_data_bf.write("EFT" + "," + str(statistics.median(sum_max_queue_time[0])) + "," + str(statistics.median(sum_total_flow[0])) + "," + str(statistics.median(sum_transfer_time[0])) + "," + str(statistics.median(sum_stretch[0])) + "," + str(statistics.median(sum_stretch_with_min[0])) + "\n")
		output_data_bf.write("SCORE"  + "," + str(statistics.median(sum_max_queue_time[1])) + "," + str(statistics.median(sum_total_flow[1])) + "," + str(statistics.median(sum_transfer_time[1])) + "," + str(statistics.median(sum_stretch[1])) + "," + str(statistics.median(sum_stretch_with_min[1])) + "\n")
		output_data_bf.write("OPPORTUNISTIC-SCORE MIX"  + "," + str(statistics.median(sum_max_queue_time[2])) + "," + str(statistics.median(sum_total_flow[2])) + "," + str(statistics.median(sum_transfer_time[2])) + "," + str(statistics.median(sum_stretch[2])) + "," + str(statistics.median(sum_stretch_with_min[2])) + "\n")
		# ~ output_data_bf.write("EFT-SCORE MIX NON DYNAMIC TH100"  + "," + str(statistics.median(sum_max_queue_time[3])) + "," + str(statistics.median(sum_total_flow[3])) + "," + str(statistics.median(sum_transfer_time[3])) + "," + str(statistics.median(sum_stretch[3])) + "," + str(statistics.median(sum_stretch_with_min[3]))  + "\n")
		# ~ output_data_bf.write("EFT-SCORE MIX DYNAMIC TH70"  + "," + str(statistics.median(sum_max_queue_time[4])) + "," + str(statistics.median(sum_total_flow[4])) + "," + str(statistics.median(sum_transfer_time[4])) + "," + str(statistics.median(sum_stretch[4])) + "," + str(statistics.median(sum_stretch_with_min[4]))  + "\n")
		# ~ output_data_bf.write("EFT-SCORE MIX DYNAMIC TH100"  + "," + str(statistics.median(sum_max_queue_time[5])) + "," + str(statistics.median(sum_total_flow[5])) + "," + str(statistics.median(sum_transfer_time[5])) + "," + str(statistics.median(sum_stretch[5])) + "," + str(statistics.median(sum_stretch_with_min[5]))  + "\n")
		# ~ output_data_bf.write("EFT-SCORE MIX NON DYNAMIC TH70"  + "," + str(statistics.median(sum_max_queue_time[6])) + "," + str(statistics.median(sum_total_flow[6])) + "," + str(statistics.median(sum_transfer_time[6])) + "," + str(statistics.median(sum_stretch[6])) + "," + str(statistics.median(sum_stretch_with_min[6]))  + "\n")
		output_data_bf.write("EFT-SCORE MIX"  + "," + str(statistics.median(sum_max_queue_time[3])) + "," + str(statistics.median(sum_total_flow[3])) + "," + str(statistics.median(sum_transfer_time[3])) + "," + str(statistics.median(sum_stretch[3])) + "," + str(statistics.median(sum_stretch_with_min[3]))  + "\n")
else:
	# Moyenne
	if (int(sys.argv[2]) == 1): # bf
		output_data_bf.write("EFT CONSERVATIVE BF" + "," + str(statistics.mean(sum_max_queue_time[0])) + "," + str(statistics.mean(sum_total_flow[0])) + "," + str(statistics.mean(sum_transfer_time[0])) + "," + str(statistics.mean(sum_stretch[0])) + "," + str(statistics.mean(sum_stretch_with_min[0])) + "\n")
		output_data_bf.write("SCORE CONSERVATIVE BF"  + "," + str(statistics.mean(sum_max_queue_time[1])) + "," + str(statistics.mean(sum_total_flow[1])) + "," + str(statistics.mean(sum_transfer_time[1])) + "," + str(statistics.mean(sum_stretch[1])) + "," + str(statistics.mean(sum_stretch_with_min[1]))  + "\n")
		output_data_bf.write("OPPORTUNISTIC-SCORE MIX CONSERVATIVE BF"  + "," + str(statistics.mean(sum_max_queue_time[2])) + "," + str(statistics.mean(sum_total_flow[2])) + "," + str(statistics.mean(sum_transfer_time[2])) + "," + str(statistics.mean(sum_stretch[2])) + "," + str(statistics.mean(sum_stretch_with_min[2]))  +"\n")
		# ~ output_data_bf.write("EFT-SCORE MIX NON DYNAMIC TH100 CONSERVATIVE BF MODE 2"  + "," + str(statistics.mean(sum_max_queue_time[3])) + "," + str(statistics.mean(sum_total_flow[3])) + "," + str(statistics.mean(sum_transfer_time[3])) + "," + str(statistics.mean(sum_stretch[3])) + "," + str(statistics.mean(sum_stretch_with_min[3]))  + "\n")
		# ~ output_data_bf.write("EFT-SCORE MIX DYNAMIC TH70 CONSERVATIVE BF MODE 0"  + "," + str(statistics.mean(sum_max_queue_time[4])) + "," + str(statistics.mean(sum_total_flow[4])) + "," + str(statistics.mean(sum_transfer_time[4])) + "," + str(statistics.mean(sum_stretch[4])) + "," + str(statistics.mean(sum_stretch_with_min[4]))  + "\n")
		output_data_bf.write("EFT-SCORE MIX CONSERVATIVE BF"  + "," + str(statistics.mean(sum_max_queue_time[3])) + "," + str(statistics.mean(sum_total_flow[3])) + "," + str(statistics.mean(sum_transfer_time[3])) + "," + str(statistics.mean(sum_stretch[3])) + "," + str(statistics.mean(sum_stretch_with_min[3]))  + "\n")
	else:
		output_data_bf.write("EFT" + "," + str(statistics.mean(sum_max_queue_time[0])) + "," + str(statistics.mean(sum_total_flow[0])) + "," + str(statistics.mean(sum_transfer_time[0])) + "," + str(statistics.mean(sum_stretch[0])) + "," + str(statistics.mean(sum_stretch_with_min[0])) + "\n")
		output_data_bf.write("SCORE"  + "," + str(statistics.mean(sum_max_queue_time[1])) + "," + str(statistics.mean(sum_total_flow[1])) + "," + str(statistics.mean(sum_transfer_time[1])) + "," + str(statistics.mean(sum_stretch[1])) + "," + str(statistics.mean(sum_stretch_with_min[1])) + "\n")
		output_data_bf.write("OPPORTUNISTIC-SCORE MIX"  + "," + str(statistics.mean(sum_max_queue_time[2])) + "," + str(statistics.mean(sum_total_flow[2])) + "," + str(statistics.mean(sum_transfer_time[2])) + "," + str(statistics.mean(sum_stretch[2])) + "," + str(statistics.mean(sum_stretch_with_min[2])) + "\n")
		# ~ output_data_bf.write("EFT-SCORE MIX NON DYNAMIC TH100"  + "," + str(statistics.mean(sum_max_queue_time[3])) + "," + str(statistics.mean(sum_total_flow[3])) + "," + str(statistics.mean(sum_transfer_time[3])) + "," + str(statistics.mean(sum_stretch[3])) + "," + str(statistics.mean(sum_stretch_with_min[3]))  + "\n")
		# ~ output_data_bf.write("EFT-SCORE MIX DYNAMIC TH70"  + "," + str(statistics.mean(sum_max_queue_time[4])) + "," + str(statistics.mean(sum_total_flow[4])) + "," + str(statistics.mean(sum_transfer_time[4])) + "," + str(statistics.mean(sum_stretch[4])) + "," + str(statistics.mean(sum_stretch_with_min[4]))  + "\n")
		# ~ output_data_bf.write("EFT-SCORE MIX DYNAMIC TH100"  + "," + str(statistics.mean(sum_max_queue_time[5])) + "," + str(statistics.mean(sum_total_flow[5])) + "," + str(statistics.mean(sum_transfer_time[5])) + "," + str(statistics.mean(sum_stretch[5])) + "," + str(statistics.mean(sum_stretch_with_min[5]))  + "\n")
		# ~ output_data_bf.write("EFT-SCORE MIX NON DYNAMIC TH70"  + "," + str(statistics.mean(sum_max_queue_time[6])) + "," + str(statistics.mean(sum_total_flow[6])) + "," + str(statistics.mean(sum_transfer_time[6])) + "," + str(statistics.mean(sum_stretch[6])) + "," + str(statistics.mean(sum_stretch_with_min[6]))  + "\n")
		output_data_bf.write("EFT-SCORE MIX"  + "," + str(statistics.mean(sum_max_queue_time[3])) + "," + str(statistics.mean(sum_total_flow[3])) + "," + str(statistics.mean(sum_transfer_time[3])) + "," + str(statistics.mean(sum_stretch[3])) + "," + str(statistics.mean(sum_stretch_with_min[3]))  + "\n")
