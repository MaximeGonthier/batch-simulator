# Compute area ratio from previous workloads for each node size and write it in a file.
# Usage: python3 src/Compute_area_ratio_previous_workload.py WORKLOAD

# Imports
import sys

input_job_file = sys.argv[1]
area_tab = [0, 0, 0]
total_area = 0
with open(input_job_file) as f:
	
	line = f.readline()
	while line:
		r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20 = line.split() # split it by whitespace
			
		# Getting index of node_list depending on size if constraint is enabled
		if ((float(r17)*10)/(float(r11)*10) == 0.0):
			index_node = 0
		elif ((float(r17)*10)/(float(r11)*10) == 6.4):
			index_node = 0
		elif ((float(r17)*10)/(float(r11)*10) == 12.8):
			index_node = 1
		elif ((float(r17)*10)/(float(r11)*10) == 51.2):
			index_node = 2
		else:
			print("Error", (float(r17)*10)/(float(r11)*10), "is a wrong input job data size. Line is:", line)
			exit(1)
						
		area_tab[index_node] += int(r11) * int(r9)
		total_area += int(r11) * int(r9)
		line = f.readline()	
f.close

file_to_open = "inputs/file_size_requirement/Ratio_area_" + sys.argv[1][27:] + ".txt"
f = open(file_to_open, "w")
for i in range (0, 3):
	# ~ to_write = "%.2f" % area_tab[i]/total_area
	f.write("Ratio size %d: %s\n" % (i, area_tab[i]/total_area))
# ~ f.write("Total area: %s\n" % total_area)
f.close
