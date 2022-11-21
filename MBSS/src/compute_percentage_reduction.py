import sys
import csv

# ~ percentage of reduction = valeur de fcfs/valeur a comparer

input_data = sys.argv[1]
output_data = open("data/Percentages_to_fcfs_" + sys.argv[2], "w")
output_data_bf = open("data/Percentages_to_fcfs_bf_" + sys.argv[2], "w")

firstline = True
fcfsline = True
fcfsbfline = True
pair = True
eftline = True
mycsv = csv.reader(open(input_data))
output_data.write("Scheduler, Maximum queue time, Total flow, Total transfer time, Stretch, Stretch with a minimum\n")
output_data_bf.write("Scheduler, Maximum queue time, Total flow, Total transfer time, Stretch, Stretch with a minimum\n")
for row in mycsv:
    # ~ print(row[1])
    if firstline:
        firstline = False
        continue
    if fcfsline:
        fcfsline = False
        max_queue_fcfs = float(row[2])
        total_flow_fcfs = float(row[7])
        transfer_time_fcfs = float(row[12])
        stretch_fcfs = float(row[13])
        stretch_with_a_min_fcfs = float(row[14])
        continue
    if fcfsbfline:
        fcfsbfline = False
        max_queue_fcfsbf = float(row[2])
        total_flow_fcfsbf = float(row[7])
        transfer_time_fcfsbf = float(row[12])
        stretch_fcfsbf = float(row[13])
        stretch_with_a_min_fcfsbf = float(row[14])
        continue
    # ~ if eftline:
        # ~ eftline = False
        # ~ continue
    
    if (max_queue_fcfs == 0):
	    max_queue_fcfs = 1
    if (max_queue_fcfsbf == 0):
	    max_queue_fcfsbf = 1
    # ~ if (stretch_fcfs == 0):
	    # ~ stretch_fcfs = 1
    # ~ if (stretch_with_a_min_fcfs == 0):
	    # ~ stretch_with_a_min_fcfs = 1
    
    # ~ if pair:
    if (row[0] == "FCFS" or row[0] == "EFT" or row[0] == "SCORE" or  row[0] == "OPPORTUNISTIC-SCORE MIX" or row[0] == "EFT-SCORE MIX NON DYNAMIC TH100" or row[0] == "EFT-SCORE MIX DYNAMIC TH70" or row[0] == "EFT-SCORE MIX DYNAMIC TH100" or row[0] == "EFT-SCORE MIX NON DYNAMIC TH70"):
	    pair = False
	    output_data.write(row[0] + "," + str(((float(row[2])-max_queue_fcfs)/(max_queue_fcfs))*100) + "," + str(((float(row[7])-total_flow_fcfs)/(total_flow_fcfs))*100) + "," + str(((float(row[12])-transfer_time_fcfs)/(transfer_time_fcfs))*100) + "," + str(((float(row[13])-stretch_fcfs)/(stretch_fcfs))*100) + "," + str(((float(row[14])-stretch_with_a_min_fcfs)/(stretch_with_a_min_fcfs))*100) + "\n")
    else:
	    pair = True
	    output_data_bf.write(row[0] + "," + str(((float(row[2])-max_queue_fcfsbf)/(max_queue_fcfsbf))*100) + "," + str(((float(row[7])-total_flow_fcfsbf)/(total_flow_fcfsbf))*100) + "," + str(((float(row[12])-transfer_time_fcfsbf)/(transfer_time_fcfsbf))*100) + "," + str(((float(row[13])-stretch_fcfsbf)/(stretch_fcfsbf))*100) + "," + str(((float(row[14])-stretch_with_a_min_fcfsbf)/(stretch_with_a_min_fcfsbf))*100) + "\n")


