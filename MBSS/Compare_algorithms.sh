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
CLUSTER_TP=${CLUSTER:24}
CLUSTER_TP=${CLUSTER_TP::-4}
#~ echo ${CLUSTER_TP}
# Generate workload
#~ bash Generate_workload_from_rackham.sh $WORKLOAD
# OR $1 is already an existing workload

echo "Scheduler,Number of jobs,Maximum queue time,Mean queue time,Total queue time,Maximum flow,Mean flow,Total flow,Transfer time,Makespan,Core time used, Waiting for a load time, Total waiting for a load time and transfer time" > outputs/Results_${WORKLOAD}.csv

#~ for ((i=0; i<5; i++))
for ((i=0; i<6; i++))
do
	if [ $((i)) == 0 ]; then SCHEDULER="Random" 
	elif [ $((i)) == 1 ]; then SCHEDULER="Fcfs" 
	elif [ $((i)) == 2 ]; then SCHEDULER="Fcfs_with_a_score" 
	elif [ $((i)) == 3 ]; then SCHEDULER="Fcfs_easybf" 
	elif [ $((i)) == 4 ]; then SCHEDULER="Fcfs_with_a_score_easy_bf" 
	elif [ $((i)) == 5 ]; then SCHEDULER="Maximum_use_single_file" 
	fi
	truncate -s 0 outputs/Results_${SCHEDULER}.csv
	echo "${SCHEDULER}"
	../../pypy3.9-v7.3.9-linux64/bin/pypy3 -O src/main_multi_core.py inputs/workloads/converted/$WORKLOAD $CLUSTER $SCHEDULER 0
	echo "Results ${SCHEDULER} are:"
	head outputs/Results_${SCHEDULER}.csv
	cat outputs/Results_${SCHEDULER}.csv >> outputs/Results_${WORKLOAD}.csv
done

echo "Final results are:"
cat outputs/Results_${WORKLOAD}.csv

echo "Plotting results..."
python3 src/plot_barplot.py ${WORKLOAD} Maximum_queue_time ${CLUSTER_TP}
python3 src/plot_barplot.py ${WORKLOAD} Mean_queue_time ${CLUSTER_TP}
python3 src/plot_barplot.py ${WORKLOAD} Total_queue_time ${CLUSTER_TP}
python3 src/plot_barplot.py ${WORKLOAD} Maximum_flow ${CLUSTER_TP}
python3 src/plot_barplot.py ${WORKLOAD} Mean_flow ${CLUSTER_TP}
python3 src/plot_barplot.py ${WORKLOAD} Total_flow ${CLUSTER_TP}
python3 src/plot_barplot.py ${WORKLOAD} Transfer_time ${CLUSTER_TP}
python3 src/plot_barplot.py ${WORKLOAD} Makespan ${CLUSTER_TP}
python3 src/plot_barplot.py ${WORKLOAD} Core_time_used ${CLUSTER_TP}
python3 src/plot_barplot.py ${WORKLOAD} Waiting_for_a_load_time ${CLUSTER_TP}
python3 src/plot_barplot.py ${WORKLOAD} Total_waiting_for_a_load_time_and_transfer_time ${CLUSTER_TP}

end=`date +%s` 
runtime=$((end-start))
echo "Execution complete! It lasted" $((runtime/60))" minute(s) and "$((runtime%60))" second(s)."
