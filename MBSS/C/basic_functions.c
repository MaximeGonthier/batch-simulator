#include <main.h>

/* Correspond to def schedule_job_on_earliest_available_cores_no_return(j, node_list, t, nb_non_available_cores) in the python code. */
int schedule_job_on_earliest_available_cores(struct Job* j, struct Node_List** head_node, int t, int nb_non_available_cores)
{
	int i = 0;	
	int min_time = -1;
	int earliest_available_time = 0;
	int first_node_size_to_choose_from = 0;
	int last_node_size_to_choose_from = 0;
	
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
		printf("Error index value in schedule_job_on_earliest_available_cores.\n");
		exit(EXIT_FAILURE);
	}
	
	/* Finding the node with the earliest available time. */
	for (i = first_node_size_to_choose_from; i <= last_node_size_to_choose_from; i++)
	{
		struct Node* n = head_node[i]->head;
		earliest_available_time = n->cores[j->cores - 1]->available_time; /* -1 because tab start at 0 */
		if (earliest_available_time < t) /* A core can't be available before t. This happens when a node is idling. */				
		{
			earliest_available_time = t;
		}
		printf("EAT is: %d\n", earliest_available_time);
		if (min_time == -1 || min_time > earliest_available_time)
		{
			min_time = earliest_available_time;
			j->node_used = n;
		}
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
	printf("EAT is: %d\n", earliest_available_time);
	// choosen_core = node.cores[0:cores_asked]		

	j->node_used = n;
	j->start_time = earliest_available_time;
	j->end_time = earliest_available_time + j->walltime;
	for (i = 0; i < j->cores; i++)
	{
		j->cores_used[i] = n->cores[i]->unique_id;
		n->cores[i]->available_time = earliest_available_time + j->walltime;
		
		/* Maybe I need job queue or not, not sure. TODO. */
		//~ copy_job_and_insert_tail_job_list(n->cores[i]->job_queue, j);
	}
	
	#ifdef PRINT
	print_decision_in_scheduler(j);
	#endif
	
	/* Need to sort cores after each schedule of a job. */
	sort_cores_by_available_time_in_specific_node(n);
}

void sort_cores_by_available_time_in_specific_node(struct Node* n)
{
	for (int step = 0; step < 20 - 1; step++)
	{
		for (int i = 0; i < 20 - step - 1; ++i)
		{
            if (n->cores[i]->available_time > n->cores[i + 1]->available_time) {
        
		struct Core* temp = n->cores[i];
        n->cores[i] = n->cores[i+1];
       n->cores[i + 1] = temp;
      }
    }
  }
}

