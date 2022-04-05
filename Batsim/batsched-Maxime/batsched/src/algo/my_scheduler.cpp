/* Maxime */

#include "my_scheduler.hpp"
#include "../global_struct_data_aware.hpp"

using namespace std;

/* Just for printing outputs for debug. */
#include <iostream>
#include <fstream>

#include <loguru.hpp>

#include "../pempek_assert.hpp"

/* TODO : a suppr */
int test = 0;

struct node *set_of_node;
int number_of_node;

void My_Scheduler::print_intervalset_machine(IntervalSet nodes, int size)
{
	LOG_F(INFO, "Nodes are");
	for (int i = 0; i < size; i++)
	{
		LOG_F(INFO, "%d", nodes[i]);
	}
}

My_Scheduler::My_Scheduler(Workload * workload,
                                 SchedulingDecision * decision,
                                 Queue * queue,
                                 ResourceSelector * selector,
                                 double rjms_delay,
                                 rapidjson::Document * variant_options) :
    ISchedulingAlgorithm(workload, decision, queue, selector, rjms_delay, variant_options)
{
}

My_Scheduler::~My_Scheduler()
{

}

/* créer les struct des machines */
void My_Scheduler::on_simulation_start(double date, const rapidjson::Value & batsim_config)
{
	LOG_F(INFO, "Il y a %d machines", _nb_machines);
	
	/* Init struct of set of node. */
	set_of_node = (struct node*) malloc(_nb_machines*sizeof(node));
	IntervalSet s;
	//~ string empty_string = "z";
	for (int i = 0; i < _nb_machines; i++)
	{
		set_of_node[i].data = s;
		//~ set_of_node[i].id_next_job = "null";
		set_of_node[i].delay_next_dynamic_job = 0;
		//~ set_of_node[i].id_current_job = "null";
	}
	
	int number_of_node = _nb_machines;
	
    _schedule = Schedule(_nb_machines, date);
    (void) batsim_config;
}

void My_Scheduler::on_simulation_end(double date)
{
    (void) date;
}

