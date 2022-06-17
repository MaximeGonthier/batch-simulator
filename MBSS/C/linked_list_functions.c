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

//~ void free_job_list(struct Job* head)
//~ {
	//~ struct Job *n = head;
	//~ while(n){
	   //~ struct Job *n1 = n;
	   //~ n = n->next;
	   //~ free(n1);
	//~ }
//~ }
