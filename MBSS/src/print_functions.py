def print_decision_in_scheduler(choosen_core, j, choosen_node):
	core_ids = []
	for i in range (0, len(choosen_core)):
		core_ids.append(choosen_core[i].unique_id)
	core_ids.sort()
	print("Job", j.unique_id, "using file", j.data, "will be computed on node", choosen_node.unique_id, "core(s)", core_ids, "start at time", j.start_time, "and is predicted to finish at time", j.end_time)
	
def print_job_queue_in_cores_specific_node(node):
	print("Jobs on node", node.unique_id, "are: ", end = "")
	for c in node.cores:
		print("On core", c.unique_id, ": ", end = "")
		for j in c.job_queue:
			print(j.unique_id, " ", end = "")
	print("")
