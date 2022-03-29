#!/usr/bin/bash

### generate yaml files of heuristic h111 for June 2017

for e in {0..4}
do
    mkdir test_MIRA_2017June_MTBF1h_downtime1h_${e}_0
    cd test_MIRA_2017June_MTBF1h_downtime1h_${e}_0

    # no node stealing, simple chechpoints
    robin generate "test_MIRA_2017June_MTBF1h_downtime1h_${e}_0.yaml" \
    --output-dir "log_${e}_0" \
    --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2017June_MTBF1h.json -e log_${e}_0/expe_${e}_0 --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF1h_downtime1h_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_0" \
    --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":0\,\\\"victim_choice\\\":1\,\\\"decision_choice\\\":1} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_0" 

    cd ..
    
    # all 18 node stealing heuristics
    for h in 1
    do
        for v in 1
        do
            for k in 1
            do
                mkdir test_MIRA_2017June_MTBF1h_downtime1h_${e}_$h$v$k
                cd test_MIRA_2017June_MTBF1h_downtime1h_${e}_$h$v$k

                robin generate "test_MIRA_2017June_MTBF1h_downtime1h_${e}_$h$v$k.yaml" \
                --output-dir "log_${e}_$h$v$k" \
                --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2017June_MTBF1h.json -e log_${e}_$h$v$k/expe_${e}_$h$v$k --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF1h_downtime1h_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_$h$v$k" \
                --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":$h\,\\\"victim_choice\\\":$v\,\\\"decision_choice\\\":$k} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_$h$v$k" 
            
                cd ..
            done
        done
    done 
done



#~ for e in {0..4}
#~ do
    #~ mkdir test_MIRA_2017June_MTBF2h_downtime1h_${e}_0
    #~ cd test_MIRA_2017June_MTBF2h_downtime1h_${e}_0

    #~ # no node stealing, simple chechpoints
    #~ robin generate "test_MIRA_2017June_MTBF2h_downtime1h_${e}_0.yaml" \
    #~ --output-dir "log_${e}_0" \
    #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2017June_MTBF2h.json -e log_${e}_0/expe_${e}_0 --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF2h_downtime1h_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_0" \
    #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":0\,\\\"victim_choice\\\":1\,\\\"decision_choice\\\":1} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_0" 

    #~ cd ..
    
    #~ # all 18 node stealing heuristics
    #~ for h in 1
    #~ do
        #~ for v in 1
        #~ do
            #~ for k in 1
            #~ do
                #~ mkdir test_MIRA_2017June_MTBF2h_downtime1h_${e}_$h$v$k
                #~ cd test_MIRA_2017June_MTBF2h_downtime1h_${e}_$h$v$k

                #~ robin generate "test_MIRA_2017June_MTBF2h_downtime1h_${e}_$h$v$k.yaml" \
                #~ --output-dir "log_${e}_$h$v$k" \
                #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2017June_MTBF2h.json -e log_${e}_$h$v$k/expe_${e}_$h$v$k --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF2h_downtime1h_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_$h$v$k" \
                #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":$h\,\\\"victim_choice\\\":$v\,\\\"decision_choice\\\":$k} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_$h$v$k" 
            
                #~ cd ..
            #~ done
        #~ done
    #~ done 
#~ done



#~ for e in {0..4}
#~ do
    #~ mkdir test_MIRA_2017June_MTBF5h_downtime1h_${e}_0
    #~ cd test_MIRA_2017June_MTBF5h_downtime1h_${e}_0

    #~ # no node stealing, simple chechpoints
    #~ robin generate "test_MIRA_2017June_MTBF5h_downtime1h_${e}_0.yaml" \
    #~ --output-dir "log_${e}_0" \
    #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2017June_MTBF5h.json -e log_${e}_0/expe_${e}_0 --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF5h_downtime1h_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_0" \
    #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":0\,\\\"victim_choice\\\":1\,\\\"decision_choice\\\":1} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_0" 

    #~ cd ..
    
    #~ # all 18 node stealing heuristics
    #~ for h in 1
    #~ do
        #~ for v in 1
        #~ do
            #~ for k in 1
            #~ do
                #~ mkdir test_MIRA_2017June_MTBF5h_downtime1h_${e}_$h$v$k
                #~ cd test_MIRA_2017June_MTBF5h_downtime1h_${e}_$h$v$k

                #~ robin generate "test_MIRA_2017June_MTBF5h_downtime1h_${e}_$h$v$k.yaml" \
                #~ --output-dir "log_${e}_$h$v$k" \
                #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2017June_MTBF5h.json -e log_${e}_$h$v$k/expe_${e}_$h$v$k --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF5h_downtime1h_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_$h$v$k" \
                #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":$h\,\\\"victim_choice\\\":$v\,\\\"decision_choice\\\":$k} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_$h$v$k" 
            
                #~ cd ..
            #~ done
        #~ done
    #~ done 
#~ done



#~ for e in {0..4}
#~ do
    #~ mkdir test_MIRA_2017June_MTBF10h_downtime1h_${e}_0
    #~ cd test_MIRA_2017June_MTBF10h_downtime1h_${e}_0

    #~ # no node stealing, simple chechpoints
    #~ robin generate "test_MIRA_2017June_MTBF10h_downtime1h_${e}_0.yaml" \
    #~ --output-dir "log_${e}_0" \
    #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2017June_MTBF10h.json -e log_${e}_0/expe_${e}_0 --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF10h_downtime1h_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_0" \
    #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":0\,\\\"victim_choice\\\":1\,\\\"decision_choice\\\":1} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_0" 

    #~ cd ..
    
    #~ # all 18 node stealing heuristics
    #~ for h in 1
    #~ do
        #~ for v in 1
        #~ do
            #~ for k in 1
            #~ do
                #~ mkdir test_MIRA_2017June_MTBF10h_downtime1h_${e}_$h$v$k
                #~ cd test_MIRA_2017June_MTBF10h_downtime1h_${e}_$h$v$k

                #~ robin generate "test_MIRA_2017June_MTBF10h_downtime1h_${e}_$h$v$k.yaml" \
                #~ --output-dir "log_${e}_$h$v$k" \
                #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2017June_MTBF10h.json -e log_${e}_$h$v$k/expe_${e}_$h$v$k --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF10h_downtime1h_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_$h$v$k" \
                #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":$h\,\\\"victim_choice\\\":$v\,\\\"decision_choice\\\":$k} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_$h$v$k" 
            
                #~ cd ..
            #~ done
        #~ done
    #~ done 
#~ done



#~ for e in {0..4}
#~ do
    #~ mkdir test_MIRA_2017June_MTBF40min_downtime1h_${e}_0
    #~ cd test_MIRA_2017June_MTBF40min_downtime1h_${e}_0

    #~ # no node stealing, simple chechpoints
    #~ robin generate "test_MIRA_2017June_MTBF40min_downtime1h_${e}_0.yaml" \
    #~ --output-dir "log_${e}_0" \
    #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2017June_MTBF40min.json -e log_${e}_0/expe_${e}_0 --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF40min_downtime1h_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_0" \
    #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":0\,\\\"victim_choice\\\":1\,\\\"decision_choice\\\":1} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_0" 

    #~ cd ..
    
    #~ # all 18 node stealing heuristics
    #~ for h in 1
    #~ do
        #~ for v in 1
        #~ do
            #~ for k in 1
            #~ do
                #~ mkdir test_MIRA_2017June_MTBF40min_downtime1h_${e}_$h$v$k
                #~ cd test_MIRA_2017June_MTBF40min_downtime1h_${e}_$h$v$k

                #~ robin generate "test_MIRA_2017June_MTBF40min_downtime1h_${e}_$h$v$k.yaml" \
                #~ --output-dir "log_${e}_$h$v$k" \
                #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2017June_MTBF40min.json -e log_${e}_$h$v$k/expe_${e}_$h$v$k --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF40min_downtime1h_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_$h$v$k" \
                #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":$h\,\\\"victim_choice\\\":$v\,\\\"decision_choice\\\":$k} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_$h$v$k" 
            
                #~ cd ..
            #~ done
        #~ done
    #~ done 
