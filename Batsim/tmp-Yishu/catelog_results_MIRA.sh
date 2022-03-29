#!/usr/bin/bash

### catalog h0 and h111 simulation results for 2018March

mkdir test_MIRA_2017June_MTBF1h_downtime1h

for e in {0..4}
do
    cp ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_0/COMPLETED_KILLED.txt ./test_MIRA_2017June_MTBF1h_downtime1h/COMPLETED_KILLED_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_0/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2017June_MTBF1h_downtime1h/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_0/node_stealing_info.txt ./test_MIRA_2017June_MTBF1h_downtime1h/node_stealing_info_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_0/log_${e}_0/expe_${e}_0_jobs.csv ./test_MIRA_2017June_MTBF1h_downtime1h/expe_${e}_0_jobs.csv
    cp ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_0/log_${e}_0/expe_${e}_0_machine_states.csv ./test_MIRA_2017June_MTBF1h_downtime1h/expe_${e}_0_machine_states.csv
    cp ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_0/log_${e}_0/expe_${e}_0_schedule.csv ./test_MIRA_2017June_MTBF1h_downtime1h/expe_${e}_0_schedule.csv


    cp ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_111/COMPLETED_KILLED.txt ./test_MIRA_2017June_MTBF1h_downtime1h/COMPLETED_KILLED_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_111/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2017June_MTBF1h_downtime1h/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_111/node_stealing_info.txt ./test_MIRA_2017June_MTBF1h_downtime1h/node_stealing_info_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_111/node_stealing_times.txt ./test_MIRA_2017June_MTBF1h_downtime1h/node_stealing_times_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_111/log_${e}_111/expe_${e}_111_jobs.csv ./test_MIRA_2017June_MTBF1h_downtime1h/expe_${e}_111_jobs.csv
    cp ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_111/log_${e}_111/expe_${e}_111_machine_states.csv ./test_MIRA_2017June_MTBF1h_downtime1h/expe_${e}_111_machine_states.csv
    cp ./test_MIRA_2017June_MTBF1h_downtime1h_${e}_111/log_${e}_111/expe_${e}_111_schedule.csv ./test_MIRA_2017June_MTBF1h_downtime1h/expe_${e}_111_schedule.csv
done 

for e in {0..4}
do
    rm -r test_MIRA_2017June_MTBF1h_downtime1h_${e}_0
    rm -r test_MIRA_2017June_MTBF1h_downtime1h_${e}_111
done 

mkdir test_MIRA_2017June_MTBF2h_downtime1h

for e in {0..4}
do
    cp ./test_MIRA_2017June_MTBF2h_downtime1h_${e}_0/COMPLETED_KILLED.txt ./test_MIRA_2017June_MTBF2h_downtime1h/COMPLETED_KILLED_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF2h_downtime1h_${e}_0/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2017June_MTBF2h_downtime1h/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF2h_downtime1h_${e}_0/node_stealing_info.txt ./test_MIRA_2017June_MTBF2h_downtime1h/node_stealing_info_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF2h_downtime1h_${e}_0/log_${e}_0/expe_${e}_0_jobs.csv ./test_MIRA_2017June_MTBF2h_downtime1h/expe_${e}_0_jobs.csv
    cp ./test_MIRA_2017June_MTBF2h_downtime1h_${e}_0/log_${e}_0/expe_${e}_0_machine_states.csv ./test_MIRA_2017June_MTBF2h_downtime1h/expe_${e}_0_machine_states.csv
    cp ./test_MIRA_2017June_MTBF2h_downtime1h_${e}_0/log_${e}_0/expe_${e}_0_schedule.csv ./test_MIRA_2017June_MTBF2h_downtime1h/expe_${e}_0_schedule.csv


    cp ./test_MIRA_2017June_MTBF2h_downtime1h_${e}_111/COMPLETED_KILLED.txt ./test_MIRA_2017June_MTBF2h_downtime1h/COMPLETED_KILLED_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF2h_downtime1h_${e}_111/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2017June_MTBF2h_downtime1h/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF2h_downtime1h_${e}_111/node_stealing_info.txt ./test_MIRA_2017June_MTBF2h_downtime1h/node_stealing_info_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF2h_downtime1h_${e}_111/node_stealing_times.txt ./test_MIRA_2017June_MTBF2h_downtime1h/node_stealing_times_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF2h_downtime1h_${e}_111/log_${e}_111/expe_${e}_111_jobs.csv ./test_MIRA_2017June_MTBF2h_downtime1h/expe_${e}_111_jobs.csv
    cp ./test_MIRA_2017June_MTBF2h_downtime1h_${e}_111/log_${e}_111/expe_${e}_111_machine_states.csv ./test_MIRA_2017June_MTBF2h_downtime1h/expe_${e}_111_machine_states.csv
    cp ./test_MIRA_2017June_MTBF2h_downtime1h_${e}_111/log_${e}_111/expe_${e}_111_schedule.csv ./test_MIRA_2017June_MTBF2h_downtime1h/expe_${e}_111_schedule.csv
done 

for e in {0..4}
do
    rm -r test_MIRA_2017June_MTBF2h_downtime1h_${e}_0
    rm -r test_MIRA_2017June_MTBF2h_downtime1h_${e}_111
done 


mkdir test_MIRA_2017June_MTBF5h_downtime1h

for e in {0..4}
do
    cp ./test_MIRA_2017June_MTBF5h_downtime1h_${e}_0/COMPLETED_KILLED.txt ./test_MIRA_2017June_MTBF5h_downtime1h/COMPLETED_KILLED_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF5h_downtime1h_${e}_0/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2017June_MTBF5h_downtime1h/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF5h_downtime1h_${e}_0/node_stealing_info.txt ./test_MIRA_2017June_MTBF5h_downtime1h/node_stealing_info_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF5h_downtime1h_${e}_0/log_${e}_0/expe_${e}_0_jobs.csv ./test_MIRA_2017June_MTBF5h_downtime1h/expe_${e}_0_jobs.csv
    cp ./test_MIRA_2017June_MTBF5h_downtime1h_${e}_0/log_${e}_0/expe_${e}_0_machine_states.csv ./test_MIRA_2017June_MTBF5h_downtime1h/expe_${e}_0_machine_states.csv
    cp ./test_MIRA_2017June_MTBF5h_downtime1h_${e}_0/log_${e}_0/expe_${e}_0_schedule.csv ./test_MIRA_2017June_MTBF5h_downtime1h/expe_${e}_0_schedule.csv


    cp ./test_MIRA_2017June_MTBF5h_downtime1h_${e}_111/COMPLETED_KILLED.txt ./test_MIRA_2017June_MTBF5h_downtime1h/COMPLETED_KILLED_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF5h_downtime1h_${e}_111/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2017June_MTBF5h_downtime1h/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF5h_downtime1h_${e}_111/node_stealing_info.txt ./test_MIRA_2017June_MTBF5h_downtime1h/node_stealing_info_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF5h_downtime1h_${e}_111/node_stealing_times.txt ./test_MIRA_2017June_MTBF5h_downtime1h/node_stealing_times_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF5h_downtime1h_${e}_111/log_${e}_111/expe_${e}_111_jobs.csv ./test_MIRA_2017June_MTBF5h_downtime1h/expe_${e}_111_jobs.csv
    cp ./test_MIRA_2017June_MTBF5h_downtime1h_${e}_111/log_${e}_111/expe_${e}_111_machine_states.csv ./test_MIRA_2017June_MTBF5h_downtime1h/expe_${e}_111_machine_states.csv
    cp ./test_MIRA_2017June_MTBF5h_downtime1h_${e}_111/log_${e}_111/expe_${e}_111_schedule.csv ./test_MIRA_2017June_MTBF5h_downtime1h/expe_${e}_111_schedule.csv
done 

for e in {0..4}
do
    rm -r test_MIRA_2017June_MTBF5h_downtime1h_${e}_0
    rm -r test_MIRA_2017June_MTBF5h_downtime1h_${e}_111
done 


mkdir test_MIRA_2017June_MTBF10h_downtime1h

for e in {0..4}
do
    cp ./test_MIRA_2017June_MTBF10h_downtime1h_${e}_0/COMPLETED_KILLED.txt ./test_MIRA_2017June_MTBF10h_downtime1h/COMPLETED_KILLED_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF10h_downtime1h_${e}_0/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2017June_MTBF10h_downtime1h/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF10h_downtime1h_${e}_0/node_stealing_info.txt ./test_MIRA_2017June_MTBF10h_downtime1h/node_stealing_info_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF10h_downtime1h_${e}_0/log_${e}_0/expe_${e}_0_jobs.csv ./test_MIRA_2017June_MTBF10h_downtime1h/expe_${e}_0_jobs.csv
    cp ./test_MIRA_2017June_MTBF10h_downtime1h_${e}_0/log_${e}_0/expe_${e}_0_machine_states.csv ./test_MIRA_2017June_MTBF10h_downtime1h/expe_${e}_0_machine_states.csv
    cp ./test_MIRA_2017June_MTBF10h_downtime1h_${e}_0/log_${e}_0/expe_${e}_0_schedule.csv ./test_MIRA_2017June_MTBF10h_downtime1h/expe_${e}_0_schedule.csv


    cp ./test_MIRA_2017June_MTBF10h_downtime1h_${e}_111/COMPLETED_KILLED.txt ./test_MIRA_2017June_MTBF10h_downtime1h/COMPLETED_KILLED_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF10h_downtime1h_${e}_111/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2017June_MTBF10h_downtime1h/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF10h_downtime1h_${e}_111/node_stealing_info.txt ./test_MIRA_2017June_MTBF10h_downtime1h/node_stealing_info_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF10h_downtime1h_${e}_111/node_stealing_times.txt ./test_MIRA_2017June_MTBF10h_downtime1h/node_stealing_times_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF10h_downtime1h_${e}_111/log_${e}_111/expe_${e}_111_jobs.csv ./test_MIRA_2017June_MTBF10h_downtime1h/expe_${e}_111_jobs.csv
    cp ./test_MIRA_2017June_MTBF10h_downtime1h_${e}_111/log_${e}_111/expe_${e}_111_machine_states.csv ./test_MIRA_2017June_MTBF10h_downtime1h/expe_${e}_111_machine_states.csv
    cp ./test_MIRA_2017June_MTBF10h_downtime1h_${e}_111/log_${e}_111/expe_${e}_111_schedule.csv ./test_MIRA_2017June_MTBF10h_downtime1h/expe_${e}_111_schedule.csv
done 

for e in {0..4}
do
    rm -r test_MIRA_2017June_MTBF10h_downtime1h_${e}_0
    rm -r test_MIRA_2017June_MTBF10h_downtime1h_${e}_111
done 


mkdir test_MIRA_2017June_MTBF40min_downtime1h

for e in {0..4}
do
    cp ./test_MIRA_2017June_MTBF40min_downtime1h_${e}_0/COMPLETED_KILLED.txt ./test_MIRA_2017June_MTBF40min_downtime1h/COMPLETED_KILLED_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF40min_downtime1h_${e}_0/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2017June_MTBF40min_downtime1h/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF40min_downtime1h_${e}_0/node_stealing_info.txt ./test_MIRA_2017June_MTBF40min_downtime1h/node_stealing_info_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF40min_downtime1h_${e}_0/log_${e}_0/expe_${e}_0_jobs.csv ./test_MIRA_2017June_MTBF40min_downtime1h/expe_${e}_0_jobs.csv
    cp ./test_MIRA_2017June_MTBF40min_downtime1h_${e}_0/log_${e}_0/expe_${e}_0_machine_states.csv ./test_MIRA_2017June_MTBF40min_downtime1h/expe_${e}_0_machine_states.csv
    cp ./test_MIRA_2017June_MTBF40min_downtime1h_${e}_0/log_${e}_0/expe_${e}_0_schedule.csv ./test_MIRA_2017June_MTBF40min_downtime1h/expe_${e}_0_schedule.csv


    cp ./test_MIRA_2017June_MTBF40min_downtime1h_${e}_111/COMPLETED_KILLED.txt ./test_MIRA_2017June_MTBF40min_downtime1h/COMPLETED_KILLED_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF40min_downtime1h_${e}_111/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2017June_MTBF40min_downtime1h/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF40min_downtime1h_${e}_111/node_stealing_info.txt ./test_MIRA_2017June_MTBF40min_downtime1h/node_stealing_info_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF40min_downtime1h_${e}_111/node_stealing_times.txt ./test_MIRA_2017June_MTBF40min_downtime1h/node_stealing_times_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF40min_downtime1h_${e}_111/log_${e}_111/expe_${e}_111_jobs.csv ./test_MIRA_2017June_MTBF40min_downtime1h/expe_${e}_111_jobs.csv
    cp ./test_MIRA_2017June_MTBF40min_downtime1h_${e}_111/log_${e}_111/expe_${e}_111_machine_states.csv ./test_MIRA_2017June_MTBF40min_downtime1h/expe_${e}_111_machine_states.csv
    cp ./test_MIRA_2017June_MTBF40min_downtime1h_${e}_111/log_${e}_111/expe_${e}_111_schedule.csv ./test_MIRA_2017June_MTBF40min_downtime1h/expe_${e}_111_schedule.csv
