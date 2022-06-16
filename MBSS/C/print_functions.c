#include <main.h>

void print_node_list(struct Node* list)
{
	struct Node* n = list;
	while (n != NULL)
	{
		printf("Id: %d Memory: %d Bandwidth: %f Available cores: %d\n", n->unique_id, n->memory, n->bandwidth, n->n_available_cores);
		n = n->next;
	}
}

void print_job_list(struct Job* list)
{
	struct Job* j = list;
	while (j != NULL)
	{
		printf("Id: %d Subtime: %d Delay: %d Walltime: %d Cores: %d Data: %d Data_size: %f Data_category: %d Workload: %d Start_time_from_history: %d Node_from_history: %d\n", j->unique_id, j->subtime, j->delay, j->walltime, j->cores, j->data, j->data_size, j->index_node_list, j->workload, j->start_time_from_history, j->node_from_history);
		j = j->next;
	}
}

//~ def print_decision_in_scheduler(choosen_core, j, choosen_node):
	//~ core_ids = []
	//~ for i in range (0, len(choosen_core)):
		//~ core_ids.append(choosen_core[i].unique_id)
	//~ core_ids.sort()
	//~ print("Job", j.unique_id, "using file", j.data, "category", j.index_node_list, "workload", j.workload, "will be computed on node", choosen_node.unique_id, "core(s)", core_ids, "start at time", j.start_time, "and is predicted to finish at time", j.end_time)