#~ done



#~ for e in {0..4}
#~ do
    #~ mkdir test_MIRA_2017June_MTBF20min_downtime1h_${e}_0
    #~ cd test_MIRA_2017June_MTBF20min_downtime1h_${e}_0

    #~ # no node stealing, simple chechpoints
    #~ robin generate "test_MIRA_2017June_MTBF20min_downtime1h_${e}_0.yaml" \
    #~ --output-dir "log_${e}_0" \
    #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2017June_MTBF20min.json -e log_${e}_0/expe_${e}_0 --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF20min_downtime1h_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_0" \
    #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":0\,\\\"victim_choice\\\":1\,\\\"decision_choice\\\":1} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_0" 

    #~ cd ..
    
    #~ # all 18 node stealing heuristics
    #~ for h in 1
    #~ do
        #~ for v in 1
        #~ do
            #~ for k in 1
            #~ do
                #~ mkdir test_MIRA_2017June_MTBF20min_downtime1h_${e}_$h$v$k
                #~ cd test_MIRA_2017June_MTBF20min_downtime1h_${e}_$h$v$k

                #~ robin generate "test_MIRA_2017June_MTBF20min_downtime1h_${e}_$h$v$k.yaml" \
                #~ --output-dir "log_${e}_$h$v$k" \
                #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2017June_MTBF20min.json -e log_${e}_$h$v$k/expe_${e}_$h$v$k --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF20min_downtime1h_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_$h$v$k" \
                #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":$h\,\\\"victim_choice\\\":$v\,\\\"decision_choice\\\":$k} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_$h$v$k" 
            
                #~ cd ..
            #~ done
        #~ done
    #~ done 
#~ done



#~ for e in {0..4}
#~ do
    #~ mkdir test_MIRA_2017June_MTBF1h_downtime10min_${e}_0
    #~ cd test_MIRA_2017June_MTBF1h_downtime10min_${e}_0

    #~ # no node stealing, simple chechpoints
    #~ robin generate "test_MIRA_2017June_MTBF1h_downtime10min_${e}_0.yaml" \
    #~ --output-dir "log_${e}_0" \
    #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2017June_MTBF1h.json -e log_${e}_0/expe_${e}_0 --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF1h_downtime10min_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_0" \
    #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":0\,\\\"victim_choice\\\":1\,\\\"decision_choice\\\":1} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_0" 

    #~ cd ..
    
    #~ # all 18 node stealing heuristics
    #~ for h in 1
    #~ do
        #~ for v in 1
        #~ do
            #~ for k in 1
            #~ do
                #~ mkdir test_MIRA_2017June_MTBF1h_downtime10min_${e}_$h$v$k
                #~ cd test_MIRA_2017June_MTBF1h_downtime10min_${e}_$h$v$k

                #~ robin generate "test_MIRA_2017June_MTBF1h_downtime10min_${e}_$h$v$k.yaml" \
                #~ --output-dir "log_${e}_$h$v$k" \
                #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2017June_MTBF1h.json -e log_${e}_$h$v$k/expe_${e}_$h$v$k --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF1h_downtime10min_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_$h$v$k" \
                #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":$h\,\\\"victim_choice\\\":$v\,\\\"decision_choice\\\":$k} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_$h$v$k" 
            
                #~ cd ..
            #~ done
        #~ done
    #~ done 
#~ done



#~ for e in {0..4}
#~ do
    #~ mkdir test_MIRA_2017June_MTBF2h_downtime10min_${e}_0
    #~ cd test_MIRA_2017June_MTBF2h_downtime10min_${e}_0

    #~ # no node stealing, simple chechpoints
    #~ robin generate "test_MIRA_2017June_MTBF2h_downtime10min_${e}_0.yaml" \
    #~ --output-dir "log_${e}_0" \
    #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2017June_MTBF2h.json -e log_${e}_0/expe_${e}_0 --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF2h_downtime10min_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_0" \
    #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":0\,\\\"victim_choice\\\":1\,\\\"decision_choice\\\":1} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_0" 

    #~ cd ..
    
    #~ # all 18 node stealing heuristics
    #~ for h in 1
    #~ do
        #~ for v in 1
        #~ do
            #~ for k in 1
            #~ do
                #~ mkdir test_MIRA_2017June_MTBF2h_downtime10min_${e}_$h$v$k
                #~ cd test_MIRA_2017June_MTBF2h_downtime10min_${e}_$h$v$k

                #~ robin generate "test_MIRA_2017June_MTBF2h_downtime10min_${e}_$h$v$k.yaml" \
                #~ --output-dir "log_${e}_$h$v$k" \
                #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2017June_MTBF2h.json -e log_${e}_$h$v$k/expe_${e}_$h$v$k --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF2h_downtime10min_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_$h$v$k" \
                #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":$h\,\\\"victim_choice\\\":$v\,\\\"decision_choice\\\":$k} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_$h$v$k" 
            
                #~ cd ..
            #~ done
        #~ done
    #~ done 
#~ done



#~ for e in {0..4}
#~ do
    #~ mkdir test_MIRA_2017June_MTBF5h_downtime10min_${e}_0
    #~ cd test_MIRA_2017June_MTBF5h_downtime10min_${e}_0

    #~ # no node stealing, simple chechpoints
    #~ robin generate "test_MIRA_2017June_MTBF5h_downtime10min_${e}_0.yaml" \
    #~ --output-dir "log_${e}_0" \
    #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2017June_MTBF5h.json -e log_${e}_0/expe_${e}_0 --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF5h_downtime10min_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_0" \
    #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":0\,\\\"victim_choice\\\":1\,\\\"decision_choice\\\":1} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_0" 

    #~ cd ..
    
    #~ # all 18 node stealing heuristics
    #~ for h in 1
    #~ do
        #~ for v in 1
        #~ do
            #~ for k in 1
            #~ do
                #~ mkdir test_MIRA_2017June_MTBF5h_downtime10min_${e}_$h$v$k
                #~ cd test_MIRA_2017June_MTBF5h_downtime10min_${e}_$h$v$k

                #~ robin generate "test_MIRA_2017June_MTBF5h_downtime10min_${e}_$h$v$k.yaml" \
                #~ --output-dir "log_${e}_$h$v$k" \
                #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2017June_MTBF5h.json -e log_${e}_$h$v$k/expe_${e}_$h$v$k --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF5h_downtime10min_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_$h$v$k" \
                #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":$h\,\\\"victim_choice\\\":$v\,\\\"decision_choice\\\":$k} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_$h$v$k" 
            
                #~ cd ..
            #~ done
        #~ done
    #~ done 
#~ done



#~ for e in {0..4}
#~ do
    #~ mkdir test_MIRA_2017June_MTBF10h_downtime10min_${e}_0
    #~ cd test_MIRA_2017June_MTBF10h_downtime10min_${e}_0

    #~ # no node stealing, simple chechpoints
    #~ robin generate "test_MIRA_2017June_MTBF10h_downtime10min_${e}_0.yaml" \
    #~ --output-dir "log_${e}_0" \
    #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2017June_MTBF10h.json -e log_${e}_0/expe_${e}_0 --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF10h_downtime10min_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_0" \
    #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":0\,\\\"victim_choice\\\":1\,\\\"decision_choice\\\":1} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_0" 

    #~ cd ..
    
    #~ # all 18 node stealing heuristics
    #~ for h in 1
    #~ do
        #~ for v in 1
        #~ do
            #~ for k in 1
            #~ do
                #~ mkdir test_MIRA_2017June_MTBF10h_downtime10min_${e}_$h$v$k
                #~ cd test_MIRA_2017June_MTBF10h_downtime10min_${e}_$h$v$k

                #~ robin generate "test_MIRA_2017June_MTBF10h_downtime10min_${e}_$h$v$k.yaml" \
                #~ --output-dir "log_${e}_$h$v$k" \
                #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2017June_MTBF10h.json -e log_${e}_$h$v$k/expe_${e}_$h$v$k --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF10h_downtime10min_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_$h$v$k" \
                #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":$h\,\\\"victim_choice\\\":$v\,\\\"decision_choice\\\":$k} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_$h$v$k" 
            
                #~ cd ..
            #~ done
        #~ done
    #~ done 
