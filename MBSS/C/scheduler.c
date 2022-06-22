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
	float time_to_reload_evicted_files = 0;
	int nb_copy_file_to_load = 0;
	int time_already_checked = 0;
	int score = 0;
	int min_time = 0;
	int choosen_time_to_load_file = 0;
	bool found = false;
	
	/* Get intervals of data. */ 
	get_current_intervals(head_node, t);
	
	#ifdef PRINT
	print_data_intervals(head_node, t);
	#endif
	
	#ifdef PRINT_SCORES_DATA
	FILE* f_fcfs_score = fopen("outputs/Scores_data.txt", "a");
	#endif
	
	/* 1. Loop on available jobs. */
	struct Job* j = head_job;
	while (j != NULL)
	{	
		if (nb_non_available_cores < nb_cores)
		{	
			#ifdef PRINT
			printf("There are %d/%d available cores.\n", nb_cores - nb_non_available_cores, nb_cores);			
			printf("\nNeed to schedule job %d using file %d.\n", j->unique_id, j->data); fflush(stdout);
			#endif
			
			/* 2. Choose a node. */		
			/* Reset some values. */					
			min_score = -1;
			earliest_available_time = 0;
			first_node_size_to_choose_from = 0;
			last_node_size_to_choose_from = 0;
			is_being_loaded = false;
			time_to_reload_evicted_files = 0;
			nb_copy_file_to_load = 0;
			
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
			
			/* For the number of valid copy of a data on other nodes. I add in this list the times I already checked for current job. */
			struct Time_Already_Checked_Nb_of_Copy_List* time_already_checked_nb_of_copy_list = (struct Time_Already_Checked_Nb_of_Copy_List*) malloc(sizeof(struct Time_Already_Checked_Nb_of_Copy_List));
			time_already_checked_nb_of_copy_list->head = NULL;
			
			for (i = first_node_size_to_choose_from; i <= last_node_size_to_choose_from; i++)
			{
				struct Node* n = head_node[i]->head;
				while (n != NULL)
				{	
					#ifdef PRINT
					printf("On node %d?\n", n->unique_id); fflush(stdout);
					#endif
					
					/* 2.1. A = Get the earliest available time from the number of cores required by the job and add it to the score. */
					earliest_available_time = n->cores[j->cores - 1]->available_time; /* -1 because tab start at 0 */
					if (earliest_available_time < t) /* A core can't be available before t. This happens when a node is idling. */				
					{
						earliest_available_time = t;
					}
					
					#ifdef PRINT
					printf("A: EAT is: %d.\n", earliest_available_time); fflush(stdout);
					#endif
					
					if (min_score == -1 || earliest_available_time < min_score)
					{
						/* 2.2. B = Compute the time to load all data. For this look at the data that will be available at the earliest available time of the node. */
						if (j->data == 0)
						{
							time_to_load_file = 0;
						}
						else
						{
							time_to_load_file = is_my_file_on_node_at_certain_time_and_transfer_time(earliest_available_time, n, t, j->data, j->data_size, &is_being_loaded); /* Use the intervals in each data to get this info. */
						}
						
						#ifdef PRINT
						printf("B: Time to load file: %d. Is being loaded? %d.\n", time_to_load_file, is_being_loaded); fflush(stdout);
						#endif
											
						if (min_score == -1 || earliest_available_time + multiplier_file_to_load*time_to_load_file < min_score)
						{
							/* 2.5. Get the amount of files that will be lost because of this load by computing the amount of data that end at the earliest time only on the supposely choosen cores, excluding current file of course. */
							if (multiplier_file_evicted == 0)
							{
								time_to_reload_evicted_files = 0;
							}
							else
							{
								time_to_reload_evicted_files = time_to_reload_percentage_of_files_ended_at_certain_time(earliest_available_time, n, j->data, j->cores/20);
							}
							
							#ifdef PRINT
							printf("C: Time to reload evicted files %f.\n", time_to_reload_evicted_files); fflush(stdout);
							#endif
							
							if (min_score == -1 || earliest_available_time + multiplier_file_to_load*time_to_load_file + multiplier_file_evicted*time_to_reload_evicted_files < min_score)
							{
								/* 2.5bis Get number of copy of the file we want to load on other nodes (if you need to load a file that is) at the time that is predicted to be used. So if a file is already loaded on a lot of node, you have a penalty if you want to load it on a new node. */
								if (time_to_load_file != 0 && is_being_loaded == false && multiplier_nb_copy != 0)
								{
									/* Did I already try this time with this job ? */
									time_already_checked = was_time_already_checked_for_nb_copy(earliest_available_time, time_already_checked_nb_of_copy_list);
									if (time_already_checked == -1)
									{
										#ifdef PRINT
										printf("Need to compute nb of copy it was never done.\n"); fflush(stdout);
										#endif
										
										nb_copy_file_to_load = get_nb_valid_copy_of_a_file(earliest_available_time, head_node, j->data);															
										create_and_insert_head_time_already_checked_nb_of_copy_list(time_already_checked_nb_of_copy_list, earliest_available_time, nb_copy_file_to_load);
									}
									else
									{
										nb_copy_file_to_load = time_already_checked;
										
										#ifdef PRINT
										printf("Already done for job %d at time %d so nb of copy is %d.\n", j->unique_id, earliest_available_time, nb_copy_file_to_load); fflush(stdout);
										#endif
									}
								}
								else
								{
									nb_copy_file_to_load = 0;
								}
								
								#ifdef PRINT
								printf("Nb of copy for data %d at time %d on node %d is %d.\n", j->data, earliest_available_time, n->unique_id, nb_copy_file_to_load); fflush(stdout);
								#endif
								
								/* Compute node's score. */
								score = earliest_available_time + multiplier_file_to_load*time_to_load_file + multiplier_file_evicted*time_to_reload_evicted_files + nb_copy_file_to_load*time_to_load_file*multiplier_nb_copy;
								
								#ifdef PRINT		
								printf("Score for job %d is %d (EAT: %d + TL %d + TRL %f +NCP %d) with node %d.\n", j->unique_id, score, earliest_available_time, multiplier_file_to_load*time_to_load_file, multiplier_file_evicted*time_to_reload_evicted_files, nb_copy_file_to_load*time_to_load_file*multiplier_nb_copy, n->unique_id); fflush(stdout);
								#endif
													
								/* 2.6. Get minimum score/ */
								if (min_score == -1)
								{
									min_time = earliest_available_time;
									min_score = score;
									j->node_used = n;
									choosen_time_to_load_file = time_to_load_file;
								}
								else if (min_score > score)
								{
									min_time = earliest_available_time;
									min_score = score;
									j->node_used = n;
									choosen_time_to_load_file = time_to_load_file;
								}
							}
						}
					}
					
					#ifdef PRINT_SCORES_DATA
					fprintf(f_fcfs_score, "Node: %d EAT: %d C: %f CxX: %f Score: %f\n", n->unique_id, earliest_available_time, time_to_reload_evicted_files, time_to_reload_evicted_files*multiplier_file_evicted, earliest_available_time + multiplier_file_to_load*time_to_load_file + multiplier_file_evicted*time_to_reload_evicted_files);
					#endif
					
					n = n->next;
				}
			}
			
			j->transfer_time = choosen_time_to_load_file;
					
			/* Get start time and update available times of the cores. */
			j->start_time = min_time;
			j->end_time = min_time + j->walltime;
			
			for (int k = 0; k < j->cores; k++)
			{
				j->cores_used[k] = j->node_used->cores[k]->unique_id;
				if (j->node_used->cores[k]->available_time <= t)
				{
					nb_non_available_cores += 1;
				}
				j->node_used->cores[k]->available_time = min_time + j->walltime;
				
				/* Maybe I need job queue or not not sure. TODO. */
			}

			/* Need to add here intervals for current scheduling. */
			found = false;
			struct Data* d = j->node_used->data->head;
			while (d != NULL)
			{
				if (d->unique_id == j->data)
				{
					found = true;
					create_and_insert_tail_interval_list(d->intervals, j->start_time);
					create_and_insert_tail_interval_list(d->intervals, j->start_time + j->transfer_time);
					create_and_insert_tail_interval_list(d->intervals, j->end_time);
					break;
				}
				d = d->next;
			}
			
			if (found == false)
			{
				#ifdef PRINT
				printf("Need to create a data and intervals for the node %d data %d.\n", j->node_used->unique_id, j->data); fflush(stdout);
				#endif
				
				/* Create a class Data for this node. */
				struct Data* new = (struct Data*) malloc(sizeof(struct Data));
				new->next = NULL;
				new->unique_id = j->data;
				new->start_time = -1;
				new->end_time = -1;
				new->nb_task_using_it = 0;
				new->intervals = (struct Interval_List*) malloc(sizeof(struct Interval_List));
				new->intervals->head = NULL;
				new->intervals->tail = NULL;
				create_and_insert_tail_interval_list(new->intervals, j->start_time);
				create_and_insert_tail_interval_list(new->intervals, j->start_time + j->transfer_time);
				create_and_insert_tail_interval_list(new->intervals, j->end_time);
				new->size = j->data_size;
				insert_tail_data_list(j->node_used->data, new);
			}			
			
			#ifdef PRINT
			printf("After add interval are:\n"); fflush(stdout);
			print_data_intervals(head_node, t);
			#endif
			
			/* Need to sort cores after each schedule of a job. */
			sort_cores_by_available_time_in_specific_node(j->node_used);
										
			// #ifdef PRINT
			// print_decision_in_scheduler(j);
			// #endif
						
			/* Insert in start times. */
			insert_next_time_in_sorted_list(start_times, j->start_time);
			
			/* Free time already checked. */
			free_time_already_checked_nb_of_copy_linked_list(&time_already_checked_nb_of_copy_list->head);

			j = j->next;
		}				
		else
		{
			#ifdef PRINT
			printf("No more available cores.\n"); fflush(stdout);
			#endif
			
			break;
		}
	}

	#ifdef PRINT_SCORES_DATA
	fclose(f_fcfs_score);
	#endif
}
