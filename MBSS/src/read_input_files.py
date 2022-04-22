# Imports
from dataclasses import dataclass
@dataclass
class Job:
    unique_id: int
    subtime: int
    delay: int
    walltime: int
    cores: int
    data: int
    data_size: int
    start_time: int
    end_time: int
    end_before_walltime: bool
    cores_used: list
@dataclass
class Node:
    unique_id: int
    memory: int
    bandwidth: float
    data: list
    cores: list
@dataclass
class Core:
    unique_id: int
    job_queue: list
    available_time: int

def read_cluster(input_node_file, node_list, available_node_list):
	with open(input_node_file) as f:
		line = f.readline()
		while line:
			r1, r2, r3, r4, r5, r6, r7, r8, r9, r10 = line.split()
			core_list = []
			for i in range (0, int(r9)):
				c = Core(i, list(), 0)
				core_list.append(c)
			n = Node(int(r3), int(r5), float(r7), list(), core_list)
			node_list.append(n)
			available_node_list.append(n)
			line = f.readline()
		f.close
	return node_list, available_node_list

def read_workload(input_job_file, job_list):
	with open(input_job_file) as f:
		line = f.readline()
		while line:
			r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18 = line.split() # split it by whitespace
			j = Job(int(r3), int(r5), int(r7), int(r9), int(r11), int(r15), int(r17), 0, 0, False, list())
			# Adding data in the list of data of the job
			# ~ i = 1
			# ~ while (i < len(str(r13))):
				# ~ c = ""
				# ~ while (str(r13)[i] != "," and str(r13)[i] != "]"):
					# ~ c += str(r13)[i]
					# ~ i += 1
				# ~ i += 1
				# ~ if (c != ""):
					# ~ j.data.append(int(c))
			# ~ # Adding data sizes
			# ~ i = 1
			# ~ while (i < len(str(r15))):
				# ~ c = ""
				# ~ while (str(r15)[i] != "," and str(r15)[i] != "]"):
					# ~ c += str(r15)[i]
					# ~ i += 1
				# ~ i += 1
				# ~ if (c != ""):
					# ~ j.data_sizes.append(int(c))
			job_list.append(j)
			line = f.readline()	
		f.close
	return job_list
