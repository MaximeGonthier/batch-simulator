#include <main.h>

bool can_it_get_backfilled (struct Job* j, struct Node* n, int t, int* nb_cores_from_hole, int* nb_cores_from_outside)
{
	*nb_cores_from_hole = 0;
	*nb_cores_from_outside = 0;
	int k = 0;
	struct Core_in_a_hole* c = (struct Core_in_a_hole*) malloc(sizeof(struct Core_in_a_hole));
	
	#ifdef PRINT
	printf("Can we backfill job %d on node %d?\n", j->unique_id, n->unique_id);
	#endif
	
	if (n->number_cores_in_a_hole != 0 && (j->cores <= n->number_cores_in_a_hole || n->cores[j->cores - 1 - n->number_cores_in_a_hole]->available_time <= t)) /* Il y a un trou et je peux rentrer dedans ou au moins en utiliser une partie! */
	{
		#ifdef PRINT
		printf("It could maybe fit or partially fit in the %d cores composing the hole of node %d.\n", n->number_cores_in_a_hole, n->unique_id);
		#endif
		//~ print_holes_specific_node(n);
		c = n->cores_in_a_hole->head;
		for (k = 0; k < n->number_cores_in_a_hole; k++)
		{
			//~ printf("Checking core %d next start time %d.\n", c->unique_id, c->start_time_of_the_hole); fflush(stdout);
			if (t + j->walltime <= c->start_time_of_the_hole)
			{
				*nb_cores_from_hole += 1;
			}
			//~ printf("%d.\n", *nb_cores_from_hole);  fflush(stdout);
			//~ if (c->next != NULL)
			//~ {
				c = c->next;
			//~ }
			//~ else
			//~ {
				//~ break;
			//~ }
			if (j->cores == *nb_cores_from_hole)
			{
				//~ printf("break\n");  fflush(stdout);
				break;
			}
		}
		//~ exit(1);
		
		//~ #ifdef PRINT
		//~ printf("nb_cores_from_hole = %d.\n", *nb_cores_from_hole);
		//~ #endif
					
		if (nb_cores_from_hole > 0)
		{
			*nb_cores_from_outside = j->cores - *nb_cores_from_hole;
			//~ nb_cores_from_outside = nb_cores_from_outside;
		
			#ifdef PRINT
			printf("Number of cores from the hole/outside: %d/%d.\n", *nb_cores_from_hole, *nb_cores_from_outside);
			#endif
						
			//~ k = 0;
			//~ while (nb_cores_from_outside != 0)
			for (k = 0; k < *nb_cores_from_outside; k++)
			{
				if (n->cores[k]->available_time > t)
				{
					//~ nb_cores_from_outside--;
					//~ k++;
				//~ }
				//~ else
				//~ {
					#ifdef PRINT
					printf("Could not fit in the hole because outside cores don't match. Return false.\n");
					#endif
					
					return false;
				}
			}
			//~ exit(1);
			
			//~ if (nb_cores_from_outside == 0)
			if (k == *nb_cores_from_outside)
			{
				/* On break et on met à vrai le booleen pour dire que le remplissage des cores sera différent et qu'il faut pas sort les cores de la node et qu'il faut mettre à jour le nombre de cores dans un trou de la node et mettre à jour le nb de non available cores. */
				#ifdef PRINT
				printf("Can fit in the hole and start at time t = %d. Return true.\n", t);
				#endif
				
				//~ backfilled_job = true;	
				//~ min_time = t;
				//~ j->node_used = n;
				//~ i = last_node_size_to_choose_from + 1;						
				//~ break;
				return true;
			}
		}
	}
	#ifdef PRINT
	printf("Could not fit or times not available. Return false.\n");
	#endif
	return false;
}							