done 

for e in {0..4}
do
    rm -r test_MIRA_2017June_MTBF40min_downtime1h_${e}_0
    rm -r test_MIRA_2017June_MTBF40min_downtime1h_${e}_111
done 


mkdir test_MIRA_2017June_MTBF20min_downtime1h

for e in {0..4}
do
    cp ./test_MIRA_2017June_MTBF20min_downtime1h_${e}_0/COMPLETED_KILLED.txt ./test_MIRA_2017June_MTBF20min_downtime1h/COMPLETED_KILLED_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF20min_downtime1h_${e}_0/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2017June_MTBF20min_downtime1h/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF20min_downtime1h_${e}_0/node_stealing_info.txt ./test_MIRA_2017June_MTBF20min_downtime1h/node_stealing_info_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF20min_downtime1h_${e}_0/log_${e}_0/expe_${e}_0_jobs.csv ./test_MIRA_2017June_MTBF20min_downtime1h/expe_${e}_0_jobs.csv
    cp ./test_MIRA_2017June_MTBF20min_downtime1h_${e}_0/log_${e}_0/expe_${e}_0_machine_states.csv ./test_MIRA_2017June_MTBF20min_downtime1h/expe_${e}_0_machine_states.csv
    cp ./test_MIRA_2017June_MTBF20min_downtime1h_${e}_0/log_${e}_0/expe_${e}_0_schedule.csv ./test_MIRA_2017June_MTBF20min_downtime1h/expe_${e}_0_schedule.csv


    cp ./test_MIRA_2017June_MTBF20min_downtime1h_${e}_111/COMPLETED_KILLED.txt ./test_MIRA_2017June_MTBF20min_downtime1h/COMPLETED_KILLED_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF20min_downtime1h_${e}_111/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2017June_MTBF20min_downtime1h/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF20min_downtime1h_${e}_111/node_stealing_info.txt ./test_MIRA_2017June_MTBF20min_downtime1h/node_stealing_info_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF20min_downtime1h_${e}_111/node_stealing_times.txt ./test_MIRA_2017June_MTBF20min_downtime1h/node_stealing_times_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF20min_downtime1h_${e}_111/log_${e}_111/expe_${e}_111_jobs.csv ./test_MIRA_2017June_MTBF20min_downtime1h/expe_${e}_111_jobs.csv
    cp ./test_MIRA_2017June_MTBF20min_downtime1h_${e}_111/log_${e}_111/expe_${e}_111_machine_states.csv ./test_MIRA_2017June_MTBF20min_downtime1h/expe_${e}_111_machine_states.csv
    cp ./test_MIRA_2017June_MTBF20min_downtime1h_${e}_111/log_${e}_111/expe_${e}_111_schedule.csv ./test_MIRA_2017June_MTBF20min_downtime1h/expe_${e}_111_schedule.csv
done 

for e in {0..4}
do
    rm -r test_MIRA_2017June_MTBF20min_downtime1h_${e}_0
    rm -r test_MIRA_2017June_MTBF20min_downtime1h_${e}_111
done 





mkdir test_MIRA_2017June_MTBF1h_downtime10min

for e in {0..4}
do
    cp ./test_MIRA_2017June_MTBF1h_downtime10min_${e}_0/COMPLETED_KILLED.txt ./test_MIRA_2017June_MTBF1h_downtime10min/COMPLETED_KILLED_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF1h_downtime10min_${e}_0/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2017June_MTBF1h_downtime10min/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF1h_downtime10min_${e}_0/node_stealing_info.txt ./test_MIRA_2017June_MTBF1h_downtime10min/node_stealing_info_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF1h_downtime10min_${e}_0/log_${e}_0/expe_${e}_0_jobs.csv ./test_MIRA_2017June_MTBF1h_downtime10min/expe_${e}_0_jobs.csv
    cp ./test_MIRA_2017June_MTBF1h_downtime10min_${e}_0/log_${e}_0/expe_${e}_0_machine_states.csv ./test_MIRA_2017June_MTBF1h_downtime10min/expe_${e}_0_machine_states.csv
    cp ./test_MIRA_2017June_MTBF1h_downtime10min_${e}_0/log_${e}_0/expe_${e}_0_schedule.csv ./test_MIRA_2017June_MTBF1h_downtime10min/expe_${e}_0_schedule.csv


    cp ./test_MIRA_2017June_MTBF1h_downtime10min_${e}_111/COMPLETED_KILLED.txt ./test_MIRA_2017June_MTBF1h_downtime10min/COMPLETED_KILLED_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF1h_downtime10min_${e}_111/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2017June_MTBF1h_downtime10min/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF1h_downtime10min_${e}_111/node_stealing_info.txt ./test_MIRA_2017June_MTBF1h_downtime10min/node_stealing_info_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF1h_downtime10min_${e}_111/node_stealing_times.txt ./test_MIRA_2017June_MTBF1h_downtime10min/node_stealing_times_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF1h_downtime10min_${e}_111/log_${e}_111/expe_${e}_111_jobs.csv ./test_MIRA_2017June_MTBF1h_downtime10min/expe_${e}_111_jobs.csv
    cp ./test_MIRA_2017June_MTBF1h_downtime10min_${e}_111/log_${e}_111/expe_${e}_111_machine_states.csv ./test_MIRA_2017June_MTBF1h_downtime10min/expe_${e}_111_machine_states.csv
    cp ./test_MIRA_2017June_MTBF1h_downtime10min_${e}_111/log_${e}_111/expe_${e}_111_schedule.csv ./test_MIRA_2017June_MTBF1h_downtime10min/expe_${e}_111_schedule.csv
done 

for e in {0..4}
do
    rm -r test_MIRA_2017June_MTBF1h_downtime10min_${e}_0
    rm -r test_MIRA_2017June_MTBF1h_downtime10min_${e}_111
done 

mkdir test_MIRA_2017June_MTBF2h_downtime10min

for e in {0..4}
do
    cp ./test_MIRA_2017June_MTBF2h_downtime10min_${e}_0/COMPLETED_KILLED.txt ./test_MIRA_2017June_MTBF2h_downtime10min/COMPLETED_KILLED_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF2h_downtime10min_${e}_0/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2017June_MTBF2h_downtime10min/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF2h_downtime10min_${e}_0/node_stealing_info.txt ./test_MIRA_2017June_MTBF2h_downtime10min/node_stealing_info_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF2h_downtime10min_${e}_0/log_${e}_0/expe_${e}_0_jobs.csv ./test_MIRA_2017June_MTBF2h_downtime10min/expe_${e}_0_jobs.csv
    cp ./test_MIRA_2017June_MTBF2h_downtime10min_${e}_0/log_${e}_0/expe_${e}_0_machine_states.csv ./test_MIRA_2017June_MTBF2h_downtime10min/expe_${e}_0_machine_states.csv
    cp ./test_MIRA_2017June_MTBF2h_downtime10min_${e}_0/log_${e}_0/expe_${e}_0_schedule.csv ./test_MIRA_2017June_MTBF2h_downtime10min/expe_${e}_0_schedule.csv


    cp ./test_MIRA_2017June_MTBF2h_downtime10min_${e}_111/COMPLETED_KILLED.txt ./test_MIRA_2017June_MTBF2h_downtime10min/COMPLETED_KILLED_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF2h_downtime10min_${e}_111/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2017June_MTBF2h_downtime10min/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF2h_downtime10min_${e}_111/node_stealing_info.txt ./test_MIRA_2017June_MTBF2h_downtime10min/node_stealing_info_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF2h_downtime10min_${e}_111/node_stealing_times.txt ./test_MIRA_2017June_MTBF2h_downtime10min/node_stealing_times_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF2h_downtime10min_${e}_111/log_${e}_111/expe_${e}_111_jobs.csv ./test_MIRA_2017June_MTBF2h_downtime10min/expe_${e}_111_jobs.csv
    cp ./test_MIRA_2017June_MTBF2h_downtime10min_${e}_111/log_${e}_111/expe_${e}_111_machine_states.csv ./test_MIRA_2017June_MTBF2h_downtime10min/expe_${e}_111_machine_states.csv
    cp ./test_MIRA_2017June_MTBF2h_downtime10min_${e}_111/log_${e}_111/expe_${e}_111_schedule.csv ./test_MIRA_2017June_MTBF2h_downtime10min/expe_${e}_111_schedule.csv
done 

for e in {0..4}
do
    rm -r test_MIRA_2017June_MTBF2h_downtime10min_${e}_0
    rm -r test_MIRA_2017June_MTBF2h_downtime10min_${e}_111
done 


mkdir test_MIRA_2017June_MTBF5h_downtime10min

for e in {0..4}
do
    cp ./test_MIRA_2017June_MTBF5h_downtime10min_${e}_0/COMPLETED_KILLED.txt ./test_MIRA_2017June_MTBF5h_downtime10min/COMPLETED_KILLED_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF5h_downtime10min_${e}_0/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2017June_MTBF5h_downtime10min/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF5h_downtime10min_${e}_0/node_stealing_info.txt ./test_MIRA_2017June_MTBF5h_downtime10min/node_stealing_info_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF5h_downtime10min_${e}_0/log_${e}_0/expe_${e}_0_jobs.csv ./test_MIRA_2017June_MTBF5h_downtime10min/expe_${e}_0_jobs.csv
    cp ./test_MIRA_2017June_MTBF5h_downtime10min_${e}_0/log_${e}_0/expe_${e}_0_machine_states.csv ./test_MIRA_2017June_MTBF5h_downtime10min/expe_${e}_0_machine_states.csv
    cp ./test_MIRA_2017June_MTBF5h_downtime10min_${e}_0/log_${e}_0/expe_${e}_0_schedule.csv ./test_MIRA_2017June_MTBF5h_downtime10min/expe_${e}_0_schedule.csv


    cp ./test_MIRA_2017June_MTBF5h_downtime10min_${e}_111/COMPLETED_KILLED.txt ./test_MIRA_2017June_MTBF5h_downtime10min/COMPLETED_KILLED_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF5h_downtime10min_${e}_111/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2017June_MTBF5h_downtime10min/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF5h_downtime10min_${e}_111/node_stealing_info.txt ./test_MIRA_2017June_MTBF5h_downtime10min/node_stealing_info_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF5h_downtime10min_${e}_111/node_stealing_times.txt ./test_MIRA_2017June_MTBF5h_downtime10min/node_stealing_times_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF5h_downtime10min_${e}_111/log_${e}_111/expe_${e}_111_jobs.csv ./test_MIRA_2017June_MTBF5h_downtime10min/expe_${e}_111_jobs.csv
    cp ./test_MIRA_2017June_MTBF5h_downtime10min_${e}_111/log_${e}_111/expe_${e}_111_machine_states.csv ./test_MIRA_2017June_MTBF5h_downtime10min/expe_${e}_111_machine_states.csv
    cp ./test_MIRA_2017June_MTBF5h_downtime10min_${e}_111/log_${e}_111/expe_${e}_111_schedule.csv ./test_MIRA_2017June_MTBF5h_downtime10min/expe_${e}_111_schedule.csv
done 

for e in {0..4}
do
    rm -r test_MIRA_2017June_MTBF5h_downtime10min_${e}_0
    rm -r test_MIRA_2017June_MTBF5h_downtime10min_${e}_111
done 


mkdir test_MIRA_2017June_MTBF10h_downtime10min

for e in {0..4}
do
    cp ./test_MIRA_2017June_MTBF10h_downtime10min_${e}_0/COMPLETED_KILLED.txt ./test_MIRA_2017June_MTBF10h_downtime10min/COMPLETED_KILLED_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF10h_downtime10min_${e}_0/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2017June_MTBF10h_downtime10min/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF10h_downtime10min_${e}_0/node_stealing_info.txt ./test_MIRA_2017June_MTBF10h_downtime10min/node_stealing_info_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF10h_downtime10min_${e}_0/log_${e}_0/expe_${e}_0_jobs.csv ./test_MIRA_2017June_MTBF10h_downtime10min/expe_${e}_0_jobs.csv
    cp ./test_MIRA_2017June_MTBF10h_downtime10min_${e}_0/log_${e}_0/expe_${e}_0_machine_states.csv ./test_MIRA_2017June_MTBF10h_downtime10min/expe_${e}_0_machine_states.csv
    cp ./test_MIRA_2017June_MTBF10h_downtime10min_${e}_0/log_${e}_0/expe_${e}_0_schedule.csv ./test_MIRA_2017June_MTBF10h_downtime10min/expe_${e}_0_schedule.csv


    cp ./test_MIRA_2017June_MTBF10h_downtime10min_${e}_111/COMPLETED_KILLED.txt ./test_MIRA_2017June_MTBF10h_downtime10min/COMPLETED_KILLED_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF10h_downtime10min_${e}_111/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2017June_MTBF10h_downtime10min/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF10h_downtime10min_${e}_111/node_stealing_info.txt ./test_MIRA_2017June_MTBF10h_downtime10min/node_stealing_info_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF10h_downtime10min_${e}_111/node_stealing_times.txt ./test_MIRA_2017June_MTBF10h_downtime10min/node_stealing_times_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF10h_downtime10min_${e}_111/log_${e}_111/expe_${e}_111_jobs.csv ./test_MIRA_2017June_MTBF10h_downtime10min/expe_${e}_111_jobs.csv
    cp ./test_MIRA_2017June_MTBF10h_downtime10min_${e}_111/log_${e}_111/expe_${e}_111_machine_states.csv ./test_MIRA_2017June_MTBF10h_downtime10min/expe_${e}_111_machine_states.csv
    cp ./test_MIRA_2017June_MTBF10h_downtime10min_${e}_111/log_${e}_111/expe_${e}_111_schedule.csv ./test_MIRA_2017June_MTBF10h_downtime10min/expe_${e}_111_schedule.csv
