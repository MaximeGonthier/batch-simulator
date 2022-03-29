#include <stdio.h>
#include <vector>
#include <fstream>
#include <set>
#include <map>

#include<algorithm>
#include <cmath>

#include <boost/program_options.hpp>
#include <boost/algorithm/string.hpp>
#include <boost/format.hpp>

#include <rapidjson/document.h>

#include <loguru.hpp>

#include "external/taywee_args.hpp"

#include "isalgorithm.hpp"
#include "decision.hpp"
#include "network.hpp"
#include "json_workload.hpp"
#include "pempek_assert.hpp"
#include "data_storage.hpp"

#include "algo/conservative_bf.hpp"
#include "algo/conservative_bf_node_stealing.hpp"
#include "algo/crasher.hpp"
#include "algo/easy_bf.hpp"
#include "algo/easy_bf_fast.hpp"
#include "algo/easy_bf_plot_liquid_load_horizon.hpp"
#include "algo/energy_bf.hpp"
#include "algo/energy_bf_dicho.hpp"
#include "algo/energy_bf_idle_sleeper.hpp"
#include "algo/energy_bf_monitoring_period.hpp"
#include "algo/energy_bf_monitoring_inertial_shutdown.hpp"
#include "algo/energy_bf_machine_subpart_sleeper.hpp"
#include "algo/energy_watcher.hpp"
#include "algo/filler.hpp"
#include "algo/fcfs.hpp"
#include "algo/fcfs_fast.hpp"
#include "algo/killer.hpp"
#include "algo/killer2.hpp"
#include "algo/random.hpp"
#include "algo/rejecter.hpp"
#include "algo/sleeper.hpp"
#include "algo/sequencer.hpp"
#include "algo/submitter.hpp"
#include "algo/wt_estimator.hpp"

using namespace std;
using namespace boost;

namespace n = network;
namespace r = rapidjson;

void run(Network & n, ISchedulingAlgorithm * algo, SchedulingDecision &d,
         Workload &workload, string scheduling_variant, std::map<std::string,double>&delay_dict, 
         std::map<std::string,double>&checkpoint_period_dict, std::map<std::string,double>&checkpoint_cost_dict, 
         std::map<std::string,double>&recovery_cost_dict, std::map<std::string,double>&Tfirst_dict, 
         std::map<std::string,double>&Rfirst_dict, bool call_make_decisions_on_single_nop = true);




/** @def STR_HELPER(x)
 *  @brief Helper macro to retrieve the string view of a macro.
 */
#define STR_HELPER(x) #x

/** @def STR(x)
 *  @brief Macro to get a const char* from a macro
 */
#define STR(x) STR_HELPER(x)

/** @def BATSCHED_VERSION
 *  @brief What batsched --version should return.
 *
 *  It is either set by CMake or set to vUNKNOWN_PLEASE_COMPILE_VIA_CMAKE
**/
#ifndef BATSCHED_VERSION
    #define BATSCHED_VERSION vUNKNOWN_PLEASE_COMPILE_VIA_CMAKE
#endif