void update_cores_for_backfilled_job(struct Job* j, int t, int nb_cores_from_hole, int nb_cores_from_outside)
{
	struct Core_in_a_hole* c = (struct Core_in_a_hole*) malloc(sizeof(struct Core_in_a_hole));
	int i = 0;
	int k = 0;
	
	#ifdef PLOT_STATS
	number_of_backfilled_jobs += 1;
	#endif
	
	/* Ca ajoute des unavailable cores puisque c'est à t. */
	//~ nb_non_available_cores_at_time_t += j->cores;
	
	/* Mettre les cores dans le job depuis ceux du trou. */
	c = j->node_used->cores_in_a_hole->head;
	
	if (nb_cores_from_hole > j->cores || nb_cores_from_hole > j->node_used->number_cores_in_a_hole)
	{ 
		printf("Error cores: %d cores taken from hole, %d cores on the job, %d cores in a hole of the node.\n", nb_cores_from_hole, j->cores, j->node_used->number_cores_in_a_hole); 
		fflush(stdout); 
		exit(1); 
	}
	
	for (k = 0; k < nb_cores_from_hole;)
	{
		if (t + j->walltime <= c->start_time_of_the_hole)
		{
			j->cores_used[i] = c->unique_id;
			i++;
			#ifdef PRINT
			printf("Adding %d in cores used from hole of node %d.\n", c->unique_id, j->node_used->unique_id);
			#endif
			k++;
		}	
	
		//~ /* Je rentre la dedans ? je crois pas. */
		//~ if (c->next == NULL && k != nb_cores_from_hole)
		//~ {
			//~ #ifdef PRINT
			//~ printf("next is null\n"); fflush(stdout);
			//~ #endif
		//~ }
		c = c->next;
	}
	
	for (k = 0; k < nb_cores_from_outside; k++)
	{
		#ifdef PRINT
		printf("Adding core from outside %d.\n", j->node_used->cores[k]->unique_id);
		#endif
				
		j->cores_used[i] = j->node_used->cores[k]->unique_id;
		j->node_used->cores[k]->available_time = t + j->walltime;
		i++;
	}		
	
	j->node_used->number_cores_in_a_hole -= nb_cores_from_hole;

	if (j->node_used->number_cores_in_a_hole < 0 || j->node_used->number_cores_in_a_hole > 19)
	{
		printf("Error nb core in hole %d on node %d.\n", j->node_used->number_cores_in_a_hole, j->node_used->unique_id); 
		fflush(stdout);
		exit(1);
	}
	
	if (j->node_used->number_cores_in_a_hole == 0)
	{
		#ifdef PRINT
		printf("Deleting all the cores in the hole cause we use them all.\n");
		#endif
				
		free_cores_in_a_hole(&j->node_used->cores_in_a_hole->head);
	}
	else
	{
		for (i = 0; i < nb_cores_from_hole; i++)
		{
			#ifdef PRINT
			printf("Deleting core %d.\n", j->cores_used[i]);
			#endif
				
			delete_core_in_hole_specific_core(j->node_used->cores_in_a_hole, j->cores_used[i]);
		}
	}
	
	#ifdef PRINT
	printf("Holes on node %d after this backfill are:\n", j->node_used->unique_id);
	print_holes_specific_node(j->node_used);
	#endif
	
	//~ return nb_non_available_cores_at_time_t;
}