done 

for e in {0..4}
do
    rm -r test_MIRA_2017June_MTBF10h_downtime10min_${e}_0
    rm -r test_MIRA_2017June_MTBF10h_downtime10min_${e}_111
done 


mkdir test_MIRA_2017June_MTBF40min_downtime10min

for e in {0..4}
do
    cp ./test_MIRA_2017June_MTBF40min_downtime10min_${e}_0/COMPLETED_KILLED.txt ./test_MIRA_2017June_MTBF40min_downtime10min/COMPLETED_KILLED_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF40min_downtime10min_${e}_0/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2017June_MTBF40min_downtime10min/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF40min_downtime10min_${e}_0/node_stealing_info.txt ./test_MIRA_2017June_MTBF40min_downtime10min/node_stealing_info_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF40min_downtime10min_${e}_0/log_${e}_0/expe_${e}_0_jobs.csv ./test_MIRA_2017June_MTBF40min_downtime10min/expe_${e}_0_jobs.csv
    cp ./test_MIRA_2017June_MTBF40min_downtime10min_${e}_0/log_${e}_0/expe_${e}_0_machine_states.csv ./test_MIRA_2017June_MTBF40min_downtime10min/expe_${e}_0_machine_states.csv
    cp ./test_MIRA_2017June_MTBF40min_downtime10min_${e}_0/log_${e}_0/expe_${e}_0_schedule.csv ./test_MIRA_2017June_MTBF40min_downtime10min/expe_${e}_0_schedule.csv


    cp ./test_MIRA_2017June_MTBF40min_downtime10min_${e}_111/COMPLETED_KILLED.txt ./test_MIRA_2017June_MTBF40min_downtime10min/COMPLETED_KILLED_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF40min_downtime10min_${e}_111/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2017June_MTBF40min_downtime10min/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF40min_downtime10min_${e}_111/node_stealing_info.txt ./test_MIRA_2017June_MTBF40min_downtime10min/node_stealing_info_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF40min_downtime10min_${e}_111/node_stealing_times.txt ./test_MIRA_2017June_MTBF40min_downtime10min/node_stealing_times_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF40min_downtime10min_${e}_111/log_${e}_111/expe_${e}_111_jobs.csv ./test_MIRA_2017June_MTBF40min_downtime10min/expe_${e}_111_jobs.csv
    cp ./test_MIRA_2017June_MTBF40min_downtime10min_${e}_111/log_${e}_111/expe_${e}_111_machine_states.csv ./test_MIRA_2017June_MTBF40min_downtime10min/expe_${e}_111_machine_states.csv
    cp ./test_MIRA_2017June_MTBF40min_downtime10min_${e}_111/log_${e}_111/expe_${e}_111_schedule.csv ./test_MIRA_2017June_MTBF40min_downtime10min/expe_${e}_111_schedule.csv
done 

for e in {0..4}
do
    rm -r test_MIRA_2017June_MTBF40min_downtime10min_${e}_0
    rm -r test_MIRA_2017June_MTBF40min_downtime10min_${e}_111
done 


mkdir test_MIRA_2017June_MTBF20min_downtime10min

for e in {0..4}
do
    cp ./test_MIRA_2017June_MTBF20min_downtime10min_${e}_0/COMPLETED_KILLED.txt ./test_MIRA_2017June_MTBF20min_downtime10min/COMPLETED_KILLED_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF20min_downtime10min_${e}_0/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2017June_MTBF20min_downtime10min/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF20min_downtime10min_${e}_0/node_stealing_info.txt ./test_MIRA_2017June_MTBF20min_downtime10min/node_stealing_info_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF20min_downtime10min_${e}_0/log_${e}_0/expe_${e}_0_jobs.csv ./test_MIRA_2017June_MTBF20min_downtime10min/expe_${e}_0_jobs.csv
    cp ./test_MIRA_2017June_MTBF20min_downtime10min_${e}_0/log_${e}_0/expe_${e}_0_machine_states.csv ./test_MIRA_2017June_MTBF20min_downtime10min/expe_${e}_0_machine_states.csv
    cp ./test_MIRA_2017June_MTBF20min_downtime10min_${e}_0/log_${e}_0/expe_${e}_0_schedule.csv ./test_MIRA_2017June_MTBF20min_downtime10min/expe_${e}_0_schedule.csv


    cp ./test_MIRA_2017June_MTBF20min_downtime10min_${e}_111/COMPLETED_KILLED.txt ./test_MIRA_2017June_MTBF20min_downtime10min/COMPLETED_KILLED_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF20min_downtime10min_${e}_111/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2017June_MTBF20min_downtime10min/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF20min_downtime10min_${e}_111/node_stealing_info.txt ./test_MIRA_2017June_MTBF20min_downtime10min/node_stealing_info_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF20min_downtime10min_${e}_111/node_stealing_times.txt ./test_MIRA_2017June_MTBF20min_downtime10min/node_stealing_times_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF20min_downtime10min_${e}_111/log_${e}_111/expe_${e}_111_jobs.csv ./test_MIRA_2017June_MTBF20min_downtime10min/expe_${e}_111_jobs.csv
    cp ./test_MIRA_2017June_MTBF20min_downtime10min_${e}_111/log_${e}_111/expe_${e}_111_machine_states.csv ./test_MIRA_2017June_MTBF20min_downtime10min/expe_${e}_111_machine_states.csv
    cp ./test_MIRA_2017June_MTBF20min_downtime10min_${e}_111/log_${e}_111/expe_${e}_111_schedule.csv ./test_MIRA_2017June_MTBF20min_downtime10min/expe_${e}_111_schedule.csv
done 

for e in {0..4}
do
    rm -r test_MIRA_2017June_MTBF20min_downtime10min_${e}_0
    rm -r test_MIRA_2017June_MTBF20min_downtime10min_${e}_111
done 


mkdir test_MIRA_2017June_MTBF1h_downtime1day

for e in {0..4}
do
    cp ./test_MIRA_2017June_MTBF1h_downtime1day_${e}_0/COMPLETED_KILLED.txt ./test_MIRA_2017June_MTBF1h_downtime1day/COMPLETED_KILLED_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF1h_downtime1day_${e}_0/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2017June_MTBF1h_downtime1day/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF1h_downtime1day_${e}_0/node_stealing_info.txt ./test_MIRA_2017June_MTBF1h_downtime1day/node_stealing_info_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF1h_downtime1day_${e}_0/log_${e}_0/expe_${e}_0_jobs.csv ./test_MIRA_2017June_MTBF1h_downtime1day/expe_${e}_0_jobs.csv
    cp ./test_MIRA_2017June_MTBF1h_downtime1day_${e}_0/log_${e}_0/expe_${e}_0_machine_states.csv ./test_MIRA_2017June_MTBF1h_downtime1day/expe_${e}_0_machine_states.csv
    cp ./test_MIRA_2017June_MTBF1h_downtime1day_${e}_0/log_${e}_0/expe_${e}_0_schedule.csv ./test_MIRA_2017June_MTBF1h_downtime1day/expe_${e}_0_schedule.csv


    cp ./test_MIRA_2017June_MTBF1h_downtime1day_${e}_111/COMPLETED_KILLED.txt ./test_MIRA_2017June_MTBF1h_downtime1day/COMPLETED_KILLED_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF1h_downtime1day_${e}_111/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2017June_MTBF1h_downtime1day/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF1h_downtime1day_${e}_111/node_stealing_info.txt ./test_MIRA_2017June_MTBF1h_downtime1day/node_stealing_info_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF1h_downtime1day_${e}_111/node_stealing_times.txt ./test_MIRA_2017June_MTBF1h_downtime1day/node_stealing_times_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF1h_downtime1day_${e}_111/log_${e}_111/expe_${e}_111_jobs.csv ./test_MIRA_2017June_MTBF1h_downtime1day/expe_${e}_111_jobs.csv
    cp ./test_MIRA_2017June_MTBF1h_downtime1day_${e}_111/log_${e}_111/expe_${e}_111_machine_states.csv ./test_MIRA_2017June_MTBF1h_downtime1day/expe_${e}_111_machine_states.csv
    cp ./test_MIRA_2017June_MTBF1h_downtime1day_${e}_111/log_${e}_111/expe_${e}_111_schedule.csv ./test_MIRA_2017June_MTBF1h_downtime1day/expe_${e}_111_schedule.csv
done 

for e in {0..4}
do
    rm -r test_MIRA_2017June_MTBF1h_downtime1day_${e}_0
    rm -r test_MIRA_2017June_MTBF1h_downtime1day_${e}_111
done 

mkdir test_MIRA_2017June_MTBF2h_downtime1day

for e in {0..4}
do
    cp ./test_MIRA_2017June_MTBF2h_downtime1day_${e}_0/COMPLETED_KILLED.txt ./test_MIRA_2017June_MTBF2h_downtime1day/COMPLETED_KILLED_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF2h_downtime1day_${e}_0/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2017June_MTBF2h_downtime1day/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF2h_downtime1day_${e}_0/node_stealing_info.txt ./test_MIRA_2017June_MTBF2h_downtime1day/node_stealing_info_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF2h_downtime1day_${e}_0/log_${e}_0/expe_${e}_0_jobs.csv ./test_MIRA_2017June_MTBF2h_downtime1day/expe_${e}_0_jobs.csv
    cp ./test_MIRA_2017June_MTBF2h_downtime1day_${e}_0/log_${e}_0/expe_${e}_0_machine_states.csv ./test_MIRA_2017June_MTBF2h_downtime1day/expe_${e}_0_machine_states.csv
    cp ./test_MIRA_2017June_MTBF2h_downtime1day_${e}_0/log_${e}_0/expe_${e}_0_schedule.csv ./test_MIRA_2017June_MTBF2h_downtime1day/expe_${e}_0_schedule.csv


    cp ./test_MIRA_2017June_MTBF2h_downtime1day_${e}_111/COMPLETED_KILLED.txt ./test_MIRA_2017June_MTBF2h_downtime1day/COMPLETED_KILLED_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF2h_downtime1day_${e}_111/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2017June_MTBF2h_downtime1day/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF2h_downtime1day_${e}_111/node_stealing_info.txt ./test_MIRA_2017June_MTBF2h_downtime1day/node_stealing_info_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF2h_downtime1day_${e}_111/node_stealing_times.txt ./test_MIRA_2017June_MTBF2h_downtime1day/node_stealing_times_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF2h_downtime1day_${e}_111/log_${e}_111/expe_${e}_111_jobs.csv ./test_MIRA_2017June_MTBF2h_downtime1day/expe_${e}_111_jobs.csv
    cp ./test_MIRA_2017June_MTBF2h_downtime1day_${e}_111/log_${e}_111/expe_${e}_111_machine_states.csv ./test_MIRA_2017June_MTBF2h_downtime1day/expe_${e}_111_machine_states.csv
    cp ./test_MIRA_2017June_MTBF2h_downtime1day_${e}_111/log_${e}_111/expe_${e}_111_schedule.csv ./test_MIRA_2017June_MTBF2h_downtime1day/expe_${e}_111_schedule.csv
done 

for e in {0..4}
do
    rm -r test_MIRA_2017June_MTBF2h_downtime1day_${e}_0
    rm -r test_MIRA_2017June_MTBF2h_downtime1day_${e}_111
done 


mkdir test_MIRA_2017June_MTBF5h_downtime1day

