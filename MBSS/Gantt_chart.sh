#!/bin/bash
# bash Gantt_chart.sh inputs/workloads/converted/test-11 inputs/clusters/rackham_4nodes.txt Fcfs 1 0
start=`date +%s`

# Get arguments
WORKLOAD=$1
WORKLOAD_TP=${WORKLOAD:27}
CLUSTER=$2
CLUSTER_TP=${CLUSTER:24}
CLUSTER_TP=${CLUSTER_TP::-4}
SCHEDULER=$3
DATE=${WORKLOAD:27:30}
CONTRAINTES_TAILLES=$4
BACKFILL_MODE=$5

# Header
echo "job_id,workload_name,profile,submission_time,requested_number_of_resources,requested_time,success,final_state,starting_time,execution_time,finish_time,waiting_time,turnaround_time,stretch,allocated_resources,consumed_energy,metadata" > "outputs/Results_all_jobs_$3.csv"

#~ make print_gantt_chart -C C/
make print_print_gantt_chart -C C/
#~ make print_plot_stats_print_gantt_chart -C C/
#~ make plot_stats_print_gantt_chart -C C/
#~ make print_gantt_chart_data_persistence -C C/
#~ make print_print_gantt_chart_data_persistence -C C/
./C/main $WORKLOAD $CLUSTER $SCHEDULER $CONTRAINTES_TAILLES outputs/test.csv $BACKFILL_MODE

# Plot gantt chart
python3 ../Batsim/batsched-Maxime/gantt-chart-plot/main.py outputs/Results_all_jobs_$3.csv $3

end=`date +%s` 
runtime=$((end-start))
echo "Execution complete! it lasted" $((runtime/60))" minute(s) and "$((runtime%60))" second(s)."



#~ Scheduler: FCFS, Number of jobs evaluated: 2476, Max queue time: 10365.000000, Mean queue time: 10339.049805, Total queue time: 25599488.000000, Max flow: 67052.000000, Mean flow: 10562.382812, Total flow: 26152460.000000, Transfer time: 8064.000000, Makespan: 4148263.000000, Core time: 553026.000000, Waiting for a load time: 150400.000000, Transfer + waiting time: 158464.000000, Mean flow stretch: 55.720737, Mean bounded flow stretch: 35.065506, Max flow stretch: 56.962162, Max bounded flow stretch: 35.183334, Nb of upgraded jobs: 0, Nb large queue times (>25000): 0, Mean flow stretch 128 256 1024: 55.720737 0.000000 0.000000, Mean flow stretch with a minimum 128 256 1024: 35.065506 0.000000 0.000000

#~ Scheduler: SCORE, Number of jobs evaluated: 2476, Max queue time: 0.000000, Mean queue time: 0.000000, Total queue time: 0.000000, Max flow: 56708.000000, Mean flow: 223.164780, Total flow: 552556.000000, Transfer time: 8064.000000, Makespan: 4137919.000000, Core time: 552556.000000, Waiting for a load time: 149930.000000, Transfer + waiting time: 157994.000000, Mean flow stretch: 0.998991, Mean bounded flow stretch: 0.628984, Max flow stretch: 1.000000, Max bounded flow stretch: 1.000000, Nb of upgraded jobs: 0, Nb large queue times (>25000): 0, Mean flow stretch 128 256 1024: 0.998991 0.000000 0.000000, Mean flow stretch with a minimum 128 256 1024: 0.628984 0.000000 0.000000
