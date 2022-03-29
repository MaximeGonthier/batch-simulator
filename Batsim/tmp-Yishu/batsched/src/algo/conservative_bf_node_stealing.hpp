#pragma once

#include <list>
#include <vector>
#include <set>
#include <map>

#include "../isalgorithm.hpp"
#include "../json_workload.hpp"
#include "../locality.hpp"
#include "../schedule.hpp"

class ConservativeBackfillingNodeStealing : public ISchedulingAlgorithm
{

public:
    ConservativeBackfillingNodeStealing (Workload * workload, SchedulingDecision * decision, Queue * queue, ResourceSelector * selector,
                            double rjms_delay, rapidjson::Document * variant_options, 
                            std::map<std::string,double> * delay_dict, 
                            std::map<std::string,double> * checkpoint_period_dict, 
                            std::map<std::string,double> * checkpoint_cost_dict, 
                            std::map<std::string,double> * recovery_cost_dict, 
                            std::map<std::string,double> * Tfirst_dict, 
                            std::map<std::string,double> * Rfirst_dict);
    virtual ~ConservativeBackfillingNodeStealing ();

    virtual void on_simulation_start(double date, const rapidjson::Value & batsim_config);

    virtual void on_simulation_end(double date);

    virtual void make_decisions(double date,
                                SortableJobOrder::UpdateInformation * update_info,
                                SortableJobOrder::CompareInformation * compare_info);

    virtual void on_machine_available_notify_event(double date, IntervalSet machines);

    virtual void on_machine_unavailable_notify_event(double date, IntervalSet machines);
    
    void submit_job_copy(const Job *job_ref, double date, int priority, int _heuristic_choice, double date_fail); //submit_job_copy after killing the job

    std::string submit_job_checkpoint(const Job *job_ref1, const Job *job_ref2, double date, int priority, int _heuristic_choice);

    std::string submit_job_checkpoint_new(const Job *job_ref_old_checkpoint, double date, int priority);
    
    double submit_job_delay (const Job *job_ref, double date_fail, int priority, int _heuristic_choice);

    double submit_job_delay_killdecision3 (const Job *job_ref, double date_fail, int priority, int _heuristic_choice);

    double submit_job_Tfirst (const Job *job_ref, double date_fail, int priority, int _heuristic_choice);

    double submit_job_Rfirst (const Job *job_ref, double date_fail, int priority, int _heuristic_choice);

private:
    Schedule _schedule;
    bool _dump_provisional_schedules = false;
    std::string _dump_prefix = "/tmp/dump";

    std::map<std::string,double> *_delay_dict;             //key is job_id, value is delay
    std::map<std::string,double> *_checkpoint_period_dict; //key is job_id, value is the checkpoint period
    std::map<std::string,double> *_checkpoint_cost_dict;   //key is job_id, value is the checkpoint cost
    std::map<std::string,double> *_recovery_cost_dict;     //key is job_id, value is the recovery cost
    std::map<std::string,double> *_Tfirst_dict;            //key is job_id, value is the first checkpoint period
    std::map<std::string,double> *_Rfirst_dict;            //key is job_id, value is the first recovery cost

    std::map<std::string,double> _starting_time;  //key is job_id, value is the starting time of each job
    std::map<std::string,int> killed_job_times;   //key is the killed job id, value is how many times it killed
    std::map<std::string,double> checkpoint_delay;//key is checkpoint_job_id, value is the corresponding delay
    std::map<std::string,double> failed_date;     //key is failed_job_id, value is the corresponding failed date
    std::map<std::string,int> killed_checkpoint_job_times;   //key is the killed checkpoint job id, value is how many times it killed


    std::map<std::string,double> Rfirst_dict;     //key is submitted job copy id, value is the corresponding Rfirst
    
    int _victim_choice = 0;
    int _heuristic_choice = 0;
    int _decision_choice = 0;
    double date_fail = 0;
    bool send_profile_if_already_sent = false;   //whether already transmitted profiles should be sent again to Batsim or not
    bool send_profiles_in_separate_event = true; //whether profiles should be sent in a separate message or not
    std::set<std::string> profiles_already_sent;

    std::set<std::string> killed_checkpoint_job; //because of some reason, the checkpoint job was killed not completed normally, thus we need exclude them when we test the job whose prority is 3

    std::set<std::string> jobs_not_selected_as_victim;
    bool kill_desicion_MF = true; //For decision choice 3, kill decision based on if the kill decision really minimize Max Flow or not
    bool kill_normal_failed_job = true; //if we need to execute "kill the normal failed job" or not, since if the failed job is checkpoint job or victim job, we do the heuristic based on some other rules
    bool find_victim_job_successfully = false; //For victim choice 1 or 2, if we find the victim job successfully or not based on the victim choice rules
    bool find_victim_job_bool = false; //if execute the step "find the victim job" or not, for heuristic 1, always true; for heuristic 2 or 3, it is true only when the number of processors of failed job is greater than 1
    bool execute_schedule_code = true;

    std::string killed_checkpoint_job_id1;
    std::string killed_checkpoint_job_id2;
    std::string killed_checkpoint_job_id3;
    std::string killed_checkpoint_job_id4;
    std::string killed_checkpoint_job_id5;

    //Only for heuristic 2 and 3, add two data strutures to record the relationship between victim job, failed job and checkpoint job
    std::map<std::string,std::string> victim_failed_job_dict;     //key is the victim job id, value is the failed job id
    std::map<std::string,std::string> victim_checkpoint_job_dict; //key is the victim job id, value is the checkpoint job id   

    // std::set<std::string> _jobs_released_recently_backup;

    int whether_to_use_node_stealing_true = 0;
    int whether_to_use_node_stealing_total = 0;

    int find_victim_job_true = 0;
    int find_victim_job_total = 0;

    int kill_decision_true = 0;
    int kill_decision_total = 0;
};