for e in {0..4}
do
    cp ./test_MIRA_2017June_MTBF5h_downtime1day_${e}_0/COMPLETED_KILLED.txt ./test_MIRA_2017June_MTBF5h_downtime1day/COMPLETED_KILLED_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF5h_downtime1day_${e}_0/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2017June_MTBF5h_downtime1day/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF5h_downtime1day_${e}_0/node_stealing_info.txt ./test_MIRA_2017June_MTBF5h_downtime1day/node_stealing_info_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF5h_downtime1day_${e}_0/log_${e}_0/expe_${e}_0_jobs.csv ./test_MIRA_2017June_MTBF5h_downtime1day/expe_${e}_0_jobs.csv
    cp ./test_MIRA_2017June_MTBF5h_downtime1day_${e}_0/log_${e}_0/expe_${e}_0_machine_states.csv ./test_MIRA_2017June_MTBF5h_downtime1day/expe_${e}_0_machine_states.csv
    cp ./test_MIRA_2017June_MTBF5h_downtime1day_${e}_0/log_${e}_0/expe_${e}_0_schedule.csv ./test_MIRA_2017June_MTBF5h_downtime1day/expe_${e}_0_schedule.csv


    cp ./test_MIRA_2017June_MTBF5h_downtime1day_${e}_111/COMPLETED_KILLED.txt ./test_MIRA_2017June_MTBF5h_downtime1day/COMPLETED_KILLED_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF5h_downtime1day_${e}_111/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2017June_MTBF5h_downtime1day/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF5h_downtime1day_${e}_111/node_stealing_info.txt ./test_MIRA_2017June_MTBF5h_downtime1day/node_stealing_info_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF5h_downtime1day_${e}_111/node_stealing_times.txt ./test_MIRA_2017June_MTBF5h_downtime1day/node_stealing_times_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF5h_downtime1day_${e}_111/log_${e}_111/expe_${e}_111_jobs.csv ./test_MIRA_2017June_MTBF5h_downtime1day/expe_${e}_111_jobs.csv
    cp ./test_MIRA_2017June_MTBF5h_downtime1day_${e}_111/log_${e}_111/expe_${e}_111_machine_states.csv ./test_MIRA_2017June_MTBF5h_downtime1day/expe_${e}_111_machine_states.csv
    cp ./test_MIRA_2017June_MTBF5h_downtime1day_${e}_111/log_${e}_111/expe_${e}_111_schedule.csv ./test_MIRA_2017June_MTBF5h_downtime1day/expe_${e}_111_schedule.csv
done 

for e in {0..4}
do
    rm -r test_MIRA_2017June_MTBF5h_downtime1day_${e}_0
    rm -r test_MIRA_2017June_MTBF5h_downtime1day_${e}_111
done 


mkdir test_MIRA_2017June_MTBF10h_downtime1day

for e in {0..4}
do
    cp ./test_MIRA_2017June_MTBF10h_downtime1day_${e}_0/COMPLETED_KILLED.txt ./test_MIRA_2017June_MTBF10h_downtime1day/COMPLETED_KILLED_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF10h_downtime1day_${e}_0/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2017June_MTBF10h_downtime1day/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF10h_downtime1day_${e}_0/node_stealing_info.txt ./test_MIRA_2017June_MTBF10h_downtime1day/node_stealing_info_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF10h_downtime1day_${e}_0/log_${e}_0/expe_${e}_0_jobs.csv ./test_MIRA_2017June_MTBF10h_downtime1day/expe_${e}_0_jobs.csv
    cp ./test_MIRA_2017June_MTBF10h_downtime1day_${e}_0/log_${e}_0/expe_${e}_0_machine_states.csv ./test_MIRA_2017June_MTBF10h_downtime1day/expe_${e}_0_machine_states.csv
    cp ./test_MIRA_2017June_MTBF10h_downtime1day_${e}_0/log_${e}_0/expe_${e}_0_schedule.csv ./test_MIRA_2017June_MTBF10h_downtime1day/expe_${e}_0_schedule.csv


    cp ./test_MIRA_2017June_MTBF10h_downtime1day_${e}_111/COMPLETED_KILLED.txt ./test_MIRA_2017June_MTBF10h_downtime1day/COMPLETED_KILLED_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF10h_downtime1day_${e}_111/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2017June_MTBF10h_downtime1day/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF10h_downtime1day_${e}_111/node_stealing_info.txt ./test_MIRA_2017June_MTBF10h_downtime1day/node_stealing_info_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF10h_downtime1day_${e}_111/node_stealing_times.txt ./test_MIRA_2017June_MTBF10h_downtime1day/node_stealing_times_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF10h_downtime1day_${e}_111/log_${e}_111/expe_${e}_111_jobs.csv ./test_MIRA_2017June_MTBF10h_downtime1day/expe_${e}_111_jobs.csv
    cp ./test_MIRA_2017June_MTBF10h_downtime1day_${e}_111/log_${e}_111/expe_${e}_111_machine_states.csv ./test_MIRA_2017June_MTBF10h_downtime1day/expe_${e}_111_machine_states.csv
    cp ./test_MIRA_2017June_MTBF10h_downtime1day_${e}_111/log_${e}_111/expe_${e}_111_schedule.csv ./test_MIRA_2017June_MTBF10h_downtime1day/expe_${e}_111_schedule.csv
done 

for e in {0..4}
do
    rm -r test_MIRA_2017June_MTBF10h_downtime1day_${e}_0
    rm -r test_MIRA_2017June_MTBF10h_downtime1day_${e}_111
done 


mkdir test_MIRA_2017June_MTBF40min_downtime1day

for e in {0..4}
do
    cp ./test_MIRA_2017June_MTBF40min_downtime1day_${e}_0/COMPLETED_KILLED.txt ./test_MIRA_2017June_MTBF40min_downtime1day/COMPLETED_KILLED_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF40min_downtime1day_${e}_0/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2017June_MTBF40min_downtime1day/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF40min_downtime1day_${e}_0/node_stealing_info.txt ./test_MIRA_2017June_MTBF40min_downtime1day/node_stealing_info_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF40min_downtime1day_${e}_0/log_${e}_0/expe_${e}_0_jobs.csv ./test_MIRA_2017June_MTBF40min_downtime1day/expe_${e}_0_jobs.csv
    cp ./test_MIRA_2017June_MTBF40min_downtime1day_${e}_0/log_${e}_0/expe_${e}_0_machine_states.csv ./test_MIRA_2017June_MTBF40min_downtime1day/expe_${e}_0_machine_states.csv
    cp ./test_MIRA_2017June_MTBF40min_downtime1day_${e}_0/log_${e}_0/expe_${e}_0_schedule.csv ./test_MIRA_2017June_MTBF40min_downtime1day/expe_${e}_0_schedule.csv


    cp ./test_MIRA_2017June_MTBF40min_downtime1day_${e}_111/COMPLETED_KILLED.txt ./test_MIRA_2017June_MTBF40min_downtime1day/COMPLETED_KILLED_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF40min_downtime1day_${e}_111/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2017June_MTBF40min_downtime1day/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF40min_downtime1day_${e}_111/node_stealing_info.txt ./test_MIRA_2017June_MTBF40min_downtime1day/node_stealing_info_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF40min_downtime1day_${e}_111/node_stealing_times.txt ./test_MIRA_2017June_MTBF40min_downtime1day/node_stealing_times_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF40min_downtime1day_${e}_111/log_${e}_111/expe_${e}_111_jobs.csv ./test_MIRA_2017June_MTBF40min_downtime1day/expe_${e}_111_jobs.csv
    cp ./test_MIRA_2017June_MTBF40min_downtime1day_${e}_111/log_${e}_111/expe_${e}_111_machine_states.csv ./test_MIRA_2017June_MTBF40min_downtime1day/expe_${e}_111_machine_states.csv
    cp ./test_MIRA_2017June_MTBF40min_downtime1day_${e}_111/log_${e}_111/expe_${e}_111_schedule.csv ./test_MIRA_2017June_MTBF40min_downtime1day/expe_${e}_111_schedule.csv
done 

for e in {0..4}
do
    rm -r test_MIRA_2017June_MTBF40min_downtime1day_${e}_0
    rm -r test_MIRA_2017June_MTBF40min_downtime1day_${e}_111
done 


mkdir test_MIRA_2017June_MTBF20min_downtime1day

for e in {0..4}
do
    cp ./test_MIRA_2017June_MTBF20min_downtime1day_${e}_0/COMPLETED_KILLED.txt ./test_MIRA_2017June_MTBF20min_downtime1day/COMPLETED_KILLED_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF20min_downtime1day_${e}_0/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2017June_MTBF20min_downtime1day/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF20min_downtime1day_${e}_0/node_stealing_info.txt ./test_MIRA_2017June_MTBF20min_downtime1day/node_stealing_info_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF20min_downtime1day_${e}_0/log_${e}_0/expe_${e}_0_jobs.csv ./test_MIRA_2017June_MTBF20min_downtime1day/expe_${e}_0_jobs.csv
    cp ./test_MIRA_2017June_MTBF20min_downtime1day_${e}_0/log_${e}_0/expe_${e}_0_machine_states.csv ./test_MIRA_2017June_MTBF20min_downtime1day/expe_${e}_0_machine_states.csv
    cp ./test_MIRA_2017June_MTBF20min_downtime1day_${e}_0/log_${e}_0/expe_${e}_0_schedule.csv ./test_MIRA_2017June_MTBF20min_downtime1day/expe_${e}_0_schedule.csv


    cp ./test_MIRA_2017June_MTBF20min_downtime1day_${e}_111/COMPLETED_KILLED.txt ./test_MIRA_2017June_MTBF20min_downtime1day/COMPLETED_KILLED_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF20min_downtime1day_${e}_111/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2017June_MTBF20min_downtime1day/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF20min_downtime1day_${e}_111/node_stealing_info.txt ./test_MIRA_2017June_MTBF20min_downtime1day/node_stealing_info_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF20min_downtime1day_${e}_111/node_stealing_times.txt ./test_MIRA_2017June_MTBF20min_downtime1day/node_stealing_times_${e}_111.txt
    cp ./test_MIRA_2017June_MTBF20min_downtime1day_${e}_111/log_${e}_111/expe_${e}_111_jobs.csv ./test_MIRA_2017June_MTBF20min_downtime1day/expe_${e}_111_jobs.csv
    cp ./test_MIRA_2017June_MTBF20min_downtime1day_${e}_111/log_${e}_111/expe_${e}_111_machine_states.csv ./test_MIRA_2017June_MTBF20min_downtime1day/expe_${e}_111_machine_states.csv
    cp ./test_MIRA_2017June_MTBF20min_downtime1day_${e}_111/log_${e}_111/expe_${e}_111_schedule.csv ./test_MIRA_2017June_MTBF20min_downtime1day/expe_${e}_111_schedule.csv
done 

for e in {0..4}
do
    rm -r test_MIRA_2017June_MTBF20min_downtime1day_${e}_0
    rm -r test_MIRA_2017June_MTBF20min_downtime1day_${e}_111
done 



### catalog h0 and h111 simulation results for 2018March
mkdir test_MIRA_2018March_MTBF1h_downtime1h

for e in {0..4}
do
    cp ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_0/COMPLETED_KILLED.txt ./test_MIRA_2018March_MTBF1h_downtime1h/COMPLETED_KILLED_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_0/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2018March_MTBF1h_downtime1h/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_0/node_stealing_info.txt ./test_MIRA_2018March_MTBF1h_downtime1h/node_stealing_info_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_0/log_${e}_0/expe_${e}_0_jobs.csv ./test_MIRA_2018March_MTBF1h_downtime1h/expe_${e}_0_jobs.csv
    cp ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_0/log_${e}_0/expe_${e}_0_machine_states.csv ./test_MIRA_2018March_MTBF1h_downtime1h/expe_${e}_0_machine_states.csv
    cp ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_0/log_${e}_0/expe_${e}_0_schedule.csv ./test_MIRA_2018March_MTBF1h_downtime1h/expe_${e}_0_schedule.csv


    cp ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_111/COMPLETED_KILLED.txt ./test_MIRA_2018March_MTBF1h_downtime1h/COMPLETED_KILLED_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_111/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2018March_MTBF1h_downtime1h/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_111/node_stealing_info.txt ./test_MIRA_2018March_MTBF1h_downtime1h/node_stealing_info_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_111/node_stealing_times.txt ./test_MIRA_2018March_MTBF1h_downtime1h/node_stealing_times_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_111/log_${e}_111/expe_${e}_111_jobs.csv ./test_MIRA_2018March_MTBF1h_downtime1h/expe_${e}_111_jobs.csv
    cp ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_111/log_${e}_111/expe_${e}_111_machine_states.csv ./test_MIRA_2018March_MTBF1h_downtime1h/expe_${e}_111_machine_states.csv
    cp ./test_MIRA_2018March_MTBF1h_downtime1h_${e}_111/log_${e}_111/expe_${e}_111_schedule.csv ./test_MIRA_2018March_MTBF1h_downtime1h/expe_${e}_111_schedule.csv
done 

for e in {0..4}
do
    rm -r test_MIRA_2018March_MTBF1h_downtime1h_${e}_0
    rm -r test_MIRA_2018March_MTBF1h_downtime1h_${e}_111
done 

mkdir test_MIRA_2018March_MTBF2h_downtime1h

