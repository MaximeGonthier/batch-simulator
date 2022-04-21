# Imports
from dataclasses import dataclass
@dataclass
class Job:
    unique_id: int
    subtime: int
    delay: int
    walltime: int
    cores: int
    data: list
    data_sizes: list
    start_time: int
    end_time: int
    end_before_walltime: bool
@dataclass
class Node:
    unique_id: int
    memory: int
    bandwidth: int
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
			r1, r2, r3, r4, r5, r6, r7, r8 = line.split()
			core_list = []
			# ~ for i in range (0, 20):
			for i in range (0, 2):
				c = Core(i, list(), 0)
				core_list.append(c)
			n = Node(int(r3), int(r5), int(r7), list(), core_list)
			node_list.append(n)
			available_node_list.append(n)
			line = f.readline()
		f.close
	return node_list, available_node_list

def read_workload(input_job_file, job_list):
	with open(input_job_file) as f:
		line = f.readline()
		while line:
			r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16 = line.split() # split it by whitespace
			j = Job(int(r3), int(r5), int(r7), int(r9), int(r11), list(), list(), 0, 0, False)
			# Adding data in the list of data of the job
			i = 1
			while (i < len(str(r13))):
				c = ""
				while (str(r13)[i] != "," and str(r13)[i] != "]"):
					c += str(r13)[i]
					i += 1
				i += 1
				if (c != ""):
					j.data.append(int(c))
			# Adding data sizes
			i = 1
			while (i < len(str(r15))):
				c = ""
				while (str(r15)[i] != "," and str(r15)[i] != "]"):
					c += str(r15)[i]
					i += 1
				i += 1
				if (c != ""):
					j.data_sizes.append(int(c))
			job_list.append(j)
			line = f.readline()	
		f.close
	return job_list
