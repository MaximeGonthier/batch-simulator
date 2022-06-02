#!/bin/bash
# bash Compare_FCFS_Score.sh workload cluster contrainte_taille
start=`date +%s`

if [ "$#" -ne 3 ]; then
    echo "Usage is bash Compare_algorithms.sh workload cluster contraintes_tailles_données"
    exit
fi

# Get arguments
WORKLOAD=$1
WORKLOAD_TP=${WORKLOAD:27}
CLUSTER=$2
CLUSTER_TP=${CLUSTER:24}
CLUSTER_TP=${CLUSTER_TP::-4}
echo ${WORKLOAD_TP}
echo ${CLUSTER_TP}
CONTRAINTES_TAILLES=$3

echo "Scheduler,Number of jobs,Maximum queue time,Mean queue time,Total queue time,Maximum flow,Mean flow,Total flow,Transfer time,Makespan,Core time used, Waiting for a load time, Total waiting for a load time and transfer time, Mean Stretch" > outputs/Results_FCFS_Score_${WORKLOAD_TP}.csv

# For heatmap
truncate -s 0 outputs/heatmap.txt

for ((i=1; i<=25; i++))
do
	# Schedulers
	if [ $((i)) == 1 ]; then SCHEDULER="Fcfs_with_a_score_x0_x0_x1"
	elif [ $((i)) == 2 ]; then SCHEDULER="Fcfs_with_a_score_x0_x1_x1"
	elif [ $((i)) == 3 ]; then SCHEDULER="Fcfs_with_a_score_x0_x2_x1"
	elif [ $((i)) == 4 ]; then SCHEDULER="Fcfs_with_a_score_x0_x3_x1"
	elif [ $((i)) == 5 ]; then SCHEDULER="Fcfs_with_a_score_x0_x4_x1"
	elif [ $((i)) == 6 ]; then SCHEDULER="Fcfs_with_a_score_x1_x0_x1"
	elif [ $((i)) == 7 ]; then SCHEDULER="Fcfs_with_a_score_x1_x1_x1"
	elif [ $((i)) == 8 ]; then SCHEDULER="Fcfs_with_a_score_x1_x2_x1"
	elif [ $((i)) == 9 ]; then SCHEDULER="Fcfs_with_a_score_x1_x3_x1"
	elif [ $((i)) == 10 ]; then SCHEDULER="Fcfs_with_a_score_x1_x4_x1"
	elif [ $((i)) == 11 ]; then SCHEDULER="Fcfs_with_a_score_x2_x0_x1"
	elif [ $((i)) == 12 ]; then SCHEDULER="Fcfs_with_a_score_x2_x1_x1"
	elif [ $((i)) == 13 ]; then SCHEDULER="Fcfs_with_a_score_x2_x2_x1"
	elif [ $((i)) == 14 ]; then SCHEDULER="Fcfs_with_a_score_x2_x3_x1"
	elif [ $((i)) == 15 ]; then SCHEDULER="Fcfs_with_a_score_x2_x4_x1"
	elif [ $((i)) == 16 ]; then SCHEDULER="Fcfs_with_a_score_x3_x0_x1"
	elif [ $((i)) == 17 ]; then SCHEDULER="Fcfs_with_a_score_x3_x1_x1"
	elif [ $((i)) == 18 ]; then SCHEDULER="Fcfs_with_a_score_x3_x2_x1"
	elif [ $((i)) == 19 ]; then SCHEDULER="Fcfs_with_a_score_x3_x3_x1"
	elif [ $((i)) == 20 ]; then SCHEDULER="Fcfs_with_a_score_x3_x4_x1"
	elif [ $((i)) == 21 ]; then SCHEDULER="Fcfs_with_a_score_x4_x0_x1"
	elif [ $((i)) == 22 ]; then SCHEDULER="Fcfs_with_a_score_x4_x1_x1"
	elif [ $((i)) == 23 ]; then SCHEDULER="Fcfs_with_a_score_x4_x2_x1"
	elif [ $((i)) == 24 ]; then SCHEDULER="Fcfs_with_a_score_x4_x3_x1"
	elif [ $((i)) == 25 ]; then SCHEDULER="Fcfs_with_a_score_x4_x4_x1"
	fi
	
	truncate -s 0 outputs/Results_${SCHEDULER}.csv
	echo "${SCHEDULER}"
	#~ # ../../pypy3.9-v7.3.9-linux64/bin/pypy3 -O src/main_multi_core.py $WORKLOAD $CLUSTER $SCHEDULER 0 $CONTRAINTES_TAILLES
	python3 -O src/main_multi_core.py $WORKLOAD $CLUSTER $SCHEDULER 0 $CONTRAINTES_TAILLES
	echo "Results ${SCHEDULER} are:"
	head outputs/Results_${SCHEDULER}.csv
	cat outputs/Results_${SCHEDULER}.csv >> outputs/Results_FCFS_Score_${WORKLOAD_TP}.csv
	
	# For heatmap
	cat outputs/Stretch_${SCHEDULER}.txt >> outputs/heatmap.txt
	echo "" >> outputs/heatmap.txt
done

echo "Final results are:"
cat outputs/Results_FCFS_Score_${WORKLOAD_TP}.csv

echo "Plotting results..."
python3 src/plot_barplot.py FCFS_Score_${WORKLOAD_TP} Maximum_queue_time ${CLUSTER_TP} 0
python3 src/plot_barplot.py FCFS_Score_${WORKLOAD_TP} Mean_queue_time ${CLUSTER_TP} 0
python3 src/plot_barplot.py FCFS_Score_${WORKLOAD_TP} Total_queue_time ${CLUSTER_TP} 0
python3 src/plot_barplot.py FCFS_Score_${WORKLOAD_TP} Maximum_flow ${CLUSTER_TP} 0
python3 src/plot_barplot.py FCFS_Score_${WORKLOAD_TP} Mean_flow ${CLUSTER_TP} 0
python3 src/plot_barplot.py FCFS_Score_${WORKLOAD_TP} Total_flow ${CLUSTER_TP} 0
python3 src/plot_barplot.py FCFS_Score_${WORKLOAD_TP} Transfer_time ${CLUSTER_TP} 0
python3 src/plot_barplot.py FCFS_Score_${WORKLOAD_TP} Makespan ${CLUSTER_TP} 0
python3 src/plot_barplot.py FCFS_Score_${WORKLOAD_TP} Core_time_used ${CLUSTER_TP} 0
python3 src/plot_barplot.py FCFS_Score_${WORKLOAD_TP} Waiting_for_a_load_time ${CLUSTER_TP} 0
python3 src/plot_barplot.py FCFS_Score_${WORKLOAD_TP} Total_waiting_for_a_load_time_and_transfer_time ${CLUSTER_TP} 0

echo "Plotting heatmap..."
python3 src/plot_heatmap.py outputs/heatmap.txt ${WORKLOAD_TP} 5

end=`date +%s` 
runtime=$((end-start))
echo "Execution complete! It lasted" $((runtime/60))" minute(s) and "$((runtime%60))" second(s)."
