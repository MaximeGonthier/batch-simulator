#include <main.h>

int get_min_EAT(struct Node_List** head_node, int first_node_size_to_choose_from, int last_node_size_to_choose_from, int nb_cores, int t)
{
	//~ printf("get_min_EAT(struct Node_List** head_node, int first_node_size_to_choose_from %d, int last_node_size_to_choose_from %d, int nb_cores %d, int t %d).\n", first_node_size_to_choose_from, last_node_size_to_choose_from, nb_cores, t);
	int min_EAT = INT_MAX;
	int i = 0;
	
	for (i = first_node_size_to_choose_from; i <= last_node_size_to_choose_from; i++)
	{
		struct Node* n = head_node[i]->head;
		while (n != NULL)
		{
			if (n->cores[nb_cores - 1]->available_time < min_EAT)
			{
				if (n->cores[nb_cores - 1]->available_time <= t)	
				{
					#ifdef PRINT
					printf("EAT == t.\n");
					#endif
					
					return t;
				}
				else
				{
					min_EAT = n->cores[nb_cores - 1]->available_time;
				}
			}
			n = n->next;
		}
	}
	if (min_EAT == INT_MAX)
	{
		perror("EAT is INT_MAX in get_min_EAT");
		exit(EXIT_FAILURE);
	}
	return min_EAT;
}

/* Correspond to def schedule_job_on_earliest_available_cores_no_return(j, node_list, t, nb_non_available_cores) in the python code. */
int schedule_job_on_earliest_available_cores(struct Job* j, struct Node_List** head_node, int t, int nb_non_available_cores, bool use_bigger_nodes)
{
	//~ printf("here\n");
	int i = 0;
	int min_time = -1;
	int earliest_available_time = 0;
	int first_node_size_to_choose_from = 0;
	int last_node_size_to_choose_from = 0;
	
	/* In which node size I can pick. */
	if (use_bigger_nodes == true)
	{
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
	}
	else
	{
		first_node_size_to_choose_from = j->index_node_list;
		last_node_size_to_choose_from = j->index_node_list;
	}
		
	/* Finding the node with the earliest available time. */
	for (i = first_node_size_to_choose_from; i <= last_node_size_to_choose_from; i++)
	{
		struct Node* n = head_node[i]->head;
		while (n != NULL)
		{
			
			//~ if (j->unique_id == 1020 && n->unique_id == 0)
			//~ {
				//~ for (int k = 0; k < 20; k++)
				//~ {
					//~ printf("avail time of core %d = %d.\n", n->cores[k]->unique_id, n->cores[k]->available_time);
				//~ }
				//~ print_cores_in_specific_node(n);
			//~ }
			
			
			//~ struct Node* n = head_node[i]->head;
			earliest_available_time = n->cores[j->cores - 1]->available_time; /* -1 because tab start at 0 */
			if (earliest_available_time < t) /* A core can't be available before t. This happens when a node is idling. */				
			{
				earliest_available_time = t;
			}
			if (min_time == -1 || min_time > earliest_available_time)
			{
				min_time = earliest_available_time;
				j->node_used = n;
			}
			
			//~ #ifdef PRINT
			//~ printf("EAT on node %d is %d.\n", n->unique_id, earliest_available_time);
			//~ #endif
			
			n = n->next;
			//~ if (n == NULL)
			//~ {
				//~ exit(1);
			//~ }
			//~ if (n->next == NULL)
			//~ {
				//~ exit(1);
			//~ }
		}
	}
	
	//~ #ifdef PRINT
	//~ if (j->node_used->unique_id == 183){
	//~ print_cores_in_specific_node(j->node_used);}
	//~ #endif
	
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
		//~ copy_job_and_insert_tail_job_list(n->cores[i]->job_queue, j);
	}
		
	#ifdef PRINT
	print_decision_in_scheduler(j);
	#endif
					//~ if (j->unique_id == 27673)
			//~ {
				//~ printf("e %d s %d sub %d t %d.\n", j->end_time, j->start_time, j->subtime, t);
				//~ print_decision_in_scheduler(j);
			//~ }
	//~ if (j->unique_id == 1382)
	//~ {
		//~ print_decision_in_scheduler(j);
	//~ }
	
	/* Need to sort cores after each schedule of a job. */
	sort_cores_by_available_time_in_specific_node(j->node_used);
		
	return nb_non_available_cores;
}

int schedule_job_on_earliest_available_cores_return_running_cores(struct Job* j, struct Node_List** head_node, int t, int nb_running_cores, bool use_bigger_nodes)
{
	//~ printf("here\n");
	int i = 0;
	int min_time = -1;
	int earliest_available_time = 0;
	int first_node_size_to_choose_from = 0;
	int last_node_size_to_choose_from = 0;
	
	/* In which node size I can pick. */
	if (use_bigger_nodes == true)
	{
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
	}
	else
	{
		first_node_size_to_choose_from = j->index_node_list;
		last_node_size_to_choose_from = j->index_node_list;
	}
		
	/* Finding the node with the earliest available time. */
	for (i = first_node_size_to_choose_from; i <= last_node_size_to_choose_from; i++)
	{
		struct Node* n = head_node[i]->head;
		while (n != NULL)
		{
			
			//~ if (j->unique_id == 1020 && n->unique_id == 0)
			//~ {
				//~ for (int k = 0; k < 20; k++)
				//~ {
					//~ printf("avail time of core %d = %d.\n", n->cores[k]->unique_id, n->cores[k]->available_time);
				//~ }
				//~ print_cores_in_specific_node(n);
			//~ }
			
			
			//~ struct Node* n = head_node[i]->head;
			earliest_available_time = n->cores[j->cores - 1]->available_time; /* -1 because tab start at 0 */
			if (earliest_available_time < t) /* A core can't be available before t. This happens when a node is idling. */				
			{
				earliest_available_time = t;
			}
			if (min_time == -1 || min_time > earliest_available_time)
			{
				min_time = earliest_available_time;
				j->node_used = n;
			}
			
			//~ #ifdef PRINT
			//~ printf("EAT on node %d is %d.\n", n->unique_id, earliest_available_time);
			//~ #endif
			
			n = n->next;
			//~ if (n == NULL)
			//~ {
				//~ exit(1);
			//~ }
			//~ if (n->next == NULL)
			//~ {
				//~ exit(1);
			//~ }
		}
	}
	
	//~ #ifdef PRINT
	//~ if (j->node_used->unique_id == 183){
	//~ print_cores_in_specific_node(j->node_used);}
	//~ #endif
	
	/* Update infos on the job and on cores. */
	j->start_time = min_time;
	j->end_time = min_time + j->walltime;
	for (i = 0; i < j->cores; i++)
	{
		j->cores_used[i] = j->node_used->cores[i]->unique_id;
		if (min_time <= t)
		{
			nb_running_cores += 1;
		}
		j->node_used->cores[i]->available_time = min_time + j->walltime;
		
		/* Maybe I need job queue or not not sure. TODO. */
		//~ copy_job_and_insert_tail_job_list(n->cores[i]->job_queue, j);
	}
		
	#ifdef PRINT
	print_decision_in_scheduler(j);
	#endif
					//~ if (j->unique_id == 27673)
			//~ {
				//~ printf("e %d s %d sub %d t %d.\n", j->end_time, j->start_time, j->subtime, t);
				//~ print_decision_in_scheduler(j);
			//~ }
	//~ if (j->unique_id == 1382)
	//~ {
		//~ print_decision_in_scheduler(j);
	//~ }
	
	/* Need to sort cores after each schedule of a job. */
	sort_cores_by_available_time_in_specific_node(j->node_used);
		
	return nb_running_cores;
}

