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
	
	//~ int nb_running_cores = 0;
	
	int nb_non_available_cores = get_nb_non_available_cores(node_list, t);

	struct Job* j = head_job;
	while (j != NULL)
	{
		if (nb_non_available_cores < nb_cores)
		{
			#ifdef PRINT
			printf("There are %d/%d available cores.\n", nb_cores - nb_non_available_cores, nb_cores);
			#endif
			
			//~ if (backfill == false)
			//~ {
			nb_non_available_cores = schedule_job_on_earliest_available_cores(j, head_node, t, nb_non_available_cores, use_bigger_nodes);
			//~ }
			//~ else
			//~ {
				//~ nb_non_available_cores = schedule_job_on_earliest_available_cores_backfill(j, head_node, t, nb_non_available_cores, use_bigger_nodes);
			//~ }
			
			insert_next_time_in_sorted_list(start_times, j->start_time);
			
			j = j->next;
		}
		else
		{
			#ifdef PRINT
			printf("There are %d/%d available cores.\n", nb_cores - nb_non_available_cores, nb_cores);
			#endif
			
			
			//~ printf("There are %d running cores.\n", nb_running_cores);
			
			/* Continue backfilling. */
			//~ if (nb_running_cores < nb_cores && backfill == true)
			//~ {
				//~ nb_running_cores = resume_backfilling(j, head_node, t, nb_running_cores, use_biger_nodes);
			//~ }
			//~ else
			//~ {
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
	int min_score = -1;
	int earliest_available_time = 0;
	int first_node_size_to_choose_from = 0;
	int last_node_size_to_choose_from = 0;
	int time_to_load_file = 0;
	bool is_being_loaded = false;
	float time_to_reload_evicted_files = 0;
	int nb_copy_file_to_load = 0;
	int time_or_data_already_checked = 0;
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
	// care use long long for area!!
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
			if (next_size != j->index_node_list)
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
	// care use long long for area!!
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

void fcfs_with_a_score_backfill_big_nodes_scheduler(struct Job* head_job, struct Node_List** head_node, int t, int multiplier_file_to_load, int multiplier_file_evicted, int multiplier_nb_copy, int backfill_big_node_mode, int total_queue_time, int finished_jobs)
{
	/* Unique to this function for fcfs with a score */
	int mean_queue_time = 0;
	int threshold_for_a_start = 0;	
	if (finished_jobs == 0)
	{
		mean_queue_time = 0;
	}
	else
	{
		mean_queue_time = total_queue_time/finished_jobs;
	}
	
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
	int time_or_data_already_checked = 0;
	int score = 0;
	int min_time = 0;
	int choosen_time_to_load_file = 0;
	bool found = false;
	
	/* Get intervals of data. */ 
	get_current_intervals(head_node, t);
	
	//~ #ifdef PRINT
	//~ print_data_intervals(head_node, t);
	//~ #endif
	
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
			
			/* Unique for this fcfs with a score as well. */
			/* Before incrementing the size of a node that I can look at I want to see if I need to. */
			threshold_for_a_start = 0;				
			if (backfill_big_node_mode == 0)
			{
				threshold_for_a_start = t;
			}
			else if (backfill_big_node_mode == 1)
			{
				if (mean_queue_time - (t - j->subtime) > 0)
				{
					threshold_for_a_start = t + mean_queue_time - (t - j->subtime);
				}
				else
				{
					threshold_for_a_start = t;
				}
			}
			else
			{
				perror("Error on backfill_big_node_mode, must be 0 or 1 in fcfs with a score.\n");
				exit(EXIT_FAILURE);
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
									/* New for this fcfs */
									if (i == first_node_size_to_choose_from || earliest_available_time <= threshold_for_a_start)
									{
										min_time = earliest_available_time;
										min_score = score;
										j->node_used = n;
										choosen_time_to_load_file = time_to_load_file;
									}
									else
									{
										#ifdef PRINT
										printf("Not current size and threshold > (%d>%d)\n", threshold_for_a_start, earliest_available_time);
										#endif
									}
								}
							}
						}
					}
					
					#ifdef PRINT_SCORES_DATA
					fprintf(f_fcfs_score, "Node: %d EAT: %d C: %f CxX: %f Score: %f\n", n->unique_id, earliest_available_time, time_to_reload_evicted_files, time_to_reload_evicted_files*multiplier_file_evicted, earliest_available_time + multiplier_file_to_load*time_to_load_file + multiplier_file_evicted*time_to_reload_evicted_files);
					#endif
					
					n = n->next;
				}
				
				/* New for this fcfs to reduce complexity. */
				if (min_time <= threshold_for_a_start && i == first_node_size_to_choose_from) /* Perfect right size! I can break. */
				{
					#ifdef PRINT
					printf("Could schedule on node of my size!\n");
					#endif
					break; /* Break the for on nodes sizes. */
				}
				/* Else I just continue the loop and try to find a better node size. If I don't find anything better I normally chose a node from the size x. Happens naturally normally cause I start with min_time == -1 at size x. */
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
				//~ #ifdef PRINT
				//~ printf("Need to create a data and intervals for the node %d data %d.\n", j->node_used->unique_id, j->data); fflush(stdout);
				//~ #endif
				
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
			
			//~ #ifdef PRINT
			//~ printf("After add interval are:\n"); fflush(stdout);
			//~ print_data_intervals(head_node, t);
			//~ #endif
			
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

