#include <main.h>

/* PB is here */
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
	for (i = 0; i < j->cores; i++)
	{
		j->cores_used[i] = n->cores[i]->unique_id;
		j->start_time = earliest_available_time;
		j->end_time = earliest_available_time + j->walltime;
		n->cores[i]->available_time = earliest_available_time + j->walltime;
		
		//~ insert_tail_job_list(n->cores[i]->job_queue, j);
		copy_job_and_insert_tail_job_list(n->cores[i]->job_queue, j);

	}
	print_decision_in_scheduler(j);
	
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

void start_jobs(int t, struct Job* j)
{
	//~ jobs_to_remove = []
	while (j != NULL)
	{ 
	//~ for j in scheduled_job_list:
		if (j->start_time == t)
		{
			
			//~ # For constraint on sizes only. TODO : remove it or put it in an ifdef if I don't have this constraint to gain time ?
			total_queue_time += j->start_time - j->subtime;
			
			int transfer_time = 0
			int waiting_for_a_load_time = 0
			if (j->data != 0 && constraint_on_sizes != 2 && j->workload != -2): /* I also don't want to put transfer time on fix workload occupation jobs */
				/* Let's look if a data transfer is needed */
				add_data_in_node(j->data, j->data_size, j->node_used, t, j->end_time, &transfer_time, &waiting_for_a_load_time)
			j->transfer_time = transfer_time;
			j->waiting_for_a_load_time = waiting_for_a_load_time;
			
			printf("For job %d: %d transfer time and %d waiting for a load time.\n", j->unique_id, transfer_time, waiting_for_a_load_time);
			
			/* Use next min end time from global variable here :) */
			//~ j->end_time = j->start_time + min(j->delay + transfer_time, j->walltime) # Attention le j->end time est mis a jour la!
			
			//~ end_times.append(j->end_time)
			
			//~ if (write_all_jobs == 3):
				//~ # Just for stats
				//~ running_cores += j->cores
				//~ if (j->node_used.n_available_cores == 20):
					//~ running_nodes += 1
				//~ j->node_used.n_available_cores -= j->cores

			//~ if (j->delay + transfer_time < j->walltime):
				//~ j->end_before_walltime = True
				
			//~ if __debug__:
				//~ print("Job", j->unique_id, "start at", t, "on node", j->node_used.unique_id, "and will end at", j->end_time,  "before walltime:", j->end_before_walltime, "transfer time is", transfer_time, "data was", j->data)
			//~ if j->unique_id == 1362:
				//~ print("Job", j->unique_id, "start at", t, "on node", j->node_used.unique_id, "and will end at", j->end_time,  "before walltime:", j->end_before_walltime, "transfer time is", transfer_time, "data was", j->data)
			
			//~ for c in j->cores_used:
				//~ c.running_job = j
			//~ jobs_to_remove.append(j)
			//~ running_jobs.append(j)
		}
		j = j->next;
	}
	//~ if len(jobs_to_remove) > 0:
		//~ scheduled_job_list = remove_jobs_from_list(scheduled_job_list, jobs_to_remove)
		//~ available_job_list = remove_jobs_from_list(available_job_list, jobs_to_remove)
	//~ return scheduled_job_list, running_jobs, end_times, running_cores, running_nodes, total_queue_time, available_job_list
}

//~ def end_jobs(t, finished_jobs, affected_node_list, running_jobs, running_cores, running_nodes, nb_job_to_evaluate_finished, nb_job_to_evaluate, first_time_day_0):
	//~ jobs_to_remove = []
	//~ for j in running_jobs:
		//~ if (j.end_time == t): # A job has finished, let's remove it from the cores, write its results and figure out if we need to fill
			
			//~ if j.workload == 1:
				//~ nb_job_to_evaluate_finished += 1
				
			//~ finished_jobs += 1
			//~ # Just printing, can remove
			//~ # ~ if (finished_jobs%5 == 0):
			//~ if (finished_jobs%100 == 0):
				//~ print("Evaluated jobs:", nb_job_to_evaluate_finished, "/", nb_job_to_evaluate, "| All jobs:", finished_jobs, "/", total_number_jobs, "| T =", t, "| Running =", len(running_jobs))
			
			//~ if __debug__:	
				//~ print("Job", j.unique_id, "finished at time", t, "|", finished_jobs, "finished jobs")
			
			//~ if j.unique_id == 1362:
				//~ print("Job", j.unique_id, "finished at time", t, "|", finished_jobs, "finished jobs")
			
			//~ finished_job_list.append(j)
			
			//~ if (write_all_jobs == 3):
				//~ # Just for stats
				//~ running_cores -= j.cores
				//~ j.node_used.n_available_cores += j.cores
				//~ if (j.node_used.n_available_cores == 20):
					//~ running_nodes -= 1
			
			//~ end_times.remove(j.end_time)
			
			//~ core_ids = []
			//~ # ~ if j.unique_id == 1362:
				//~ # ~ print("Try to remove", j.unique_id)
			//~ for i in range (0, len(j.cores_used)):
				//~ # ~ if j.unique_id == 1362:
					//~ # ~ print("Try to remove", j.unique_id, "from core", j.cores_used[i])
				//~ j.cores_used[i].job_queue.remove(j)
				//~ j.cores_used[i].running_job = None
								
				//~ # ~ if (j.end_before_walltime == True):
					//~ # ~ j.cores_used[i].available_time = t
					
				//~ core_ids.append(j.cores_used[i].unique_id)
			
			//~ to_print_job_csv(j, j.node_used.unique_id, core_ids, t, first_time_day_0)

			//~ if (j.end_before_walltime == True and j.node_used not in affected_node_list): # Need to backfill or shiftleft depending on the strategy OLD
				//~ affected_node_list.append(j.node_used)
			
			//~ # ~ print("Try to remove", j.unique_id)
			//~ jobs_to_remove.append(j)
						
	//~ running_jobs = remove_jobs_from_list(running_jobs, jobs_to_remove)
						
	//~ return finished_jobs, affected_node_list, finished_job_list, running_jobs, running_cores, running_nodes, nb_job_to_evaluate_finished

