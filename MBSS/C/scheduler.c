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
		if(j->delay <= 0)
		{
			j->delay = 1;
		}
		j->walltime -= time_since_start;
		if(j->walltime <= 0)
		{
			j->walltime = 1;
		}
		
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
				
		schedule_job_specific_node_at_earliest_available_time(j, choosen_node, t);
		nb_job_to_delete += 1;
		
		/* Add in list of starting times. */		
		insert_next_time_in_sorted_list(start_times, j->start_time);
		
		#ifdef PRINT
		print_decision_in_scheduler(j);
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

void fcfs_scheduler(struct Job* head_job, struct Node_List** head_node, int t, bool use_bigger_nodes)
{
	#ifdef PRINT
	printf("Start fcfs scheduler. Use bigger nodes: %d.\n", use_bigger_nodes);
	#endif
		
	int nb_non_available_cores = get_nb_non_available_cores(node_list, t);

	struct Job* j = head_job;
	while (j != NULL)
	{
		if (nb_non_available_cores < nb_cores)
		{
			#ifdef PRINT
			printf("There are %d/%d available cores.\n", nb_cores - nb_non_available_cores, nb_cores);
			#endif
			
			nb_non_available_cores = schedule_job_on_earliest_available_cores(j, head_node, t, nb_non_available_cores, use_bigger_nodes);
			
			insert_next_time_in_sorted_list(start_times, j->start_time);
			
			j = j->next;
		}
		else
		{
			#ifdef PRINT
			printf("There are %d/%d available cores.\n", nb_cores - nb_non_available_cores, nb_cores);
			#endif
			
			break;
		}
	}
}

void fcfs_easybf_scheduler(struct Job* head_job, struct Node_List** head_node, int t, bool use_bigger_nodes)
{
	#ifdef PRINT
	printf("Start fcfs easybf scheduler. Use bigger nodes: %d.\n", use_bigger_nodes);
	#endif
	
	int nb_running_cores = running_cores;
	
	#ifdef PRINT
	printf("Nb of running cores before j1: %d.\n", nb_running_cores);
	#endif
	
	/* First schedule J_1. */
	struct Job* j1 = head_job;
	nb_running_cores = schedule_job_on_earliest_available_cores_return_running_cores(j1, head_node, t, nb_running_cores, use_bigger_nodes);
	insert_next_time_in_sorted_list(start_times, j1->start_time);
	
	#ifdef PRINT
	printf("Nb of running cores after j1: %d.\n", nb_running_cores);
	#endif
	
	bool result = false;
	struct Job* j = j1->next;

	while (j != NULL)
	{
		if (nb_running_cores < nb_cores)
		{
			#ifdef PRINT
			printf("There are %d/%d running cores.\n", nb_running_cores, nb_cores);
			#endif
			
			result = false;
			
			nb_running_cores = try_to_start_job_immediatly_without_delaying_j1(j, j1, head_node, nb_running_cores, &result, use_bigger_nodes, t);
			
			if (result == true)
			{
				insert_next_time_in_sorted_list(start_times, j->start_time);
			}
			
			#ifdef PRINT
			printf("Nb of running cores after starting (or not: %d) Job %d: %d.\n", result, j->unique_id, nb_running_cores);
			#endif
			
			j = j->next;
		}
		else
		{
			#ifdef PRINT
			printf("There are %d/%d running cores.\n", nb_running_cores, nb_cores);
			#endif
			
			break;
		}
	}
}

void fcfs_with_a_score_easybf_scheduler(struct Job* head_job, struct Node_List** head_node, int t, int multiplier_file_to_load, int multiplier_file_evicted, int multiplier_nb_copy)
{
	#ifdef PRINT
	printf("Start fcfs with a score easybf scheduler.\n");
	#endif
	
	int nb_running_cores = running_cores;
	
	#ifdef PRINT
	printf("Nb of running cores before j1: %d.\n", nb_running_cores);
	#endif
	
	/* First schedule J_1. */
	struct Job* j1 = head_job;
	nb_running_cores = schedule_job_fcfs_score_return_running_cores(j1, head_node, t, nb_running_cores, multiplier_file_to_load, multiplier_file_evicted, multiplier_nb_copy);
	insert_next_time_in_sorted_list(start_times, j1->start_time);
	
	#ifdef PRINT
	printf("Nb of running cores after j1: %d.\n", nb_running_cores);
	#endif
	
	bool result = false;
	struct Job* j = j1->next;

	while (j != NULL)
	{
		if (nb_running_cores < nb_cores)
		{
			#ifdef PRINT
			printf("There are %d/%d running cores.\n", nb_running_cores, nb_cores);
			#endif
			
			result = false;
			
			nb_running_cores = try_to_start_job_immediatly_fcfs_score_without_delaying_j1(j, j1, head_node, nb_running_cores, &result, t, multiplier_file_to_load, multiplier_file_evicted, multiplier_nb_copy);
			
			if (result == true)
			{
				insert_next_time_in_sorted_list(start_times, j->start_time);
			}
			#ifdef PRINT
			printf("Nb of running cores after starting (or not: %d) Job %d: %d.\n", result, j->unique_id, nb_running_cores);
			#endif
			j = j->next;
		}
		else
		{
			#ifdef PRINT
			printf("There are %d/%d running cores.\n", nb_running_cores, nb_cores);
			#endif
			
			break;
		}
	}
}

