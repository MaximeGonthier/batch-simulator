#include <main.h>

void schedule_job_specific_node_at_earliest_available_time(struct Job* j, struct Node* n, int t)
{
	int i = 0;
	int earliest_available_time = n->cores[j->cores - 1]->available_time;
	if (earliest_available_time < t)
	{
		earliest_available_time = t;
	}
	printf("EAT is: %d\n", earliest_available_time);
	//~ choosen_core = node.cores[0:cores_asked]		

	j->node_used = n;
	for (i = 0; i < j->cores; i++)
	{
		j->cores_used[i] = n->cores[i]->unique_id;
		j->start_time = earliest_available_time;
		j->end_time = earliest_available_time + j->walltime;
		n->cores[i]->available_time = earliest_available_time + j->walltime;
		
		insert_tail_job_list(n->cores[i]->job_queue, j);
	}
	print_decision_in_scheduler(j);
	
	sort_cores_by_available_time_in_specific_node(n);
}

void sort_cores_by_available_time_in_specific_node(struct Node* n)
{
	
}
