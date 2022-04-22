# ~ from dataclasses import dataclass

# ~ @dataclass
# ~ class Core:
    # ~ unique_id: int
    # ~ job_queue: list
    # ~ available_time: int
    
def ShiftLeft(cores_used, job, job_list): # Job finished before end of walltime
	print("Shifting...")
	for c in cores_used: # Check if I can find jobs to shift
		# ~ print(c.unique_id)
		for j in c.job_queue:
			# ~ print(j.unique_id)
			if (j.cores_used[0].available_time == ):
				print("Cool")
	
def BackFill(cores, job, node_list):
	print("BackFilling...")
