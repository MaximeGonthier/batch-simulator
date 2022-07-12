#!/bin/bash
# oarsub -p nova -l core=16,walltime=02:00:00 -r '2022-07-08 12:12:00' "bash Compare_Backfilling.sh inputs/workloads/converted/2022-01-24-\>2022-01-24 inputs/clusters/rackham_450_128_32_256_4_1024.txt"

start=`date +%s`

if [ "$#" -ne 2 ]; then
    echo "Usage is bash Compare_Backfilling.sh workload cluster"
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
CONTRAINTES_TAILLES=0
#~ CONTRAINTES_TAILLES=1
#~ CONTRAINTES_TAILLES=2

make -C C/

echo "Scheduler,Number of jobs,Maximum queue time,Mean queue time,Total queue time,Maximum flow,Mean flow,Total flow,Transfer time,Makespan,Core time used, Waiting for a load time, Total waiting for a load time and transfer time, Mean Stretch, Mean Stretch With a Minimum, Max Stretch, Max Stretch With a Minimum, Nb Upgraded Jobs" > outputs/Results_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}.csv

for ((i=1; i<=4; i++))
do
	# Schedulers
	if [ $((i)) == 1 ]; then SCHEDULER="Fcfs"
	elif [ $((i)) == 2 ]; then SCHEDULER="Fcfs_easybf"
	elif [ $((i)) == 3 ]; then SCHEDULER="Fcfs_with_a_score_x500_x500_x0"
	elif [ $((i)) == 4 ]; then SCHEDULER="Fcfs_with_a_score_easybf_x500_x500_x0"
	fi
	
	truncate -s 0 outputs/Results_${SCHEDULER}.csv
	./C/main $WORKLOAD $CLUSTER $SCHEDULER $CONTRAINTES_TAILLES
	cat outputs/Results_${SCHEDULER}.csv >> outputs/Results_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}.csv
done

echo "Final results are:"
cat outputs/Results_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}.csv

echo "Plotting results..."
python3 src/plot_barplot.py Backfill_${WORKLOAD_TP} Maximum_queue_time ${CLUSTER_TP} 0 outputs/Results_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Backfill_${WORKLOAD_TP} Mean_queue_time ${CLUSTER_TP} 0 outputs/Results_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Backfill_${WORKLOAD_TP} Total_queue_time ${CLUSTER_TP} 0 outputs/Results_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Backfill_${WORKLOAD_TP} Maximum_flow ${CLUSTER_TP} 0 outputs/Results_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Backfill_${WORKLOAD_TP} Mean_flow ${CLUSTER_TP} 0 outputs/Results_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Backfill_${WORKLOAD_TP} Total_flow ${CLUSTER_TP} 0 outputs/Results_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Backfill_${WORKLOAD_TP} Transfer_time ${CLUSTER_TP} 0 outputs/Results_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Backfill_${WORKLOAD_TP} Makespan ${CLUSTER_TP} 0 outputs/Results_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Backfill_${WORKLOAD_TP} Core_time_used ${CLUSTER_TP} 0 outputs/Results_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Backfill_${WORKLOAD_TP} Waiting_for_a_load_time ${CLUSTER_TP} 0 outputs/Results_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Backfill_${WORKLOAD_TP} Total_waiting_for_a_load_time_and_transfer_time ${CLUSTER_TP} 0 outputs/Results_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Backfill_${WORKLOAD_TP} Mean_Stretch ${CLUSTER_TP} 0 outputs/Results_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Backfill_${WORKLOAD_TP} Mean_Stretch_With_a_Minimum ${CLUSTER_TP} 0 outputs/Results_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Backfill_${WORKLOAD_TP} Max_Stretch ${CLUSTER_TP} 0 outputs/Results_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Backfill_${WORKLOAD_TP} Max_Stretch_With_a_Minimum ${CLUSTER_TP} 0 outputs/Results_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Backfill_${WORKLOAD_TP} Nb_Upgraded_Jobs ${CLUSTER_TP} 0 outputs/Results_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}.csv

# Moving main csv data file
mv outputs/Results_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}.csv data/Results_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}.csv

end=`date +%s` 
runtime=$((end-start))
echo "Execution complete! It lasted" $((runtime/60))" minute(s) and "$((runtime%60))" second(s)."