#~ done



#~ for e in {0..4}
#~ do
    #~ mkdir test_MIRA_2017June_MTBF40min_downtime10min_${e}_0
    #~ cd test_MIRA_2017June_MTBF40min_downtime10min_${e}_0

    #~ # no node stealing, simple chechpoints
    #~ robin generate "test_MIRA_2017June_MTBF40min_downtime10min_${e}_0.yaml" \
    #~ --output-dir "log_${e}_0" \
    #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2017June_MTBF40min.json -e log_${e}_0/expe_${e}_0 --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF40min_downtime10min_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_0" \
    #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":0\,\\\"victim_choice\\\":1\,\\\"decision_choice\\\":1} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_0" 

    #~ cd ..
    
    #~ # all 18 node stealing heuristics
    #~ for h in 1
    #~ do
        #~ for v in 1
        #~ do
            #~ for k in 1
            #~ do
                #~ mkdir test_MIRA_2017June_MTBF40min_downtime10min_${e}_$h$v$k
                #~ cd test_MIRA_2017June_MTBF40min_downtime10min_${e}_$h$v$k

                #~ robin generate "test_MIRA_2017June_MTBF40min_downtime10min_${e}_$h$v$k.yaml" \
                #~ --output-dir "log_${e}_$h$v$k" \
                #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2017June_MTBF40min.json -e log_${e}_$h$v$k/expe_${e}_$h$v$k --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF40min_downtime10min_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_$h$v$k" \
                #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":$h\,\\\"victim_choice\\\":$v\,\\\"decision_choice\\\":$k} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_$h$v$k" 
            
                #~ cd ..
            #~ done
        #~ done
    #~ done 
#~ done



#~ for e in {0..4}
#~ do
    #~ mkdir test_MIRA_2017June_MTBF20min_downtime10min_${e}_0
    #~ cd test_MIRA_2017June_MTBF20min_downtime10min_${e}_0

    #~ # no node stealing, simple chechpoints
    #~ robin generate "test_MIRA_2017June_MTBF20min_downtime10min_${e}_0.yaml" \
    #~ --output-dir "log_${e}_0" \
    #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2017June_MTBF20min.json -e log_${e}_0/expe_${e}_0 --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF20min_downtime10min_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_0" \
    #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":0\,\\\"victim_choice\\\":1\,\\\"decision_choice\\\":1} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_0" 

    #~ cd ..
    
    #~ # all 18 node stealing heuristics
    #~ for h in 1
    #~ do
        #~ for v in 1
        #~ do
            #~ for k in 1
            #~ do
                #~ mkdir test_MIRA_2017June_MTBF20min_downtime10min_${e}_$h$v$k
                #~ cd test_MIRA_2017June_MTBF20min_downtime10min_${e}_$h$v$k

                #~ robin generate "test_MIRA_2017June_MTBF20min_downtime10min_${e}_$h$v$k.yaml" \
                #~ --output-dir "log_${e}_$h$v$k" \
                #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2017June_MTBF20min.json -e log_${e}_$h$v$k/expe_${e}_$h$v$k --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF20min_downtime10min_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_$h$v$k" \
                #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":$h\,\\\"victim_choice\\\":$v\,\\\"decision_choice\\\":$k} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_$h$v$k" 
            
                #~ cd ..
            #~ done
        #~ done
    #~ done 
#~ done


#~ for e in {0..4}
#~ do
    #~ mkdir test_MIRA_2017June_MTBF1h_downtime1day_${e}_0
    #~ cd test_MIRA_2017June_MTBF1h_downtime1day_${e}_0

    #~ # no node stealing, simple chechpoints
    #~ robin generate "test_MIRA_2017June_MTBF1h_downtime1day_${e}_0.yaml" \
    #~ --output-dir "log_${e}_0" \
    #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2017June_MTBF1h.json -e log_${e}_0/expe_${e}_0 --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF1h_downtime1day_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_0" \
    #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":0\,\\\"victim_choice\\\":1\,\\\"decision_choice\\\":1} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_0" 

    #~ cd ..
    
    #~ # all 18 node stealing heuristics
    #~ for h in 1
    #~ do
        #~ for v in 1
        #~ do
            #~ for k in 1
            #~ do
                #~ mkdir test_MIRA_2017June_MTBF1h_downtime1day_${e}_$h$v$k
                #~ cd test_MIRA_2017June_MTBF1h_downtime1day_${e}_$h$v$k

                #~ robin generate "test_MIRA_2017June_MTBF1h_downtime1day_${e}_$h$v$k.yaml" \
                #~ --output-dir "log_${e}_$h$v$k" \
                #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2017June_MTBF1h.json -e log_${e}_$h$v$k/expe_${e}_$h$v$k --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF1h_downtime1day_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_$h$v$k" \
                #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":$h\,\\\"victim_choice\\\":$v\,\\\"decision_choice\\\":$k} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_$h$v$k" 
            
                #~ cd ..
            #~ done
        #~ done
    #~ done 
#~ done



#~ for e in {0..4}
#~ do
    #~ mkdir test_MIRA_2017June_MTBF2h_downtime1day_${e}_0
    #~ cd test_MIRA_2017June_MTBF2h_downtime1day_${e}_0

    #~ # no node stealing, simple chechpoints
    #~ robin generate "test_MIRA_2017June_MTBF2h_downtime1day_${e}_0.yaml" \
    #~ --output-dir "log_${e}_0" \
    #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2017June_MTBF2h.json -e log_${e}_0/expe_${e}_0 --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF2h_downtime1day_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_0" \
    #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":0\,\\\"victim_choice\\\":1\,\\\"decision_choice\\\":1} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_0" 

    #~ cd ..
    
    #~ # all 18 node stealing heuristics
    #~ for h in 1
    #~ do
        #~ for v in 1
        #~ do
            #~ for k in 1
            #~ do
                #~ mkdir test_MIRA_2017June_MTBF2h_downtime1day_${e}_$h$v$k
                #~ cd test_MIRA_2017June_MTBF2h_downtime1day_${e}_$h$v$k

                #~ robin generate "test_MIRA_2017June_MTBF2h_downtime1day_${e}_$h$v$k.yaml" \
                #~ --output-dir "log_${e}_$h$v$k" \
                #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2017June_MTBF2h.json -e log_${e}_$h$v$k/expe_${e}_$h$v$k --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF2h_downtime1day_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_$h$v$k" \
                #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":$h\,\\\"victim_choice\\\":$v\,\\\"decision_choice\\\":$k} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_$h$v$k" 
            
                #~ cd ..
            #~ done
        #~ done
    #~ done 
#~ done



#~ for e in {0..4}
#~ do
    #~ mkdir test_MIRA_2017June_MTBF5h_downtime1day_${e}_0
    #~ cd test_MIRA_2017June_MTBF5h_downtime1day_${e}_0

    #~ # no node stealing, simple chechpoints
    #~ robin generate "test_MIRA_2017June_MTBF5h_downtime1day_${e}_0.yaml" \
    #~ --output-dir "log_${e}_0" \
    #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2017June_MTBF5h.json -e log_${e}_0/expe_${e}_0 --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF5h_downtime1day_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_0" \
    #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":0\,\\\"victim_choice\\\":1\,\\\"decision_choice\\\":1} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_0" 

    #~ cd ..
    
    #~ # all 18 node stealing heuristics
    #~ for h in 1
    #~ do
        #~ for v in 1
        #~ do
            #~ for k in 1
            #~ do
                #~ mkdir test_MIRA_2017June_MTBF5h_downtime1day_${e}_$h$v$k
                #~ cd test_MIRA_2017June_MTBF5h_downtime1day_${e}_$h$v$k

                #~ robin generate "test_MIRA_2017June_MTBF5h_downtime1day_${e}_$h$v$k.yaml" \
                #~ --output-dir "log_${e}_$h$v$k" \
                #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2017June_MTBF5h.json -e log_${e}_$h$v$k/expe_${e}_$h$v$k --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF5h_downtime1day_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_$h$v$k" \
                #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":$h\,\\\"victim_choice\\\":$v\,\\\"decision_choice\\\":$k} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_$h$v$k" 
            
                #~ cd ..
            #~ done
        #~ done
    #~ done 
