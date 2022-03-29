#include "conservative_bf_node_stealing.hpp"

#include <loguru.hpp>

#include "../pempek_assert.hpp"

#include <iostream>
#include <fstream>

using namespace std;

ConservativeBackfillingNodeStealing ::ConservativeBackfillingNodeStealing(Workload *workload,
    SchedulingDecision *decision, Queue *queue, ResourceSelector *selector, double rjms_delay,
    rapidjson::Document *variant_options, map<string, double> *delay_dict,
    map<string, double> *checkpoint_period_dict, map<string, double> *checkpoint_cost_dict,
    map<string, double> *recovery_cost_dict,
    map<string, double> *Tfirst_dict,
    map<string, double> *Rfirst_dict)
    : ISchedulingAlgorithm(workload, decision, queue, selector, rjms_delay, variant_options)
{
    //cerr<<"ConservativeBackfillingNodeStealing is running"<<endl;
    if (variant_options->HasMember("dump_previsional_schedules"))
    {
        PPK_ASSERT_ERROR((*variant_options)["dump_previsional_schedules"].IsBool(),
            "Invalid options: 'dump_previsional_schedules' should be a boolean");
        _dump_provisional_schedules = (*variant_options)["dump_previsional_schedules"].GetBool();
    }

    if (variant_options->HasMember("dump_prefix"))
    {
        PPK_ASSERT_ERROR(
            (*variant_options)["dump_prefix"].IsString(), "Invalid options: 'dump_prefix' should be a string");
        _dump_prefix = (*variant_options)["dump_prefix"].GetString();
    }
    _delay_dict = delay_dict;
    _checkpoint_period_dict = checkpoint_period_dict;
    _checkpoint_cost_dict = checkpoint_cost_dict;
    _recovery_cost_dict = recovery_cost_dict;
    _Tfirst_dict = Tfirst_dict;
    _Rfirst_dict = Rfirst_dict;

    //For all hsuristics, submitting failed job copy using its previous checkpoint 
    //heuristic_choice = 0 without node stealing (no victim jobs), submitting failed job copy using its previous checkpoint
    //heuristic_choice = 1 node stealing heuristic, submitting victim job copy using its previous checkpoint
    //heuristic_choice = 2 node stealing heuristic, submitting victim job copy using its proactive checkpoint
    //heuristic_choice = 3 node stealing heuristic, submitting victim job copy using its future checkpoint
    _heuristic_choice = (*variant_options)["heuristic_choice"].GetInt();

    //victim_choice = 1 choose the job with smallest number of processors as victim, if ties, choose the one whose release time is latest
    //victim_choice = 2 choose the job with latest release time as victim, if ties, choose the one whose number of processors is smallest
    _victim_choice = (*variant_options)["victim_choice"].GetInt();

    //decision_choice = 1 only kill victim job when the number of processors of victim job is smaller than that of the failed job
    //decision_choice = 2 only kill victim job when the release time of victim job is later than that of the failed job
    //decision_choice = 3 only kill victim job when killing decision really minimize the maximal of flows of failed job and victim job
    _decision_choice = (*variant_options)["decision_choice"].GetInt();
}

ConservativeBackfillingNodeStealing ::~ConservativeBackfillingNodeStealing()
{
}

void ConservativeBackfillingNodeStealing ::on_simulation_start(double date, const rapidjson::Value &batsim_config)
{
    _schedule = Schedule(_nb_machines, date);
    (void)batsim_config;
}

void ConservativeBackfillingNodeStealing ::on_simulation_end(double date)
{
    (void)date;
}

void ConservativeBackfillingNodeStealing ::on_machine_available_notify_event(double date, IntervalSet machines)
{
    (void)date;
    _machines_that_became_available_recently += machines;

    for (auto it = _machines_that_became_available_recently.elements_begin();
         it != _machines_that_became_available_recently.elements_end(); ++it)
    {
        //cerr << *it << " ";
        _nb_machines++;
    }

    // add "current available machines" to the current TimeSlice
    Schedule::TimeSliceIterator slice = _schedule.find_last_time_slice_before_date(date);   
    _schedule.add_to_available_machines(_machines_that_became_available_recently, slice);

    // remove "current available machines" from the failed_machines
    for (auto it = _machines_that_became_available_recently.elements_begin();
         it != _machines_that_became_available_recently.elements_end(); ++it)
    {
        _schedule.remove_failed_machine(*it);
    }
}

void ConservativeBackfillingNodeStealing ::on_machine_unavailable_notify_event(double date, IntervalSet machines)
{
    (void)date;
    _machines_that_became_unavailable_recently += machines;
    
    for (auto it = _machines_that_became_unavailable_recently.elements_begin();
         it != _machines_that_became_unavailable_recently.elements_end(); ++it)
    {
        //cerr << *it << " ";
        _nb_machines--;
    }

    // remove "current unavailable machines" from the current TimeSlice   
    Schedule::TimeSliceIterator slice = _schedule.find_last_time_slice_before_date(date);
    _schedule.remove_from_available_machines(_machines_that_became_unavailable_recently, slice);

    // add "current unavailable machines" to the failed_machines
    for (auto it = _machines_that_became_unavailable_recently.elements_begin();
         it != _machines_that_became_unavailable_recently.elements_end(); ++it)
    {
        _schedule.add_failed_machine(*it);
    }
}

//step 1, kill failed job 
//step 2, whether to use node stealing strategy for this failed job
//step 3, find victim job
//step 4, kill decision
//step 5, submit checkpoint job
//step 6, kill victim job
//step 7, submit failed job copy    
//step 8, submit victim job copy

//For heuristic 0, step 1 -> step 7 (do not need step2)

//For heuristic 1 (the number of available machines is larger than the number of machines that failed job need), step 1 -> step 2 (FALSE) -> step 7
//For heuristic 1 (kill decision choice is false), step 1 -> step 2 (TRUE) -> step 3 -> step 4 (FALSE) -> step 7 
//For heuristic 1 (kill decision choice is true), step 1 -> step 2 (TRUE) -> step 3 -> step 4 (TRUE) -> step 6 -> step 7 -> step 8

//For heuristic 2 (the number of available machines is larger than the number of machines that failed job need), step 1 -> step 2 (FALSE) -> step 7 
//For heuristic 2 (kill decision choice is false), step 1 -> step 2 (TRUE) -> step 3 -> step 4 (FALSE) -> step 7 
//For heuristic 2 (kill decision choice is true), step 1 -> step 2 (TRUE) -> step 3 -> step 4 (TRUE) -> step 5 -> step 6 -> step 7 -> step 8

//For heuristic 3 (the number of available machines is larger than the number of machines that failed job need), step 1 -> step 2 (FALSE) -> step 7 
//For heuristic 3 (kill decision choice is false), step 1 -> step 2 (TRUE) -> step 3 -> step 4 (FALSE) -> step 7
//For heuristic 3 (kill decision choice is true), step 1 -> step 2 (TRUE) -> step 3 -> step 4 (TRUE) -> step 5 -> step 6 -> step 7 -> step 8


