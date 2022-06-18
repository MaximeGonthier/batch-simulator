#include <main.h>

void insert_head_job_list(struct Job_List* liste, struct Job* j)
{
	if (liste->head == NULL)
	{
		liste->head = j;
		liste->tail = j;
	}
	else
	{
		j->next = liste->head;
		liste->head = j;
	}
}

void insert_tail_job_list(struct Job_List* liste, struct Job* j)
{
	if (liste->head == NULL)
	{
		liste->head = j;
		liste->tail = j;
	}
	else
	{
		//~ struct Job* tmp = liste->head;
		//~ while (tmp != NULL)
		//~ {
			//~ tmp = tmp->next;
		//~ }
		//~ tmp = j;
		liste->tail->next = j;
		liste->tail = j;
	}
}

void insert_tail_node_list(struct Node_List* liste, struct Node* n)
{
	if (liste->head == NULL)
	{
		liste->head = n;
		liste->tail = n;
	}
	else
	{
		liste->tail->next = n;
		liste->tail = n;
	}
}

/* Attention might need to malloc here for Data and other struct !!! */
void copy_job_and_insert_tail_job_list(struct Job_List* liste, struct Job* j)
{
	struct Job* new = (struct Job*) malloc(sizeof(struct Job));
	
	new->next = NULL;
	new->unique_id = j->unique_id;
	new->subtime = j->subtime;
	new->delay = j->delay;
	new->walltime = j->walltime;
	new->cores = j->cores;
	new->data = j->data;
	new->data_size = j->data_size;
	new->index_node_list = j->index_node_list;
	new->start_time = j->start_time;
	new->end_time = j->end_time;
	new->end_before_walltime = j->end_before_walltime;
	new->node_used = j->node_used;
	new->cores_used = j->cores_used;
	new->transfer_time = j->transfer_time;
	new->waiting_for_a_load_time = j->waiting_for_a_load_time;
	new->workload = j->workload;
	new->start_time_from_history = j->start_time_from_history;
	new->node_from_history = j->node_from_history;
   
	if (liste->head == NULL)
	{
		liste->head = new;
		liste->tail = new;
	}
	else
	{
		liste->tail->next = new;
		liste->tail = new;
	}
}

//~ void free_job_list(struct Job* head)
//~ {
	//~ struct Job *n = head;
	//~ while(n){
	   //~ struct Job *n1 = n;
	   //~ n = n->next;
	   //~ free(n1);
	//~ }
//~ }
