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

//~ void addLast(struct node **head, int val)
//~ {
    //~ //create a new node
    //~ struct node *newNode = malloc(sizeof(struct node));
    //~ newNode->data = val;
    //~ newNode->next     = NULL;

    //~ //if head is NULL, it is an empty list
    //~ if(*head == NULL)
         //~ *head = newNode;
    //~ //Otherwise, find the last node and add the newNode
    //~ else
    //~ {
        //~ struct node *lastNode = *head;
        

        //~ //last node's next address will be NULL.
        //~ while(lastNode->next != NULL)
        //~ {
            //~ lastNode = lastNode->next;
        //~ }

        //~ //add the newNode at the end of the linked list
        //~ lastNode->next = newNode;
      

    //~ }

//~ }

void insert_tail_job_list(struct Job_List* liste, struct Job* j)
{
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
	//create a new node
    //~ struct node *newNode = malloc(sizeof(struct node));
    //~ newNode->data = val;
    //~ newNode->next     = NULL;

    //if head is NULL, it is an empty list
    if(liste->head == NULL)
    {
         liste->head = j;
	 }
    //Otherwise, find the last node and add the newNode
    else
    {
        struct Job *lastNode = liste->head;
        

        //last node's next address will be NULL.
        while(lastNode->next != NULL)
        {
            lastNode = lastNode->next;
        }

        //add the newNode at the end of the linked list
        lastNode->next = j;
      

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

void insert_tail_to_print_list(struct To_Print_List* liste, struct To_Print* tp)
{
	if (liste->head == NULL)
	{
		liste->head = tp;
		liste->tail = tp;
	}
	else
	{
		liste->tail->next = tp;
		liste->tail = tp;
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
	//~ void sortedInsert(struct Node** head_ref,
                  //~ struct Node* new_node)
//~ {
    struct Next_Time* current;
    /* Special case for the head end */
    if (liste->head == NULL || liste->head->time >= time_to_insert) {
		
		/* I don't want the same time twice. So I addthis condition. */
		if (liste->head != NULL)
		{
			if (liste->head->time == time_to_insert)
			{
				return;
			}
		}
		
		struct Next_Time* new = (struct Next_Time*) malloc(sizeof(struct Next_Time));
		new->next = liste->head;
		new->time = time_to_insert;
        //~ new_node->next = *head_ref;
        liste->head = new;
    }
    else {
        /* Locate the node before
the point of insertion */
        current = liste->head;
        while (current->next != NULL && current->next->time <= time_to_insert) {
            current = current->next;
        }
        
 		/* I don't want the same time twice. So I addthis condition. */
 		if (current != NULL)
 		{
			if (current->time == time_to_insert)
			{
				return;
			}   
		}
        
        struct Next_Time* new = (struct Next_Time*) malloc(sizeof(struct Next_Time));
        new->time = time_to_insert;
        new->next = current->next;
        current->next = new;
    }
//~ }
	//~ if (liste->head == NULL)
	//~ {
		//~ struct Next_Time* new = (struct Next_Time*) malloc(sizeof(struct Next_Time));
		//~ new->next = NULL;
		//~ new->time = time_to_insert;
		//~ liste->head = new;
	//~ }
	//~ else
	//~ {
		//~ if (liste->head->time == time_to_insert)
		//~ {
			//~ return;
		//~ }
		//~ else if (liste->head->time > time_to_insert) /* Need to insert at head. */
		//~ {
			//~ printf("Dans le else.\n");
			//~ struct Next_Time* new = (struct Next_Time*) malloc(sizeof(struct Next_Time));
			//~ new->next = liste->head;
			//~ new->time = time_to_insert;
			//~ liste->head = new;
			//~ return;
		//~ }
		//~ printf("In insert time 0. Head is %d\n", liste->head->time);
		//~ struct Next_Time* temp = liste->head;
		//~ struct Next_Time* prev = liste->head;
		//~ while (temp->time < time_to_insert && temp != NULL)
		//~ {
			//~ printf("Next.\n");
			//~ prev = temp;
			//~ temp = temp->next;
			//~ printf("Next ok.\n");
			//~ if (temp == NULL) { printf("Temp is null.\n"); break; }
		//~ }
		//~ printf("In insert time 0.5.\n"); fflush(stdout);
		//~ if (temp == NULL) /* We are at the end. */
		//~ {
			//~ struct Next_Time* new = (struct Next_Time*) malloc(sizeof(struct Next_Time));
			//~ new->next = NULL;
			//~ new->time = time_to_insert;
			//~ temp = new;
			//~ return;
		//~ }
		//~ printf("In insert time 1.\n");
		//~ if (temp->time == time_to_insert)
		//~ {
			//~ return;
		//~ }
		//~ struct Next_Time* new = (struct Next_Time*) malloc(sizeof(struct Next_Time));
		//~ new->next = temp;
		//~ new->time = time_to_insert;
		//~ prev = new;
	//~ }
}

/* Insert so it's sorted by start times from history. */
void insert_job_in_sorted_list(struct Job_List* liste, struct Job* j)
{
    struct Job* current;
    /* Special case for the head end */
    if (liste->head == NULL || liste->head->start_time_from_history >= j->start_time_from_history) {	
		j->next = liste->head;
        liste->head = j;
    }
    else {
        /* Locate the node before
the point of insertion */
        current = liste->head;
        while (current->next != NULL && current->next->start_time_from_history <= j->start_time_from_history) {
            current = current->next;
        }
        
        j->next = current->next;
        current->next = j;
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
    if (temp != NULL && temp->time == time_to_delete) {
        liste->head = temp->next; // Changed head
        free(temp); // free old head
        return;
    }
	
	while (temp->time != time_to_delete && temp != NULL)
	{
		prev = temp;
		temp = temp->next;
	}
	if (temp == NULL)
	{
		printf("Deletion of time %d failed.\n", time_to_delete);
		exit(EXIT_FAILURE);
	}
	prev->next = temp->next;
	free(temp);
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
		printf("Error list empty.\n"); fflush(stdout);
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
		printf("Error, deletion of job %d failed.\n", unique_id_to_delete); fflush(stdout);
		exit(EXIT_FAILURE);
	}
	prev->next = temp->next;
	free(temp);
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
	//~ new->node_used = j->node_used;
	//~ new->cores_used = j->cores_used;
	new->transfer_time = j->transfer_time;
	new->waiting_for_a_load_time = j->waiting_for_a_load_time;
	new->workload = j->workload;
	new->start_time_from_history = j->start_time_from_history;
	new->node_from_history = j->node_from_history;

	new->node_used = (struct Node*) malloc(sizeof(struct Node));
	new->node_used = j->node_used;
	
	new->cores_used = malloc(new->cores*sizeof(int));
	new->cores_used = j->cores_used;

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

void free_next_time_linked_list(struct Next_Time** head_ref)
{
 /* deref head_ref to get the real head */
   struct Next_Time* current = *head_ref;
   struct Next_Time* next;
 
   while (current != NULL)
   {
       next = current->next;
       free(current);
       current = next;
   }
   
   /* deref head_ref to affect the real head back
      in the caller. */
   *head_ref = NULL;
}