void add_data_in_node (int data_unique_id, int data_size, struct Node* node_used, int t, int end_time, int* transfer_time, int* waiting_for_a_load_time)
{
	printf("Adding %d.\n", data_unique_id);
	bool data_is_on_node = false;
	/* Let's try to find it in the node */
	struct Data* d = node_used->data->head;
	while (d != NULL)
	{
		printf("Testing %d.\n", d->unique_id);
		if (data_unique_id == d->unique_id) /* It is already on node */
		{
			if (d->nb_task_using_it > 0 || d->end_time == t) /* And is still valid! */
			{
				if (d->start_time > t) /* The job will have to wait for the data to be loaded by another job before starting */
				{
					printf("Will need to wait.\n");
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
				printf("Data %d is not on node anymore need to reload it.\n", data_unique_id);
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
	if (data_is_on_node == false) /* Need to load it */
	{
		printf("Data %d, is not on node %d at all need to create it.\n", data_unique_id, node_used->unique_id);
		*transfer_time = data_size/node_used->bandwidth;
		/* Create a class Data for this node */
		struct Data* new = (struct Data*) malloc(sizeof(struct Data));
		new->unique_id = data_unique_id;
		new->start_time = t + *transfer_time;
		new->end_time = end_time;
		new->nb_task_using_it = 1;
		new->size = data_size;
		new->next = NULL;
		//~ node_used->data->head = new;
		insert_tail_data_list(node_used->data, new);
	}	
	//~ return transfer_time, waiting_for_a_load_time
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
void start_jobs(int t, struct Job* j)
{
	int i = 0;
	int k = 0;
	int overhead_of_load = 0;
	int min_between_delay_and_walltime = 0;
	printf("Start of start_jobs at time %d.\n", t);
	//~ jobs_to_remove = []
	while (j != NULL)
	{
	//~ for j in scheduled_job_list:
		if (j->start_time == t)
		{
			/* Remove from list of starting times. */
			if (start_times->head->time == t)
			{
				printf("Before deleting starting time %d:\n", t);
				print_time_list(start_times->head, 0);
				delete_next_time_linked_list(start_times, t);
				printf("After deleting starting time %d:\n", t);
				print_time_list(start_times->head, 0);
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
			
			printf("For job %d: %d transfer time and %d waiting for a load time.\n", j->unique_id, transfer_time, waiting_for_a_load_time);
			
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
			printf("Before adding ending time %d:\n", j->end_time);
			print_time_list(end_times->head, 1);
			insert_next_time_in_sorted_list(end_times, j->end_time);
			printf("After adding ending time %d:\n", j->end_time);
			print_time_list(end_times->head, 1);
			
			/* Use next min end time from global variable here :) */
			//~ if (next_end_time > j->end_time || next_end_time == -1)
			//~ {
				//~ next_end_time = j->end_time;
			//~ }
			
			#ifdef PRINT_CLUSTER_USAGE
			running_cores += j->cores;
			if (j->node_used->n_available_cores == 20)
			{
				running_nodes += 1;
			}
			j->node_used->n_available_cores -= j->cores;
			#endif
				
			printf("==> Job %d start at time %d on node %d and will end at time %d before walltime: %d transfer time is %d data was %d.\n", j->unique_id, t, j->node_used->unique_id, j->end_time, j->end_before_walltime, transfer_time, j->data);
			
			for (i = 0; i < j->cores; i++)
			{
				for (k = 0; k < 20; k++)
				{
					if (j->node_used->cores[k]->unique_id == j->cores_used[i])
					{
						//~ j->cores[i]->running_job = j;
						j->node_used->cores[k]->running_job = true;
						break;
					}
				}
			}
			//~ jobs_to_remove.append(j)
			//~ insert_tail_job_list(running_jobs, j);
			//~ copy_job_and_insert_tail_job_list(running_jobs, j);
			
		}
		j = j->next;
	}
	
	/* Copy and delete. */
	j = scheduled_job_list->head;
	while (j != NULL)
	{
		if (j->start_time == t)
		{
			struct Job* temp = j->next;
			copy_delete_insert_job_list(scheduled_job_list, running_jobs, j);
			j = temp;
		}
		else
		{
			j = j->next;
		}
	}
	printf("End of start_jobs at time %d.\n", t);
	//~ if len(jobs_to_remove) > 0:
		//~ scheduled_job_list = remove_jobs_from_list(scheduled_job_list, jobs_to_remove)
		//~ available_job_list = remove_jobs_from_list(available_job_list, jobs_to_remove)
	//~ return scheduled_job_list, running_jobs, end_times, running_cores, running_nodes, total_queue_time, available_job_list
}

/* Go through running jobs to find finished jobs. */
void end_jobs(struct Job* job_list_head, int t)
{
	printf("Start of end_jobs at time %d.\n", t);
	int i = 0;
	int k = 0;
	struct Job* j= job_list_head;
	while(j != NULL)
	{
		if (j->end_time == t) /* A job has finished, let's remove it from the cores, write its results and figure out if we need to fill */
		{
			/* Remove from list of ending times. */
			if (end_times->head->time == t)
			{
				printf("Before deleting ending time %d:\n", t);
				print_time_list(end_times->head, 1);
				delete_next_time_linked_list(end_times, t);
				printf("After deleting ending time %d:\n", t);
				print_time_list(end_times->head, 1);
			}
			
			if (j->workload == 1)
			{
				nb_job_to_evaluate_finished += 1;
			}
				
			finished_jobs += 1;
			
			#ifdef PRINT
			printf("==> Job %d finished at time %d on node %d.\n", j->unique_id, t, j->node_used->unique_id); fflush(stdout);
			#endif
			
			/* Just printing, can remove */
			if (finished_jobs%1 == 0)
			{
				printf("Evaluated jobs: %d/%d | All jobs: %d/%d | T = %d.\n", nb_job_to_evaluate_finished, nb_job_to_evaluate, finished_jobs, total_number_jobs, t); fflush(stdout);
			}
									
			#ifdef PRINT_CLUSTER_USAGE
			running_cores -= j->cores;
			j->node_used->n_available_cores += j->cores;
			if (j->node_used->n_available_cores == 20)
			{
				running_nodes -= 1;
			}
			#endif
			
			for (i = 0; i < j->cores; i++)
			{
				for (k = 0; k < 20; k++)
				{
					if (j->node_used->cores[k]->unique_id == j->cores_used[i])
					{
						//~ j->cores[i]->running_job = j;
						j->node_used->cores[k]->running_job = false;
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
			//~ to_print_job_csv(j, j->node_used.unique_id, core_ids, t, first_time_day_0) /* TODO a coder */
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
	printf("End of end_jobs at time %d.\n", t);	fflush(stdout);	
	//~ return finished_jobs, affected_node_list, finished_job_list, running_jobs, running_cores, running_nodes, nb_job_to_evaluate_finished
}

/* Reset available times by going through the cores in each node. */
void reset_cores(struct Node_List** l, int t)
{
	int i = 0;
	int j = 0;
	for (i = 0; i < 3; i++)
	{
		struct Node* n = l[i]->head;
		for (j = 0; j < 20; j++)
		{
			//~ c.job_queue.clear()
			if (n->cores[j]->running_job == false)
			{
				n->cores[j]->available_time = t;
			}
			else
			{
				//~ n[i]->cores[j]->available_time = c.running_job.start_time + c.running_job.walltime;
				//~ c.job_queue.append(c.running_job);
			}
		}
	}
}
