/* Maxime */

#include "my_scheduler.hpp"
#include "../global_struct_data_aware.hpp"

using namespace std;

/* Just for printing outputs for debug. */
#include <iostream>
#include <fstream>

#include <loguru.hpp>

#include "../pempek_assert.hpp"

struct node *set_of_node;

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
	for (int i = 0; i < _nb_machines; i++)
	{
		set_of_node[i].data = s;
	}
	
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
        _schedule.remove_job((*_workload)[ended_job_id]);

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

    // Queue sorting by priority
    const Job * priority_job_after = nullptr;
    sort_queue_while_handling_priority_job(priority_job_before, priority_job_after, update_info, compare_info);

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
					LOG_F(INFO, "Execute %s", new_job_id.c_str());
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
					LOG_F(INFO, "Execute %s", job->id.c_str());
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
					LOG_F(INFO, "Execute %s", job->id.c_str());
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
}


void My_Scheduler::sort_queue_while_handling_priority_job(const Job * priority_job_before,
                                                             const Job *& priority_job_after,
                                                             SortableJobOrder::UpdateInformation * update_info,
                                                             SortableJobOrder::CompareInformation * compare_info)
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
				LOG_F(INFO, "Execute %s in if (alloc.started_in_first_slice) of sort_queue", priority_job_after->id.c_str());
				print_intervalset_machine(alloc.used_machines, alloc.used_machines.size());
				
				//~ IntervalSet test_intervalset;
				//~ for (int i = 0; i < priority_job_after->nb_requested_resources; i++)
				//~ {
					//~ test_intervalset.insert(i);
				//~ }
				//~ LOG_F(INFO, "New custom Intervalset!");
				//~ print_intervalset_machine(test_intervalset, test_intervalset.size());
				
                _decision->add_execute_job(priority_job_after->id, alloc.used_machines, (double)update_info->current_date);
                //~ _decision->add_execute_job(priority_job_after->id, test_intervalset, (double)update_info->current_date);
                _queue->remove_job(priority_job_after);
                priority_job_after = _queue->first_job_or_nullptr();
                could_run_priority_job = true;
            }
        }
    }

    if (_debug)
		LOG_F(1, "sort_queue_while_handling_priority_job ending, %s", _schedule.to_string().c_str());
}


//~ My_Scheduler::My_Scheduler(Workload *workload, SchedulingDecision * decision, Queue * queue, ResourceSelector *selector, double rjms_delay, rapidjson::Document *variant_options) : ISchedulingAlgorithm(workload, decision, queue, selector, rjms_delay, variant_options)
//~ {	
    //~ if (variant_options->HasMember("fraction_of_machines_to_use"))
    //~ {
        //~ PPK_ASSERT_ERROR((*variant_options)["fraction_of_machines_to_use"].IsNumber(),
                //~ "Invalid options: 'fraction_of_machines_to_use' should be a number");
        //~ fraction_of_machines_to_use = (*variant_options)["fraction_of_machines_to_use"].GetDouble();
        //~ PPK_ASSERT_ERROR(fraction_of_machines_to_use > 0 && fraction_of_machines_to_use <= 1,
                         //~ "Invalid options: 'fraction_of_machines_to_use' should be in ]0,1] "
                         //~ "but got value=%g", fraction_of_machines_to_use);
    //~ }

    //~ if (variant_options->HasMember("custom_mapping"))
    //~ {
        //~ PPK_ASSERT_ERROR((*variant_options)["custom_mapping"].IsBool(),
                //~ "Invalid options: 'custom_mapping' should be a boolean");
        //~ custom_mapping = (*variant_options)["custom_mapping"].GetBool();
    //~ }

    //~ if (variant_options->HasMember("set_job_metadata"))
    //~ {
        //~ PPK_ASSERT_ERROR((*variant_options)["set_job_metadata"].IsBool(),
                //~ "Invalid options: 'set_job_metadata' should be a boolean");
        //~ set_job_metadata = (*variant_options)["set_job_metadata"].GetBool();
    //~ }

    //~ LOG_F(INFO, "custom_mapping: %s", custom_mapping?"true":"false");
    //~ LOG_F(INFO, "fraction_of_machines_to_use: %g", fraction_of_machines_to_use);
    //~ LOG_F(INFO, "set_job_metadata: %d", set_job_metadata);
//~ }

//~ My_Scheduler::~My_Scheduler()
//~ {

//~ }

//~ /* La on ajoute les machines */
//~ void My_Scheduler::on_simulation_start(double date, const rapidjson::Value & batsim_config)
//~ {
    //~ (void) date;
    //~ (void) batsim_config;

    //~ available_machines.insert(IntervalSet::ClosedInterval(0, _nb_machines - 1));
    //~ PPK_ASSERT_ERROR(available_machines.size() == (unsigned int) _nb_machines);
