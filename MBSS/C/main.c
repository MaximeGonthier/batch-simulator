//~ #define PRINT
//~ #define PRINT_GANTT_CHART
//~ #define PRINT_DISTRIBUTION_QUEUE_TIMES
//~ #define PRINT_CLUSTER_USAGE
#include <main.h>

//~ from read_input_files import *
//~ from print_functions import *
//~ from basic_functions import *
//~ from scheduler import *
//~ from filling_strategy import *
//~ write_all_jobs = int(sys.argv[4]) # 1 for gantt charts, 2 for distribution of queue times, 3 for cluster usage

void main(int argc, char *argv[])
{
	/* Init global variables */
	finished_jobs = 0;
	total_number_jobs = 0;
	running_cores = 0;
	running_nodes = 0;
	nb_job_to_evaluate_finished = 0;
	total_queue_time = 0;

	
	char* input_job_file = argv[1];
	char* input_node_file = argv[2];
	char* scheduler = argv[3];
	constraint_on_sizes = atoi(argv[4]); /* To add or remove the constraint that some jobs can't be executed on certain nodes. 0 for no constraint, 1 for constraint, 2 for constraint but we don't consider transfer time. */
	
	#ifdef PRINT
	printf("Workloads: %s\n", input_job_file);
	printf("Cluster: %s\n", input_node_file);
	printf("Scheduler: %s\n", scheduler);
	printf("Size constraint: %d\n", constraint_on_sizes);
	#endif	
	
	/* Read cluster */
	read_cluster(input_node_file);
	printf("Read cluster done!\n");
	#ifdef PRINT
	print_node_list(node_list);
	#endif
	
	/* Read workload */
	read_workload(input_job_file, constraint_on_sizes);
	int nb_job_to_evaluate = get_nb_job_to_evaluate(job_list->head);
	int first_subtime_day_0 = get_first_time_day_0(job_list->head);
	#ifdef PRINT
	printf("\nNumber of jobs to evaluate: %d\n", nb_job_to_evaluate);
	printf("First time day 0: %d\n", first_subtime_day_0);
	printf("Number of nodes: %d\n", total_number_nodes);
	printf("\nJobs to start before:\n");
	print_job_list(job_list_to_start_from_history->head);
	printf("\nJobs for simulation:\n");
	print_job_list(job_list->head);
	#endif
	#ifdef PRINT_CLUSTER_USAGE
	write_in_file_first_times_all_day(job_list->head, first_subtime_day_0);
	#endif

	bool new_job = false;
	int next_submit_time = first_subtime_day_0;
	int t = first_subtime_day_0;
	next_end_time = t;
	
	//~ struct Job a = malloc(sizeof(struct Job));

	/* First start jobs from rackham's history. First need to sort it by start time */
	get_state_before_day_0_scheduler(job_list_to_start_from_history->head, node_list, t);
	printf("\nScheduled job list after starting jobs from history.\n");
	print_job_list(scheduled_job_list->head);
	//~ print_job_list(scheduled_job_list->tail->next);
	
	start_jobs(t, scheduled_job_list->head);
	//~ scheduled_job_list, running_jobs, end_times, running_cores, running_nodes, total_queue_time, available_job_list = start_jobs(t, scheduled_job_list, running_jobs, end_times, running_cores, running_nodes, total_queue_time, available_job_list)

//~ # TODO: delete, just for stats
//~ f_fcfs_score = open("outputs/Scores_data.txt", "w")
//~ f_fcfs_score.close()


	/* TODO : use next start and end time to trigger start jobs and end jobs */

	return;
}

