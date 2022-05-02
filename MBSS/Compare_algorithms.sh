#!/bin/bash
# bash Compare_algorithms.sh workload cluster
start=`date +%s`

if [ "$#" -ne 2 ]; then
    echo "Usage is bash Compare_algorithms.sh workload_date cluster"
    exit
fi

# Get arguments
WORKLOAD=$1
CLUSTER=$2

# Generate workload
#~ bash Generate_workload_from_rackham.sh $WORKLOAD
# OR $1 is already an existing workload

echo "Scheduler,Number of jobs,Maximum queue time,Mean queue time,Total queue time,Maximum flow,Mean flow,Total flow,Total transfer and wait time,Makespan,Core time used, Total waiting for a load time, Total waiting for a load time and transfer time" > outputs/Results_${WORKLOAD}.csv

for ((i=0; i<4; i++))
do
	if [ $((i)) == 0 ]; then SCHEDULER="Random" 
	elif [ $((i)) == 1 ]; then SCHEDULER="Fcfs_with_a_score" 
	elif [ $((i)) == 2 ]; then SCHEDULER="Maximum_use_single_file" 
	elif [ $((i)) == 3 ]; then SCHEDULER="Easy_bf_fcfs_fcfs" 
	fi
	truncate -s 0 outputs/Results_${SCHEDULER}.csv
	echo "${SCHEDULER}"
	python3 src/main_multi_core.py inputs/workloads/converted/$WORKLOAD $CLUSTER $SCHEDULER 0
	echo "Results ${SCHEDULER} are:"
	head outputs/Results_${SCHEDULER}.csv
	cat outputs/Results_${SCHEDULER}.csv >> outputs/Results_${WORKLOAD}.csv
done

echo "Final results are:"
cat outputs/Results_${WORKLOAD}.csv

echo "Plotting results..."
python3 src/plot_barplot.py ${WORKLOAD} Maximum_queue_time
python3 src/plot_barplot.py ${WORKLOAD} Mean_queue_time
python3 src/plot_barplot.py ${WORKLOAD} Total_queue_time
python3 src/plot_barplot.py ${WORKLOAD} Maximum_flow
python3 src/plot_barplot.py ${WORKLOAD} Mean_flow
python3 src/plot_barplot.py ${WORKLOAD} Total_flow
python3 src/plot_barplot.py ${WORKLOAD} Total_transfer_time
python3 src/plot_barplot.py ${WORKLOAD} Makespan
python3 src/plot_barplot.py ${WORKLOAD} Core_time_used
python3 src/plot_barplot.py ${WORKLOAD} Total_waiting_for_a_load_time
python3 src/plot_barplot.py ${WORKLOAD} Total_waiting_for_a_load_time_and_transfer_time

end=`date +%s` 
runtime=$((end-start))
echo "Execution complete! It lasted" $((runtime/60))" minute(s) and "$((runtime%60))" second(s)."
