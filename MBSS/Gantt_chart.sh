#!/bin/bash
# bash Gantt_chart.sh workload cluster scheduler
# bash Gantt_chart.sh inputs/workloads/workload_2.txt inputs/cluster_1.txt First-Come-First-Serve-Data-Aware
start=`date +%s`

# Header
echo "job_id,workload_name,profile,submission_time,requested_number_of_resources,requested_time,success,final_state,starting_time,execution_time,finish_time,waiting_time,turnaround_time,stretch,allocated_resources,consumed_energy,metadata" > "outputs/Results_all_jobs_$3.csv"

# Exec with 1 to print all jobs
python3 src/main.py $1 $2 $3 1

# Plot gantt chart
echo "Plotting gantt chart..."
python3 ../Batsim/batsched-Maxime/gantt-chart-plot/main.py outputs/Results_all_jobs_$3.csv $3

end=`date +%s` 
runtime=$((end-start))
echo "Execution complete! it lasted" $((runtime/60))" minute(s) and "$((runtime%60))" second(s)."
