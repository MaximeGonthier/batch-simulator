#!/bin/bash
# bash Compare_FCFS_Score.sh workload cluster contrainte_taille
# oarsub -p nova -l core=16,walltime=04:00:00 -r '2022-09-22 14:00:00' "bash Compare_Conservative_Backfill.sh inputs/workloads/converted/2022-01-17-\>2022-01-17_V9532 inputs/clusters/rackham_450_128_32_256_4_1024.txt 0"

start=`date +%s`

if [ "$#" -ne 4 ]; then
    echo "Usage is bash Compare_Conservative_Backfill.sh converted_workload cluster size_constraint(0, 1 or 2) starting_i"
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
CONTRAINTES_TAILLES=$3 # 1 if you want both constraints
echo "Contraintes tailles:" ${CONTRAINTES_TAILLES}
STARTING_I=$(($4))

make -C C/

OUTPUT_FILE=outputs/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}.csv
if (($((STARTING_I)) == 1))
then
	echo "Scheduler,Number of jobs,Maximum queue time,Mean queue time,Total queue time,Maximum flow,Mean flow,Total flow,Transfer time,Makespan,Core time used, Waiting for a load time, Total waiting for a load time and transfer time, Mean Stretch, Mean Stretch With a Minimum, Max Stretch, Max Stretch With a Minimum, Nb Upgraded Jobs, Nb jobs large queue time, Mean flow stretch 128 jobs, Mean flow stretch 256 jobs, Mean flow stretch 1024 jobs, Mean flow stretch with a minimum 128 jobs, Mean flow stretch with a minimum 256 jobs, Mean flow stretch with a minimum 1024 jobs" > ${OUTPUT_FILE}
fi
#~ for ((i=$((STARTING_I)); i<=16; i++))
#~ do
	#~ # Schedulers
	#~ if [ $((i)) == 1 ]; then SCHEDULER="Fcfs"; BACKFILL_MODE=0
	#~ elif [ $((i)) == 2 ]; then SCHEDULER="Fcfs_conservativebf"; BACKFILL_MODE=0
	#~ elif [ $((i)) == 3 ]; then SCHEDULER="Fcfs_conservativebf"; BACKFILL_MODE=1
	#~ elif [ $((i)) == 4 ]; then SCHEDULER="Fcfs_conservativebf"; BACKFILL_MODE=2
	#~ elif [ $((i)) == 5 ]; then SCHEDULER="Fcfs_with_a_score_x500_x1_x0_x0"; BACKFILL_MODE=0
	#~ elif [ $((i)) == 6 ]; then SCHEDULER="Fcfs_with_a_score_conservativebf_x500_x1_x0_x0"; BACKFILL_MODE=0
	#~ elif [ $((i)) == 7 ]; then SCHEDULER="Fcfs_with_a_score_conservativebf_x500_x1_x0_x0"; BACKFILL_MODE=1
	#~ elif [ $((i)) == 8 ]; then SCHEDULER="Fcfs_with_a_score_conservativebf_x500_x1_x0_x0"; BACKFILL_MODE=2
	#~ elif [ $((i)) == 9 ]; then SCHEDULER="Fcfs_with_a_score_mixed_strategy_x500_x1_x0_x0"; BACKFILL_MODE=0
	#~ elif [ $((i)) == 10 ]; then SCHEDULER="Fcfs_with_a_score_mixed_strategy_conservativebf_x500_x1_x0_x0"; BACKFILL_MODE=0
	#~ elif [ $((i)) == 11 ]; then SCHEDULER="Fcfs_with_a_score_mixed_strategy_conservativebf_x500_x1_x0_x0"; BACKFILL_MODE=1
	#~ elif [ $((i)) == 12 ]; then SCHEDULER="Fcfs_with_a_score_mixed_strategy_conservativebf_x500_x1_x0_x0"; BACKFILL_MODE=2
	#~ elif [ $((i)) == 13 ]; then SCHEDULER="Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_x500_x1_x0_x0"; BACKFILL_MODE=0
	#~ elif [ $((i)) == 14 ]; then SCHEDULER="Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_conservativebf_x500_x1_x0_x0"; BACKFILL_MODE=0
	#~ elif [ $((i)) == 15 ]; then SCHEDULER="Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_conservativebf_x500_x1_x0_x0"; BACKFILL_MODE=1
	#~ elif [ $((i)) == 16 ]; then SCHEDULER="Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_conservativebf_x500_x1_x0_x0"; BACKFILL_MODE=2
	#~ fi
	#~ ./C/main $WORKLOAD $CLUSTER $SCHEDULER $CONTRAINTES_TAILLES $OUTPUT_FILE $BACKFILL_MODE
#~ done
for ((i=$((STARTING_I)); i<=16; i++))
do
	# Schedulers
	if [ $((i)) == 1 ]; then SCHEDULER="Fcfs_conservativebf"; BACKFILL_MODE=0
	elif [ $((i)) == 2 ]; then SCHEDULER="Fcfs_with_a_score_conservativebf_x500_x1_x0_x0"; BACKFILL_MODE=0
	elif [ $((i)) == 3 ]; then SCHEDULER="Fcfs_with_a_score_mixed_strategy_conservativebf_x500_x1_x0_x0"; BACKFILL_MODE=0
	elif [ $((i)) == 4 ]; then SCHEDULER="Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_conservativebf_x500_x1_x0_x0"; BACKFILL_MODE=0
	fi
	./C/main $WORKLOAD $CLUSTER $SCHEDULER $CONTRAINTES_TAILLES $OUTPUT_FILE $BACKFILL_MODE
done
echo "Final results are:"
cat ${OUTPUT_FILE}
mv ${OUTPUT_FILE} data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}.csv


end=`date +%s` 
runtime=$((end-start))
echo "Execution complete! It lasted" $((runtime/60))" minute(s) and "$((runtime%60))" second(s)."
