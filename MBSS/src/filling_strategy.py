# Shift every job on the first available time slot on the same cores
def ShiftLeft(node_list, t):
	print("Shifting...")
	for n in node_list:
		for c in n.cores:
			for j in c.job_queue:
				if j.start_time > c.available_time: # Mean we can shift left
					print("Start time", j.start_time, "of", j.unique_id, "is superior to avail time", c.available_time, "of core", c.unique_id, "node", n.unique_id)
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
						# ~ j.end_time = j.end_time - j.start_time + max_avail
						j.end_time = j.end_time - (j.start_time - max_avail)
						j.start_time = max_avail
						print ("Job", j.unique_id, "will now start at time", j.start_time, "and end at time", j.end_time)
					for c3 in j.cores_used:
						c3.available_time = j.start_time + j.walltime	
							
def BackFill(cores, job, node_list):
	print("BackFilling...")
