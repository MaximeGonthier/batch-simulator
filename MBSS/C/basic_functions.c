#include <main.h>

/* Correspond to def schedule_job_on_earliest_available_cores_no_return(j, node_list, t, nb_non_available_cores) in the python code. */
int schedule_job_on_earliest_available_cores(struct Job* j, struct Node_List** head_node, int t, int nb_non_available_cores, bool use_bigger_nodes)
{
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
	
	//~ if (j->unique_id == 1382)
	//~ {
		//~ print_decision_in_scheduler(j);
	//~ }
	
	/* Need to sort cores after each schedule of a job. */
	sort_cores_by_available_time_in_specific_node(j->node_used);
		
	return nb_non_available_cores;
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
	
	/* Need to sort cores after each schedule of a job. */
	sort_cores_by_available_time_in_specific_node(j->node_used);
		
	return nb_non_available_cores;
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
			/* Remove from list of starting times. */
			if (start_times->head != NULL && start_times->head->time == t)
			{
				//~ #ifdef PRINT
				//~ printf("Before deleting starting time %d:\n", t); fflush(stdout);
				//~ print_time_list(start_times->head, 0);
				//~ #endif
				
				delete_next_time_linked_list(start_times, t);
				
				//~ #ifdef PRINT
				//~ printf("After deleting starting time %d:\n", t); fflush(stdout);
				//~ print_time_list(start_times->head, 0);
				//~ #endif
			}
			
			//~ # For constraint on sizes only. TODO : remove it or put it in an ifdef if I don't have this constraint to gain time ?
			total_queue_time += j->start_time - j->subtime;
			
			int transfer_time = 0;
			int waiting_for_a_load_time = 0;
			//~ if (j->data != 0 && constraint_on_sizes != 2 && j->workload != -2) /* I also don't want to put transfer time on fix workload occupation jobs */
			if (j->data != 0 && constraint_on_sizes != 2) /* I also don't want to put transfer time on fix workload occupation jobs */
			{
				/* Let's look if a data transfer is needed */
				add_data_in_node(j->data, j->data_size, j->node_used, t, j->end_time, &transfer_time, &waiting_for_a_load_time);
			}
			j->transfer_time = transfer_time;
			j->waiting_for_a_load_time = waiting_for_a_load_time;
						
			//~ if (j->unique_id <= 1382)
			//~ {
				//~ printf("%d and %d.\n", j->transfer_time, j->waiting_for_a_load_time);
			//~ }
			
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
				printf("Error calcul transfer time.\n"); fflush(stdout);
				exit(EXIT_FAILURE);
			}
			
			//~ #ifdef PRINT
			//~ printf("For job %d: %d transfer time and %d waiting for a load time.\n", j->unique_id, transfer_time, waiting_for_a_load_time); fflush(stdout);
			//~ #endif
			
			if (j->delay + overhead_of_load < j->walltime)
			{
				min_between_delay_and_walltime = j->delay + overhead_of_load;
				j->end_before_walltime = true;
			}
			else
			{
				min_between_delay_and_walltime = j->walltime;
				j->end_before_walltime = false;
			}
			j->end_time = j->start_time + min_between_delay_and_walltime; /* Attention le j->end time est mis a jour la! */
			
			/* Add in list of end times. */
			//~ #ifdef PRINT
			//~ printf("Before adding ending time %d:\n", j->end_time);
			//~ print_time_list(end_times->head, 1);
			//~ #endif
			
			insert_next_time_in_sorted_list(end_times, j->end_time);
			
			//~ #ifdef PRINT
			//~ printf("After adding ending time %d:\n", j->end_time);
			//~ print_time_list(end_times->head, 1);
			//~ #endif
			
			/* Use next min end time from global variable here :) */
			//~ if (next_end_time > j->end_time || next_end_time == -1)
			//~ {
				//~ next_end_time = j->end_time;
			//~ }
			#ifdef PRINT
			printf("==> Job %d %d cores start at time %d on node %d and will end at time %d before walltime: %d transfer time is %d data was %d.\n", j->unique_id, j->cores, t, j->node_used->unique_id, j->end_time, j->end_before_walltime, transfer_time, j->data);
			#endif
			
			#ifdef PRINT_CLUSTER_USAGE
			running_cores += j->cores;
			if (j->node_used->n_available_cores == 20)
			{
				running_nodes += 1;
			}
			j->node_used->n_available_cores -= j->cores;
			if (j->node_used->n_available_cores < 0)
			{
				printf("error n avail cores start_jobs is %d on node %d.\n", j->node_used->n_available_cores, j->node_used->unique_id);
				exit(EXIT_FAILURE);
			}
			#endif
			
			//~ #ifdef PRINT
			//~ if (j->node_used->unique_id == 183) {
			//~ printf("n avail cores start_jobs %d.\n", j->node_used->n_available_cores); }
			//~ #endif
			
			//~ #ifdef PRINT
			//~ if (j->unique_id <= 1382) {
			//~ printf("==> Job %d start at time %d on node %d and will end at time %d before walltime: %d transfer time is %d data was %d.\n", j->unique_id, t, j->node_used->unique_id, j->end_time, j->end_before_walltime, transfer_time, j->data); }
			//~ #endif
			
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
				
			finished_jobs += 1;
			
			//~ #ifdef PRINT
			//~ if (j->node_used->unique_id == 183)
			//~ {
			//~ printf("==> Job %d %d cores finished at time %d on node %d.\n", j->unique_id, j->cores, t, j->node_used->unique_id);
			//~ }
			//~ #endif
			
			/* Just printing, can remove */
			if (finished_jobs%5000 == 0)
			{
				//~ printf("Evaluated jobs: %d/%d | All jobs: %d/%d | T = %d.\n", nb_job_to_evaluate_finished, nb_job_to_evaluate, finished_jobs, total_number_jobs, t); fflush(stdout);
				//~ printf("Evaluated jobs: %d/%d | All jobs: %d/%d | T = %d.\n", nb_job_to_evaluate_started, nb_job_to_evaluate, finished_jobs, total_number_jobs, t); fflush(stdout);
				printf("Evaluated jobs: %d/%d | All jobs: %d/%d | T = %d.\n", nb_job_to_evaluate_started, nb_job_to_evaluate, finished_jobs, total_number_jobs, t); fflush(stdout);
			}
									
			#ifdef PRINT_CLUSTER_USAGE
			running_cores -= j->cores;
			j->node_used->n_available_cores += j->cores;
			if (j->node_used->n_available_cores == 20)
			{
				running_nodes -= 1;
			}
			if (j->node_used->n_available_cores > 20)
			{
				printf("error n avail jobs on node %d", j->node_used->unique_id);
				exit(EXIT_FAILURE);
			}
			#endif
			
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
						break;
					}
				}
			}
			
			if (j->data != 0)
			{
				remove_data_from_node(j, t);
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
			delete_job_linked_list(running_jobs, j->unique_id);
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

int is_my_file_on_node_at_certain_time_and_transfer_time(int predicted_time, struct Node* n, int t, int current_data, int current_data_size, bool* is_being_loaded)
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
float time_to_reload_percentage_of_files_ended_at_certain_time(int predicted_time, struct Node* n, int current_data, int percentage_occupied)
{
	int size_file_ended = 0;
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
				printf("Add size %d->\n", d->size); fflush(stdout);
				#endif
			}
		}
		d = d->next;
	}
	
	#ifdef PRINT
	printf("Total size of data on node ending before my EAT is: %d but I return (%d*%d)/%f = %f.\n", size_file_ended, percentage_occupied, size_file_ended, n->bandwidth, (size_file_ended*percentage_occupied)/n->bandwidth); fflush(stdout);
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
				
	return earliest_available_time;
}