void My_Scheduler::make_decisions(double date,
                                     SortableJobOrder::UpdateInformation *update_info,
                                     SortableJobOrder::CompareInformation *compare_info)
{
	LOG_F(INFO, "Beggining of make_decision.");	
	
    const Job * priority_job_before = _queue->first_job_or_nullptr();

    // Let's remove finished jobs from the schedule
    for (const string & ended_job_id : _jobs_ended_recently)
    {
		LOG_F(INFO, "Remove %s", ended_job_id.c_str());
		/* Check if current terminated job has a delay */
        _schedule.remove_job((*_workload)[ended_job_id]);
	}

    // Let's handle recently released jobs
    std::vector<std::string> recently_queued_jobs;
    for (const string & new_job_id : _jobs_released_recently)
    {
        const Job * new_job = (*_workload)[new_job_id];

        if (new_job->nb_requested_resources > _nb_machines) /* If a job need more nodes than available it's rejected. */
        {
            _decision->add_reject_job(new_job_id, date);
        }
        else if (!new_job->has_walltime) /* If a job has no walltime it's rejected. */
        {
            LOG_SCOPE_FUNCTION(INFO);
            LOG_F(INFO, "Date=%g. Rejecting job '%s' as it has no walltime", date, new_job_id.c_str());
            _decision->add_reject_job(new_job_id, date);
        }
        else /* Add job in queue. */
        {
            _queue->append_job(new_job, update_info);
            recently_queued_jobs.push_back(new_job_id);
        }
    }

    // Let's update the schedule's present
    _schedule.update_first_slice(date);
    
	//~ LOG_F(INFO, "Available machines in make_decisions:");
	//~ for (int i = 0; i < _schedule.begin()->available_machines.size(); i++)
	//~ {
		//~ LOG_F(INFO, "%d: delay = %d", _schedule.begin()->available_machines[i], set_of_node[_schedule.begin()->available_machines[i]].delay_next_dynamic_job);
		//~ if (test == 0 && set_of_node[_schedule.begin()->available_machines[i]].delay_next_dynamic_job != 0)
		//~ {
			//~ test = 1;
			//~ set_of_node[_schedule.begin()->available_machines[i]].delay_next_dynamic_job = 0;
			//~ submit_delay_job(10.0, date);
			//~ _decision->add_execute_job(job_id, _schedule.begin()->available_machines[i], date);
		//~ }
	//~ }

    // Queue sorting by priority
    const Job * priority_job_after = nullptr;
    sort_queue_while_handling_priority_job(priority_job_before, priority_job_after, update_info, compare_info, date);

    // If no resources have been released, we can just try to backfill the newly-released jobs
    if (_jobs_ended_recently.empty())
    {
        int nb_available_machines = _schedule.begin()->available_machines.size();
        LOG_F(INFO, "There are %d available nodes", nb_available_machines);

        for (unsigned int i = 0; i < recently_queued_jobs.size() && nb_available_machines > 0; ++i)
        {
            const string & new_job_id = recently_queued_jobs[i];
            const Job * new_job = (*_workload)[new_job_id];

            // The job could have already been executed by sort_queue_while_handling_priority_job,
            // that's why we check whether the queue contains the job.
            if (_queue->contains_job(new_job) && new_job != priority_job_after && new_job->nb_requested_resources <= nb_available_machines)
            {
                Schedule::JobAlloc alloc = _schedule.add_job_first_fit_data_aware(new_job, _selector);
                if ( alloc.started_in_first_slice)
                {
					LOG_F(INFO, "Execute %s backfill", new_job_id.c_str());
                    _decision->add_execute_job(new_job_id, alloc.used_machines, date);
                    _queue->remove_job(new_job);
                    nb_available_machines -= new_job->nb_requested_resources;
                }
                else
                    _schedule.remove_job(new_job);
            }
        }
    }
    else
    {
        // Some resources have been released, the whole queue should be traversed.
        /* Try to start a job if a dynamic job just finished */
        //~ for (int i = 0; i < number_of_node; i++)
        //~ {
			//~ if (set_of_node[i].id_next_job != "null")
			//~ {
				//~ LOG_F(INFO, "Node %d is not null on next, execute %s", i, set_of_node[i].id_next_job.c_str());
				//~ _decision->add_execute_job(set_of_node[i].id_next_job, i, date);
				//~ set_of_node[i].id_next_job = "null";
			//~ }
		//~ }
        
        auto job_it = _queue->begin();
        int nb_available_machines = _schedule.begin()->available_machines.size();
		LOG_F(INFO, "There are %d available nodes", nb_available_machines);
        
        // Let's try to backfill all the jobs
        while (job_it != _queue->end() && nb_available_machines > 0)
        {
            const Job * job = (*job_it)->job;

            if (_schedule.contains_job(job))
                _schedule.remove_job(job);

            if (job == priority_job_after) // If the current job is priority
            {
                Schedule::JobAlloc alloc = _schedule.add_job_first_fit_data_aware(job, _selector);

                if (alloc.started_in_first_slice)
                {
					LOG_F(INFO, "Execute %s no backfill prio", job->id.c_str());
                    _decision->add_execute_job(job->id, alloc.used_machines, date);
                    job_it = _queue->remove_job(job_it); // Updating job_it to remove on traversal
                    priority_job_after = _queue->first_job_or_nullptr();
                }
                else
                    ++job_it;
            }
            else // The job is not priority
            {
                Schedule::JobAlloc alloc = _schedule.add_job_first_fit_data_aware(job, _selector);

                if (alloc.started_in_first_slice)
                {
					LOG_F(INFO, "Execute %s no backfill no prio", job->id.c_str());
                    _decision->add_execute_job(job->id, alloc.used_machines, date);
                    job_it = _queue->remove_job(job_it);
                }
                else
                {
                    _schedule.remove_job(job);
                    ++job_it;
                }
            }
        }
    }
    
    /* Pour dire que les jobs dynamiques sont terminées. 
     * Il faut que je compte le nb de jobs dynamique ou que je sache quand ils sont tous finis pour pouvoir déclencher cela. */
    if (dynamic_finished == 1)
    //~ if (test == 1)
    {
		LOG_F(INFO, "Call finish dynamic jobs");
		_decision->add_scheduler_finished_submitting_jobs(date);
	}
}


