#!/bin/bash
# bash Stats_single_workload.sh
start=`date +%s`

# Get arguments
WORKLOAD=$1
WORKLOAD_TP=${WORKLOAD:27}
CLUSTER=$2
CLUSTER_TP=${CLUSTER:24}
CLUSTER_TP=${CLUSTER_TP::-4}
SCHEDULER=$3
DATE=${WORKLOAD:27:30}

../../pypy3.9-v7.3.9-linux64/bin/pypy3 src/main_multi_core.py $WORKLOAD $CLUSTER $SCHEDULER 1
python3 src/plot_running_cores.py outputs/Stats_$SCHEDULER.csv Used_cores ${WORKLOAD_TP} ${CLUSTER_TP} ${SCHEDULER}
python3 src/plot_running_cores.py outputs/Stats_$SCHEDULER.csv Used_nodes ${WORKLOAD_TP} ${CLUSTER_TP} ${SCHEDULER}

end=`date +%s` 
runtime=$((end-start))
echo "Execution complete! It lasted" $((runtime/60))" minute(s) and "$((runtime%60))" second(s)."