int main(int argc, char ** argv)
{
    const set<string> variants_set = {"conservative_bf", "conservative_bf_node_stealing", "crasher", "easy_bf", "easy_bf_fast",
                                      "easy_bf_plot_liquid_load_horizon",
                                      "energy_bf", "energy_bf_dicho", "energy_bf_idle_sleeper",
                                      "energy_bf_monitoring",
                                      "energy_bf_monitoring_inertial", "energy_bf_subpart_sleeper",
                                      "energy_watcher", "fcfs", "fcfs_fast",
                                      "filler", "killer", "killer2", "random", "rejecter",
                                      "sequencer", "sleeper", "submitter", "waiting_time_estimator"};
    const set<string> policies_set = {"basic", "contiguous"};
    const set<string> queue_orders_set = {"fcfs", "fcfs_prio", "lcfs", "desc_bounded_slowdown", "desc_slowdown",
                                          "asc_size", "desc_size", "asc_walltime", "desc_walltime"};
    const set<string> verbosity_levels_set = {"debug", "info", "quiet", "silent"};

    const string variants_string = "{" + boost::algorithm::join(variants_set, ", ") + "}";
    const string policies_string = "{" + boost::algorithm::join(policies_set, ", ") + "}";
    const string queue_orders_string = "{" + boost::algorithm::join(queue_orders_set, ", ") + "}";
    const string verbosity_levels_string = "{" + boost::algorithm::join(verbosity_levels_set, ", ") + "}";

    ISchedulingAlgorithm * algo = nullptr;
    ResourceSelector * selector = nullptr;
    Queue * queue = nullptr;
    SortableJobOrder * order = nullptr;

    args::ArgumentParser parser("A Batsim-compatible scheduler in C++.");
    args::HelpFlag flag_help(parser, "help", "Display this help menu", {'h', "help"});
    args::CompletionFlag completion(parser, {"complete"});

    args::ValueFlag<double> flag_rjms_delay(parser, "delay", "Sets the expected time that the RJMS takes to do some things like killing a job", {'d', "rjms_delay"}, 5.0);//walltime+5
    args::ValueFlag<string> flag_selection_policy(parser, "policy", "Sets the resource selection policy. Available values are " + policies_string, {'p', "policy"}, "basic");
    args::ValueFlag<string> flag_socket_endpoint(parser, "endpoint", "Sets the socket endpoint.", {'s', "socket-endpoint"}, "tcp://*:28000");
    args::ValueFlag<string> flag_scheduling_variant(parser, "variant", "Sets the scheduling variant. Available values are " + variants_string, {'v', "variant"}, "filler");
    args::ValueFlag<string> flag_variant_options(parser, "options", "Sets the scheduling variant options. Must be formatted as a JSON object.", {"variant_options"}, "{}");
    args::ValueFlag<string> flag_variant_options_filepath(parser, "options-filepath", "Sets the scheduling variant options as the content of the given filepath. Overrides the variant_options options.", {"variant_options_filepath"}, "");
    args::ValueFlag<string> flag_queue_order(parser, "order", "Sets the queue order. Available values are " + queue_orders_string, {'o', "queue_order"}, "fcfs");
    args::ValueFlag<string> flag_verbosity_level(parser, "verbosity-level", "Sets the verbosity level. Available values are " + verbosity_levels_string, {"verbosity"}, "info");
    args::ValueFlag<bool> flag_call_make_decisions_on_single_nop(parser, "flag", "If set to true, make_decisions will be called after single NOP messages.", {"call_make_decisions_on_single_nop"}, true);
    args::Flag flag_version(parser, "version", "Shows batsched version", {"version"});
    
    //cerr << "modified batsched test\n";
    try
    {
        parser.ParseCLI(argc, argv);

        if (flag_rjms_delay.Get() < 0)
            throw args::ValidationError(str(format("Invalid '%1%' parameter value (%2%): Must be non-negative.")
                                            % flag_rjms_delay.Name()
                                            % flag_rjms_delay.Get()));

        if (queue_orders_set.find(flag_queue_order.Get()) == queue_orders_set.end())
            throw args::ValidationError(str(format("Invalid '%1%' value (%2%): Not in %3%")
                                            % flag_queue_order.Name()
                                            % flag_queue_order.Get()
                                            % queue_orders_string));

        if (variants_set.find(flag_scheduling_variant.Get()) == variants_set.end())
            throw args::ValidationError(str(format("Invalid '%1%' value (%2%): Not in %3%")
                                            % flag_scheduling_variant.Name()
                                            % flag_scheduling_variant.Get()
                                            % variants_string));

        if (verbosity_levels_set.find(flag_verbosity_level.Get()) == verbosity_levels_set.end())
            throw args::ValidationError(str(format("Invalid '%1%' value (%2%): Not in %3%")
                                            % flag_verbosity_level.Name()
                                            % flag_verbosity_level.Get()
                                            % verbosity_levels_string));
    }
    catch(args::Help&)
    {
        parser.helpParams.addDefault = true;
        printf("%s", parser.Help().c_str());
        return 0;
    }
    catch (args::Completion & e)
    {
        printf("%s", e.what());
        return 0;
    }
    catch(args::ParseError & e)
    {
        printf("%s\n", e.what());
        return 1;
    }
    catch(args::ValidationError & e)
    {
        printf("%s\n", e.what());
        return 1;
    }

    if (flag_version)
    {
        printf("%s\n", STR(BATSCHED_VERSION));
        return 0;
    }

    string socket_endpoint = flag_socket_endpoint.Get();
    string scheduling_variant = flag_scheduling_variant.Get();
    string selection_policy = flag_selection_policy.Get();
    string queue_order = flag_queue_order.Get();
    string variant_options = flag_variant_options.Get();
    string variant_options_filepath = flag_variant_options_filepath.Get();
    string verbosity_level = flag_verbosity_level.Get();
    double rjms_delay = flag_rjms_delay.Get();
    bool call_make_decisions_on_single_nop = flag_call_make_decisions_on_single_nop.Get();

    try
    {
        // Logging configuration
        if (verbosity_level == "debug")
            loguru::g_stderr_verbosity = loguru::Verbosity_1;
        else if (verbosity_level == "quiet")
            loguru::g_stderr_verbosity = loguru::Verbosity_WARNING;
        else if (verbosity_level == "silent")
            loguru::g_stderr_verbosity = loguru::Verbosity_OFF;
        else
            loguru::g_stderr_verbosity = loguru::Verbosity_INFO;

        // Workload creation
        Workload w;
        w.set_rjms_delay(rjms_delay);

        map<string,double> delay_dict; // new map

        map<string,double> checkpoint_period_dict;

        map<string,double> checkpoint_cost_dict;

        map<string,double> recovery_cost_dict;

        map<string,double> Tfirst_dict;

        map<string,double> Rfirst_dict;

        // Scheduling parameters
        SchedulingDecision decision;

        // Queue order
        if (queue_order == "fcfs")
            order = new FCFSOrder; 
        else if (queue_order == "fcfs_prio") 
            order = new FCFSPrioOrder;
        else if (queue_order == "lcfs")
            order = new LCFSOrder;
        else if (queue_order == "desc_bounded_slowdown")
            order = new DescendingBoundedSlowdownOrder(1);
        else if (queue_order == "desc_slowdown")
            order = new DescendingSlowdownOrder;
        else if (queue_order == "asc_size")
            order = new AscendingSizeOrder;
        else if (queue_order == "desc_size")
            order = new DescendingSizeOrder;
        else if (queue_order == "asc_walltime")
            order = new AscendingWalltimeOrder;
        else if (queue_order == "desc_walltime")
            order = new DescendingWalltimeOrder;

        queue = new Queue(order);


        // Resource selector
        if (selection_policy == "basic")
            selector = new BasicResourceSelector;
        else if (selection_policy == "contiguous")
            selector = new ContiguousResourceSelector;
        else
        {
            printf("Invalid resource selection policy '%s'. Available options are %s\n", selection_policy.c_str(), policies_string.c_str());
            return 1;
        }

        // Scheduling variant options
        if (!variant_options_filepath.empty())
        {
            ifstream variants_options_file(variant_options_filepath);

            if (variants_options_file.is_open())
            {
                // Let's put the whole file content into one string
                variants_options_file.seekg(0, ios::end);
                variant_options.reserve(variants_options_file.tellg());
                variants_options_file.seekg(0, ios::beg);

                variant_options.assign((std::istreambuf_iterator<char>(variants_options_file)),
                                        std::istreambuf_iterator<char>());
            }
            else
            {
                printf("Couldn't open variants options file '%s'. Aborting.\n", variant_options_filepath.c_str());
                return 1;
            }
        }

        rapidjson::Document json_doc_variant_options;
        json_doc_variant_options.Parse(variant_options.c_str());
        if (!json_doc_variant_options.IsObject())
        {
            printf("Invalid variant options: Not a JSON object. variant_options='%s'\n", variant_options.c_str());
            return 1;
        }
        LOG_F(1, "variant_options = '%s'", variant_options.c_str());
        //cerr << "variant_options =" << variant_options.c_str()<< endl;
        
        //Scheduling variant
        if (scheduling_variant == "filler")
            algo = new Filler(&w, &decision, queue, selector, rjms_delay, &json_doc_variant_options);
        else if (scheduling_variant == "conservative_bf")
            algo = new ConservativeBackfilling(&w, &decision, queue, selector, rjms_delay, &json_doc_variant_options);      
        else if (scheduling_variant == "conservative_bf_node_stealing")
            algo = new ConservativeBackfillingNodeStealing(&w, &decision, queue, selector, rjms_delay, 
            &json_doc_variant_options, &delay_dict, 
            &checkpoint_period_dict, &checkpoint_cost_dict, &recovery_cost_dict, &Tfirst_dict, &Rfirst_dict);
        else if (scheduling_variant == "crasher")
            algo = new Crasher(&w, &decision, queue, selector, rjms_delay, &json_doc_variant_options);
        else if (scheduling_variant == "easy_bf")
            algo = new EasyBackfilling(&w, &decision, queue, selector, rjms_delay, &json_doc_variant_options);
        else if (scheduling_variant == "easy_bf_fast")
            algo = new EasyBackfillingFast(&w, &decision, queue, selector, rjms_delay, &json_doc_variant_options);
        else if (scheduling_variant == "easy_bf_plot_liquid_load_horizon")
            algo = new EasyBackfillingPlotLiquidLoadHorizon(&w, &decision, queue, selector, rjms_delay, &json_doc_variant_options);
        else if (scheduling_variant == "energy_bf")
            algo = new EnergyBackfilling(&w, &decision, queue, selector, rjms_delay, &json_doc_variant_options);
        else if (scheduling_variant == "energy_bf_dicho")
            algo = new EnergyBackfillingDichotomy(&w, &decision, queue, selector, rjms_delay, &json_doc_variant_options);
        else if (scheduling_variant == "energy_bf_idle_sleeper")
            algo = new EnergyBackfillingIdleSleeper(&w, &decision, queue, selector, rjms_delay, &json_doc_variant_options);
        else if (scheduling_variant == "energy_bf_monitoring")
            algo = new EnergyBackfillingMonitoringPeriod(&w, &decision, queue, selector, rjms_delay, &json_doc_variant_options);
        else if (scheduling_variant == "energy_bf_monitoring_inertial")
            algo = new EnergyBackfillingMonitoringInertialShutdown(&w, &decision, queue, selector, rjms_delay, &json_doc_variant_options);
        else if (scheduling_variant == "energy_bf_subpart_sleeper")
            algo = new EnergyBackfillingMachineSubpartSleeper(&w, &decision, queue, selector, rjms_delay, &json_doc_variant_options);
        else if (scheduling_variant == "energy_watcher")
            algo = new EnergyWatcher(&w, &decision, queue, selector, rjms_delay, &json_doc_variant_options);
        else if (scheduling_variant == "fcfs")
            algo = new FCFS(&w, &decision, queue, selector, rjms_delay, &json_doc_variant_options);
        else if (scheduling_variant == "fcfs_fast")
            algo = new FCFSFast(&w, &decision, queue, selector, rjms_delay, &json_doc_variant_options);
        else if (scheduling_variant == "killer")
            algo = new Killer(&w, &decision, queue, selector, rjms_delay, &json_doc_variant_options);
        else if (scheduling_variant == "killer2")
            algo = new Killer2(&w, &decision, queue, selector, rjms_delay, &json_doc_variant_options);
        else if (scheduling_variant == "random")
            algo = new Random(&w, &decision, queue, selector, rjms_delay, &json_doc_variant_options);
        else if (scheduling_variant == "rejecter")
            algo = new Rejecter(&w, &decision, queue, selector, rjms_delay, &json_doc_variant_options);
        else if (scheduling_variant == "sequencer")
            algo = new Sequencer(&w, &decision, queue, selector, rjms_delay, &json_doc_variant_options);
        else if (scheduling_variant == "sleeper")
            algo = new Sleeper(&w, &decision, queue, selector, rjms_delay, &json_doc_variant_options);
        else if (scheduling_variant == "submitter")
            algo = new Submitter(&w, &decision, queue, selector, rjms_delay, &json_doc_variant_options);
        else if (scheduling_variant == "waiting_time_estimator")
            algo = new WaitingTimeEstimator(&w, &decision, queue, selector, rjms_delay, &json_doc_variant_options);

        // Network
        Network n;
        n.bind(socket_endpoint);

        // Run the simulation
        run(n, algo, decision, w, scheduling_variant, delay_dict, checkpoint_period_dict, 
        checkpoint_cost_dict, recovery_cost_dict, Tfirst_dict, Rfirst_dict, call_make_decisions_on_single_nop);
    }
    catch(const std::exception & e)
    {
        string what = e.what();

        if (what == "Connection lost")
        {
            LOG_F(ERROR, "%s", what.c_str());
        }
        else
        {
            LOG_F(ERROR, "%s", what.c_str());

            delete queue;
            delete order;

            delete algo;
            delete selector;

            throw;
        }
    }

    delete queue;
    delete order;

    delete algo;
    delete selector;

    return 0;
    //return scheduling_variant;
}

