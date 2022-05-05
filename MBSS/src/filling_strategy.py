from basic_functions import *
# ~ from main_multi_core import *

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

# Try to schedule immediatly in FCFS order without delaying first_job_in_queue
def easy_backfill_no_return2(first_job_in_queue, t, node_list, l):
	print("Début de Easy BackFilling...")
	# ~ job_to_remove = []
	# ~ print_job_info_from_list(available_job_list, t)
	
	# ~ tab = [0] * (len(node_list) + 1)
	# ~ print(tab[2])
	
	for j in l:
		if j != first_job_in_queue and j.start_time != t:
			print("Try to backfill", j.unique_id, "at time", t, "first job is", first_job_in_queue.unique_id)
			# ~ choosen_node = None
			# ~ nb_possible_cores = 0
			# ~ choosen_core = []
			if (j.index_node_list == 0): # Je peux choisir dans la liste entière
				nodes_to_choose_from = node_list[0] + node_list[1] + node_list[2]
			elif (j.index_node_list == 1): # Je peux choisir dans la 1 et la 2
				nodes_to_choose_from = node_list[1] + node_list[2]
			elif (j.index_node_list == 2): # Je peux choisir que dans la 2
				nodes_to_choose_from = node_list[2]
			for n in nodes_to_choose_from:
				choosen_node = None
				choosen_core = []
				nb_possible_cores = 0
				if n.n_available_cores >= j.cores: 
				# ~ print("len", len(node_list))
				# ~ if n.n_available_cores - tab[n.unique_id] >= j.cores: 
					print("On node", n.unique_id, "there are:", n.n_available_cores, "available cores and I use", j.cores) 
					# Need to make sure it won't delay first_job_in_queue
					# If it's the same node and the job is longer that start time of first_job_in_queue it might cause problems
					if (n == first_job_in_queue.node_used and t + j.walltime > first_job_in_queue.start_time):
						# Careful, you can't choose the same cores!
						# ~ print("same node")
						for c in n.cores:
							if c.available_time <= t and c not in first_job_in_queue.cores_used:
								nb_possible_cores += 1
						if (nb_possible_cores >= j.cores): # Ok you can!
							choosen_node = n
							# ~ print("node choosen is the same as first j")
							for c in choosen_node.cores:
								if c.available_time <= t and c not in first_job_in_queue.cores_used:
									choosen_core.append(c)
									
									# ~ if (j.unique_id == 19848 or j.unique_id == 20143 or j.unique_id == 21407):
										# ~ print("In bf same node at time", t, "Added on node", choosen_node.unique_id, "core", c.unique_id)
									
									c.job_queue.append(j)
									if (len(choosen_core) == j.cores):
										break										
					else: # You can choose any free core
						# ~ print("free node")
						choosen_node = n
						choosen_node.cores.sort(key = operator.attrgetter("available_time"))
						choosen_core = choosen_node.cores[0:j.cores]
						for c in choosen_core:
													
							c.job_queue.append(j)
							
							# Fix en carton
							# ~ c.available_time = t
							
					if choosen_node != None:
						start_time = get_start_time_and_update_avail_times_of_cores(t, choosen_core, j.walltime) 
						j.node_used = choosen_node
						j.cores_used = choosen_core
						j.start_time = start_time
						j.end_time = start_time + j.walltime	
						
						for c in choosen_core:
							for j2 in c.job_queue:
								if j != j2:
									j2.start_time = c.available_time
									j2.end_time = j2.start_time + j.walltime	
									c.available_time = j2.end_time
									
						# ~ choosen_node.n_available_cores -= j.cores
						# ~ tab[n.unique_id] += j.cores
												
						# ~ available_job_list.remove(j)
						# ~ job_to_remove.append(j)
						# ~ scheduled_job_list.append(j)
						print_decision_in_scheduler(choosen_core, j, choosen_node)
						start_jobs_single_job(t, j)
						# ~ print_job_info_from_list(available_job_list, t)
						break
	# ~ available_job_list = remove_jobs_from_list(available_job_list, job_to_remove)
	# ~ print("Fin de Easy BackFilling...")
	# ~ return scheduled_job_list

