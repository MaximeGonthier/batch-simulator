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

//~ void copy_job_and_insert_tail_job_list(struct Job_List* liste, struct Job* j)
//~ {
	//~ struct Job* new = (struct Job*) malloc(sizeof(struct Job));
	//~ new->next = NULL;
	//~ new->unique_id = 1;
		//~ struct Job* next;
	//~ int unique_id;
    //~ int subtime;
    //~ int delay;
    //~ int walltime;
    //~ int cores;
    //~ int data;
    //~ float data_size;
    //~ int index_node_list;
    //~ int start_time;
    //~ int end_time;
    //~ bool end_before_walltime;
    //~ struct Node* node_used; /* None */
    //~ int* cores_used; /* list */
    //~ int transfer_time;
    //~ int waiting_for_a_load_time;
    //~ int workload;
    //~ int start_time_from_history;
    //~ int node_from_history;
	//~ if (liste->head == NULL)
	//~ {
		//~ liste->head = j;
		//~ liste->tail = j;
	//~ }
	//~ else
	//~ {
		//~ liste->tail->next = j;
		//~ liste->tail = j;
	//~ }

//~ }

//~ void free_job_list(struct Job* head)
//~ {
	//~ struct Job *n = head;
	//~ while(n){
	   //~ struct Job *n1 = n;
	   //~ n = n->next;
	   //~ free(n1);
	//~ }
//~ }
