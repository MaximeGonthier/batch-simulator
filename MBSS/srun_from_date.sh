#!/bin/bash
# bash srun_from_date.sh 24:00:00 01-01

if [ "$#" -ne 2 ]; then
    echo "Usage is bash srun_from_date.sh WALLTIME date"
    exit
fi

# Get arguments
DATE=$2
WALLTIME=$1
WORKLOAD="inputs/workloads/converted/2022-${DATE}-\\>2022-${DATE}_V10000_anonymous"
WORKLOAD_TP=${WORKLOAD:27}
CLUSTER="inputs/clusters/rackham_450_128_32_256_4_1024.txt"
CLUSTER_TP=${CLUSTER:24}
CLUSTER_TP=${CLUSTER_TP::-4}
CONTRAINTES_TAILLES=0
BUSY_CLUSTER_THRESHOLD=80

make -C C/

SCHEDULER="Fcfs"; BACKFILL_MODE=0
OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) > ${DATE}_${SCHEDULER}.txt &"
echo "call: ${call}"
eval ${call}

SCHEDULER="Fcfs_conservativebf"; BACKFILL_MODE=2
OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) > ${DATE}_${SCHEDULER}.txt &"
echo "call: ${call}"
eval ${call}

SCHEDULER="Fcfs_with_a_score_x1_x0_x0_x0"; BACKFILL_MODE=0
OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) > ${DATE}_${SCHEDULER}.txt &"
echo "call: ${call}"
eval ${call}

SCHEDULER="Fcfs_with_a_score_conservativebf_x1_x0_x0_x0"; BACKFILL_MODE=2
OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
echo "call: ${call}"
eval ${call}

SCHEDULER="Fcfs_with_a_score_x500_x1_x0_x0"; BACKFILL_MODE=0
OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) > ${DATE}_${SCHEDULER}.txt &"
echo "call: ${call}"
eval ${call}

SCHEDULER="Fcfs_with_a_score_conservativebf_x500_x1_x0_x0"; BACKFILL_MODE=2
OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) > ${DATE}_${SCHEDULER}.txt &"
echo "call: ${call}"
eval ${call}

SCHEDULER="Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_x500_x1_x0_x0"; BACKFILL_MODE=0
OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) > ${DATE}_${SCHEDULER}.txt &"
echo "call: ${call}"
eval ${call}

SCHEDULER="Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_conservativebf_x500_x1_x0_x0"; BACKFILL_MODE=2
OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) > ${DATE}_${SCHEDULER}.txt &"
echo "call: ${call}"
eval ${call}

SCHEDULER="Fcfs_with_a_score_mixed_strategy_x500_x1_x0_x0"; BACKFILL_MODE=0
OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) > ${DATE}_${SCHEDULER}.txt &"
echo "call: ${call}"
eval ${call}

SCHEDULER="Fcfs_with_a_score_mixed_strategy_conservativebf_x500_x1_x0_x0"; BACKFILL_MODE=2
OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) > ${DATE}_${SCHEDULER}.txt &"
echo "call: ${call}"
eval ${call}