for e in {0..4}
do
    cp ./test_MIRA_2018March_MTBF2h_downtime1h_${e}_0/COMPLETED_KILLED.txt ./test_MIRA_2018March_MTBF2h_downtime1h/COMPLETED_KILLED_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF2h_downtime1h_${e}_0/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2018March_MTBF2h_downtime1h/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF2h_downtime1h_${e}_0/node_stealing_info.txt ./test_MIRA_2018March_MTBF2h_downtime1h/node_stealing_info_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF2h_downtime1h_${e}_0/log_${e}_0/expe_${e}_0_jobs.csv ./test_MIRA_2018March_MTBF2h_downtime1h/expe_${e}_0_jobs.csv
    cp ./test_MIRA_2018March_MTBF2h_downtime1h_${e}_0/log_${e}_0/expe_${e}_0_machine_states.csv ./test_MIRA_2018March_MTBF2h_downtime1h/expe_${e}_0_machine_states.csv
    cp ./test_MIRA_2018March_MTBF2h_downtime1h_${e}_0/log_${e}_0/expe_${e}_0_schedule.csv ./test_MIRA_2018March_MTBF2h_downtime1h/expe_${e}_0_schedule.csv


    cp ./test_MIRA_2018March_MTBF2h_downtime1h_${e}_111/COMPLETED_KILLED.txt ./test_MIRA_2018March_MTBF2h_downtime1h/COMPLETED_KILLED_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF2h_downtime1h_${e}_111/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2018March_MTBF2h_downtime1h/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF2h_downtime1h_${e}_111/node_stealing_info.txt ./test_MIRA_2018March_MTBF2h_downtime1h/node_stealing_info_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF2h_downtime1h_${e}_111/node_stealing_times.txt ./test_MIRA_2018March_MTBF2h_downtime1h/node_stealing_times_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF2h_downtime1h_${e}_111/log_${e}_111/expe_${e}_111_jobs.csv ./test_MIRA_2018March_MTBF2h_downtime1h/expe_${e}_111_jobs.csv
    cp ./test_MIRA_2018March_MTBF2h_downtime1h_${e}_111/log_${e}_111/expe_${e}_111_machine_states.csv ./test_MIRA_2018March_MTBF2h_downtime1h/expe_${e}_111_machine_states.csv
    cp ./test_MIRA_2018March_MTBF2h_downtime1h_${e}_111/log_${e}_111/expe_${e}_111_schedule.csv ./test_MIRA_2018March_MTBF2h_downtime1h/expe_${e}_111_schedule.csv
done 

for e in {0..4}
do
    rm -r test_MIRA_2018March_MTBF2h_downtime1h_${e}_0
    rm -r test_MIRA_2018March_MTBF2h_downtime1h_${e}_111
done 


mkdir test_MIRA_2018March_MTBF5h_downtime1h

for e in {0..4}
do
    cp ./test_MIRA_2018March_MTBF5h_downtime1h_${e}_0/COMPLETED_KILLED.txt ./test_MIRA_2018March_MTBF5h_downtime1h/COMPLETED_KILLED_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF5h_downtime1h_${e}_0/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2018March_MTBF5h_downtime1h/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF5h_downtime1h_${e}_0/node_stealing_info.txt ./test_MIRA_2018March_MTBF5h_downtime1h/node_stealing_info_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF5h_downtime1h_${e}_0/log_${e}_0/expe_${e}_0_jobs.csv ./test_MIRA_2018March_MTBF5h_downtime1h/expe_${e}_0_jobs.csv
    cp ./test_MIRA_2018March_MTBF5h_downtime1h_${e}_0/log_${e}_0/expe_${e}_0_machine_states.csv ./test_MIRA_2018March_MTBF5h_downtime1h/expe_${e}_0_machine_states.csv
    cp ./test_MIRA_2018March_MTBF5h_downtime1h_${e}_0/log_${e}_0/expe_${e}_0_schedule.csv ./test_MIRA_2018March_MTBF5h_downtime1h/expe_${e}_0_schedule.csv


    cp ./test_MIRA_2018March_MTBF5h_downtime1h_${e}_111/COMPLETED_KILLED.txt ./test_MIRA_2018March_MTBF5h_downtime1h/COMPLETED_KILLED_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF5h_downtime1h_${e}_111/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2018March_MTBF5h_downtime1h/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF5h_downtime1h_${e}_111/node_stealing_info.txt ./test_MIRA_2018March_MTBF5h_downtime1h/node_stealing_info_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF5h_downtime1h_${e}_111/node_stealing_times.txt ./test_MIRA_2018March_MTBF5h_downtime1h/node_stealing_times_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF5h_downtime1h_${e}_111/log_${e}_111/expe_${e}_111_jobs.csv ./test_MIRA_2018March_MTBF5h_downtime1h/expe_${e}_111_jobs.csv
    cp ./test_MIRA_2018March_MTBF5h_downtime1h_${e}_111/log_${e}_111/expe_${e}_111_machine_states.csv ./test_MIRA_2018March_MTBF5h_downtime1h/expe_${e}_111_machine_states.csv
    cp ./test_MIRA_2018March_MTBF5h_downtime1h_${e}_111/log_${e}_111/expe_${e}_111_schedule.csv ./test_MIRA_2018March_MTBF5h_downtime1h/expe_${e}_111_schedule.csv
done 

for e in {0..4}
do
    rm -r test_MIRA_2018March_MTBF5h_downtime1h_${e}_0
    rm -r test_MIRA_2018March_MTBF5h_downtime1h_${e}_111
done 


mkdir test_MIRA_2018March_MTBF10h_downtime1h

for e in {0..4}
do
    cp ./test_MIRA_2018March_MTBF10h_downtime1h_${e}_0/COMPLETED_KILLED.txt ./test_MIRA_2018March_MTBF10h_downtime1h/COMPLETED_KILLED_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF10h_downtime1h_${e}_0/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2018March_MTBF10h_downtime1h/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF10h_downtime1h_${e}_0/node_stealing_info.txt ./test_MIRA_2018March_MTBF10h_downtime1h/node_stealing_info_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF10h_downtime1h_${e}_0/log_${e}_0/expe_${e}_0_jobs.csv ./test_MIRA_2018March_MTBF10h_downtime1h/expe_${e}_0_jobs.csv
    cp ./test_MIRA_2018March_MTBF10h_downtime1h_${e}_0/log_${e}_0/expe_${e}_0_machine_states.csv ./test_MIRA_2018March_MTBF10h_downtime1h/expe_${e}_0_machine_states.csv
    cp ./test_MIRA_2018March_MTBF10h_downtime1h_${e}_0/log_${e}_0/expe_${e}_0_schedule.csv ./test_MIRA_2018March_MTBF10h_downtime1h/expe_${e}_0_schedule.csv


    cp ./test_MIRA_2018March_MTBF10h_downtime1h_${e}_111/COMPLETED_KILLED.txt ./test_MIRA_2018March_MTBF10h_downtime1h/COMPLETED_KILLED_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF10h_downtime1h_${e}_111/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2018March_MTBF10h_downtime1h/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF10h_downtime1h_${e}_111/node_stealing_info.txt ./test_MIRA_2018March_MTBF10h_downtime1h/node_stealing_info_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF10h_downtime1h_${e}_111/node_stealing_times.txt ./test_MIRA_2018March_MTBF10h_downtime1h/node_stealing_times_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF10h_downtime1h_${e}_111/log_${e}_111/expe_${e}_111_jobs.csv ./test_MIRA_2018March_MTBF10h_downtime1h/expe_${e}_111_jobs.csv
    cp ./test_MIRA_2018March_MTBF10h_downtime1h_${e}_111/log_${e}_111/expe_${e}_111_machine_states.csv ./test_MIRA_2018March_MTBF10h_downtime1h/expe_${e}_111_machine_states.csv
    cp ./test_MIRA_2018March_MTBF10h_downtime1h_${e}_111/log_${e}_111/expe_${e}_111_schedule.csv ./test_MIRA_2018March_MTBF10h_downtime1h/expe_${e}_111_schedule.csv
done 

for e in {0..4}
do
    rm -r test_MIRA_2018March_MTBF10h_downtime1h_${e}_0
    rm -r test_MIRA_2018March_MTBF10h_downtime1h_${e}_111
done 


mkdir test_MIRA_2018March_MTBF40min_downtime1h

for e in {0..4}
do
    cp ./test_MIRA_2018March_MTBF40min_downtime1h_${e}_0/COMPLETED_KILLED.txt ./test_MIRA_2018March_MTBF40min_downtime1h/COMPLETED_KILLED_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF40min_downtime1h_${e}_0/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2018March_MTBF40min_downtime1h/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF40min_downtime1h_${e}_0/node_stealing_info.txt ./test_MIRA_2018March_MTBF40min_downtime1h/node_stealing_info_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF40min_downtime1h_${e}_0/log_${e}_0/expe_${e}_0_jobs.csv ./test_MIRA_2018March_MTBF40min_downtime1h/expe_${e}_0_jobs.csv
    cp ./test_MIRA_2018March_MTBF40min_downtime1h_${e}_0/log_${e}_0/expe_${e}_0_machine_states.csv ./test_MIRA_2018March_MTBF40min_downtime1h/expe_${e}_0_machine_states.csv
    cp ./test_MIRA_2018March_MTBF40min_downtime1h_${e}_0/log_${e}_0/expe_${e}_0_schedule.csv ./test_MIRA_2018March_MTBF40min_downtime1h/expe_${e}_0_schedule.csv


    cp ./test_MIRA_2018March_MTBF40min_downtime1h_${e}_111/COMPLETED_KILLED.txt ./test_MIRA_2018March_MTBF40min_downtime1h/COMPLETED_KILLED_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF40min_downtime1h_${e}_111/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2018March_MTBF40min_downtime1h/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF40min_downtime1h_${e}_111/node_stealing_info.txt ./test_MIRA_2018March_MTBF40min_downtime1h/node_stealing_info_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF40min_downtime1h_${e}_111/node_stealing_times.txt ./test_MIRA_2018March_MTBF40min_downtime1h/node_stealing_times_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF40min_downtime1h_${e}_111/log_${e}_111/expe_${e}_111_jobs.csv ./test_MIRA_2018March_MTBF40min_downtime1h/expe_${e}_111_jobs.csv
    cp ./test_MIRA_2018March_MTBF40min_downtime1h_${e}_111/log_${e}_111/expe_${e}_111_machine_states.csv ./test_MIRA_2018March_MTBF40min_downtime1h/expe_${e}_111_machine_states.csv
    cp ./test_MIRA_2018March_MTBF40min_downtime1h_${e}_111/log_${e}_111/expe_${e}_111_schedule.csv ./test_MIRA_2018March_MTBF40min_downtime1h/expe_${e}_111_schedule.csv
done 

for e in {0..4}
do
    rm -r test_MIRA_2018March_MTBF40min_downtime1h_${e}_0
    rm -r test_MIRA_2018March_MTBF40min_downtime1h_${e}_111
done 


mkdir test_MIRA_2018March_MTBF20min_downtime1h

for e in {0..4}
do
    cp ./test_MIRA_2018March_MTBF20min_downtime1h_${e}_0/COMPLETED_KILLED.txt ./test_MIRA_2018March_MTBF20min_downtime1h/COMPLETED_KILLED_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF20min_downtime1h_${e}_0/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2018March_MTBF20min_downtime1h/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF20min_downtime1h_${e}_0/node_stealing_info.txt ./test_MIRA_2018March_MTBF20min_downtime1h/node_stealing_info_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF20min_downtime1h_${e}_0/log_${e}_0/expe_${e}_0_jobs.csv ./test_MIRA_2018March_MTBF20min_downtime1h/expe_${e}_0_jobs.csv
    cp ./test_MIRA_2018March_MTBF20min_downtime1h_${e}_0/log_${e}_0/expe_${e}_0_machine_states.csv ./test_MIRA_2018March_MTBF20min_downtime1h/expe_${e}_0_machine_states.csv
    cp ./test_MIRA_2018March_MTBF20min_downtime1h_${e}_0/log_${e}_0/expe_${e}_0_schedule.csv ./test_MIRA_2018March_MTBF20min_downtime1h/expe_${e}_0_schedule.csv


    cp ./test_MIRA_2018March_MTBF20min_downtime1h_${e}_111/COMPLETED_KILLED.txt ./test_MIRA_2018March_MTBF20min_downtime1h/COMPLETED_KILLED_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF20min_downtime1h_${e}_111/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2018March_MTBF20min_downtime1h/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF20min_downtime1h_${e}_111/node_stealing_info.txt ./test_MIRA_2018March_MTBF20min_downtime1h/node_stealing_info_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF20min_downtime1h_${e}_111/node_stealing_times.txt ./test_MIRA_2018March_MTBF20min_downtime1h/node_stealing_times_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF20min_downtime1h_${e}_111/log_${e}_111/expe_${e}_111_jobs.csv ./test_MIRA_2018March_MTBF20min_downtime1h/expe_${e}_111_jobs.csv
    cp ./test_MIRA_2018March_MTBF20min_downtime1h_${e}_111/log_${e}_111/expe_${e}_111_machine_states.csv ./test_MIRA_2018March_MTBF20min_downtime1h/expe_${e}_111_machine_states.csv
    cp ./test_MIRA_2018March_MTBF20min_downtime1h_${e}_111/log_${e}_111/expe_${e}_111_schedule.csv ./test_MIRA_2018March_MTBF20min_downtime1h/expe_${e}_111_schedule.csv
done 

for e in {0..4}
do
    rm -r test_MIRA_2018March_MTBF20min_downtime1h_${e}_0
    rm -r test_MIRA_2018March_MTBF20min_downtime1h_${e}_111
done 





mkdir test_MIRA_2018March_MTBF1h_downtime10min

