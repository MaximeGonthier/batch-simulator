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
    data_size: float
    index_node_list: int
    start_time: int
    end_time: int
    end_before_walltime: bool
    node_used: None
    cores_used: list
    transfer_time: int
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
			# ~ node_list.append(n)
			# ~ available_node_list.append(n)
			if (int(r5) == 128):
				node_list[0].append(n)
				available_node_list[0].append(n)
			elif (int(r5) == 256):
				node_list[1].append(n)
				available_node_list[1].append(n)
			elif (int(r5) == 1024):
				node_list[2].append(n)
				available_node_list[2].append(n)
			else:
				print("Error, wrong input cluster memory size")
				exit
			line = f.readline()
		f.close
	return node_list, available_node_list

def read_workload(input_job_file, job_list):
	with open(input_job_file) as f:
		line = f.readline()
		while line:
			r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18 = line.split() # split it by whitespace
			
			# Getting index of node_list depending on size
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
				exit
			
			j = Job(int(r3), int(r5), int(r7), int(r9), int(r11), int(r15), float(r17), index_node, 0, 0, False, None, list(), 0)
			job_list.append(j)
			line = f.readline()	
		f.close
	return job_list
