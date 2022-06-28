#include <main.h>

int constraint_on_sizes;
int nb_cores;
int nb_job_to_evaluate;
int finished_jobs;
int total_number_jobs;
int total_number_nodes;
struct Job_List* job_list; /* All jobs not available yet */
struct Job_List* new_job_list; /* New available jobs */
struct Job_List* job_list_to_start_from_history; /* With -2 and before start */
struct Job_List* scheduled_job_list; /* Scheduled or available */
struct Job_List* running_jobs; /* Started */
struct Node_List** node_list;
struct To_Print_List* jobs_to_print_list;
int running_cores;
int running_nodes;
int total_queue_time;
int first_subtime_day_0;
char* scheduler;
struct Next_Time_List* end_times;
struct Next_Time_List* start_times;
int nb_job_to_evaluate_started;

int main(int argc, char *argv[])
{
	/* Init global variables */
	finished_jobs = 0;
	total_number_jobs = 0;
	running_cores = 0;
	running_nodes = 0;
	//~ nb_job_to_evaluate_finished = 0;
	nb_job_to_evaluate_started = 0;
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
	
	printf("Workloads: %s\n", input_job_file);
	printf("Cluster: %s\n", input_node_file);
	printf("Scheduler: %s\n", scheduler);
	printf("Size constraint: %d\n", constraint_on_sizes);	
	
	/* Read cluster */
	read_cluster(input_node_file);
	printf("Read cluster done.\n"); fflush(stdout);

	#ifdef PRINT
	print_node_list(node_list);
	#endif
	
	/* Read workload */
	read_workload(input_job_file, constraint_on_sizes);
	printf("Read workload done.\n");
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

	//~ bool new_job = false;
	int next_submit_time = first_subtime_day_0;
	int t = first_subtime_day_0;
	//~ next_end_time = -1; /* TODO: enable it here if use it I set it in start_jobs */
		
	/* First start jobs from rackham's history. First need to sort it by start time */
	if (job_list_to_start_from_history->head != NULL)
	{
		get_state_before_day_0_scheduler(job_list_to_start_from_history->head, node_list, t);
	}
	
	#ifdef PRINT
	printf("\nScheduled job list after scheduling -2 jobs from history. Must be full.\n");
	print_job_list(scheduled_job_list->head);
	#endif
	
	/* Just for -2 jobs here */
	if (scheduled_job_list->head != NULL)
	{
		start_jobs(t, scheduled_job_list->head);
	}
	printf("Start jobs before day 0 done.\n");
	
	#ifdef PRINT
	printf("\nSchedule job list after starting - 2. Must be less full.\n"); fflush(stdout);
	print_job_list(scheduled_job_list->head);
	#endif

	#ifdef PRINT_SCORES_DATA
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
	
	int i = 0;
	int j = 0;
	int multiplier_file_to_load = 0;
	int multiplier_file_evicted = 0;
	int multiplier_nb_copy = 0;
	int backfill_big_node_mode = 0;
	
	/* Getting informations for certain schedulers. */
	if (strncmp(scheduler, "Fcfs_with_a_score_x", 19) == 0)
	{
		i = 19;
		j = 19;
		while (scheduler[i] != '_')
		{
			i += 1;
		}
		char *to_copy = malloc(5*sizeof(char));
		strncpy(to_copy, scheduler + j, i - j);
		multiplier_file_to_load = atoi(to_copy);
		j = i + 2;
		i = i + 1;
		while (scheduler[i] != '_')
		{
			i += 1;
		}
		strncpy(to_copy, scheduler + j, i - j);
		multiplier_file_evicted = atoi(to_copy);
		j = i + 2;
		while (scheduler[i])
		{
			i += 1;
		}
		strncpy(to_copy, scheduler + j, i - j);
		multiplier_nb_copy = atoi(to_copy);
		
		printf("Multiplier file to load: %d / Multiplier file evicted: %d / Multiplier nb of copy: %d.\n", multiplier_file_to_load, multiplier_file_evicted, multiplier_nb_copy);
		free(to_copy);
	}
	else if (strncmp(scheduler, "Fcfs_area_filling", 17) == 0)
	{
		FILE *f = NULL;
		int** Planned_Area = malloc(3*3*sizeof(int));
		char s1[10];
		char s2[10];
		char s3[10];
		char s4[10];
		if (strncmp(scheduler, "Fcfs_area_filling_omniscient", 28) == 0)
		{
			f = fopen("inputs/file_size_requirement/Ratio_area_2022-02-08->2022-02-08_omniscient.txt", "r");
		}
		else 
		{
			f = fopen("inputs/file_size_requirement/Ratio_area_2022-02-08->2022-02-08.txt", "r");
		}
		if (!f)
		{
			perror("fopen error in area filling.\n");
			exit(EXIT_FAILURE);
		}
		i = 0;
		while (fscanf(f, "%s %s %s %s", s1, s2, s3, s4) == 4)
		{
			Planned_Area[i][0] = atof(s2);
			Planned_Area[i][1] = atof(s3);
			Planned_Area[i][2] = atof(s4);
			i += 1;
		}
		fclose(f);
	}
	else if (strncmp(scheduler, "Fcfs_backfill_big_nodes_", 24) == 0)
	{
		/* 0 = don't compute anything, 1 = compute mean queue time */
		backfill_big_node_mode = scheduler[24] - '0';
		printf("backfill big nodes mode is %d.\n", backfill_big_node_mode);
	}
	
	bool new_jobs = false;
	
	/* For the schedulers dealing with size constraint I need to sort scheduled_job_list by file size (biggest to smallest) now but
	 * also do it when new jobs are added to scheduled_job_list. */
	bool sort_by_file_size = false;
	if ((strncmp(scheduler, "Fcfs_backfill_big_nodes_", 24) == 0) || (strncmp(scheduler, "Fcfs_area_filling", 17) == 0) || (strncmp(scheduler, "Fcfs_big_job_first", 19) == 0))
	{
		printf("Sorting job list by file's size.\n");
		sort_by_file_size = true;
		sort_job_list_by_file_size(&scheduled_job_list->head);
		print_job_list(scheduled_job_list->head);
	}
	
	/* Start of simulation. */
	printf("Start simulation.\n");
	while(nb_job_to_evaluate != nb_job_to_evaluate_started)
	{
		/* Get ended job. */
		old_finished_jobs = finished_jobs;
		if (end_times->head != NULL && end_times->head->time == t)
		{
			end_jobs(running_jobs->head, t);
		}	
		/* Get started jobs. */
		if (start_times->head != NULL)
		{
			if (start_times->head->time == t)
			{
				start_jobs(t, scheduled_job_list->head);
			}
		}			
		
		new_jobs = false;
		/* Get the set of available jobs at time t */
		/* Jobs are already sorted by subtime so I can simply stop with a break */
		if (next_submit_time == t) /* We have new jobs need to schedule them. */
		{
			new_jobs = true;
			#ifdef PRINT
			printf("We have new jobs at time %d.\n", t);
			#endif
			
			/* Copy in scheduled_job_list jobs and delete from job_list. */
			job_pointer = job_list->head;
			while (job_pointer != NULL)
			{
				if (job_pointer->subtime <= t)
				{
					#ifdef PRINT
					printf("New job %d.\n", job_pointer->unique_id);
					#endif
					
					temp = job_pointer->next;
					if (sort_by_file_size == true)
					{
						copy_delete_insert_job_list_sorted_by_file_size(job_list, scheduled_job_list, job_pointer);
					}
					else
					{
						copy_delete_insert_job_list(job_list, scheduled_job_list, job_pointer);
					}
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
		}

		if ((old_finished_jobs < finished_jobs || new_jobs == true) && scheduled_job_list->head != NULL) /* TODO not sure the head != NULL work. */
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
			
			if (strncmp(scheduler, "Fcfs_with_a_score_x", 19) == 0)
			{
				fcfs_with_a_score_scheduler(scheduled_job_list->head, node_list, t, multiplier_file_to_load, multiplier_file_evicted, multiplier_nb_copy);
			}
			else if (strcmp(scheduler, "Fcfs") == 0)
			{
				fcfs_scheduler(scheduled_job_list->head, node_list, t);
			}
			else if (strcmp(scheduler, "Fcfs_no_use_bigger_nodes") == 0)
			{
				fcfs_no_use_bigger_nodes_scheduler(scheduled_job_list->head, node_list, t);
			}
			else if (strcmp(scheduler, "Fcfs_big_job_first") == 0)
			{
				fcfs_no_use_bigger_nodes_scheduler(scheduled_job_list->head, node_list, t);
			}
			else if (strcmp(scheduler, "Fcfs_area_filling") == 0 || strcmp(scheduler, "Fcfs_area_filling_omniscient") == 0)
			{
				fcfs_no_use_bigger_nodes_scheduler(scheduled_job_list->head, node_list, t, Planned_Area);
			}
			else if (strcmp(scheduler, "Fcfs_backfill_big_nodes_") == 0)
			{
				fcfs_no_use_bigger_nodes_scheduler(scheduled_job_list->head, node_list, t, backfill_big_node_mode, total_queue_time, finished_jobs);
			}
			else
			{
				printf("Error: wrong scheduler in arguments.\n"); fflush(stdout);
				exit(EXIT_FAILURE);
			}
							
			#ifdef PRINT	
			printf("End of reschedule.\n");
			#endif
			
			/* Get started jobs. */
			if (start_times->head != NULL)
			{
				if (start_times->head->time == t)
				{
					start_jobs(t, scheduled_job_list->head);
				}
			}
		}
		
		//~ /* Get started jobs. */
		//~ if (start_times->head != NULL)
		//~ {
			//~ if (start_times->head->time == t)
			//~ {
				//~ start_jobs(t, scheduled_job_list->head);
			//~ }
		//~ }
		
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
	
	printf("Computing and writing results...\n");
	print_csv(jobs_to_print_list->head);
	
	return 1;
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
		