void ConservativeBackfillingNodeStealing ::make_decisions(
    double date, SortableJobOrder::UpdateInformation *update_info, SortableJobOrder::CompareInformation *compare_info)
{
    // cerr<<"date "<<date <<" make_decisions function is running"<<endl;
    if (_machines_that_became_unavailable_recently.is_empty() == false)
    {
        Schedule::TimeSliceIterator slice = _schedule.find_last_time_slice_before_date(date);
        // cerr<<"date: "<<date<<endl;
        // cerr<<"slice begin: "<<float(slice->begin) << "slice end: " <<float(slice->end) <<"slice length: "<<float(slice->length)<<endl;

        //////////////////////////////////////////////////////
        //
        //    1(0,1,2,3). Kill failed job
        //
        //////////////////////////////////////////////////////

        for (auto it = slice->allocated_jobs.begin(); it != slice->allocated_jobs.end(); ++it) //`it' is a pointer of the map (the map is allocated_jobs of current slice)
        {
            const Job *job_ref = (it->first);     // the key is the pointer of jobs (*job_ref)
            IntervalSet Proc_int = (it->second);  // the value is its according processor indexes (Proc_int)

            for (auto it = _machines_that_became_unavailable_recently.elements_begin();
                 it != _machines_that_became_unavailable_recently.elements_end(); ++it)
            {
                const Job *failed_job_ref = NULL;
                if (Proc_int.contains(*it))
                {
                    // cerr << "date: " << date <<"the processor " << *it << " is unavaialable" << endl;
                    failed_job_ref = job_ref;
                    string failed_job_id = failed_job_ref->id;
                    // cerr << "date: "<< date << "failed job " << failed_job_id << " using the processor " << *it << " should be killed now" << endl;
                    failed_date.insert(make_pair(failed_job_id,date));

                    //1. Test the current failed job is an old victim job or not
                    map<string, string>::iterator it_victim_checkpoint_job_dict = victim_checkpoint_job_dict.find(failed_job_id);//current failed job is the old victim job
                    if (it_victim_checkpoint_job_dict != victim_checkpoint_job_dict.end()) 
                    {
                        //The current failed job is an old victim job, failed_job_ref = old_victim_job_ref
                        //cerr<<"The current failed job "<<failed_job_id<<" is an old victim job"<<endl;

                        //First, we kill the old victim job
                        _decision->add_kill_job({failed_job_ref->id}, date); //failed job ref is an old victim job ref
                        
                        //Second, we kill the corresponding old checkpoint job
                        string old_checkpoint_job_id = it_victim_checkpoint_job_dict->second;
                        const Job *old_checkpoint_job_ref = (*_workload)[old_checkpoint_job_id];
                        _decision->add_kill_job({old_checkpoint_job_ref->id}, date);
                        //killed_checkpoint_job_id1 = old_checkpoint_job_ref->id;
                        killed_checkpoint_job.insert(old_checkpoint_job_ref->id);
                       
                        map<string, string>::iterator it_victim_failed_job_dict = victim_failed_job_dict.find(failed_job_id);//current failed job is the old victim job
                        if (it_victim_failed_job_dict != victim_failed_job_dict.end()) 
                        {
                            string old_failed_job_id = it_victim_failed_job_dict->second;

                            //Third, we submit the corresponding old failed job with priority 2 using previous checkpoint
                            const Job *old_failed_job_ref = (*_workload)[old_failed_job_id];
                            map<string, double>::iterator it = failed_date.find(old_failed_job_ref->id);
                            if (it != failed_date.end()) {
                                date_fail = it->second;
                            }
                            submit_job_copy(old_failed_job_ref, date, 2, 1, date_fail); 

                            //Forth, we submit old victim job (current failed job) copy with priority 1 using previous checkpoint
                            submit_job_copy(failed_job_ref, date, 1, 1, date_fail); 
                            
                            //Erase the old victim job (current failed job) from the two dicts, because the killed victim job will also be in the _jobs_ended_recently, 
                            //In _jobs_ended_recently, we only test the normal completed victim job, not the killed victim job  
                            victim_failed_job_dict.erase(failed_job_id);
                            victim_checkpoint_job_dict.erase(failed_job_id);
                            kill_normal_failed_job = false; // We do not need to execute "kill normal failed job function" below
                        }
                    }
                    
                    //2. Test the current failed job is an old checkpoint job or not
                    for (map<string, string>::iterator it_victim_checkpoint_job_dict = victim_checkpoint_job_dict.begin(); it_victim_checkpoint_job_dict != victim_checkpoint_job_dict.end(); it_victim_checkpoint_job_dict++)
                    {
                        //The current failed job is an old checkpoint job
                        string old_checkpoint_job_id = it_victim_checkpoint_job_dict->second;

                        if(failed_job_id==old_checkpoint_job_id){

                            string old_victim_job_id = it_victim_checkpoint_job_dict->first;
                            //cerr<<"The current failed job "<<failed_job_id<<" is an old checkpoint job"<<endl;
                            //cerr<<"The corresponding old victim job is "<<old_victim_job_id<<endl;

                            const Job *old_victim_job_ref = (*_workload)[old_victim_job_id];

                            map<string, string>::iterator it_victim_failed_job_dict = victim_failed_job_dict.find(old_victim_job_id);
                            if (it_victim_failed_job_dict != victim_failed_job_dict.end()) 
                            {
                                string old_failed_job_id = it_victim_failed_job_dict->second;
                                const Job *old_failed_job_ref = (*_workload)[old_failed_job_id];
                                int nb_failues_in_checkpoints = old_failed_job_ref->nb_requested_resources - failed_job_ref->nb_requested_resources + 1; //include the failure occur in checkpoint now

                                if (old_victim_job_ref->nb_requested_resources >= nb_failues_in_checkpoints)
                                {
                                    //The number of processors of the old victim job is larger than or equal to the failue numbers of the old checkpoint job
                                    //the number of resources of the old victim job is enough to give the old failed job

                                    //Special case: If the number of processors of old checkpoint job is equal to 1, we can not submit new samller checkpoint, since the the number of processors of new smaller checkpoint can not be 0
                                    //In this case, do not use the node-stealing, just kill the old checkpoint job (current failed job) and kill the old failed job and submit its job copy as "smaller than" case below
                                    if(failed_job_ref->nb_requested_resources==1){
                                        
                                        //First, kill the old checkpoint job (current failed job) 
                                        _decision->add_kill_job({failed_job_ref->id}, date); //failed_job_ref is old_checkpoint_job_ref
                                        //killed_checkpoint_job_id2 = failed_job_ref->id;
                                        killed_checkpoint_job.insert(failed_job_ref->id);

                                        map<string, double>::iterator it = failed_date.find(old_failed_job_ref->id);
                                        if (it != failed_date.end()) {
                                            date_fail = it->second;
                                        }

                                        //Second, submit the old failed job copy with priority 2 using its previous checkpoint
                                        submit_job_copy(old_failed_job_ref, date, 2, 1, date_fail); 

                                        //key is the victim job, remove the corresponding old checkpoint job (since the old checkpoint job is killed)
                                        victim_failed_job_dict.erase(old_victim_job_id);
                                        victim_checkpoint_job_dict.erase(old_victim_job_id);
                                    }
                                    else{
                                        //First, kill the old checkpoint job (current failed job)
                                        _decision->add_kill_job({failed_job_ref->id}, date); 
                                        killed_checkpoint_job_id3 = failed_job_ref->id;
                                        killed_checkpoint_job.insert(failed_job_ref->id);

                                        //Second, submit a new smaller checkpoint job with one less number of processors
                                        string checkpoint_job_id_new = submit_job_checkpoint_new(failed_job_ref, date, 3);

                                        //The checkpoint_job_id_new should also be included in the jobs_not_selected_as_victim 
                                        jobs_not_selected_as_victim.insert(checkpoint_job_id_new); 

                                        //key is the victim job, change the corresponding checkpoint job from the old checkpoint job to new smaller checkpoint job
                                        victim_checkpoint_job_dict[old_victim_job_id] = checkpoint_job_id_new;
                                    }
                                }
                                else
                                {   
                                    //The number of processors of the old victim job is smaller than the failue numbers of the old checkpoint job
                                    //the number of resources of the victim job is not enough to give the failed job
                                    //In this case, do not use the node-stealing, just kill the old checkpoint job (current failed job) and kill the old failed job and submit its job copy

                                    //First, kill the old checkpoint job (current failed job) 
                                    _decision->add_kill_job({failed_job_ref->id}, date); //failed_job_ref is old checkpoint_job_ref 
                                    killed_checkpoint_job_id4 = failed_job_ref->id;
                                    killed_checkpoint_job.insert(failed_job_ref->id);

                                    //Second, submit the old failed job copy with priority 2 using its previous checkpoint
                                    map<string, double>::iterator it = failed_date.find(old_failed_job_ref->id);
                                    if (it != failed_date.end()) {
                                        date_fail = it->second;
                                    }                                   
                                    submit_job_copy(old_failed_job_ref, date, 2, 1, date_fail); 

                                    //key is the victim job, remove the corresponding old checkpoint job (since the old checkpoint job is killed)
                                    victim_failed_job_dict.erase(old_victim_job_id);
                                    victim_checkpoint_job_dict.erase(old_victim_job_id);
                                    
                                }
                                kill_normal_failed_job = false;
                                break;
                            }
                        }
                    }
                    
                    //The current failed job is neither an old victim job nor an old checkpoint job, it is a normal failed job
                    if (kill_normal_failed_job==true)
                    {
                        //First, kill the normal failed job
                        _decision->add_kill_job({ failed_job_ref->id }, date); 
                        jobs_not_selected_as_victim.insert(failed_job_ref->id);

                        //cerr<<"test!!!"<<endl;
                        if (_heuristic_choice==0){
                            //////////////////////////////////////////////////////
                            //
                            //    7(0). Submit failed job copy with priority 2
                            //
                            //////////////////////////////////////////////////////

                            //Submit the failed job copy with priority 2 using its previous checkpoint
                            map<string, double>::iterator it = failed_date.find(failed_job_ref->id);
                            if (it != failed_date.end()) {
                                date_fail = it->second;
                            }
                            submit_job_copy(failed_job_ref, date, 2, _heuristic_choice, date_fail); 
                        }
                        else{
                            //////////////////////////////////////////////////////////////////////////
                            //
                            //    2(1,2,3). Weather to use node stealing strategy for the failed job 
                            //
                            //////////////////////////////////////////////////////////////////////////

                            //when the number of processors of failed job is equal to 1 (only for proactive heuristic and future heuristic), we do not use the node-stealing for all the heuristics, because we can not submit a checkpoint-job using 0 processor
                            //when the number of available machines is larger than 0, we do not use the node-stealing, since failed job copy can use the available idle machine
                            
                            if ((_heuristic_choice==1) || ((_heuristic_choice==2) && (failed_job_ref->nb_requested_resources>1)) || ((_heuristic_choice==3) && (failed_job_ref->nb_requested_resources>1)))
                            {
                                find_victim_job_bool = true;
                                //cerr<<"update"<<endl;
                            }
                            else{
                                find_victim_job_bool = false;
                            }
                            
                            whether_to_use_node_stealing_total = whether_to_use_node_stealing_total + 1;
                            //cerr<<"whether_to_use_node_stealing_total "<<whether_to_use_node_stealing_total<<endl;
                            ofstream fout("./node_stealing_times.txt",ios::app);
                            fout << "date "<<date<< " failure " << whether_to_use_node_stealing_total <<endl;
                            fout.close();  
                            

                            if (slice->nb_available_machines == 0 && find_victim_job_bool) 
                            {
                                whether_to_use_node_stealing_true = whether_to_use_node_stealing_true + 1;
                                //cerr<<"whether_to_use_node_stealing_true "<<whether_to_use_node_stealing_true<<endl;

                                //////////////////////////////////////////////////////
                                //
                                //    3(1,2,3). Find VICTIM JOB
                                //
                                //////////////////////////////////////////////////////

                                const Job *victim_job_ref = NULL;
                                if (_victim_choice==1)
                                {
                                    // 1. Choose the job with smallest number of processors as victim job
                                    int nb_requested_resources_victim_temp = 1e9;                                  
                                    for (auto it = slice->allocated_jobs.begin(); it != slice->allocated_jobs.end(); ++it)
                                    {
                                        const Job *job_ref = (it->first);
                                        string job_id_temp = job_ref->id;
                                        std::set<std::string>::iterator it_not_selected = jobs_not_selected_as_victim.find(job_id_temp);
                                        if (it_not_selected != jobs_not_selected_as_victim.end())
                                        {
                                            //The victim job temp is inclued in the set 'jobs_not_selected_as_victim', should find another one
                                        }
                                        else{
                                            //The victim job temp is not inclued in the set 'jobs_not_selected_as_victim', should try this one
                                            int nb_requested_resources_ref = job_ref->nb_requested_resources;
                                            if (nb_requested_resources_ref <= nb_requested_resources_victim_temp || victim_job_ref == NULL)
                                            {
                                                if (nb_requested_resources_ref < nb_requested_resources_victim_temp || victim_job_ref == NULL){
                                                    nb_requested_resources_victim_temp = nb_requested_resources_ref;
                                                    victim_job_ref = job_ref;
                                                }
                                                else{
                                                    //If ties, choose the one whose release date is the latest
                                                    if (job_ref->submission_time > victim_job_ref->submission_time)
                                                    {
                                                        nb_requested_resources_victim_temp = nb_requested_resources_ref;
                                                        victim_job_ref = job_ref;
                                                    }
                                                }                                   
                                            }
                                            find_victim_job_successfully = true;
                                        }
                                    }
                                }
                                else if (_victim_choice==2)
                                {
                                    // 2. Choose the job with the latest release date as victim job
                                    double release_date_victim_temp = 0.0;                                    
                                    for (auto it = slice->allocated_jobs.begin(); it != slice->allocated_jobs.end(); ++it)
                                    {
                                        const Job *job_ref = (it->first);
                                        string job_id_temp = job_ref->id;
                                        std::set<std::string>::iterator it_not_selected = jobs_not_selected_as_victim.find(job_id_temp);
                                        if (it_not_selected != jobs_not_selected_as_victim.end())
                                        {
                                            //The victim job temp is inclued in the set 'jobs_not_selected_as_victim', should find another one
                                        }
                                        else
                                        {
                                            //The victim job temp is not inclued in the set 'jobs_not_selected_as_victim', should try this one
                                            //IntervalSet Proc_int = (it->second);
                                            double release_date_ref = job_ref->submission_time;
                                            if (release_date_ref >= release_date_victim_temp || victim_job_ref == NULL)
                                            {
                                                if (release_date_ref > release_date_victim_temp || victim_job_ref == NULL)
                                                {
                                                    release_date_victim_temp = release_date_ref;
                                                    victim_job_ref = job_ref;
                                                }
                                                else{
                                                    //If ties, choose the one whose number of processors is smaller
                                                    if (job_ref->nb_requested_resources < victim_job_ref->nb_requested_resources)
                                                    {
                                                        release_date_victim_temp = release_date_ref;
                                                        victim_job_ref = job_ref;
                                                    }
                                                }  
                                            }
                                            find_victim_job_successfully = true;
                                        }
                                    }
                                }
                                else{
                                    cerr<<"_victim_choice is neither 1 nor 2"<<endl;
                                } 

                                find_victim_job_total = find_victim_job_total + 1;
                                //cerr<<"find_victim_job_total "<<find_victim_job_total<<endl;

                                if(find_victim_job_successfully == true){

                                    find_victim_job_true = find_victim_job_true + 1;
                                    //cerr<<"find_victim_job_true "<<find_victim_job_true<<endl;

                                    //////////////////////////////////////////////////////////////////
                                    //
                                    //    Step 4 (heuristic 1, 2 or 3). KILL decision choice
                                    //
                                    //////////////////////////////////////////////////////////////////

                                    if (_decision_choice==3){

                                        map<string, double>::iterator it = failed_date.find(failed_job_ref->id);
                                        if (it != failed_date.end()) {
                                            date_fail = it->second;
                                        }
                                        double t_kill = 0.0; //t_kill is the date when kill the victim job
                                        if (_heuristic_choice==1){
                                            t_kill = date_fail;
                                        }
                                        else if (_heuristic_choice==2){
                                            string job_id_contains_workloadname = victim_job_ref->id; //victim job id

                                            map<string, double>::iterator iter_ckp_period = _checkpoint_period_dict->find(job_id_contains_workloadname);
                                            double T = iter_ckp_period->second;

                                            map<string, double>::iterator iter_ckp_cost = _checkpoint_cost_dict->find(job_id_contains_workloadname);
                                            double C = iter_ckp_cost->second;

                                            map<string, double>::iterator iter_Tfirst = _Tfirst_dict->find(job_id_contains_workloadname);
                                            double Tfirst = iter_Tfirst->second;

                                            map<string, double>::iterator iter_Rfirst = _Rfirst_dict->find(job_id_contains_workloadname);
                                            double Rfirst = iter_Rfirst->second;

                                            map<string, double>::iterator iter_starting_time = _starting_time.find(job_id_contains_workloadname);
                                            double t_start = iter_starting_time->second;

                                            double delay = 0.0;
                                            double t_fail = date_fail;

                                            if (t_fail - t_start <= Rfirst){
                                                //at date_fail, victim job is setting the Rfirst, 
                                                //thus no need to set another new checkpoint, see previous checkpoint as proactive checkpoint
                                                //just kill victim job and resubmit failed job copy and victim job copy
                                                //delay of the proactive checkpoint job should be 0
                                                delay = 0.1; 
                                            }
                                            else if(t_fail - t_start > Rfirst && t_fail - t_start <= Rfirst+Tfirst){
                                                delay = C;
                                            }
                                            else if(t_fail - t_start > Rfirst+Tfirst && t_fail - t_start <= Rfirst+Tfirst+C){
                                                //at date_fail, victim job is setting the regular checkpoint, 
                                                //thus no need to set another new checkpoint, 
                                                //just continue finishing the current uncompleted regular checkpoint 
                                                delay = C - (t_fail - t_start - Rfirst - Tfirst); 
                                            }
                                            else{
                                                double t1 = Rfirst + Tfirst + C;
                                                double a = t_fail - t_start - floor((t_fail - (t_start+t1))/(T+C)) *(T+C) - t1;
                                                if (a <= T){
                                                    delay = C;
                                                }
                                                else // T < a <= T+c
                                                {
                                                    //at date_fail, victim job is setting the regular checkpoint, 
                                                    //thus no need to set another new checkpoint, 
                                                    //just continue finishing the current uncompleted regular checkpoint 
                                                    delay = T + C - a; 
                                                }  
                                            }
                                            t_kill = date_fail + delay;
                                        }
                                        else if (_heuristic_choice==3){
                                            string job_id_contains_workloadname = victim_job_ref->id; //victim job id

                                            map<string, double>::iterator iter_ckp_period = _checkpoint_period_dict->find(job_id_contains_workloadname);
                                            double T = iter_ckp_period->second;

                                            map<string, double>::iterator iter_ckp_cost = _checkpoint_cost_dict->find(job_id_contains_workloadname);
                                            double C = iter_ckp_cost->second;

                                            map<string, double>::iterator iter_Tfirst = _Tfirst_dict->find(job_id_contains_workloadname);
                                            double Tfirst = iter_Tfirst->second;

                                            map<string, double>::iterator iter_Rfirst = _Rfirst_dict->find(job_id_contains_workloadname);
                                            double Rfirst = iter_Rfirst->second;

                                            map<string, double>::iterator iter_starting_time = _starting_time.find(job_id_contains_workloadname);
                                            double t_start = iter_starting_time->second;
                                            
                                            double t1 = 0.0;
                                            double delay = 0.0;
                                            double t_fail = date_fail;
                                        
                                            if (t_fail - t_start <= Rfirst + Tfirst +C){
                                                t1 = Rfirst + Tfirst +C;
                                                delay = t1 - (t_fail - t_start);
                                            }
                                            else{
                                                t1 = Rfirst + Tfirst +C;
                                                delay = ceil((t_fail - (t1+t_start))/(T+C)) * (T+C) +t1 - (t_fail-t_start);
                                            }

                                            t_kill = date_fail + delay;
                                        }                                     

                                        // The walltime of the failed job copy 
                                        double Rfirst_failed_job_copy = submit_job_Rfirst(failed_job_ref, date_fail, 2, _heuristic_choice);
                                        double t_useful_failed_job = submit_job_delay_killdecision3(failed_job_ref, date_fail, 2, _heuristic_choice);
                                        //double t_useful_failed_job = submit_job_delay(failed_job_ref, date_fail, 2, _heuristic_choice);
                                        // string failed_job_id = failed_job_ref->id;
                                        // cerr<<"failed_job_id "<<failed_job_id<<endl;
                                        int pos1 = failed_job_id.find("!");
                                        string failed_job_id_number = failed_job_id.substr(pos1 + 1); // Here, failed_job_id_number does not containing the workloadname
                                        double Rfirst_failed_last_job = 0.0;
                                        map<string, double>::iterator iter_failed_Rfirst_dict = Rfirst_dict.find(failed_job_id_number);
                                        if (iter_failed_Rfirst_dict != Rfirst_dict.end())
                                        {
                                            Rfirst_failed_last_job = iter_failed_Rfirst_dict->second;
                                            //cerr<<"Rfirst_failed_last_job "<<Rfirst_failed_last_job<<endl;
                                        }
                                        Rational walltime_failed_job = failed_job_ref->walltime - Rfirst_failed_last_job -5;
                                        // Rational walltime_failed_job_copy = ceil(Rfirst_failed_job_copy) + walltime_failed_job -floor(t_useful_failed_job);
                                        double walltime_failed_job_copy = Rfirst_failed_job_copy + (double)walltime_failed_job - t_useful_failed_job;

                                        // The walltime of the victim job copy 
                                        double Rfirst_victim_job_copy = submit_job_Rfirst(victim_job_ref, date_fail, 1, _heuristic_choice);
                                        double t_useful_victim_job = submit_job_delay_killdecision3(victim_job_ref, date_fail, 1, _heuristic_choice);
                                        //double t_useful_victim_job = submit_job_delay(victim_job_ref, date_fail, 1, _heuristic_choice);
                                        string victim_job_id = victim_job_ref->id;
                                        //cerr<<"victim_job_id "<<victim_job_id<<endl;
                                        int pos2 = victim_job_id.find("!");
                                        string victim_job_id_number = victim_job_id.substr(pos2 + 1); // Here, victim_job_id_number does not containing the workloadname
                                        double Rfirst_victim_last_job = 0.0;
                                        map<string, double>::iterator iter_victim_Rfirst_dict = Rfirst_dict.find(victim_job_id_number);
                                        if (iter_victim_Rfirst_dict != Rfirst_dict.end())
                                        {
                                            Rfirst_victim_last_job = iter_victim_Rfirst_dict->second;
                                            //cerr<<"Rfirst_victim_last_job "<<Rfirst_victim_last_job<<endl;
                                        }
                                        Rational walltime_victim_job = victim_job_ref->walltime - Rfirst_victim_last_job -5;
                                        // Rational walltime_victim_job_copy = ceil(Rfirst_victim_job_copy) + walltime_victim_job - floor(t_useful_victim_job);
                                        double walltime_victim_job_copy = Rfirst_victim_job_copy + (double)walltime_victim_job - t_useful_victim_job;    
                                        
                                        //we can not use the end of current slice as t_prime, since the definition of the end of the current slice is the minimal of starting time plus walltime of all jobs
                                        //these jobs include the failed job itself, we should exclude the failed job since one of it processor is unavailable
                                        double t_prime_nokill_failedjob=1e9;
                                        double t_prime_nokill_failedjob_temp=0.0;
                                        for (auto it = slice->allocated_jobs.begin(); it != slice->allocated_jobs.end(); ++it)
                                        {
                                            const Job *job_ref = (it->first);
                                            if (job_ref != failed_job_ref){ //exclude the failed job, at least there is a victim job (and other running jobs)
                                                IntervalSet Proc_int = (it->second);
                                                map<string, double>::iterator iter_starting_time = _starting_time.find(job_ref->id);
                                                t_prime_nokill_failedjob_temp = iter_starting_time->second + float(job_ref->walltime) - 5;
                                                if (t_prime_nokill_failedjob_temp < t_prime_nokill_failedjob)
                                                {
                                                    t_prime_nokill_failedjob = t_prime_nokill_failedjob_temp;
                                                }
                                            }  
                                        }

                                        double t_prime_kill_victimjob1=1e9;
                                        double t_prime_kill_victimjob1_temp = 0.0;
                                        for (auto it = slice->allocated_jobs.begin(); it != slice->allocated_jobs.end(); ++it)
                                        {
                                            const Job *job_ref = (it->first);
                                            //exclude the failed job and victim job
                                            if (job_ref != failed_job_ref && job_ref != victim_job_ref){ 
                                                IntervalSet Proc_int = (it->second);
                                                map<string, double>::iterator iter_starting_time = _starting_time.find(job_ref->id);
                                                t_prime_kill_victimjob1_temp = iter_starting_time->second + float(job_ref->walltime)-5;
                                                if (t_prime_kill_victimjob1_temp < t_prime_kill_victimjob1)
                                                {
                                                    t_prime_kill_victimjob1 = t_prime_kill_victimjob1_temp;
                                                }
                                            }  
                                        }

                                        //after excluding the failed job and victim job, if no other jobs in current slice, 
                                        //victim job copy should execute after t_kill plus delay of failed job copy using the processors of old victim job , 
                                        //we do not know the delay of failed job copy, we use the walltime of failed job copy to substitute delay of failed job copy
                                        double t_prime_kill_victimjob2 = t_kill + float(walltime_failed_job_copy);

                                        //We shoule take the minimal of t_prime_kill_victimjob1 and t_prime_kill_victimjob2 as t_prime_kill_victimjob
                                        //Two cases: first, after excluding the failed job and victim job, if no other jobs in current slice, then t_prime_kill_victimjob1=1e9, we should use t_prime_kill_victimjob2
                                        //Second, after excluding the failed job and victim job, we find t_prime_kill_victimjob1 in current slice, but it is larger than t_prime_kill_victimjob2, we shouls also use t_prime_kill_victimjob2
                                        double t_prime_kill_victimjob = min(t_prime_kill_victimjob1, t_prime_kill_victimjob2);
                                        
                                        double r1 = failed_job_ref->submission_time; //The release time of failed job
                                        double r2 = victim_job_ref->submission_time; //The release time of victim job

                                        //For the no killing case                
                                        map<string, double>::iterator iter_starting_time = _starting_time.find(victim_job_ref->id);
                                        double s2 = iter_starting_time->second; //The starting time of victim job                    
                                        double c1 = t_prime_nokill_failedjob + float(walltime_failed_job_copy); //The completion time of failed job without killing victim job
                                        double c2 = s2 + float(walltime_victim_job); //The completion time of victim job without killing victim job    
                                        double MF = max(c1-r1,c2-r2);

                                        //For the killing case
                                        double c1_k = t_kill + float(walltime_failed_job_copy); //The completion time of failed job with killing victim job
                                        double c2_k = t_prime_kill_victimjob + float(walltime_victim_job_copy); //The completion time of victim job with killing victim job
                                        double MF_k = max(c1_k-r1,c2_k-r2);

                                        if (MF<=MF_k){
                                            kill_desicion_MF = false;
                                        }
                                        else{
                                            kill_desicion_MF = true;
                                        }

                                        // cerr<<"s2 "<<s2<<endl;
                                        // cerr<<"c1 "<<c1<<endl;
                                        // cerr<<"c2 "<<c2<<endl;
                                        // cerr<<"r1 "<<r1<<endl;
                                        // cerr<<"r2 "<<r2<<endl;
                                        // cerr<<"c1_k "<<c1_k<<endl;
                                        // cerr<<"c2_k "<<c2_k<<endl;
                                        // cerr<<"MF "<<MF<<endl;
                                        // cerr<<"MF_k "<<MF_k<<endl;
                                    }
                                    

                                    //cerr<<"failed_job_ref->id "<<failed_job_ref->id<<endl;
                                    //cerr<<"job_ref->id "<<job_ref->id<<endl;
                                    //cerr<<"victim_job_ref->id "<<victim_job_ref->id<<endl;

                                    //cerr<<"victim_job_ref->nb_requested_resources "<<victim_job_ref->nb_requested_resources<<endl;
                                    //cerr<<"failed_job_ref->nb_requested_resources "<<failed_job_ref->nb_requested_resources<<endl;
                                    //cerr<<"victim_job_ref->submission_time "<<victim_job_ref->submission_time<<endl;
                                    //cerr<<"failed_job_ref->submission_time "<<failed_job_ref->submission_time<<endl;
                                    //cerr<<"kill_desicion_MF "<<kill_desicion_MF<<endl;
                

                                    //if ((_decision_choice==1) || (_decision_choice==2)  || (_decision_choice==3)) //always kill
                                   
                                    kill_decision_total = kill_decision_total + 1;
                                    //cerr<<"kill_decision_total "<<kill_decision_total<<endl;
                                    
                                    if (((_decision_choice==1) && (victim_job_ref->nb_requested_resources < failed_job_ref->nb_requested_resources)) 
                                        || ((_decision_choice==2) && (victim_job_ref->submission_time > failed_job_ref->submission_time)) 
                                        ||((_decision_choice==3) && (kill_desicion_MF==true))) 
                                    {
                                        kill_decision_true = kill_decision_true + 1;
                                        //cerr<<"kill_decision_true "<<kill_decision_true<<endl;

                                        ofstream fout("./node_stealing_times.txt",ios::app);
                                        fout << "date "<<date<< " nodesteal " << kill_decision_true << endl;
                                        fout.close();  
                                        
                                        //kill decision choice is true
                                        if (_heuristic_choice==1){
                                            ///////////////////////////////////////////////////////////////////
                                            //
                                            //    Step 6 (heuristic 1). Kill victim job
                                            //
                                            ///////////////////////////////////////////////////////////////////

                                            _decision->add_kill_job({ victim_job_ref->id }, date);
                                            //cerr<<"testtest"<<endl;

                                            ///////////////////////////////////////////////////////////////////
                                            //
                                            //    Step 7 (heuristic 1). Submit failed job copy with priority 2
                                            //
                                            ///////////////////////////////////////////////////////////////////
                                            
                                            map<string, double>::iterator it = failed_date.find(failed_job_ref->id);
                                            if (it != failed_date.end()) {
                                                date_fail = it->second;
                                            }
                                            submit_job_copy(failed_job_ref, date, 2, _heuristic_choice, date_fail); 

                                            ////////////////////////////////////////////////////////////////////
                                            //
                                            //    Step 8 (heuristic 1). Submit victim job copy with priority 1
                                            //
                                            ////////////////////////////////////////////////////////////////////

                                            submit_job_copy(victim_job_ref, date, 1, _heuristic_choice, date_fail);
                                        }
                                        else if (_heuristic_choice==2 || _heuristic_choice==3){
                                            /////////////////////////////////////////////////////////////////////////
                                            //
                                            //    Step 5 (heuristic 2 or 3). Submit checkpoint job with priority 3
                                            //
                                            /////////////////////////////////////////////////////////////////////////
                                            
                                            string checkpoint_job_id = submit_job_checkpoint(failed_job_ref, victim_job_ref, date, 3, _heuristic_choice);

                                            jobs_not_selected_as_victim.insert(checkpoint_job_id); //old checkpoint job can not be selected as the victim job
                                            jobs_not_selected_as_victim.insert(victim_job_ref->id); //old victim job can not be selected as the victim job
                                            
                                            //key is the victim job id, value is the checkpoint job id 
                                            victim_checkpoint_job_dict.insert(make_pair(victim_job_ref->id, checkpoint_job_id));

                                            //key is the victim job id, value is the failed job id 
                                            victim_failed_job_dict.insert(make_pair(victim_job_ref->id, failed_job_ref->id));




                                            // ////////////////////////////////////////////////////////////////////////
                                            // //
                                            // //    Step 7 (heuristic 2 or 3). Submit failed job copy with priority 2
                                            // //
                                            // ////////////////////////////////////////////////////////////////////////

                                            // // string failed_job_id = failed_job_workload_name + "!" + failed_job_id_number;
                                            // // const Job *failed_job_ref = (*_workload)[failed_job_id];
                                            // map<string, double>::iterator it = failed_date.find(failed_job_ref->id);
                                            // if (it != failed_date.end()) {
                                            //     date_fail = it->second;
                                            // }
                                            // submit_job_copy(failed_job_ref, date, 2, _heuristic_choice, date_fail); 
                                        }
                                        else{
                                            cerr<<"Something wrong, _heuristic_choice is not 1, 2 and 3"<<endl;
                                        }
                                    }
                                    else{
                                        //kill decision is false, thus we do not kill the vcitm job, we submit failed job copy with priority 2 directly
                                        //cerr<<"kill decision is false "<<endl;
                                        /////////////////////////////////////////////////////////////////////////////////////////////////////
                                        //
                                        //    Step 7 (heuristic 1, 2 or 3). Submit failed job copy with priority 2 (Kill decision is false)
                                        //
                                        //////////////////////////////////////////////////////////////////////////////////////////////////////
                                        
                                        map<string, double>::iterator it = failed_date.find(failed_job_ref->id);
                                        if (it != failed_date.end()) {
                                            date_fail = it->second;
                                        }
                                        submit_job_copy(failed_job_ref, date, 2, _heuristic_choice, date_fail);                   
                                    }
                                    find_victim_job_successfully = false;
                                }
                                else
                                {
                                    //special case, "find_victim_job_successfully = false" 
                                    //after excluding the jobs in the jobs_not_selected_as_victim set from the allocated jobs map of the current slice 
                                    //there is no other jobs to be selected as victim, thus we should use no victim job (no node-stealing) and just submit the failed job copy
                                    //cerr<<"find_victim_job_successfully = false "<<endl;
                                    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                    //
                                    //    Step 7 (heuristic 1, 2 or 3). Submit failed job copy with priority 2 (Do not find the adequate victim job)
                                    //
                                    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                    
                                    map<string, double>::iterator it = failed_date.find(failed_job_ref->id);
                                    if (it != failed_date.end()) {
                                        date_fail = it->second;
                                    }
                                    submit_job_copy(failed_job_ref, date, 2, _heuristic_choice, date_fail); 
                                } 
                            }
                            else{
                                //if the number of available machines is not equal to 0 or 
                                //the number of resources of failed job is equal to 1 (only for proactive and future heuristic), we should submit failed job directly
                                //cerr<<"the number of available machines is not equal to 0 or the number of resources of failed job is equal to 1"<<endl;
                                ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                //
                                //    Step 7 (heuristic 1, 2 or 3). Submit failed job copy with priority 2 (Whether to use node stealing strategy for the failed job is false)
                                //
                                ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                
                                map<string, double>::iterator it = failed_date.find(failed_job_ref->id);
                                if (it != failed_date.end()) {
                                    date_fail = it->second;
                                }
                                submit_job_copy(failed_job_ref, date, 2, _heuristic_choice, date_fail); 
                            }
                        }   
                    }
                    kill_normal_failed_job = true;
                }
            }
        }
    }



    // for (vector<string>::iterator it_jobs_ended_recently = _jobs_ended_recently.begin(); it_jobs_ended_recently != _jobs_ended_recently.end(); it_jobs_ended_recently++)
    // {
    //     cerr<<"*it_jobs_ended_recently "<<*it_jobs_ended_recently<<endl;
    // }

    // for (set<string>::iterator it_killed_checkpoint_job = killed_checkpoint_job.begin(); it_killed_checkpoint_job != killed_checkpoint_job.end(); it_killed_checkpoint_job++)
    // {
    //     cerr<<"*it_killed_checkpoint_job "<<*it_killed_checkpoint_job<<endl;
    // }

    // Let's remove finished jobs from the schedule 
    for (const string &ended_job_id : _jobs_ended_recently)
    {
        // remove ended job from the set jobs_not_selected as victim
        std::set<std::string>::iterator it_not_selected = jobs_not_selected_as_victim.find(ended_job_id);
        if (it_not_selected != jobs_not_selected_as_victim.end())
        {
            jobs_not_selected_as_victim.erase(ended_job_id);
        }

        const Job *removed_job = (*_workload)[ended_job_id];
        string removed_job_id = removed_job->id;
        // cerr<<"removed_job_id "<<removed_job_id<<endl;

        // special case, the victim job completes before the checkpoint job completion,
        // we should kill the corresponding checkpoint job and submit failed job copy
        map<string, string>::iterator it_victim_checkpoint_job_dict = victim_checkpoint_job_dict.find(removed_job_id); //test the removed job id is the victim job id or not
        if (it_victim_checkpoint_job_dict != victim_checkpoint_job_dict.end()) 
        {
            // cerr<<"removed_job_id1 "<<removed_job_id<<endl;
            //The removed job is a victim job
            //First, we should kill the corresponding checkpoint job
            string checkpoint_job_id = it_victim_checkpoint_job_dict->second;
            const Job *checkpoint_job_ref = (*_workload)[checkpoint_job_id];
            _decision->add_kill_job({ checkpoint_job_ref->id }, date);
            //killed_checkpoint_job_id5 = checkpoint_job_ref->id;
            killed_checkpoint_job.insert(checkpoint_job_ref->id);

            //Second, find the corresponding failed job and submit the failed job copy
            map<string, string>::iterator it_victim_failed_job_dict = victim_failed_job_dict.find(removed_job_id); //removed job id is the victim job id now
            if (it_victim_failed_job_dict != victim_failed_job_dict.end()) 
            {
                string failed_job_id = it_victim_failed_job_dict->second;
                const Job *failed_job_ref = (*_workload)[failed_job_id];
                map<string, double>::iterator it = failed_date.find(failed_job_ref->id);
                if (it != failed_date.end()) {
                    date_fail = it->second;
                }
                submit_job_copy(failed_job_ref, date, 2, _heuristic_choice, date_fail);
                // cerr<<"submit failed_job_ref successfully "<<failed_job_ref->id<<endl;

                // special case for victim job, the victim job finishes before the checkpoint job completion
                victim_failed_job_dict.erase(removed_job_id);
                victim_checkpoint_job_dict.erase(removed_job_id);
                // cerr<<"erase succesfully"<<endl;
            }
            else 
            {
                cerr<<"Something wrong, can not find the victim job in the map victim_failed_job_dict"<<endl;
            }
        }
        // else 
        // {
            //The removed job is not a victim job, it may be a checkpoint job or normal job
        // }

        //Check the checkpoint_job with priority 3
        //There are two cases, First, the checkpoint job complete succesfully, we should submit failed job copy and victim job copy
        //Second, the checkpoint job is killed because some reason, we should not submit failed job copy and victim job copy (failed job copy and victim job copy are analysed case by case above) 
        
        set<string>::iterator it_killed_checkpoint_job = killed_checkpoint_job.find(removed_job_id); //test the removed job id is the victim job id or not
        if (it_killed_checkpoint_job != killed_checkpoint_job.end()) 
        {
            _schedule.remove_job(removed_job); //remove killed checkpoint job from the schedule
            killed_checkpoint_job.erase(removed_job_id);
        }
        else
        {
            if (removed_job->priority==3) 
            {
                execute_schedule_code = false;
                //removed_job is a normal checkpoint job
                // cerr<<"removed_job3 "<<removed_job->id<<endl;
                //cerr<<"remove the job (completed checkpoint job or killed checkpoint job) from the schedule: "<<removed_job->id<<endl;
                _schedule.remove_job(removed_job); 
                int pos1 = removed_job_id.find("!"); //The checkpoint id is like "resubmit!43-2_62_checkpoint"
                int pos2 = removed_job_id.find("_");
                string temp_job_id = removed_job_id.substr(pos2+1);
                int pos3 = temp_job_id.find("_");
                string failed_job_id_number = removed_job_id.substr(pos1+1,pos2-pos1-1);
                string victim_job_id_number = temp_job_id.substr(0,pos3);
                int failed_job_id_number_find = failed_job_id_number.find("-");
                int victim_job_id_number_find = victim_job_id_number.find("-");

                string failed_job_workload_name;
                if(failed_job_id_number_find==-1)
                {
                    failed_job_workload_name = "w0";
                }
                else
                {
                    failed_job_workload_name = "resubmit"; //If there is a "-" in the job id number, which means it was resubmitted
                }

                string victim_job_workload_name;
                if(victim_job_id_number_find==-1)
                {
                    victim_job_workload_name = "w0";
                }
                else
                {
                    victim_job_workload_name = "resubmit"; //If there is a "-" in the job id number, which means it was resubmitted
                }        

                //////////////////////////////////////////////////////
                //
                //    Step 6 (heuristic 2 or 3). Kill victim job
                //
                //////////////////////////////////////////////////////

                //normal case for the victim job, when checkpoint job completes, we kill the corresponding victim job
                string victim_job_id = victim_job_workload_name + "!" + victim_job_id_number;
                const Job *victim_job_ref = (*_workload)[victim_job_id];
                _decision->add_kill_job({ victim_job_ref->id }, date);

                victim_failed_job_dict.erase(victim_job_id);
                victim_checkpoint_job_dict.erase(victim_job_id);

                ////////////////////////////////////////////////////////////////////////
                //
                //    Step 7 (heuristic 2 or 3). Submit failed job copy with priority 2
                //
                ////////////////////////////////////////////////////////////////////////

                string failed_job_id = failed_job_workload_name + "!" + failed_job_id_number;
                const Job *failed_job_ref = (*_workload)[failed_job_id];
                map<string, double>::iterator it = failed_date.find(failed_job_ref->id);
                if (it != failed_date.end()) {
                    date_fail = it->second;
                }
                submit_job_copy(failed_job_ref, date, 2, _heuristic_choice, date_fail); 

                /////////////////////////////////////////////////////////////////////////
                //
                //    Step 8 (heuristic 2 or 3). Submit victim job copy with priority 1
                //
                /////////////////////////////////////////////////////////////////////////

                submit_job_copy(victim_job_ref, date, 1, _heuristic_choice, date_fail); 
            }
            else
            {
                // cerr<<"removed_job4 "<<removed_job->id<<endl;
                //This is the completion of the normal job (except normal completed checkpoint job and killed checkpoint job)
                // whose priority is 0, 1 and 2, we just remove it from the schedule 
                _schedule.remove_job(removed_job); 
                //cerr<<"remove the normal completed or killed job (except for checkpoint job) from the schedule: "<<removed_job->id<<endl;
            }
        } 
    }

    // for (const string & killed_job_id : _jobs_killed_recently){
    //     cerr<<"killed_job_id "<<killed_job_id<<endl;
    //     _schedule.remove_job((*_workload)[killed_job_id]);
    //     cerr<<"remove killed job "<<killed_job_id<<" sucessfully"<<endl;
    // }
        

    // Let's handle recently released jobs
    std::vector<std::string> recently_queued_jobs;
    bool priority_bool = false; // if job priority is 1 or 2 or 3, we set the priority_bool to true

    // cerr<<"date: "<<date<<" _jobs_released_recently: ";
    // for (vector<string>::iterator it2=_jobs_released_recently.begin(); it2!=_jobs_released_recently.end(); it2++){
    //     cerr<<*it2<<" ";
    // }
    // cerr<<endl;

    for (const string &new_job_id : _jobs_released_recently) 
    {
        // cerr<<"_nb_machines in conservative.cpp "<<_nb_machines<<endl;
        const Job *new_job = (*_workload)[new_job_id];
        // cerr<<"date "<<date<<" new released job "<<new_job_id<<endl;
        // cerr<<"date "<<date<<" new_job->nb_requested_resources "<<new_job->nb_requested_resources<<" _nb_machines "<<_nb_machines<<endl;
        if (new_job->nb_requested_resources > _nb_machines) 
        {
            _decision->add_reject_job(new_job_id, date);
        }
        else if (!new_job->has_walltime)
        {
            LOG_SCOPE_FUNCTION(INFO);
            LOG_F(INFO, "Date=%g. Rejecting job '%s' as it has no walltime", date, new_job_id.c_str());
            _decision->add_reject_job(new_job_id, date);
        }
        else
        {
            _queue->append_job(new_job, update_info);
            // if priority of new_job is = 1 or 2 or 3, then change the boolen to true
            int priority = new_job->priority;
            if (priority == 1 || priority == 2 || priority ==3)
            {
                priority_bool = true; 
            }
            recently_queued_jobs.push_back(new_job_id);
        }
    }

    // cerr<<"date: "<<date<<" recently_queued_jobs: ";
    // for (vector<string>::iterator it1=recently_queued_jobs.begin(); it1!=recently_queued_jobs.end(); it1++){
    //     cerr<<*it1<<" ";
    // }
    // cerr<<endl;

    // Let's update the schedule's present
    _schedule.update_first_slice(date);

    // Queue sorting
    _queue->sort_queue(update_info, compare_info);
    //cerr<<"date "<<date<<" _queue->sort_queue "<<_queue->to_string()<<endl;
    // cerr<<"date: "<<date<<" _queue: "<<_queue->to_string()<<endl;
    // cerr<<"date: "<<date<<" priority_bool: "<<priority_bool<<endl;
    // cerr<<"_machines_that_became_unavailable_recently.is_empty() "<<_machines_that_became_unavailable_recently.is_empty()<<endl;
    // if(!execute_schedule_code){
    //     cerr<<"date "<<date<<" schedule code case 0"<<endl;
    // }


    if (execute_schedule_code){
        if (priority_bool || (_machines_that_became_unavailable_recently.is_empty() == false))
        {
            //cerr<<"date "<<date<<" schedule code case 1"<<endl;
            //If there is a (or more) new job in the recently_queued_jobs whose priority is 1, 2 or 3, 
            //we should remove all jobs from the schedule
            //then schedule jobs in the queue again, since it used the new way to schedule 
            //(job whose priority bigger schedule early)

            // remove all jobs from the schedule
            for (auto job_it = _queue->begin(); job_it != _queue->end(); job_it++)
            {
                const Job *job = (*job_it)->job;
                _schedule.remove_job_if_exists(job);
            }

            // add jobs from queue to the schedule based on the priority of each job
            for (auto job_it = _queue->begin(); job_it != _queue->end(); )
            {
                const Job *new_job = (*job_it)->job;
                //cerr<<"add_job_first_fit before"<<endl;
                string new_job_id = new_job->id;
                // cerr<<"new_job_id "<<new_job_id<<endl;
                // cerr<<"new_job->nb_requested_resources "<<new_job->nb_requested_resources<<endl;
                // cerr<<"_nb_machines "<<_nb_machines<<endl;
                if (new_job->nb_requested_resources > _nb_machines) 
                {
                    // cerr<<"_decision->add_reject_job before"<<endl;
                    // cerr<<"new_job_id "<<new_job_id<<endl;
                    // cerr<<"date "<<date<<endl;              
                    // A currently submitted job may not have enough processors when it schedule in the future 
                    //using the "_shedule.add_job_first_fit" function 
                    //(because of other failures making other processors be unavailable).
                    // Thus, we reject this submitted job and remove it from the queue. 
                    _decision->add_reject_job(new_job_id, date);
                    job_it = _queue->remove_job(job_it);
                    //cerr<<"_queue->to_string() "<<_queue->to_string()<<endl;
                    cerr<<"A previous submitted job copy do not have enough processors when it schedule now"<<endl;
                }
                else{
                    Schedule::JobAlloc alloc = _schedule.add_job_first_fit(new_job, _selector);
                    //cerr<<"add_job_first_fit after"<<endl;
                    // If the job should start now, let's say it to the resource manager
                    if (alloc.started_in_first_slice)
                    {
                        _decision->add_execute_job(new_job->id, alloc.used_machines, date);
                        _starting_time.insert(make_pair(new_job->id, date)); //key is the job id, value is the startng time
                        job_it = _queue->remove_job(job_it);
                    }
                    else
                        ++job_it;
                }
            }
        }
        else
        {
            //If the priority of new job in the recently_queued_jobs are all 0, there are two cases
            //First case, if _jobs_ended_recently is empty (no jobs ended recently), 
            //then just add new job to the schedule from the recently_queued_jobs

            //Second case, if _jobs_ended_recently is not empty 
            //(some jobs ended recently which means some processors become available) 
            //or some processors become available or unavailable, then we should used 
            //the conservative_backfilling heuristic, 
            //remove job from the shedule in the queue and add it to the schedule again 
            //to see if it can be schedule eraly in some holes

            //Here is the first case, If no resources have been released (no jobs ended recently), 
            //then we can just insert the new jobs into the schedule
            // cerr<<"date: "<<date<<endl;
            // cerr<<"_jobs_ended_recently.empty() "<<_jobs_ended_recently.empty()<<endl;
            // cerr<<"_machines_that_became_available_recently.is_empty() "<<_machines_that_became_available_recently.is_empty()<<endl;
            // cerr<<"_machines_that_became_unavailable_recently.is_empty() "<<_machines_that_became_unavailable_recently.is_empty()<<endl;
            
            //if (_jobs_ended_recently.empty())  // no jobs ended recently
            // if (_jobs_ended_recently.empty() && (_machines_that_became_available_recently.is_empty() == true)
            //    && (_machines_that_became_unavailable_recently.is_empty() == true))  // no resources have been released
            if (_jobs_ended_recently.empty() && (_machines_that_became_available_recently.is_empty() == true))  // no resources have been released
            {
                //cerr<<"date "<<date<<" schedule code case 2"<<endl;
                //cerr<<"date: "<<date<<" no resources have been released (no jobs ended and proc become avail)"<<endl;
                for (const string &new_job_id : recently_queued_jobs)
                {
                    const Job *new_job = (*_workload)[new_job_id];
                    //cerr<<"date: "<<date<<" no resources have been released and the recently queued job: "<<new_job_id<<endl;
                    Schedule::JobAlloc alloc = _schedule.add_job_first_fit(new_job, _selector);
                    // If the job should start now, let's say it to the resource manager
                    if (alloc.started_in_first_slice)
                    {
                        _decision->add_execute_job(new_job->id, alloc.used_machines, date);
                        _starting_time.insert(make_pair(new_job->id, date));
                        _queue->remove_job(new_job);
                    }
                }
            }
            //Here is the second case, some resources have been released (some jobs ended recently) 
            //or some processors become available or unavailable, 
            //then we should use the conservative_backfilling rule, 
            //remove job in the queue from the shedule and then add it to 
            //the schedule again to see if it can be scheduled eraly in some "holes"
            //if ((_jobs_ended_recently.empty() == false) || (_machines_that_became_available_recently.is_empty() == false))  
            else
            {
                //cerr<<"date "<<date<<" schedule code case 3"<<endl;
                // Since some resources have been freed,
                // Let's compress the schedule following conservative backfilling rules:
                // For each non running job j
                //   Remove j from the schedule
                //   Add j into the schedule
                //   If j should be executed now
                //   Take the decision to run j now
                //cerr<<"date: "<<date<<" some resources have been released(jobs ended or proc become avail/unavail)"<<endl;
                for (auto job_it = _queue->begin(); job_it != _queue->end();)
                {
                    const Job *job = (*job_it)->job;
                    //cerr<<"date: "<<date<<" some resources have been released, we try the job in the queue: "<<job->id<<endl;
                    _schedule.remove_job_if_exists(job);
                    // if (_dump_provisional_schedules)
                    //_schedule.incremental_dump_as_batsim_jobs_file(_dump_prefix);

                    Schedule::JobAlloc alloc = _schedule.add_job_first_fit(job, _selector);
                    // if (_dump_provisional_schedules)
                    //_schedule.incremental_dump_as_batsim_jobs_file(_dump_prefix);

                    //cerr<<"date: "<<date<<" job id "<<job->id<<" alloc.started_in_first_slice "<<alloc.started_in_first_slice<<endl;

                    if (alloc.started_in_first_slice)
                    {
                        _decision->add_execute_job(job->id, alloc.used_machines, date);
                        _starting_time.insert(make_pair(job->id, date));
                        job_it = _queue->remove_job(job_it);
                    }
                    else
                        ++job_it;
                }
            }
        }



        
    }
    execute_schedule_code = true;


    // And now let's see if we can estimate some waiting times
    for (const std::string &job_id : _jobs_whose_waiting_time_estimation_has_been_requested_recently)
    {
        const Job *new_job = (*_workload)[job_id];
        double answer = _schedule.query_wait(new_job->nb_requested_resources, new_job->walltime, _selector);
        _decision->add_answer_estimate_waiting_time(job_id, answer, date);
    }

    if (_dump_provisional_schedules)
    {
        _schedule.incremental_dump_as_batsim_jobs_file(_dump_prefix);
    }

    //cerr<<"_no_more_external_event_to_occur_received 1"<<endl;
    // Sending the "end of dynamic submissions" to Batsim if needed
    if (_no_more_external_event_to_occur_received == true)
    {
        //cerr<<"_no_more_external_event_to_occur_received 2"<<endl;
        //cerr<<"whether_to_use_node_stealing_true final "<<whether_to_use_node_stealing_true<<endl;
        //cerr<<"whether_to_use_node_stealing_total final "<<whether_to_use_node_stealing_total<<endl;
        double whether_to_use_node_stealing_true_ratio = (double)whether_to_use_node_stealing_true / whether_to_use_node_stealing_total;
        //cerr<<"whether_to_use_node_stealing_true_ratio "<<whether_to_use_node_stealing_true_ratio<<endl;

        //cerr<<"find_victim_job_true final "<<find_victim_job_true<<endl;
        //cerr<<"find_victim_job_total final "<<find_victim_job_total<<endl;
        double find_victim_job_true_ratio = (double)find_victim_job_true / find_victim_job_total;
        //cerr<<"find_victim_job_true_ratio "<<find_victim_job_true_ratio<<endl;

        //cerr<<"kill_decision_true final "<<kill_decision_true<<endl;
        //cerr<<"kill_decision_total final "<<kill_decision_total<<endl;
        double kill_decision_true_ratio = (double)kill_decision_true / kill_decision_total;
        //cerr<<"kill_decision_true_ratio "<<kill_decision_true_ratio<<endl;

        double total_ratio = whether_to_use_node_stealing_true_ratio * find_victim_job_true_ratio * kill_decision_true_ratio;
        
        //ofstream fout("/home/yishu/Desktop/ratios.txt",ios::app);
        //ofstream fout("/home/ydu/YishuDu/node-stealing-for-resilience/tmp/expe-out/ratios.txt",ios::app);

        ofstream fout("./node_stealing_info.txt",ios::app);
        fout << "h111 & "<<whether_to_use_node_stealing_true << " & ";
        fout << whether_to_use_node_stealing_total <<" & ";
        fout << whether_to_use_node_stealing_true_ratio <<" & ";
        fout << find_victim_job_true <<" & ";
        fout << find_victim_job_total <<" & ";
        fout << find_victim_job_true_ratio <<" & ";
        fout << kill_decision_true <<" & ";
        fout << kill_decision_total <<" & ";
        fout << kill_decision_true_ratio<<" & ";
        fout << total_ratio <<" \\\\"<<endl;
        fout.close();

        _decision->add_scheduler_finished_submitting_jobs(date);
    }
    //cerr<<"date: "<<date << " End of make_decisions, now schedule is:" << _schedule.to_string() << endl;

}

