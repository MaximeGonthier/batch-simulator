#include <main.h>

//~ struct Job_List* init()
//~ {
    //~ Job_List* liste = malloc(sizeof(*liste));
    //~ Job* element = malloc(sizeof(*element));

    //~ if (liste == NULL || element == NULL)
    //~ {
        //~ exit(EXIT_FAILURE);
    //~ }

    //~ element->nombre = 0;
    //~ element->suivant = NULL;
    //~ liste->head = element;
    //~ liste->tail = element;

    //~ return liste;
//~ }

void insert_head_job_list(struct Job_List *liste, struct Job* j)
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

void insert_tail_job_list(struct Job_List *liste, struct Job* j)
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
