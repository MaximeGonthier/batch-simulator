//~ #pragma once

#include <list>
//~ #include <iostream>
//~ #include <fstream>

#include <loguru.hpp> /* For INFO */
//~ #include "../isalgorithm.hpp"
//~ #include "../json_workload.hpp"
//~ #include "../locality.hpp"
//~ #include "../schedule.hpp"
#include <string>
//~ using namespace std;

//~ extern struct linked_list *set_of_task;
extern int number_of_node;
extern int dynamic_finished;
extern int number_dynamic_job_submitted;

struct node /* Struct showing data on the nodes. It will be a tab of struct because we know before hand the number of nodes. */
{
    IntervalSet data; /* IntervalSet is the set of data loaded in memory. */
    int delay_next_dynamic_job;
    int id_current_job;
	std::string current_job;
	bool need_to_execute_dynamic_job;
	bool need_to_submit_dynamic_job;
	bool is_computing_dynamic_job;
	std::string dynamic_job_to_execute;
};

extern struct node set_of_node[8]; /* Tab of struct for the nodes. */

    //~ string id_next_job; /* The next job to be computed on this node. This is used when we have a data load. We create a dynamic job for the job and the job that was supposed to run will be here. It is tested in job completed in the main. */


//~ struct task
//~ {
	//~ string id;
    //~ int *tab_data;
    //~ int nb_data;
    //~ task *next;
//~ };

//~ class linked_list /* Linked list of the set of task and their data. */
//~ {
//~ public:
    //~ task *head;
    //~ task *pointeur;
    //~ int size_linked_list;
    
    //~ linked_list()
    //~ {
        //~ head = NULL;
    //~ }
    
    //~ void init_set_of_task()
    //~ {		
    	//~ set_of_task = new linked_list;
		//~ set_of_task->size_linked_list = 0;
		//~ set_of_task->pointeur = NULL;
		//~ set_of_task->head = set_of_task->pointeur;
	//~ }
	
    //~ void add_task_set_of_task(int *tab, int tab_size, string task_id)
    //~ {		
		//~ set_of_task->pointeur = set_of_task->head;
		//~ task *t = new task;
		//~ t->tab_data = (int*) malloc(tab_size*sizeof(int));
		//~ t->nb_data = tab_size;
		//~ t->id = task_id;
		//~ for (int i = 0; i < tab_size; i++)
		//~ {
			//~ t->tab_data[i] = tab[i];
		//~ }
		//~ t->next = set_of_task->pointeur;
		//~ set_of_task->pointeur = t;
		//~ set_of_task->size_linked_list++;
		//~ set_of_task->head = set_of_task->pointeur;
	//~ }
//~ };