void fill_cores_minimize_holes (struct Job* j, bool backfill_activated, int backfill_mode, int t, int* nb_non_available_cores)
{
	int i = 0;
	int k = 0;
	sort_cores_by_unique_id_in_specific_node(j->node_used); /* Attention, il faut faire gaffe que dans le scheduler c'est ensuite re sort dans le sens des temps disponible le plus tôt. */
	for (i = 0; i < j->cores; i++)
	{
		while(1)
		{
			if (j->node_used->cores[k]->available_time <= j->start_time)
			{
				j->cores_used[i] = j->node_used->cores[k]->unique_id;
				
				if (j->node_used->cores[k]->available_time <= t)
				{
					*nb_non_available_cores += 1;
				}
						
				if (backfill_activated == true)
				{
					/* Spécifique au cas avec backfilling */
					if (j->node_used->cores[k]->available_time <= t && j->start_time > t)
					{
						#ifdef PRINT
						printf("Il va y avoir un trou sur node %d core %d.\n", j->node_used->unique_id, j->node_used->cores[k]->unique_id); fflush(stdout);
						#endif
						j->node_used->number_cores_in_a_hole += 1;
						struct Core_in_a_hole* new = (struct Core_in_a_hole*) malloc(sizeof(struct Core_in_a_hole));
						new->unique_id = j->node_used->cores[k]->unique_id;
						new->start_time_of_the_hole = j->start_time;
						new->next = NULL;
						if (j->node_used->cores_in_a_hole == NULL)
						{
							initialize_cores_in_a_hole(j->node_used->cores_in_a_hole, new);
						}
						else
						{
							if (backfill_mode == 2) /* Favorise les jobs backfill car se met sur le coeurs qui a le temps le plus petit possible. */
							{
								insert_cores_in_a_hole_list_sorted_increasing_order(j->node_used->cores_in_a_hole, new);
							}
							else
							{
								insert_cores_in_a_hole_list_sorted_decreasing_order(j->node_used->cores_in_a_hole, new);
							}
						}
					}
					/* Fin de spécifique au cas avec backfilling */
				}

				j->node_used->cores[k]->available_time = j->start_time + j->walltime;
				k++;
				break;
			}
			k++;
		}
	}
}

