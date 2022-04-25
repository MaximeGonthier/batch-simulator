# ~ from dataclasses import dataclass

# ~ @dataclass
# ~ class Core:
    # ~ unique_id: int
    # ~ job_queue: list
    # ~ available_time: int
    
def ShiftLeft(node_list, t): # Job finished before end of walltime
	print("Shifting...")
	for n in node_list:
		for c in n.cores:
			for j in c.job_queue:
				if j.start_time > c.available_time: #Mean we can shift left
					can_shift = True
					max_avail = -1
					for c2 in j.cores_used:
						if c2.available_time >= j.start_time:
							can_shift = False
							break
						else:
							if max_avail < c2.available_time:
								max_avail = c2.available_time
					if can_shift == True:
						j.end_time = j.end_time - j.start_time + max_avail
						j.start_time = max_avail
						print ("Job", j.unique_id, "will now start at time", j.start_time, "and end at time", j.end_time)
					for c3 in j.cores_used:
						c3.available_time = j.start_time + j.walltime	
	
	# ~ for c in cores_used: # Check if I can find jobs to shift
		# ~ for j in c.job_queue:
			# ~ can_shiftleft = True
			# ~ for c2 in j.cores_used:
				# ~ if (c2.available_time > t):
					# ~ can_shiftleft = False
					# ~ break
			# ~ if (can_shiftleft == True):
				# ~ j.end_time = j.end_time - j.start_time - t
	
def BackFill(cores, job, node_list):
	print("BackFilling...")