//~ # Try to schedule immediatly in FCFS order without delaying first_job_in_queue
//~ def easy_backfill_no_return(first_job_in_queue, t, node_list, l):
	//~ # ~ print("Début de Easy BackFilling...")
	//~ # ~ job_to_remove = []
	//~ # ~ print_job_info_from_list(available_job_list, t)
	
	//~ # ~ tab = [0] * (len(node_list) + 1)
	//~ # ~ i = 0
	//~ # ~ for n in node_list[0] + node_list[1] + node_list[2]:
		//~ # ~ tab[i] = n.n_available_cores
		//~ # ~ for c in n:
			//~ # ~ for j in c.job_queue:
				//~ # ~ if 
		//~ # ~ i += 1
	//~ # ~ print(tab[2])
	
	//~ for j in l:
		//~ if j != first_job_in_queue and j.start_time != t:
			//~ if __debug__:
				//~ print("Try to backfill", j.unique_id, "at time", t, "first job is", first_job_in_queue.unique_id)
			//~ # ~ choosen_node = None
			//~ # ~ nb_possible_cores = 0
			//~ # ~ choosen_core = []
			//~ if (j.index_node_list == 0): # Je peux choisir dans la liste entière
				//~ nodes_to_choose_from = node_list[0] + node_list[1] + node_list[2]
			//~ elif (j.index_node_list == 1): # Je peux choisir dans la 1 et la 2
				//~ nodes_to_choose_from = node_list[1] + node_list[2]
			//~ elif (j.index_node_list == 2): # Je peux choisir que dans la 2
				//~ nodes_to_choose_from = node_list[2]
			//~ for n in nodes_to_choose_from:
				//~ choosen_node = None
				//~ choosen_core = []
				//~ # ~ nb_possible_cores = 0

				//~ # OLD
				//~ # ~ nb = nb_available_cores(n, t)
				//~ # ~ if nb >= j.cores: 
					//~ # ~ print("On node", n.unique_id, "there are:", nb, "available cores and I use", j.cores) 
					//~ # ~ # Need to make sure it won't delay first_job_in_queue
					//~ # ~ # If it's the same node and the job is longer that start time of first_job_in_queue it might cause problems
					//~ # ~ if (n == first_job_in_queue.node_used and t + j.walltime > first_job_in_queue.start_time):
						//~ # ~ # Careful, you can't choose the same cores!
						//~ # ~ for c in n.cores:
							//~ # ~ if c.available_time <= t and c not in first_job_in_queue.cores_used:
								//~ # ~ nb_possible_cores += 1
						//~ # ~ if (nb_possible_cores >= j.cores): # Ok you can!
							//~ # ~ choosen_node = n
							
							//~ # ~ for c in choosen_node.cores:
								//~ # ~ if c.available_time <= t and c not in first_job_in_queue.cores_used:
									//~ # ~ choosen_core.append(c)
									
									
									//~ # ~ c.job_queue.append(j)
									//~ # ~ if (len(choosen_core) == j.cores):
										//~ # ~ break
														
					//~ # ~ else: # You can choose any free core
						//~ # ~ choosen_node = n
						//~ # ~ choosen_node.cores.sort(key = operator.attrgetter("available_time"))
						//~ # ~ choosen_core = choosen_node.cores[0:j.cores]
						//~ # ~ for c in choosen_core:
													
							//~ # ~ c.job_queue.append(j)
							
							//~ # ~ # Fix en carton
							//~ # ~ # c.available_time = t
				
				//~ # NEW			
				//~ # ~ nb = nb_available_cores(n, t)
				//~ # ~ if nb >= j.cores: 
					//~ # ~ print("On node", n.unique_id, "there are:", nb, "available cores and I use", j.cores) 
					//~ # Need to make sure it won't delay first_job_in_queue
					//~ # If it's the same node and the job is longer that start time of first_job_in_queue it might cause problems
				//~ same_node = False
				//~ success = False
				//~ if (n == first_job_in_queue.node_used and t + j.walltime > first_job_in_queue.start_time):
					//~ same_node = True
					
				//~ choosen_core, success = return_cores_not_running_a_job(n, j.cores, t, same_node, first_job_in_queue.cores_used)
						//~ # ~ # Careful, you can't choose the same cores!
						//~ # ~ for c in n.cores:
							//~ # ~ if c.available_time <= t and c not in first_job_in_queue.cores_used:
								//~ # ~ nb_possible_cores += 1
						//~ # ~ if (nb_possible_cores >= j.cores): # Ok you can!
							//~ # ~ choosen_node = n
							
							//~ # ~ for c in choosen_node.cores:
								//~ # ~ if c.available_time <= t and c not in first_job_in_queue.cores_used:
									//~ # ~ choosen_core.append(c)
									
									
									//~ # ~ c.job_queue.append(j)
									//~ # ~ if (len(choosen_core) == j.cores):
										//~ # ~ break
														
					//~ # ~ else: # You can choose any free core
				//~ if success == True:
					//~ choosen_node = n
					//~ # ~ choosen_node.cores.sort(key = operator.attrgetter("available_time"))
					//~ # ~ choosen_core = choosen_node.cores[0:j.cores]
					//~ for c in choosen_core:
													
						//~ c.job_queue.append(j)
							
						//~ # Fix en carton
						//~ c.available_time = t
					
					//~ # OLD
					//~ # ~ if choosen_node != None:
					//~ start_time = get_start_time_and_update_avail_times_of_cores(t, choosen_core, j.walltime) 
					//~ j.node_used = choosen_node
					//~ j.cores_used = choosen_core
					//~ j.start_time = start_time
					//~ j.end_time = start_time + j.walltime	
						
					//~ for c in choosen_core:
						//~ for j2 in c.job_queue:
							//~ if j != j2:
								//~ j2.start_time = c.available_time
								//~ j2.end_time = j2.start_time + j.walltime	
								//~ c.available_time = j2.end_time
									
						//~ # ~ choosen_node.n_available_cores -= j.cores
						//~ # ~ tab[n.unique_id] += j.cores
												
						//~ # ~ available_job_list.remove(j)
						//~ # ~ job_to_remove.append(j)
						//~ # ~ scheduled_job_list.append(j)
					//~ if __debug__:
						//~ print_decision_in_scheduler(choosen_core, j, choosen_node)
						//~ # ~ start_jobs_single_job(t, j)
						//~ # ~ tab[n.unique_id] -= j.cores
						//~ # ~ print_job_info_from_list(available_job_list, t)
					//~ break
	//~ # ~ available_job_list = remove_jobs_from_list(available_job_list, job_to_remove)
	//~ # ~ print("Fin de Easy BackFilling...")
	//~ # ~ return scheduled_job_list