void ConservativeBackfillingNodeStealing ::submit_job_copy(const Job *job_ref, double date, int priority, int _heuristic_choice, double date_fail)
{
    double submit_time = date;
    int res = job_ref->nb_requested_resources;
    string profile = "rp-" + job_ref->id; //rp is the abbreviation of "resubmit profile"

    string job_id_contains_workloadname = job_ref->id;
    int pos = job_id_contains_workloadname.find("!");
    string job_id = job_id_contains_workloadname.substr(pos + 1); // Here, job_id is a number, not containing the workloadname

    string job_id_first_character;
    int pos1 = job_id.find("-");
    if (pos1 == -1)
    {
        job_id_first_character = job_id;
    }
    else
    {
        job_id_first_character = job_id.substr(0, pos1);
    }

    string last_job_id; 
    map<string, int>::iterator iter1 = killed_job_times.find(job_id_first_character);
    if (iter1 != killed_job_times.end()) 
    {
        // job_id existed in the keys of the map, we should change it to the new id with the resubmit times plus one
        last_job_id = job_id_first_character + '-' + to_string(iter1->second);
        iter1->second = iter1->second + 1;
        job_id = job_id_first_character + '-' + to_string(iter1->second);
        //cerr<<"iter1->second "<<iter1->second<<endl;
        //cerr<<"last_job_id "<<last_job_id<<endl;
    }
    else // job_id did not exist in the keys of the map, we need to insert the new killed job id
    {
        killed_job_times.insert(make_pair(job_id_first_character, 1));
        job_id = job_id_first_character + '-' + to_string(1);
    }
    //string unique_job_id = workload_name + "!" + job_id; // Here, unique_job_id is the new job copy id (a string), containing the workloadname

    map<string, double>::iterator iter_checkpoint_period_dict = _checkpoint_period_dict->find(job_id_contains_workloadname);
    double checkpoint_period = iter_checkpoint_period_dict->second;

    map<string, double>::iterator iter_checkpoint_cost_dict = _checkpoint_cost_dict->find(job_id_contains_workloadname);
    double checkpoint_cost = iter_checkpoint_cost_dict->second;

    map<string, double>::iterator iter_recovery_cost_dict = _recovery_cost_dict->find(job_id_contains_workloadname);
    double recovery_cost = iter_recovery_cost_dict->second;

    double delay = 0.0;
    double t_useful = 0.0;
    double t_wasted = 0.0;
    double Tfirst = submit_job_Tfirst(job_ref, date_fail, priority, _heuristic_choice);
    double Rfirst = submit_job_Rfirst(job_ref, date_fail, priority, _heuristic_choice);
    // cerr<<"checkpoint_period "<<checkpoint_period<<endl;
    // cerr<<"checkpoint_cost "<<checkpoint_cost<<endl;
    // cerr<<"recovery_cost "<<recovery_cost<<endl;
    // cerr<<"Tfirst "<<Tfirst<<endl;
    // cerr<<"Rfirst "<<Rfirst<<endl;

    Rfirst_dict.insert(make_pair(job_id, Rfirst));
    // for (map<string, double>::iterator it_Rfirst_dict = Rfirst_dict.begin(); it_Rfirst_dict != Rfirst_dict.end(); it_Rfirst_dict++)
    // {
    //     string job_submitted_id = it_Rfirst_dict->first;
    //     double job_submitted_Rfirst = it_Rfirst_dict->second;
    //     cerr<<"job_submitted_id "<<job_submitted_id<<endl;
    //     cerr<<"job_submitted_Rfirst "<<job_submitted_Rfirst<<endl;
    // }

    double Rfirst_last_job = 0.0;
    map<string, double>::iterator iter_Rfirst_dict = Rfirst_dict.find(last_job_id);
    if (iter_Rfirst_dict != Rfirst_dict.end())
    {
        Rfirst_last_job = iter_Rfirst_dict->second;
    }
    
    map<string, double>::iterator iter = _delay_dict->find(job_id_contains_workloadname);
    if (iter != _delay_dict->end())
    {
        t_useful = submit_job_delay(job_ref, date_fail, priority, _heuristic_choice);

        // cerr<<"Rfirst "<<Rfirst<<endl;
        // cerr<<"Rfirst_last_job "<<Rfirst_last_job<<endl;
        // cerr<<"iter->second "<<iter->second<<endl;
        // cerr<<"t_useful "<<t_useful<<endl;

        //fix the bug: if the job copy was submitted firstly, then use the Rfirst function;
        //if the job copy was submitted secondly or thirdly and so on, then Rfirst = 0, 
        //since the delay of job copy has already included the Rfirst in the first submitted time

        //new_delay = Rfirst + old_delay(excluded the Rfirst_last_job) - old_delay;
        delay = Rfirst + (iter->second-Rfirst_last_job) - t_useful; //iter->second is the original delay
        
    }

    //Rational walltime_new = job_ref->walltime - floor(t_useful); 
    Rational original_walltime = (job_ref->walltime-Rfirst_last_job) - 5; // minus 5 because on line 112 in main.cpp, it automatically add 5 to the original walltime  
    //new_walltime = Rfirst + old_walltime - old_delay
    //Rational walltime_new = ceil(Rfirst) + original_walltime - floor(t_useful); 
    double walltime_new = Rfirst + (double)original_walltime - t_useful; 

    //cerr<<"job_id "<<job_id<<" delay "<<delay<<endl;

    int buf_size = 256;
    char *buf_job = new char[buf_size];
    // int nb_chars = snprintf(buf_job, buf_size,
    //     R"foo({"id":"%s", "subtime":%g, "walltime":%g, "res":%d, "profile":"%s", "priority":%d})foo", job_id.c_str(),
    //     submit_time, (double)walltime_new, res, profile.c_str(), priority);
    int nb_chars = snprintf(buf_job, buf_size,
        R"foo({"id":"%s", "subtime":%g, "walltime":%g, "res":%d, "profile":"%s", "priority":%d})foo", job_id.c_str(),
        submit_time, walltime_new, res, profile.c_str(), priority);//priority backup
    PPK_ASSERT_ERROR(nb_chars < buf_size - 1);

    // cerr<<"job_id: "<<job_id<<" submitted Tfirst: "<<Tfirst<<endl;

    char *buf_profile = new char[buf_size];
    nb_chars = snprintf(buf_profile, buf_size,
        R"foo({"type": "delay", "delay": %g, "checkpoint_period": %g, "checkpoint_cost": %g, "recovery_cost": %g,
         "Tfirst": %g, "Rfirst": %g})foo",
        delay, checkpoint_period, checkpoint_cost, recovery_cost, Tfirst, Rfirst);
    PPK_ASSERT_ERROR(nb_chars < buf_size - 1);

    bool already_sent_profile = profiles_already_sent.count(profile) == 1;
    bool send_profile = !already_sent_profile || send_profile_if_already_sent;

    // string workload_name = " ";
    // if (priority==2){
    //     workload_name= "failed";
    // }
    // else if (priority==1)
    // {
    //     workload_name = "victim";
    // }
    // else{
    //     cerr<<"the priority of submitted job copy is neither 1 nor 2"<<endl;
    // }

    string workload_name = "resubmit";

    if (send_profile && send_profiles_in_separate_event)
        _decision->add_submit_profile(workload_name, profile, buf_profile, date);

    _decision->add_submit_job(
        workload_name, job_id, profile, buf_job, buf_profile, date, send_profile && !send_profiles_in_separate_event);

    profiles_already_sent.insert(profile);

    //We assume that the submit failed/victim job copy will comelete successfully and then we compute the usefultime and checkpoint time
    
    double t1 = Rfirst + Tfirst + checkpoint_cost;
    double checkpoint = checkpoint_cost + floor((delay-t1)/(checkpoint_period+checkpoint_cost))*checkpoint_cost;
    double useful_time = delay - Rfirst - checkpoint; //Here, useful_time includes "tail", because we submit it now and do not know if it will fail
    double useful_wholejob = useful_time * res; //Here, res is the job_size
    double checkpoint_wholejob = checkpoint * res;
    double Rfirst_wholejob = Rfirst * res;
    double waste_due_to_failure = 0.0;
    double waste_due_to_node_stealing =0.0;

    // cerr<<"job_id "<<job_id<<endl;
    // cerr<<"Rfirst "<<Rfirst<<endl;
    // cerr<<"Tfirst "<<Tfirst<<endl;
    // cerr<<"checkpoint_cost "<<checkpoint_cost<<endl;
    // cerr<<"delay "<<delay<<endl;
    // cerr<<"checkpoint_period "<<checkpoint_period<<endl;
    // cerr<<"res "<<res<<endl;

    ofstream fout("./COMPLETED_SUCCESSFULLY_JOBCOPY.txt",ios::app);
    fout <<setw(15) << job_id <<setw(15) << priority <<setw(15) << useful_wholejob <<setw(15) << checkpoint_wholejob << setw(15) << waste_due_to_failure << setw(15)<<waste_due_to_node_stealing<<setw(15) <<Rfirst_wholejob <<setw(15) <<Tfirst <<setw(15) <<Rfirst<<endl;
    fout.close();
    
    delete[] buf_job;
    delete[] buf_profile;
}

