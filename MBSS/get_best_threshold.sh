#!/bin/bash
# bash get_best_threshold.sh workload cluster

start=`date +%s`

if [ "$#" -ne 3 ]; then
    echo "Usage is bash get_best_threshold.sh converted_workload cluster starting_i"
    exit
fi

# Get arguments
WORKLOAD=$1
WORKLOAD_TP=${WORKLOAD:27}
CLUSTER=$2
CLUSTER_TP=${CLUSTER:24}
CLUSTER_TP=${CLUSTER_TP::-4}
echo "Workload:" ${WORKLOAD_TP}
echo "Cluster:" ${CLUSTER_TP}
CONTRAINTES_TAILLES=0
echo "Contraintes tailles:" ${CONTRAINTES_TAILLES}
STARTING_I=$(($3))

make -C C/

OUTPUT_FILE=outputs/Results_FCFS_Score_Threshold_${WORKLOAD_TP}_${CLUSTER_TP}.csv
if (($((STARTING_I)) == 1))
then
	echo "Scheduler,Number of jobs,Maximum queue time,Mean queue time,Total queue time,Maximum flow,Mean flow,Total flow,Transfer time,Makespan,Core time used, Waiting for a load time, Total waiting for a load time and transfer time, Mean Stretch, Mean Stretch With a Minimum, Max Stretch, Max Stretch With a Minimum, Nb Upgraded Jobs, Nb jobs large queue time, Mean flow stretch 128 jobs, Mean flow stretch 256 jobs, Mean flow stretch 1024 jobs, Mean flow stretch with a minimum 128 jobs, Mean flow stretch with a minimum 256 jobs, Mean flow stretch with a minimum 1024 jobs, Number of data reuse" > ${OUTPUT_FILE}
fi

# En testant que les bases et le meilleur mode
for ((i=$((STARTING_I)); i<=11; i++))
do
	# Schedulers
	if [ $((i)) == 1 ]; then SCHEDULER="Fcfs_with_a_score_mixed_strategy_x500_x1_x0_x0"; BACKFILL_MODE=0; BUSY_CLUSTER_THRESHOLD=50
	elif [ $((i)) == 2 ]; then SCHEDULER="Fcfs_with_a_score_mixed_strategy_x500_x1_x0_x0"; BACKFILL_MODE=0; BUSY_CLUSTER_THRESHOLD=55
	elif [ $((i)) == 3 ]; then SCHEDULER="Fcfs_with_a_score_mixed_strategy_x500_x1_x0_x0"; BACKFILL_MODE=0; BUSY_CLUSTER_THRESHOLD=60
	elif [ $((i)) == 4 ]; then SCHEDULER="Fcfs_with_a_score_mixed_strategy_x500_x1_x0_x0"; BACKFILL_MODE=0; BUSY_CLUSTER_THRESHOLD=65
	elif [ $((i)) == 5 ]; then SCHEDULER="Fcfs_with_a_score_mixed_strategy_x500_x1_x0_x0"; BACKFILL_MODE=0; BUSY_CLUSTER_THRESHOLD=70
	elif [ $((i)) == 6 ]; then SCHEDULER="Fcfs_with_a_score_mixed_strategy_x500_x1_x0_x0"; BACKFILL_MODE=0; BUSY_CLUSTER_THRESHOLD=75
	elif [ $((i)) == 7 ]; then SCHEDULER="Fcfs_with_a_score_mixed_strategy_x500_x1_x0_x0"; BACKFILL_MODE=0; BUSY_CLUSTER_THRESHOLD=80
	elif [ $((i)) == 8 ]; then SCHEDULER="Fcfs_with_a_score_mixed_strategy_x500_x1_x0_x0"; BACKFILL_MODE=0; BUSY_CLUSTER_THRESHOLD=85
	elif [ $((i)) == 9 ]; then SCHEDULER="Fcfs_with_a_score_mixed_strategy_x500_x1_x0_x0"; BACKFILL_MODE=0; BUSY_CLUSTER_THRESHOLD=90
	elif [ $((i)) == 10 ]; then SCHEDULER="Fcfs_with_a_score_mixed_strategy_x500_x1_x0_x0"; BACKFILL_MODE=0; BUSY_CLUSTER_THRESHOLD=95
	elif [ $((i)) == 11 ]; then SCHEDULER="Fcfs_with_a_score_mixed_strategy_x500_x1_x0_x0"; BACKFILL_MODE=0; BUSY_CLUSTER_THRESHOLD=100
	fi
	./C/main $WORKLOAD $CLUSTER $SCHEDULER $CONTRAINTES_TAILLES $OUTPUT_FILE $BACKFILL_MODE $BUSY_CLUSTER_THRESHOLD 1
done

echo "Final results are:"
cat ${OUTPUT_FILE}
mv ${OUTPUT_FILE} data/Results_FCFS_Score_Threshold_${WORKLOAD_TP}_${CLUSTER_TP}.csv


end=`date +%s` 
runtime=$((end-start))
echo "Execution complete! It lasted" $((runtime/60))" minute(s) and "$((runtime%60))" second(s)."