//~ # Print in a csv file the results of this job allocation
//~ def to_print_job_csv(job, node_used, core_ids, time, first_time_day_0):	
	//~ time_used = job.end_time - job.start_time
	
	//~ # Only evaluate jobs from workload 1
	//~ if (job.workload == 1):	
		//~ tp = To_print(job.unique_id, job.subtime, node_used, core_ids, time, time_used, job.transfer_time, job.start_time, job.end_time, job.cores, job.waiting_for_a_load_time, job.delay + job.data_size/0.1, job.index_node_list)
		//~ to_print_list.append(tp)
		
	//~ if (write_all_jobs == 1): # For gantt charts
		//~ file_to_open = "outputs/Results_all_jobs_" + scheduler + ".csv"
		//~ f = open(file_to_open, "a")
		//~ # ~ f.write("%d,%d,delay,%f,%d,%f,1,COMPLETED_SUCCESSFULLY,%f,%f,%f,%f,%f,%f," % (job.unique_id, job.unique_id, job.subtime, job.cores, job.walltime, job.start_time, time_used, job.end_time, job.start_time, job.end_time, 1))
		//~ # ~ f.write("%d,%d,delay,%f,%d,%f,1,COMPLETED_SUCCESSFULLY,%f,%f,%f,%f,%f,%f," % (job.unique_id, job.unique_id, job.subtime, job.cores, job.walltime, job.start_time - 1000, time_used, job.end_time - 1000, job.start_time - 1000, job.end_time - 1000, 1))
		//~ f.write("%d,%d,delay,%f,%d,%f,1,COMPLETED_SUCCESSFULLY,%f,%f,%f,%f,%f,%f," % (job.unique_id, job.unique_id, 0, job.cores, job.walltime, job.start_time - first_time_day_0, time_used, job.end_time - first_time_day_0, job.start_time - first_time_day_0, job.end_time - first_time_day_0, 1))
				
		//~ if (len(core_ids) > 1):
			//~ # ~ core_ids.sort()
			//~ for i in range (0, len(core_ids)):
			//~ # ~ for i in core_ids:
				//~ if (i == len(core_ids) - 1):
					//~ f.write("%d" % (node_used*20 + core_ids[i]))
				//~ else:
					//~ # ~ print(node_used)
					//~ # ~ print(len(core_ids))
					//~ # ~ print(i)
					//~ # ~ f.write("%d-" % (node_used*20 + core_ids[i]))
					//~ f.write("%d " % (node_used*20 + core_ids[i]))
		//~ else:
			//~ f.write("%d" % (node_used*20 + core_ids[0]))
		//~ f.write(",-1,\"\"\n")
		//~ f.close()
	//~ elif (write_all_jobs == 2): # For distribution of queue times
		//~ file_to_open = "outputs/Distribution_queue_times_" + scheduler + ".txt"
		//~ f = open(file_to_open, "a")
		//~ f.write("%d\n" % (job.start_time - job.subtime))
		//~ f.close()