double ConservativeBackfillingNodeStealing ::submit_job_delay (const Job *job_ref, double date_fail, int priority, int _heuristic_choice)
{
    string job_id_contains_workloadname = job_ref->id;
    int pos = job_id_contains_workloadname.find("!");
    string job_id = job_id_contains_workloadname.substr(pos + 1); // Here, job_id is a number, not containing the workloadname

    map<string, double>::iterator iter_ckp_period = _checkpoint_period_dict->find(job_id_contains_workloadname);
    double T = iter_ckp_period->second;

    map<string, double>::iterator iter_ckp_cost = _checkpoint_cost_dict->find(job_id_contains_workloadname);
    double C = iter_ckp_cost->second;

    map<string, double>::iterator iter_Tfirst = _Tfirst_dict->find(job_id_contains_workloadname);
    double Tfirst = iter_Tfirst->second;

    map<string, double>::iterator iter_Rfirst = _Rfirst_dict->find(job_id_contains_workloadname);
    double Rfirst = iter_Rfirst->second;

    map<string, double>::iterator iter_starting_time = _starting_time.find(job_id_contains_workloadname);
    double t_start = iter_starting_time->second;

    double t_fail = date_fail;
    double delay = 0.0;
    double t1 = 0.0;
    double t2 = 0.0;
    double a = 0.0;
    double useful_time = 0.0;
    double checkpoint = 0.0;
    double proactive_checkpoint = 0.0;
    double future_checkpoint = 0.0;
    double waste_due_to_failure = 0.0;
    double waste_due_to_node_stealing = 0.0;

    if(_heuristic_choice==0){ //no node stealing (no victim jobs), failed job copy using its previous (regular) checkpoint
        if(priority==2){
            t1 = Rfirst + Tfirst + C;
            if (t_fail - t_start <= t1){
                delay = 0;
                useful_time = 0;
                checkpoint = 0;
            }
            else{
                delay = Tfirst + C + floor((t_fail - (t_start+t1))/(T+C)) *(T+C);
                useful_time = Tfirst + floor((t_fail - (t_start+t1))/(T+C)) *T; //Here, useful_time do not include "tail", "tail" is the waste
                checkpoint = C + floor((t_fail - (t_start+t1))/(T+C))*C;
            }
        }
        else
        {
            cerr<<"Something wrong, the priority of submited job copy is not 2."<<endl;
        }
    }
    else if(_heuristic_choice==1){ //victim job copy using its previous checkpoint
        if(priority==2){
            t1 = Rfirst + Tfirst + C;
            if (t_fail - t_start <= t1){
                delay = 0;
                useful_time = 0;
                checkpoint = 0;
            }
            else{
                delay = Tfirst + C + floor((t_fail - (t_start+t1))/(T+C)) *(T+C);
                useful_time = Tfirst + floor((t_fail - (t_start+t1))/(T+C)) *T; //Here, useful_time do not include "tail", "tail" is the waste
                checkpoint = C + floor((t_fail - (t_start+t1))/(T+C))*C;
            }
        }
        else if (priority==1)
        {
            t2 = Rfirst + Tfirst + C;
            if (t_fail - t_start <= t2){
                delay = 0;
                useful_time = 0;
                checkpoint = 0;
            }
            else{
                delay = Tfirst + C + floor((t_fail - (t_start+t2))/(T+C)) *(T+C);
                useful_time = Tfirst + floor((t_fail - (t_start+t2))/(T+C)) *T;
                checkpoint = C + floor((t_fail - (t_start+t2))/(T+C))*C;
            }
        }
        else
        {
            cerr<<"Something wrong, the priority of submited job copy is neither 2 nor 1."<<endl;
        }
    }
    else if (_heuristic_choice==2){ //victim job copy using its proactive checkpoint
        if(priority==2){
            t1 = Rfirst + Tfirst + C;
            if (t_fail - t_start <= t1){
                delay = 0;
                useful_time = 0;
                checkpoint = 0;
            }
            else{
                delay = Tfirst + C + floor((t_fail - (t_start+t1))/(T+C))*(T+C);
                useful_time = Tfirst + floor((t_fail - (t_start+t1))/(T+C))*T; //Here, useful_time do not include "tail", "tail" is the waste
                checkpoint = C + floor((t_fail - (t_start+t1))/(T+C))*C;
            }
        }
        else if (priority==1)
        {
            if (t_fail - t_start <= Rfirst){
                delay = 0;
                useful_time = 0;
                checkpoint = 0;
            }
            else if (t_fail - t_start > Rfirst && t_fail - t_start <= Rfirst+Tfirst){
                delay = t_fail - t_start - Rfirst;
                useful_time = t_fail - t_start - Rfirst;
                checkpoint = 0;
                proactive_checkpoint = C;
            }
            else if (t_fail - t_start > Rfirst+Tfirst && t_fail - t_start <= Rfirst+Tfirst+C){
                //at date_fail, victim job is setting the regular checkpoint, 
                //thus no need to set another new checkpoint, 
                //just continue finishing the current uncompleted regular checkpoint 
                delay = Tfirst+C; 
                useful_time = Tfirst;
                checkpoint = C;
                proactive_checkpoint = 0; //proactive checkpoint is same with regular checkpoint for this case
            }
            else{
                t2 = Rfirst + Tfirst + C;
                a = t_fail - t_start - floor((t_fail - (t_start+t2))/(T+C)) *(T+C) - t2;
                if (a <= T){
                    delay = t_fail - t_start - Rfirst;
                    checkpoint = C + floor((t_fail - (t_start+t2))/(T+C)) *C;
                    useful_time = delay - checkpoint;
                    proactive_checkpoint = C;
                }
                else // T < a <= T+c
                {
                    //at date_fail, victim job is setting the regular checkpoint, 
                    //thus no need to set another new checkpoint, 
                    //just continue finishing the current uncompleted regular checkpoint 
                    delay = Tfirst + C + ceil((t_fail - (t_start+t2))/(T+C)) *(T+C);
                    useful_time = Tfirst + ceil((t_fail - (t_start+t2))/(T+C)) *T;
                    checkpoint = C + ceil((t_fail - (t_start+t2))/(T+C)) *C;
                    proactive_checkpoint = 0; //proactive checkpoint is same with regular checkpoint for this case
                }    
            }
        }
        else
        {
            cerr<<"Something wrong, the priority of submited job copy is neither 2 nor 1."<<endl;
        }
    }
    else if (_heuristic_choice==3){ //victim job copy using its future checkpoint
        if(priority==2){ //failed job
            t1 = Rfirst + Tfirst + C;
            if (t_fail - t_start <= t1){
                delay = 0;
                useful_time = 0;
                checkpoint = 0; 
            }
            else{
                delay = Tfirst + C + floor((t_fail - (t_start+t1))/(T+C)) *(T+C);
                useful_time = Tfirst + floor((t_fail - (t_start+t1))/(T+C))*T; //Here, useful_time do not include "tail", "tail" is the waste
                checkpoint = C + floor((t_fail - (t_start+t1))/(T+C))*C;
            }
        }
        else if (priority==1) //victim job
        {
            t2 = Rfirst + Tfirst + C;
            if (t_fail - t_start < t2){
                delay = Tfirst + C;
                useful_time = 0;
                checkpoint = C;
                future_checkpoint = 0; //future checkpoint is same with regular checkpoint for this case
            }
            else{
                delay = Tfirst + C + ceil((t_fail - (t_start+t2))/(T+C)) *(T+C);
                useful_time = Tfirst + ceil((t_fail - (t_start+t2))/(T+C)) *T;
                checkpoint = C + ceil((t_fail - (t_start+t2))/(T+C)) *C;
                future_checkpoint = 0; //future checkpoint is same with regular checkpoint for this case
            }
        }
        else
        {
            cerr<<"Something wrong, the priority of submit job copy is neither 2 nor 1."<<endl;
        }
    }
    else{
        cerr<<"Something wrong, _heuristic_choice is not 0, 1, 2 and 3" <<endl;
    }

    int job_size = job_ref -> nb_requested_resources;

    double wasted_time = 0.0;
    double Rfirst_wholejob = 0.0;

    if (t_fail - t_start - Rfirst - delay <=0){
        wasted_time = 0; //failure occured in the Rfirst, thus the waste is 0
        Rfirst_wholejob = (t_fail - t_start - delay) * job_size; //and Rfirst_wholejob is just a part of the Rfirst and delay is 0 at this time
    }
    else{
        wasted_time = (t_fail - t_start - Rfirst - delay) * job_size;
        Rfirst_wholejob = Rfirst * job_size;
    }


    //double wasted_time = (t_fail - t_start - Rfirst - delay) * job_size;
    // cerr<<"job_id "<<job_id<<endl;
    // cerr<<"t_fail "<<t_fail<<endl;
    // cerr<<"t_start "<<t_start<<endl;
    // cerr<<"Rfirst "<<Rfirst<<endl;
    // cerr<<"delay "<<delay<<endl;
    // cerr<<"job_size "<<job_size<<endl;
    // cerr<<"wasted_time "<<wasted_time<<endl;

    if (priority==2){
        waste_due_to_failure = wasted_time;
    }
    else if (priority==1){
        if(_heuristic_choice==1){
            waste_due_to_node_stealing = wasted_time;
        }
        else if (_heuristic_choice==2||_heuristic_choice==3){
            waste_due_to_node_stealing = 0;
        }
        else{
            cerr<<"Something wrong, _heuristic_choice is not 1, 2 or 3" <<endl;
        }
    }
    else{
        cerr<<"Something wrong, priority is not 1 or 2" <<endl;
    }

    double useful_wholejob = useful_time * job_size;
    double checkpoint_wholejob = (checkpoint + proactive_checkpoint + future_checkpoint) * job_size;

    ofstream fout("./COMPLETED_KILLED.txt",ios::app); 
    fout <<setw(15) << job_id <<setw(15) << priority <<setw(15) << useful_wholejob <<setw(15) << checkpoint_wholejob << setw(15) << waste_due_to_failure << setw(15)<<waste_due_to_node_stealing<<setw(15) <<Rfirst_wholejob <<setw(15) <<Tfirst <<setw(15) <<Rfirst<<endl;
    fout.close(); 

    return delay;
}