/* Add a malus on fcfs with a score on the index of the node you want to use depending on the allocated area you have. */
void fcfs_with_a_score_area_filling_scheduler(struct Job* head_job, struct Node_List** head_node, int t, int multiplier_file_to_load, int multiplier_file_evicted, int multiplier_nb_copy, int multiplier_area_bigger_nodes)
{
	#ifdef PRINT
	printf("Start of planned area filling.\n");
	printf("Planned areas are: [%lld, %lld, %lld] [%lld, %lld, %lld] [%lld, %lld, %lld]\n", Planned_Area[0][0], Planned_Area[0][1], Planned_Area[0][2], Planned_Area[1][0], Planned_Area[1][1], Planned_Area[1][2], Planned_Area[2][0], Planned_Area[2][1], Planned_Area[2][2]);
	#endif
	
	//~ long long Temp_Planned_Area[3][3];
	int i = 0;
	//~ int k = 0;
	
	//~ for (i = 0; i < 3; i++)
	//~ {
		//~ for (k = 0; k < 3; k++)
		//~ {
			//~ Temp_Planned_Area[i][k] = Planned_Area[i][k];
		//~ }
	//~ }
	
	int nb_non_available_cores = get_nb_non_available_cores(node_list, t);		
	//~ int i = 0;
	int min_score = -1;
	int earliest_available_time = 0;
	int first_node_size_to_choose_from = 0;
	int last_node_size_to_choose_from = 0;
	int time_to_load_file = 0;
	bool is_being_loaded = false;
	float time_to_reload_evicted_files = 0;
	int nb_copy_file_to_load = 0;
	int time_or_data_already_checked = 0;
	int score = 0;
	int min_time = 0;
	int choosen_time_to_load_file = 0;
	bool found = false;
	float area_ratio_used = 0;
	//~ long long area_ratio_used = 0;
	
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
			area_ratio_used = 0;
			
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
				if (Planned_Area[i][j->index_node_list] > 0 || i == first_node_size_to_choose_from)
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
									
									if (min_score == -1 || earliest_available_time + multiplier_file_to_load*time_to_load_file + multiplier_file_evicted*time_to_reload_evicted_files + nb_copy_file_to_load*time_to_load_file*multiplier_nb_copy < min_score)
									{
										if (i != first_node_size_to_choose_from && multiplier_area_bigger_nodes != 0)
										{
											#ifdef PRINT
											printf("area_ratio_used = (%d*%d)/%lld.\n", j->cores, j->walltime, Planned_Area[i][j->index_node_list]); fflush(stdout);
											#endif
											
											area_ratio_used = (j->cores*j->walltime)/Planned_Area[i][j->index_node_list];
										}
										else
										{
											area_ratio_used = 0;
										}
									
										/* Compute node's score. */
										score = earliest_available_time + multiplier_file_to_load*time_to_load_file + multiplier_file_evicted*time_to_reload_evicted_files + nb_copy_file_to_load*time_to_load_file*multiplier_nb_copy + multiplier_area_bigger_nodes*area_ratio_used;
										
										#ifdef PRINT
										printf("Score for job %d is %d (EAT: %d + TL %d + TRL %f + NCP %d + AREA %f) with node %d.\n", j->unique_id, score, earliest_available_time, multiplier_file_to_load*time_to_load_file, multiplier_file_evicted*time_to_reload_evicted_files, nb_copy_file_to_load*time_to_load_file*multiplier_nb_copy, multiplier_area_bigger_nodes*area_ratio_used, n->unique_id); fflush(stdout);
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