//~ if (scheduler == "Fcfs_area_filling" or scheduler == "Fcfs_area_filling_omniscient"):
	//~ Planned_Area = []
	//~ if (scheduler == "Fcfs_area_filling"):
		//~ with open("inputs/file_size_requirement/Ratio_area_2022-02-02->2022-02-02.txt") as f:
			//~ line = f.readline()
			//~ r1, r2, r3, r4,= line.split()
			//~ Planned_Area.append([float(r2), float(r3), float(r4)])
			//~ line = f.readline()
			//~ r1, r2, r3, r4,= line.split()
			//~ Planned_Area.append([float(r2), float(r3), float(r4)])
			//~ line = f.readline()
			//~ r1, r2, r3, r4,= line.split()
			//~ Planned_Area.append([float(r2), float(r3), float(r4)])
		//~ f.close
	//~ elif (scheduler == "Fcfs_area_filling_omniscient"):
		//~ with open("inputs/file_size_requirement/Ratio_area_2022-02-08->2022-02-08_very_reduced.txt") as f:
			//~ line = f.readline()
			//~ r1, r2, r3, r4,= line.split()
			//~ Planned_Area.append([float(r2), float(r3), float(r4)])
			//~ line = f.readline()
			//~ r1, r2, r3, r4,= line.split()
			//~ Planned_Area.append([float(r2), float(r3), float(r4)])
			//~ line = f.readline()
			//~ r1, r2, r3, r4,= line.split()
			//~ Planned_Area.append([float(r2), float(r3), float(r4)])
		//~ f.close
	//~ else:
		//~ print("Wrong scheduler area filling")
		//~ exit(1)


//~ if (write_all_jobs == 3):
	//~ title = "outputs/Stats_" + scheduler + ".csv"
	//~ f_stats = open(title, "w")
	//~ f_stats.write("Used cores,Used nodes,Scheduled jobs\n")

//~ # Variant for FCFS with a score
//~ if scheduler[0:19] == "Fcfs_with_a_score_x":
	//~ i = 19
	//~ j = 19
	//~ while scheduler[i] != "_":
		//~ i+= 1
	//~ multiplier_file_to_load = int(scheduler[j:i])
	//~ j = i + 2
	//~ i = i + 1
	//~ while scheduler[i] != "_":
		//~ i+= 1
	//~ multiplier_file_evicted = int(scheduler[j:i])
	//~ j = i + 2
	//~ multiplier_nb_copy = int(scheduler[j:len(scheduler)])
	
	
	//~ # ~ if len(scheduler) == 26:
	//~ # ~ elif len(scheduler) == 27:
	//~ # ~ else:
		//~ # ~ print("ERROR: Your Fcfs_with_a_score_x is written wrong it should be Fcfs_with_a_score_xM_xM_xM. Or I haven't dealt with this number for multipliers :/")
		//~ # ~ exit(1)
	//~ # ~ multiplier_file_to_load = int(scheduler[19])
	//~ # ~ multiplier_file_evicted = int(scheduler[22])
	//~ # ~ multiplier_nb_copy = int(scheduler[25])
	//~ print("Multiplier file to load:", multiplier_file_to_load, "| Multiplier file evicted:", multiplier_file_evicted, "| Multiplier nb of copy:", multiplier_nb_copy)