double ConservativeBackfillingNodeStealing ::submit_job_delay_killdecision3 (const Job *job_ref, double date_fail, int priority, int _heuristic_choice)
{
    string job_id_contains_workloadname = job_ref->id;

    map<string, double>::iterator iter_ckp_period = _checkpoint_period_dict->find(job_id_contains_workloadname);
    double T = iter_ckp_period->second;

    map<string, double>::iterator iter_ckp_cost = _checkpoint_cost_dict->find(job_id_contains_workloadname);
    double C = iter_ckp_cost->second;

    map<string, double>::iterator iter_Tfirst = _Tfirst_dict->find(job_id_contains_workloadname);
    double Tfirst = iter_Tfirst->second;

    map<string, double>::iterator iter_Rfirst = _Rfirst_dict->find(job_id_contains_workloadname);
    double Rfirst = iter_Rfirst->second;

    map<string, double>::iterator iter_starting_time = _starting_time.find(job_id_contains_workloadname);
    double t_start = iter_starting_time->second;

    double t_fail = date_fail;
    double delay = 0.0;
    double t1 = 0.0;
    double t2 = 0.0;
    double a = 0.0;

    if(_heuristic_choice==0){ //no node stealing (no victim jobs), failed job copy using its previous (regular) checkpoint
        if(priority==2){
            t1 = Rfirst + Tfirst + C;
            if (t_fail - t_start <= t1){
                delay = 0;
            }
            else{
                delay = Tfirst + C + floor((t_fail - (t_start+t1))/(T+C)) *(T+C);
            }
        }
        else
        {
            cerr<<"Something wrong, the priority of submited job copy is not 2."<<endl;
        }
    }
    else if(_heuristic_choice==1){ //victim job copy using its previous checkpoint
        if(priority==2){
            t1 = Rfirst + Tfirst + C;
            if (t_fail - t_start <= t1){
                delay = 0;
            }
            else{
                delay = Tfirst + C + floor((t_fail - (t_start+t1))/(T+C)) *(T+C);
            }
        }
        else if (priority==1)
        {
            t2 = Rfirst + Tfirst + C;
            if (t_fail - t_start <= t2){
                delay = 0;
            }
            else{
                delay = Tfirst + C + floor((t_fail - (t_start+t2))/(T+C)) *(T+C);
            }
        }
        else
        {
            cerr<<"Something wrong, the priority of submited job copy is neither 2 nor 1."<<endl;
        }
    }
    else if (_heuristic_choice==2){ //victim job copy using its proactive checkpoint
        if(priority==2){
            t1 = Rfirst + Tfirst + C;
            if (t_fail - t_start <= t1){
                delay = 0;
            }
            else{
                delay = Tfirst + C + floor((t_fail - (t_start+t1))/(T+C)) *(T+C);
            }
        }
        else if (priority==1)
        {
            if (t_fail - t_start <= Rfirst){
                delay = 0;
            }
            else if (t_fail - t_start > Rfirst && t_fail - t_start <= Rfirst+Tfirst){
                delay = t_fail - t_start - Rfirst;
            }
            else if (t_fail - t_start > Rfirst+Tfirst && t_fail - t_start <= Rfirst+Tfirst+C){
                //at date_fail, victim job is setting the regular checkpoint, 
                //thus no need to set another new checkpoint, 
                //just continue finishing the current uncompleted regular checkpoint 
                delay = Tfirst+C; 
            }
            else{
                t2 = Rfirst + Tfirst + C;
                a = t_fail - t_start - floor((t_fail - (t_start+t2))/(T+C)) *(T+C) - t2;
                if (a <= T){
                    delay = t_fail - t_start - Rfirst;
                }
                else // T < a <= T+c
                {
                    //at date_fail, victim job is setting the regular checkpoint, 
                    //thus no need to set another new checkpoint, 
                    //just continue finishing the current uncompleted regular checkpoint 
                    delay = Tfirst + C + ceil((t_fail - (t_start+t2))/(T+C)) *(T+C);
                }    
            }
        }
        else
        {
            cerr<<"Something wrong, the priority of submited job copy is neither 2 nor 1."<<endl;
        }
    }
    else if (_heuristic_choice==3){ //victim job copy using its future checkpoint
        if(priority==2){ //failed job
            t1 = Rfirst + Tfirst + C;
            if (t_fail - t_start <= t1){
                delay = 0;
            }
            else{
                delay = Tfirst + C + floor((t_fail - (t_start+t1))/(T+C)) *(T+C);
            }
        }
        else if (priority==1) //victim job
        {
            t2 = Rfirst + Tfirst + C;
            if (t_fail - t_start < t2){
                delay = Tfirst + C;
            }
            else{
                delay = Tfirst + C + ceil((t_fail - (t_start+t2))/(T+C)) *(T+C);
            }
        }
        else
        {
            cerr<<"Something wrong, the priority of submit job copy is neither 2 nor 1."<<endl;
        }
    }
    else{
        cerr<<"Something wrong, _heuristic_choice is not 0, 1, 2 and 3" <<endl;
    }

    return delay;
}

