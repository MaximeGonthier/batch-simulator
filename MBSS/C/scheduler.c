#include <main.h>

void get_state_before_day_0_scheduler(struct Job* j, struct Node_List** n, int t)
{
	int i = 0;
			
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
	printf("%d nodes of size 128, %d of size 256 and %d of size 1024.\n", nb_node[0], nb_node[1], nb_node[2]);
	free(temp);

	while (j != NULL)
	{
		/* Insert in scheduled_job_list */
		insert_tail_job_list(scheduled_job_list, j);
		
		int time_since_start = t - j->start_time_from_history;
		j->delay -= time_since_start;
		j->walltime -= time_since_start;
		j->start_time = t;
		
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
		printf("Choosen node is: ");
		print_single_node(choosen_node);
		//~ choosen_core, earliest_available_time = return_earliest_available_cores_and_start_time_specific_node(j->cores, choosen_node, t)
		
		//~ start_time = earliest_available_time
		//~ j->node_used = choosen_node
		//~ j->cores_used = choosen_core
		//~ j->start_time = start_time
		//~ j->end_time = start_time + j->walltime			
		//~ for c in choosen_core:
			//~ c.job_queue.append(j)			
			//~ c.available_time = start_time + j->walltime
				
		//~ if __debug__:
			//~ print_decision_in_scheduler(choosen_core, j, choosen_node)
		//~ if j->unique_id == 1362:
			//~ print_decision_in_scheduler(choosen_core, j, choosen_node)
			
		j = j->next;
		//~ free(choosen_node);
	}
	free(nb_node);
}
