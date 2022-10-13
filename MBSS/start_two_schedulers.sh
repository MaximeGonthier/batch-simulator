#!/bin/bash
# bash Gantt_chart.sh inputs/workloads/converted/test-11 inputs/clusters/rackham_4nodes.txt 1
start=`date +%s`

# Get arguments
WORKLOAD=$1
WORKLOAD_TP=${WORKLOAD:27}
CLUSTER=$2
CLUSTER_TP=${CLUSTER:24}
CLUSTER_TP=${CLUSTER_TP::-4}
DATE=${WORKLOAD:27:30}
CONTRAINTES_TAILLES=$3

make -C C/
./C/main $WORKLOAD $CLUSTER HEFT $CONTRAINTES_TAILLES outputs/test.csv
make plot_stats -C C/
./C/main $WORKLOAD $CLUSTER Mixed_strategy_if_EAT_is_t $CONTRAINTES_TAILLES outputs/test.csv

diff outputs/Stretch_HEFT.txt outputs/Stretch_Mixed_strategy_if_EAT_is_t.txt

end=`date +%s` 
runtime=$((end-start))
echo "Execution complete! it lasted" $((runtime/60))" minute(s) and "$((runtime%60))" second(s)."