//~ # Variant for backfill big nodes
//~ if (scheduler[0:24] == "Fcfs_backfill_big_nodes_"):
	//~ # 0 = don't compute anything, 1 = compute mean queue time
	//~ backfill_big_node_mode = int(scheduler[24])
	
//~ # For constraint on node sizes
//~ total_queue_time = 0
	
//~ # Start of simulation
//~ first_job_in_queue = None

//~ while(nb_job_to_evaluate != nb_job_to_evaluate_finished):
	//~ # Get the set of available jobs at time t
	//~ # Jobs are already sorted by subtime so I can simply stop with a break
	//~ if next_submit_time == t:
		//~ to_remove = []
		//~ for j in job_list:
			//~ # ~ if (j.subtime == t):
			//~ if (j.subtime <= t):
				//~ new_job_list.append(j)
				//~ available_job_list.append(j)
				//~ to_remove.append(j)
			//~ elif (j.subtime > t):
				//~ next_submit_time = j.subtime
				//~ break
		//~ remove_jobs_from_list(job_list, to_remove)
	
	//~ # New jobs are available! Schedule them
	//~ # ~ if (len(available_job_list) > 0):
	//~ if (len(new_job_list) > 0):
	//~ # ~ if (new_job == True):
		//~ if __debug__:
			//~ # ~ print(len(available_job_list), "new jobs at time", t)
			//~ print(len(new_job_list), "new jobs at time", t)
			
		//~ if (scheduler == "Random"):
			//~ random.shuffle(available_job_list)
			//~ scheduled_job_list = random_scheduler(new_job_list, node_list, t)
			
		//~ # ~ elif (scheduler == "Fcfs_with_a_score" or scheduler == "Fcfs_with_a_score_variant"):
		//~ elif (scheduler[0:19] == "Fcfs_with_a_score_x"):
			//~ # ~ fcfs_with_a_score_scheduler(available_job_list, node_list, t, multiplier, multiplier_nb_copy)
			//~ scheduled_job_list = fcfs_with_a_score_scheduler(new_job_list, node_list, t, multiplier_file_to_load, multiplier_file_evicted, multiplier_nb_copy)
			
		//~ elif (scheduler == "Fcfs"):
			//~ scheduled_job_list = fcfs_scheduler(new_job_list, node_list, t)
			
		//~ elif (scheduler == "Fcfs_no_use_bigger_nodes"):
			//~ scheduled_job_list = fcfs_no_use_bigger_nodes_scheduler(new_job_list, node_list, t)
			
		//~ elif (scheduler == "Fcfs_big_job_first"):
			//~ # Order new jobs list and append them in order (depending on the size they need) in available job list
			//~ new_job_list.sort(key = operator.attrgetter("index_node_list"), reverse = True)
			//~ available_job_list.sort(key = operator.attrgetter("index_node_list"), reverse = True)
			//~ scheduled_job_list = fcfs_scheduler_big_job_first(new_job_list, node_list, t)
		
		//~ elif (scheduler == "Fcfs_area_filling" or scheduler == "Fcfs_area_filling_omniscient"):
			//~ new_job_list.sort(key = operator.attrgetter("index_node_list"), reverse = True)
			//~ available_job_list.sort(key = operator.attrgetter("index_node_list"), reverse = True)
			//~ scheduled_job_list = fcfs_scheduler_area_filling(new_job_list, node_list, t, Planned_Area)
			
		//~ elif (scheduler[0:24] == "Fcfs_backfill_big_nodes_"):
			//~ new_job_list.sort(key = operator.attrgetter("index_node_list"), reverse = True)
			//~ available_job_list.sort(key = operator.attrgetter("index_node_list"), reverse = True)
			//~ scheduled_job_list = fcfs_scheduler_backfill_big_nodes(new_job_list, node_list, t, backfill_big_node_mode, total_queue_time, finished_jobs)
				
		//~ elif (scheduler == "Fcfs_easybf"):
			//~ if (first_job_in_queue == None):
				//~ first_job_in_queue = available_job_list[0]
			//~ else:
				//~ first_job_in_queue = scheduled_job_list[0]
			//~ fcfs_scheduler(available_job_list, node_list, t)
			//~ easy_backfill_no_return(first_job_in_queue, t, node_list, available_job_list)

		//~ elif (scheduler == "Fcfs_with_a_score_easy_bf"):
			//~ if (first_job_in_queue == None):
				//~ first_job_in_queue = available_job_list[0]
			//~ else:
				//~ first_job_in_queue = scheduled_job_list[0]
			//~ fcfs_with_a_score_scheduler(available_job_list, node_list, t, multiplier, multiplier_nb_copy)
			//~ easy_backfill_no_return(first_job_in_queue, t, node_list, available_job_list)
			
		//~ elif (scheduler == "Common_file_packages_with_a_score"):
			//~ common_file_packages_with_a_score(available_job_list, node_list, t, total_number_cores)
				
		//~ elif (scheduler == "Maximum_use_single_file"):
			//~ while(len(available_job_list) > 0):
				//~ # ~ print(len(available_job_list))
				//~ available_job_list = maximum_use_single_file_scheduler(available_job_list, node_list, t)
		//~ else:
			//~ print("Wrong scheduler in arguments")
			//~ exit(1)
			
		//~ # ~ available_job_list.clear()
		//~ new_job_list.clear()
	
	//~ # Get ended job. Inform if a filing is needed. Compute file transfers needed.	
	//~ affected_node_list = []	
	//~ finished_job_list = []	
	//~ old_finished_jobs = finished_jobs
	
	//~ if t in end_times:
		//~ finished_jobs, affected_node_list, finished_job_list, running_jobs, running_cores, running_nodes, nb_job_to_evaluate_finished = end_jobs(t, finished_jobs, affected_node_list, running_jobs, running_cores, running_nodes, nb_job_to_evaluate_finished, nb_job_to_evaluate, first_time_day_0)
		
	//~ # Let's remove finished jobs copy of data but after the start job so the one finishing and starting consecutivly don't load it twice
	//~ # Now I deal with it with intevralk it should work like before
	//~ if len(finished_job_list) > 0:
		//~ remove_data_from_node(finished_job_list, t)
	
	//~ # ~ if (len(affected_node_list) > 0): # A core has been liberated earlier so go schedule everything
	//~ if (old_finished_jobs < finished_jobs and len(available_job_list) > 0):
		//~ # ~ print("Core liberated")
		//~ # Reset all cores and jobs
		//~ if (scheduler != "Maximum_use_single_file"):
			//~ reset_cores(node_list[0] + node_list[1] + node_list[2], t)
		
		//~ if __debug__:
			//~ print("Reschedule. Nb of job available:", len(available_job_list))
			
		//~ if (scheduler == "Random"):
			//~ scheduled_job_list = random_scheduler(available_job_list, node_list, t)
			
		//~ # ~ elif (scheduler == "Fcfs_with_a_score" or scheduler == "Fcfs_with_a_score_variant"):
		//~ elif (scheduler[0:19] == "Fcfs_with_a_score_x"):
			//~ # ~ fcfs_with_a_score_scheduler(scheduled_job_list, node_list, t, multiplier, multiplier_nb_copy)
			//~ scheduled_job_list = fcfs_with_a_score_scheduler(available_job_list, node_list, t, multiplier_file_to_load, multiplier_file_evicted, multiplier_nb_copy)
			
		//~ elif (scheduler == "Fcfs"):
			//~ # ~ fcfs_scheduler(scheduled_job_list, node_list, t)
			//~ scheduled_job_list = fcfs_scheduler(available_job_list, node_list, t)
			
		//~ elif (scheduler == "Fcfs_no_use_bigger_nodes"):
			//~ scheduled_job_list = fcfs_no_use_bigger_nodes_scheduler(available_job_list, node_list, t)

		//~ elif (scheduler == "Fcfs_big_job_first"):
			//~ scheduled_job_list = fcfs_scheduler_big_job_first(available_job_list, node_list, t)
			
		//~ elif (scheduler[0:24] == "Fcfs_backfill_big_nodes_"):
			//~ scheduled_job_list = fcfs_scheduler_backfill_big_nodes(available_job_list, node_list, t, backfill_big_node_mode, total_queue_time, finished_jobs)
			
		//~ elif (scheduler == "Fcfs_area_filling" or scheduler == "Fcfs_area_filling_omniscient"):
			//~ scheduled_job_list = fcfs_scheduler_area_filling(available_job_list, node_list, t, Planned_Area)
			
		//~ elif (scheduler == "Maximum_use_single_file"):
			//~ reset_cores(affected_node_list, t)
			//~ maximum_use_single_file_re_scheduler(scheduled_job_list, t, affected_node_list)
			
		//~ elif (scheduler == "Common_file_packages_with_a_score"):
			//~ common_file_packages_with_a_score(scheduled_job_list, node_list, t, total_number_cores)
			
		//~ if __debug__:
			//~ print("End of reschedule")
	
	//~ # Ones with backfill
	//~ # ~ if (old_finished_jobs < finished_jobs):
		//~ if (scheduler == "Fcfs_easybf"):
			//~ if (len(scheduled_job_list) > 0):
				//~ first_job_in_queue = scheduled_job_list[0]
				//~ # ~ print("First job is", first_job_in_queue.unique_id)
				//~ if len(affected_node_list) > 0:
					//~ fcfs_scheduler(scheduled_job_list, node_list, t)
			//~ easy_backfill_no_return(first_job_in_queue, t, node_list, scheduled_job_list)
			
		//~ elif (scheduler == "Fcfs_with_a_score_easy_bf"):
			//~ if (len(scheduled_job_list) > 0):
				//~ first_job_in_queue = scheduled_job_list[0]
				//~ # ~ print("First job is", first_job_in_queue.unique_id)
				//~ if len(affected_node_list) > 0:
					//~ fcfs_with_a_score_scheduler(scheduled_job_list, node_list, t, multiplier, multiplier_nb_copy)
			//~ easy_backfill_no_return(first_job_in_queue, t, node_list, scheduled_job_list)
			
	//~ # Get started jobs
	//~ if (len(scheduled_job_list) > 0):
		//~ # ~ scheduled_job_list.sort(key = operator.attrgetter("start_time"))
		//~ # ~ if (scheduled_job_list[0].start_time == t):
		//~ scheduled_job_list, running_jobs, end_times, running_cores, running_nodes, total_queue_time, available_job_list = start_jobs(t, scheduled_job_list, running_jobs, end_times, running_cores, running_nodes, total_queue_time, available_job_list)
	
	//~ # ~ # Let's remove finished jobs copy of data but after the start job so the one finishing and starting consecutivly don't load it twice
	//~ # ~ if len(finished_job_list) > 0:
		//~ # ~ remove_data_from_node(finished_job_list)
	
	//~ # Print cluster usage
	//~ if write_all_jobs == 3:
		//~ f_stats.write("%d,%d,%d\n" % (running_cores, running_nodes, len(available_job_list)))
		
	//~ # Time is advancing
	//~ t += 1

//~ if (write_all_jobs == 3):
	//~ f_stats.close()

//~ # Print results in a csv file
//~ print("Computing and writing results...")
//~ print_csv(to_print_list, scheduler)
