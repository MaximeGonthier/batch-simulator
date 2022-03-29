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
using namespace std;

extern struct linked_list *set_of_task;
extern struct node *set_of_node; /* Tab of struct for the nodes. */

struct node /* Struct showing data on the nodes. It will be a tab of struct because we know before hand the number of nodes. */
{
    IntervalSet data; /* IntervalSet is the set of data loaded in memory. */
    //~ int id;
};

struct task
{
	string id;
    int *tab_data;
    int nb_data;
    task *next;
};

class linked_list /* Linked list of the set of task and their data. */
{
public:
    task *head;
    task *pointeur;
    int size_linked_list;
    
    linked_list()
    {
        head = NULL;
    }
    
    void init_set_of_task()
    {		
    	set_of_task = new linked_list;
		set_of_task->size_linked_list = 0;
		set_of_task->pointeur = NULL;
		set_of_task->head = set_of_task->pointeur;
	}
	
    void add_task_set_of_task(int *tab, int tab_size, string task_id)
    {		
		set_of_task->pointeur = set_of_task->head;
		task *t = new task;
		t->tab_data = (int*) malloc(tab_size*sizeof(int));
		t->nb_data = tab_size;
		t->id = task_id;
		for (int i = 0; i < tab_size; i++)
		{
			t->tab_data[i] = tab[i];
		}
		t->next = set_of_task->pointeur;
		set_of_task->pointeur = t;
		set_of_task->size_linked_list++;
		set_of_task->head = set_of_task->pointeur;
	}
};

//~ void print_intervalset(IntervalSet a, char* s)
//~ {
	//~ LOG_F(INFO, "Intervalset from %s", s);
	//~ for (int i = 0; i < a.size(); i++)
	//~ {
		//~ LOG_F(INFO, "%d", a[i]);
	//~ }
//~ }