void run(Network & n, ISchedulingAlgorithm * algo, SchedulingDecision & d,
         Workload & workload, string scheduling_variant, std::map<std::string,double>&delay_dict, 
         std::map<std::string,double>&checkpoint_period_dict, std::map<std::string,double>&checkpoint_cost_dict, 
         std::map<std::string,double>&recovery_cost_dict, std::map<std::string,double>&Tfirst_dict, 
         std::map<std::string,double>&Rfirst_dict, bool call_make_decisions_on_single_nop)
{
    //cerr<<"scheduling_variant: "<<scheduling_variant<<endl;
    
    bool simulation_finished = false;

    // Redis creation
    RedisStorage redis;
    bool redis_enabled = false;
    algo->set_redis(&redis);

    while (!simulation_finished)
    {
        string received_message;
        n.read(received_message);

        if (boost::trim_copy(received_message).empty())
            throw runtime_error("Empty message received (connection lost ?)");

        d.clear();

        r::Document doc;
        doc.Parse(received_message.c_str());

        double message_date = doc["now"].GetDouble();
        double current_date = message_date;
        bool requested_callback_received = false;

        // Let's handle all received events
        const r::Value & events_array = doc["events"];

        //double failure_rate=0.0;

        for (unsigned int event_i = 0; event_i < events_array.Size(); ++event_i)
        {
            const r::Value & event_object = events_array[event_i];
            const std::string event_type = event_object["type"].GetString();
            current_date = event_object["timestamp"].GetDouble();
            const r::Value & event_data = event_object["data"];

            if (event_type == "SIMULATION_BEGINS")
            {
                //failure_rate = event_data["failure_rate"].GetDouble();
                //cerr<<"failure_rate1 "<<failure_rate<<endl;

                int nb_resources;
                // DO this for retrocompatibility with batsim 2 API
                if (event_data.HasMember("nb_compute_resources"))
                {
                    nb_resources = event_data["nb_compute_resources"].GetInt();
                }
                else
                {
                    nb_resources = event_data["nb_resources"].GetInt();
                }
                redis_enabled = event_data["config"]["redis-enabled"].GetBool();

                if (redis_enabled)
                {
                    string redis_hostname = event_data["config"]["redis-hostname"].GetString();
                    int redis_port = event_data["config"]["redis-port"].GetInt();
                    string redis_prefix = event_data["config"]["redis-prefix"].GetString();

                    redis.connect_to_server(redis_hostname, redis_port, nullptr);
                    redis.set_instance_key_prefix(redis_prefix);
                }

                d.set_redis(redis_enabled, &redis);

                algo->set_nb_machines(nb_resources);
                algo->on_simulation_start(current_date, event_data["config"]);
            }
            else if (event_type == "SIMULATION_ENDS")
            {
                algo->on_simulation_end(current_date);
                simulation_finished = true;
            }
            else if (event_type == "JOB_SUBMITTED")
            {
                //cerr<<endl;
                //cerr<<"After the batsched gets the JOB_SUBMITTED event, the new job information is: "<<endl;

                string job_id = event_data["job_id"].GetString();
                // cerr<<"job_id "<<job_id<<endl;

                if(scheduling_variant == "conservative_bf_node_stealing")
                {
                    string profile_name = event_data["job"]["profile"].GetString();

                    double delay_job_submitted = event_data["profile"]["delay"].GetDouble();

                    double checkpoint_cost = event_data["profile"]["checkpoint_cost"].GetDouble();


                    // cerr<<"checkpoint_cost_old "<<checkpoint_cost_old<<endl;
                    // double checkpoint_cost = 0.1 * delay_job_submitted;
                    // cerr<<"checkpoint_cost "<<checkpoint_cost<<endl;

                    int res = event_data["job"]["res"].GetInt();

                    // cerr<<"res "<<res<<endl;

                    //int res = min(pow(3.0,2),64);
                    // double res_new1 = log(res)/log(2);
                    // int res_new2 = ceil (res_new1);
                    // int res_new3 = pow(2,res_new2);
                    // int res_new4 = min(res_new3,64);

                    // cerr<<"res_new1 "<<res_new1<<endl;
                    // cerr<<"res_new2 "<<res_new2<<endl;
                    // cerr<<"res_new3 "<<res_new3<<endl;
                    // cerr<<"res_new4 "<<res_new4<<endl;

                    // double lambda = event_data["lambda"].GetDouble();
                    // cerr<<"lambda "<<lambda<<endl;
                    // int _heuristic_choice = (*variant_options)["heuristic_choice"].GetInt();
                    // cerr<<"_heuristic_choice: "<<_heuristic_choice<<endl;

                    double checkpoint_period = 0.0;
                    double Tfirst = 0.0;
                    int pos1 = job_id.find("-");
                    if (pos1 == -1)
                    {
                        //This job is submmited from the original json file, need to calculate checkpoint period and Tfirst
                        //cerr<<"failure_rate2 "<<failure_rate<<endl;
                        //checkpoint_period = sqrt((2*checkpoint_cost)/(0.1*res)); //0.1*res 2.46*0.0000001 1*0.00001 5*0.000000001 1.55*0.00001 0.00001 5*0.000001  6*0.000001 failure rate = 6*10^(-6) for single node
                        double total_failure_rate = event_data["profile"]["total_failure_rate"].GetDouble();
                        //checkpoint_period = sqrt((2*checkpoint_cost)/(total_failure_rate/1e8*res));
                         checkpoint_period = sqrt((2*checkpoint_cost)/(0.1*res));
                        Tfirst = checkpoint_period;
                        // cerr<<"total_failure_rate "<<total_failure_rate<<endl;
                        // cerr<<"checkpoint_cost "<<checkpoint_cost<<endl;
                        // cerr<<"res "<<res<<endl;
                        // cerr<<"checkpoint_period1 "<<checkpoint_period<<endl;
                        // cerr<<"Tfirst1 "<<checkpoint_period<<endl;
                    }
                    else
                    {
                        //This job is resubmmited copy from the conservative_bf_node_stealing.cpp, use the computed data in .cpp as checkpoint period and Tfirst
                        checkpoint_period = event_data["profile"]["checkpoint_period"].GetDouble();
                        Tfirst = event_data["profile"]["Tfirst"].GetDouble();
                        // cerr<<"checkpoint_period2 "<<checkpoint_period<<endl;
                        // cerr<<"Tfirst2 "<<checkpoint_period<<endl;
                    }

                    // double checkpoint_period_check = event_data["profile"]["checkpoint_period"].GetDouble();
                    // cerr<<"checkpoint_period_check "<<checkpoint_period_check<<endl;

                    // double Tfirst_check = event_data["profile"]["Tfirst"].GetDouble();
                    // cerr<<"Tfirst_check "<<Tfirst_check<<endl;


                    double recovery_cost = event_data["profile"]["recovery_cost"].GetDouble();
                    // cerr<<"recovery_cost_old "<<recovery_cost_old<<endl;
                    // double recovery_cost = checkpoint_cost;
                    // cerr<<"recovery_cost "<<recovery_cost<<endl;
                    

                    double Rfirst = event_data["profile"]["Rfirst"].GetDouble();
                    // cerr<<"Rfirst_old "<<Rfirst_old<<endl;
                    // double Rfirst = recovery_cost;
                    // cerr<<"Rfirst "<<Rfirst<<endl;

                    int priority = event_data["job"]["priority"].GetInt();

                    // cerr<<"profile_name: "<<profile_name<<"  job_id: "<<job_id<<"  delay: "<<delay_job_submitted<<endl;

                    // cerr<<"checkpoint_period: "<<checkpoint_period<<"  checkpoint_cost: "<<checkpoint_cost<<"  recovery_cost: "
                    // <<recovery_cost<<"  Tfirst: "<<Tfirst<<"  Rfirst: "<<Rfirst<<" priority: "<<priority<<endl;

                    //map<string,double> delay_dict;

                    delay_dict.insert(make_pair(job_id, delay_job_submitted));

                    checkpoint_period_dict.insert(make_pair(job_id, checkpoint_period));

                    checkpoint_cost_dict.insert(make_pair(job_id, checkpoint_cost));

                    recovery_cost_dict.insert(make_pair(job_id, recovery_cost));

                    Tfirst_dict.insert(make_pair(job_id, Tfirst));

                    Rfirst_dict.insert(make_pair(job_id, Rfirst));

                    // cerr<<"In main.cpp, keys and values in the delay_dict: " <<endl;
                    // for (map<string, double>::iterator it = delay_dict.begin(); it != delay_dict.end(); it++)
                    // {
                    //     cerr << "job_id= " << it->first << " delay= " << it->second << endl;
                    // }
                    // cerr << endl;

                    // cerr<<"In main.cpp, keys and values in the checkpoint_period_dict: " <<endl;
                    // for (map<string, double>::iterator it1 = checkpoint_period_dict.begin(); it1 != checkpoint_period_dict.end(); it1++)
                    // {
                    //     cerr << "job_id= " << it1->first << " checkpoint_period= " << it1->second << endl;
                    // }
                    // cerr << endl;

                    // cerr<<"In main.cpp, keys and values in the checkpoint_cost_dict: " <<endl;
                    // for (map<string, double>::iterator it2 = checkpoint_cost_dict.begin(); it2 != checkpoint_cost_dict.end(); it2++)
                    // {
                    //     cerr << "job_id= " << it2->first << " checkpoint_cost= " << it2->second << endl;
                    // }
                    // cerr << endl;

                    // cerr<<"In main.cpp, keys and values in the recovery_cost_dict: " <<endl;
                    // for (map<string, double>::iterator it3 = recovery_cost_dict.begin(); it3 != recovery_cost_dict.end(); it3++)
                    // {
                    //     cerr << "job_id= " << it3->first << " recovery_cost= " << it3->second << endl;
                    // }
                    // cerr << endl;

                    // cerr<<"In main.cpp, keys and values in the Tfirst_dict: " <<endl;
                    // for (map<string, double>::iterator it4 = Tfirst_dict.begin(); it4 != Tfirst_dict.end(); it4++)
                    // {
                    //     cerr << "job_id= " << it4->first << " Tfirst= " << it4->second << endl;
                    // }
                    // cerr << endl;

                    // cerr<<"In main.cpp, keys and values in the Rfirst_dict: " <<endl;
                    // for (map<string, double>::iterator it5 = Rfirst_dict.begin(); it5 != Rfirst_dict.end(); it5++)
                    // {
                    //     cerr << "job_id= " << it5->first << " Rfirst= " << it5->second << endl;
                    // }
                    // cerr << endl;
                }

                


                if (redis_enabled)
                    workload.add_job_from_redis(redis, job_id, current_date);
                else
                    workload.add_job_from_json_object(event_data["job"], job_id, current_date);

                algo->on_job_release(current_date, {job_id});
            }
            else if (event_type == "JOB_COMPLETED")
            {
                string job_id = event_data["job_id"].GetString();
                workload[job_id]->completion_time = current_date;
                algo->on_job_end(current_date, {job_id});
            }
            else if (event_type == "RESOURCE_STATE_CHANGED")
            {
                IntervalSet resources = IntervalSet::from_string_hyphen(event_data["resources"].GetString(), " ");
                string new_state = event_data["state"].GetString();
                algo->on_machine_state_changed(current_date, resources, std::stoi(new_state));
            }
            else if (event_type == "JOB_KILLED")
            {
                const r::Value & job_ids_map = event_data["job_progress"];
                PPK_ASSERT_ERROR(job_ids_map.GetType() == r::kObjectType);

                vector<string> job_ids;

                for (auto itr = job_ids_map.MemberBegin(); itr != job_ids_map.MemberEnd(); ++itr)
                {
                    string job_id = itr->name.GetString();
                    job_ids.push_back(job_id);
                }

                algo->on_job_killed(current_date, job_ids);
            }
            else if (event_type == "REQUESTED_CALL")
            {
                requested_callback_received = true;
                algo->on_requested_call(current_date);
            }
            else if (event_type == "ANSWER")
            {
                for (auto itr = event_data.MemberBegin(); itr != event_data.MemberEnd(); ++itr)
                {
                    string key_value = itr->name.GetString();

                    if (key_value == "consumed_energy")
                    {
                        double consumed_joules = itr->value.GetDouble();
                        algo->on_answer_energy_consumption(current_date, consumed_joules);
                    }
                    else
                    {
                        PPK_ASSERT_ERROR(false, "Unknown ANSWER type received '%s'", key_value.c_str());
                    }
                }
            }
            else if (event_type == "QUERY")
            {
                const r::Value & requests = event_data["requests"];

                for (auto itr = requests.MemberBegin(); itr != requests.MemberEnd(); ++itr)
                {
                    string key_value = itr->name.GetString();

                    if (key_value == "estimate_waiting_time")
                    {
                        const r::Value & request_object = itr->value;
                        string job_id = request_object["job_id"].GetString();
                        workload.add_job_from_json_object(request_object["job"], job_id, current_date);

                        algo->on_query_estimate_waiting_time(current_date, job_id);
                    }
                    else
                    {
                        PPK_ASSERT_ERROR(false, "Unknown QUERY type received '%s'", key_value.c_str());
                    }
                }
            }
            else if (event_type == "NOTIFY")
            {
                string notify_type = event_data["type"].GetString();

                if (notify_type == "no_more_static_job_to_submit")
                {
                    algo->on_no_more_static_job_to_submit_received(current_date);
                }
                else if (notify_type == "no_more_external_event_to_occur")
                {
                    algo->on_no_more_external_event_to_occur(current_date);//new
                }
                else if (notify_type == "event_machine_available")
                {
                    IntervalSet resources = IntervalSet::from_string_hyphen(event_data["resources"].GetString(), " ");
                    algo->on_machine_available_notify_event(current_date, resources);
                }
                else if (notify_type == "event_machine_unavailable")
                {
                    IntervalSet resources = IntervalSet::from_string_hyphen(event_data["resources"].GetString(), " ");
                    algo->on_machine_unavailable_notify_event(current_date, resources);
                }
                else
                {
                    throw runtime_error("Unknown NOTIFY type received. Type = " + notify_type);
                }

            }
            else
            {
                throw runtime_error("Unknown event received. Type = " + event_type);
            }
        }

        bool requested_callback_only = requested_callback_received && (events_array.Size() == 1);

        // make_decisions is not called if (!call_make_decisions_on_single_nop && single_nop_received)
        if (!(!call_make_decisions_on_single_nop && requested_callback_only))
        {
            SortableJobOrder::UpdateInformation update_info(current_date);
            //cerr<<"main.cpp: algo->make_decisions"<<endl;
            algo->make_decisions(message_date, &update_info, nullptr);
            algo->clear_recent_data_structures();
        }

        message_date = max(message_date, d.last_date());

        const string & message_to_send = d.content(message_date);
        n.write(message_to_send);
    }
}
