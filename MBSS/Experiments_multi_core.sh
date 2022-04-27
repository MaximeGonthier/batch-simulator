#!/bin/bash
# bash Experiments_multi_core.sh workload cluster scheduler print_gantt_chart?
start=`date +%s`

if [ "$#" -ne 4 ]; then
    echo "Usage is bash Experiments_multi_core.sh workload cluster scheduler print_gantt_chart?"
    exit
fi

# Get arguments
WORKLOAD=$1
CLUSTER=$2
SCHEDULER=$3
PRINT_GANTT_CHART=$4

# Generate workload
#~ bash Generate_workload_from_rackham.sh $WORKLOAD
# OR $1 is already an existing workload

# Random (Random)
echo "job_id,workload_name,profile,submission_time,requested_number_of_resources,requested_time,success,final_state,starting_time,execution_time,finish_time,waiting_time,turnaround_time,stretch,allocated_resources,consumed_energy,metadata" > "outputs/Results_all_jobs_${SCHEDULER}.csv"
truncate -s 0 outputs/Results_${SCHEDULER}.txt
python3 src/main_multi_core.py $WORKLOAD $CLUSTER $SCHEDULER ShiftLeft $4

if [ $4 == 1 ]; then
	python3 ../Batsim/batsched-Maxime/gantt-chart-plot/main.py outputs/Results_all_jobs_${SCHEDULER}.csv ${SCHEDULER}
fi

echo "Results:"
head outputs/Results_${SCHEDULER}.txt

end=`date +%s` 
runtime=$((end-start))
echo "Execution complete! It lasted" $((runtime/60))" minute(s) and "$((runtime%60))" second(s)."
