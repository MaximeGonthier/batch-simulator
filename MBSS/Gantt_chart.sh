#!/bin/bash
# bash Gantt_chart.sh inputs/workloads/converted/test-11 inputs/clusters/rackham_4nodes.txt Fcfs 1
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

# Header
echo "job_id,workload_name,profile,submission_time,requested_number_of_resources,requested_time,success,final_state,starting_time,execution_time,finish_time,waiting_time,turnaround_time,stretch,allocated_resources,consumed_energy,metadata" > "outputs/Results_all_jobs_$3.csv"

#~ make print_gantt_chart -C C/
make print_print_gantt_chart -C C/
./C/main $WORKLOAD $CLUSTER $SCHEDULER $CONTRAINTES_TAILLES

# Plot gantt chart
echo "Plotting gantt chart..."
python3 ../Batsim/batsched-Maxime/gantt-chart-plot/main.py outputs/Results_all_jobs_$3.csv $3

end=`date +%s` 
runtime=$((end-start))
echo "Execution complete! it lasted" $((runtime/60))" minute(s) and "$((runtime%60))" second(s)."
