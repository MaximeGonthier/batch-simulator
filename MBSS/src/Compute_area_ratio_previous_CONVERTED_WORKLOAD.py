# The commented code just got area ratio from previous CONVERTED_WORKLOAD of each job size.
# The new code also compute the area each job can use in other sizes like described in Area filling.
# Usage: python3 src/Compute_area_ratio_previous_CONVERTED_WORKLOAD.py CONVERTED_WORKLOAD CLUSTER CONVERTED_WORKLOAD_7_DAYS_LATER (optional)
# Attention je considère qu'on a que 3 tailles de nodes par défaut. Ajouter cela à la lecture du cluster si besoin.
# Si l'option 7_days_earlier_ n'est pas vide alors je renomme avec 7 jours de plus dans le nom du workload et avec 7_days_earlier_ pour indiquer au code C que c'est ca pour le non omnisicnet
# Imports
import sys

# ~ planned = int(sys.argv[3]) # I do both at once now
# Inputs
input_job_file = sys.argv[1]
# get number of nodes of each type
K_1 = 0
K_2 = 0
K_3 = 0
with open(sys.argv[2], 'r') as fp:
	for count, line in enumerate(fp):
		r1, r2, r3, r4, r5, r6, r7, r8, r9, r10 = line.split()
		if int(r5) == 128:
			K_1 += 1
		elif int(r5) == 256:
			K_2 += 1
		elif int(r5) == 1024:
			K_3 += 1
		else:
			print("Error size memory not dealed with must be 128; 256 or 1024")
			exit(1)
K = K_1 + K_2 + K_3 # Total number of nodes
fp.close
Nb_different_node_size = 3

print("K_1 =", K_1)
print("K_2 =", K_2)
print("K_3 =", K_3)
print("K =", K)

Area_Jobs = [0, 0, 0]
Area_Jobset = 0
with open(input_job_file) as f:
	
	line = f.readline()
	while line:
		r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21, r22, r23, r24 = line.split() # split it by whitespace
			
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
						
		Area_Jobs[index_node] += int(r11) * int(r9)
		Area_Jobset += int(r11) * int(r9)
		line = f.readline()	
f.close

print("Area_Jobs[M_1] =", Area_Jobs[0])
print("Area_Jobs[M_2] =", Area_Jobs[1])
print("Area_Jobs[M_3] =", Area_Jobs[2])
print("Area_Jobset =", Area_Jobset)
# ~ exit(1)

Tmax = max(Area_Jobs[2]/K_3, (Area_Jobs[2] + Area_Jobs[1])/(K_3 + K_2), Area_Jobset/K)
print("Tmax =", Tmax)

# For M_3
Planned_Area_3 = [0, 0, Area_Jobs[2]]
Ratio_Area_3 = [0, 0, Area_Jobs[2]/Tmax]
Remaining_Area_3 = Tmax*K_3
Remaining_Area_3 = Remaining_Area_3 - Area_Jobs[2]
Area_Jobs[2] = 0
y = 2 - 1
print("Remaining_Area_3 =", Remaining_Area_3)
while Remaining_Area_3 > 0 and y >= 0:
	area_to_use = min(Remaining_Area_3, Area_Jobs[y])
	print("area_to_use for M_3 =", area_to_use)
	Remaining_Area_3 = Remaining_Area_3 - area_to_use
	Planned_Area_3[y] = area_to_use
	Ratio_Area_3[y] = area_to_use/Tmax
	Area_Jobs[y] = Area_Jobs[y] - area_to_use
	y = y - 1
	
# For M_2
Planned_Area_2 = [0, Area_Jobs[1], 0]
Ratio_Area_2 = [0, Area_Jobs[1]/Tmax, 0]
Remaining_Area_2 = Tmax*K_2
Remaining_Area_2 = Remaining_Area_2 - Area_Jobs[1]
Area_Jobs[1] = 0
y = 1 - 1
print("Remaining_Area_2 =", Remaining_Area_2)
while Remaining_Area_2 > 0 and y >= 0:
	area_to_use = min(Remaining_Area_2, Area_Jobs[y])
	print("area_to_use for M_2 =", area_to_use)
	Remaining_Area_2 = Remaining_Area_2 - area_to_use
	Planned_Area_2[y] = area_to_use
	Ratio_Area_2[y] = area_to_use/Tmax
	Area_Jobs[y] = Area_Jobs[y] - area_to_use
	y = y - 1
	
# For M_1
Planned_Area_1 = [Area_Jobs[0], 0, 0]
Ratio_Area_1 = [Area_Jobs[0]/Tmax, 0, 0]

# ~ if planned == 1:
print("Planned_Area_3 =", Planned_Area_3)
print("Planned_Area_2 =", Planned_Area_2)
print("Planned_Area_1 =", Planned_Area_1)
# ~ else:
print("Ratio_Area_3 =", Ratio_Area_3)
print("Ratio_Area_2 =", Ratio_Area_2)
print("Ratio_Area_1 =", Ratio_Area_1)

if len(sys.argv) == 4: # Cas non omnisicnet
	file_to_open1 = "inputs/Planned_Ratio_areas/Ratio_area_" + sys.argv[3][27:] + "_7_days_earlier_" + sys.argv[2][24:]
	file_to_open2 = "inputs/Planned_Ratio_areas/Planned_area_" + sys.argv[3][27:] + "_7_days_earlier_" + sys.argv[2][24:]
else:
	file_to_open1 = "inputs/Planned_Ratio_areas/Ratio_area_" + sys.argv[1][27:] + "_" + sys.argv[2][24:]
	file_to_open2 = "inputs/Planned_Ratio_areas/Planned_area_" + sys.argv[1][27:] + "_" + sys.argv[2][24:]

f1 = open(file_to_open1, "w")
f2 = open(file_to_open2, "w")
print("Opening files ", file_to_open1, "and", file_to_open2)

f2.write("Planned_Area_1: %s %s %s\n" % (Planned_Area_1[0], Planned_Area_1[1], Planned_Area_1[2]))
f2.write("Planned_Area_2: %s %s %s\n" % (Planned_Area_2[0], Planned_Area_2[1], Planned_Area_2[2]))
f2.write("Planned_Area_3: %s %s %s\n" % (Planned_Area_3[0], Planned_Area_3[1], Planned_Area_3[2]))
f1.write("Ratio_Area_1: %s %s %s\n" % (Ratio_Area_1[0], Ratio_Area_1[1], Ratio_Area_1[2]))
f1.write("Ratio_Area_2: %s %s %s\n" % (Ratio_Area_2[0], Ratio_Area_2[1], Ratio_Area_2[2]))
f1.write("Ratio_Area_3: %s %s %s\n" % (Ratio_Area_3[0], Ratio_Area_3[1], Ratio_Area_3[2]))

f1.close
f2.close