for e in {0..4}
do
    cp ./test_MIRA_2018March_MTBF1h_downtime10min_${e}_0/COMPLETED_KILLED.txt ./test_MIRA_2018March_MTBF1h_downtime10min/COMPLETED_KILLED_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF1h_downtime10min_${e}_0/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2018March_MTBF1h_downtime10min/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF1h_downtime10min_${e}_0/node_stealing_info.txt ./test_MIRA_2018March_MTBF1h_downtime10min/node_stealing_info_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF1h_downtime10min_${e}_0/log_${e}_0/expe_${e}_0_jobs.csv ./test_MIRA_2018March_MTBF1h_downtime10min/expe_${e}_0_jobs.csv
    cp ./test_MIRA_2018March_MTBF1h_downtime10min_${e}_0/log_${e}_0/expe_${e}_0_machine_states.csv ./test_MIRA_2018March_MTBF1h_downtime10min/expe_${e}_0_machine_states.csv
    cp ./test_MIRA_2018March_MTBF1h_downtime10min_${e}_0/log_${e}_0/expe_${e}_0_schedule.csv ./test_MIRA_2018March_MTBF1h_downtime10min/expe_${e}_0_schedule.csv


    cp ./test_MIRA_2018March_MTBF1h_downtime10min_${e}_111/COMPLETED_KILLED.txt ./test_MIRA_2018March_MTBF1h_downtime10min/COMPLETED_KILLED_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF1h_downtime10min_${e}_111/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2018March_MTBF1h_downtime10min/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF1h_downtime10min_${e}_111/node_stealing_info.txt ./test_MIRA_2018March_MTBF1h_downtime10min/node_stealing_info_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF1h_downtime10min_${e}_111/node_stealing_times.txt ./test_MIRA_2018March_MTBF1h_downtime10min/node_stealing_times_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF1h_downtime10min_${e}_111/log_${e}_111/expe_${e}_111_jobs.csv ./test_MIRA_2018March_MTBF1h_downtime10min/expe_${e}_111_jobs.csv
    cp ./test_MIRA_2018March_MTBF1h_downtime10min_${e}_111/log_${e}_111/expe_${e}_111_machine_states.csv ./test_MIRA_2018March_MTBF1h_downtime10min/expe_${e}_111_machine_states.csv
    cp ./test_MIRA_2018March_MTBF1h_downtime10min_${e}_111/log_${e}_111/expe_${e}_111_schedule.csv ./test_MIRA_2018March_MTBF1h_downtime10min/expe_${e}_111_schedule.csv
done 

for e in {0..4}
do
    rm -r test_MIRA_2018March_MTBF1h_downtime10min_${e}_0
    rm -r test_MIRA_2018March_MTBF1h_downtime10min_${e}_111
done 

mkdir test_MIRA_2018March_MTBF2h_downtime10min

for e in {0..4}
do
    cp ./test_MIRA_2018March_MTBF2h_downtime10min_${e}_0/COMPLETED_KILLED.txt ./test_MIRA_2018March_MTBF2h_downtime10min/COMPLETED_KILLED_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF2h_downtime10min_${e}_0/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2018March_MTBF2h_downtime10min/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF2h_downtime10min_${e}_0/node_stealing_info.txt ./test_MIRA_2018March_MTBF2h_downtime10min/node_stealing_info_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF2h_downtime10min_${e}_0/log_${e}_0/expe_${e}_0_jobs.csv ./test_MIRA_2018March_MTBF2h_downtime10min/expe_${e}_0_jobs.csv
    cp ./test_MIRA_2018March_MTBF2h_downtime10min_${e}_0/log_${e}_0/expe_${e}_0_machine_states.csv ./test_MIRA_2018March_MTBF2h_downtime10min/expe_${e}_0_machine_states.csv
    cp ./test_MIRA_2018March_MTBF2h_downtime10min_${e}_0/log_${e}_0/expe_${e}_0_schedule.csv ./test_MIRA_2018March_MTBF2h_downtime10min/expe_${e}_0_schedule.csv


    cp ./test_MIRA_2018March_MTBF2h_downtime10min_${e}_111/COMPLETED_KILLED.txt ./test_MIRA_2018March_MTBF2h_downtime10min/COMPLETED_KILLED_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF2h_downtime10min_${e}_111/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2018March_MTBF2h_downtime10min/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF2h_downtime10min_${e}_111/node_stealing_info.txt ./test_MIRA_2018March_MTBF2h_downtime10min/node_stealing_info_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF2h_downtime10min_${e}_111/node_stealing_times.txt ./test_MIRA_2018March_MTBF2h_downtime10min/node_stealing_times_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF2h_downtime10min_${e}_111/log_${e}_111/expe_${e}_111_jobs.csv ./test_MIRA_2018March_MTBF2h_downtime10min/expe_${e}_111_jobs.csv
    cp ./test_MIRA_2018March_MTBF2h_downtime10min_${e}_111/log_${e}_111/expe_${e}_111_machine_states.csv ./test_MIRA_2018March_MTBF2h_downtime10min/expe_${e}_111_machine_states.csv
    cp ./test_MIRA_2018March_MTBF2h_downtime10min_${e}_111/log_${e}_111/expe_${e}_111_schedule.csv ./test_MIRA_2018March_MTBF2h_downtime10min/expe_${e}_111_schedule.csv
done 

for e in {0..4}
do
    rm -r test_MIRA_2018March_MTBF2h_downtime10min_${e}_0
    rm -r test_MIRA_2018March_MTBF2h_downtime10min_${e}_111
done 


mkdir test_MIRA_2018March_MTBF5h_downtime10min

for e in {0..4}
do
    cp ./test_MIRA_2018March_MTBF5h_downtime10min_${e}_0/COMPLETED_KILLED.txt ./test_MIRA_2018March_MTBF5h_downtime10min/COMPLETED_KILLED_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF5h_downtime10min_${e}_0/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2018March_MTBF5h_downtime10min/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF5h_downtime10min_${e}_0/node_stealing_info.txt ./test_MIRA_2018March_MTBF5h_downtime10min/node_stealing_info_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF5h_downtime10min_${e}_0/log_${e}_0/expe_${e}_0_jobs.csv ./test_MIRA_2018March_MTBF5h_downtime10min/expe_${e}_0_jobs.csv
    cp ./test_MIRA_2018March_MTBF5h_downtime10min_${e}_0/log_${e}_0/expe_${e}_0_machine_states.csv ./test_MIRA_2018March_MTBF5h_downtime10min/expe_${e}_0_machine_states.csv
    cp ./test_MIRA_2018March_MTBF5h_downtime10min_${e}_0/log_${e}_0/expe_${e}_0_schedule.csv ./test_MIRA_2018March_MTBF5h_downtime10min/expe_${e}_0_schedule.csv


    cp ./test_MIRA_2018March_MTBF5h_downtime10min_${e}_111/COMPLETED_KILLED.txt ./test_MIRA_2018March_MTBF5h_downtime10min/COMPLETED_KILLED_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF5h_downtime10min_${e}_111/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2018March_MTBF5h_downtime10min/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF5h_downtime10min_${e}_111/node_stealing_info.txt ./test_MIRA_2018March_MTBF5h_downtime10min/node_stealing_info_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF5h_downtime10min_${e}_111/node_stealing_times.txt ./test_MIRA_2018March_MTBF5h_downtime10min/node_stealing_times_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF5h_downtime10min_${e}_111/log_${e}_111/expe_${e}_111_jobs.csv ./test_MIRA_2018March_MTBF5h_downtime10min/expe_${e}_111_jobs.csv
    cp ./test_MIRA_2018March_MTBF5h_downtime10min_${e}_111/log_${e}_111/expe_${e}_111_machine_states.csv ./test_MIRA_2018March_MTBF5h_downtime10min/expe_${e}_111_machine_states.csv
    cp ./test_MIRA_2018March_MTBF5h_downtime10min_${e}_111/log_${e}_111/expe_${e}_111_schedule.csv ./test_MIRA_2018March_MTBF5h_downtime10min/expe_${e}_111_schedule.csv
done 

for e in {0..4}
do
    rm -r test_MIRA_2018March_MTBF5h_downtime10min_${e}_0
    rm -r test_MIRA_2018March_MTBF5h_downtime10min_${e}_111
done 


mkdir test_MIRA_2018March_MTBF10h_downtime10min

for e in {0..4}
do
    cp ./test_MIRA_2018March_MTBF10h_downtime10min_${e}_0/COMPLETED_KILLED.txt ./test_MIRA_2018March_MTBF10h_downtime10min/COMPLETED_KILLED_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF10h_downtime10min_${e}_0/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2018March_MTBF10h_downtime10min/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF10h_downtime10min_${e}_0/node_stealing_info.txt ./test_MIRA_2018March_MTBF10h_downtime10min/node_stealing_info_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF10h_downtime10min_${e}_0/log_${e}_0/expe_${e}_0_jobs.csv ./test_MIRA_2018March_MTBF10h_downtime10min/expe_${e}_0_jobs.csv
    cp ./test_MIRA_2018March_MTBF10h_downtime10min_${e}_0/log_${e}_0/expe_${e}_0_machine_states.csv ./test_MIRA_2018March_MTBF10h_downtime10min/expe_${e}_0_machine_states.csv
    cp ./test_MIRA_2018March_MTBF10h_downtime10min_${e}_0/log_${e}_0/expe_${e}_0_schedule.csv ./test_MIRA_2018March_MTBF10h_downtime10min/expe_${e}_0_schedule.csv


    cp ./test_MIRA_2018March_MTBF10h_downtime10min_${e}_111/COMPLETED_KILLED.txt ./test_MIRA_2018March_MTBF10h_downtime10min/COMPLETED_KILLED_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF10h_downtime10min_${e}_111/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2018March_MTBF10h_downtime10min/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF10h_downtime10min_${e}_111/node_stealing_info.txt ./test_MIRA_2018March_MTBF10h_downtime10min/node_stealing_info_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF10h_downtime10min_${e}_111/node_stealing_times.txt ./test_MIRA_2018March_MTBF10h_downtime10min/node_stealing_times_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF10h_downtime10min_${e}_111/log_${e}_111/expe_${e}_111_jobs.csv ./test_MIRA_2018March_MTBF10h_downtime10min/expe_${e}_111_jobs.csv
    cp ./test_MIRA_2018March_MTBF10h_downtime10min_${e}_111/log_${e}_111/expe_${e}_111_machine_states.csv ./test_MIRA_2018March_MTBF10h_downtime10min/expe_${e}_111_machine_states.csv
    cp ./test_MIRA_2018March_MTBF10h_downtime10min_${e}_111/log_${e}_111/expe_${e}_111_schedule.csv ./test_MIRA_2018March_MTBF10h_downtime10min/expe_${e}_111_schedule.csv
done 

for e in {0..4}
do
    rm -r test_MIRA_2018March_MTBF10h_downtime10min_${e}_0
    rm -r test_MIRA_2018March_MTBF10h_downtime10min_${e}_111
done 


mkdir test_MIRA_2018March_MTBF40min_downtime10min

for e in {0..4}
do
    cp ./test_MIRA_2018March_MTBF40min_downtime10min_${e}_0/COMPLETED_KILLED.txt ./test_MIRA_2018March_MTBF40min_downtime10min/COMPLETED_KILLED_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF40min_downtime10min_${e}_0/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2018March_MTBF40min_downtime10min/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF40min_downtime10min_${e}_0/node_stealing_info.txt ./test_MIRA_2018March_MTBF40min_downtime10min/node_stealing_info_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF40min_downtime10min_${e}_0/log_${e}_0/expe_${e}_0_jobs.csv ./test_MIRA_2018March_MTBF40min_downtime10min/expe_${e}_0_jobs.csv
    cp ./test_MIRA_2018March_MTBF40min_downtime10min_${e}_0/log_${e}_0/expe_${e}_0_machine_states.csv ./test_MIRA_2018March_MTBF40min_downtime10min/expe_${e}_0_machine_states.csv
    cp ./test_MIRA_2018March_MTBF40min_downtime10min_${e}_0/log_${e}_0/expe_${e}_0_schedule.csv ./test_MIRA_2018March_MTBF40min_downtime10min/expe_${e}_0_schedule.csv


    cp ./test_MIRA_2018March_MTBF40min_downtime10min_${e}_111/COMPLETED_KILLED.txt ./test_MIRA_2018March_MTBF40min_downtime10min/COMPLETED_KILLED_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF40min_downtime10min_${e}_111/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2018March_MTBF40min_downtime10min/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF40min_downtime10min_${e}_111/node_stealing_info.txt ./test_MIRA_2018March_MTBF40min_downtime10min/node_stealing_info_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF40min_downtime10min_${e}_111/node_stealing_times.txt ./test_MIRA_2018March_MTBF40min_downtime10min/node_stealing_times_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF40min_downtime10min_${e}_111/log_${e}_111/expe_${e}_111_jobs.csv ./test_MIRA_2018March_MTBF40min_downtime10min/expe_${e}_111_jobs.csv
    cp ./test_MIRA_2018March_MTBF40min_downtime10min_${e}_111/log_${e}_111/expe_${e}_111_machine_states.csv ./test_MIRA_2018March_MTBF40min_downtime10min/expe_${e}_111_machine_states.csv
    cp ./test_MIRA_2018March_MTBF40min_downtime10min_${e}_111/log_${e}_111/expe_${e}_111_schedule.csv ./test_MIRA_2018March_MTBF40min_downtime10min/expe_${e}_111_schedule.csv
