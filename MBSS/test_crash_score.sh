#!/bin/bash
start=`date +%s`

if [ "$#" -ne 1 ]; then
    echo "Usage is bash Compare_Conservative_Backfill.sh converted_workload"
    exit
fi

# Get arguments
WORKLOAD=$1
WORKLOAD_TP=${WORKLOAD:27}
CLUSTER="inputs/clusters/rackham_450_128_32_256_4_1024.txt"
CLUSTER_TP=${CLUSTER:24}
CLUSTER_TP=${CLUSTER_TP::-4}
echo "Workload:" ${WORKLOAD_TP}
echo "Cluster:" ${CLUSTER_TP}
CONTRAINTES_TAILLES=0
echo "Contraintes tailles:" ${CONTRAINTES_TAILLES}
OUTPUT_FILE="outputs/test_fcfs_score_crash.txt"

make -C C/
ulimit -S -s 10000000

SCHEDULER="Fcfs_with_a_score_x500_x1_x0_x0"
BACKFILL_MODE=0
./C/main $WORKLOAD $CLUSTER $SCHEDULER $CONTRAINTES_TAILLES $OUTPUT_FILE $BACKFILL_MODE

echo "Final results are:"
cat ${OUTPUT_FILE}

end=`date +%s` 
runtime=$((end-start))
echo "Execution complete! It lasted" $((runtime/60))" minute(s) and "$((runtime%60))" second(s)."
