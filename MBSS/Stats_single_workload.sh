#!/bin/bash

# bash Stats_single_workload.sh inputs/workloads/converted/2022-07-16-\>2022-07-16_V10000 inputs/clusters/rackham_450_128_32_256_4_1024.txt Fcfs

# Stats on an execution but also on the workload itself
# bash Stats_single_workload.sh WORKLOAD CLUSTER SCHEDULER CONTRAINTES_TAILLES
start=`date +%s`

if [ "$#" -ne 3 ]; then
    echo "Usage is bash zzzzz.sh converted_workload cluster scheduler"
    exit
fi

# Get arguments
WORKLOAD=$1
WORKLOAD_TP=${WORKLOAD:27}
CLUSTER=$2
CLUSTER_TP=${CLUSTER:24}
CLUSTER_TP=${CLUSTER_TP::-4}

DAY=${WORKLOAD:35:2}
MONTH=${WORKLOAD:32:2}
YEAR=${WORKLOAD:27:4}
echo "Day" ${DAY}
echo "Month" ${MONTH}
echo "Year" ${YEAR}
SCHEDULER=$3
DATE=${WORKLOAD:27:30}
CONTRAINTES_TAILLES=0

make print_cluster_usage -C C/
./C/main $WORKLOAD $CLUSTER $SCHEDULER $CONTRAINTES_TAILLES outputs/test.csv 0 80

read V1 V2 V3 V4 < outputs/Start_end_evaluated_slice.txt
# Full
#~ python3 src/plot_stats_one_execution.py outputs/Stats_$SCHEDULER.csv Used_nodes ${WORKLOAD_TP} ${CLUSTER_TP} ${SCHEDULER} $V1 $V2 $V3 $V4 0 ${DAY} ${MONTH} ${YEAR}
# Reduced
python3 src/plot_stats_one_execution.py outputs/Stats_$SCHEDULER.csv Used_nodes ${WORKLOAD_TP} ${CLUSTER_TP} ${SCHEDULER} $V1 $V2 $V3 $V4 1 ${DAY} ${MONTH} ${YEAR}

mv outputs/Stats_$SCHEDULER.csv data/Stats_${SCHEDULER}_${MONTH}-${DAY}.csv

# 07-16
#~ python3 src/plot_stats_one_execution.py data/Stats_${SCHEDULER}_07-16.csv Used_nodes ${WORKLOAD_TP} ${CLUSTER_TP} ${SCHEDULER} $V1 $V2 $V3 $V4 1 ${DAY} ${MONTH} ${YEAR}


end=`date +%s` 
runtime=$((end-start))
echo "Execution complete! It lasted" $((runtime/60))" minute(s) and "$((runtime%60))" second(s)."