done 

for e in {0..4}
do
    rm -r test_MIRA_2018March_MTBF40min_downtime10min_${e}_0
    rm -r test_MIRA_2018March_MTBF40min_downtime10min_${e}_111
done 


mkdir test_MIRA_2018March_MTBF20min_downtime10min

for e in {0..4}
do
    cp ./test_MIRA_2018March_MTBF20min_downtime10min_${e}_0/COMPLETED_KILLED.txt ./test_MIRA_2018March_MTBF20min_downtime10min/COMPLETED_KILLED_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF20min_downtime10min_${e}_0/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2018March_MTBF20min_downtime10min/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF20min_downtime10min_${e}_0/node_stealing_info.txt ./test_MIRA_2018March_MTBF20min_downtime10min/node_stealing_info_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF20min_downtime10min_${e}_0/log_${e}_0/expe_${e}_0_jobs.csv ./test_MIRA_2018March_MTBF20min_downtime10min/expe_${e}_0_jobs.csv
    cp ./test_MIRA_2018March_MTBF20min_downtime10min_${e}_0/log_${e}_0/expe_${e}_0_machine_states.csv ./test_MIRA_2018March_MTBF20min_downtime10min/expe_${e}_0_machine_states.csv
    cp ./test_MIRA_2018March_MTBF20min_downtime10min_${e}_0/log_${e}_0/expe_${e}_0_schedule.csv ./test_MIRA_2018March_MTBF20min_downtime10min/expe_${e}_0_schedule.csv


    cp ./test_MIRA_2018March_MTBF20min_downtime10min_${e}_111/COMPLETED_KILLED.txt ./test_MIRA_2018March_MTBF20min_downtime10min/COMPLETED_KILLED_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF20min_downtime10min_${e}_111/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2018March_MTBF20min_downtime10min/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF20min_downtime10min_${e}_111/node_stealing_info.txt ./test_MIRA_2018March_MTBF20min_downtime10min/node_stealing_info_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF20min_downtime10min_${e}_111/node_stealing_times.txt ./test_MIRA_2018March_MTBF20min_downtime10min/node_stealing_times_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF20min_downtime10min_${e}_111/log_${e}_111/expe_${e}_111_jobs.csv ./test_MIRA_2018March_MTBF20min_downtime10min/expe_${e}_111_jobs.csv
    cp ./test_MIRA_2018March_MTBF20min_downtime10min_${e}_111/log_${e}_111/expe_${e}_111_machine_states.csv ./test_MIRA_2018March_MTBF20min_downtime10min/expe_${e}_111_machine_states.csv
    cp ./test_MIRA_2018March_MTBF20min_downtime10min_${e}_111/log_${e}_111/expe_${e}_111_schedule.csv ./test_MIRA_2018March_MTBF20min_downtime10min/expe_${e}_111_schedule.csv
done 

for e in {0..4}
do
    rm -r test_MIRA_2018March_MTBF20min_downtime10min_${e}_0
    rm -r test_MIRA_2018March_MTBF20min_downtime10min_${e}_111
done 


mkdir test_MIRA_2018March_MTBF1h_downtime1day

for e in {0..4}
do
    cp ./test_MIRA_2018March_MTBF1h_downtime1day_${e}_0/COMPLETED_KILLED.txt ./test_MIRA_2018March_MTBF1h_downtime1day/COMPLETED_KILLED_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF1h_downtime1day_${e}_0/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2018March_MTBF1h_downtime1day/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF1h_downtime1day_${e}_0/node_stealing_info.txt ./test_MIRA_2018March_MTBF1h_downtime1day/node_stealing_info_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF1h_downtime1day_${e}_0/log_${e}_0/expe_${e}_0_jobs.csv ./test_MIRA_2018March_MTBF1h_downtime1day/expe_${e}_0_jobs.csv
    cp ./test_MIRA_2018March_MTBF1h_downtime1day_${e}_0/log_${e}_0/expe_${e}_0_machine_states.csv ./test_MIRA_2018March_MTBF1h_downtime1day/expe_${e}_0_machine_states.csv
    cp ./test_MIRA_2018March_MTBF1h_downtime1day_${e}_0/log_${e}_0/expe_${e}_0_schedule.csv ./test_MIRA_2018March_MTBF1h_downtime1day/expe_${e}_0_schedule.csv


    cp ./test_MIRA_2018March_MTBF1h_downtime1day_${e}_111/COMPLETED_KILLED.txt ./test_MIRA_2018March_MTBF1h_downtime1day/COMPLETED_KILLED_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF1h_downtime1day_${e}_111/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2018March_MTBF1h_downtime1day/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF1h_downtime1day_${e}_111/node_stealing_info.txt ./test_MIRA_2018March_MTBF1h_downtime1day/node_stealing_info_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF1h_downtime1day_${e}_111/node_stealing_times.txt ./test_MIRA_2018March_MTBF1h_downtime1day/node_stealing_times_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF1h_downtime1day_${e}_111/log_${e}_111/expe_${e}_111_jobs.csv ./test_MIRA_2018March_MTBF1h_downtime1day/expe_${e}_111_jobs.csv
    cp ./test_MIRA_2018March_MTBF1h_downtime1day_${e}_111/log_${e}_111/expe_${e}_111_machine_states.csv ./test_MIRA_2018March_MTBF1h_downtime1day/expe_${e}_111_machine_states.csv
    cp ./test_MIRA_2018March_MTBF1h_downtime1day_${e}_111/log_${e}_111/expe_${e}_111_schedule.csv ./test_MIRA_2018March_MTBF1h_downtime1day/expe_${e}_111_schedule.csv
done 

for e in {0..4}
do
    rm -r test_MIRA_2018March_MTBF1h_downtime1day_${e}_0
    rm -r test_MIRA_2018March_MTBF1h_downtime1day_${e}_111
done 

mkdir test_MIRA_2018March_MTBF2h_downtime1day

for e in {0..4}
do
    cp ./test_MIRA_2018March_MTBF2h_downtime1day_${e}_0/COMPLETED_KILLED.txt ./test_MIRA_2018March_MTBF2h_downtime1day/COMPLETED_KILLED_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF2h_downtime1day_${e}_0/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2018March_MTBF2h_downtime1day/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF2h_downtime1day_${e}_0/node_stealing_info.txt ./test_MIRA_2018March_MTBF2h_downtime1day/node_stealing_info_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF2h_downtime1day_${e}_0/log_${e}_0/expe_${e}_0_jobs.csv ./test_MIRA_2018March_MTBF2h_downtime1day/expe_${e}_0_jobs.csv
    cp ./test_MIRA_2018March_MTBF2h_downtime1day_${e}_0/log_${e}_0/expe_${e}_0_machine_states.csv ./test_MIRA_2018March_MTBF2h_downtime1day/expe_${e}_0_machine_states.csv
    cp ./test_MIRA_2018March_MTBF2h_downtime1day_${e}_0/log_${e}_0/expe_${e}_0_schedule.csv ./test_MIRA_2018March_MTBF2h_downtime1day/expe_${e}_0_schedule.csv


    cp ./test_MIRA_2018March_MTBF2h_downtime1day_${e}_111/COMPLETED_KILLED.txt ./test_MIRA_2018March_MTBF2h_downtime1day/COMPLETED_KILLED_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF2h_downtime1day_${e}_111/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2018March_MTBF2h_downtime1day/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF2h_downtime1day_${e}_111/node_stealing_info.txt ./test_MIRA_2018March_MTBF2h_downtime1day/node_stealing_info_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF2h_downtime1day_${e}_111/node_stealing_times.txt ./test_MIRA_2018March_MTBF2h_downtime1day/node_stealing_times_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF2h_downtime1day_${e}_111/log_${e}_111/expe_${e}_111_jobs.csv ./test_MIRA_2018March_MTBF2h_downtime1day/expe_${e}_111_jobs.csv
    cp ./test_MIRA_2018March_MTBF2h_downtime1day_${e}_111/log_${e}_111/expe_${e}_111_machine_states.csv ./test_MIRA_2018March_MTBF2h_downtime1day/expe_${e}_111_machine_states.csv
    cp ./test_MIRA_2018March_MTBF2h_downtime1day_${e}_111/log_${e}_111/expe_${e}_111_schedule.csv ./test_MIRA_2018March_MTBF2h_downtime1day/expe_${e}_111_schedule.csv
done 

for e in {0..4}
do
    rm -r test_MIRA_2018March_MTBF2h_downtime1day_${e}_0
    rm -r test_MIRA_2018March_MTBF2h_downtime1day_${e}_111
done 


mkdir test_MIRA_2018March_MTBF5h_downtime1day

for e in {0..4}
do
    cp ./test_MIRA_2018March_MTBF5h_downtime1day_${e}_0/COMPLETED_KILLED.txt ./test_MIRA_2018March_MTBF5h_downtime1day/COMPLETED_KILLED_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF5h_downtime1day_${e}_0/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2018March_MTBF5h_downtime1day/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF5h_downtime1day_${e}_0/node_stealing_info.txt ./test_MIRA_2018March_MTBF5h_downtime1day/node_stealing_info_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF5h_downtime1day_${e}_0/log_${e}_0/expe_${e}_0_jobs.csv ./test_MIRA_2018March_MTBF5h_downtime1day/expe_${e}_0_jobs.csv
    cp ./test_MIRA_2018March_MTBF5h_downtime1day_${e}_0/log_${e}_0/expe_${e}_0_machine_states.csv ./test_MIRA_2018March_MTBF5h_downtime1day/expe_${e}_0_machine_states.csv
    cp ./test_MIRA_2018March_MTBF5h_downtime1day_${e}_0/log_${e}_0/expe_${e}_0_schedule.csv ./test_MIRA_2018March_MTBF5h_downtime1day/expe_${e}_0_schedule.csv


    cp ./test_MIRA_2018March_MTBF5h_downtime1day_${e}_111/COMPLETED_KILLED.txt ./test_MIRA_2018March_MTBF5h_downtime1day/COMPLETED_KILLED_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF5h_downtime1day_${e}_111/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2018March_MTBF5h_downtime1day/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF5h_downtime1day_${e}_111/node_stealing_info.txt ./test_MIRA_2018March_MTBF5h_downtime1day/node_stealing_info_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF5h_downtime1day_${e}_111/node_stealing_times.txt ./test_MIRA_2018March_MTBF5h_downtime1day/node_stealing_times_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF5h_downtime1day_${e}_111/log_${e}_111/expe_${e}_111_jobs.csv ./test_MIRA_2018March_MTBF5h_downtime1day/expe_${e}_111_jobs.csv
    cp ./test_MIRA_2018March_MTBF5h_downtime1day_${e}_111/log_${e}_111/expe_${e}_111_machine_states.csv ./test_MIRA_2018March_MTBF5h_downtime1day/expe_${e}_111_machine_states.csv
    cp ./test_MIRA_2018March_MTBF5h_downtime1day_${e}_111/log_${e}_111/expe_${e}_111_schedule.csv ./test_MIRA_2018March_MTBF5h_downtime1day/expe_${e}_111_schedule.csv
done 

for e in {0..4}
do
    rm -r test_MIRA_2018March_MTBF5h_downtime1day_${e}_0
    rm -r test_MIRA_2018March_MTBF5h_downtime1day_${e}_111
done 


mkdir test_MIRA_2018March_MTBF10h_downtime1day

for e in {0..4}
do
    cp ./test_MIRA_2018March_MTBF10h_downtime1day_${e}_0/COMPLETED_KILLED.txt ./test_MIRA_2018March_MTBF10h_downtime1day/COMPLETED_KILLED_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF10h_downtime1day_${e}_0/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2018March_MTBF10h_downtime1day/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF10h_downtime1day_${e}_0/node_stealing_info.txt ./test_MIRA_2018March_MTBF10h_downtime1day/node_stealing_info_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF10h_downtime1day_${e}_0/log_${e}_0/expe_${e}_0_jobs.csv ./test_MIRA_2018March_MTBF10h_downtime1day/expe_${e}_0_jobs.csv
    cp ./test_MIRA_2018March_MTBF10h_downtime1day_${e}_0/log_${e}_0/expe_${e}_0_machine_states.csv ./test_MIRA_2018March_MTBF10h_downtime1day/expe_${e}_0_machine_states.csv
    cp ./test_MIRA_2018March_MTBF10h_downtime1day_${e}_0/log_${e}_0/expe_${e}_0_schedule.csv ./test_MIRA_2018March_MTBF10h_downtime1day/expe_${e}_0_schedule.csv


    cp ./test_MIRA_2018March_MTBF10h_downtime1day_${e}_111/COMPLETED_KILLED.txt ./test_MIRA_2018March_MTBF10h_downtime1day/COMPLETED_KILLED_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF10h_downtime1day_${e}_111/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2018March_MTBF10h_downtime1day/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF10h_downtime1day_${e}_111/node_stealing_info.txt ./test_MIRA_2018March_MTBF10h_downtime1day/node_stealing_info_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF10h_downtime1day_${e}_111/node_stealing_times.txt ./test_MIRA_2018March_MTBF10h_downtime1day/node_stealing_times_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF10h_downtime1day_${e}_111/log_${e}_111/expe_${e}_111_jobs.csv ./test_MIRA_2018March_MTBF10h_downtime1day/expe_${e}_111_jobs.csv
    cp ./test_MIRA_2018March_MTBF10h_downtime1day_${e}_111/log_${e}_111/expe_${e}_111_machine_states.csv ./test_MIRA_2018March_MTBF10h_downtime1day/expe_${e}_111_machine_states.csv
    cp ./test_MIRA_2018March_MTBF10h_downtime1day_${e}_111/log_${e}_111/expe_${e}_111_schedule.csv ./test_MIRA_2018March_MTBF10h_downtime1day/expe_${e}_111_schedule.csv
