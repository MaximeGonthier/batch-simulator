import sys
import csv

# ~ percentage of reduction = ((v1-v2)/(-v2))*100 avec v2 valeur de fcfs

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
    if eftline:
        eftline = False
        continue
    
    # ~ if pair:
	    # ~ pair = False
	    # ~ output_data.write(row[0] + "," + str(((float(row[2])-max_queue_fcfs)/(max_queue_fcfs))*100) + "," + str(((float(row[7])-total_flow_fcfs)/(total_flow_fcfs))*100) + "," + str(((float(row[12])-transfer_time_fcfs)/(transfer_time_fcfs))*100) + "," + str(((float(row[13])-stretch_fcfs)/(stretch_fcfs))*100) + "," + str(((float(row[14])-stretch_with_a_min_fcfs)/(stretch_with_a_min_fcfs))*100) + "\n")
    # ~ else:
	    # ~ pair = True
    output_data_bf.write(row[0] + "," + str(((float(row[2])-max_queue_fcfsbf)/(max_queue_fcfsbf))*100) + "," + str(((float(row[7])-total_flow_fcfsbf)/(total_flow_fcfsbf))*100) + "," + str(((float(row[12])-transfer_time_fcfsbf)/(transfer_time_fcfsbf))*100) + "," + str(((float(row[13])-stretch_fcfsbf)/(stretch_fcfsbf))*100) + "," + str(((float(row[14])-stretch_with_a_min_fcfsbf)/(stretch_with_a_min_fcfsbf))*100) + "\n")

    #print("fcfs max queue is" + max_queue_fcfs + "and bf is" + max_queue_fcfsbf)
    # ~ max_queue = row[2]
    #print(max_queue + " | ")
    # ~ total_flow= row[7]
    #print(total_flow + " | ")
    # ~ transfer_time = row[12]
    #print(transfer_time + " | ")
    # ~ stretch = row[13]
    #print(stretch + " | ")
    # ~ stretch_with_a_min = row[14]
    #print(stretch_with_a_min)



# f = open(input_data, 'r')
# line = f.readline()
# ~ output_data.write(line)

# ~ FCFS,8693,10259.000000,335.047058,2912564.000000,614422.000000,6916.390625,60124184.000000,1120704.000000,6657248.000000,441400128.000000,567637.000000,1688341.000000,1.471702,1.458031,8.360000,7.983662,0,0,1.465915,0.002528,0.003260,1.452244,0.002528,0.003260,6285

# line = f.readline()
# ~ r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21, r22, r23, r24, r25, r26, r27 = line.split() # split it by whitespace

# ~ print(r1, r2, r3);

# ~ total_flow_fcfs_conservative_bf =

# while line:
	
	# ~ output_data.write("%s,%f,%f,%f,%f\n");
	
	# line = f.readline()	
	
# f.close

# ~ print("Area_Jobs[M_1] =", Area_Jobs[0])
# ~ print("Area_Jobs[M_2] =", Area_Jobs[1])
# ~ print("Area_Jobs[M_3] =", Area_Jobs[2])
# ~ print("Area_Jobset =", Area_Jobset)
# ~ exit(1)

# ~ Tmax = max(Area_Jobs[2]/K_3, (Area_Jobs[2] + Area_Jobs[1])/(K_3 + K_2), Area_Jobset/K)
# ~ print("Tmax =", Tmax)

# ~ # For M_3
# ~ Planned_Area_3 = [0, 0, Area_Jobs[2]]
# ~ Ratio_Area_3 = [0, 0, Area_Jobs[2]/Tmax]
# ~ Remaining_Area_3 = Tmax*K_3
# ~ Remaining_Area_3 = Remaining_Area_3 - Area_Jobs[2]
# ~ Area_Jobs[2] = 0
# ~ y = 2 - 1
# ~ print("Remaining_Area_3 =", Remaining_Area_3)
# ~ while Remaining_Area_3 > 0 and y >= 0:
	# ~ area_to_use = min(Remaining_Area_3, Area_Jobs[y])
	# ~ print("area_to_use for M_3 =", area_to_use)
	# ~ Remaining_Area_3 = Remaining_Area_3 - area_to_use
	# ~ Planned_Area_3[y] = area_to_use
	# ~ Ratio_Area_3[y] = area_to_use/Tmax
	# ~ Area_Jobs[y] = Area_Jobs[y] - area_to_use
	# ~ y = y - 1
	
# ~ # For M_2
# ~ Planned_Area_2 = [0, Area_Jobs[1], 0]
# ~ Ratio_Area_2 = [0, Area_Jobs[1]/Tmax, 0]
# ~ Remaining_Area_2 = Tmax*K_2
# ~ Remaining_Area_2 = Remaining_Area_2 - Area_Jobs[1]
# ~ Area_Jobs[1] = 0
# ~ y = 1 - 1
# ~ print("Remaining_Area_2 =", Remaining_Area_2)
# ~ while Remaining_Area_2 > 0 and y >= 0:
	# ~ area_to_use = min(Remaining_Area_2, Area_Jobs[y])
	# ~ print("area_to_use for M_2 =", area_to_use)
	# ~ Remaining_Area_2 = Remaining_Area_2 - area_to_use
	# ~ Planned_Area_2[y] = area_to_use
	# ~ Ratio_Area_2[y] = area_to_use/Tmax
	# ~ Area_Jobs[y] = Area_Jobs[y] - area_to_use
	# ~ y = y - 1
	
# ~ # For M_1
# ~ Planned_Area_1 = [Area_Jobs[0], 0, 0]
# ~ Ratio_Area_1 = [Area_Jobs[0]/Tmax, 0, 0]