#~ done



#~ for e in {0..4}
#~ do
    #~ mkdir test_MIRA_2017June_MTBF10h_downtime1day_${e}_0
    #~ cd test_MIRA_2017June_MTBF10h_downtime1day_${e}_0

    #~ # no node stealing, simple chechpoints
    #~ robin generate "test_MIRA_2017June_MTBF10h_downtime1day_${e}_0.yaml" \
    #~ --output-dir "log_${e}_0" \
    #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2017June_MTBF10h.json -e log_${e}_0/expe_${e}_0 --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF10h_downtime1day_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_0" \
    #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":0\,\\\"victim_choice\\\":1\,\\\"decision_choice\\\":1} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_0" 

    #~ cd ..
    
    #~ # all 18 node stealing heuristics
    #~ for h in 1
    #~ do
        #~ for v in 1
        #~ do
            #~ for k in 1
            #~ do
                #~ mkdir test_MIRA_2017June_MTBF10h_downtime1day_${e}_$h$v$k
                #~ cd test_MIRA_2017June_MTBF10h_downtime1day_${e}_$h$v$k

                #~ robin generate "test_MIRA_2017June_MTBF10h_downtime1day_${e}_$h$v$k.yaml" \
                #~ --output-dir "log_${e}_$h$v$k" \
                #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2017June_MTBF10h.json -e log_${e}_$h$v$k/expe_${e}_$h$v$k --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF10h_downtime1day_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_$h$v$k" \
                #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":$h\,\\\"victim_choice\\\":$v\,\\\"decision_choice\\\":$k} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_$h$v$k" 
            
                #~ cd ..
            #~ done
        #~ done
    #~ done 
#~ done



#~ for e in {0..4}
#~ do
    #~ mkdir test_MIRA_2017June_MTBF40min_downtime1day_${e}_0
    #~ cd test_MIRA_2017June_MTBF40min_downtime1day_${e}_0

    #~ # no node stealing, simple chechpoints
    #~ robin generate "test_MIRA_2017June_MTBF40min_downtime1day_${e}_0.yaml" \
    #~ --output-dir "log_${e}_0" \
    #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2017June_MTBF40min.json -e log_${e}_0/expe_${e}_0 --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF40min_downtime1day_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_0" \
    #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":0\,\\\"victim_choice\\\":1\,\\\"decision_choice\\\":1} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_0" 

    #~ cd ..
    
    #~ # all 18 node stealing heuristics
    #~ for h in 1
    #~ do
        #~ for v in 1
        #~ do
            #~ for k in 1
            #~ do
                #~ mkdir test_MIRA_2017June_MTBF40min_downtime1day_${e}_$h$v$k
                #~ cd test_MIRA_2017June_MTBF40min_downtime1day_${e}_$h$v$k

                #~ robin generate "test_MIRA_2017June_MTBF40min_downtime1day_${e}_$h$v$k.yaml" \
                #~ --output-dir "log_${e}_$h$v$k" \
                #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2017June_MTBF40min.json -e log_${e}_$h$v$k/expe_${e}_$h$v$k --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF40min_downtime1day_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_$h$v$k" \
                #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":$h\,\\\"victim_choice\\\":$v\,\\\"decision_choice\\\":$k} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_$h$v$k" 
            
                #~ cd ..
            #~ done
        #~ done
    #~ done 
#~ done



#~ for e in {0..4}
#~ do
    #~ mkdir test_MIRA_2017June_MTBF20min_downtime1day_${e}_0
    #~ cd test_MIRA_2017June_MTBF20min_downtime1day_${e}_0

    #~ # no node stealing, simple chechpoints
    #~ robin generate "test_MIRA_2017June_MTBF20min_downtime1day_${e}_0.yaml" \
    #~ --output-dir "log_${e}_0" \
    #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2017June_MTBF20min.json -e log_${e}_0/expe_${e}_0 --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF20min_downtime1day_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_0" \
    #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":0\,\\\"victim_choice\\\":1\,\\\"decision_choice\\\":1} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_0" 

    #~ cd ..
    
    #~ # all 18 node stealing heuristics
    #~ for h in 1
    #~ do
        #~ for v in 1
        #~ do
            #~ for k in 1
            #~ do
                #~ mkdir test_MIRA_2017June_MTBF20min_downtime1day_${e}_$h$v$k
                #~ cd test_MIRA_2017June_MTBF20min_downtime1day_${e}_$h$v$k

                #~ robin generate "test_MIRA_2017June_MTBF20min_downtime1day_${e}_$h$v$k.yaml" \
                #~ --output-dir "log_${e}_$h$v$k" \
                #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2017June_MTBF20min.json -e log_${e}_$h$v$k/expe_${e}_$h$v$k --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF20min_downtime1day_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_$h$v$k" \
                #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":$h\,\\\"victim_choice\\\":$v\,\\\"decision_choice\\\":$k} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_$h$v$k" 
            
                #~ cd ..
            #~ done
        #~ done
    #~ done 
#~ done


#~ ### generate yaml files of heuristic h111 for March 2018

#~ for e in {0..4}
#~ do
    #~ mkdir test_MIRA_2018March_MTBF1h_downtime1h_${e}_0
    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_${e}_0

    #~ # no node stealing, simple chechpoints
    #~ robin generate "test_MIRA_2018March_MTBF1h_downtime1h_${e}_0.yaml" \
    #~ --output-dir "log_${e}_0" \
    #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2018March_MTBF1h.json -e log_${e}_0/expe_${e}_0 --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF1h_downtime1h_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_0" \
    #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":0\,\\\"victim_choice\\\":1\,\\\"decision_choice\\\":1} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_0" 

    #~ cd ..
    
    #~ # all 18 node stealing heuristics
    #~ for h in 1
    #~ do
        #~ for v in 1
        #~ do
            #~ for k in 1
            #~ do
                #~ mkdir test_MIRA_2018March_MTBF1h_downtime1h_${e}_$h$v$k
                #~ cd test_MIRA_2018March_MTBF1h_downtime1h_${e}_$h$v$k

                #~ robin generate "test_MIRA_2018March_MTBF1h_downtime1h_${e}_$h$v$k.yaml" \
                #~ --output-dir "log_${e}_$h$v$k" \
                #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2018March_MTBF1h.json -e log_${e}_$h$v$k/expe_${e}_$h$v$k --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF1h_downtime1h_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_$h$v$k" \
                #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":$h\,\\\"victim_choice\\\":$v\,\\\"decision_choice\\\":$k} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_$h$v$k" 
            
                #~ cd ..
            #~ done
        #~ done
    #~ done 
#~ done



#~ for e in {0..4}
#~ do
    #~ mkdir test_MIRA_2018March_MTBF2h_downtime1h_${e}_0
    #~ cd test_MIRA_2018March_MTBF2h_downtime1h_${e}_0

    #~ # no node stealing, simple chechpoints
    #~ robin generate "test_MIRA_2018March_MTBF2h_downtime1h_${e}_0.yaml" \
    #~ --output-dir "log_${e}_0" \
    #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2018March_MTBF2h.json -e log_${e}_0/expe_${e}_0 --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF2h_downtime1h_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_0" \
    #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":0\,\\\"victim_choice\\\":1\,\\\"decision_choice\\\":1} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_0" 

    #~ cd ..
    
    #~ # all 18 node stealing heuristics
    #~ for h in 1
    #~ do
        #~ for v in 1
        #~ do
            #~ for k in 1
            #~ do
                #~ mkdir test_MIRA_2018March_MTBF2h_downtime1h_${e}_$h$v$k
                #~ cd test_MIRA_2018March_MTBF2h_downtime1h_${e}_$h$v$k

                #~ robin generate "test_MIRA_2018March_MTBF2h_downtime1h_${e}_$h$v$k.yaml" \
                #~ --output-dir "log_${e}_$h$v$k" \
                #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2018March_MTBF2h.json -e log_${e}_$h$v$k/expe_${e}_$h$v$k --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF2h_downtime1h_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_$h$v$k" \
                #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":$h\,\\\"victim_choice\\\":$v\,\\\"decision_choice\\\":$k} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_$h$v$k" 
            
                #~ cd ..
            #~ done
        #~ done
    #~ done 
