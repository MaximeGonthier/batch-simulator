#include <main.h>

void get_state_before_day_0_scheduler(struct Job* j2, struct Node_List** n, int t)
{
	int i = 0;
	int nb_job_to_delete = 0;		
	/* Get number of node in each size category */
	struct Node *temp = (struct Node*) malloc(sizeof(struct Node));
	int* nb_node = malloc(3*sizeof(int));
	for (i = 0; i < 3; i++)
	{
		nb_node[i] = 0;
		temp = node_list[i]->head;
		while (temp != NULL)
		{
			temp = temp->next;
			nb_node[i] += 1;
		}
	}
	
	#ifdef PRINT
	printf("%d nodes of size 128, %d of size 256 and %d of size 1024.\n", nb_node[0], nb_node[1], nb_node[2]);
	#endif
	
	free(temp);

	struct Job* j = j2;
	while (j != NULL)
	{
		/* Insert in scheduled_job_list */
		//~ copy_job_and_insert_tail_job_list(scheduled_job_list, j);
		//~ insert_tail_job_list(scheduled_job_list, j);
		
		int time_since_start = t - j->start_time_from_history;
		j->delay -= time_since_start;
		j->walltime -= time_since_start;
		
		struct Node *choosen_node = (struct Node*) malloc(sizeof(struct Node));
		int index_node = (j->node_from_history - 1)%(nb_node[0] + nb_node[1] + nb_node[2]);
		if (index_node >= nb_node[0])
		{
			if (index_node >= nb_node[0] + nb_node[1])
			{
				choosen_node = node_list[2]->head;
				for (i = 0; i < index_node - nb_node[0] - nb_node[1]; i++)
				{
					choosen_node = choosen_node->next;
				}
			}
			else
			{
				choosen_node = node_list[1]->head;
				for (i = 0; i < index_node - nb_node[0]; i++)
				{
					choosen_node = choosen_node->next;
				}
			}
		}
		else
		{
			choosen_node = node_list[0]->head;
			for (i = 0; i < index_node; i++)
			{
				choosen_node = choosen_node->next;
			}
		}
		
		#ifdef PRINT
		printf("Choosen node is: ");
		print_single_node(choosen_node);
		#endif
		
		schedule_job_specific_node_at_earliest_available_time(j, choosen_node, t);
		nb_job_to_delete += 1;
		
		/* Add in list of starting times. */
		
		#ifdef PRINT
		printf("Before adding starting time %d:\n", j->start_time);
		print_time_list(start_times->head, 0);
		#endif
		
		insert_next_time_in_sorted_list(start_times, j->start_time);
		
		#ifdef PRINT
		printf("After adding starting time %d:\n", j->start_time);
		print_time_list(start_times->head, 0);
		#endif
		
		j = j->next;
	}
	
	/* Remove from job list to start and put it in scheduled job list. */
	for (i = 0; i < nb_job_to_delete; i++)
	{
		j = job_list_to_start_from_history->head;
		copy_delete_insert_job_list(job_list_to_start_from_history, scheduled_job_list, j);
	}

	free(nb_node);
}

void fcfs_scheduler(struct Job* head_job, struct Node_List** head_node, int t)
{
	int nb_non_available_cores = get_nb_non_available_cores(node_list, t);
	struct Job* j = head_job;
	while (j != NULL)
	{
		if (nb_non_available_cores < nb_cores)
		{
			#ifdef PRINT
			printf("There are %d/%d available cores.\n", nb_cores - nb_non_available_cores, nb_cores);
			#endif
			
			nb_non_available_cores = schedule_job_on_earliest_available_cores(j, head_node, t, nb_non_available_cores);
			
			insert_next_time_in_sorted_list(start_times, j->start_time);
			
			j = j->next;
		}
		else
		{
			#ifdef PRINT
			printf("There are %d/%d available cores. Break.\n", nb_cores - nb_non_available_cores, nb_cores);
			#endif
			
			break;
		}
		
		/* Add in list of starting times. */
		//~ #ifdef PRINT
		//~ printf("Before adding starting time %d:\n", j->start_time);
		//~ print_time_list(start_times->head, 0);
		//~ #endif
		
		//~ insert_next_time_in_sorted_list(start_times, j->start_time);
		
		//~ #ifdef PRINT
		//~ printf("After adding starting time %d:\n", j->start_time);
		//~ print_time_list(start_times->head, 0);
		//~ #endif
			
		//~ j = j->next;
	}
}