//~ }

//~ void My_Scheduler::on_simulation_end(double date)
//~ {
	//~ (void) date;
//~ }

//~ void My_Scheduler::make_decisions(double date,
                            //~ SortableJobOrder::UpdateInformation *update_info,
                            //~ SortableJobOrder::CompareInformation *compare_info)
//~ {
	/* Print in INFO the data */
    //~ set_of_task->print_set_of_task();
	//~ set_of_task->pointeur = set_of_task->head;
	//~ for (int j = 0; j < set_of_task->size_linked_list; j++)
	//~ {
		//~ for (int i = 0; i < set_of_task->pointeur->nb_data; i++)
		//~ {
			//~ LOG_F(INFO, "%d ", set_of_task->pointeur->tab_data[i]);
		//~ }
		//~ set_of_task->pointeur = set_of_task->pointeur->next;
	//~ }
	

    //~ // Let's update available machines
    //~ for (const string & ended_job_id : _jobs_ended_recently)
    //~ {
        //~ available_machines.insert(current_allocations[ended_job_id]);
        //~ current_allocations.erase(ended_job_id);
    //~ }

    //~ // Handle machine (un)availability from user events
    //~ unavailable_machines -= _machines_that_became_available_recently;
    //~ unavailable_machines += _machines_that_became_unavailable_recently;

    //~ // Let's handle recently released jobs
    //~ for (const string & new_job_id : _jobs_released_recently)
    //~ {
        //~ const Job * new_job = (*_workload)[new_job_id];

        //~ if (new_job->nb_requested_resources > _nb_machines)
            //~ _decision->add_reject_job(new_job_id, date);
        //~ else
            //~ _queue->append_job(new_job, update_info);
    //~ }

    //~ // Queue sorting
    //~ _queue->sort_queue(update_info, compare_info);

	//~ /* Ancien */
    //~ fill(date);
    
    /* Nouveau */
   	//~ auto job_it = _queue->begin();
	//~ const Job * job = (*job_it)->job;
    //~ int nb_machines_to_allocate = ceil(fraction_of_machines_to_use * job->nb_requested_resources);
    //~ IntervalSet used_machines = used_machines.left(nb_machines_to_allocate);
    //~ _decision->add_execute_job(job->id, used_machines, date);
//~ }

//~ void My_Scheduler::fill(double date)
//~ {
	//~ LOG_F(INFO, "Beggining of fill.");
    //~ IntervalSet usable_machines = available_machines - unavailable_machines;
    //~ if (_debug)
        //~ LOG_F(1, "fill, usable_machines=%s", usable_machines.to_string_hyphen().c_str());

    //~ int nb_usable = usable_machines.size();
    //~ for (auto job_it = _queue->begin(); job_it != _queue->end() && nb_usable > 0; )
    //~ {
        //~ const Job * job = (*job_it)->job;

        //~ // If it fits I sits (http://knowyourmeme.com/memes/if-it-fits-i-sits)
        //~ IntervalSet used_machines;

        //~ if (_selector->fit(job, usable_machines, used_machines))
        //~ {
            //~ // Fewer machines might be used that those selected by the fitting algorithm
            //~ int nb_machines_to_allocate = ceil(fraction_of_machines_to_use * job->nb_requested_resources);
            //~ PPK_ASSERT_ERROR(nb_machines_to_allocate > 0 && nb_machines_to_allocate <= job->nb_requested_resources);
            //~ used_machines = used_machines.left(nb_machines_to_allocate);

            //~ if (custom_mapping)
            //~ {
                //~ vector<int> executor_to_allocated_resource_mapping;
                //~ executor_to_allocated_resource_mapping.resize(job->nb_requested_resources);
                //~ for (int i = 0; i < job->nb_requested_resources; ++i)
                    //~ executor_to_allocated_resource_mapping[i] = i % nb_machines_to_allocate;
				//~ LOG_F(INFO, "Execute %s", job->id.c_str());
                //~ _decision->add_execute_job(job->id, used_machines, date, executor_to_allocated_resource_mapping);
            //~ }
            //~ else
            //~ {
                //~ _decision->add_execute_job(job->id, used_machines, date);
            //~ }

            //~ current_allocations[job->id] = used_machines;

            //~ usable_machines.remove(used_machines);
            //~ available_machines.remove(used_machines);
            //~ nb_usable -= used_machines.size();

            //~ if (set_job_metadata)
                //~ _decision->add_set_job_metadata(job->id,
                                                //~ "just some metadata for job " + job->id,
                                                //~ date);

            //~ job_it = _queue->remove_job(job);
        //~ }
        //~ else
            //~ job_it++;
    //~ }
//~ }
