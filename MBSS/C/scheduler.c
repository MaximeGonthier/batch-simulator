#include <main.h>

void get_state_before_day_0_scheduler(struct Job* j, struct Node* nl, int t)
{
	//~ struct Job j = jl;
	//~ scheduled_job_list = NULL;
	while (j != NULL)
	{
		/* Insert and remove */
		insert_tail_job_list(scheduled_job_list, j);
		//~ remove_job_linked_list(j, )
		
		//~ time_since_start = t - j.start_time_from_history
		//~ j.delay -= time_since_start
		//~ j.walltime -= time_since_start
		//~ j.start_time = t
		
		//~ # ~ print("Nb nodes:", len(node_list[0]) + len(node_list[1]) + len(node_list[2]))
		//~ # ~ if len(node_list[0]) + len(node_list[1]) + len(node_list[2]) == 486:
			//~ # ~ choosen_node = j.node_from_history
		//~ # ~ else: # need to play around a bit with a reduced cluster
		//~ index_node = (j.node_from_history - 1)%(len(node_list[0]) + len(node_list[1]) + len(node_list[2]))
		//~ # ~ print("Index node in tab:", index_node)
		//~ # ~ exit(1)
		//~ if index_node >= len(node_list[0]):
			//~ if index_node >= len(node_list[0]) + len(node_list[1]):
				//~ choosen_node = node_list[2][index_node - (len(node_list[0]) + len(node_list[1]))]
			//~ else:
				//~ choosen_node = node_list[1][index_node - len(node_list[0])]
		//~ else:
			//~ choosen_node = node_list[0][index_node]
				
		//~ # ~ print("Nb cores, choosen node, time:", j.cores, choosen_node.unique_id, t)
		//~ # ~ exit(1)
		//~ choosen_core, earliest_available_time = return_earliest_available_cores_and_start_time_specific_node(j.cores, choosen_node, t)
		
		//~ start_time = earliest_available_time
		//~ j.node_used = choosen_node
		//~ j.cores_used = choosen_core
		//~ j.start_time = start_time
		//~ j.end_time = start_time + j.walltime			
		//~ for c in choosen_core:
			//~ c.job_queue.append(j)			
			//~ c.available_time = start_time + j.walltime
		
		//~ # ~ if j.unique_id == 1362:
			//~ # ~ print(choosen_core)
		
		//~ if __debug__:
			//~ print_decision_in_scheduler(choosen_core, j, choosen_node)
		//~ if j.unique_id == 1362:
			//~ print_decision_in_scheduler(choosen_core, j, choosen_node)
		j = j->next;
	}
	//~ job_list_to_start_from_history = NULL;
	free(job_list_to_start_from_history);
}