void My_Scheduler::sort_queue_while_handling_priority_job(const Job * priority_job_before,
                                                             const Job *& priority_job_after,
                                                             SortableJobOrder::UpdateInformation * update_info,
                                                             SortableJobOrder::CompareInformation * compare_info,
                                                             double date)
{
    if (_debug)
		LOG_F(1, "sort_queue_while_handling_priority_job beginning, %s", _schedule.to_string().c_str());

    // Let's sort the queue
    _queue->sort_queue(update_info, compare_info);

    // Let the new priority job be computed
    priority_job_after = _queue->first_job_or_nullptr();

    // If the priority job has changed
    if (priority_job_after != priority_job_before)
    {
        // If there was a priority job before, let it be removed from the schedule
        if (priority_job_before != nullptr)
            _schedule.remove_job_if_exists(priority_job_before);

        // Let us ensure the priority job is in the schedule.
        // To do so, while the priority job can be executed now, we keep on inserting it into the schedule
        for (bool could_run_priority_job = true; could_run_priority_job && priority_job_after != nullptr; )
        {
            could_run_priority_job = false;

            // Let's add the priority job into the schedule
            //~ Schedule::JobAlloc alloc = _schedule.add_job_first_fit(priority_job_after, _selector);
            Schedule::JobAlloc alloc = _schedule.add_job_first_fit_data_aware(priority_job_after, _selector);

            if (alloc.started_in_first_slice)
            {
				/* If data load */
				if (test == 0) /* TODO : to delete. I just test here to do it just one time. */
                {
					//~ /* TODO : Add dynamic job for data load a mettre avant et une fois terminé mettre le job prévu sur le noeud */
					//~ if ((priority_job_after->data - set_of_node[alloc.used_machines[0]].data).size() != 0)
					//~ {
						//~ LOG_F(INFO, "Need at least one data load! Start dynamic job");
						//~ /* Next job is the one that was supposed to run. */	
						//~ set_of_node[alloc.used_machines[0]].id_next_job = priority_job_after->id;
						//~ /* Add delay job and when it's finished execute this one on the node. */
						//~ submit_delay_job(10.0, date);
						//~ string job_id = "w0!" + to_string(11); /* TODO : a incrémenter a chaque fois l'id. */
						//~ _decision->add_execute_job(job_id, alloc.used_machines, date);
					//~ }
					submit_delay_job(10.0, date);
					test = 1; /* I need to increment the number of dynamic job created ? */
						
						//~ /* Quand le job dynamique sera terminé, je mettrais sur le noeud, le vrai job qui était prévu. */
				}
				//~ else
				//~ {
				
					//~ LOG_F(INFO, "Execute %s in queue sort. %d data load needed", priority_job_after->id.c_str(), (priority_job_after->data - set_of_node[alloc.used_machines[0]].data).size());
					LOG_F(INFO, "Execute %s in queue sort.", priority_job_after->id.c_str());

					/* I add into the global struct of node the data loaded with this new task. */
					/* TODO-Maxime : deal with eviction ? */
					//~ LOG_F(INFO, "Intervalset from job");
					//~ for (int i = 0; i < priority_job_after->data.size(); i++)
					//~ {
						//~ LOG_F(INFO, "%d", priority_job_after->data[i]);
					//~ }
					//~ LOG_F(INFO, "Allocated node in fit is %d", alloc.used_machines[0]);
					//~ set_of_node[alloc.used_machines[0]].data += priority_job_after->data;
					//~ LOG_F(INFO, "Intervalset from node %d after adding new data", alloc.used_machines[0]);
					//~ for (int i = 0; i < set_of_node[alloc.used_machines[0]].data.size(); i++)
					//~ {
						//~ LOG_F(INFO, "%d", set_of_node[alloc.used_machines[0]].data[i]);
					//~ }
											
					_decision->add_execute_job(priority_job_after->id, alloc.used_machines, (double)update_info->current_date);
					_queue->remove_job(priority_job_after);
					priority_job_after = _queue->first_job_or_nullptr();
					could_run_priority_job = true;
				//~ }
            }
        }
    }

    if (_debug)
		LOG_F(1, "sort_queue_while_handling_priority_job ending, %s", _schedule.to_string().c_str());
}

void My_Scheduler::submit_delay_job(double delay, double date)
{
	int nb_submitted_jobs = 11; /* TODO a declarer ou incrementer aileurs. Utile ? Ouu pour les noms des jobs */
	
    string workload_name = "dynamic";
    //~ string workload_name = "w0";

    double submit_time = date;
    double walltime = delay + 5;
    int res = 1;
    string profile = "delay_" + std::to_string(delay);
    //~ string profile = "delay";

    int buf_size = 128;

    string job_id = to_string(nb_submitted_jobs);
    string unique_job_id = workload_name + "!" + job_id;

    char * buf_job = new char[buf_size];
    int nb_chars = snprintf(buf_job, buf_size,
             R"foo({"id":"%s", "subtime":%g, "walltime":%g, "res":%d, "profile":"%s"})foo",
             job_id.c_str(), submit_time, walltime, res, profile.c_str());
    PPK_ASSERT_ERROR(nb_chars < buf_size - 1);

    char * buf_profile = new char[buf_size];
    nb_chars = snprintf(buf_profile, buf_size,
            R"foo({"type": "delay", "delay": %g})foo", delay);
    PPK_ASSERT_ERROR(nb_chars < buf_size - 1);
	
	_decision->add_submit_profile(workload_name, profile, buf_profile, date);
	
    _decision->add_submit_job(workload_name, job_id, profile,
                              buf_job, buf_profile, date,
                              false);
                              
    delete[] buf_job;
    delete[] buf_profile;
}