#~ done



#~ for e in {0..4}
#~ do
    #~ mkdir test_MIRA_2018March_MTBF5h_downtime1h_${e}_0
    #~ cd test_MIRA_2018March_MTBF5h_downtime1h_${e}_0

    #~ # no node stealing, simple chechpoints
    #~ robin generate "test_MIRA_2018March_MTBF5h_downtime1h_${e}_0.yaml" \
    #~ --output-dir "log_${e}_0" \
    #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2018March_MTBF5h.json -e log_${e}_0/expe_${e}_0 --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF5h_downtime1h_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_0" \
    #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":0\,\\\"victim_choice\\\":1\,\\\"decision_choice\\\":1} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_0" 

    #~ cd ..
    
    #~ # all 18 node stealing heuristics
    #~ for h in 1
    #~ do
        #~ for v in 1
        #~ do
            #~ for k in 1
            #~ do
                #~ mkdir test_MIRA_2018March_MTBF5h_downtime1h_${e}_$h$v$k
                #~ cd test_MIRA_2018March_MTBF5h_downtime1h_${e}_$h$v$k

                #~ robin generate "test_MIRA_2018March_MTBF5h_downtime1h_${e}_$h$v$k.yaml" \
                #~ --output-dir "log_${e}_$h$v$k" \
                #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2018March_MTBF5h.json -e log_${e}_$h$v$k/expe_${e}_$h$v$k --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF5h_downtime1h_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_$h$v$k" \
                #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":$h\,\\\"victim_choice\\\":$v\,\\\"decision_choice\\\":$k} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_$h$v$k" 
            
                #~ cd ..
            #~ done
        #~ done
    #~ done 
#~ done



#~ for e in {0..4}
#~ do
    #~ mkdir test_MIRA_2018March_MTBF10h_downtime1h_${e}_0
    #~ cd test_MIRA_2018March_MTBF10h_downtime1h_${e}_0

    #~ # no node stealing, simple chechpoints
    #~ robin generate "test_MIRA_2018March_MTBF10h_downtime1h_${e}_0.yaml" \
    #~ --output-dir "log_${e}_0" \
    #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2018March_MTBF10h.json -e log_${e}_0/expe_${e}_0 --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF10h_downtime1h_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_0" \
    #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":0\,\\\"victim_choice\\\":1\,\\\"decision_choice\\\":1} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_0" 

    #~ cd ..
    
    #~ # all 18 node stealing heuristics
    #~ for h in 1
    #~ do
        #~ for v in 1
        #~ do
            #~ for k in 1
            #~ do
                #~ mkdir test_MIRA_2018March_MTBF10h_downtime1h_${e}_$h$v$k
                #~ cd test_MIRA_2018March_MTBF10h_downtime1h_${e}_$h$v$k

                #~ robin generate "test_MIRA_2018March_MTBF10h_downtime1h_${e}_$h$v$k.yaml" \
                #~ --output-dir "log_${e}_$h$v$k" \
                #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2018March_MTBF10h.json -e log_${e}_$h$v$k/expe_${e}_$h$v$k --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF10h_downtime1h_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_$h$v$k" \
                #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":$h\,\\\"victim_choice\\\":$v\,\\\"decision_choice\\\":$k} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_$h$v$k" 
            
                #~ cd ..
            #~ done
        #~ done
    #~ done 
#~ done



#~ for e in {0..4}
#~ do
    #~ mkdir test_MIRA_2018March_MTBF40min_downtime1h_${e}_0
    #~ cd test_MIRA_2018March_MTBF40min_downtime1h_${e}_0

    #~ # no node stealing, simple chechpoints
    #~ robin generate "test_MIRA_2018March_MTBF40min_downtime1h_${e}_0.yaml" \
    #~ --output-dir "log_${e}_0" \
    #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2018March_MTBF40min.json -e log_${e}_0/expe_${e}_0 --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF40min_downtime1h_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_0" \
    #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":0\,\\\"victim_choice\\\":1\,\\\"decision_choice\\\":1} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_0" 

    #~ cd ..
    
    #~ # all 18 node stealing heuristics
    #~ for h in 1
    #~ do
        #~ for v in 1
        #~ do
            #~ for k in 1
            #~ do
                #~ mkdir test_MIRA_2018March_MTBF40min_downtime1h_${e}_$h$v$k
                #~ cd test_MIRA_2018March_MTBF40min_downtime1h_${e}_$h$v$k

                #~ robin generate "test_MIRA_2018March_MTBF40min_downtime1h_${e}_$h$v$k.yaml" \
                #~ --output-dir "log_${e}_$h$v$k" \
                #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2018March_MTBF40min.json -e log_${e}_$h$v$k/expe_${e}_$h$v$k --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF40min_downtime1h_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_$h$v$k" \
                #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":$h\,\\\"victim_choice\\\":$v\,\\\"decision_choice\\\":$k} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_$h$v$k" 
            
                #~ cd ..
            #~ done
        #~ done
    #~ done 
#~ done



#~ for e in {0..4}
#~ do
    #~ mkdir test_MIRA_2018March_MTBF20min_downtime1h_${e}_0
    #~ cd test_MIRA_2018March_MTBF20min_downtime1h_${e}_0

    #~ # no node stealing, simple chechpoints
    #~ robin generate "test_MIRA_2018March_MTBF20min_downtime1h_${e}_0.yaml" \
    #~ --output-dir "log_${e}_0" \
    #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2018March_MTBF20min.json -e log_${e}_0/expe_${e}_0 --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF20min_downtime1h_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_0" \
    #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":0\,\\\"victim_choice\\\":1\,\\\"decision_choice\\\":1} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_0" 

    #~ cd ..
    
    #~ # all 18 node stealing heuristics
    #~ for h in 1
    #~ do
        #~ for v in 1
        #~ do
            #~ for k in 1
            #~ do
                #~ mkdir test_MIRA_2018March_MTBF20min_downtime1h_${e}_$h$v$k
                #~ cd test_MIRA_2018March_MTBF20min_downtime1h_${e}_$h$v$k

                #~ robin generate "test_MIRA_2018March_MTBF20min_downtime1h_${e}_$h$v$k.yaml" \
                #~ --output-dir "log_${e}_$h$v$k" \
                #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2018March_MTBF20min.json -e log_${e}_$h$v$k/expe_${e}_$h$v$k --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF20min_downtime1h_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_$h$v$k" \
                #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":$h\,\\\"victim_choice\\\":$v\,\\\"decision_choice\\\":$k} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_$h$v$k" 
            
                #~ cd ..
            #~ done
        #~ done
    #~ done 
#~ done