double ConservativeBackfillingNodeStealing ::submit_job_Tfirst(const Job *job_ref, double date_fail, int priority, int _heuristic_choice)
{
    string job_id_contains_workloadname = job_ref->id;

    map<string, double>::iterator iter_ckp_period = _checkpoint_period_dict->find(job_id_contains_workloadname);
    double T = iter_ckp_period->second;

    map<string, double>::iterator iter_ckp_cost = _checkpoint_cost_dict->find(job_id_contains_workloadname);
    double C = iter_ckp_cost->second;

    map<string, double>::iterator iter_Tfirst = _Tfirst_dict->find(job_id_contains_workloadname);
    double Tfirst = iter_Tfirst->second;

    map<string, double>::iterator iter_Rfirst = _Rfirst_dict->find(job_id_contains_workloadname);
    double Rfirst = iter_Rfirst->second;

    map<string, double>::iterator iter_starting_time = _starting_time.find(job_id_contains_workloadname);
    double t_start = iter_starting_time->second;
    
    double t_fail = date_fail;
    double t1 = 0.0;
    double t2 = 0.0;
    double a = 0.0;
    double Tfirst_new = 0.0;

    if (_heuristic_choice==0){ //no node stealing (no victim jobs), failed job copy using its previous (regular) checkpoint
        if(priority==2){
            t1 = Rfirst+Tfirst+C;
            if (t_fail-t_start <= t1){
                Tfirst_new = Tfirst;
            }
            else {
                Tfirst_new = T;
            }
        }
        else
        {
            cerr<<"Something wrong, the priority of submit job copy is not 2."<<endl;
        }
    }
    else if (_heuristic_choice==1){ //victim job copy using its previous checkpoint
        if(priority==2){
            t1 = Rfirst+Tfirst+C;
            if (t_fail-t_start <= t1){
                Tfirst_new = Tfirst;
            }
            else {
                Tfirst_new = T;
            }
        }
        else if (priority==1)
        {
            t2 = Rfirst+Tfirst+C;
            if (t_fail-t_start <= t2){
                Tfirst_new = Tfirst;
            }
            else{
                Tfirst_new = T;
            }
        }
        else
        {
            cerr<<"Something wrong, the priority of submit job copy is neither 2 nor 1."<<endl;
        }
    }
    else if (_heuristic_choice==2){ //victim job copy using its proactive checkpoint
        if(priority==2){
            t1 = Rfirst+Tfirst+C;
            if (t_fail-t_start <= t1){
                Tfirst_new = Tfirst;
            }
            else {
                Tfirst_new = T;
            }
        }
        else if (priority==1)
        {
            if (t_fail-t_start <= Rfirst){
                Tfirst_new = Tfirst;
            }
            else if(t_fail-t_start > Rfirst && t_fail-t_start <= Rfirst+Tfirst){
                Tfirst_new = Tfirst - (t_fail-t_start-Rfirst);
            }
            else if(t_fail-t_start > Rfirst+Tfirst && t_fail-t_start <= Rfirst+Tfirst+C){
                //at date_fail, victim job is setting the regular checkpoint, 
                //thus no need to set another new checkpoint, 
                //just continue finishing the current uncompleted regular checkpoint 
                //thus next Tfirst_new is the regular T
                Tfirst_new = T;
            }
            else{
                t1 = Rfirst + Tfirst + C;
                a = t_fail - t_start - floor((t_fail - (t_start+t1))/(T+C)) *(T+C) - t1;
                if (a <= T){
                    Tfirst_new = T-a;
                }
                else // T < a <= T+c
                {
                    //at date_fail, victim job is setting the regular checkpoint, 
                    //thus no need to set another new checkpoint, 
                    //just continue finishing the current uncompleted regular checkpoint 
                    //thus next Tfirst_new is the regular T
                    Tfirst_new = T;
                }                
            }
        }
        else
        {
            cerr<<"Something wrong, the priority of submit job copy is neither 2 nor 1."<<endl;
        }
    }
    else if (_heuristic_choice==3){ //victim job copy using its future checkpoint
        if(priority==2){
            t1 = Rfirst+Tfirst+C;
            if (t_fail-t_start <= t1){
                Tfirst_new = Tfirst;
            }
            else {
                Tfirst_new = T;
            }
        }
        else if (priority==1)
        {
            Tfirst_new = T;
        }
        else
        {
            cerr<<"Something wrong, the priority of submit job copy is neither 2 nor 1."<<endl;
        }
    }
    else{
        cerr<<"Something wrong, _heuristic_choice is not 1, 2 and 3" <<endl;
    }

    return Tfirst_new;
}



