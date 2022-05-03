# Shift every job on the first available time slot on the same cores
def ShiftLeft(affected_node_list, t):
	# ~ print("Shifting...")
	for n in affected_node_list:
		for c in n.cores:
			for j in c.job_queue:
				if j.start_time > c.available_time: # Mean we can shift left
					print("SHIFTING Start time", j.start_time, "of", j.unique_id, "is superior to avail time", c.available_time, "of core", c.unique_id, "node", n.unique_id)
					can_shift = True
					max_avail = -1
					for c2 in j.cores_used:
						
						# OLD
						if c2.available_time >= j.start_time:
						# ~ if c2.job_queue[0].end_time > t and c2.job_queue[0].unique_id != j.unique_id:
							can_shift = False
							print("Can't because of core", c2.unique_id, "avail time is", c2.available_time, "queue of size", len(c2.job_queue), "at time", t)
							break
						else:
							if max_avail < c2.available_time:
							# ~ if max_avail < c2.job_queue[0].end_time:
								# ~ max_avail = c2.job_queue[0].end_time
								max_avail = c2.available_time
						
						# ~ # NEW
						# ~ for j2 in c2.job_queue:
							# ~ if (j2.unique_id != j.unique_id):
								# ~ if t + j.walltime > j2.start_time:
									# ~ can_shift = False
									# ~ print("Can't because of core", c2.unique_id, "avail time is", c2.available_time, "queue of size", len(c2.job_queue), "at time", t, "j2 start at", j2.start_time)
									# ~ break
								# ~ else:
									# ~ if max_avail < c2.available_time:
										# ~ max_avail = c2.available_time
					if can_shift == True:
						# ~ j.end_time = j.end_time - (j.start_time - max_avail)
						j.start_time = max_avail
						j.end_time = j.start_time + j.walltime	
						print ("Job", j.unique_id, "will now start at time", j.start_time, "and end at time", j.end_time)
					for c3 in j.cores_used:
						c3.available_time = j.start_time + j.walltime
						
# Shift every job on the first available time slot on the same cores
def ShiftLeft2(affected_node_list, t):
	# ~ print("Shifting...")
	for n in affected_node_list:
		for c in n.cores:
			if (c.available_time <= t and c.job_queue):
				for j in c.job_queue:
					if j.start_time > c.available_time
			
			
			for j in c.job_queue:
				if j.start_time > c.available_time: # Mean we can shift left
					print("SHIFTING Start time", j.start_time, "of", j.unique_id, "is superior to avail time", c.available_time, "of core", c.unique_id, "node", n.unique_id)
					can_shift = True
					max_avail = -1
					for c2 in j.cores_used:
						
						# OLD
						if c2.available_time >= j.start_time:
						# ~ if c2.job_queue[0].end_time > t and c2.job_queue[0].unique_id != j.unique_id:
							can_shift = False
							print("Can't because of core", c2.unique_id, "avail time is", c2.available_time, "queue of size", len(c2.job_queue), "at time", t)
							break
						else:
							if max_avail < c2.available_time:
							# ~ if max_avail < c2.job_queue[0].end_time:
								# ~ max_avail = c2.job_queue[0].end_time
								max_avail = c2.available_time
						
						# ~ # NEW
						# ~ for j2 in c2.job_queue:
							# ~ if (j2.unique_id != j.unique_id):
								# ~ if t + j.walltime > j2.start_time:
									# ~ can_shift = False
									# ~ print("Can't because of core", c2.unique_id, "avail time is", c2.available_time, "queue of size", len(c2.job_queue), "at time", t, "j2 start at", j2.start_time)
									# ~ break
								# ~ else:
									# ~ if max_avail < c2.available_time:
										# ~ max_avail = c2.available_time
					if can_shift == True:
						# ~ j.end_time = j.end_time - (j.start_time - max_avail)
						j.start_time = max_avail
						j.end_time = j.start_time + j.walltime	
						print ("Job", j.unique_id, "will now start at time", j.start_time, "and end at time", j.end_time)
					for c3 in j.cores_used:
						c3.available_time = j.start_time + j.walltime
