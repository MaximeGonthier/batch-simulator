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

# General info on delay walltime and number of cores used
#~ ../../pypy3.9-v7.3.9-linux64/bin/pypy3 src/convert_stats_workload_single_file.py ${WORKLOAD_TP}
#~ python3 src/plot_stats_workload.py ${WORKLOAD_TP} cores
#~ python3 src/plot_stats_workload.py ${WORKLOAD_TP} walltime
#~ python3 src/plot_stats_workload.py ${WORKLOAD_TP} delay


# Simulation
#~ ../../pypy3.9-v7.3.9-linux64/bin/pypy3 -O src/main_multi_core.py $WORKLOAD $CLUSTER $SCHEDULER 3 $CONTRAINTES_TAILLES
#~ python3 -O src/main_multi_core.py $WORKLOAD $CLUSTER $SCHEDULER 3 $CONTRAINTES_TAILLES


make print_cluster_usage -C C/
./C/main $WORKLOAD $CLUSTER Fcfs $CONTRAINTES_TAILLES

read V1 V2 V3 V4 < outputs/Start_end_evaluated_slice.txt
echo $V1
echo $V2
echo $V3
echo $V4
python3 src/plot_stats_one_execution.py outputs/Stats_$SCHEDULER.csv Used_cores ${WORKLOAD_TP} ${CLUSTER_TP} ${SCHEDULER} $V1 $V2 $V3 $V4
python3 src/plot_stats_one_execution.py outputs/Stats_$SCHEDULER.csv Used_nodes ${WORKLOAD_TP} ${CLUSTER_TP} ${SCHEDULER} $V1 $V2 $V3 $V4
python3 src/plot_stats_one_execution.py outputs/Stats_$SCHEDULER.csv Nb_scheduled_jobs ${WORKLOAD_TP} ${CLUSTER_TP} ${SCHEDULER} $V1 $V2 $V3 $V4

end=`date +%s` 
runtime=$((end-start))
echo "Execution complete! It lasted" $((runtime/60))" minute(s) and "$((runtime%60))" second(s)."