#~ for e in {0..4}
#~ do
    #~ mkdir test_MIRA_2018March_MTBF1h_downtime10min_${e}_0
    #~ cd test_MIRA_2018March_MTBF1h_downtime10min_${e}_0

    #~ # no node stealing, simple chechpoints
    #~ robin generate "test_MIRA_2018March_MTBF1h_downtime10min_${e}_0.yaml" \
    #~ --output-dir "log_${e}_0" \
    #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2018March_MTBF1h.json -e log_${e}_0/expe_${e}_0 --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF1h_downtime10min_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_0" \
    #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":0\,\\\"victim_choice\\\":1\,\\\"decision_choice\\\":1} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_0" 

    #~ cd ..
    
    #~ # all 18 node stealing heuristics
    #~ for h in 1
    #~ do
        #~ for v in 1
        #~ do
            #~ for k in 1
            #~ do
                #~ mkdir test_MIRA_2018March_MTBF1h_downtime10min_${e}_$h$v$k
                #~ cd test_MIRA_2018March_MTBF1h_downtime10min_${e}_$h$v$k

                #~ robin generate "test_MIRA_2018March_MTBF1h_downtime10min_${e}_$h$v$k.yaml" \
                #~ --output-dir "log_${e}_$h$v$k" \
                #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2018March_MTBF1h.json -e log_${e}_$h$v$k/expe_${e}_$h$v$k --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF1h_downtime10min_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_$h$v$k" \
                #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":$h\,\\\"victim_choice\\\":$v\,\\\"decision_choice\\\":$k} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_$h$v$k" 
            
                #~ cd ..
            #~ done
        #~ done
    #~ done 
#~ done



#~ for e in {0..4}
#~ do
    #~ mkdir test_MIRA_2018March_MTBF2h_downtime10min_${e}_0
    #~ cd test_MIRA_2018March_MTBF2h_downtime10min_${e}_0

    #~ # no node stealing, simple chechpoints
    #~ robin generate "test_MIRA_2018March_MTBF2h_downtime10min_${e}_0.yaml" \
    #~ --output-dir "log_${e}_0" \
    #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2018March_MTBF2h.json -e log_${e}_0/expe_${e}_0 --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF2h_downtime10min_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_0" \
    #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":0\,\\\"victim_choice\\\":1\,\\\"decision_choice\\\":1} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_0" 

    #~ cd ..
    
    #~ # all 18 node stealing heuristics
    #~ for h in 1
    #~ do
        #~ for v in 1
        #~ do
            #~ for k in 1
            #~ do
                #~ mkdir test_MIRA_2018March_MTBF2h_downtime10min_${e}_$h$v$k
                #~ cd test_MIRA_2018March_MTBF2h_downtime10min_${e}_$h$v$k

                #~ robin generate "test_MIRA_2018March_MTBF2h_downtime10min_${e}_$h$v$k.yaml" \
                #~ --output-dir "log_${e}_$h$v$k" \
                #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2018March_MTBF2h.json -e log_${e}_$h$v$k/expe_${e}_$h$v$k --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF2h_downtime10min_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_$h$v$k" \
                #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":$h\,\\\"victim_choice\\\":$v\,\\\"decision_choice\\\":$k} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_$h$v$k" 
            
                #~ cd ..
            #~ done
        #~ done
    #~ done 
#~ done



#~ for e in {0..4}
#~ do
    #~ mkdir test_MIRA_2018March_MTBF5h_downtime10min_${e}_0
    #~ cd test_MIRA_2018March_MTBF5h_downtime10min_${e}_0

    #~ # no node stealing, simple chechpoints
    #~ robin generate "test_MIRA_2018March_MTBF5h_downtime10min_${e}_0.yaml" \
    #~ --output-dir "log_${e}_0" \
    #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2018March_MTBF5h.json -e log_${e}_0/expe_${e}_0 --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF5h_downtime10min_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_0" \
    #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":0\,\\\"victim_choice\\\":1\,\\\"decision_choice\\\":1} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_0" 

    #~ cd ..
    
    #~ # all 18 node stealing heuristics
    #~ for h in 1
    #~ do
        #~ for v in 1
        #~ do
            #~ for k in 1
            #~ do
                #~ mkdir test_MIRA_2018March_MTBF5h_downtime10min_${e}_$h$v$k
                #~ cd test_MIRA_2018March_MTBF5h_downtime10min_${e}_$h$v$k

                #~ robin generate "test_MIRA_2018March_MTBF5h_downtime10min_${e}_$h$v$k.yaml" \
                #~ --output-dir "log_${e}_$h$v$k" \
                #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2018March_MTBF5h.json -e log_${e}_$h$v$k/expe_${e}_$h$v$k --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF5h_downtime10min_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_$h$v$k" \
                #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":$h\,\\\"victim_choice\\\":$v\,\\\"decision_choice\\\":$k} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_$h$v$k" 
            
                #~ cd ..
            #~ done
        #~ done
    #~ done 
#~ done



#~ for e in {0..4}
#~ do
    #~ mkdir test_MIRA_2018March_MTBF10h_downtime10min_${e}_0
    #~ cd test_MIRA_2018March_MTBF10h_downtime10min_${e}_0

    #~ # no node stealing, simple chechpoints
    #~ robin generate "test_MIRA_2018March_MTBF10h_downtime10min_${e}_0.yaml" \
    #~ --output-dir "log_${e}_0" \
    #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2018March_MTBF10h.json -e log_${e}_0/expe_${e}_0 --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF10h_downtime10min_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_0" \
    #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":0\,\\\"victim_choice\\\":1\,\\\"decision_choice\\\":1} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_0" 

    #~ cd ..
    
    #~ # all 18 node stealing heuristics
    #~ for h in 1
    #~ do
        #~ for v in 1
        #~ do
            #~ for k in 1
            #~ do
                #~ mkdir test_MIRA_2018March_MTBF10h_downtime10min_${e}_$h$v$k
                #~ cd test_MIRA_2018March_MTBF10h_downtime10min_${e}_$h$v$k

                #~ robin generate "test_MIRA_2018March_MTBF10h_downtime10min_${e}_$h$v$k.yaml" \
                #~ --output-dir "log_${e}_$h$v$k" \
                #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2018March_MTBF10h.json -e log_${e}_$h$v$k/expe_${e}_$h$v$k --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF10h_downtime10min_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_$h$v$k" \
                #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":$h\,\\\"victim_choice\\\":$v\,\\\"decision_choice\\\":$k} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_$h$v$k" 
            
                #~ cd ..
            #~ done
        #~ done
    #~ done 
#~ done



#~ for e in {0..4}
#~ do
    #~ mkdir test_MIRA_2018March_MTBF40min_downtime10min_${e}_0
    #~ cd test_MIRA_2018March_MTBF40min_downtime10min_${e}_0

    #~ # no node stealing, simple chechpoints
    #~ robin generate "test_MIRA_2018March_MTBF40min_downtime10min_${e}_0.yaml" \
    #~ --output-dir "log_${e}_0" \
    #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2018March_MTBF40min.json -e log_${e}_0/expe_${e}_0 --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF40min_downtime10min_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_0" \
    #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":0\,\\\"victim_choice\\\":1\,\\\"decision_choice\\\":1} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_0" 

    #~ cd ..
    
    #~ # all 18 node stealing heuristics
    #~ for h in 1
    #~ do
        #~ for v in 1
        #~ do
            #~ for k in 1
            #~ do
                #~ mkdir test_MIRA_2018March_MTBF40min_downtime10min_${e}_$h$v$k
                #~ cd test_MIRA_2018March_MTBF40min_downtime10min_${e}_$h$v$k

                #~ robin generate "test_MIRA_2018March_MTBF40min_downtime10min_${e}_$h$v$k.yaml" \
                #~ --output-dir "log_${e}_$h$v$k" \
                #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2018March_MTBF40min.json -e log_${e}_$h$v$k/expe_${e}_$h$v$k --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF40min_downtime10min_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_$h$v$k" \
                #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":$h\,\\\"victim_choice\\\":$v\,\\\"decision_choice\\\":$k} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_$h$v$k" 
            
                #~ cd ..
            #~ done
        #~ done
    #~ done 
#~ done



