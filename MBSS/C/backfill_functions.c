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

int update_cores_for_backfilled_job(int nb_non_available_cores, struct Job* j, int t, int nb_cores_from_hole, int nb_cores_from_outside)
{
	struct Core_in_a_hole* c = (struct Core_in_a_hole*) malloc(sizeof(struct Core_in_a_hole));
	int i = 0;
	int k = 0;
	
	#ifdef PLOT_STATS
	number_of_backfilled_jobs += 1;
	#endif
	
	/* Ca ajoute des unavailable cores puisque c'est à t. */
	nb_non_available_cores += j->cores;
	
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
	
	return nb_non_available_cores;
}

void fill_cores_minimize_holes (struct Job* j, bool backfill_activated, int backfill_mode, int t)
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