int schedule_job_on_earliest_available_cores_specific_sublist_node(struct Job* j, struct Node_List* head_node_size_i, int t, int nb_non_available_cores)
{
	int i = 0;
	int min_time = -1;
	int earliest_available_time = 0;
	//~ int first_node_size_to_choose_from = 0;
	//~ int last_node_size_to_choose_from = 0;
			
	/* Finding the node with the earliest available time. */
	//~ for (i = first_node_size_to_choose_from; i <= last_node_size_to_choose_from; i++)
	//~ {
		struct Node* n = head_node_size_i->head;
		while (n != NULL)
		{			
			earliest_available_time = n->cores[j->cores - 1]->available_time; /* -1 because tab start at 0 */
			if (earliest_available_time < t) /* A core can't be available before t. This happens when a node is idling. */				
			{
				earliest_available_time = t;
			}
			if (min_time == -1 || min_time > earliest_available_time)
			{
				min_time = earliest_available_time;
				j->node_used = n;
			}
						
			n = n->next;
		}
		
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
		//~ copy_job_and_insert_tail_job_list(n->cores[i]->job_queue, j);
	}
		
	#ifdef PRINT
	print_decision_in_scheduler(j);
	#endif
	
				//~ if (j->unique_id == 27673)
			//~ {
				//~ printf("%d %d %d.\n", j->end_time, j->start_time, j->subtime);
				//~ print_decision_in_scheduler(j);
			//~ }
	
	/* Need to sort cores after each schedule of a job. */
	sort_cores_by_available_time_in_specific_node(j->node_used);
		
	return nb_non_available_cores;
}