double ConservativeBackfillingNodeStealing ::submit_job_Rfirst(const Job *job_ref, double date_fail, int priority, int _heuristic_choice)
{
    string job_id_contains_workloadname = job_ref->id;

    map<string, double>::iterator iter_ckp_cost = _checkpoint_cost_dict->find(job_id_contains_workloadname);
    double C = iter_ckp_cost->second;

    map<string, double>::iterator iter_rec_cost = _recovery_cost_dict->find(job_id_contains_workloadname);
    double R = iter_rec_cost->second;

    map<string, double>::iterator iter_Tfirst = _Tfirst_dict->find(job_id_contains_workloadname);
    double Tfirst = iter_Tfirst->second;

    map<string, double>::iterator iter_Rfirst = _Rfirst_dict->find(job_id_contains_workloadname);
    double Rfirst = iter_Rfirst->second;

    map<string, double>::iterator iter_starting_time = _starting_time.find(job_id_contains_workloadname);
    double t_start = iter_starting_time->second;

    double t_fail = date_fail;
    double t1 = 0.0;
    double Rfirst_new = 0.0;

    if (_heuristic_choice==0){ //no node stealing (no victim jobs), failed job copy using its previous (regular) checkpoint
        if(priority==2){
            t1 = Rfirst+Tfirst+C;
            if (t_fail-t_start <= t1){
                Rfirst_new = Rfirst;
            }
            else {
                Rfirst_new = R;
            }
        }
        else
        {
            cerr<<"Something wrong, the priority of submit job copy is not 2."<<endl;
        }
    }
    else if (_heuristic_choice==1){ //victim job copy using its previous checkpoint
        if(priority==2){
            t1 = Rfirst+Tfirst+C;
            if (t_fail-t_start <= t1){
                Rfirst_new = Rfirst;
            }
            else {
                Rfirst_new = R;
            }
        }
        else if (priority==1)
        {
            if (t_fail-t_start <= Rfirst+Tfirst+C){ 
                Rfirst_new = Rfirst;
            }
            else {
                Rfirst_new = R;
            }
        }
        else
        {
            cerr<<"Something wrong, the priority of submit job copy is neither 2 nor 1."<<endl;
        }
    }
    else if (_heuristic_choice==2){ //victim job copy using its proactive checkpoint
        if(priority==2){
            t1 = Rfirst+Tfirst+C;
            if (t_fail-t_start <= t1){
                Rfirst_new = Rfirst;
            }
            else {
                Rfirst_new = R;
            }
        }
        else if (priority==1)
        {
            Rfirst_new = R; 
        }
        else
        {
            cerr<<"Something wrong, the priority of submit job copy is neither 2 nor 1."<<endl;
        }
    }
    else if (_heuristic_choice==3){ //victim job copy using its future checkpoint
        if(priority==2){
            t1 = Rfirst+Tfirst+C;
            if (t_fail-t_start <= t1){
                Rfirst_new = Rfirst;
            }
            else {
                Rfirst_new = R;
            }
        }
        else if (priority==1)
        {
            Rfirst_new = R;
        }
        else
        {
            cerr<<"Something wrong, the priority of submit job copy is neither 2 nor 1."<<endl;
        }
    }
    else{
        cerr<<"Something wrong, _heuristic_choice is neither 2 nor 3" <<endl;
    }

    return Rfirst_new;
}


