#!/bin/bash
# bash Add_new_heursitic_and_plot.sh workload cluster contrainte_taille
start=`date +%s`

if [ "$#" -ne 4 ]; then
    echo "Usage is bash Add_new_heursitic_and_plot.sh workload cluster contraintes_tailles_données scheduler"
    exit
fi

# Get arguments
WORKLOAD=$1
WORKLOAD_TP=${WORKLOAD:27}
CLUSTER=$2
CLUSTER_TP=${CLUSTER:24}
CLUSTER_TP=${CLUSTER_TP::-4}
CONTRAINTES_TAILLES=$3
SCHEDULER=$4
	
truncate -s 0 outputs/Results_${SCHEDULER}.csv
echo "${SCHEDULER}"
../../pypy3.9-v7.3.9-linux64/bin/pypy3 -O src/main_multi_core.py $WORKLOAD $CLUSTER $SCHEDULER 0 $CONTRAINTES_TAILLES
echo "Results ${SCHEDULER} are:"
head outputs/Results_${SCHEDULER}.csv
cat outputs/Results_${SCHEDULER}.csv >> outputs/Results_${WORKLOAD_TP}.csv

echo "Final results are:"
cat outputs/Results_${WORKLOAD_TP}.csv

echo "Plotting results..."
python3 src/plot_barplot.py ${WORKLOAD_TP} Maximum_queue_time ${CLUSTER_TP} 0
python3 src/plot_barplot.py ${WORKLOAD_TP} Mean_queue_time ${CLUSTER_TP} 0
python3 src/plot_barplot.py ${WORKLOAD_TP} Total_queue_time ${CLUSTER_TP} 0
python3 src/plot_barplot.py ${WORKLOAD_TP} Maximum_flow ${CLUSTER_TP} 0
python3 src/plot_barplot.py ${WORKLOAD_TP} Mean_flow ${CLUSTER_TP} 0
python3 src/plot_barplot.py ${WORKLOAD_TP} Total_flow ${CLUSTER_TP} 0
python3 src/plot_barplot.py ${WORKLOAD_TP} Transfer_time ${CLUSTER_TP} 0
python3 src/plot_barplot.py ${WORKLOAD_TP} Makespan ${CLUSTER_TP} 0
python3 src/plot_barplot.py ${WORKLOAD_TP} Core_time_used ${CLUSTER_TP} 0
python3 src/plot_barplot.py ${WORKLOAD_TP} Waiting_for_a_load_time ${CLUSTER_TP} 0
python3 src/plot_barplot.py ${WORKLOAD_TP} Total_waiting_for_a_load_time_and_transfer_time ${CLUSTER_TP} 0

end=`date +%s` 
runtime=$((end-start))
echo "Execution complete! It lasted" $((runtime/60))" minute(s) and "$((runtime%60))" second(s)."