int schedule_job_fcfs_score_return_running_cores(struct Job* j, struct Node_List** head_node, int t, int nb_running_cores, int multiplier_file_to_load, int multiplier_file_evicted, int multiplier_nb_copy)
{
	//~ int nb_non_available_cores = get_nb_non_available_cores(node_list, t);		
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
	//~ while (j != NULL)
	//~ {
		//~ if (nb_non_available_cores < nb_cores)
		//~ {
			//~ #ifdef PRINT
			//~ printf("There are %d/%d available cores.\n", nb_cores - nb_non_available_cores, nb_cores);			
			//~ printf("\nNeed to schedule job %d using file %d.\n", j->unique_id, j->data); fflush(stdout);
			//~ #endif
			
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
				//~ if (j->node_used->cores[k]->available_time <= t)
				//~ {
					//~ nb_non_available_cores += 1;
				//~ }
				if (min_time <= t)
				{
					nb_running_cores += 1;
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
			
			//~ j = j->next;
		//~ }				
		//~ else
		//~ {
			//~ #ifdef PRINT
			//~ printf("No more available cores.\n"); fflush(stdout);
			//~ #endif
			
			//~ break;
		//~ }
	//~ }
	
	/* --- Reduced complexity nb of copy --- */
	/* Free time already checked. */
	if (multiplier_nb_copy != 0)
	{
		free_time_or_data_already_checked_nb_of_copy_linked_list(&time_or_data_already_checked_nb_of_copy_list->head);
	}

	#ifdef PRINT_SCORES_DATA
	fclose(f_fcfs_score);
	#endif
	return nb_running_cores;
}

/* Called at the beggining of each callof fcfs with a score. */
void get_current_intervals(struct Node_List** head_node, int t)
{
	int i = 0;
	for (i = 0; i < 3; i++)
	{
		struct Node* n = head_node[i]->head;
		while (n != NULL)
		{
			struct Data* d = n->data->head;
			while (d != NULL)
			{
				//~ if (d->intervals->head != NULL)
				//~ {
					//~ free_interval_linked_list(&d->intervals->head);
					//~ d->intervals = (struct Interval_List*) malloc(sizeof(struct Interval_List));
					//~ d->intervals->head = NULL;
					//~ d->intervals->tail = NULL;
				//~ }
				//~ else if (d->intervals->head == NULL)
				//~ {
					//~ d->intervals = (struct Interval_List*) malloc(sizeof(struct Interval_List));
					//~ d->intervals->head = NULL;
					//~ d->intervals->tail = NULL;
				//~ }
				//~ else
				//~ {
					//~ printf("Error\n");
					//~ exit(EXIT_FAILURE);
				//~ }
				//~ print_data_intervals(head_node, t);
					
					/* TODO : maybe I need to free here each time ? But when I do i get different results from Fcfs with x0_x0_x0. */
					d->intervals = (struct Interval_List*) malloc(sizeof(struct Interval_List));
					d->intervals->head = NULL;
					d->intervals->tail = NULL;
					
					if (d->nb_task_using_it > 0)
					{
						create_and_insert_tail_interval_list(d->intervals, t);
						if (d->start_time < t)
						{
							create_and_insert_tail_interval_list(d->intervals, t);
						}
						else
						{
							create_and_insert_tail_interval_list(d->intervals, d->start_time);
						}
						create_and_insert_tail_interval_list(d->intervals, d->end_time);
					}
					else if (d->end_time >= t)
					{
						create_and_insert_tail_interval_list(d->intervals, t);
						create_and_insert_tail_interval_list(d->intervals, t);
						create_and_insert_tail_interval_list(d->intervals, t);
					}
				d = d->next;
			}
			n = n->next;
		}
	}
}

int get_nb_non_available_cores(struct Node_List** n, int t)
{
	int nb_non_available_cores = 0;
	int i = 0;
	int j = 0;
	for (i = 0; i < 3; i++)
	{
		struct Node* temp = n[i]->head;
		while (temp != NULL)
		{
			for (j = 0; j < 20; j++)
			{
				if (temp->cores[j]->available_time > t)
				{
					nb_non_available_cores += 1;
				}
			}			
			temp = temp->next;
		}
	}
	return nb_non_available_cores;
}

//~ int get_nb_running_cores(struct Node_List** n, int t)
//~ {
	//~ int nb_running_cores = 0;
	//~ int i = 0;
	//~ for (i = 0; i < 3; i++)
	//~ {
		//~ struct Node* temp = n[i]->head;
		//~ while (temp != NULL)
		//~ {			
			//~ /* Get running cores */
			//~ nb_running_cores += 20 - temp->n_available_cores;
			
			//~ temp = temp->next;
		//~ }
	//~ }
	//~ return nb_running_cores;
//~ }

void schedule_job_specific_node_at_earliest_available_time(struct Job* j, struct Node* n, int t)
{
	int i = 0;
	//~ struct Job* j = j2;

	int earliest_available_time = n->cores[j->cores - 1]->available_time;
	if (earliest_available_time < t)
	{
		earliest_available_time = t;
	}
	// choosen_core = node.cores[0:cores_asked]		

	j->node_used = n;
	
	//~ #ifdef PRINT
	//~ if (j->node_used->unique_id == 183) {
	//~ print_cores_in_specific_node(j->node_used); }
	//~ #endif
	
	j->start_time = earliest_available_time;
	j->end_time = earliest_available_time + j->walltime;
	for (i = 0; i < j->cores; i++)
	{
		j->cores_used[i] = n->cores[i]->unique_id;
		
		//~ if (j->node_used->cores[i]->available_time <= t)
		//~ {
			//~ nb_non_available_cores += 1;
		//~ }
		
		n->cores[i]->available_time = earliest_available_time + j->walltime;
		
		/* Maybe I need job queue or not, not sure. TODO. */
		//~ copy_job_and_insert_tail_job_list(n->cores[i]->job_queue, j);
	}
	
	//~ #ifdef PRINT
	//~ if (j->node_used->unique_id == 183) {
	//~ print_decision_in_scheduler(j); }
	//~ #endif
	
	
	/* Need to sort cores after each schedule of a job. */
	sort_cores_by_available_time_in_specific_node(n);
}

void add_data_in_node (int data_unique_id, int data_size, struct Node* node_used, int t, int end_time, int* transfer_time, int* waiting_for_a_load_time)
{
	#ifdef PRINT
	printf("Adding data %d on node %d at time %d.\n", data_unique_id, node_used->unique_id, t); fflush(stdout);
	#endif
	
	bool data_is_on_node = false;
	/* Let's try to find it in the node */
	//~ struct Data* d = node_used->data->head;
	struct Data* d = (struct Data*) malloc(sizeof(struct Data));
	d = node_used->data->head;
	while (d != NULL)
	{
		if (data_unique_id == d->unique_id) /* It is already on node */
		{
			if (d->nb_task_using_it > 0 || d->end_time == t) /* And is still valid! */
			{
				if (d->start_time > t) /* The job will have to wait for the data to be loaded by another job before starting */
				{
					//~ *transfer_time = d->start_time - t; /* I commented this from python code will it changes things ? */
					*waiting_for_a_load_time = d->start_time - t;
				}
				else
				{
					*transfer_time = 0; /* No need to wait to start the job, data is already fully loaded */
				}
			}
			else /* Need to reload it */
			{
				*transfer_time = data_size/node_used->bandwidth;
				d->start_time = t + *transfer_time;
			}
			
			data_is_on_node = true;
			d->nb_task_using_it += 1;
			
			if (d->end_time < end_time)
			{
				d->end_time = end_time;
			}
			break;
		}
		d = d->next;
	}
	//~ free(d);
	if (data_is_on_node == false) /* Need to load it */
	{
		*transfer_time = data_size/node_used->bandwidth;
		//~ #ifdef PRINT
		//~ printf("1.2.\n"); fflush(stdout);
		//~ #endif
		/* Create a class Data for this node */
		struct Data* new = (struct Data*) malloc(sizeof(struct Data));
		//~ #ifdef PRINT
		//~ printf("2.\n"); fflush(stdout);
		//~ #endif
		new->unique_id = data_unique_id;
		new->start_time = t + *transfer_time;
		new->end_time = end_time;
		new->nb_task_using_it = 1;
		new->size = data_size;
		new->next = NULL;
		new->intervals = (struct Interval_List*) malloc(sizeof(struct Interval_List));
		insert_tail_data_list(node_used->data, new);
	}
	//~ #ifdef PRINT
	//~ printf("%d added.\n", data_unique_id); fflush(stdout);
	//~ #endif
}

void remove_data_from_node(struct Job* j, int t)
{
	struct Data* d = j->node_used->data->head;
	while (d != NULL)
	{
		if (j->data == d->unique_id)
		{
			d->nb_task_using_it -= 1;
				
			if (d->nb_task_using_it == 0)
			{
				d->end_time = t;
			}
			break;
		}	
		d = d->next;
	}
}

/* Go through schedule jobs to find finished jobs. */
void start_jobs(int t, struct Job* head)
{
	int i = 0;
	int k = 0;
	int overhead_of_load = 0;
	int min_between_delay_and_walltime = 0;
	int transfer_time = 0;
	int waiting_for_a_load_time = 0;
	#ifdef PRINT
	printf("Start of start_jobs at time %d.\n", t); fflush(stdout);
	#endif
	
	struct Job* j = head;
	
	while (j != NULL)
	{
		//~ printf("Looking at job %d.\n", j->unique_id); fflush(stdout);
		if (j->start_time == t)
		//~ if (j->start_time <= t)
		{
			
			/* Update nb of jobs to schedule */
			nb_job_to_schedule -= 1;
			if (nb_job_to_schedule < 0)
			{
				printf("Error nb_job_to_schedule = %d\n", nb_job_to_schedule);
				exit(EXIT_FAILURE);
			}
			
			if (j->delay <= 0)
			{
				printf("Error delay is %d for job %d.\n", j->delay, j->unique_id);
				exit(EXIT_FAILURE);
			}
			
			//~ printf("It needs to start.\n");
			/* Remove from list of starting times. */
			if (start_times->head != NULL && start_times->head->time == t)
			{
				delete_next_time_linked_list(start_times, t);
			}
			
			/* For constraint on sizes only. TODO : remove it or put it in an ifdef if I don't have this constraint to gain some time ? */
			total_queue_time += j->start_time - j->subtime;
			
			transfer_time = 0;
			waiting_for_a_load_time = 0;
			
			//~ if (j->data != 0)
			if (j->data != 0 && constraint_on_sizes != 2)
			{
				//~ printf("here\n"	);
				/* Let's look if a data transfer is needed */
				add_data_in_node(j->data, j->data_size, j->node_used, t, j->end_time, &transfer_time, &waiting_for_a_load_time);
			}
			//~ if (constraint_on_sizes == 2)
			//~ {
				//~ j->transfer_time = 0;
				//~ j->waiting_for_a_load_time = 0;
			//~ }
			//~ else
			//~ {
			//~ transfer_time = 0;
			//~ waiting_for_a_load_time = 0;
				j->transfer_time = transfer_time;
				j->waiting_for_a_load_time = waiting_for_a_load_time;
			//~ }
			
			/* If the scheduler is area filling I need to update allocated area if job j was scheduled on a bigger node. */
			if ((strncmp(scheduler, "Fcfs_area_filling", 17) == 0) && j->index_node_list < j->node_used->index_node_list)
			{
				if (planned_or_ratio == 1)
				{
					Allocated_Area[j->node_used->index_node_list][j->index_node_list] += j->cores*j->walltime;
					#ifdef PRINT
					printf("update for real area: %lld\n", Allocated_Area[j->node_used->index_node_list][j->index_node_list]);
					#endif
				}
				else
				{
					Planned_Area[j->node_used->index_node_list][j->index_node_list] -= j->cores*j->walltime;
					#ifdef PRINT
					printf("update for real area: %lld\n", Planned_Area[j->node_used->index_node_list][j->index_node_list]);
					#endif
				}
			}
			
			overhead_of_load = 0;
				//~ printf("%d %d.\n", transfer_time, waiting_for_a_load_time);
				if (transfer_time == 0)
				{
					overhead_of_load = waiting_for_a_load_time;
				}
				else if (waiting_for_a_load_time == 0)
				{
					overhead_of_load = transfer_time;
				}
				else
				{
					printf("Error calcul transfer time.\n");
					exit(EXIT_FAILURE);
				}
			//~ }
			
			#ifdef PRINT
			printf("For job %d (delay = %d): %d transfer time and %d waiting for a load time. Overhead is %d\n", j->unique_id, j->delay, transfer_time, waiting_for_a_load_time, overhead_of_load); fflush(stdout);
			#endif
			
			if (j->delay + overhead_of_load < j->walltime)
			{
				//~ printf("end before walltime\n");
				min_between_delay_and_walltime = j->delay + overhead_of_load;
				j->end_before_walltime = true;
			}
			else
			{
				//~ printf("end at walltime\n");
				min_between_delay_and_walltime = j->walltime;
				j->end_before_walltime = false;
			}
			j->end_time = j->start_time + min_between_delay_and_walltime; /* Attention le j->end time est mis a jour la! */
			
			if (j->end_time <= j->start_time)
			{
				printf("Error end time job %d workload %d: %d -> %d\n min_between_delay_and_walltime is %d, walltime was %d, delay was %d\n", j->unique_id, j->workload, j->start_time, j->end_time, min_between_delay_and_walltime, j->walltime, j->delay);
				exit(EXIT_FAILURE);
			}
			
			insert_next_time_in_sorted_list(end_times, j->end_time);
			
			#ifdef PRINT
			printf("==> Job %d %d cores start at time %d on node %d and will end at time %d before walltime: %d transfer time is %d data was %d.\n", j->unique_id, j->cores, t, j->node_used->unique_id, j->end_time, j->end_before_walltime, transfer_time, j->data);
			#endif
			
			/*For easy bf */
			running_cores += j->cores;
			
			
			/** Defining cluster usage **/
			if (j->node_used->n_available_cores == 20)
			{
				running_nodes += 1;
				
				// if (j->workload == -2)
				// {
					// running_nodes_workload_minus_2 += 1;
				//~}
			}
			j->node_used->n_available_cores -= j->cores;
			//~ #ifdef PRINT_CLUSTER_USAGE
			if (j->node_used->n_available_cores < 0 || j->node_used->n_available_cores > 20)
			{
				printf("ERROR ERROR\n"); 
				exit(1);
				//~ printf("==> Job %d %d cores start at time %d on node %d and will end at time %d before walltime: %d transfer time is %d data was %d.\n", j->unique_id, j->cores, t, j->node_used->unique_id, j->end_time, j->end_before_walltime, transfer_time, j->data);
				//~ printf("Error n avail in start_jobs: %d on node %d for job %d. T = %d.\n", j->node_used->n_available_cores, j->node_used->unique_id, j->unique_id, t);
				//~ print_single_node(j->node_used);
				//~ print_cores_in_specific_node(j->node_used);
			}
			//~ #endif
			/** End of defining cluster usage **/
						
			for (i = 0; i < j->cores; i++)
			{
				for (k = 0; k < 20; k++)
				{
					if (j->node_used->cores[k]->unique_id == j->cores_used[i])
					{
						//~ j->cores[i]->running_job = j;
						j->node_used->cores[k]->running_job = true;
						j->node_used->cores[k]->running_job_end = j->start_time + j->walltime;
						break;
					}
				}
			}
			//~ jobs_to_remove.append(j)
			//~ insert_tail_job_list(running_jobs, j);
			//~ copy_job_and_insert_tail_job_list(running_jobs, j);
			
			/* Test with finish in start jobs instead of end jobs. */
			if (j->workload == 1)
			{
				nb_job_to_evaluate_started += 1;
			}
			to_print_job_csv(j, t);
		}
		j = j->next;
	}
	
	/* Copy and delete. */
	j = scheduled_job_list->head;
	while (j != NULL)
	{
		if (j->start_time == t)
		{
			//~ printf("Delete job %d from scheduled.\n", j->unique_id); fflush(stdout);
			struct Job* temp = j->next;
			copy_delete_insert_job_list(scheduled_job_list, running_jobs, j);
			j = temp;
		}
		else
		{
			j = j->next;
		}
	}
	//~ printf("End of start jobs.\n"); fflush(stdout);
	//~ print_job_list(scheduled_job_list->head);
	//~ if len(jobs_to_remove) > 0:
		//~ scheduled_job_list = remove_jobs_from_list(scheduled_job_list, jobs_to_remove)
		//~ available_job_list = remove_jobs_from_list(available_job_list, jobs_to_remove)
	//~ return scheduled_job_list, running_jobs, end_times, running_cores, running_nodes, total_queue_time, available_job_list
}

/* Go through running jobs to find finished jobs. */
void end_jobs(struct Job* job_list_head, int t)
{
	#ifdef PRINT
	printf("Start of end_jobs at time %d.\n", t); fflush(stdout);
	#endif
	
	int i = 0;
	int k = 0;
	struct Job* j= job_list_head;
	while(j != NULL)
	{
		if (j->end_time == t) /* A job has finished, let's remove it from the cores, write its results and figure out if we need to fill */
		//~ if (j->end_time >= t) /* A job has finished, let's remove it from the cores, write its results and figure out if we need to fill */
		{
			/* Remove from list of ending times. */
			if (end_times->head != NULL && end_times->head->time == t)
			{
				//~ #ifdef PRINT
				//~ printf("Before deleting ending time %d:\n", t);
				//~ print_time_list(end_times->head, 1);
				//~ #endif
				
				delete_next_time_linked_list(end_times, t);
				
				//~ #ifdef PRINT
				//~ printf("After deleting ending time %d:\n", t);
				//~ print_time_list(end_times->head, 1);
				//~ #endif
			}
			
			//~ if (j->workload == 1)
			//~ {
				//~ nb_job_to_evaluate_finished += 1;
				//~ nb_job_to_evaluate_started += 1;
			//~ }
			
			/* If the scheduler is area filling and the job finished before the walltime, I want to remove (or add) the difference from the walltime. */
			/* Attention c'est pas pour fcfs with a score area factor!! */
			if ((strncmp(scheduler, "Fcfs_area_filling", 17) == 0) && j->index_node_list < j->node_used->index_node_list && j->end_before_walltime == true)
			{
				if (planned_or_ratio == 1)
				{
					Allocated_Area[j->node_used->index_node_list][j->index_node_list] -= j->cores*(j->walltime - (j->end_time - j->start_time));
					#ifdef PRINT
					printf("update for real area: %lld\n", Allocated_Area[j->node_used->index_node_list][j->index_node_list]);
					#endif
				}
				else
				{
					Planned_Area[j->node_used->index_node_list][j->index_node_list] += j->cores*(j->walltime - (j->end_time - j->start_time));
					#ifdef PRINT
					printf("update for real area: %lld\n", Planned_Area[j->node_used->index_node_list][j->index_node_list]);
					#endif
				}
			}

				
			finished_jobs += 1;
			
			#ifdef PRINT
			printf("==> Job %d %d cores finished at time %d on node %d.\n", j->unique_id, j->cores, t, j->node_used->unique_id);
			#endif
			
			/* Just printing, can remove */
			//~ if (finished_jobs%5000 == 0)
			if (finished_jobs%2500 == 0)
			{
				printf("Evaluated jobs: %d/%d | All jobs: %d/%d | T = %d.\n", nb_job_to_evaluate_started, nb_job_to_evaluate, finished_jobs, total_number_jobs, t); fflush(stdout);
			}
			
			/* For easybf */
			running_cores -= j->cores;				
			
			
			/** Defining cluster usage **/
			j->node_used->n_available_cores += j->cores;
			if (j->node_used->n_available_cores == 20)
			{
				running_nodes -= 1;
				
				// if (j->workload == -2)
				// {
					// running_nodes_workload_minus_2 -= 1;
				// }
			}
			//~ #ifdef PRINT_CLUSTER_USAGE
			//~ }
			if (j->node_used->n_available_cores < 0 || j->node_used->n_available_cores > 20)
			{
				printf("ERROR ERROR\n");
				exit(1); 
				//~ printf("==> Job %d %d cores finished at time %d on node %d.\n", j->unique_id, j->cores, t, j->node_used->unique_id);
				//~ printf("Error n avail in end_jobs: %d on node %d for job %d. T = %d.\n", j->node_used->n_available_cores, j->node_used->unique_id, j->unique_id, t);
				//~ print_single_node(j->node_used);
				//~ print_cores_in_specific_node(j->node_used);
			}
			//~ #endif
			/** End of defining cluster usage **/
						
			//~ #ifdef PRINT
			//~ if (j->node_used->unique_id == 183) {
			//~ printf("n avail cores end_jobs %d.\n", j->node_used->n_available_cores); }
			//~ #endif
			
			for (i = 0; i < j->cores; i++)
			{
				for (k = 0; k < 20; k++)
				{
					if (j->node_used->cores[k]->unique_id == j->cores_used[i])
					{
						//~ j->cores[i]->running_job = j;
						j->node_used->cores[k]->running_job = false;
						j->node_used->cores[k]->running_job_end = -1;
						//~ printf("Running false for job %d.\n", j->unique_id);
						break;
					}
				}
			}
			
			if (j->data != 0)
			{
				//~ printf("Remove data...\n"); fflush(stdout);
				remove_data_from_node(j, t);
				//~ printf("Remove data Ok!\n"); fflush(stdout);
			}
			
			//~ for (i = 0; i < j->cores; i++)
			//~ {
				// j->cores_used[i].job_queue.remove(j)
				//~ j->cores_used[i].running_job = None					
				//~ core_ids.append(j->cores_used[i].unique_id)
			//~ }
			
			/* Adding in a struct the data needed for statistics. */
			//~ to_print_job_csv(j, t);
		}
		j = j->next;
	}				
		
	/* Delete from running jobs. */
	j = job_list_head;
	while (j != NULL)
	{
		if (j->end_time == t)
		{
			//~ printf("Before:\n");
			//~ print_job_list(running_jobs->head);
			//~ printf("Deletion of job %d.\n", j->unique_id); fflush(stdout);
			struct Job* temp = j->next;
			//~ printf("delete_job_linked_list for %d...\n", j->unique_id); fflush(stdout);
			//~ if (j->unique_id == 11) {
				//~ printf("Job %d, %d %d %d %d %d %f %d %d %d %d %d cores: %d %d %d %d %d %d %d %d %d %d\n", j->unique_id, j->subtime, j->delay, j->walltime, j->cores, j->data, j->data_size, j->index_node_list, j->start_time, j->end_time, j->end_before_walltime, j->node_used->unique_id, j->cores_used[0],j->cores_used[1],j->cores_used[2],j->cores_used[3],j->cores_used[4], j->transfer_time, j->waiting_for_a_load_time, j->workload, j->start_time_from_history, j->node_from_history);
			//~ }
			delete_job_linked_list(running_jobs, j->unique_id);
			//~ printf("delete_job_linked_list for %d Ok!\n", j->unique_id); fflush(stdout);
			j = temp;
			//~ print_job_list(running_jobs->head);
		}
		else
		{
			j = j->next;
		}
	}
}

/* Reset available times by going through the cores in each node. */
void reset_cores(struct Node_List** l, int t)
{
	int i = 0;
	int j = 0;
	for (i = 0; i < 3; i++)
	{
		struct Node* n = l[i]->head;
		while (n != NULL)
		{
			for (j = 0; j < 20; j++)
			{
				if (n->cores[j]->running_job == false)
				{
					n->cores[j]->available_time = t;
					//~ printf("Core takes t = %d for node %d;\n", t, n->unique_id);
				}
				else
				{
					if (n->cores[j]->running_job_end == -1)
					{
						perror("error reset cores.\n");
						exit(EXIT_FAILURE);
					}
					n->cores[j]->available_time = n->cores[j]->running_job_end;
				}
			}
			
			/* Need to sort cores after a reset as well. */
			sort_cores_by_available_time_in_specific_node(n);
			
			n = n->next;
		}
	}
}

//~ int is_my_file_on_node_at_certain_time_and_transfer_time(int predicted_time, struct Node* n, int t, int current_data, int current_data_size, bool* is_being_loaded)
float is_my_file_on_node_at_certain_time_and_transfer_time(int predicted_time, struct Node* n, int t, int current_data, float current_data_size, bool* is_being_loaded)
{
	struct Data* d = n->data->head;
	int* temp_interval_usage_time = malloc(3*sizeof(int));
	while (d != NULL)
	{
		#ifdef PRINT
		printf("Data %d is on node %d.\n", d->unique_id, n->unique_id); fflush(stdout);
		#endif
		
		struct Interval* i = d->intervals->head;
		if (d->unique_id == current_data && i != NULL)
		{
			#ifdef PRINT
			printf("Interval not empty, but is it on the node at time %d ?\n", predicted_time);
			#endif
			
			while (i != NULL)
			{
				temp_interval_usage_time[0] = i->time;
				i = i->next;
				temp_interval_usage_time[1] = i->time;
				i = i->next;
				temp_interval_usage_time[2] = i->time;
				
				#ifdef PRINT
				printf("Checking %d / %d / %d.\n", temp_interval_usage_time[0], temp_interval_usage_time[1], temp_interval_usage_time[2]);
				#endif
				
				if (temp_interval_usage_time[0] <= predicted_time && temp_interval_usage_time[1] <= predicted_time && predicted_time <= temp_interval_usage_time[2])
				{
					*is_being_loaded = false;
					free(temp_interval_usage_time);
					return 0;
				}
				else if (temp_interval_usage_time[0] <= predicted_time && predicted_time <= temp_interval_usage_time[2])
				{
					*is_being_loaded = true;
					int temp = temp_interval_usage_time[1];
					free(temp_interval_usage_time);
					return temp - t;
				}
				i = i->next;
			}
			break;
		}
		d = d->next;
	}
	*is_being_loaded = false;
	free(temp_interval_usage_time);
	return current_data_size/n->bandwidth;
}

/* % of space you will take and thus time it will take to reload evicted data. */
//~ float time_to_reload_percentage_of_files_ended_at_certain_time(int predicted_time, struct Node* n, int current_data, int percentage_occupied)
float time_to_reload_percentage_of_files_ended_at_certain_time(int predicted_time, struct Node* n, int current_data, float percentage_occupied)
{
	//~ int size_file_ended = 0;
	float size_file_ended = 0;
	struct Data* d = n->data->head;
	while (d != NULL)
	{
		struct Interval* i = d->intervals->head;
		if (d->unique_id != current_data && i != NULL)
		{
			#ifdef PRINT
			printf("Checking tail of the interval of data %d: %d->\n", d->unique_id, d->intervals->tail->time);
			#endif
			
			if (predicted_time >= d->intervals->tail->time)
			{
				size_file_ended += d->size;
				
				#ifdef PRINT
				printf("Add size %f->\n", d->size); fflush(stdout);
				#endif
			}
		}
		d = d->next;
	}
	
	#ifdef PRINT
	printf("Total size of data on node ending before my EAT is: %f but I return (%f*%f)/%f = %f.\n", size_file_ended, percentage_occupied, size_file_ended, n->bandwidth, (size_file_ended*percentage_occupied)/n->bandwidth); fflush(stdout);
	#endif
	
	return (size_file_ended*percentage_occupied)/n->bandwidth;
}

int get_nb_valid_copy_of_a_file(int predicted_time, struct Node_List** head_node, int current_data)
{
	int nb_of_copy = 0;
	int j = 0;
	int* temp_interval_usage_time = malloc(2*sizeof(int));
	
	for (j = 0; j < 3; j++)
	{
		struct Node* n = head_node[j]->head;
		while(n != NULL)
		{
			struct Data* d = n->data->head;
			while (d != NULL)
			{
				struct Interval* i = d->intervals->head;
				if (d->unique_id == current_data && i != NULL)
				{
					#ifdef PRINT
					printf("Data %d is on node %d but at predicted time %d?\n", d->unique_id, n->unique_id, predicted_time);
					#endif
					
					while (i != NULL)
					{
						temp_interval_usage_time[0] = i->time;
						i = i->next;
						i = i->next;
						temp_interval_usage_time[1] = i->time;
						
						#ifdef PRINT
						printf("Checking %d / %d.\n", temp_interval_usage_time[0], temp_interval_usage_time[1]);
						#endif
						
						if (temp_interval_usage_time[0] <= predicted_time && predicted_time <= temp_interval_usage_time[1])
						{
							nb_of_copy += 1;
							break;
						}
						i = i->next;
					}
					break;
				}
				d = d->next;
			}
			n = n->next;
		}
	}
	free(temp_interval_usage_time);
	return nb_of_copy;
}
					
int was_time_or_data_already_checked_for_nb_copy(int t_or_d, struct Time_or_Data_Already_Checked_Nb_of_Copy_List* list)
{
	struct Time_or_Data_Already_Checked_Nb_of_Copy* a = list->head;
	while (a != NULL)
	{
		if (a->time_or_data == t_or_d)
		{
			return a->nb_of_copy;
		}
		a = a->next;
	}
	return -1;
}

int schedule_job_to_start_immediatly_on_specific_node_size(struct Job* j, struct Node_List* head_node_size_i, int t, int backfill_big_node_mode, int total_queue_time, int nb_finished_jobs, int nb_non_available_cores, bool* result)
{
	int mean_queue_time = 0;
	int earliest_available_time = 0;
	int threshold_for_a_start = 0;
	int i = 0;
	
	if (nb_finished_jobs == 0)
	{
		mean_queue_time = 0;
	}
	else
	{
		mean_queue_time = total_queue_time/nb_finished_jobs;
	}
	
	struct Node* n = head_node_size_i->head;
	while(n != NULL)
	{
		earliest_available_time = n->cores[j->cores - 1]->available_time; /* -1 because tab start at 0 */
		
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
			perror("Error on backfill_big_node_mode, must be 0 or 1.\n");
			exit(EXIT_FAILURE);
		}
			
		if (earliest_available_time <= threshold_for_a_start) /* Ok I can start immediatly, schedule job and return true. */
		{
			/* Update infos on the job and on cores. */
			j->node_used = n;
			j->start_time = earliest_available_time;
			j->end_time = earliest_available_time + j->walltime;
			for (i = 0; i < j->cores; i++)
			{
				j->cores_used[i] = j->node_used->cores[i]->unique_id;
				if (j->node_used->cores[i]->available_time <= t)
				{
					nb_non_available_cores += 1;
				}
				j->node_used->cores[i]->available_time = earliest_available_time + j->walltime;
				
				/* Maybe I need job queue or not not sure. TODO. */
				//~ copy_job_and_insert_tail_job_list(n->cores[i]->job_queue, j);
			}
		
			#ifdef PRINT
			print_decision_in_scheduler(j);
			#endif
		
			/* Need to sort cores after each schedule of a job. */
			sort_cores_by_available_time_in_specific_node(j->node_used);
			
			*result = true;
			return nb_non_available_cores;
		}
		n = n->next;
	}
	return nb_non_available_cores;
}