done 

for e in {0..4}
do
    rm -r test_MIRA_2018March_MTBF10h_downtime1day_${e}_0
    rm -r test_MIRA_2018March_MTBF10h_downtime1day_${e}_111
done 


mkdir test_MIRA_2018March_MTBF40min_downtime1day

for e in {0..4}
do
    cp ./test_MIRA_2018March_MTBF40min_downtime1day_${e}_0/COMPLETED_KILLED.txt ./test_MIRA_2018March_MTBF40min_downtime1day/COMPLETED_KILLED_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF40min_downtime1day_${e}_0/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2018March_MTBF40min_downtime1day/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF40min_downtime1day_${e}_0/node_stealing_info.txt ./test_MIRA_2018March_MTBF40min_downtime1day/node_stealing_info_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF40min_downtime1day_${e}_0/log_${e}_0/expe_${e}_0_jobs.csv ./test_MIRA_2018March_MTBF40min_downtime1day/expe_${e}_0_jobs.csv
    cp ./test_MIRA_2018March_MTBF40min_downtime1day_${e}_0/log_${e}_0/expe_${e}_0_machine_states.csv ./test_MIRA_2018March_MTBF40min_downtime1day/expe_${e}_0_machine_states.csv
    cp ./test_MIRA_2018March_MTBF40min_downtime1day_${e}_0/log_${e}_0/expe_${e}_0_schedule.csv ./test_MIRA_2018March_MTBF40min_downtime1day/expe_${e}_0_schedule.csv


    cp ./test_MIRA_2018March_MTBF40min_downtime1day_${e}_111/COMPLETED_KILLED.txt ./test_MIRA_2018March_MTBF40min_downtime1day/COMPLETED_KILLED_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF40min_downtime1day_${e}_111/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2018March_MTBF40min_downtime1day/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF40min_downtime1day_${e}_111/node_stealing_info.txt ./test_MIRA_2018March_MTBF40min_downtime1day/node_stealing_info_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF40min_downtime1day_${e}_111/node_stealing_times.txt ./test_MIRA_2018March_MTBF40min_downtime1day/node_stealing_times_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF40min_downtime1day_${e}_111/log_${e}_111/expe_${e}_111_jobs.csv ./test_MIRA_2018March_MTBF40min_downtime1day/expe_${e}_111_jobs.csv
    cp ./test_MIRA_2018March_MTBF40min_downtime1day_${e}_111/log_${e}_111/expe_${e}_111_machine_states.csv ./test_MIRA_2018March_MTBF40min_downtime1day/expe_${e}_111_machine_states.csv
    cp ./test_MIRA_2018March_MTBF40min_downtime1day_${e}_111/log_${e}_111/expe_${e}_111_schedule.csv ./test_MIRA_2018March_MTBF40min_downtime1day/expe_${e}_111_schedule.csv
done 

for e in {0..4}
do
    rm -r test_MIRA_2018March_MTBF40min_downtime1day_${e}_0
    rm -r test_MIRA_2018March_MTBF40min_downtime1day_${e}_111
done 


mkdir test_MIRA_2018March_MTBF20min_downtime1day

for e in {0..4}
do
    cp ./test_MIRA_2018March_MTBF20min_downtime1day_${e}_0/COMPLETED_KILLED.txt ./test_MIRA_2018March_MTBF20min_downtime1day/COMPLETED_KILLED_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF20min_downtime1day_${e}_0/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2018March_MTBF20min_downtime1day/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF20min_downtime1day_${e}_0/node_stealing_info.txt ./test_MIRA_2018March_MTBF20min_downtime1day/node_stealing_info_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF20min_downtime1day_${e}_0/log_${e}_0/expe_${e}_0_jobs.csv ./test_MIRA_2018March_MTBF20min_downtime1day/expe_${e}_0_jobs.csv
    cp ./test_MIRA_2018March_MTBF20min_downtime1day_${e}_0/log_${e}_0/expe_${e}_0_machine_states.csv ./test_MIRA_2018March_MTBF20min_downtime1day/expe_${e}_0_machine_states.csv
    cp ./test_MIRA_2018March_MTBF20min_downtime1day_${e}_0/log_${e}_0/expe_${e}_0_schedule.csv ./test_MIRA_2018March_MTBF20min_downtime1day/expe_${e}_0_schedule.csv


    cp ./test_MIRA_2018March_MTBF20min_downtime1day_${e}_111/COMPLETED_KILLED.txt ./test_MIRA_2018March_MTBF20min_downtime1day/COMPLETED_KILLED_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF20min_downtime1day_${e}_111/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2018March_MTBF20min_downtime1day/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF20min_downtime1day_${e}_111/node_stealing_info.txt ./test_MIRA_2018March_MTBF20min_downtime1day/node_stealing_info_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF20min_downtime1day_${e}_111/node_stealing_times.txt ./test_MIRA_2018March_MTBF20min_downtime1day/node_stealing_times_${e}_111.txt
    cp ./test_MIRA_2018March_MTBF20min_downtime1day_${e}_111/log_${e}_111/expe_${e}_111_jobs.csv ./test_MIRA_2018March_MTBF20min_downtime1day/expe_${e}_111_jobs.csv
    cp ./test_MIRA_2018March_MTBF20min_downtime1day_${e}_111/log_${e}_111/expe_${e}_111_machine_states.csv ./test_MIRA_2018March_MTBF20min_downtime1day/expe_${e}_111_machine_states.csv
    cp ./test_MIRA_2018March_MTBF20min_downtime1day_${e}_111/log_${e}_111/expe_${e}_111_schedule.csv ./test_MIRA_2018March_MTBF20min_downtime1day/expe_${e}_111_schedule.csv
done 

for e in {0..4}
do
    rm -r test_MIRA_2018March_MTBF20min_downtime1day_${e}_0
    rm -r test_MIRA_2018March_MTBF20min_downtime1day_${e}_111
done 



###catelog all heuristic simulation results for June 2017
mkdir test_MIRA_2017June_MTBF1h_downtime1h_allheuristics

for e in {0..4}
do
    cp ./test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_0/COMPLETED_KILLED.txt ./test_MIRA_2017June_MTBF1h_downtime1h_allheuristics/COMPLETED_KILLED_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_0/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2017June_MTBF1h_downtime1h_allheuristics/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_0/node_stealing_info.txt ./test_MIRA_2017June_MTBF1h_downtime1h_allheuristics/node_stealing_info_${e}_0.txt
    cp ./test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_0/log_${e}_0/expe_${e}_0_jobs.csv ./test_MIRA_2017June_MTBF1h_downtime1h_allheuristics/expe_${e}_0_jobs.csv
    cp ./test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_0/log_${e}_0/expe_${e}_0_machine_states.csv ./test_MIRA_2017June_MTBF1h_downtime1h_allheuristics/expe_${e}_0_machine_states.csv
    cp ./test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_0/log_${e}_0/expe_${e}_0_schedule.csv ./test_MIRA_2017June_MTBF1h_downtime1h_allheuristics/expe_${e}_0_schedule.csv
       
    for h in 1 2 3
    do
        for v in 1 2
        do
            for k in 1 2 3
            do
                cp ./test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_$h$v$k/COMPLETED_KILLED.txt ./test_MIRA_2017June_MTBF1h_downtime1h_allheuristics/COMPLETED_KILLED_${e}_$h$v$k.txt
                cp ./test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_$h$v$k/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2017June_MTBF1h_downtime1h_allheuristics/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_$h$v$k.txt
                cp ./test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_$h$v$k/node_stealing_info.txt ./test_MIRA_2017June_MTBF1h_downtime1h_allheuristics/node_stealing_info_${e}_$h$v$k.txt
                cp ./test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_$h$v$k/node_stealing_times.txt ./test_MIRA_2017June_MTBF1h_downtime1h_allheuristics/node_stealing_times_${e}_$h$v$k.txt
                cp ./test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_$h$v$k/log_${e}_$h$v$k/expe_${e}_$h$v${k}_jobs.csv ./test_MIRA_2017June_MTBF1h_downtime1h_allheuristics/expe_${e}_$h$v${k}_jobs.csv
                cp ./test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_$h$v$k/log_${e}_$h$v$k/expe_${e}_$h$v${k}_machine_states.csv ./test_MIRA_2017June_MTBF1h_downtime1h_allheuristics/expe_${e}_$h$v${k}_machine_states.csv
                cp ./test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_$h$v$k/log_${e}_$h$v$k/expe_${e}_$h$v${k}_schedule.csv ./test_MIRA_2017June_MTBF1h_downtime1h_allheuristics/expe_${e}_$h$v${k}_schedule.csv
            done
        done
    done
done 

for e in {0..4}
do
    rm -r test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_0

    for h in 1 2 3
    do
        for v in 1 2
        do
            for k in 1 2 3
            do
                rm -r test_MIRA_2017June_MTBF1h_downtime1h_allheuristics_${e}_$h$v$k
            done
        done
    done
done 


###catelog all heuristic simulation results for March 2018
mkdir test_MIRA_2018March_MTBF1h_downtime1h_allheuristics

for e in {0..4}
do
    cp ./test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_0/COMPLETED_KILLED.txt ./test_MIRA_2018March_MTBF1h_downtime1h_allheuristics/COMPLETED_KILLED_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_0/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2018March_MTBF1h_downtime1h_allheuristics/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_0/node_stealing_info.txt ./test_MIRA_2018March_MTBF1h_downtime1h_allheuristics/node_stealing_info_${e}_0.txt
    cp ./test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_0/log_${e}_0/expe_${e}_0_jobs.csv ./test_MIRA_2018March_MTBF1h_downtime1h_allheuristics/expe_${e}_0_jobs.csv
    cp ./test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_0/log_${e}_0/expe_${e}_0_machine_states.csv ./test_MIRA_2018March_MTBF1h_downtime1h_allheuristics/expe_${e}_0_machine_states.csv
    cp ./test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_0/log_${e}_0/expe_${e}_0_schedule.csv ./test_MIRA_2018March_MTBF1h_downtime1h_allheuristics/expe_${e}_0_schedule.csv
       
    for h in 1 2 3
    do
        for v in 1 2
        do
            for k in 1 2 3
            do
                cp ./test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_$h$v$k/COMPLETED_KILLED.txt ./test_MIRA_2018March_MTBF1h_downtime1h_allheuristics/COMPLETED_KILLED_${e}_$h$v$k.txt
                cp ./test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_$h$v$k/COMPLETED_SUCCESSFULLY_JOBCOPY.txt ./test_MIRA_2018March_MTBF1h_downtime1h_allheuristics/COMPLETED_SUCCESSFULLY_JOBCOPY_${e}_$h$v$k.txt
                cp ./test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_$h$v$k/node_stealing_info.txt ./test_MIRA_2018March_MTBF1h_downtime1h_allheuristics/node_stealing_info_${e}_$h$v$k.txt
                cp ./test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_$h$v$k/node_stealing_times.txt ./test_MIRA_2018March_MTBF1h_downtime1h_allheuristics/node_stealing_times_${e}_$h$v$k.txt
                cp ./test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_$h$v$k/log_${e}_$h$v$k/expe_${e}_$h$v${k}_jobs.csv ./test_MIRA_2018March_MTBF1h_downtime1h_allheuristics/expe_${e}_$h$v${k}_jobs.csv
                cp ./test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_$h$v$k/log_${e}_$h$v$k/expe_${e}_$h$v${k}_machine_states.csv ./test_MIRA_2018March_MTBF1h_downtime1h_allheuristics/expe_${e}_$h$v${k}_machine_states.csv
                cp ./test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_$h$v$k/log_${e}_$h$v$k/expe_${e}_$h$v${k}_schedule.csv ./test_MIRA_2018March_MTBF1h_downtime1h_allheuristics/expe_${e}_$h$v${k}_schedule.csv
            done
        done
    done
done 

for e in {0..4}
do
    rm -r test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_0

    for h in 1 2 3
    do
        for v in 1 2
        do
            for k in 1 2 3
            do
                rm -r test_MIRA_2018March_MTBF1h_downtime1h_allheuristics_${e}_$h$v$k
            done
        done
    done
done 