void fcfs_with_a_score_scheduler(struct Job* head_job, struct Node_List** head_node, int t, int multiplier_file_to_load, int multiplier_file_evicted, int multiplier_nb_copy)
{	
	int nb_non_available_cores = get_nb_non_available_cores(node_list, t);		
	int i = 0;
	int min_score = -1;
	int earliest_available_time = 0;
	int first_node_size_to_choose_from = 0;
	int last_node_size_to_choose_from = 0;
	int time_to_load_file = 0;
	bool is_being_loaded = false;
	
	/* Get intervals of data. */
	get_current_intervals(head_node, t);
	
	/* For printing intervals on each node. */
	print_data_intervals(head_node, t);
	
	//~ exit(1);
	
	#ifdef PRINT_SCORES_DATA
	f_fcfs_score = open("outputs/Scores_data.txt", "a")
	#endif
	
	/* 1. Loop on available jobs. */
	struct Job* j = head_job;
	while (j != NULL)
	{	
		if (nb_non_available_cores < nb_cores)
		{	
			/* 2. Choose a node. */		
			
			/* Reset some values. */					
			min_score = -1;
			earliest_available_time = 0;
			first_node_size_to_choose_from = 0;
			last_node_size_to_choose_from = 0;
			is_being_loaded = false;
			
			/* In which node size I can pick. */
			if (j->index_node_list == 0)
			{
				first_node_size_to_choose_from = 0;
				last_node_size_to_choose_from = 2;
			}
			else if (j->index_node_list == 1)
			{
				first_node_size_to_choose_from = 1;
				last_node_size_to_choose_from = 2;
			}
			else if (j->index_node_list == 2)
			{
				first_node_size_to_choose_from = 2;
				last_node_size_to_choose_from = 2;
			}
			else
			{
				printf("Error index value in schedule_job_on_earliest_available_cores.\n");  fflush(stdout);
				exit(EXIT_FAILURE);
			}
			
			//~ /* For the number of valid copy of a data on other nodes. I add in this list the times I already checked for current job. */
			//~ time_checked_for_nb_copy = []
			//~ corresponding_results = []
			
			for (i = first_node_size_to_choose_from; i <= last_node_size_to_choose_from; i++)
			{
				struct Node* n = head_node[i]->head;
				while (n != NULL)
				{						
					/* 2.1. A = Get the earliest available time from the number of cores required by the job and add it to the score. */
					earliest_available_time = n->cores[j->cores - 1]->available_time; /* -1 because tab start at 0 */
					if (earliest_available_time < t) /* A core can't be available before t. This happens when a node is idling. */				
					{
						earliest_available_time = t;
					}
					
					if (min_score == -1 or earliest_available_time < min_score)
						
						/* 2.2. B = Compute the time to load all data. For this look at the data that will be available at the earliest available time of the node. */
						if (j->data == 0)
						{
							time_to_load_file = 0;
						}
						else
						{
							time_to_load_file = is_my_file_on_node_at_certain_time_and_transfer_time(earliest_available_time, n, t, j->data, j->data_size, &is_being_loaded); /* Use the intervals in each data to get this info. */
						}
						
						printf("Time to load file: %d. Is being loaded ? %d.\n", time_to_load_file, is_being_loaded); fflush(stdout);
							
						//~ if min_score == -1 or earliest_available_time + multiplier_file_to_load*time_to_load_file < min_score:
						
							//~ # 2.5. Get the amount of files that will be lost because of this load by computing the amount of data that end at the earliest time only on the supposely choosen cores, excluding current file of course
							//~ # ~ if j->data != 0 and time_to_load_file == 0
								//~ # ~ size_files_ended = size_files_ended_at_certain_time(earliest_available_time, n, j->data)
							//~ if multiplier_file_evicted == 0:
								//~ size_files_ended = 0
								//~ time_to_reload_evicted_files = 0
							//~ else:
								//~ size_files_ended = size_files_ended_at_before_certain_time(earliest_available_time, n.data, j->data, j->cores/20)
								//~ time_to_reload_evicted_files = size_files_ended/n.bandwidth
						
							//~ if min_score == -1 or earliest_available_time + multiplier_file_to_load*time_to_load_file + multiplier_file_evicted*time_to_reload_evicted_files < min_score:
						
								//~ # 2.5bis Get number of copy of the file we want to load on other nodes (if you need to load a file that is) at the time that is predicted to be used. So if a file is already loaded on a lot of node, you have a penalty if you want to load it on a new node.
								//~ if time_to_load_file != 0 and is_being_loaded == False and multiplier_nb_copy != 0:
									//~ nb_copy_file_to_load = 0
									//~ if (earliest_available_time not in time_checked_for_nb_copy):
										
										//~ # ~ print("Need to compute nb of copy of data", j->data)
										//~ nb_copy_file_to_load = get_nb_valid_copy_of_a_file(earliest_available_time, nodes_to_choose_from, j->data)
										//~ # ~ nb_copy_file_to_load = get_nb_valid_copy_of_a_file(earliest_available_time, nodes_to_choose_from, j->data)
									
									//~ # ~ # Simplified version
									//~ # ~ nb_copy_file_to_load = nb_copy_current_file
															
										//~ time_checked_for_nb_copy.append(earliest_available_time)
										//~ corresponding_results.append(nb_copy_file_to_load)
									//~ else:
										//~ nb_copy_file_to_load = corresponding_results[time_checked_for_nb_copy.index(earliest_available_time)]
										//~ # ~ print("Already done for", j->unique_id, "at time", earliest_available_time, "so nb of copy is", nb_copy_file_to_load)
									//~ # ~ print("Nb of copy for data", j->data, "at time", earliest_available_time, "on node", n.unique_id, "is", nb_copy_file_to_load)
								//~ else:
									//~ nb_copy_file_to_load = 0

								//~ # Compute node's score
								//~ score = earliest_available_time + multiplier_file_to_load*time_to_load_file + multiplier_file_evicted*time_to_reload_evicted_files + nb_copy_file_to_load*time_to_load_file*multiplier_nb_copy
												
								//~ # ~ print("Score for job", j->unique_id, "is", score, "(EAT:", earliest_available_time, "+ TL", multiplier_file_to_load*time_to_load_file, "+ TRL", multiplier_file_evicted*time_to_reload_evicted_files, "+ CP", nb_copy_file_to_load*time_to_load_file*multiplier_nb_copy, ") with node", n.unique_id, "\n")
					
								//~ # 2.6. Get minimum score
								//~ if min_score == -1:
									//~ min_time = earliest_available_time
									//~ min_score = score
									//~ choosen_node = n
									//~ choosen_time_to_load_file = time_to_load_file
								//~ elif min_score > score:
									//~ min_time = earliest_available_time
									//~ min_score = score
									//~ choosen_node = n
									//~ choosen_time_to_load_file = time_to_load_file
						
					//~ f_fcfs_score.write("Node: %d EAT: %d C: %d CxX: %d Score: %d\n" % (n.unique_id, earliest_available_time, time_to_reload_evicted_files, time_to_reload_evicted_files*multiplier_file_evicted, earliest_available_time + multiplier_file_to_load*time_to_load_file + multiplier_file_evicted*time_to_reload_evicted_files))
					n = n->next;
				}
			}
			
			//~ j->transfer_time = choosen_time_to_load_file
					
			//~ # 3. Choose a core
			//~ choosen_core = choosen_node.cores[0:j->cores]

			//~ # 4. Get start time and update available times of the cores
			//~ # start_time = get_start_time_and_update_avail_times_of_cores(t, choosen_core, j->walltime) 
			//~ start_time = min_time
			
			//~ # 5. Update jobs info and add job in choosen cores
			//~ j->node_used = choosen_node
			//~ j->cores_used = choosen_core
			//~ j->start_time = start_time
			//~ j->end_time = start_time + j->walltime
			
			//~ # Test intervals. Need to add here for current scheduling
			//~ found = False
			//~ for d in choosen_node.data:
				//~ if d.unique_id == j->data:
					//~ found = True
					//~ d.temp_interval_usage_time.append(j->start_time)
					//~ d.temp_interval_usage_time.append(j->start_time + j->transfer_time)
					//~ d.temp_interval_usage_time.append(j->end_time)
					//~ # ~ print("After add interval is:", d.temp_interval_usage_time)
					//~ break
			//~ if found == False:
				//~ # ~ print("Need to create intervals for the node", choosen_node.unique_id, "data", j->data)
				//~ # Create a class Data for this node
				//~ d = Data(j->data, -1, -1, 0, [j->start_time, j->start_time + j->transfer_time, j->end_time], j->data_size)
				//~ # ~ print("After add interval is:", d.temp_interval_usage_time)
				//~ choosen_node.data.append(d)
				//~ # ~ exit(1)
			//~ # ~ print
					
			//~ for c in choosen_core:
				//~ c.job_queue.append(j)
								
				//~ # Test reduced complexity
				//~ if c.available_time <= t:
					//~ nb_non_available_cores += 1
					
				//~ c.available_time = start_time + j->walltime
				
			/* Need to sort cores after each schedule of a job. */
			sort_cores_by_available_time_in_specific_node(j->node_used);
										
			#ifdef PRINT
			print_decision_in_scheduler(j);
			#endif
			
			/* Insert in start times. */
			insert_next_time_in_sorted_list(start_times, j->start_time);
			
			j = j->next;
		}				
		else
		{
			break;
		}
	}
	
	#ifdef PRINT_SCORES_DATA
	fclose(f_fcfs_score);
	#endif
	exit(1);
}