int try_to_start_job_immediatly_without_delaying_j1(struct Job* j, struct Job* j1, struct Node_List** head_node, int nb_running_cores, bool* result, bool use_bigger_nodes, int t)
{
	//~ printf("Try to start Job %d now.\n", j->unique_id);
	int earliest_available_time = 0;
	int i = 0;
	int k = 0;
	bool ok_on_this_node = false;
	
	/* TODO: To try and reduce complexity a little I look at the available cores on each node and if it's inferior to j->cores I don't bother looking. Is it worth it ? Idk. */
	
	int l = 0;
	int first_node_size_to_choose_from = 0;
	int last_node_size_to_choose_from = 0;
	
	/* In which node size I can pick. */
	if (use_bigger_nodes == true)
	{
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
	}
	else
	{
		first_node_size_to_choose_from = j->index_node_list;
		last_node_size_to_choose_from = j->index_node_list;
	}
	
	bool need_to_break = false;
	
	/* Finding the node with the earliest available time. */
	for (l = first_node_size_to_choose_from; l <= last_node_size_to_choose_from; l++)
	{
		struct Node* n = head_node[l]->head;
		while(n != NULL)
		{
			ok_on_this_node = false;
			earliest_available_time = n->cores[j->cores - 1]->available_time; /* -1 because tab start at 0 */
						
			if (earliest_available_time <= t) /* Ok I can start immediatly, schedule job and return true. */
			{
				ok_on_this_node = true;
				
				/* But is it the same node as j1 ? If yes I need to be careful. */
				if (n->unique_id == j1->node_used->unique_id)
				{
					if (earliest_available_time + j->walltime > j1->start_time) /* It will finish later so I need to check if it's the same cores. If yes I can't do it. */
					{
						need_to_break = false;
						for (i = 0; i < j->cores; i++)
						{
							for (k = 0; k < j1->cores; k++)
							{
								//~ printf("Testing %d == %d ?\n", n->cores[i]->unique_id, j1->cores_used[k]);
								if (n->cores[i]->unique_id == j1->cores_used[k])
								{
									/* Need to exit. */
									ok_on_this_node = false;
									//~ printf("%d == %d.\n", n->cores[i]->unique_id, j1->cores_used[k]);
									need_to_break = true;
									break;
								}
							}
							if (need_to_break == true)
							{
								break;
							}
						}
					}
				}
				
				if (ok_on_this_node == true)
				{
					/* Update infos on the job and on cores. */
					j->node_used = n;
					j->start_time = earliest_available_time;
					j->end_time = earliest_available_time + j->walltime;
					for (i = 0; i < j->cores; i++)
					{
						j->cores_used[i] = j->node_used->cores[i]->unique_id;
						//~ if (j->node_used->cores[i]->available_time <= t)
						//~ {
						nb_running_cores += 1;
						//~ }
						j->node_used->cores[i]->available_time = earliest_available_time + j->walltime;
						
						/* Maybe I need job queue or not not sure. TODO. */
						//~ copy_job_and_insert_tail_job_list(n->cores[i]->job_queue, j);
					}
				
					#ifdef PRINT
					print_decision_in_scheduler(j);
					#endif
				
					/* Need to sort cores after each schedule of a job. */
					sort_cores_by_available_time_in_specific_node(j->node_used);
					
					*result = true;
					return nb_running_cores;
				}
			}
			n = n->next;
		}
	}
	return nb_running_cores;
}

