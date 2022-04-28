#!/bin/bash
# bash Experiments_multi_core.sh workload cluster scheduler PRINT?
start=`date +%s`

if [ "$#" -ne 4 ]; then
    echo "Usage is bash Experiments_multi_core.sh workload cluster scheduler PRINT?"
    exit
fi

# Get arguments
WORKLOAD=$1
CLUSTER=$2
SCHEDULER=$3
PRINT=$4
DATE=${WORKLOAD:27:30}

# Generate workload
#~ bash Generate_workload_from_rackham.sh $WORKLOAD
# OR $1 is already an existing workload

# Random (Random)
if [ $PRINT == 1 ]; then
echo "job_id,workload_name,profile,submission_time,requested_number_of_resources,requested_time,success,final_state,starting_time,execution_time,finish_time,waiting_time,turnaround_time,stretch,allocated_resources,consumed_energy,metadata" > "outputs/Results_all_jobs_${SCHEDULER}.csv"
fi
if [ $PRINT == 2 ]; then
: > "outputs/Distribution_queue_times_${SCHEDULER}.txt"
fi

truncate -s 0 outputs/Results_${SCHEDULER}.csv
python3 src/main_multi_core.py $WORKLOAD $CLUSTER $SCHEDULER ShiftLeft $PRINT

if [ $PRINT == 1 ]; then
	python3 ../Batsim/batsched-Maxime/gantt-chart-plot/main.py outputs/Results_all_jobs_${SCHEDULER}.csv ${SCHEDULER}
fi
if [ $PRINT == 2 ]; then
	python3 src/plot_distribution_queue_times.py outputs/Distribution_queue_times_${SCHEDULER}.txt $SCHEDULER $DATE
fi

echo "Results:"
head outputs/Results_${SCHEDULER}.csv

end=`date +%s` 
runtime=$((end-start))
echo "Execution complete! It lasted" $((runtime/60))" minute(s) and "$((runtime%60))" second(s)."
