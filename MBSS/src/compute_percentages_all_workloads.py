import sys
import argparse
import csv
import statistics
def calculate_median(l):
    l = sorted(l)
    l_len = len(l)
    if l_len < 1:
        return None
    if l_len % 2 == 0 :
        return ( l[(l_len-1)/2] + l[(l_len+1)/2] ) / 2.0
    else:
        return l[(l_len-1)/2]

# ~ input_data = sys.argv[1]
# ~ output_data = open("data/Percentages_to_fcfs_" + sys.argv[2], "w")
if (int(sys.argv[2]) == 1):
	output_data_bf = open("data/Percentages_to_fcfs_bf_all_workloads", "w")
else:
	output_data_bf = open("data/Percentages_to_fcfs_all_workloads", "w")
firstline = True
fcfsline = True
fcfsbfline = True
pair = True
eftline = True
# ~ mycsv = csv.reader(open(input_data))
output_data_bf.write("Scheduler, Maximum queue time, Total flow, Total transfer time, Stretch, Stretch with a minimum\n")

# ~ sum_max_queue_time = [0, 0, 0, 0, 0, 0, 0]
sum_max_queue_time = [[], [], [], [], []]
# ~ sum_total_flow = [0, 0, 0, 0, 0, 0, 0]
sum_total_flow = [[], [], [], [], []]
# ~ sum_transfer_time = [0, 0, 0, 0, 0, 0, 0]
sum_transfer_time = [[], [], [], [], []]
# ~ sum_stretch = [0, 0, 0, 0, 0, 0, 0]
sum_stretch = [[], [], [], [], []]
# ~ sum_stretch_with_min = [0, 0, 0, 0, 0, 0, 0]
sum_stretch_with_min = [[], [], [], [], []]

nargs = float(sys.argv[1])
nargs2 = int(sys.argv[1])
print("Number of files:", nargs)
# ~ j = 0
for i in range(0, nargs2):
	mycsv = csv.reader(open(sys.argv[i + 3]))
	# ~ sum_max_queue_time += 
	print("Read " + sys.argv[i + 3] + "...")
	firstline = True
	j = 0
	for row in mycsv:
		if firstline:
			firstline = False
			continue
		# Moyenne
		# ~ sum_max_queue_time[j] += float(row[1])
		# ~ sum_total_flow[j] += float(row[2])
		# ~ sum_transfer_time[j] += float(row[3])
		# ~ sum_stretch[j] += float(row[4])
		# ~ sum_stretch_with_min[j] += float(row[5])
		# Mediane
		sum_max_queue_time[j].append(float(row[1]))
		sum_total_flow[j].append(float(row[2]))
		sum_transfer_time[j].append(float(row[3]))
		sum_stretch[j].append(float(row[4]))
		sum_stretch_with_min[j].append(float(row[5]))
	
		# ~ if (j == 0):
			# ~ print("For EFT: ", float(row[1]))
	
		j += 1
	
    # ~ if fcfsline:
        # ~ fcfsline = False
        # ~ max_queue_fcfs = float(row[2])
        # ~ total_flow_fcfs = float(row[7])
        # ~ transfer_time_fcfs = float(row[12])
        # ~ stretch_fcfs = float(row[13])
        # ~ stretch_with_a_min_fcfs = float(row[14])
        # ~ continue
    # ~ if fcfsbfline:
        # ~ fcfsbfline = False
        # ~ max_queue_fcfsbf = float(row[2])
        # ~ total_flow_fcfsbf = float(row[7])
        # ~ transfer_time_fcfsbf = float(row[12])
        # ~ stretch_fcfsbf = float(row[13])
        # ~ stretch_with_a_min_fcfsbf = float(row[14])
        # ~ continue
    # ~ if eftline:
        # ~ eftline = False
        # ~ continue
    
    # ~ output_data_bf.write(row[0] + "," + str(((float(row[2])-max_queue_fcfsbf)/(max_queue_fcfsbf))*100) + "," + str(((float(row[7])-total_flow_fcfsbf)/(total_flow_fcfsbf))*100) + "," + str(((float(row[12])-transfer_time_fcfsbf)/(transfer_time_fcfsbf))*100) + "," + str(((float(row[13])-stretch_fcfsbf)/(stretch_fcfsbf))*100) + "," + str(((float(row[14])-stretch_with_a_min_fcfsbf)/(stretch_with_a_min_fcfsbf))*100) + "\n")