/* Basically it's fcfs with a score but only on nodes where you can start immediatly. */
int try_to_start_job_immediatly_fcfs_score_without_delaying_j1(struct Job* j, struct Job* j1, struct Node_List** head_node, int nb_running_cores, bool* result, int t, int multiplier_file_to_load, int multiplier_file_evicted, int multiplier_nb_copy)
{
	//~ printf("Try to start job %d now with fcfs score.\n", j->unique_id);
	int earliest_available_time = 0;
	int i = 0;
	int k = 0;
	long long score = 0;
	//~ bool ok_on_this_node = false;
				/* Reset some values. */
	int choosen_time_to_load_file = 0;
	bool found = false;
	int min_time = 0;					
	long long	min_score = -1;
	int time_to_load_file = 0;
	int time_or_data_already_checked = 0;
			//~ earliest_available_time = 0;
			//~ first_node_size_to_choose_from = 0;
			//~ last_node_size_to_choose_from = 0;
			bool is_being_loaded = false;
			float time_to_reload_evicted_files = 0;
			int nb_copy_file_to_load = 0;
	bool could_schedule = false;
	
	/* TODO: To try and reduce complexity a little I look at the available cores on each node and if it's inferior to j->cores I don't bother looking. Is it worth it ? Idk. */
	
	int l = 0;
	int first_node_size_to_choose_from = 0;
	int last_node_size_to_choose_from = 0;
	
	/* In which node size I can pick. */
	//~ if (use_bigger_nodes == true)
	//~ {
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
	//~ }
	//~ else
	//~ {
		//~ first_node_size_to_choose_from = j->index_node_list;
		//~ last_node_size_to_choose_from = j->index_node_list;
	//~ }
	bool ok_on_this_node = false;
	bool need_to_break = false;
	
	struct Time_or_Data_Already_Checked_Nb_of_Copy_List* time_or_data_already_checked_nb_of_copy_list = (struct Time_or_Data_Already_Checked_Nb_of_Copy_List*) malloc(sizeof(struct Time_or_Data_Already_Checked_Nb_of_Copy_List));
	time_or_data_already_checked_nb_of_copy_list->head = NULL;
		
	/* Finding the node with the earliest available time. */
	for (l = first_node_size_to_choose_from; l <= last_node_size_to_choose_from; l++)
	{
		struct Node* n = head_node[l]->head;
		while(n != NULL)
		{
			//~ ok_on_this_node = false;
			earliest_available_time = n->cores[j->cores - 1]->available_time; /* -1 because tab start at 0 */
						
			if (earliest_available_time <= t) /* Ok I can start immediatly, Find score. */
			{
				ok_on_this_node = true;				
				/* But is it the same node as j1 ? If yes I need to be careful. */
				if (n->unique_id == j1->node_used->unique_id)
				{
					if (earliest_available_time + j->walltime > j1->start_time) /* It will finish later so I need to check if it's the same cores. If yes I can't do it. */
					{
						need_to_break = false;
						for (i = 0; i < j->cores; i++)
						{
							for (k = 0; k < j1->cores; k++)
							{
								//~ printf("Testing %d == %d ?\n", n->cores[i]->unique_id, j1->cores_used[k]);
								if (n->cores[i]->unique_id == j1->cores_used[k])
								{
									/* Need to exit. */
									ok_on_this_node = false;
									//~ printf("%d == %d.\n", n->cores[i]->unique_id, j1->cores_used[k]);
									need_to_break = true;
									break;
								}
							}
							if (need_to_break == true)
							{
								break;
							}
						}
					}
				}
				
				if (ok_on_this_node == true)
				{
					//~ printf("Node %d is ok.\n", n->unique_id);
					could_schedule = true;
					/* I already do it earlier. */
					//~ earliest_available_time = n->cores[j->cores - 1]->available_time; /* -1 because tab start at 0 */
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
				}
			}
			n = n->next;
		}
	}
		
		/* Update job */
		if (could_schedule == true)
		{
			j->transfer_time = choosen_time_to_load_file;
					
			/* Get start time and update available times of the cores. */
			j->start_time = min_time;
			j->end_time = min_time + j->walltime;
			
			for (int k = 0; k < j->cores; k++)
			{
				j->cores_used[k] = j->node_used->cores[k]->unique_id;
				//~ if (j->node_used->cores[k]->available_time <= t)
				//~ {
					//~ nb_non_available_cores += 1;
				//~ }
				nb_running_cores += 1;
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
	
			/* --- Reduced complexity nb of copy --- */
			/* Free time already checked. */
			if (multiplier_nb_copy != 0)
			{
				free_time_or_data_already_checked_nb_of_copy_linked_list(&time_or_data_already_checked_nb_of_copy_list->head);
			}
			*result = true;
			return nb_running_cores;
	}
	//~ printf("Could not start the job.\n");
	return nb_running_cores;
}

int get_earliest_available_time_specific_sublist_node(int nb_cores_asked, struct Node_List* head_node_size_i, struct Node** choosen_node, int t)
{
	int min_time = -1;
	int earliest_available_time = 0;
	struct Node* n = head_node_size_i->head;
	while (n != NULL)
	{			
		earliest_available_time = n->cores[nb_cores_asked - 1]->available_time; /* -1 because tab start at 0 */
		if (earliest_available_time < t) /* A core can't be available before t. This happens when a node is idling. */				
		{
			earliest_available_time = t;
		}
		if (min_time == -1 || min_time > earliest_available_time)
		{
			min_time = earliest_available_time;
			*choosen_node = n;
		}			
		n = n->next;
	}
				
	return min_time;
}

// Function to perform Selection Sort
void sort_tab_of_int_decreasing_order(long long arr[], int n)
{
    int i, j, min_idx;
 
    // One by one move boundary of unsorted subarray
    for (i = 0; i < n - 1; i++) {
 
        // Find the minimum element in unsorted array
        min_idx = i;
        for (j = i + 1; j < n; j++)
            //~ if (arr[j] < arr[min_idx])
            if (arr[j] > arr[min_idx])
                min_idx = j;
 
        // Swap the found minimum element
        // with the first element
        swap(&arr[min_idx], &arr[i]);
        
    }
}

void swap(long long* xp, long long* yp)
{
    long long temp = *xp;
    *xp = *yp;
    *yp = temp;
}
