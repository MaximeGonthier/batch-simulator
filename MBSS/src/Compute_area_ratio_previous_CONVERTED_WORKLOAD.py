# The commented code just got area ratio from previous CONVERTED_WORKLOAD of each job size.
# The new code also compute the area each job can use in other sizes like described in Area filling.
# Usage: python3 src/Compute_area_ratio_previous_CONVERTED_WORKLOAD.py CONVERTED_WORKLOAD CLUSTER
# Attention je considère qu'on a que 3 tailles de nodes par défaut. Ajouter cela à la lecture du cluster si besoin.

# NEW
# Imports
import sys

# Inputs
input_job_file = sys.argv[1]
# get number of nodes of each type
k_1 = 0
k_2 = 0
k_3 = 0
with open(sys.argv[2], 'r') as fp:
	for count, line in enumerate(fp):
		# ~ print(line)
		r1, r2, r3, r4, r5, r6, r7, r8, r9, r10 = line.split()
		if int(r5) == 128:
			k_1 += 1
		elif int(r5) == 256:
			k_2 += 1
		elif int(r5) == 1024:
			k_3 += 1
		else:
			print("Error size memory not dealed with must be 128; 256 or 1024")
			exit(1)
K = k_1 + k_2 + k_3 # Total number of nodes
fp.close
Nb_different_node_size = 3

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


# ~ f.write("Area Jobs 1: %s\n" % (area_tab[0]))
# ~ f.write("Area Jobs 2: %s\n" % (area_tab[1]))
# ~ f.write("Area Jobs 3: %s\n" % (area_tab[2]))
# ~ f.write("Total area: %s\n" % (total_area))
Tmax = total_area/K
# ~ f.write("Tmax: %s\n" % (Tmax))
Area_1 = area_tab[0]/k_1
Area_2 = area_tab[1]/k_2
Area_3 = area_tab[2]/k_3

print("Total area:", total_area)
print("nb nodes:", K)
print("Tmax:", Tmax)
print("Area 1:", Area_1)
print("Area 2:", Area_2)
print("Area 3:", Area_3)


# ~ f.write("Area_1: %s\n" % (Area_1))
# ~ f.write("Area_2: %s\n" % (Area_2))
# ~ f.write("Area_3: %s\n" % (Area_3))

# Start with bigger one. -1 means infinite
if Area_3 < Tmax:
	if Area_3 + Area_2 <= Tmax:
		if Area_3 + Area_2 + Area_1 <= Tmax: # Can all fit on node of size 3
			Planned_Area_3 = [Area_1, Area_2, -1]
		else: # Only jobs 2 and 3 can all fit on node of size 3 and maybe a part of Area 1
			Planned_Area_3 = [max(0, Tmax - (Area_3 + Area_2)), Area_2, -1]
	else: # A part of area 2 can fit
		Planned_Area_3 = [0, max(0, Tmax - Area_3), -1]
else: # nothing else can fit
	Planned_Area_3 = [0, 0, -1]

# Start with bigger one. -1 means infinite
if Area_2 - Planned_Area_3[1] < Tmax:
	if Area_2 - Planned_Area_3[1] + Area_1 <= Tmax:
		Planned_Area_2 = [Area_1, -1, 0]
	else:
		Planned_Area_2 = [max(0, Tmax - (Area_2 - Planned_Area_3[1])), -1, 0]
else: # nothing else can fit
	Planned_Area_2 = [0, -1, 0]

Planned_Area_1 = [-1, 0, 0]

f.write("Planned_Area_1: %s %s %s\n" % (Planned_Area_1[0], Planned_Area_1[1], Planned_Area_1[2]))
f.write("Planned_Area_2: %s %s %s\n" % (Planned_Area_2[0], Planned_Area_2[1], Planned_Area_2[2]))
f.write("Planned_Area_3: %s %s %s\n" % (Planned_Area_3[0], Planned_Area_3[1], Planned_Area_3[2]))

f.close

# OLD
# ~ # Compute area ratio from previous CONVERTED_WORKLOADs for each node size and write it in a file.
# ~ # Usage: python3 src/Compute_area_ratio_previous_CONVERTED_WORKLOAD.py CONVERTED_WORKLOAD

# ~ # Imports
# ~ import sys

# ~ input_job_file = sys.argv[1]
# ~ area_tab = [0, 0, 0]
# ~ total_area = 0
# ~ with open(input_job_file) as f:
	
	# ~ line = f.readline()
	# ~ while line:
		# ~ r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20 = line.split() # split it by whitespace
			
		# ~ # Getting index of node_list depending on size if constraint is enabled
		# ~ if ((float(r17)*10)/(float(r11)*10) == 0.0):
			# ~ index_node = 0
		# ~ elif ((float(r17)*10)/(float(r11)*10) == 6.4):
			# ~ index_node = 0
		# ~ elif ((float(r17)*10)/(float(r11)*10) == 12.8):
			# ~ index_node = 1
		# ~ elif ((float(r17)*10)/(float(r11)*10) == 51.2):
			# ~ index_node = 2
		# ~ else:
			# ~ print("Error", (float(r17)*10)/(float(r11)*10), "is a wrong input job data size. Line is:", line)
			# ~ exit(1)
						
		# ~ area_tab[index_node] += int(r11) * int(r9)
		# ~ total_area += int(r11) * int(r9)
		# ~ line = f.readline()	
# ~ f.close

# ~ file_to_open = "inputs/file_size_requirement/Ratio_area_" + sys.argv[1][27:] + ".txt"
# ~ f = open(file_to_open, "w")
# ~ for i in range (0, 3):
	# ~ f.write("Ratio size %d: %s\n" % (i, area_tab[i]/total_area))
# ~ f.close
