from dataclasses import dataclass

# Global structs and input files
@dataclass
class Job:
    unique_id: int
    priority: int
    delay: float
    res: int
    data: str
    subtime: float
    walltime: float
@dataclass
class Node:
    unique_id: int
    memory: int
    bandwidth: float
    data: str
job_list = []
node_list = []
input_job_file = "inputs/workload_1.txt"
input_node_file = "inputs/cluster_1.txt"

#Random scheduler
def random_scheduler():
	for j in job_list:
		
	
#Main
with open(input_job_file) as f:
	line = f.readline()
	while line:
		r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16 = line.split() # split it by whitespace
		j = Job(int(r3), int(r5), float(r7), int(r9), str(r11), float(r13), float(r15))
		job_list.append(j)
		line = f.readline()
		
with open(input_node_file) as f:
	line = f.readline()
	while line:
		r1, r2, r3, r4, r5, r6, r7, r8, r9, r10 = line.split() # split it by whitespace
		n = Node(int(r3), int(r5), float(r7), str(r9))
		node_list.append(n)
		line = f.readline()

print("List of nodes :\n", node_list)
print("List of jobs :\n", job_list)

random_scheduler()
