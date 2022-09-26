#!/bin/bash
# Stats on an execution but also on the workload itself
# bash Stats_single_workload.sh WORKLOAD CLUSTER SCHEDULER CONTRAINTES_TAILLES
start=`date +%s`

if [ "$#" -ne 4 ]; then
    echo "Usage is bash zzzzz.sh converted_workload cluster scheduler size_constraint(0, 1 or 2)"
    exit
fi

# Get arguments
WORKLOAD=$1
WORKLOAD_TP=${WORKLOAD:27}
CLUSTER=$2
CLUSTER_TP=${CLUSTER:24}
CLUSTER_TP=${CLUSTER_TP::-4}
SCHEDULER=$3
DATE=${WORKLOAD:27:30}
CONTRAINTES_TAILLES=$4

make print_cluster_usage -C C/
./C/main $WORKLOAD $CLUSTER $SCHEDULER $CONTRAINTES_TAILLES outputs/test.csv

read V1 V2 V3 V4 < outputs/Start_end_evaluated_slice.txt
python3 src/plot_stats_one_execution.py outputs/Stats_$SCHEDULER.csv Used_nodes ${WORKLOAD_TP} ${CLUSTER_TP} ${SCHEDULER} $V1 $V2 $V3 $V4
#~ python3 src/plot_stats_one_execution.py outputs/test.csv Used_nodes ${WORKLOAD_TP} ${CLUSTER_TP} ${SCHEDULER} $V1 $V2 $V3 $V4

end=`date +%s` 
runtime=$((end-start))
echo "Execution complete! It lasted" $((runtime/60))" minute(s) and "$((runtime%60))" second(s)."