# Moyenne
# ~ output_data_bf.write("EFT" + "," + str(sum_max_queue_time[0]/nargs) + "," + str(sum_total_flow[0]/nargs) + "," + str(sum_transfer_time[0]/nargs) + "," + str(sum_stretch[0]/nargs) + "," + str(sum_stretch_with_min[0]/nargs) + "\n")
# ~ output_data_bf.write("SCORE"  + "," + str(sum_max_queue_time[1]/nargs) + "," + str(sum_total_flow[1]/nargs) + "," + str(sum_transfer_time[1]/nargs) + "," + str(sum_stretch[1]/nargs) + "," + str(sum_stretch_with_min[1]/nargs) + "\n")
# ~ output_data_bf.write("SCORE CONSERVATIVE BF"  + "," + str(sum_max_queue_time[2]/nargs) + "," + str(sum_total_flow[2]/nargs) + "," + str(sum_transfer_time[2]/nargs) + "," + str(sum_stretch[2]/nargs) + "," + str(sum_stretch_with_min[2]/nargs)  + "\n")
# ~ output_data_bf.write("EFT-SCORE MIX"  + "," + str(sum_max_queue_time[3]/nargs) + "," + str(sum_total_flow[3]/nargs) + "," + str(sum_transfer_time[3]/nargs) + "," + str(sum_stretch[3]/nargs) + "," + str(sum_stretch_with_min[3]/nargs)  + "\n")
# ~ output_data_bf.write("EFT-SCORE MIX CONSERVATIVE BF"  + "," + str(sum_max_queue_time[4]/nargs) + "," + str(sum_total_flow[4]/nargs) + "," + str(sum_transfer_time[4]/nargs) + "," + str(sum_stretch[4]/nargs) + "," + str(sum_stretch_with_min[4]/nargs)  + "\n")
# ~ output_data_bf.write("OPPORTUNISTIC-SCORE MIX"  + "," + str(sum_max_queue_time[5]/nargs) + "," + str(sum_total_flow[5]/nargs) + "," + str(sum_transfer_time[5]/nargs) + "," + str(sum_stretch[5]/nargs) + "," + str(sum_stretch_with_min[5]/nargs) + "\n")
# ~ output_data_bf.write("OPPORTUNISTIC-SCORE MIX CONSERVATIVE BF"  + "," + str(sum_max_queue_time[6]/nargs) + "," + str(sum_total_flow[6]/nargs) + "," + str(sum_transfer_time[6]/nargs) + "," + str(sum_stretch[6]/nargs) + "," + str(sum_stretch_with_min[6]/nargs)  +"\n")

print(sum_stretch)

# ~ # Mediane
# ~ if (int(sys.argv[2]) == 1):
	# ~ output_data_bf.write("EFT CONSERVATIVE BF" + "," + str(statistics.median(sum_max_queue_time[0])) + "," + str(statistics.median(sum_total_flow[0])) + "," + str(statistics.median(sum_transfer_time[0])) + "," + str(statistics.median(sum_stretch[0])) + "," + str(statistics.median(sum_stretch_with_min[0])) + "\n")
	# ~ output_data_bf.write("SCORE CONSERVATIVE BF"  + "," + str(statistics.median(sum_max_queue_time[1])) + "," + str(statistics.median(sum_total_flow[1])) + "," + str(statistics.median(sum_transfer_time[1])) + "," + str(statistics.median(sum_stretch[1])) + "," + str(statistics.median(sum_stretch_with_min[1]))  + "\n")
	# ~ output_data_bf.write("EFT-SCORE MIX CONSERVATIVE BF"  + "," + str(statistics.median(sum_max_queue_time[2])) + "," + str(statistics.median(sum_total_flow[2])) + "," + str(statistics.median(sum_transfer_time[2])) + "," + str(statistics.median(sum_stretch[2])) + "," + str(statistics.median(sum_stretch_with_min[2]))  + "\n")
	# ~ output_data_bf.write("OPPORTUNISTIC-SCORE MIX CONSERVATIVE BF"  + "," + str(statistics.median(sum_max_queue_time[3])) + "," + str(statistics.median(sum_total_flow[3])) + "," + str(statistics.median(sum_transfer_time[3])) + "," + str(statistics.median(sum_stretch[3])) + "," + str(statistics.median(sum_stretch_with_min[3]))  +"\n")
	# ~ output_data_bf.write("EFT-SCORE MIX CONSERVATIVE BF V2"  + "," + str(statistics.median(sum_max_queue_time[4])) + "," + str(statistics.median(sum_total_flow[4])) + "," + str(statistics.median(sum_transfer_time[4])) + "," + str(statistics.median(sum_stretch[4])) + "," + str(statistics.median(sum_stretch_with_min[4]))  + "\n")
