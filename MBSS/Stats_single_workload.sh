#!/bin/bash
# Stats on an execution but also on the workload itself
# bash Stats_single_workload.sh WORKLOAD CLUSTER SCHEDULER CONTRAINTES_TAILLES
start=`date +%s`

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
./C/main $WORKLOAD $CLUSTER $SCHEDULER $CONTRAINTES_TAILLES

read V1 V2 V3 V4 < outputs/Start_end_evaluated_slice.txt
#~ echo $V1
#~ echo $V2
#~ echo $V3
#~ echo $V4
#~ python3 src/plot_stats_one_execution.py outputs/Stats_$SCHEDULER.csv Used_cores ${WORKLOAD_TP} ${CLUSTER_TP} ${SCHEDULER} $V1 $V2 $V3 $V4
python3 src/plot_stats_one_execution.py outputs/Stats_$SCHEDULER.csv Used_nodes ${WORKLOAD_TP} ${CLUSTER_TP} ${SCHEDULER} $V1 $V2 $V3 $V4
#~ python3 src/plot_stats_one_execution.py outputs/Stats_$SCHEDULER.csv Nb_scheduled_jobs ${WORKLOAD_TP} ${CLUSTER_TP} ${SCHEDULER} $V1 $V2 $V3 $V4

#~ python3 src/plot_cluster_usage.py outputs/Results_for_cluster_usage.txt ${WORKLOAD_TP} ${CLUSTER_TP} ${SCHEDULER}

end=`date +%s` 
runtime=$((end-start))
echo "Execution complete! It lasted" $((runtime/60))" minute(s) and "$((runtime%60))" second(s)."
