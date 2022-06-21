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
	//~ print_job_list(scheduled_job_list->head);
	//~ print_job_list(job_list_to_start_from_history->head);
	//~ exit(1);
	free(nb_node);

	//~ j = scheduled_job_list->head;
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
		
		insert_next_time_in_sorted_list(start_times, j->start_time);
		
		//~ #ifdef PRINT
		//~ printf("After adding starting time %d:\n", j->start_time);
		//~ print_time_list(start_times->head, 0);
		//~ #endif
			
		j = j->next;
	}
}
