#!/bin/bash
# oarsub -p nova -l core=16,walltime=14:00:00 -r '2022-09-01 19:00:00' "bash Compare_Size_And_Data_Constraint.sh inputs/workloads/converted/2022-01-17-\>2022-01-17_V9532 inputs/clusters/rackham_450_128_32_256_4_1024.txt"

start=`date +%s`

if [ "$#" -ne 2 ]; then
    echo "Usage is bash Compare_Size_And_Data_Constraint.sh workload cluster"
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
CONTRAINTES_TAILLES=1

make -C C/

echo "Scheduler,Number of jobs,Maximum queue time,Mean queue time,Total queue time,Maximum flow,Mean flow,Total flow,Transfer time,Makespan,Core time used, Waiting for a load time, Total waiting for a load time and transfer time, Mean Stretch, Mean Stretch With a Minimum, Max Stretch, Max Stretch With a Minimum, Nb Upgraded Jobs, Nb jobs large queue time, Mean flow stretch 128 jobs, Mean flow stretch 256 jobs, Mean flow stretch 1024 jobs, Mean flow stretch with a minimum 128 jobs, Mean flow stretch with a minimum 256 jobs, Mean flow stretch with a minimum 1024 jobs" > outputs/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv

for ((i=1; i<=20; i++))
do
	# Schedulers
	if [ $((i)) == 1 ]; then SCHEDULER="Fcfs_no_use_bigger_nodes"
	elif [ $((i)) == 2 ]; then SCHEDULER="Fcfs"
	elif [ $((i)) == 3 ]; then SCHEDULER="Fcfs_backfill_big_nodes_0"
	elif [ $((i)) == 4 ]; then SCHEDULER="Fcfs_area_filling"
	elif [ $((i)) == 5 ]; then SCHEDULER="Fcfs_area_filling_omniscient"
	elif [ $((i)) == 6 ]; then SCHEDULER="Fcfs_area_filling_with_ratio"
	elif [ $((i)) == 7 ]; then SCHEDULER="Fcfs_area_filling_omniscient_with_ratio"
	elif [ $((i)) == 8 ]; then SCHEDULER="Fcfs_with_a_score_x1_x0_x0_x0"
	elif [ $((i)) == 9 ]; then SCHEDULER="Fcfs_with_a_score_x500_x500_x0_x0"
	elif [ $((i)) == 10 ]; then SCHEDULER="Fcfs_with_a_score_backfill_big_nodes_weighted_random_x500_x500_x0_x0"
	elif [ $((i)) == 11 ]; then SCHEDULER="Fcfs_area_filling_with_a_score_x500_x500_x0_x0"
	elif [ $((i)) == 12 ]; then SCHEDULER="Fcfs_area_filling_omniscient_with_a_score_x500_x500_x0_x0"
	elif [ $((i)) == 13 ]; then SCHEDULER="Fcfs_area_filling_with_ratio_with_a_score_x500_x500_x0_x0"
	elif [ $((i)) == 14 ]; then SCHEDULER="Fcfs_area_filling_with_ratio_7_days_earlier_with_a_score_x500_x500_x0_x0"
	elif [ $((i)) == 15 ]; then SCHEDULER="Fcfs_area_filling_omniscient_with_ratio_with_a_score_x500_x500_x0_x0"
	elif [ $((i)) == 16 ]; then SCHEDULER="Fcfs_with_a_score_area_factor_x500_x500_x0_x500"
	elif [ $((i)) == 17 ]; then SCHEDULER="Fcfs_with_a_score_area_factor_with_planned_area_x500_x500_x0_x1000"
	elif [ $((i)) == 18 ]; then SCHEDULER="Fcfs_with_a_score_area_factor_with_omniscient_planned_area_x500_x500_x0_x1000"
	elif [ $((i)) == 19 ]; then SCHEDULER="Fcfs_with_a_score_backfill_big_nodes_gain_loss_tradeoff_x500_x500_x0_x0"
	elif [ $((i)) == 20 ]; then SCHEDULER="Fcfs_with_a_score_backfill_big_nodes_95th_percentile_x500_x500_x0_x0"
	fi
	
	truncate -s 0 outputs/Results_${SCHEDULER}.csv
	./C/main $WORKLOAD $CLUSTER $SCHEDULER $CONTRAINTES_TAILLES
	cat outputs/Results_${SCHEDULER}.csv >> outputs/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv
