# pour faire la courbe d'usage du cluster en fonction du workload 

import matplotlib.pyplot as plt
import pandas as pd
import sys
from collections import Counter

# ~ data = pd.read_csv(sys.argv[1])
workload = sys.argv[2]
cluster = sys.argv[3]
scheduler = sys.argv[4]
title = workload + "_" + scheduler + "_" + "used_nodes" + "_" + cluster

# Init plot
plot_title = "Used nodes" + " " + scheduler
Y_label = "Number of nodes used"
if (cluster == "4nodes"):
	line = 4
elif (cluster == "41_128_3_256_1_1024"):
	line = 45
elif (cluster == "95_128_4_256_1_1024"):
	line = 100
elif (cluster == "182_128_16_256_2_1024"):
	line = 200
elif (cluster == "450_128_32_256_4_1024"):
	line = 486
else:
	print("error")
	exit(1)
plt.axhline(y = line, color = 'black', linestyle = '-', label = "Total number of nodes")
plt.gca().set_ylim(bottom=0)

# Compute usage for each workload
node_used_workload_minus_2 = []
node_used_workload_minus_1 = []
node_used_workload_0 = []
node_used_workload_1 = []
node_used_workload_2 = []
node_used_workload_total = []
t = 0
f2 = open("outputs/Nodes_usage.csv", "w")

while t != 11001: # ?
	with open("outputs/Results_for_cluster_usage.txt") as f:
		line = f.readline()
		while line:
			# ~ print(line)
			r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14 = line.split() # Split it by whitespace
		
			if (int(r8) == t):
				if (int(r14) == -2):
					node_used_workload_minus_2.append(int(r2))
				elif (int(r14) == -1):
					node_used_workload_minus_1.append(int(r2))
				elif (int(r14) == 0):
					node_used_workload_0.append(int(r2))
				elif (int(r14) == 1):
					node_used_workload_1.append(int(r2))
				elif (int(r14) == 2):
					node_used_workload_2.append(int(r2))
				# ~ print("Add %d" % int(r2))
				node_used_workload_total.append(int(r2))
			
			if (int(r11) == t):
				if (int(r14) == -2):
					node_used_workload_minus_2.remove(int(r2))
				elif (int(r14) == -1):
					node_used_workload_minus_1.remove(int(r2))
				elif (int(r14) == 0):
					node_used_workload_0.remove(int(r2))
				elif (int(r14) == 1):
					node_used_workload_1.remove(int(r2))
				elif (int(r14) == 2):
					node_used_workload_2.remove(int(r2))
				# ~ print("Remove %d" % int(r2))
				node_used_workload_total.remove(int(r2))
			
			counter_object_minus_2 = Counter(node_used_workload_minus_2)
			keys_minus_2 = counter_object_minus_2.keys()
			num_values_minus_2 = len(keys_minus_2)
			
			counter_object_minus_1 = Counter(node_used_workload_minus_1)
			keys_minus_1 = counter_object_minus_1.keys()
			num_values_minus_1 = len(keys_minus_1)
			
			counter_object_0 = Counter(node_used_workload_0)
			keys_0 = counter_object_0.keys()
			num_values_0 = len(keys_0)
			
			counter_object_1 = Counter(node_used_workload_1)
			keys_1 = counter_object_1.keys()
			num_values_1 = len(keys_1)
			
			counter_object_2 = Counter(node_used_workload_2)
			keys_2 = counter_object_2.keys()
			num_values_2 = len(keys_2)
			
			counter_object_total = Counter(node_used_workload_total)
			keys_total = counter_object_total.keys()
			num_values_total = len(keys_total)
			
			f2.write("%d,%d,%d,%d,%d,%d\n" % (num_values_minus_2, num_values_minus_1, num_values_0, num_values_1, num_values_2, num_values_total));
			
			line = f.readline()	
		t += 1
f.close


f2.close
# ~ exit

data = pd.read_csv("outputs/Nodes_usage.csv")

df = pd.DataFrame(data)
 
# ~ Y_index = 0

Y1 = list(df.iloc[:, 0])
Y2 = list(df.iloc[:, 1])
Y3 = list(df.iloc[:, 2])
Y4 = list(df.iloc[:, 3])
Y5 = list(df.iloc[:, 4])
Y6 = list(df.iloc[:, 5])

# ~ plt.axvline(x = first_job_day_1, color = 'orange', linestyle = '-', label = "Submission time first job day 1")
# ~ plt.axvline(x = first_job_day_2, color = 'red', linestyle = '-', label = "Submission time first job day 2 and beyond")

plt.plot(Y1)
plt.plot(Y2)
plt.plot(Y3)
plt.plot(Y4)
plt.plot(Y5)
plt.plot(Y6)
plt.title(plot_title)
plt.xlabel("Time in seconds")
plt.ylabel(Y_label)

filename = "plot/" + title + ".pdf"

plt.savefig(filename)
