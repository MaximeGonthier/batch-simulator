#include <main.h>

void main(int argc, char *argv[])
{
	/* Init global variables */
	finished_jobs = 0;
	total_number_jobs = 0;
	running_cores = 0;
	running_nodes = 0;
	nb_job_to_evaluate_finished = 0;
	total_queue_time = 0;
	//~ struct Job* first_job_in_queue = NULL; /* TODO: need to malloc ? Just if I use backfill. Useless else. */
	struct Job* job_pointer = (struct Job*) malloc(sizeof(struct Job));
	struct Job* temp = (struct Job*) malloc(sizeof(struct Job));
	
	end_times = malloc(sizeof(*end_times));
	end_times->head = NULL;
	start_times = malloc(sizeof(*start_times));
	start_times->head = NULL;
	jobs_to_print_list = malloc(sizeof(*jobs_to_print_list));
	jobs_to_print_list->head = NULL;
	jobs_to_print_list->tail = NULL;
	
	int old_finished_jobs = 0;
	char* input_job_file = argv[1];
	char* input_node_file = argv[2];
	scheduler = argv[3]; /* malloc ? */
	constraint_on_sizes = atoi(argv[4]); /* To add or remove the constraint that some jobs can't be executed on certain nodes. 0 for no constraint, 1 for constraint, 2 for constraint but we don't consider transfer time. */
	
	#ifdef PRINT
	printf("Workloads: %s\n", input_job_file);
	printf("Cluster: %s\n", input_node_file);
	printf("Scheduler: %s\n", scheduler);
	printf("Size constraint: %d\n", constraint_on_sizes);
	#endif	
	
	/* Read cluster */
	read_cluster(input_node_file);
	printf("Read cluster done.\n"); fflush(stdout);

	#ifdef PRINT
	print_node_list(node_list);
	#endif
	
	/* Read workload */
	read_workload(input_job_file, constraint_on_sizes);
	printf("Read workload done.\n"); fflush(stdout);
	nb_job_to_evaluate = get_nb_job_to_evaluate(job_list->head);
	first_subtime_day_0 = get_first_time_day_0(job_list->head);
	
	//~ #ifdef PRINT
	//~ printf("\nNumber of jobs to evaluate: %d\n", nb_job_to_evaluate);
	//~ printf("First time day 0: %d\n", first_subtime_day_0);
	//~ printf("Number of nodes: %d\n", total_number_nodes);
	//~ printf("\nJobs to start before:\n");
	//~ print_job_list(job_list_to_start_from_history->head);
	//~ printf("\nJobs for simulation:\n");
	//~ print_job_list(job_list->head);
	//~ #endif
	
	#ifdef PRINT_CLUSTER_USAGE
	write_in_file_first_times_all_day(job_list->head, first_subtime_day_0);
	#endif

	bool new_job = false;
	int next_submit_time = first_subtime_day_0;
	int t = first_subtime_day_0;
	//~ next_end_time = -1; /* TODO: enable it here if use it I set it in start_jobs */
		
	/* First start jobs from rackham's history. First need to sort it by start time */
	if (job_list_to_start_from_history->head != NULL)
	{
		get_state_before_day_0_scheduler(job_list_to_start_from_history->head, node_list, t);
	}
	printf("State before day 0 done.\n"); fflush(stdout);
	
	//~ #ifdef PRINT
	//~ printf("\njob_list_to_start_from_history after schedule. Must be empty.\n");
	//~ print_job_list(job_list_to_start_from_history->head);
	//~ printf("\nScheduled job list after starting jobs from history. Must be full.\n");
	//~ print_job_list(scheduled_job_list->head);
	//~ #endif
	
	/* Just for -2 jobs here */
	if (scheduled_job_list->head != NULL)
	{
		start_jobs(t, scheduled_job_list->head);
	}
	printf("Start jobs before day 0 done.\n"); fflush(stdout);
	
	#ifdef PRINT
	printf("\nSchedule job list after schedule - 2. Must be less full.\n");
	print_job_list(scheduled_job_list->head);
	//~ printf("\nRunning job list after schedule -2. Must be filled with jobs from scheduled job list previously started at time t = %d.\n", t);
	//~ print_job_list(running_jobs->head);
	#endif

	#ifdef PRINT
	FILE* f_fcfs_score = fopen("outputs/Scores_data.txt", "w");
	if (!f_fcfs_score)
	{
		perror("fopen in main");
        exit(EXIT_FAILURE);
	}
	fclose(f_fcfs_score);
	#endif
	
	#ifdef PRINT_CLUSTER_USAGE
	char* title = malloc(100*sizeof(char));
	strcpy(title, "outputs/Stats_");
	strcat(title, scheduler);
	strcat(title, ".csv");
	FILE* f_stats = fopen(title, "w");
	if (!f_stats)
	{
		perror("fopen in main");
        exit(EXIT_FAILURE);
	}
	fprintf(f_stats, "Used cores,Used nodes,Scheduled jobs\n");
	#endif
	
	/* Getting informations for certain schedulers. */
	if scheduler[0:19] == "Fcfs_with_a_score_x":
		i = 19
		j = 19
		while scheduler[i] != "_":
			i+= 1
		multiplier_file_to_load = int(scheduler[j:i])
		j = i + 2
		i = i + 1
		while scheduler[i] != "_":
			i+= 1
		multiplier_file_evicted = int(scheduler[j:i])
		j = i + 2
		multiplier_nb_copy = int(scheduler[j:len(scheduler)])
		
		
		# ~ if len(scheduler) == 26:
		# ~ elif len(scheduler) == 27:
		# ~ else:
			# ~ print("ERROR: Your Fcfs_with_a_score_x is written wrong it should be Fcfs_with_a_score_xM_xM_xM. Or I haven't dealt with this number for multipliers :/")
			# ~ exit(1)
		# ~ multiplier_file_to_load = int(scheduler[19])
		# ~ multiplier_file_evicted = int(scheduler[22])
		# ~ multiplier_nb_copy = int(scheduler[25])
		print("Multiplier file to load:", multiplier_file_to_load, "| Multiplier file evicted:", multiplier_file_evicted, "| Multiplier nb of copy:", multiplier_nb_copy)

	/* Start of simulation. */
	while(nb_job_to_evaluate != nb_job_to_evaluate_finished)
	{
		/* Get the set of available jobs at time t */
		/* Jobs are already sorted by subtime so I can simply stop with a break */
		if (next_submit_time == t) /* We have new jobs need to schedule them. */
		{
			#ifdef PRINT
			printf("We have new jobs at time %d.\n", t);
			#endif
			
			/* Copy in new jobs and delete from job_list. */
			job_pointer = job_list->head;
			while (job_pointer != NULL)
			{
				if (job_pointer->subtime <= t)
				{
					temp = job_pointer->next;
					copy_delete_insert_job_list(job_list, new_job_list, job_pointer);
					job_pointer = temp;
				}
				else
				{
					break;
				}
			}

			if (job_pointer != NULL)
			{
				next_submit_time = job_pointer->subtime;
			}
			else
			{
				next_submit_time = -1;
			}
			
			//~ #ifdef PRINT
			//~ printf("\nJob list after new jobs, must be less full.\n");
			//~ print_job_list(job_list->head);
			//~ printf("\nNew jobs after new jobs, must be a bit filled.\n");
			//~ print_job_list(new_job_list->head);
			//~ #endif

			/* New jobs are available! Schedule them. */
			if (strcmp(scheduler, "Random") == 0)
			{
				//~ random.shuffle(available_job_list);
				//~ scheduled_job_list = random_scheduler(new_job_list, node_list, t);
			}
				
			//~ /* ~ elif (scheduler == "Fcfs_with_a_score" or scheduler == "Fcfs_with_a_score_variant"):
			//~ elif (scheduler[0:19] == "Fcfs_with_a_score_x"):
				//~ /* ~ fcfs_with_a_score_scheduler(available_job_list, node_list, t, multiplier, multiplier_nb_copy)
				//~ scheduled_job_list = fcfs_with_a_score_scheduler(new_job_list, node_list, t, multiplier_file_to_load, multiplier_file_evicted, multiplier_nb_copy)
				
			else if (strcmp(scheduler, "Fcfs") == 0)
			{
				fcfs_scheduler(new_job_list->head, node_list, t);
			}
				
			//~ elif (scheduler == "Fcfs_no_use_bigger_nodes"):
				//~ scheduled_job_list = fcfs_no_use_bigger_nodes_scheduler(new_job_list, node_list, t)
				
			//~ elif (scheduler == "Fcfs_big_job_first"):
				//~ /* Order new jobs list and append them in order (depending on the size they need) in available job list
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
					//~ /* ~ print(len(available_job_list))
					//~ available_job_list = maximum_use_single_file_scheduler(available_job_list, node_list, t)
			else
			{
				printf("Wrong scheduler in arguments"); fflush(stdout);
				exit(EXIT_FAILURE);
			}
			
			/* Copy in scheduled_job and delete from new_jobs */
			job_pointer = new_job_list->head;
			while (job_pointer != NULL)
			{
				temp = job_pointer->next;
				copy_delete_insert_job_list(new_job_list, scheduled_job_list, job_pointer);
				job_pointer = temp;
			}
			
			//~ for (int i = 0; i < number_of_new_jobs; i++)
			//~ {
				//~ job_pointer = new_job_list->head;
				//~ printf("Add %d.\n", job_pointer->unique_id);
				//~ copy_delete_insert_job_list(new_job_list, scheduled_job_list, job_pointer);
			//~ }
			
			/* Copy and delete. */
			//~ job_pointer = new_job_list->head;
			//~ while (job_pointer != NULL)
			//~ {
				//~ if (job_pointer->start_time == t)
				//~ {
					//~ printf("Delete job %d from scheduled.\n", j->unique_id); fflush(stdout);
					//~ struct Job* temp = job_pointer->next;
					//~ copy_delete_insert_job_list(new_job_list, scheduled_job_list, job_pointer);
					//~ job_pointer = temp;
				//~ }
				//~ else
				//~ {
					//~ job_pointer = job_pointer->next;
				//~ }
			//~ }
			
			#ifdef PRINT
			printf("New job list emptied. Next start is %d t is %d. New schedule job list is:\n", start_times->head->time, t); fflush(stdout);
			print_job_list(scheduled_job_list->head);
			#endif
			
			//~ #ifdef PRINT
			//~ printf("\nNew job list after schedule of new jobs. Must be empty.\n");
			//~ print_job_list(new_job_list->head);
			//~ printf("\nSchedule job list after schedule of new jobs. Must be a bit more full.\n");
			//~ print_job_list(scheduled_job_list->head);
			//~ #endif
			
		}

		
		//~ printf("here\n");
		//~ /* Get ended job. Inform if a filing is needed. Compute file transfers needed.	 */
		//~ affected_node_list = []	
		//~ finished_job_list = []	
		old_finished_jobs = finished_jobs;
		//~ printf("here\n");	
		//~ if (end_times	
		if (end_times->head != NULL && end_times->head->time == t)
		{
			//~ printf("here\n");
			//~ printf("Job(s) ended.\n");
			//~ finished_jobs, affected_node_list, finished_job_list, running_jobs, running_cores, running_nodes, nb_job_to_evaluate_finished = end_jobs(t, finished_jobs, affected_node_list, running_jobs, running_cores, running_nodes, nb_job_to_evaluate_finished, nb_job_to_evaluate, first_time_day_0);
			end_jobs(running_jobs->head, t);
			//~ printf("here\n");
			/* Let's remove finished jobs copy of data but after the start job so the one finishing and starting consecutivly don't load it twice. */
			//~ remove_data_from_node(finished_job_list->head, t); /* I do it in end_jobs directly! */
		}

		if (old_finished_jobs < finished_jobs && scheduled_job_list->head != NULL) /* TODO not sure the head != NULL work. */
		{
			#ifdef PRINT
			printf("Core(s) liberated. Need to free them.\n"); fflush(stdout);
			#endif
			
			/* Reset all cores and jobs. */
			reset_cores(node_list, t);
			
			/* Reset planned starting times. */
			free_next_time_linked_list(&start_times->head);
			
			#ifdef PRINT
			printf("Reschedule.\n");
			#endif
			
			if (strcmp(scheduler, "Random") == 0)
			{
				//~ scheduled_job_list = random_scheduler(available_job_list, node_list, t);
			}				
			else if (strcmp(scheduler, "Fcfs") == 0)
			{
				fcfs_scheduler(scheduled_job_list->head, node_list, t);
			}
				
			//~ /* ~ elif (scheduler == "Fcfs_with_a_score" or scheduler == "Fcfs_with_a_score_variant"):
			//~ elif (scheduler[0:19] == "Fcfs_with_a_score_x"):
				//~ /* ~ fcfs_with_a_score_scheduler(scheduled_job_list, node_list, t, multiplier, multiplier_nb_copy)
				//~ scheduled_job_list = fcfs_with_a_score_scheduler(available_job_list, node_list, t, multiplier_file_to_load, multiplier_file_evicted, multiplier_nb_copy)
								
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
			
			#ifdef PRINT	
			printf("End of reschedule.\n");
			#endif
		
		//~ /* Ones with backfill
		//~ /* ~ if (old_finished_jobs < finished_jobs):
			//~ if (scheduler == "Fcfs_easybf"):
				//~ if (len(scheduled_job_list) > 0):
					//~ first_job_in_queue = scheduled_job_list[0]
					//~ /* ~ print("First job is", first_job_in_queue.unique_id)
					//~ if len(affected_node_list) > 0:
						//~ fcfs_scheduler(scheduled_job_list, node_list, t)
				//~ easy_backfill_no_return(first_job_in_queue, t, node_list, scheduled_job_list)
				
			//~ elif (scheduler == "Fcfs_with_a_score_easy_bf"):
				//~ if (len(scheduled_job_list) > 0):
					//~ first_job_in_queue = scheduled_job_list[0]
					//~ /* ~ print("First job is", first_job_in_queue.unique_id)
					//~ if len(affected_node_list) > 0:
						//~ fcfs_with_a_score_scheduler(scheduled_job_list, node_list, t, multiplier, multiplier_nb_copy)
				//~ easy_backfill_no_return(first_job_in_queue, t, node_list, scheduled_job_list)
		}
		
		/* Get started jobs. */
		if (start_times->head != NULL)
		{
			if (start_times->head->time == t)
			{
				start_jobs(t, scheduled_job_list->head);
			}
		}
		
		#ifdef PRINT_CLUSTER_USAGE
		fprintf(f_stats, "%d,%d,%d\n", running_cores, running_nodes, get_length_job_list(scheduled_job_list->head));
		#endif
		
		if (start_times->head != NULL && t > start_times->head->time)
		{
			printf("ERROR, next start is %d t is %d.\n", start_times->head->time, t); fflush(stdout);
			exit(EXIT_FAILURE);
		}
		
		/* Time is advancing. */
		t += 1;
	}
	
	#ifdef PRINT_CLUSTER_USAGE
	fclose(f_stats);
	#endif
	
	#ifdef PRINT
	printf("Computing and writing results...\n");
	#endif
	
	print_csv(jobs_to_print_list->head);
	
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
		