bool only_check_conservative_backfill(struct Job* j, struct Node_List** head_node, int t, int backfill_mode, int* nb_non_available_cores_at_time_t)
{
	/* NEW core selection conservative bf only */
	int nb_cores_from_hole = 0;
	int nb_cores_from_outside = 0;
	//~ int nb_cores_from_outside_remembered = 0;
	/* End of NEW core selection conservative bf only */
	
	/* OLD */
	//~ bool can_fit = false;
	/* OLD */
	
	#ifdef PRINT
	printf("\nScheduling job %d at time %d. Backfill mode is %d.\n", j->unique_id, t, backfill_mode);
	#endif

	//~ int parcours_des_nodes = 0;
	//~ int start_index = 0;
	int i = 0;
	//~ int k = 0;
	int min_time = -1;
	//~ int earliest_available_time = 0;
	int first_node_size_to_choose_from = 0;
	int last_node_size_to_choose_from = 0;
	bool backfilled_job = false;
	//~ struct Core_in_a_hole* c = (struct Core_in_a_hole*) malloc(sizeof(struct Core_in_a_hole));
	
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

	/* Finding the node with the earliest available time. */
	//~ for (parcours_des_nodes = 0; parcours_des_nodes < 2; parcours_des_nodes++) /* Pour faire nodes puis trou ou l'inverse. */
	//~ {
		for (i = first_node_size_to_choose_from; i <= last_node_size_to_choose_from; i++)
		{
			struct Node* n = head_node[i]->head;
			while (n != NULL)
			{
				//~ if ((parcours_des_nodes == 0 && (backfill_mode == 0 || backfill_mode == 2 || backfill_mode == 3)) || (parcours_des_nodes == 1 && (backfill_mode == 1)))
				//~ {
					#ifdef PRINT
					printf("Checking node %d.\n", n->unique_id);
					#endif
					
					//~ earliest_available_time = n->cores[j->cores - 1]->available_time;
					//~ if (earliest_available_time < t)	
					//~ {
						//~ earliest_available_time = t;
					//~ }
								
					//~ if (min_time == -1 || min_time > earliest_available_time)
					//~ {
						//~ min_time = earliest_available_time;
						//~ j->node_used = n;
						
						//~ if (min_time == t)
						//~ {
							//~ #ifdef PRINT
							//~ printf("min_time == t, break.\n");
							//~ #endif
							
							//~ i = last_node_size_to_choose_from + 1;
							 // //~ parcours_des_nodes = 2;
							//~ break;
						//~ }
					//~ }
				//~ }
				//~ else
				//~ {
					backfilled_job = can_it_get_backfilled(j, n, t, &nb_cores_from_hole, &nb_cores_from_outside);
					if (backfilled_job == true)
					{
						min_time = t;
						j->node_used = n;
						i = last_node_size_to_choose_from + 1;
						j->start_time = min_time;
						j->end_time = min_time + j->walltime;
						update_cores_for_backfilled_job(j, t, nb_cores_from_hole, nb_cores_from_outside);
						*nb_non_available_cores_at_time_t += j->cores;
						
						/* NEW core selection */
						if (nb_cores_from_outside > 0)
						{
							sort_cores_by_available_time_in_specific_node(j->node_used);
						}
						/* End of NEW core selection */
			
						if (j->node_used->unique_id == biggest_hole_unique_id)
						{
							get_new_biggest_hole(head_node);
						}
			
						#ifdef PRINT
						print_decision_in_scheduler(j);
						print_cores_in_specific_node(j->node_used);
						#endif
						return true;
					}
				//~ }
				n = n->next;
			}
		}
	//~ }
		
	/* Update infos on the job and on cores. */
	//~ j->start_time = min_time;
	//~ j->end_time = min_time + j->walltime;
	
	/* TODO : il faut enlever les cores qu'on va vraiment utiliser. car il peut y avoir différents temps de backfill.
	 * il faut ensuite delete core par core. */
	 
	//~ if (backfilled_job == true)
	//~ {
		//~ nb_non_available_cores_at_time_t = update_cores_for_backfilled_job(nb_non_available_cores, j, t, nb_cores_from_hole, nb_cores_from_outside);
		//~ nb_non_available_cores += j->cores;
	//~ }
	 
	//~ if (backfill_mode == 1)
	//~ {
		//~ /* NEW core selection conservative bf only */
		//~ if (backfilled_job == true)
		//~ {
			//~ #ifdef PLOT_STATS
			//~ number_of_backfilled_jobs += 1;
			//~ #endif
			//~ /* Ca ajoute des unavailable cores puisque c'est à t. */
			//~ nb_non_available_cores += j->cores;
			//~ /* Mettre les cores dans le job depuis ceux du trou. */
			//~ c = j->node_used->cores_in_a_hole->head;
			//~ i = 0;
			//~ #ifdef PRINT
			//~ printf("%d %d on node %d.\n", nb_cores_from_hole, j->node_used->number_cores_in_a_hole, j->node_used->unique_id); fflush(stdout);
			//~ #endif
			//~ if (nb_cores_from_hole > j->cores || nb_cores_from_hole > j->node_used->number_cores_in_a_hole) { printf("eerorr coress: %d cores taken from hole, %d cores on the job, %d cores in a hole of the node.\n", nb_cores_from_hole, j->cores, j->node_used->number_cores_in_a_hole); fflush(stdout); exit(1); }
			//~ for (k = 0; k < nb_cores_from_hole;)
			//~ {
				//~ if (t + j->walltime <= c->start_time_of_the_hole)
				//~ {
					//~ j->cores_used[i] = c->unique_id;
					//~ i++;
					//~ #ifdef PRINT
					//~ printf("Adding %d in cores used  from hole of job %d.\n", c->unique_id, j->unique_id);
					//~ #endif
					//~ k++;
				//~ }					
						//~ /* Je rentre la dedans ? je crois pas. */
						//~ if (c->next == NULL && k != nb_cores_from_hole)
						//~ {
							//~ #ifdef PRINT
							//~ printf("next is null\n"); fflush(stdout);
							//~ #endif
						//~ }
						//~ c = c->next;
					//~ }
			//~ for (k = 0; k < nb_cores_from_outside_remembered; k++)
			//~ {
				//~ #ifdef PRINT
				//~ printf("Adding core from outside %d.\n", j->node_used->cores[k]->unique_id);
				//~ #endif
				
				//~ j->cores_used[i] = j->node_used->cores[k]->unique_id;
				//~ j->node_used->cores[k]->available_time = t + j->walltime;
				//~ i++;
			//~ }		
			//~ j->node_used->number_cores_in_a_hole -= nb_cores_from_hole;

			//~ if (j->node_used->number_cores_in_a_hole < 0 || j->node_used->number_cores_in_a_hole > 19)
			//~ {
				//~ printf("erreur nb core in hole %d on node %d.\n", j->node_used->number_cores_in_a_hole, j->node_used->unique_id);  fflush(stdout); exit(1);
			//~ }
			//~ if (j->node_used->number_cores_in_a_hole == 0)
			//~ {
				//~ #ifdef PRINT
				//~ printf("Deleting all the cores in the hole cause we use them all.\n");
				//~ #endif
				
				//~ free_cores_in_a_hole(&j->node_used->cores_in_a_hole->head);
			//~ }
			//~ else
			//~ {
				//~ for (i = 0; i < nb_cores_from_hole; i++)
				//~ {
					//~ #ifdef PRINT
					//~ printf("Deleting core %d.\n", j->cores_used[i]);
					//~ #endif
					
					//~ delete_core_in_hole_specific_core(j->node_used->cores_in_a_hole, j->cores_used[i]);
				//~ }
				// delete_core_in_hole_from_head(j->node_used->cores_in_a_hole, nb_cores_from_hole);
			//~ }
			//~ #ifdef PRINT
			//~ printf("Holes after this backfill are:\n");
			//~ print_holes(head_node);
			//~ #endif
		//~ }
	//~ }
	
	//~ if (backfill_mode == 0)
	//~ {
		//~ /* OLD BF */
		//~ if (backfilled_job == true)
		//~ {
			//~ #ifdef PLOT_STATS
			//~ number_of_backfilled_jobs += 1;
			//~ #endif			
			//~ /* Ca ajoute des unavailable cores puisque c'est à t. */
			//~ nb_non_available_cores += j->cores;
			//~ /* Mettre les cores dans le job depuis ceux du trou. */
			//~ c = j->node_used->cores_in_a_hole->head;
			//~ for (i = 0; i < j->cores; i++)
			//~ {
				//~ j->cores_used[i] = c->unique_id;
				//~ c = c->next;
			//~ }
			//~ /* Mettre à jour le nombre de cores (s'il en reste) dans un trou de la node. */
			//~ #ifdef PRINT
			//~ printf("Backfilled job, using %d cores, nb of cores in the hole was %d.\n", j->cores, j->node_used->number_cores_in_a_hole); fflush(stdout);
			//~ #endif
			//~ j->node_used->number_cores_in_a_hole -= j->cores;
			//~ if (j->node_used->number_cores_in_a_hole == 0)
			//~ {
				//~ free_cores_in_a_hole(&j->node_used->cores_in_a_hole->head);
			//~ }
			//~ else
			//~ {
				//~ delete_core_in_hole_from_head(j->node_used->cores_in_a_hole, j->cores);
			//~ }
			//~ #ifdef PRINT
			//~ printf("Holes after this backfill are:\n");
			//~ print_holes(head_node);
			//~ #endif
		//~ }
		//~ /* OLD BF */
	//~ }
	
	//~ if (backfilled_job == false)
	//~ else /* backfilled_job == false */
	//~ {
		//~ if (backfill_mode == 1)
		//~ {
			//~ /* NEW core selection */
			//~ start_index = 0;
			//~ i = 19;
			//~ while(j->node_used->cores[i]->available_time > min_time)
			//~ {
				//~ i--;
			//~ }
			//~ start_index = i;
			//~ #ifdef PRINT
			//~ printf("Start index would have been %d.\n", start_index);
			//~ #endif
			//~ /* End of NEW core selection */
		//~ }
		
		//~ if (backfill_mode == 0)
		//~ {
			/* OLD BF */
			//~ start_index = 0;
			/* OLD BF */
		//~ }
		
		
		/* En commentaire: version plus longue qui prend les cores les plus utilisées pour remplir le job courant; A tester. */
		//~ if (j->start_time == t)
		//~ {
			//~ nb_non_available_cores_at_time_t += j->cores;
		//~ }
		
		//~ nb_non_available_cores += j->cores;
		
		//~ if (backfill_mode == 1 || backfill_mode == 2)
		//~ {
			//~ #ifdef PRINT
			//~ printf("fill_cores_minimize_holes\n");
			//~ #endif
			
			//~ fill_cores_minimize_holes (j, true, backfill_mode, t);
		//~ }
		//~ else
		//~ {
			//~ int k = 0;
			//~ sort_cores_by_unique_id_in_specific_node(j->node_used);
			//~ for (i = 0; i < j->cores; i++)
			//~ {
				//~ while(1)
				//~ {
					//~ if (j->node_used->cores[k]->available_time <= j->start_time)
					//~ {
						//~ j->cores_used[i] = j->node_used->cores[k]->unique_id;
						//~ j->cores_used[i] = j->node_used->cores[i]->unique_id;
						
						/* Spécifique au cas avec backfilling */
						//~ if (j->node_used->cores[k]->available_time <= t && j->start_time > t)
						//~ if (j->node_used->cores[i]->available_time <= t && j->start_time > t)
						//~ {
							//~ #ifdef PRINT
							//~ printf("Il va y avoir un trou sur node %d core %d.\n", j->node_used->unique_id, j->node_used->cores[k]->unique_id); fflush(stdout);
							//~ printf("Il va y avoir un trou sur node %d core %d.\n", j->node_used->unique_id, j->node_used->cores[i]->unique_id); fflush(stdout);
							//~ #endif
							
							//~ j->node_used->number_cores_in_a_hole += 1;
							//~ struct Core_in_a_hole* new = (struct Core_in_a_hole*) malloc(sizeof(struct Core_in_a_hole));
							//~ new->unique_id = j->node_used->cores[k]->unique_id;
							//~ new->unique_id = j->node_used->cores[i]->unique_id;
							//~ new->start_time_of_the_hole = min_time;
							//~ new->next = NULL;
							//~ if (j->node_used->cores_in_a_hole == NULL)
							//~ {
								//~ initialize_cores_in_a_hole(j->node_used->cores_in_a_hole, new);
							//~ }
							//~ else
							//~ {
								//~ if (backfill_mode == 3) /* Favorise les jobs backfill car se met sur le coeurs qui a le temps le plus petit possible. */
								//~ {
									//~ insert_cores_in_a_hole_list_sorted_increasing_order(j->node_used->cores_in_a_hole, new);
								//~ }
								//~ else
								//~ {
									//~ insert_cores_in_a_hole_list_sorted_decreasing_order(j->node_used->cores_in_a_hole, new);
								//~ }
							//~ }
						//~ }
						/* Fin de spécifique au cas avec backfilling */
						
						//~ j->node_used->cores[k]->available_time = j->start_time + j->walltime;
						//~ j->node_used->cores[i]->available_time = j->start_time + j->walltime;
						//~ k++;
						//~ break;
					//~ }
					//~ k++;
				//~ }
			//~ }
		//~ }
	//~ }

	/* Need to sort cores after each schedule of a job only if it was not backfilled. */
	
	//~ if (backfill_mode == 1)
	//~ {
		
		/* NEW core selection */
		//~ if (backfilled_job == false || nb_cores_from_outside > 0)
		//~ {
			//~ sort_cores_by_available_time_in_specific_node(j->node_used);
		//~ }
		/* End of NEW core selection */
		
	//~ }
	
	//~ if (backfill_mode == 0)
	//~ {
		//~ /* OLD core selection */
		//~ if (backfilled_job == false)
		//~ {
			//~ sort_cores_by_available_time_in_specific_node(j->node_used);
		//~ }
		//~ /* End of OLD core selection */
	//~ }
	
	//~ #ifdef PRINT
	//~ print_decision_in_scheduler(j);
	//~ print_cores_in_specific_node(j->node_used);
	//~ #endif
	
	//~ return nb_non_available_cores;
	return false;
}
