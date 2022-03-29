/* Maxime */
#pragma once

#include <list>

#include "../isalgorithm.hpp"
#include "../json_workload.hpp"
#include "../locality.hpp"
#include "../schedule.hpp"
#include <string>
using namespace std;

//~ extern struct linked_list *set_of_task;
//~ extern struct node *set_of_node; /* Tab of struct for the nodes. */

//~ struct node /* Struct showing data on the nodes. It will be a tab of struct because we know before hand the number of nodes. */
//~ {
    //~ IntervalSet data; /* IntervalSet is the set of data loaded in memory. */
//~ };

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

class My_Scheduler : public ISchedulingAlgorithm
{
public:
    My_Scheduler(Workload * workload, SchedulingDecision * decision, Queue * queue, ResourceSelector * selector,
                    double rjms_delay, rapidjson::Document * variant_options);
    virtual ~My_Scheduler();

	virtual void print_intervalset_machine(IntervalSet nodes, int size);
	
    virtual void on_simulation_start(double date, const rapidjson::Value & batsim_config);

    virtual void on_simulation_end(double date);

    virtual void make_decisions(double date,
                                SortableJobOrder::UpdateInformation * update_info,
                                SortableJobOrder::CompareInformation * compare_info);

    void sort_queue_while_handling_priority_job(const Job * priority_job_before,
                                                const Job *& priority_job_after,
                                                SortableJobOrder::UpdateInformation * update_info,
                                                SortableJobOrder::CompareInformation * compare_info);

protected:
    Schedule _schedule;
    bool _debug = false;
};
