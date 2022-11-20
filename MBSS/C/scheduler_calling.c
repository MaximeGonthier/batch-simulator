#include <main.h>

void call_scheduler(char* scheduler, struct Job_List* liste, int t, int use_bigger_nodes, int multiplier_file_to_load, int multiplier_file_evicted, int multiplier_nb_copy, int adaptative_multiplier, int penalty_on_job_sizes, int start_immediately_if_EAT_is_t, int backfill_mode, int number_node_size_128_and_more, int number_node_size_256_and_more, int number_node_size_1024, float (*Ratio_Area)[3], int multiplier_area_bigger_nodes, int division_by_planned_area, int backfill_big_node_mode, int mixed_strategy)
{
	int i = 0;
	int j = 0;
	
	if (strncmp(scheduler, "Fcfs_with_a_score_x", 19) == 0 || strncmp(scheduler, "Fcfs_with_a_score_adaptative_multiplier_x", 41) == 0 || strncmp(scheduler, "Fcfs_with_a_score_adaptative_multiplier_3_x", 43) == 0 || strncmp(scheduler, "Fcfs_with_a_score_adaptative_multiplier_4_x", 43) == 0 || strncmp(scheduler, "Fcfs_with_a_score_penalty_on_big_jobs_x", 39) == 0 || strncmp(scheduler, "Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_x", 53) == 0) /* Ok avec DATA_PERSISTENCE */
	{
		fcfs_with_a_score_scheduler(liste->head, node_list, t, multiplier_file_to_load, multiplier_file_evicted, multiplier_nb_copy, adaptative_multiplier, penalty_on_job_sizes, start_immediately_if_EAT_is_t, 0);
	}
	else if (strncmp(scheduler, "Fcfs_with_a_score_easybf_x", 26) == 0 || strncmp(scheduler, "Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_easybf_x", 60) == 0)
	{
		#ifdef DATA_PERSISTENCE
		printf("DATA_PERSISTENCE not dealt with for this scheduler.\n"); exit(1);
		#endif
				
		fcfs_with_a_score_easybf_scheduler(liste->head, node_list, t, multiplier_file_to_load, multiplier_file_evicted, multiplier_nb_copy, adaptative_multiplier, penalty_on_job_sizes, start_immediately_if_EAT_is_t);
	}
	else if (strncmp(scheduler, "Fcfs_with_a_score_conservativebf_x", 34) == 0 || strncmp(scheduler, "Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_conservativebf_x", 68) == 0) /* Ok avec DATA_PERSISTENCE */
	{
		fcfs_with_a_score_conservativebf_scheduler(liste->head, node_list, t, multiplier_file_to_load, multiplier_file_evicted, adaptative_multiplier, start_immediately_if_EAT_is_t, backfill_mode, mixed_strategy);
	}
	else if (strncmp(scheduler, "Fcfs_with_a_score_mixed_strategy_easybf_x", 41) == 0) /* Ok avec DATA_PERSISTENCE */
	{
		if (busy_cluster == 1)
		{
			fcfs_with_a_score_easybf_scheduler(liste->head, node_list, t, multiplier_file_to_load, multiplier_file_evicted, multiplier_nb_copy, adaptative_multiplier, penalty_on_job_sizes, start_immediately_if_EAT_is_t);
		}
		else
		{
			fcfs_with_a_score_easybf_scheduler(liste->head, node_list, t, 1, 0, 0, 0, 0, 0);
		}
	}
	else if (strncmp(scheduler, "Fcfs_with_a_score_mixed_strategy_conservativebf_x", 49) == 0) /* Ok avec DATA_PERSISTENCE */
	{	
		//~ if (busy_cluster == 1)
		//~ {
			//~ fcfs_with_a_score_conservativebf_scheduler(liste->head, node_list, t, multiplier_file_to_load, multiplier_file_evicted, adaptative_multiplier, start_immediately_if_EAT_is_t, backfill_mode);
		//~ }
		//~ else
		//~ {
			//~ fcfs_with_a_score_conservativebf_scheduler(liste->head, node_list, t, 1, 0, 0, 0, backfill_mode);
		//~ }
		
		/* NEW */
		//~ fcfs_with_a_score_conservativebf_scheduler(liste->head, node_list, t, 1, 0, 0, 0, backfill_mode, mixed_strategy);
		fcfs_with_a_score_conservativebf_scheduler(liste->head, node_list, t, multiplier_file_to_load, multiplier_file_evicted, adaptative_multiplier, start_immediately_if_EAT_is_t, backfill_mode, mixed_strategy);
	}
	else if (strcmp(scheduler, "Mix_score_nb_running_jobs") == 0) /* Ok avec DATA_PERSISTENCE */
			{
				if (nb_job_to_schedule >= 486 - running_nodes)
				{
					fcfs_with_a_score_scheduler(liste->head, node_list, t, 500, 50, 0, 0, 0, 0, 0);
				}
				else
				{
					eft_scheduler(liste->head, node_list, t);
				}
			}
	else if (strcmp(scheduler, "EFT") == 0) /* Ok avec DATA_PERSISTENCE */
	{
		eft_scheduler(liste->head, node_list, t);
	}
	else if (strcmp(scheduler, "EFT_if_nb_jobs_superior_to_available_nodes") == 0) /* Ok avec DATA_PERSISTENCE */
	{
		if (486 - running_nodes >= nb_job_to_schedule)
		{
			eft_scheduler(liste->head, node_list, t);
		}
		else
				{
					fcfs_with_a_score_scheduler(liste->head, node_list, t, 500, 1, 0, 0, 0, 0, 0);
				}
			}
			else if (strcmp(scheduler, "Mixed_strategy") == 0) /* Ok avec DATA_PERSISTENCE */
			{
				if (busy_cluster == 1)
				{
					locality_scheduler(liste->head, node_list, t);
				}
				else
				{
					eft_scheduler(liste->head, node_list, t);
				}
			}
			else if (strcmp(scheduler, "Try_EFT_else_do_SCORE") == 0) 
			{
				#ifdef DATA_PERSISTENCE
				printf("DATA_PERSISTENCE not dealt with for this scheduler.\n"); exit(1);
				#endif
				
				/* Create a fake node_list with fake cores that copy the real node_list.
				 * Copy it's content from the real node_list. */
				struct Node_List** fake_node_list = (struct Node_List**) malloc(3*sizeof(struct Node_List));
				for (i = 0; i < 3; i++)
				{
					/* Allocate */
					fake_node_list[i] = (struct Node_List*) malloc(sizeof(struct Node_List));
					fake_node_list[i]->head = NULL;
					fake_node_list[i]->tail = NULL;
					/* Copy */
					struct Node* n = node_list[i]->head;
					while (n != NULL)
					{
						/* The node */
						struct Node *new = (struct Node*) malloc(sizeof(struct Node));								
						new->unique_id = n->unique_id;
						new->memory = n->memory;
						new->bandwidth = n->bandwidth;
						new->n_available_cores = n->n_available_cores;
						new->index_node_list = n->index_node_list;
						/* The data */
						new->data = malloc(sizeof(*new->data));
						new->data->head = NULL;
						new->data->tail = NULL;
						struct Data* d = n->data->head;
						while (d != NULL)
						{
							struct Data* new_data = (struct Data*) malloc(sizeof(struct Data));
							new_data->unique_id = d->unique_id;
							new_data->start_time = d->start_time;
							new_data->end_time = d->end_time;
							
							#ifndef DATA_PERSISTENCE
							new_data->nb_task_using_it = d->nb_task_using_it;
							#endif
							
							/* Copy Intervals */
							/* Pas besoin car je les get au début du schedule. */
							new_data->size = d->size;
							new_data->next = NULL;
							insert_tail_data_list(new->data, new_data);
							d = d->next;
						}
						/* The cores */
						new->cores = (struct Core**) malloc(20*sizeof(struct Core));
						for (j = 0; j < 20; j++)
						{
							new->cores[j] = (struct Core*) malloc(sizeof(struct Core));
							new->cores[j]->unique_id = n->cores[j]->unique_id;
							new->cores[j]->available_time = n->cores[j]->available_time;
							new->cores[j]->running_job = n->cores[j]->running_job;
							new->cores[j]->running_job_end = n->cores[j]->running_job_end;
						}
						
						/* For conservative bf */
						new->number_cores_in_a_hole = 0;
						//~ new->cores_in_a_hole = NULL;
						//~ new->start_time_of_the_hole = NULL;
						//~ new->cores_in_a_hole = NULL; /* free plutot ? */
						new->cores_in_a_hole = malloc(sizeof(*new->cores_in_a_hole));
						new->cores_in_a_hole->head = NULL;
						new->cores_in_a_hole->tail = NULL;
						
						#ifdef DATA_PERSISTENCE
						new->data_occupation = n->data_occupation;
						new->temp_data = malloc(sizeof(*new->temp_data));
						new->temp_data->head = NULL;
						new->temp_data->tail = NULL;
						#endif
						
						/* Insert node */
						new->next = NULL;
						insert_tail_node_list(fake_node_list[i], new);
						n = n->next;
					}
				}

		double success = fake_eft_scheduler(liste->head, fake_node_list, t, 1);
				//~ double success = 1;
				//~ printf("Mean flow is (-1 if failed t) %f.\n", success);
		if (success == -1) /* It failed I must do score */
				{
					//~ printf("SCORE\n");
					fcfs_with_a_score_scheduler(liste->head, node_list, t, 500, 1, 0, 0, 0, 0, 0);
					/* Multiplicateur qui dépend  */
					//~ fcfs_with_a_score_scheduler(liste->head, node_list, t, 500, 1, 0, 3, 0, 0);
				}
				else /* EFT succeded I can start it. */
				{
					//~ printf("EFT\n");
					eft_scheduler(liste->head, node_list, t); 
				}
			}
			else if (strcmp(scheduler, "Mixed_strategy_if_EAT_is_t") == 0) /* Ok avec DATA_PERSISTENCE */
			{
				mixed_if_EAT_is_t_scheduler(liste->head, node_list, t, 0);
			}
			else if (strcmp(scheduler, "Mixed_strategy_if_EAT_is_t_no_TLE") == 0) /* Ok avec DATA_PERSISTENCE */
			{
				mixed_if_EAT_is_t_scheduler(liste->head, node_list, t, 1);
			}
			else if (strncmp(scheduler, "Flow_adaptation", 15) == 0) /** Flow_adaptation_EFT_score or Flow_adaptation_EFT_locality **/
			{
				#ifdef DATA_PERSISTENCE
				printf("DATA_PERSISTENCE not dealt with for this scheduler.\n"); exit(1);
				#endif
				
				/* Create a fake node_list with fake cores that copy the real node_list.
				 * Copy it's content from the real node_list. */
				struct Node_List** fake_node_list = (struct Node_List**) malloc(3*sizeof(struct Node_List));
				for (i = 0; i < 3; i++)
				{
					/* Allocate */
					fake_node_list[i] = (struct Node_List*) malloc(sizeof(struct Node_List));
					fake_node_list[i]->head = NULL;
					fake_node_list[i]->tail = NULL;
					/* Copy */
					struct Node* n = node_list[i]->head;
					while (n != NULL)
					{
						/* The node */
						struct Node *new = (struct Node*) malloc(sizeof(struct Node));								
						new->unique_id = n->unique_id;
						new->memory = n->memory;
						new->bandwidth = n->bandwidth;
						new->n_available_cores = n->n_available_cores;
						new->index_node_list = n->index_node_list;
						/* The data */
						new->data = malloc(sizeof(*new->data));
						new->data->head = NULL;
						new->data->tail = NULL;
						struct Data* d = n->data->head;
						while (d != NULL)
						{
							struct Data* new_data = (struct Data*) malloc(sizeof(struct Data));
							new_data->unique_id = d->unique_id;
							new_data->start_time = d->start_time;
							new_data->end_time = d->end_time;
							
							#ifndef DATA_PERSISTENCE
							new_data->nb_task_using_it = d->nb_task_using_it;
							#endif
							
							/* Copy Intervals */
							/* Pas besoin car je les get au début du schedule. */
							new_data->size = d->size;
							new_data->next = NULL;
							insert_tail_data_list(new->data, new_data);
							d = d->next;
						}
						/* The cores */
						new->cores = (struct Core**) malloc(20*sizeof(struct Core));
						for (j = 0; j < 20; j++)
						{
							new->cores[j] = (struct Core*) malloc(sizeof(struct Core));
							new->cores[j]->unique_id = n->cores[j]->unique_id;
							new->cores[j]->available_time = n->cores[j]->available_time;
							new->cores[j]->running_job = n->cores[j]->running_job;
							new->cores[j]->running_job_end = n->cores[j]->running_job_end;
						}
						
						/* For conservative bf */
						new->number_cores_in_a_hole = 0;
						//~ new->cores_in_a_hole = NULL;
						//~ new->start_time_of_the_hole = NULL;
						//~ new->cores_in_a_hole = NULL; /* free plutot ? */
						new->cores_in_a_hole = malloc(sizeof(*new->cores_in_a_hole));
						new->cores_in_a_hole->head = NULL;
						new->cores_in_a_hole->tail = NULL;
						
						#ifdef DATA_PERSISTENCE
						new->data_occupation = n->data_occupation;
						new->temp_data = malloc(sizeof(*new->temp_data));
						new->temp_data->head = NULL;
						new->temp_data->tail = NULL;
						#endif
						
						/* Insert node */
						new->next = NULL;
						insert_tail_node_list(fake_node_list[i], new);
						n = n->next;
					}
				}
				/* La je fais pas l'arret quand tout les cores sont recouvert. Alors que dans le schedule ensuite oui. */
				double EFT_mean_flow = fake_eft_scheduler(liste->head, fake_node_list, t, 0);			
				double locality_mean_flow = 0;
				if (strcmp(scheduler, "Flow_adaptation_EFT_locality") == 0)
				{
					locality_mean_flow = fake_locality_scheduler(liste->head, fake_node_list, t);
				}
				else if (strcmp(scheduler, "Flow_adaptation_EFT_score") == 0)
				{
					locality_mean_flow = fake_fcfs_with_a_score_scheduler(liste->head, fake_node_list, t, 500, 50, 0, 0, 0);
				}
				else
				{
					printf("Error Flow adapatation scheduler does not exist.\n");
					exit(EXIT_FAILURE);
				}
				//~ printf("EFT flow is %d, Locality flow is %d.\n", EFT_flow, locality_flow);	
				if (EFT_mean_flow < locality_mean_flow)
				{
					//~ printf("EFT\n");
					eft_scheduler(liste->head, node_list, t);
				}
				else
				{
					if (strcmp(scheduler, "Flow_adaptation_EFT_locality") == 0)
					{
						locality_scheduler(liste->head, node_list, t);
					}
					else
					{
						//~ printf("SCORE\n");
						fcfs_with_a_score_scheduler(liste->head, node_list, t, 500, 50, 0, 0, 0, 0, 0);
					}
				}
			}
			else if (strncmp(scheduler, "Fcfs_with_a_score_mixed_strategy_x", 34) == 0 || strncmp(scheduler, "Fcfs_with_a_score_mixed_strategy_adaptative_multiplier_x", 56) == 0 || strncmp(scheduler, "Fcfs_with_a_score_mixed_strategy_non_dynamic_x", 46) == 0) /* Ok avec DATA_PERSISTENCE */
			{
				//~ if (busy_cluster == 1)
				//~ {
					//~ #ifdef PRINT_CLUSTER_USAGE
					//~ mixed_mode = 1;
					//~ #endif
					
					//~ fcfs_with_a_score_scheduler(liste->head, node_list, t, multiplier_file_to_load, multiplier_file_evicted, multiplier_nb_copy, adaptative_multiplier, penalty_on_job_sizes, start_immediately_if_EAT_is_t, mixed_strategy);
				//~ }
				//~ else
				//~ {
					//~ #ifdef PRINT_CLUSTER_USAGE
					//~ mixed_mode = 0;
					//~ #endif
					
					//~ // eft_scheduler(liste->head, node_list, t);
					//~ fcfs_with_a_score_scheduler(liste->head, node_list, t, 1, 0, 0, adaptative_multiplier, penalty_on_job_sizes, start_immediately_if_EAT_is_t, mixed_strategy);
					//~ /* try score avec 1 ? */
				//~ }
				fcfs_with_a_score_scheduler(liste->head, node_list, t, multiplier_file_to_load, multiplier_file_evicted, multiplier_nb_copy, adaptative_multiplier, penalty_on_job_sizes, start_immediately_if_EAT_is_t, mixed_strategy);
			}
			else if (strncmp(scheduler, "Fcfs_with_a_score_mixed_strategy_not_EFT_x", 43) == 0) /* Ok avec DATA_PERSISTENCE */
			{
				if (busy_cluster == 1)
				{
					fcfs_with_a_score_scheduler(liste->head, node_list, t, multiplier_file_to_load, multiplier_file_evicted, multiplier_nb_copy, adaptative_multiplier, penalty_on_job_sizes, start_immediately_if_EAT_is_t, mixed_strategy);
				}
				else
				{
					fcfs_with_a_score_scheduler(liste->head, node_list, t, 1, 1, 0, adaptative_multiplier, penalty_on_job_sizes, start_immediately_if_EAT_is_t, mixed_strategy);
				}
			}
			else if (strncmp(scheduler, "Fcfs_with_a_score_backfill_big_nodes_95th_percentile_x", 54) == 0)
			{
				#ifdef DATA_PERSISTENCE
				printf("DATA_PERSISTENCE not dealt with for this scheduler.\n"); exit(1);
				#endif
				fcfs_with_a_score_backfill_big_nodes_95th_percentile_scheduler(liste->head, node_list, t, multiplier_file_to_load, multiplier_file_evicted, multiplier_nb_copy, number_node_size_128_and_more, number_node_size_256_and_more, number_node_size_1024);
			}
			else if (strncmp(scheduler, "Fcfs_with_a_score_backfill_big_nodes_weighted_random_x", 54) == 0)
			{
				#ifdef DATA_PERSISTENCE
				printf("DATA_PERSISTENCE not dealt with for this scheduler.\n"); exit(1);
				#endif
				fcfs_with_a_score_backfill_big_nodes_weighted_random_scheduler(liste->head, node_list, t, multiplier_file_to_load, multiplier_file_evicted, multiplier_nb_copy);
			}
			else if (strncmp(scheduler, "Fcfs_with_a_score_backfill_big_nodes_gain_loss_tradeoff_x", 57) == 0)
			{
				#ifdef DATA_PERSISTENCE
				printf("DATA_PERSISTENCE not dealt with for this scheduler.\n"); exit(1);
				#endif
				fcfs_with_a_score_backfill_big_nodes_gain_loss_tradeoff_scheduler(liste->head, node_list, t, multiplier_file_to_load, multiplier_file_evicted, multiplier_nb_copy);
			}
			else if (strncmp(scheduler, "Fcfs_area_filling_with_a_score_x", 32) == 0 || strncmp(scheduler, "Fcfs_area_filling_omniscient_with_a_score_x", 43) == 0 || strncmp(scheduler, "Fcfs_area_filling_with_ratio_with_a_score_x", 43) == 0 || strncmp(scheduler, "Fcfs_area_filling_with_ratio_7_days_earlier_with_a_score_x", 58) == 0 || strncmp(scheduler, "Fcfs_area_filling_omniscient_with_ratio_with_a_score_x", 54) == 0)
			{
				#ifdef DATA_PERSISTENCE
				printf("DATA_PERSISTENCE not dealt with for this scheduler.\n"); exit(1);
				#endif
				fcfs_with_a_score_area_filling_scheduler(liste->head, node_list, t, multiplier_file_to_load, multiplier_file_evicted, multiplier_nb_copy, planned_or_ratio, Ratio_Area);
			}
	else if (strncmp(scheduler, "Fcfs_with_a_score_area_factor_x", 31) == 0 || strncmp(scheduler, "Fcfs_with_a_score_area_factor_with_omniscient_planned_area_x", 60) == 0 || strncmp(scheduler, "Fcfs_with_a_score_area_factor_with_planned_area_x", 49) == 0)
	{
		#ifdef DATA_PERSISTENCE
		printf("DATA_PERSISTENCE not dealt with for this scheduler.\n"); exit(1);
		#endif
		fcfs_with_a_score_area_factor_scheduler(liste->head, node_list, t, multiplier_file_to_load, multiplier_file_evicted, multiplier_nb_copy, multiplier_area_bigger_nodes, division_by_planned_area);
	}
	else if ((strcmp(scheduler, "Fcfs") == 0) || (strcmp(scheduler, "Fcfs_no_use_bigger_nodes") == 0) || (strcmp(scheduler, "Fcfs_big_job_first") == 0)) /* Ok avec DATA_PERSISTENCE */
	{
		fcfs_scheduler(liste->head, node_list, t, use_bigger_nodes);
	}
	else if (strcmp(scheduler, "Fcfs_easybf") == 0 || strcmp(scheduler, "Fcfs_no_use_bigger_nodes_easybf") == 0)
	{
		fcfs_easybf_scheduler(liste->head, node_list, t, use_bigger_nodes);
	}
	else if (strcmp(scheduler, "Fcfs_conservativebf") == 0)
	{
		fcfs_conservativebf_scheduler(liste->head, node_list, t, backfill_mode);
	}
	else if ((strcmp(scheduler, "Fcfs_backfill_big_nodes_0") == 0) || (strcmp(scheduler, "Fcfs_backfill_big_nodes_1") == 0) || (strcmp(scheduler, "Fcfs_backfill_big_nodes_0_big_job_first") == 0) || (strcmp(scheduler, "Fcfs_backfill_big_nodes_1_big_job_first") == 0))
	{
		#ifdef DATA_PERSISTENCE
		printf("DATA_PERSISTENCE not dealt with for this scheduler.\n"); exit(1);
		#endif
		fcfs_scheduler_backfill_big_nodes(liste->head, node_list, t, backfill_big_node_mode, total_queue_time, finished_jobs);
	}
	else if (strcmp(scheduler, "Fcfs_area_filling_with_ratio") == 0 || strcmp(scheduler, "Fcfs_area_filling_omniscient_with_ratio") == 0 || strcmp(scheduler, "Fcfs_area_filling_with_ratio_big_job_first") == 0 || strcmp(scheduler, "Fcfs_area_filling_omniscient_with_ratio_big_job_first") == 0 || strcmp(scheduler, "Fcfs_area_filling_with_ratio_7_days_earlier") == 0)
	{
		#ifdef DATA_PERSISTENCE
		printf("DATA_PERSISTENCE not dealt with for this scheduler.\n"); exit(1);
		#endif
		fcfs_scheduler_ratio_area_filling(liste->head, node_list, t, Ratio_Area);
	}
	else if (strcmp(scheduler, "Fcfs_area_filling") == 0 || strcmp(scheduler, "Fcfs_area_filling_omniscient") == 0 || strcmp(scheduler, "Fcfs_area_filling_big_job_first") == 0 || strcmp(scheduler, "Fcfs_area_filling_omniscient_big_job_first") == 0)
	{
		#ifdef DATA_PERSISTENCE
		printf("DATA_PERSISTENCE not dealt with for this scheduler.\n"); exit(1);
		#endif
		fcfs_scheduler_planned_area_filling(liste->head, node_list, t);
	}
	else
	{
		printf("Error: wrong scheduler in arguments.\n"); fflush(stdout);
		exit(EXIT_FAILURE);
	}
}