#~ for e in {0..4}
#~ do
    #~ mkdir test_MIRA_2018March_MTBF20min_downtime10min_${e}_0
    #~ cd test_MIRA_2018March_MTBF20min_downtime10min_${e}_0

    #~ # no node stealing, simple chechpoints
    #~ robin generate "test_MIRA_2018March_MTBF20min_downtime10min_${e}_0.yaml" \
    #~ --output-dir "log_${e}_0" \
    #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2018March_MTBF20min.json -e log_${e}_0/expe_${e}_0 --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF20min_downtime10min_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_0" \
    #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":0\,\\\"victim_choice\\\":1\,\\\"decision_choice\\\":1} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_0" 

    #~ cd ..
    
    #~ # all 18 node stealing heuristics
    #~ for h in 1
    #~ do
        #~ for v in 1
        #~ do
            #~ for k in 1
            #~ do
                #~ mkdir test_MIRA_2018March_MTBF20min_downtime10min_${e}_$h$v$k
                #~ cd test_MIRA_2018March_MTBF20min_downtime10min_${e}_$h$v$k

                #~ robin generate "test_MIRA_2018March_MTBF20min_downtime10min_${e}_$h$v$k.yaml" \
                #~ --output-dir "log_${e}_$h$v$k" \
                #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2018March_MTBF20min.json -e log_${e}_$h$v$k/expe_${e}_$h$v$k --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF20min_downtime10min_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_$h$v$k" \
                #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":$h\,\\\"victim_choice\\\":$v\,\\\"decision_choice\\\":$k} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_$h$v$k" 
            
                #~ cd ..
            #~ done
        #~ done
    #~ done 
#~ done


#~ for e in {0..4}
#~ do
    #~ mkdir test_MIRA_2018March_MTBF1h_downtime1day_${e}_0
    #~ cd test_MIRA_2018March_MTBF1h_downtime1day_${e}_0

    #~ # no node stealing, simple chechpoints
    #~ robin generate "test_MIRA_2018March_MTBF1h_downtime1day_${e}_0.yaml" \
    #~ --output-dir "log_${e}_0" \
    #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2018March_MTBF1h.json -e log_${e}_0/expe_${e}_0 --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF1h_downtime1day_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_0" \
    #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":0\,\\\"victim_choice\\\":1\,\\\"decision_choice\\\":1} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_0" 

    #~ cd ..
    
    #~ # all 18 node stealing heuristics
    #~ for h in 1
    #~ do
        #~ for v in 1
        #~ do
            #~ for k in 1
            #~ do
                #~ mkdir test_MIRA_2018March_MTBF1h_downtime1day_${e}_$h$v$k
                #~ cd test_MIRA_2018March_MTBF1h_downtime1day_${e}_$h$v$k

                #~ robin generate "test_MIRA_2018March_MTBF1h_downtime1day_${e}_$h$v$k.yaml" \
                #~ --output-dir "log_${e}_$h$v$k" \
                #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2018March_MTBF1h.json -e log_${e}_$h$v$k/expe_${e}_$h$v$k --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF1h_downtime1day_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_$h$v$k" \
                #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":$h\,\\\"victim_choice\\\":$v\,\\\"decision_choice\\\":$k} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_$h$v$k" 
            
                #~ cd ..
            #~ done
        #~ done
    #~ done 
#~ done



#~ for e in {0..4}
#~ do
    #~ mkdir test_MIRA_2018March_MTBF2h_downtime1day_${e}_0
    #~ cd test_MIRA_2018March_MTBF2h_downtime1day_${e}_0

    #~ # no node stealing, simple chechpoints
    #~ robin generate "test_MIRA_2018March_MTBF2h_downtime1day_${e}_0.yaml" \
    #~ --output-dir "log_${e}_0" \
    #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2018March_MTBF2h.json -e log_${e}_0/expe_${e}_0 --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF2h_downtime1day_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_0" \
    #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":0\,\\\"victim_choice\\\":1\,\\\"decision_choice\\\":1} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_0" 

    #~ cd ..
    
    #~ # all 18 node stealing heuristics
    #~ for h in 1
    #~ do
        #~ for v in 1
        #~ do
            #~ for k in 1
            #~ do
                #~ mkdir test_MIRA_2018March_MTBF2h_downtime1day_${e}_$h$v$k
                #~ cd test_MIRA_2018March_MTBF2h_downtime1day_${e}_$h$v$k

                #~ robin generate "test_MIRA_2018March_MTBF2h_downtime1day_${e}_$h$v$k.yaml" \
                #~ --output-dir "log_${e}_$h$v$k" \
                #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2018March_MTBF2h.json -e log_${e}_$h$v$k/expe_${e}_$h$v$k --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF2h_downtime1day_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_$h$v$k" \
                #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":$h\,\\\"victim_choice\\\":$v\,\\\"decision_choice\\\":$k} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_$h$v$k" 
            
                #~ cd ..
            #~ done
        #~ done
    #~ done 
#~ done



#~ for e in {0..4}
#~ do
    #~ mkdir test_MIRA_2018March_MTBF5h_downtime1day_${e}_0
    #~ cd test_MIRA_2018March_MTBF5h_downtime1day_${e}_0

    #~ # no node stealing, simple chechpoints
    #~ robin generate "test_MIRA_2018March_MTBF5h_downtime1day_${e}_0.yaml" \
    #~ --output-dir "log_${e}_0" \
    #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2018March_MTBF5h.json -e log_${e}_0/expe_${e}_0 --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF5h_downtime1day_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_0" \
    #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":0\,\\\"victim_choice\\\":1\,\\\"decision_choice\\\":1} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_0" 

    #~ cd ..
    
    #~ # all 18 node stealing heuristics
    #~ for h in 1
    #~ do
        #~ for v in 1
        #~ do
            #~ for k in 1
            #~ do
                #~ mkdir test_MIRA_2018March_MTBF5h_downtime1day_${e}_$h$v$k
                #~ cd test_MIRA_2018March_MTBF5h_downtime1day_${e}_$h$v$k

                #~ robin generate "test_MIRA_2018March_MTBF5h_downtime1day_${e}_$h$v$k.yaml" \
                #~ --output-dir "log_${e}_$h$v$k" \
                #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2018March_MTBF5h.json -e log_${e}_$h$v$k/expe_${e}_$h$v$k --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF5h_downtime1day_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_$h$v$k" \
                #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":$h\,\\\"victim_choice\\\":$v\,\\\"decision_choice\\\":$k} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_$h$v$k" 
            
                #~ cd ..
            #~ done
        #~ done
    #~ done 
#~ done



#~ for e in {0..4}
#~ do
    #~ mkdir test_MIRA_2018March_MTBF10h_downtime1day_${e}_0
    #~ cd test_MIRA_2018March_MTBF10h_downtime1day_${e}_0

    #~ # no node stealing, simple chechpoints
    #~ robin generate "test_MIRA_2018March_MTBF10h_downtime1day_${e}_0.yaml" \
    #~ --output-dir "log_${e}_0" \
    #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2018March_MTBF10h.json -e log_${e}_0/expe_${e}_0 --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF10h_downtime1day_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_0" \
    #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":0\,\\\"victim_choice\\\":1\,\\\"decision_choice\\\":1} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_0" 

    #~ cd ..
    
    #~ # all 18 node stealing heuristics
    #~ for h in 1
    #~ do
        #~ for v in 1
        #~ do
            #~ for k in 1
            #~ do
                #~ mkdir test_MIRA_2018March_MTBF10h_downtime1day_${e}_$h$v$k
                #~ cd test_MIRA_2018March_MTBF10h_downtime1day_${e}_$h$v$k

                #~ robin generate "test_MIRA_2018March_MTBF10h_downtime1day_${e}_$h$v$k.yaml" \
                #~ --output-dir "log_${e}_$h$v$k" \
                #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2018March_MTBF10h.json -e log_${e}_$h$v$k/expe_${e}_$h$v$k --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF10h_downtime1day_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_$h$v$k" \
                #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":$h\,\\\"victim_choice\\\":$v\,\\\"decision_choice\\\":$k} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_$h$v$k" 
            
                #~ cd ..
            #~ done
        #~ done
    #~ done 
#~ done