done

echo "Final results are:"
cat outputs/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv

echo "Plotting results..."
python3 src/plot_barplot.py Results_Size_And_Data_${WORKLOAD_TP} Maximum_queue_time ${CLUSTER_TP} 0 outputs/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Results_Size_And_Data_${WORKLOAD_TP} Mean_queue_time ${CLUSTER_TP} 0 outputs/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Results_Size_And_Data_${WORKLOAD_TP} Total_queue_time ${CLUSTER_TP} 0 outputs/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Results_Size_And_Data_${WORKLOAD_TP} Maximum_flow ${CLUSTER_TP} 0 outputs/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Results_Size_And_Data_${WORKLOAD_TP} Mean_flow ${CLUSTER_TP} 0 outputs/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Results_Size_And_Data_${WORKLOAD_TP} Total_flow ${CLUSTER_TP} 0 outputs/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Results_Size_And_Data_${WORKLOAD_TP} Transfer_time ${CLUSTER_TP} 0 outputs/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Results_Size_And_Data_${WORKLOAD_TP} Makespan ${CLUSTER_TP} 0 outputs/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Results_Size_And_Data_${WORKLOAD_TP} Core_time_used ${CLUSTER_TP} 0 outputs/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Results_Size_And_Data_${WORKLOAD_TP} Waiting_for_a_load_time ${CLUSTER_TP} 0 outputs/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py  Results_Size_And_Data_${WORKLOAD_TP} Total_waiting_for_a_load_time_and_transfer_time ${CLUSTER_TP} 0 outputs/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Results_Size_And_Data_${WORKLOAD_TP} Mean_Stretch ${CLUSTER_TP} 0 outputs/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Results_Size_And_Data_${WORKLOAD_TP} Mean_Stretch_With_a_Minimum ${CLUSTER_TP} 0 outputs/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Results_Size_And_Data_${WORKLOAD_TP} Max_Stretch ${CLUSTER_TP} 0 outputs/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Results_Size_And_Data_${WORKLOAD_TP} Max_Stretch_With_a_Minimum ${CLUSTER_TP} 0 outputs/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Results_Size_And_Data_${WORKLOAD_TP} Nb_Upgraded_Jobs ${CLUSTER_TP} 0 outputs/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Results_Size_And_Data_${WORKLOAD_TP} Mean_Stretch_128 ${CLUSTER_TP} 0 outputs/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Results_Size_And_Data_${WORKLOAD_TP} Mean_Stretch_256 ${CLUSTER_TP} 0 outputs/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Results_Size_And_Data_${WORKLOAD_TP} Mean_Stretch_1024 ${CLUSTER_TP} 0 outputs/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Results_Size_And_Data_${WORKLOAD_TP} Mean_Stretch_With_a_Minimum_128 ${CLUSTER_TP} 0 outputs/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Results_Size_And_Data_${WORKLOAD_TP} Mean_Stretch_With_a_Minimum_256 ${CLUSTER_TP} 0 outputs/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Results_Size_And_Data_${WORKLOAD_TP} Mean_Stretch_With_a_Minimum_1024 ${CLUSTER_TP} 0 outputs/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv

# Moving main csv data file
mv outputs/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv data/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv

end=`date +%s` 
runtime=$((end-start))
echo "Execution complete! It lasted" $((runtime/60))" minute(s) and "$((runtime%60))" second(s)."