void fcfs_with_a_score_scheduler(struct Job* head_job, struct Node_List** head_node, int t, int multiplier_file_to_load, int multiplier_file_evicted, int multiplier_nb_copy)
{
	int nb_non_available_cores = get_nb_non_available_cores(node_list, t);		
	int i = 0;
	long long min_score = -1;
	int earliest_available_time = 0;
	int first_node_size_to_choose_from = 0;
	int last_node_size_to_choose_from = 0;
	int time_to_load_file = 0;
	bool is_being_loaded = false;
	float time_to_reload_evicted_files = 0;
	int nb_copy_file_to_load = 0;
	int time_or_data_already_checked = 0;
	long long score = 0;
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
	
	/* --- Reduced complexity nb of copy --- */	
	//~ if (multiplier_nb_copy != 0)
	//~ {
		struct Time_or_Data_Already_Checked_Nb_of_Copy_List* time_or_data_already_checked_nb_of_copy_list = (struct Time_or_Data_Already_Checked_Nb_of_Copy_List*) malloc(sizeof(struct Time_or_Data_Already_Checked_Nb_of_Copy_List));
		time_or_data_already_checked_nb_of_copy_list->head = NULL;
	//~ }

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
			
			/* --- Normal complexity nb of copy --- */		
			/* For the number of valid copy of a data on other nodes. I add in this list the times I already checked for current job. */
			//~ struct Time_or_Data_Already_Checked_Nb_of_Copy_List* time_or_data_already_checked_nb_of_copy_list = (struct Time_or_Data_Already_Checked_Nb_of_Copy_List*) malloc(sizeof(struct Time_or_Data_Already_Checked_Nb_of_Copy_List));
			//~ time_or_data_already_checked_nb_of_copy_list->head = NULL;
			
			/* --- Reduced complexity nb of copy --- */
			if (multiplier_nb_copy != 0)
			{
				time_or_data_already_checked = was_time_or_data_already_checked_for_nb_copy(j->data, time_or_data_already_checked_nb_of_copy_list);
			}

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
									
									/* --- Normal complexity nb of copy --- */
									//~ time_or_data_already_checked = was_time_or_data_already_checked_for_nb_copy(earliest_available_time, time_or_data_already_checked_nb_of_copy_list);								
									//~ if (time_or_data_already_checked == -1)
									//~ {
										//~ #ifdef PRINT
										//~ printf("Need to compute nb of copy it was never done.\n"); fflush(stdout);
										//~ #endif
										//~ nb_copy_file_to_load = get_nb_valid_copy_of_a_file(earliest_available_time, head_node, j->data);
										//~ create_and_insert_head_time_or_data_already_checked_nb_of_copy_list(time_or_data_already_checked_nb_of_copy_list, earliest_available_time, nb_copy_file_to_load);
									//~ }
									//~ else
									//~ {
										//~ nb_copy_file_to_load = time_or_data_already_checked;
										//~ #ifdef PRINT
										//~ printf("Already done for job %d at time %d so nb of copy is %d.\n", j->unique_id, earliest_available_time, nb_copy_file_to_load); fflush(stdout);
										//~ #endif
									//~ }
									
									/* --- Reduced complexity nb of copy --- */
									if (time_or_data_already_checked == -1)
									{
										#ifdef PRINT
										printf("Need to compute nb of copy it was never done.\n");
										#endif
										nb_copy_file_to_load = get_nb_valid_copy_of_a_file(t, head_node, j->data);
										create_and_insert_head_time_or_data_already_checked_nb_of_copy_list(time_or_data_already_checked_nb_of_copy_list, j->data, nb_copy_file_to_load);
										time_or_data_already_checked = nb_copy_file_to_load;
										#ifdef PRINT
										printf("Compute nb of copy done, it's %d.\n", nb_copy_file_to_load);
										#endif
									}
									else
									{
										nb_copy_file_to_load = time_or_data_already_checked;
										#ifdef PRINT
										printf("Already done for job %d at time %d so nb of copy is %d.\n", j->unique_id, t, nb_copy_file_to_load);
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
								
								/* Je dépasse les int max ? */
								//~ if (score > 1000000000)
								//~ {
									//~ printf("Risque de dépasser les int max.\n");
									//~ exit(EXIT_FAILURE);
								//~ }
								
								#ifdef PRINT		
								printf("Score for job %d is %lld (EAT: %d + TL %d + TRL %f +NCP %d) with node %d.\n", j->unique_id, score, earliest_available_time, multiplier_file_to_load*time_to_load_file, multiplier_file_evicted*time_to_reload_evicted_files, nb_copy_file_to_load*time_to_load_file*multiplier_nb_copy, n->unique_id); fflush(stdout);
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
										
			#ifdef PRINT
			print_decision_in_scheduler(j);
			#endif
						
			/* Insert in start times. */
			insert_next_time_in_sorted_list(start_times, j->start_time);
			
			/* --- Normal complexity nb of copy --- */
			/* Free time already checked. */
			//~ free_time_or_data_already_checked_nb_of_copy_linked_list(&time_or_data_already_checked_nb_of_copy_list->head);
			
			/* --- Normal complexity nb of copy --- */
			/* Increment nb of copy for current file if we scheduled at time t the current job. */
			if (multiplier_nb_copy != 0 && j->start_time == t)
			{
				//~ printf("Need to increment for job %d Multi is %d.\n", j->unique_id, multiplier_nb_copy); fflush(stdout);
				increment_time_or_data_nb_of_copy_specific_time_or_data(time_or_data_already_checked_nb_of_copy_list, j->data);
				//~ printf("Increment ok for job %d.\n", j->unique_id); fflush(stdout);
			}
			
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
	
	/* --- Reduced complexity nb of copy --- */
	/* Free time already checked. */
	if (multiplier_nb_copy != 0)
	{
		free_time_or_data_already_checked_nb_of_copy_linked_list(&time_or_data_already_checked_nb_of_copy_list->head);
	}

	#ifdef PRINT_SCORES_DATA
	fclose(f_fcfs_score);
	#endif
}

/* TODO : pas besoin de sort a chaque fois. Do I do it ? */
void fcfs_scheduler_backfill_big_nodes(struct Job* head_job, struct Node_List** head_node, int t, int backfill_big_node_mode, int total_queue_time, int nb_finished_jobs)
{
	#ifdef PRINT
	printf("Start fcfs_scheduler_backfill_big_nodes. Mode is: %d.\n", backfill_big_node_mode);
	#endif
	
	int nb_non_available_cores = get_nb_non_available_cores(node_list, t);
	struct Job* j = head_job;
	bool result = false;
	int i = 0;
	
	while (j != NULL)
	{
		if (nb_non_available_cores < nb_cores)
		{
			#ifdef PRINT
			printf("There are %d/%d available cores.\n", nb_cores - nb_non_available_cores, nb_cores);
			#endif
			
			result = false;
			if (j->index_node_list != 2) /* TODO : pas sûr ça. */
			{
				i = j->index_node_list;
				while (result == false && i != 3)
				{
					#ifdef PRINT
					printf("Try to start immedialy (T=%d) job %d on node of category %d.\n", t, j->unique_id, i);
					#endif
					
					nb_non_available_cores = schedule_job_to_start_immediatly_on_specific_node_size(j, head_node[i], t, backfill_big_node_mode, total_queue_time, nb_finished_jobs, nb_non_available_cores, &result);
					i += 1;
				}
			}
			if (result == false)
			{
				#ifdef PRINT
				printf("Just schedule later job %d.\n", j->unique_id);
				#endif
				
				/* If we are here it means we failed to start the job anywhere or it's a job necessating the biggest nodes, so we need to schedule it now on it's corresponding node size (so the smallest one on which it fits). */
				nb_non_available_cores = schedule_job_on_earliest_available_cores_specific_sublist_node(j, head_node[j->index_node_list], t, nb_non_available_cores);
			}
			//~ exit(1);
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
	}
}
	
//~ void fcfs_scheduler_planned_area_filling(struct Job* head_job, struct Node_List** head_node, int t, long long Planned_Area[3][3])
void fcfs_scheduler_planned_area_filling(struct Job* head_job, struct Node_List** head_node, int t)
{
	// Care use long long for area!!
	#ifdef PRINT
	printf("Start of planned area filling.\n");
	printf("Planned areas are: [%lld, %lld, %lld] [%lld, %lld, %lld] [%lld, %lld, %lld]\n", Planned_Area[0][0], Planned_Area[0][1], Planned_Area[0][2], Planned_Area[1][0], Planned_Area[1][1], Planned_Area[1][2], Planned_Area[2][0], Planned_Area[2][1], Planned_Area[2][2]);
	#endif
	
	long long Temp_Planned_Area[3][3];
	int i = 0;
	int k = 0;
	
	for (i = 0; i < 3; i++)
	{
		for (k = 0; k < 3; k++)
		{
			Temp_Planned_Area[i][k] = Planned_Area[i][k];
		}
	}
		
	int next_size = 0;
	long long Area_j;
	int EAT = 0;
	int min_time = -1;
	int nb_non_available_cores = get_nb_non_available_cores(node_list, t);
	struct Job* j = head_job;
	int choosen_size = 0;
	struct Node* choosen_node = NULL; /* TODO: malloc ? */
	while (j != NULL)
	{
		if (nb_non_available_cores < nb_cores)
		{
			#ifdef PRINT
			printf("There are %d/%d available cores.\n", nb_cores - nb_non_available_cores, nb_cores);
			printf("Scheduling job %d.\n", j->unique_id);
			#endif
			
			min_time = -1;
			choosen_node = NULL;
			Area_j = j->cores*j->walltime;
			
			/* Get EAT on each node size. */
			for (next_size = j->index_node_list; next_size < 3; next_size++)
			{
				if (next_size == j->index_node_list || Temp_Planned_Area[next_size][j->index_node_list] - Area_j >= 0)
				{
					EAT = get_earliest_available_time_specific_sublist_node(j->cores, head_node[next_size], &choosen_node, t);
					
					#ifdef PRINT
					printf("EAT on node of size %d is %d.\n", next_size, EAT);
					#endif
					
					if (EAT == t)
					{
						#ifdef PRINT
						printf("EAT == t can break.\n");
						#endif
						
						min_time = EAT;
						choosen_size = next_size;
						j->node_used = choosen_node;
						break;
					}
					else if (EAT < min_time || min_time == -1)
					{
						min_time = EAT;
						choosen_size = next_size;
						j->node_used = choosen_node;
					}
				}
			}
			
			/* Schedule the job on said node size */
			/* Update infos on the job and on cores. */
			j->start_time = min_time;
			j->end_time = min_time + j->walltime;
			for (i = 0; i < j->cores; i++)
			{
				j->cores_used[i] = j->node_used->cores[i]->unique_id;
				if (j->node_used->cores[i]->available_time <= t)
				{
					nb_non_available_cores += 1;
				}
				j->node_used->cores[i]->available_time = min_time + j->walltime;
				
				/* Maybe I need job queue or not not sure. TODO. */
				// copy_job_and_insert_tail_job_list(n->cores[i]->job_queue, j);
			}
			
			/* Reduced corresponding Planned_Area */
			//~ if (next_size != j->index_node_list)
			if (choosen_size > j->index_node_list)
			{
				/* TODO do temp ... and real in start jobs ... */
				Temp_Planned_Area[choosen_size][j->index_node_list] -= Area_j;
			}
				
			#ifdef PRINT
			print_decision_in_scheduler(j);
			#endif
			
			/* Need to sort cores after each schedule of a job. */
			sort_cores_by_available_time_in_specific_node(j->node_used);
		
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
	}
}

void fcfs_scheduler_ratio_area_filling(struct Job* head_job, struct Node_List** head_node, int t, float Ratio_Area[3][3])
{
	// Care use long long for area!!
	#ifdef PRINT
	printf("Start of ratio area filling.\n");
	printf("Ratio areas are: [%f, %f, %f] [%f, %f, %f] [%f, %f, %f]\n", Ratio_Area[0][0], Ratio_Area[0][1], Ratio_Area[0][2], Ratio_Area[1][0], Ratio_Area[1][1], Ratio_Area[1][2], Ratio_Area[2][0], Ratio_Area[2][1], Ratio_Area[2][2]);
	printf("Allocated areas are: [%lld, %lld, %lld] [%lld, %lld, %lld] [%lld, %lld, %lld]\n", Allocated_Area[0][0], Allocated_Area[0][1], Allocated_Area[0][2], Allocated_Area[1][0], Allocated_Area[1][1], Allocated_Area[1][2], Allocated_Area[2][0], Allocated_Area[2][1], Allocated_Area[2][2]);
	#endif
	
	long long Temp_Allocated_Area[3][3];
	int i = 0;
	int k = 0;
	
	for (i = 0; i < 3; i++)
	{
		for (k = 0; k < 3; k++)
		{
			Temp_Allocated_Area[i][k] = Allocated_Area[i][k];
		}
	}
	
	int next_size = 0;
	long long Area_j;
	int EAT = 0;
	int min_time = -1;
	int nb_non_available_cores = get_nb_non_available_cores(node_list, t);
	struct Job* j = head_job;
	int choosen_size = 0;
	struct Node* choosen_node = NULL; /* TODO: malloc ? */
	while (j != NULL)
	{
		if (nb_non_available_cores < nb_cores)
		{
			#ifdef PRINT
			printf("There are %d/%d available cores.\n", nb_cores - nb_non_available_cores, nb_cores);
			printf("Scheduling job %d.\n", j->unique_id);			
			printf("Temp allocated areas are: [%lld, %lld, %lld] [%lld, %lld, %lld] [%lld, %lld, %lld]\n", Temp_Allocated_Area[0][0], Temp_Allocated_Area[0][1], Temp_Allocated_Area[0][2], Temp_Allocated_Area[1][0], Temp_Allocated_Area[1][1], Temp_Allocated_Area[1][2], Temp_Allocated_Area[2][0], Temp_Allocated_Area[2][1], Temp_Allocated_Area[2][2]);
			#endif
			
			min_time = -1;
			choosen_node = NULL;
			Area_j = j->cores*j->walltime;
			
			/* Get EAT on each node size. */
			for (next_size = j->index_node_list; next_size < 3; next_size++)
			{
				#ifdef PRINT
				printf("%f*%d - %lld - %lld >= 0 ?\n", Ratio_Area[next_size][j->index_node_list], t, Temp_Allocated_Area[next_size][j->index_node_list], Area_j);
				#endif
				
				if (next_size == j->index_node_list || Ratio_Area[next_size][j->index_node_list]*t - Temp_Allocated_Area[next_size][j->index_node_list] - Area_j >= 0)
				{
					EAT = get_earliest_available_time_specific_sublist_node(j->cores, head_node[next_size], &choosen_node, t);
					
					#ifdef PRINT
					printf("EAT on node of size %d is %d.\n", next_size, EAT);
					#endif
					
					if (EAT == t)
					{
						#ifdef PRINT
						printf("EAT == t can break.\n");
						#endif
						
						min_time = EAT;
						choosen_size = next_size;
						j->node_used = choosen_node;
						break;
					}
					else if (EAT < min_time || min_time == -1)
					{
						min_time = EAT;
						choosen_size = next_size;
						j->node_used = choosen_node;
					}
				}
			}
			
			/* Schedule the job on said node size */
			/* Update infos on the job and on cores. */
			j->start_time = min_time;
			j->end_time = min_time + j->walltime;
			for (i = 0; i < j->cores; i++)
			{
				j->cores_used[i] = j->node_used->cores[i]->unique_id;
				if (j->node_used->cores[i]->available_time <= t)
				{
					nb_non_available_cores += 1;
				}
				j->node_used->cores[i]->available_time = min_time + j->walltime;
				
				/* Maybe I need job queue or not not sure. TODO. */
				// copy_job_and_insert_tail_job_list(n->cores[i]->job_queue, j);
			}
			
			/* increment temp allocated area */
			if (choosen_size > j->index_node_list)
			{
				Temp_Allocated_Area[choosen_size][j->index_node_list] += Area_j;
			}
				
			#ifdef PRINT
			print_decision_in_scheduler(j);
			#endif
			
			/* Need to sort cores after each schedule of a job. */
			sort_cores_by_available_time_in_specific_node(j->node_used);
		
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
	}
}

/** Différence avec fcfs with a score classique:
 * Je regarde le score de tous les noeuds pour calculer le percentile, donc pas de if pour voir si le score en cours à une chance d'être meilleur.
 * Tableau pour ranger les score de chaque noeud calculé
 * Calcul du 95th percentile
 * Récupérer le best score dans chaque catégorie de taille de noeuds.
 * Plus besoin de get le minimum score après chaque calcul de score
 **/
void fcfs_with_a_score_backfill_big_nodes_95th_percentile_scheduler(struct Job* head_job, struct Node_List** head_node, int t, int multiplier_file_to_load, int multiplier_file_evicted, int multiplier_nb_copy, int number_node_size_128_and_more, int number_node_size_256_and_more, int number_node_size_1024)
{
	int nb_non_available_cores = get_nb_non_available_cores(node_list, t);		
	int i = 0;
	//~ int min_score = -1;
	int earliest_available_time = 0;
	int first_node_size_to_choose_from = 0;
	int last_node_size_to_choose_from = 0;
	int time_to_load_file = 0;
	bool is_being_loaded = false;
	float time_to_reload_evicted_files = 0;
	int nb_copy_file_to_load = 0;
	int time_or_data_already_checked = 0;
	long long score = 0;
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
	
	/* --- Reduced complexity nb of copy --- */	
	struct Time_or_Data_Already_Checked_Nb_of_Copy_List* time_or_data_already_checked_nb_of_copy_list = (struct Time_or_Data_Already_Checked_Nb_of_Copy_List*) malloc(sizeof(struct Time_or_Data_Already_Checked_Nb_of_Copy_List));
	time_or_data_already_checked_nb_of_copy_list->head = NULL;

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
			//~ min_score = -1;
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
						
			/* --- Reduced complexity nb of copy --- */
			if (multiplier_nb_copy != 0)
			{
				time_or_data_already_checked = was_time_or_data_already_checked_for_nb_copy(j->data, time_or_data_already_checked_nb_of_copy_list);
			}
			
			/* Tab pour ranger tout les scores */
			int nb_nodes_evaluated = 0;
			long long min_score_nodes_128 = -1;
			long long min_score_nodes_256 = -1;
			long long min_score_nodes_1024 = -1;
			int min_time_nodes_128 = 0;
			int min_time_nodes_256 = 0;
			int min_time_nodes_1024 = 0;
			struct Node* node_used_nodes_128 = NULL;
			struct Node* node_used_nodes_256 = NULL;
			struct Node* node_used_nodes_1024 = NULL;
			int choosen_time_to_load_file_nodes_128 = 0;
			int choosen_time_to_load_file_nodes_256 = 0;
			int choosen_time_to_load_file_nodes_1024 = 0;
			if (j->index_node_list == 0)
			{
				nb_nodes_evaluated = number_node_size_128_and_more;
			}
			else if (j->index_node_list == 1)
			{
				nb_nodes_evaluated = number_node_size_256_and_more;
			}
			else
			{
				nb_nodes_evaluated = number_node_size_1024;
			}
			long long* tab_scores_all_nodes = malloc(sizeof(long long)*nb_nodes_evaluated);
			
			/* Compteur score calculé actuel */
			int index_current_evaluated_node = 0;
			
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
					
					//~ if (min_score == -1 || earliest_available_time < min_score)
					//~ {
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
											
						//~ if (min_score == -1 || earliest_available_time + multiplier_file_to_load*time_to_load_file < min_score)
						//~ {
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
							
							//~ if (min_score == -1 || earliest_available_time + multiplier_file_to_load*time_to_load_file + multiplier_file_evicted*time_to_reload_evicted_files < min_score)
							//~ {
								/* 2.5bis Get number of copy of the file we want to load on other nodes (if you need to load a file that is) at the time that is predicted to be used. So if a file is already loaded on a lot of node, you have a penalty if you want to load it on a new node. */
								if (time_to_load_file != 0 && is_being_loaded == false && multiplier_nb_copy != 0)
								{									
									/* --- Reduced complexity nb of copy --- */
									if (time_or_data_already_checked == -1)
									{
										#ifdef PRINT
										printf("Need to compute nb of copy it was never done.\n");
										#endif
										nb_copy_file_to_load = get_nb_valid_copy_of_a_file(t, head_node, j->data);
										create_and_insert_head_time_or_data_already_checked_nb_of_copy_list(time_or_data_already_checked_nb_of_copy_list, j->data, nb_copy_file_to_load);
										time_or_data_already_checked = nb_copy_file_to_load;
										#ifdef PRINT
										printf("Compute nb of copy done, it's %d.\n", nb_copy_file_to_load);
										#endif
									}
									else
									{
										nb_copy_file_to_load = time_or_data_already_checked;
										#ifdef PRINT
										printf("Already done for job %d at time %d so nb of copy is %d.\n", j->unique_id, t, nb_copy_file_to_load);
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
								printf("Score for job %d is %lld (EAT: %d + TL %d + TRL %f +NCP %d) with node %d.\n", j->unique_id, score, earliest_available_time, multiplier_file_to_load*time_to_load_file, multiplier_file_evicted*time_to_reload_evicted_files, nb_copy_file_to_load*time_to_load_file*multiplier_nb_copy, n->unique_id); fflush(stdout);
								#endif
													
								//~ /* 2.6. Get minimum score/ */
								//~ if (min_score == -1)
								//~ {
									//~ min_time = earliest_available_time;
									//~ min_score = score;
									//~ j->node_used = n;
									//~ choosen_time_to_load_file = time_to_load_file;
								//~ }
								//~ else if (min_score > score)
								//~ {
									//~ min_time = earliest_available_time;
									//~ min_score = score;
									//~ j->node_used = n;
									//~ choosen_time_to_load_file = time_to_load_file;
								//~ }
								
								/* update by category */
								if (n->memory == 128 && (score < min_score_nodes_128 || min_score_nodes_128 == -1))
								{
									min_score_nodes_128 = score;
									min_time_nodes_128 = earliest_available_time;
									node_used_nodes_128 = n;
									choosen_time_to_load_file_nodes_128 = time_to_load_file;
									//~ printf("%d is a new best score for the size 128.\n", score);
								}
								else if (n->memory == 256 && (score < min_score_nodes_256 || min_score_nodes_256 == -1))
								{
									min_score_nodes_256 = score;
									min_time_nodes_256 = earliest_available_time;
									node_used_nodes_256 = n;
									choosen_time_to_load_file_nodes_256 = time_to_load_file;
									//~ printf("%d is a new best score for the size 256.\n", score);
								}
								else if (n->memory == 1024 && (score < min_score_nodes_1024 || min_score_nodes_1024 == -1))
								{
									min_score_nodes_1024 = score;
									min_time_nodes_1024 = earliest_available_time;
									node_used_nodes_1024 = n;
									choosen_time_to_load_file_nodes_1024 = time_to_load_file;
									//~ printf("%d is a new best score for the size 1024.\n", score);
								}
								
								/* Add score in tab with all scores */
								//~ printf("Adding %d to the score tab.\n", score);
								tab_scores_all_nodes[index_current_evaluated_node] = score;
								index_current_evaluated_node += 1;
							//~ }
						//~ }
					//~ }
					
					#ifdef PRINT_SCORES_DATA
					fprintf(f_fcfs_score, "Node: %d EAT: %d C: %f CxX: %f Score: %f\n", n->unique_id, earliest_available_time, time_to_reload_evicted_files, time_to_reload_evicted_files*multiplier_file_evicted, earliest_available_time + multiplier_file_to_load*time_to_load_file + multiplier_file_evicted*time_to_reload_evicted_files);
					#endif
					
					n = n->next;
				}
			}
			//~ exit(1);
			
			/* Computing 95th percentile */
			double result_percentile_computation = 0;
			if (j->index_node_list != 2)
			{
				sort_tab_of_int_decreasing_order(tab_scores_all_nodes, nb_nodes_evaluated);
				//~ printf("Tab of scores after sort by decreasing order is: ");
				//~ print_tab_of_int(tab_scores_all_nodes, nb_nodes_evaluated);
				
				double percentile = 95;
				double fractional_rank = 0;
				fractional_rank = (percentile/100.0)*(nb_nodes_evaluated);
				//~ printf("fractional_rank: %f = (%f/100.0)*(%d)\n", fractional_rank, percentile, nb_nodes_evaluated);
				int index = ceil(fractional_rank) - 1;
				//~ printf("Index of the tab for the 95yh percentile is %d.\n", index);
				result_percentile_computation = tab_scores_all_nodes[index];
				//~ printf("result_percentile_computation: %f\n", result_percentile_computation);
			}
			if (j->index_node_list == 0)
			{
				if (min_score_nodes_128 <= result_percentile_computation)
				{
					j->node_used = node_used_nodes_128;
					min_time = min_time_nodes_128;
					choosen_time_to_load_file = choosen_time_to_load_file_nodes_128;
					//~ printf("Choosen score %d is from a 128 node.\n", min_score_nodes_128);
				}
				else if (min_score_nodes_256 <= result_percentile_computation)
				{
					j->node_used = node_used_nodes_256;
					min_time = min_time_nodes_256;
					choosen_time_to_load_file = choosen_time_to_load_file_nodes_256;
					//~ printf("Choosen score %d is from a 256 node.\n", min_score_nodes_256);
				}
				else if (min_score_nodes_1024 <= result_percentile_computation)
				{
					j->node_used = node_used_nodes_1024;
					min_time = min_time_nodes_1024;
					choosen_time_to_load_file = choosen_time_to_load_file_nodes_1024;
					//~ printf("Choosen score %d is from a 1024 node.\n", min_score_nodes_1024);
				}
				else
				{
					j->node_used = node_used_nodes_128;
					min_time = min_time_nodes_128;
					choosen_time_to_load_file = choosen_time_to_load_file_nodes_128;
					//~ printf("Choosen score %d is from a 128 node but is not in the 95th percentile.\n", min_score_nodes_128);
				}
			}
			else if (j->index_node_list == 1)
			{
				if (min_score_nodes_256 <= result_percentile_computation)
				{
					j->node_used = node_used_nodes_256;
					min_time = min_time_nodes_256;
					choosen_time_to_load_file = choosen_time_to_load_file_nodes_256;
					//~ printf("Choosen score %d is from a 256 node.\n", min_score_nodes_256);
				}
				else if (min_score_nodes_1024 <= result_percentile_computation)
				{
					j->node_used = node_used_nodes_1024;
					min_time = min_time_nodes_1024;
					choosen_time_to_load_file = choosen_time_to_load_file_nodes_1024;
					//~ printf("Choosen score %d is from a 1024 node.\n", min_score_nodes_1024);
				}
				else
				{
					j->node_used = node_used_nodes_256;
					min_time = min_time_nodes_256;
					choosen_time_to_load_file = choosen_time_to_load_file_nodes_256;
					//~ printf("Choosen score %d is from a 256 node but is not in the 95th percentile.\n", min_score_nodes_256);
				}
			}
			else
			{
				j->node_used = node_used_nodes_1024;
				min_time = min_time_nodes_1024;
				choosen_time_to_load_file = choosen_time_to_load_file_nodes_1024;
				//~ printf("Choosen score %d is from a 1024 but so does the job's file so I just don't check the percentile anyway.\n", min_score_nodes_1024);
			}
			free(tab_scores_all_nodes); /* ? */
			//~ exit(1);
			
			/* Updating values for the job once the node was choosen. */
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
										
			#ifdef PRINT
			print_decision_in_scheduler(j);
			#endif
						
			/* Insert in start times. */
			insert_next_time_in_sorted_list(start_times, j->start_time);
			
			/* --- Normal complexity nb of copy --- */
			/* Free time already checked. */
			//~ free_time_or_data_already_checked_nb_of_copy_linked_list(&time_or_data_already_checked_nb_of_copy_list->head);
			
			/* --- Normal complexity nb of copy --- */
			/* Increment nb of copy for current file if we scheduled at time t the current job. */
			if (multiplier_nb_copy != 0 && j->start_time == t)
			{
				//~ printf("Need to increment for job %d Multi is %d.\n", j->unique_id, multiplier_nb_copy); fflush(stdout);
				increment_time_or_data_nb_of_copy_specific_time_or_data(time_or_data_already_checked_nb_of_copy_list, j->data);
				//~ printf("Increment ok for job %d.\n", j->unique_id); fflush(stdout);
			}
			
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
	
	/* --- Reduced complexity nb of copy --- */
	/* Free time already checked. */
	if (multiplier_nb_copy != 0)
	{
		free_time_or_data_already_checked_nb_of_copy_linked_list(&time_or_data_already_checked_nb_of_copy_list->head);
	}

	#ifdef PRINT_SCORES_DATA
	fclose(f_fcfs_score);
	#endif
}

/** What is unique here:
 * Tab of min score for each node size
 * Tab of min time used
 * Tab of node used created
 * Tab of choosen time to load file
 */
void fcfs_with_a_score_backfill_big_nodes_weighted_random_scheduler(struct Job* head_job, struct Node_List** head_node, int t, int multiplier_file_to_load, int multiplier_file_evicted, int multiplier_nb_copy)
{
	int nb_non_available_cores = get_nb_non_available_cores(node_list, t);		
	int i = 0;
	int random = 0;
	int node_size_choosen = 0;
	long long sum_best_scores = 0;
	long long* tab_min_score = malloc(sizeof(long long)*3);
	tab_min_score[0] = -1;
	tab_min_score[1] = -1;
	tab_min_score[2] = -1;
	int earliest_available_time = 0;
	int first_node_size_to_choose_from = 0;
	int last_node_size_to_choose_from = 0;
	int time_to_load_file = 0;
	bool is_being_loaded = false;
	float time_to_reload_evicted_files = 0;
	int nb_copy_file_to_load = 0;
	int time_or_data_already_checked = 0;
	long long score = 0;
	int* tab_min_time = malloc(sizeof(int)*3);
	tab_min_time[0] = 0;
	tab_min_time[1] = 0;
	tab_min_time[2] = 0;
	int* tab_choosen_time_to_load_file = malloc(sizeof(int)*3);
	tab_choosen_time_to_load_file[0] = 0;
	tab_choosen_time_to_load_file[1] = 0;
	tab_choosen_time_to_load_file[2] = 0;
	bool found = false;
	struct Node** tab_node_used = malloc(sizeof(struct Node)*3);
	tab_node_used[0] = NULL;
	tab_node_used[1] = NULL;
	tab_node_used[2] = NULL;
	
	/* Get intervals of data. */ 
	get_current_intervals(head_node, t);
	
	#ifdef PRINT
	print_data_intervals(head_node, t);
	#endif
	
	#ifdef PRINT_SCORES_DATA
	FILE* f_fcfs_score = fopen("outputs/Scores_data.txt", "a");
	#endif
	
	/* --- Reduced complexity nb of copy --- */	
	struct Time_or_Data_Already_Checked_Nb_of_Copy_List* time_or_data_already_checked_nb_of_copy_list = (struct Time_or_Data_Already_Checked_Nb_of_Copy_List*) malloc(sizeof(struct Time_or_Data_Already_Checked_Nb_of_Copy_List));
	time_or_data_already_checked_nb_of_copy_list->head = NULL;

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
			tab_min_score[0] = -1;
			tab_min_score[1] = -1;
			tab_min_score[2] = -1;
			tab_min_time[0] = 0;
			tab_min_time[1] = 0;
			tab_min_time[2] = 0;
			tab_choosen_time_to_load_file[0] = 0;
			tab_choosen_time_to_load_file[1] = 0;
			tab_choosen_time_to_load_file[2] = 0;
			earliest_available_time = 0;
			first_node_size_to_choose_from = 0;
			last_node_size_to_choose_from = 0;
			is_being_loaded = false;
			time_to_reload_evicted_files = 0;
			nb_copy_file_to_load = 0;
			tab_node_used[0] = NULL;
			tab_node_used[1] = NULL;
			tab_node_used[2] = NULL;
					
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
						
			/* --- Reduced complexity nb of copy --- */
			if (multiplier_nb_copy != 0)
			{
				time_or_data_already_checked = was_time_or_data_already_checked_for_nb_copy(j->data, time_or_data_already_checked_nb_of_copy_list);
			}

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
					
					if (tab_min_score[i] == -1 || earliest_available_time < tab_min_score[i])
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
											
						if (tab_min_score[i] == -1 || earliest_available_time + multiplier_file_to_load*time_to_load_file < tab_min_score[i])
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
							
							if (tab_min_score[i] == -1 || earliest_available_time + multiplier_file_to_load*time_to_load_file + multiplier_file_evicted*time_to_reload_evicted_files < tab_min_score[i])
							{
								/* 2.5bis Get number of copy of the file we want to load on other nodes (if you need to load a file that is) at the time that is predicted to be used. So if a file is already loaded on a lot of node, you have a penalty if you want to load it on a new node. */
								if (time_to_load_file != 0 && is_being_loaded == false && multiplier_nb_copy != 0)
								{							
									/* --- Reduced complexity nb of copy --- */
									if (time_or_data_already_checked == -1)
									{
										#ifdef PRINT
										printf("Need to compute nb of copy it was never done.\n");
										#endif
										nb_copy_file_to_load = get_nb_valid_copy_of_a_file(t, head_node, j->data);
										create_and_insert_head_time_or_data_already_checked_nb_of_copy_list(time_or_data_already_checked_nb_of_copy_list, j->data, nb_copy_file_to_load);
										time_or_data_already_checked = nb_copy_file_to_load;
										#ifdef PRINT
										printf("Compute nb of copy done, it's %d.\n", nb_copy_file_to_load);
										#endif
									}
									else
									{
										nb_copy_file_to_load = time_or_data_already_checked;
										#ifdef PRINT
										printf("Already done for job %d at time %d so nb of copy is %d.\n", j->unique_id, t, nb_copy_file_to_load);
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
								//~ printf("Score: %d = earliest_available_time + multiplier_file_to_load*time_to_load_file + multiplier_file_evicted*time_to_reload_evicted_files + nb_copy_file_to_load*time_to_load_file*multiplier_nb_copy);
								
								#ifdef PRINT		
								printf("Score for job %d is %lld (EAT: %d + TL %d + TRL %f +NCP %d) with node %d.\n", j->unique_id, score, earliest_available_time, multiplier_file_to_load*time_to_load_file, multiplier_file_evicted*time_to_reload_evicted_files, nb_copy_file_to_load*time_to_load_file*multiplier_nb_copy, n->unique_id); fflush(stdout);
								#endif
													
								/* 2.6. Get minimum score/ */
								if (tab_min_score[i] == -1)
								{
									tab_min_time[i] = earliest_available_time;
									tab_min_score[i] = score;
									tab_node_used[i] = n;
									tab_choosen_time_to_load_file[i] = time_to_load_file;
								}
								else if (tab_min_score[i] > score)
								{
									tab_min_time[i] = earliest_available_time;
									tab_min_score[i] = score;
									tab_node_used[i] = n;
									tab_choosen_time_to_load_file[i] = time_to_load_file;
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
			
			/* Choix aléatoire pondéré du meilleur noeud */
			sum_best_scores = 0;
			if (tab_min_score[0] != - 1)
			{
				sum_best_scores += tab_min_score[0];
			}
			if (tab_min_score[1] != - 1)
			{
				sum_best_scores += tab_min_score[1];
			}
			if (tab_min_score[2] != - 1)
			{
				sum_best_scores += tab_min_score[2];
			}
			//~ printf("Sum of best scores (ignoring -1): %d = %d + %d + %d.\n", sum_best_scores, tab_min_score[0], tab_min_score[1], tab_min_score[2]);
			random = rand()%sum_best_scores;
			//~ printf("Random 1 = %d.\n", random); 
			if (random < tab_min_score[0] || tab_min_score[0] == -1)
			{
				//~ printf("Eliminate size 0.\n");
				sum_best_scores = 0;
				if (tab_min_score[1] != - 1)
				{
					sum_best_scores += tab_min_score[1];
				}
				if (tab_min_score[2] != - 1)
				{
					sum_best_scores += tab_min_score[2];
				}
				//~ printf("Sum of best scores (ignoring -1): %d = %d + %d.\n", sum_best_scores, tab_min_score[1], tab_min_score[2]);
				random = rand()%sum_best_scores;
				//~ printf("Random 2 = %d.\n", random); 
				if (random < tab_min_score[1] || tab_min_score[1] == -1)
				{
					node_size_choosen = 2;
				}
				else
				{
					node_size_choosen = 1;
				}
			}
			else if (random < tab_min_score[0] + tab_min_score[1] || tab_min_score[1] == -1)
			{
				//~ printf("Eliminate size 1.\n");
				sum_best_scores = 0;
				if (tab_min_score[0] != - 1)
				{
					sum_best_scores += tab_min_score[0];
				}
				if (tab_min_score[2] != - 1)
				{
					sum_best_scores += tab_min_score[2];
				}
				//~ printf("Sum of best scores (ignoring -1): %d = %d + %d.\n", sum_best_scores, tab_min_score[0], tab_min_score[2]);
				random = rand()%sum_best_scores;
				//~ printf("Random 2 = %d.\n", random); 
				if (random < tab_min_score[0] || tab_min_score[0] == -1)
				{
					node_size_choosen = 2;
				}
				else
				{
					node_size_choosen = 0;
				}
			}
			else
			{
				//~ printf("Eliminate size 2.\n");
				sum_best_scores = 0;
				if (tab_min_score[0] != - 1)
				{
					sum_best_scores += tab_min_score[0];
				}
				if (tab_min_score[1] != - 1)
				{
					sum_best_scores += tab_min_score[1];
				}
				//~ printf("Sum of best scores (ignoring -1): %d = %d + %d.\n", sum_best_scores, tab_min_score[0], tab_min_score[1]);
				random = rand()%sum_best_scores;
				//~ printf("Random 2 = %d.\n", random); 
				if (random < tab_min_score[0] || tab_min_score[0] == -1)
				{
					node_size_choosen = 1;
				}
				else
				{
					node_size_choosen = 0;
				}
			}
			//~ printf("Choosen size is %d.\n", node_size_choosen);
			
			/* Penser à update j->node_used içi car je ne le fais pas plus haut ans ce cas. */
			j->node_used = tab_node_used[node_size_choosen];
			
			j->transfer_time = tab_choosen_time_to_load_file[node_size_choosen];
					
			/* Get start time and update available times of the cores. */
			j->start_time = tab_min_time[node_size_choosen];
			j->end_time = tab_min_time[node_size_choosen] + j->walltime;
			
			for (int k = 0; k < j->cores; k++)
			{
				j->cores_used[k] = j->node_used->cores[k]->unique_id;
				if (j->node_used->cores[k]->available_time <= t)
				{
					nb_non_available_cores += 1;
				}
				j->node_used->cores[k]->available_time = tab_min_time[node_size_choosen] + j->walltime;
				
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
										
			#ifdef PRINT
			print_decision_in_scheduler(j);
			#endif
						
			/* Insert in start times. */
			insert_next_time_in_sorted_list(start_times, j->start_time);
						
			/* --- Normal complexity nb of copy --- */
			/* Increment nb of copy for current file if we scheduled at time t the current job. */
			if (multiplier_nb_copy != 0 && j->start_time == t)
			{
				increment_time_or_data_nb_of_copy_specific_time_or_data(time_or_data_already_checked_nb_of_copy_list, j->data);
			}
			
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
	
	/* --- Reduced complexity nb of copy --- */
	/* Free time already checked. */
	if (multiplier_nb_copy != 0)
	{
		free_time_or_data_already_checked_nb_of_copy_linked_list(&time_or_data_already_checked_nb_of_copy_list->head);
	}
	
	free(tab_min_score);
	free(tab_min_time);
	free(tab_choosen_time_to_load_file);
	free(tab_node_used);

	#ifdef PRINT_SCORES_DATA
	fclose(f_fcfs_score);
	#endif
}

/* Add a malus on fcfs with a score on the index of the node you want to use depending on the allocated area you have. */
void fcfs_with_a_score_area_filling_scheduler(struct Job* head_job, struct Node_List** head_node, int t, int multiplier_file_to_load, int multiplier_file_evicted, int multiplier_nb_copy, int planned_or_ratio)
{
	/* get area in a temp tab */
	long long Temp_Planned_Area[3][3];
	int i = 0;
	int k = 0;
	
	for (i = 0; i < 3; i++)
	{
		for (k = 0; k < 3; k++)
		{
			Temp_Planned_Area[i][k] = Planned_Area[i][k];
		}
	}

	long long Area_j = 0;
	int nb_non_available_cores = get_nb_non_available_cores(node_list, t);		
	long long min_score = -1;
	int earliest_available_time = 0;
	int first_node_size_to_choose_from = 0;
	int last_node_size_to_choose_from = 0;
	int time_to_load_file = 0;
	bool is_being_loaded = false;
	float time_to_reload_evicted_files = 0;
	int nb_copy_file_to_load = 0;
	int time_or_data_already_checked = 0;
	long long score = 0;
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
	
	/* --- Reduced complexity nb of copy --- */	
	struct Time_or_Data_Already_Checked_Nb_of_Copy_List* time_or_data_already_checked_nb_of_copy_list = (struct Time_or_Data_Already_Checked_Nb_of_Copy_List*) malloc(sizeof(struct Time_or_Data_Already_Checked_Nb_of_Copy_List));
	time_or_data_already_checked_nb_of_copy_list->head = NULL;


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
			
			/* --- Reduced complexity nb of copy --- */
			if (multiplier_nb_copy != 0)
			{
				time_or_data_already_checked = was_time_or_data_already_checked_for_nb_copy(j->data, time_or_data_already_checked_nb_of_copy_list);
			}
			
			Area_j = j->cores*j->walltime;

			for (i = first_node_size_to_choose_from; i <= last_node_size_to_choose_from; i++)
			{
				if (i == j->index_node_list || Temp_Planned_Area[i][j->index_node_list] - Area_j >= 0)
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
										/* --- Reduced complexity nb of copy --- */
										if (time_or_data_already_checked == -1)
										{
											#ifdef PRINT
											printf("Need to compute nb of copy it was never done.\n");
											#endif
											nb_copy_file_to_load = get_nb_valid_copy_of_a_file(t, head_node, j->data);
											create_and_insert_head_time_or_data_already_checked_nb_of_copy_list(time_or_data_already_checked_nb_of_copy_list, j->data, nb_copy_file_to_load);
											time_or_data_already_checked = nb_copy_file_to_load;
											#ifdef PRINT
											printf("Compute nb of copy done, it's %d.\n", nb_copy_file_to_load);
											#endif
										}
										else
										{
											nb_copy_file_to_load = time_or_data_already_checked;
											#ifdef PRINT
											printf("Already done for job %d at time %d so nb of copy is %d.\n", j->unique_id, t, nb_copy_file_to_load);
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
									printf("Score for job %d is %lld (EAT: %d + TL %d + TRL %f +NCP %d) with node %d.\n", j->unique_id, score, earliest_available_time, multiplier_file_to_load*time_to_load_file, multiplier_file_evicted*time_to_reload_evicted_files, nb_copy_file_to_load*time_to_load_file*multiplier_nb_copy, n->unique_id); fflush(stdout);
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
			}
			
			j->transfer_time = choosen_time_to_load_file;
					
			/* Get start time and update available times of the cores. */
			j->start_time = min_time;
			j->end_time = min_time + j->walltime;
			
			for (k = 0; k < j->cores; k++)
			{
				j->cores_used[k] = j->node_used->cores[k]->unique_id;
				if (j->node_used->cores[k]->available_time <= t)
				{
					nb_non_available_cores += 1;
				}
				j->node_used->cores[k]->available_time = min_time + j->walltime;
				
				/* Maybe I need job queue or not not sure. TODO. */
			}
			
			/* Reduced corresponding Planned_Area */
			//~ if (choosen_size > j->index_node_list)
			//~ {
				//~ Temp_Planned_Area[choosen_size][j->index_node_list] -= Area_j;
			//~ }

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
										
			#ifdef PRINT
			print_decision_in_scheduler(j);
			#endif
						
			/* Insert in start times. */
			insert_next_time_in_sorted_list(start_times, j->start_time);
			
			/* --- Normal complexity nb of copy --- */
			/* Free time already checked. */
			//~ free_time_or_data_already_checked_nb_of_copy_linked_list(&time_or_data_already_checked_nb_of_copy_list->head);
			
			/* --- Normal complexity nb of copy --- */
			/* Increment nb of copy for current file if we scheduled at time t the current job. */
			if (multiplier_nb_copy != 0 && j->start_time == t)
			{
				//~ printf("Need to increment for job %d Multi is %d.\n", j->unique_id, multiplier_nb_copy); fflush(stdout);
				increment_time_or_data_nb_of_copy_specific_time_or_data(time_or_data_already_checked_nb_of_copy_list, j->data);
				//~ printf("Increment ok for job %d.\n", j->unique_id); fflush(stdout);
			}
			
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
	
	/* --- Reduced complexity nb of copy --- */
	/* Free time already checked. */
	if (multiplier_nb_copy != 0)
	{
		free_time_or_data_already_checked_nb_of_copy_linked_list(&time_or_data_already_checked_nb_of_copy_list->head);
	}

	#ifdef PRINT_SCORES_DATA
	fclose(f_fcfs_score);
	#endif

}
