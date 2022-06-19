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

void insert_tail_data_list(struct Data_List* liste, struct Data* d)
{
	if (liste->head == NULL)
	{
		//~ printf("Added %d.\n",1);
		liste->head = d;
		liste->tail = d;
	}
	else
	{
		liste->tail->next = d;
		liste->tail = d;
	}
}

/* Insert so it's sorted by growing times. */
void insert_next_time_in_sorted_list(struct Next_Time_List* liste, int time_to_insert)
{
	if (liste->head == NULL)
	{
		struct Next_Time* new = (struct Next_Time*) malloc(sizeof(struct Next_Time));
		new->next = NULL;
		new->time = time_to_insert;
		liste->head = new;
	}
	else
	{
		struct Next_Time* temp = liste->head;
		struct Next_Time* prev = liste->head;
		while (temp->time < time_to_insert && temp->next != NULL)
		{
			prev = temp;
			temp = temp->next;
		}
		if (temp->time == time_to_insert)
		{
			return;
		}
		struct Next_Time* new = (struct Next_Time*) malloc(sizeof(struct Next_Time));
		new->next = temp->next;
		new->time = time_to_insert;
		prev = new;
	}
}

/* Delete all time corresponding to this time. The list is sorted so it should be easy. */
void delete_next_time_linked_list(struct Next_Time_List* liste, int time_to_delete)
{
    if (liste == NULL)
    {
		printf("Error list empty.\n");
        exit(EXIT_FAILURE);
    }

	struct Next_Time* temp = liste->head;
	struct Next_Time* prev = liste->head;
	
	// If head node itself holds the key to be deleted
    if (temp != NULL && temp->time == time_to_delete) 
    {
		liste->head = temp->next; // Changed head
        free(temp); // free old head
        temp = liste->head;
        while (temp->time == time_to_delete)
		{
			liste->head = temp->next; // Changed head
			free(temp); // free old head
			temp = liste->head;
		}
        return;
    }
	
	while (temp->time != time_to_delete && temp != NULL)
	{
		prev = temp;
		temp = temp->next;
	}
	if (temp == NULL)
	{
		printf("Deletion of job %d failed.\n", time_to_delete);
		exit(EXIT_FAILURE);
	}
	while (temp->time == time_to_delete)
	{
		prev->next = temp->next;
		free(temp);
		temp = prev;
	}
}

//~ /* Attention might need to malloc here for Data and other struct !!! */
//~ void copy_job_and_insert_tail_job_list(struct Job_List* liste, struct Job* j)
//~ {
	//~ struct Job* new = (struct Job*) malloc(sizeof(struct Job));
	
	//~ new->next = NULL;
	//~ new->unique_id = j->unique_id;
	//~ new->subtime = j->subtime;
	//~ new->delay = j->delay;
	//~ new->walltime = j->walltime;
	//~ new->cores = j->cores;
	//~ new->data = j->data;
	//~ new->data_size = j->data_size;
	//~ new->index_node_list = j->index_node_list;
	//~ new->start_time = j->start_time;
	//~ new->end_time = j->end_time;
	//~ new->end_before_walltime = j->end_before_walltime;
	//~ new->node_used = j->node_used;
	//~ new->cores_used = j->cores_used;
	//~ new->transfer_time = j->transfer_time;
	//~ new->waiting_for_a_load_time = j->waiting_for_a_load_time;
	//~ new->workload = j->workload;
	//~ new->start_time_from_history = j->start_time_from_history;
	//~ new->node_from_history = j->node_from_history;
   
	//~ if (liste->head == NULL)
	//~ {
		//~ liste->head = new;
		//~ liste->tail = new;
	//~ }
	//~ else
	//~ {
		//~ liste->tail->next = new;
		//~ liste->tail = new;
	//~ }
//~ }

void delete_job_linked_list(struct Job_List* liste, int unique_id_to_delete)
{
    if (liste == NULL)
    {
		printf("Error list empty.\n");
        exit(EXIT_FAILURE);
    }

	struct Job* temp = liste->head;
	struct Job* prev = liste->head;
	
	 // If head node itself holds the key to be deleted
    if (temp != NULL && temp->unique_id == unique_id_to_delete) {
        liste->head = temp->next; // Changed head
        free(temp); // free old head
        return;
    }
	
	while (temp->unique_id != unique_id_to_delete && temp != NULL)
	{
		prev = temp;
		temp = temp->next;
	}
	if (temp == NULL)
	{
		printf("Deletion of job %d failed.\n", unique_id_to_delete);
		exit(EXIT_FAILURE);
	}
	prev->next = temp->next;
	free(temp);
    //~ struct Job* aSupprimer = temp;
    //~ liste->premier = liste->premier->suivant;
        //~ free(aSupprimer);
}

/* Copy a job, delete it from list 1 and add it in tail of list 2. */
void copy_delete_insert_job_list(struct Job_List* to_delete_from, struct Job_List* to_append_to, struct Job* j)
{
	/* If empty can't delete. */
	if (to_delete_from == NULL)
    {
		printf("Error list empty.\n");
        exit(EXIT_FAILURE);
    }
    
    /* New copy from j */
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

	/* Delete */
	delete_job_linked_list(to_delete_from, j->unique_id);
	
	/* Add in new list */
	insert_tail_job_list(to_append_to, new);
}

int get_length_job_list(struct Job* head)
{
	int length = 0;
	struct Job* j = head;
	while (j != NULL)
	{
		length += 1;
		j = j->next;
	}
	return length;
}