# ~ else:
	# ~ output_data_bf.write("EFT" + "," + str(statistics.median(sum_max_queue_time[0])) + "," + str(statistics.median(sum_total_flow[0])) + "," + str(statistics.median(sum_transfer_time[0])) + "," + str(statistics.median(sum_stretch[0])) + "," + str(statistics.median(sum_stretch_with_min[0])) + "\n")
	# ~ output_data_bf.write("SCORE"  + "," + str(statistics.median(sum_max_queue_time[1])) + "," + str(statistics.median(sum_total_flow[1])) + "," + str(statistics.median(sum_transfer_time[1])) + "," + str(statistics.median(sum_stretch[1])) + "," + str(statistics.median(sum_stretch_with_min[1])) + "\n")
	# ~ output_data_bf.write("EFT-SCORE MIX"  + "," + str(statistics.median(sum_max_queue_time[2])) + "," + str(statistics.median(sum_total_flow[2])) + "," + str(statistics.median(sum_transfer_time[2])) + "," + str(statistics.median(sum_stretch[2])) + "," + str(statistics.median(sum_stretch_with_min[2]))  + "\n")
	# ~ output_data_bf.write("OPPORTUNISTIC-SCORE MIX"  + "," + str(statistics.median(sum_max_queue_time[3])) + "," + str(statistics.median(sum_total_flow[3])) + "," + str(statistics.median(sum_transfer_time[3])) + "," + str(statistics.median(sum_stretch[3])) + "," + str(statistics.median(sum_stretch_with_min[3])) + "\n")
	# ~ output_data_bf.write("EFT-SCORE MIX V2"  + "," + str(statistics.median(sum_max_queue_time[4])) + "," + str(statistics.median(sum_total_flow[4])) + "," + str(statistics.median(sum_transfer_time[4])) + "," + str(statistics.median(sum_stretch[4])) + "," + str(statistics.median(sum_stretch_with_min[4]))  + "\n")
# Moyenne
if (int(sys.argv[2]) == 1):
	output_data_bf.write("EFT CONSERVATIVE BF" + "," + str(statistics.mean(sum_max_queue_time[0])) + "," + str(statistics.mean(sum_total_flow[0])) + "," + str(statistics.mean(sum_transfer_time[0])) + "," + str(statistics.mean(sum_stretch[0])) + "," + str(statistics.mean(sum_stretch_with_min[0])) + "\n")
	output_data_bf.write("SCORE CONSERVATIVE BF"  + "," + str(statistics.mean(sum_max_queue_time[1])) + "," + str(statistics.mean(sum_total_flow[1])) + "," + str(statistics.mean(sum_transfer_time[1])) + "," + str(statistics.mean(sum_stretch[1])) + "," + str(statistics.mean(sum_stretch_with_min[1]))  + "\n")
	output_data_bf.write("EFT-SCORE MIX CONSERVATIVE BF"  + "," + str(statistics.mean(sum_max_queue_time[2])) + "," + str(statistics.mean(sum_total_flow[2])) + "," + str(statistics.mean(sum_transfer_time[2])) + "," + str(statistics.mean(sum_stretch[2])) + "," + str(statistics.mean(sum_stretch_with_min[2]))  + "\n")
	output_data_bf.write("OPPORTUNISTIC-SCORE MIX CONSERVATIVE BF"  + "," + str(statistics.mean(sum_max_queue_time[3])) + "," + str(statistics.mean(sum_total_flow[3])) + "," + str(statistics.mean(sum_transfer_time[3])) + "," + str(statistics.mean(sum_stretch[3])) + "," + str(statistics.mean(sum_stretch_with_min[3]))  +"\n")
	output_data_bf.write("EFT-SCORE MIX CONSERVATIVE BF V2"  + "," + str(statistics.mean(sum_max_queue_time[4])) + "," + str(statistics.mean(sum_total_flow[4])) + "," + str(statistics.mean(sum_transfer_time[4])) + "," + str(statistics.mean(sum_stretch[4])) + "," + str(statistics.mean(sum_stretch_with_min[4]))  + "\n")
else:
	output_data_bf.write("EFT" + "," + str(statistics.mean(sum_max_queue_time[0])) + "," + str(statistics.mean(sum_total_flow[0])) + "," + str(statistics.mean(sum_transfer_time[0])) + "," + str(statistics.mean(sum_stretch[0])) + "," + str(statistics.mean(sum_stretch_with_min[0])) + "\n")
	output_data_bf.write("SCORE"  + "," + str(statistics.mean(sum_max_queue_time[1])) + "," + str(statistics.mean(sum_total_flow[1])) + "," + str(statistics.mean(sum_transfer_time[1])) + "," + str(statistics.mean(sum_stretch[1])) + "," + str(statistics.mean(sum_stretch_with_min[1])) + "\n")
	output_data_bf.write("EFT-SCORE MIX"  + "," + str(statistics.mean(sum_max_queue_time[2])) + "," + str(statistics.mean(sum_total_flow[2])) + "," + str(statistics.mean(sum_transfer_time[2])) + "," + str(statistics.mean(sum_stretch[2])) + "," + str(statistics.mean(sum_stretch_with_min[2]))  + "\n")
	output_data_bf.write("OPPORTUNISTIC-SCORE MIX"  + "," + str(statistics.mean(sum_max_queue_time[3])) + "," + str(statistics.mean(sum_total_flow[3])) + "," + str(statistics.mean(sum_transfer_time[3])) + "," + str(statistics.mean(sum_stretch[3])) + "," + str(statistics.mean(sum_stretch_with_min[3])) + "\n")
	output_data_bf.write("EFT-SCORE MIX V2"  + "," + str(statistics.mean(sum_max_queue_time[4])) + "," + str(statistics.mean(sum_total_flow[4])) + "," + str(statistics.mean(sum_transfer_time[4])) + "," + str(statistics.mean(sum_stretch[4])) + "," + str(statistics.mean(sum_stretch_with_min[4]))  + "\n")