string ConservativeBackfillingNodeStealing ::submit_job_checkpoint(const Job *job_ref1, const Job *job_ref2, double date, int priority, int _heuristic_choice)
{
    string workload_name = "resubmit";
    double submit_time = date; 
    int res = job_ref1->nb_requested_resources-1;
    
    int buf_size = 256;
    string job_id_failed_contains_workloadname = job_ref1->id;
    int pos_failed = job_id_failed_contains_workloadname.find("!");
    string job_id_failed = job_id_failed_contains_workloadname.substr(pos_failed + 1); // Here, job_id is a number, not containing the workloadname

    string job_id_victim_contains_workloadname = job_ref2->id;
    int pos_victim = job_id_victim_contains_workloadname.find("!");
    string job_id_victim = job_id_victim_contains_workloadname.substr(pos_victim + 1); // Here, job_id is a number, not containing the workloadname

    string job_id = job_id_failed + "_" + job_id_victim + "_checkpoint";
    string profile = "rp-"+job_id;

    double delay = 0.0;
    double t_fail = date;
    
    if (_heuristic_choice==2){
        string job_id_contains_workloadname = job_ref2->id; //victim job id

        map<string, double>::iterator iter_ckp_period = _checkpoint_period_dict->find(job_id_contains_workloadname);
        double T = iter_ckp_period->second;

        map<string, double>::iterator iter_ckp_cost = _checkpoint_cost_dict->find(job_id_contains_workloadname);
        double C = iter_ckp_cost->second;

        map<string, double>::iterator iter_Tfirst = _Tfirst_dict->find(job_id_contains_workloadname);
        double Tfirst = iter_Tfirst->second;

        map<string, double>::iterator iter_Rfirst = _Rfirst_dict->find(job_id_contains_workloadname);
        double Rfirst = iter_Rfirst->second;

        map<string, double>::iterator iter_starting_time = _starting_time.find(job_id_contains_workloadname);
        double t_start = iter_starting_time->second;

        double t2 = 0.0;
        double a = 0.0;

        if (t_fail - t_start <= Rfirst){
            //at date_fail, victim job is setting the Rfirst, 
            //thus no need to set another new checkpoint, see previous checkpoint as proactive checkpoint
            //just kill victim job and resubmit failed job copy and victim job copy
            //delay of the proactive checkpoint job should be 0
            delay = 0.1; 
        }
        else if(t_fail - t_start > Rfirst && t_fail - t_start <= Rfirst+Tfirst){
            delay = C;
        }
        else if(t_fail - t_start > Rfirst+Tfirst && t_fail - t_start <= Rfirst+Tfirst+C){
            //at date_fail, victim job is setting the regular checkpoint, 
            //thus no need to set another new checkpoint, 
            //just continue finishing the current uncompleted regular checkpoint 
            delay = C - (t_fail - t_start - Rfirst - Tfirst); 
        }
        else{
            t2 = Rfirst + Tfirst + C;
            a = t_fail - t_start - floor((t_fail - (t_start+t2))/(T+C)) *(T+C) - t2;
            if (a <= T){
                delay = C;
            }
            else // T < a <= T+c
            {
                //at date_fail, victim job is setting the regular checkpoint, 
                //thus no need to set another new checkpoint, 
                //just continue finishing the current uncompleted regular checkpoint 
                delay = T + C - a; 
            }  
        }
    }
    else if (_heuristic_choice==3){
        string job_id_contains_workloadname = job_ref2->id; //victim job id

        map<string, double>::iterator iter_ckp_period = _checkpoint_period_dict->find(job_id_contains_workloadname);
        double T = iter_ckp_period->second;

        map<string, double>::iterator iter_ckp_cost = _checkpoint_cost_dict->find(job_id_contains_workloadname);
        double C = iter_ckp_cost->second;

        map<string, double>::iterator iter_Tfirst = _Tfirst_dict->find(job_id_contains_workloadname);
        double Tfirst = iter_Tfirst->second;

        map<string, double>::iterator iter_Rfirst = _Rfirst_dict->find(job_id_contains_workloadname);
        double Rfirst = iter_Rfirst->second;

        map<string, double>::iterator iter_starting_time = _starting_time.find(job_id_contains_workloadname);
        double t_start = iter_starting_time->second;
        
        double t2 = Rfirst + Tfirst +C;
    
        if (t_fail - t_start <= Rfirst + Tfirst +C){
            delay = t2 - (t_fail - t_start);
        }
        else{
            delay = ceil((t_fail - (t_start+t2))/(T+C)) * (T+C) + t2 - (t_fail-t_start);
        }
    }
    else{
        cerr<<"Something wrong, _victim choice is neither 2 nor 3"<<endl;
    }

    //walltime += 15 minutes, we assume that the walltime of checkpoint job is its delay plus 900 seconds
    //Rational walltime_new = ceil(delay) + 900;
    double walltime_new = delay + 900;
    
    char *buf_job = new char[buf_size];
    // int nb_chars = snprintf(buf_job, buf_size,
    //     R"foo({"id":"%s", "subtime":%g, "walltime":%g, "res":%d, "profile":"%s", "priority":%d})foo", job_id.c_str(),
    //     submit_time, (double)walltime_new, res, profile.c_str(), priority);
    int nb_chars = snprintf(buf_job, buf_size,
        R"foo({"id":"%s", "subtime":%g, "walltime":%g, "res":%d, "profile":"%s", "priority":%d})foo", job_id.c_str(),
        submit_time, walltime_new, res, profile.c_str(), priority);
    PPK_ASSERT_ERROR(nb_chars < buf_size - 1);

    map<string, double>::iterator iter_checkpoint_period_dict = _checkpoint_period_dict->find(job_id_victim_contains_workloadname);
    double checkpoint_period = iter_checkpoint_period_dict->second;

    map<string, double>::iterator iter_checkpoint_cost_dict = _checkpoint_cost_dict->find(job_id_victim_contains_workloadname);
    double checkpoint_cost = iter_checkpoint_cost_dict->second;

    map<string, double>::iterator iter_recovery_cost_dict = _recovery_cost_dict->find(job_id_victim_contains_workloadname);
    double recovery_cost = iter_recovery_cost_dict->second;

    char *buf_profile = new char[buf_size];
    nb_chars = snprintf(buf_profile, buf_size,
        R"foo({"type": "delay", "delay": %g, "checkpoint_period": %g, "checkpoint_cost": %g, "recovery_cost": %g,
         "Tfirst": %g, "Rfirst": %g})foo",
        delay, checkpoint_period, checkpoint_cost, recovery_cost, checkpoint_period, 0.0);
    PPK_ASSERT_ERROR(nb_chars < buf_size - 1);

    bool already_sent_profile = profiles_already_sent.count(profile) == 1;
    bool send_profile = !already_sent_profile || send_profile_if_already_sent;

    if (send_profile && send_profiles_in_separate_event)
        _decision->add_submit_profile(workload_name, profile, buf_profile, date);

    _decision->add_submit_job(
        workload_name, job_id, profile, buf_job, buf_profile, date, send_profile && !send_profiles_in_separate_event);

    profiles_already_sent.insert(profile);

    string job_id_contains_workload_name = workload_name + "!" + job_id;

    checkpoint_delay.insert(make_pair(job_id_contains_workload_name, delay));

    delete[] buf_job;
    delete[] buf_profile;

    return job_id_contains_workload_name;
}

string ConservativeBackfillingNodeStealing ::submit_job_checkpoint_new(const Job *job_ref_old_checkpoint, double date, int priority)
{
    string workload_name = "resubmit";
    double submit_time = date; 
    string old_checkpoint_job_id = job_ref_old_checkpoint->id;
    // cerr<<"old_checkpoint_job_id "<<old_checkpoint_job_id<<endl;

    int pos1 = old_checkpoint_job_id.find("!");
    int pos2 = old_checkpoint_job_id.find_last_of("t");
    // cerr<<"pos1 "<<pos1<<endl;
    // cerr<<"pos2 "<<pos2<<endl;
    string old_checkpoint_job_id_number = old_checkpoint_job_id.substr(pos1+1,pos2-pos1);
    // cerr<<"old_checkpoint_job_id_number "<<old_checkpoint_job_id_number<<endl;

    //string old_checkpoint_job_id; 
    string job_id;
    map<string, int>::iterator iter1 = killed_checkpoint_job_times.find(old_checkpoint_job_id_number);
    if (iter1 != killed_checkpoint_job_times.end()) 
    {
        // job_id existed in the keys of the map, we should change it to the new id with the resubmit times plus one
        //old_checkpoint_job_id = old_checkpoint_job_id_number + '-' + to_string(iter1->second);
        iter1->second = iter1->second + 1;
        // cerr<<"iter1->second "<<iter1->second<<endl;
        job_id = old_checkpoint_job_id_number + '-' + to_string(iter1->second);
        //cerr<<"iter1->second "<<iter1->second<<endl;
        //cerr<<"last_job_id "<<last_job_id<<endl;
    }
    else // checkpoint job_id did not exist in the keys of the map, we need to insert the new killed checkpoint job id
    {
        //old_checkpoint_job_id = old_checkpoint_job_id_number;
        killed_checkpoint_job_times.insert(make_pair(old_checkpoint_job_id_number, 1));
        job_id = old_checkpoint_job_id_number + '-' + to_string(1);
    }

    // for(auto it = killed_checkpoint_job_times.begin(); it!=killed_checkpoint_job_times.end(); it++)
    // {
    //     cerr<<"it->first "<<it->first<<endl;
    //     cerr<<"it->second "<<it->second<<endl;
    // }


    // cerr<<"current checkpoint id "<<job_id<<endl;
    //string job_id = old_checkpoint_job_>id_number + "_new";

    double old_delay = 0.0;
    map<string, double>::iterator it_checkpoint_delay = checkpoint_delay.find(old_checkpoint_job_id);
    if (it_checkpoint_delay != checkpoint_delay.end()){
        old_delay = it_checkpoint_delay->second;
    }

    map<string, double>::iterator iter_starting_time = _starting_time.find(old_checkpoint_job_id);
    double delay_executed = date - iter_starting_time->second;
    double delay = old_delay - delay_executed;

    int res = job_ref_old_checkpoint->nb_requested_resources - 1;
    string profile = "rp-"+job_id;

    Rational walltime_old = job_ref_old_checkpoint->walltime - 5; //minus 5 because on line 112 in main.cpp, it automatically add 5 to the original walltime
    //Rational walltime_new = walltime_old - floor(delay_executed); 
    double walltime_new = (double)walltime_old - delay_executed; 
    
    int buf_size = 256;
    char *buf_job = new char[buf_size];
    // int nb_chars = snprintf(buf_job, buf_size,
    //     R"foo({"id":"%s", "subtime":%g, "walltime":%g, "res":%d, "profile":"%s", "priority":%d})foo", job_id.c_str(),
    //     submit_time, (double)walltime_new, res, profile.c_str(), priority);
    int nb_chars = snprintf(buf_job, buf_size,
        R"foo({"id":"%s", "subtime":%g, "walltime":%g, "res":%d, "profile":"%s", "priority":%d})foo", job_id.c_str(),
        submit_time, walltime_new, res, profile.c_str(), priority);
    PPK_ASSERT_ERROR(nb_chars < buf_size - 1);

    char *buf_profile = new char[buf_size];

    map<string, double>::iterator iter_checkpoint_period_dict = _checkpoint_period_dict->find(old_checkpoint_job_id);
    double checkpoint_period = iter_checkpoint_period_dict->second;

    map<string, double>::iterator iter_checkpoint_cost_dict = _checkpoint_cost_dict->find(old_checkpoint_job_id);
    double checkpoint_cost = iter_checkpoint_cost_dict->second;

    map<string, double>::iterator iter_recovery_cost_dict = _recovery_cost_dict->find(old_checkpoint_job_id);
    double recovery_cost = iter_recovery_cost_dict->second;

    nb_chars = snprintf(buf_profile, buf_size,
        R"foo({"type": "delay", "delay": %g, "checkpoint_period": %g, "checkpoint_cost": %g, "recovery_cost": %g,
         "Tfirst": %g, "Rfirst": %g})foo",
        delay, checkpoint_period, checkpoint_cost, recovery_cost, checkpoint_period, 0.0);
    PPK_ASSERT_ERROR(nb_chars < buf_size - 1);

    bool already_sent_profile = profiles_already_sent.count(profile) == 1;
    bool send_profile = !already_sent_profile || send_profile_if_already_sent;

    if (send_profile && send_profiles_in_separate_event)
        _decision->add_submit_profile(workload_name, profile, buf_profile, date);

    _decision->add_submit_job(
        workload_name, job_id, profile, buf_job, buf_profile, date, send_profile && !send_profiles_in_separate_event);

    profiles_already_sent.insert(profile);

    string job_id_contains_workload_name = workload_name + "!" + job_id;

    checkpoint_delay.insert(make_pair(job_id_contains_workload_name, delay));

    delete[] buf_job;
    delete[] buf_profile;

    return job_id_contains_workload_name;
}