#~ for e in {0..4}
#~ do
    #~ mkdir test_MIRA_2018March_MTBF40min_downtime1day_${e}_0
    #~ cd test_MIRA_2018March_MTBF40min_downtime1day_${e}_0

    #~ # no node stealing, simple chechpoints
    #~ robin generate "test_MIRA_2018March_MTBF40min_downtime1day_${e}_0.yaml" \
    #~ --output-dir "log_${e}_0" \
    #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2018March_MTBF40min.json -e log_${e}_0/expe_${e}_0 --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF40min_downtime1day_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_0" \
    #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":0\,\\\"victim_choice\\\":1\,\\\"decision_choice\\\":1} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_0" 

    #~ cd ..
    
    #~ # all 18 node stealing heuristics
    #~ for h in 1
    #~ do
        #~ for v in 1
        #~ do
            #~ for k in 1
            #~ do
                #~ mkdir test_MIRA_2018March_MTBF40min_downtime1day_${e}_$h$v$k
                #~ cd test_MIRA_2018March_MTBF40min_downtime1day_${e}_$h$v$k

                #~ robin generate "test_MIRA_2018March_MTBF40min_downtime1day_${e}_$h$v$k.yaml" \
                #~ --output-dir "log_${e}_$h$v$k" \
                #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2018March_MTBF40min.json -e log_${e}_$h$v$k/expe_${e}_$h$v$k --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF40min_downtime1day_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_$h$v$k" \
                #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":$h\,\\\"victim_choice\\\":$v\,\\\"decision_choice\\\":$k} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_$h$v$k" 
            
                #~ cd ..
            #~ done
        #~ done
    #~ done 
#~ done



#~ for e in {0..4}
#~ do
    #~ mkdir test_MIRA_2018March_MTBF20min_downtime1day_${e}_0
    #~ cd test_MIRA_2018March_MTBF20min_downtime1day_${e}_0

    #~ # no node stealing, simple chechpoints
    #~ robin generate "test_MIRA_2018March_MTBF20min_downtime1day_${e}_0.yaml" \
    #~ --output-dir "log_${e}_0" \
    #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2018March_MTBF20min.json -e log_${e}_0/expe_${e}_0 --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF20min_downtime1day_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_0" \
    #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":0\,\\\"victim_choice\\\":1\,\\\"decision_choice\\\":1} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_0" 

    #~ cd ..
    
    #~ # all 18 node stealing heuristics
    #~ for h in 1
    #~ do
        #~ for v in 1
        #~ do
            #~ for k in 1
            #~ do
                #~ mkdir test_MIRA_2018March_MTBF20min_downtime1day_${e}_$h$v$k
                #~ cd test_MIRA_2018March_MTBF20min_downtime1day_${e}_$h$v$k

                #~ robin generate "test_MIRA_2018March_MTBF20min_downtime1day_${e}_$h$v$k.yaml" \
                #~ --output-dir "log_${e}_$h$v$k" \
                #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2018March_MTBF20min.json -e log_${e}_$h$v$k/expe_${e}_$h$v$k --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF20min_downtime1day_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_$h$v$k" \
                #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":$h\,\\\"victim_choice\\\":$v\,\\\"decision_choice\\\":$k} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_$h$v$k" 
            
                #~ cd ..
            #~ done
        #~ done
    #~ done 
#~ done



#~ # generate yaml files of all heuristics for June 2017

#~ for e in {0..4}
#~ do
    #~ mkdir test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_0
    #~ cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_0

    #~ # no node stealing, simple chechpoints
    #~ robin generate "test_MIRA_2017June_MTBF1h_downtime1h_${e}_0.yaml" \
    #~ --output-dir "log_${e}_0" \
    #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2017June_MTBF1h.json -e log_${e}_0/expe_${e}_0 --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF1h_downtime1h_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_0" \
    #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":0\,\\\"victim_choice\\\":1\,\\\"decision_choice\\\":1} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_0" 

    #~ cd ..
    
    #~ # all 18 node stealing heuristics
    #~ for h in 1 2 3
    #~ do
        #~ for v in 1 2
        #~ do
            #~ for k in 1 2 3
            #~ do
                #~ mkdir test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_$h$v$k
                #~ cd test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_$h$v$k

                #~ robin generate "test_MIRA_2017June_MTBF1h_downtime1h_${e}_$h$v$k.yaml" \
                #~ --output-dir "log_${e}_$h$v$k" \
                #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2017June_MTBF1h.json -e log_${e}_$h$v$k/expe_${e}_$h$v$k --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF1h_downtime1h_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_$h$v$k" \
                #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":$h\,\\\"victim_choice\\\":$v\,\\\"decision_choice\\\":$k} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_$h$v$k" 
            
                #~ cd ..
            #~ done
        #~ done
    #~ done 
#~ done

#~ # generate yaml files of all heuristics for March 2018

#~ for e in {0..4}
#~ do
    #~ mkdir test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_0
    #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_0

    #~ # no node stealing, simple chechpoints
    #~ robin generate "test_MIRA_2018March_MTBF1h_downtime1h_${e}_0.yaml" \
    #~ --output-dir "log_${e}_0" \
    #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2018March_MTBF1h.json -e log_${e}_0/expe_${e}_0 --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF1h_downtime1h_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_0" \
    #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":0\,\\\"victim_choice\\\":1\,\\\"decision_choice\\\":1} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_0" 

    #~ cd ..
    
    #~ # all 18 node stealing heuristics
    #~ for h in 1 2 3
    #~ do
        #~ for v in 1 2
        #~ do
            #~ for k in 1 2 3
            #~ do
                #~ mkdir test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_$h$v$k
                #~ cd test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_$h$v$k

                #~ robin generate "test_MIRA_2018March_MTBF1h_downtime1h_${e}_$h$v$k.yaml" \
                #~ --output-dir "log_${e}_$h$v$k" \
                #~ --batcmd "batsim -p ../batsim-src-stable/platforms/cluster49152.xml -w ../batsim-src-stable/workloads/MIRA_2018March_MTBF1h.json -e log_${e}_$h$v$k/expe_${e}_$h$v$k --enable-dynamic-jobs --enable-profile-reuse --acknowledge-dynamic-jobs --forward-profiles-on-submission --events ../batsim-src-stable/events/events_MIRA_MTBF1h_downtime1h_$e.txt --disable-schedule-tracing --socket-endpoint ipc://foobar_${e}_$h$v$k" \
                #~ --schedcmd "batsched -v conservative_bf_node_stealing --variant_options={\\\"heuristic_choice\\\":$h\,\\\"victim_choice\\\":$v\,\\\"decision_choice\\\":$k} --queue_order fcfs_prio --socket-endpoint ipc://foobar_${e}_$h$v$k" 
            
                #~ cd ..
            #~ done
        #~ done
    #~ done 
#~ done


# generate yaml files of original heuristic conservative_bf for June 2017 without checkpoints
mkdir test_MIRA_2017June_MTBF1h_downtime1h_withoutC
cd test_MIRA_2017June_MTBF1h_downtime1h_withoutC
 
robin generate "test_MIRA_2017June_MTBF1h_downtime1h_withoutC.yaml" \
--output-dir "expe-out_MIRA_2017June_MTBF1h_downtime1h_only_conservativebf" \
--batcmd "batsim -p batsim-src-stable/platforms/cluster49152.xml -w batsim-src-stable/workloads/MIRA_2017June_withoutC.json -e expe-out_MIRA_2017June_MTBF1h_downtime1h_only_conservativebf/expe_0_0" \
--schedcmd "batsched -v conservative_bf"  

cd ..


#~ # generate yaml files of original heuristic conservative_bf for March 2018 without checkpoints
#~ mkdir test_MIRA_2018March_MTBF1h_downtime1h_withoutC
#~ cd test_MIRA_2018March_MTBF1h_downtime1h_withoutC
 
#~ robin generate "test_MIRA_2018March_MTBF1h_downtime1h_withoutC.yaml" \
#~ --output-dir "expe-out_MIRA_2018March_MTBF1h_downtime1h_only_conservativebf" \
#~ --batcmd "batsim -p batsim-src-stable/platforms/cluster49152.xml -w batsim-src-stable/workloads/MIRA_2018March_withoutC.json -e expe-out_MIRA_2018March_MTBF1h_downtime1h_only_conservativebf/expe_0_0" \
#~ --schedcmd "batsched -v conservative_bf"  

#~ cd ..

