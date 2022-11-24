#!/bin/bash
start=`date +%s`

if [ "$#" -ne 2 ]; then
    echo "Usage is bash *.sh workload cluster"
    exit
fi

# Get arguments
WORKLOAD=$1
WORKLOAD_TP=${WORKLOAD:27}
CLUSTER=$2
CLUSTER_TP=${CLUSTER:24}
CLUSTER_TP=${CLUSTER_TP::-4}
echo ${WORKLOAD_TP}
echo ${CLUSTER_TP}

make print_distribution_queue_times -C C/

SCHEDULER="Fcfs"
echo "${SCHEDULER}"
#~ ./C/main $WORKLOAD $CLUSTER $SCHEDULER 0 outputs/test.csv 2 80

SCHEDULER="Fcfs_with_a_score_mixed_strategy_x500_x1_x0_x0"
echo "${SCHEDULER}"
#~ ./C/main $WORKLOAD $CLUSTER $SCHEDULER 0 outputs/test.csv 2 80

echo "Plotting results..."
#~ python3 src/plot_queue_times.py outputs/Stretch_times_FCFS.txt "outputs/Stretch_times_EFT-SCORE MIX.txt" stretch
python3 src/plot_queue_times.py data/Stretch_times_FCFS_${WORKLOAD_TP}_${CLUSTER_TP}.txt  data/Stretch_times_EFT-SCORE-MIX_${WORKLOAD_TP}_${CLUSTER_TP}.txt stretch
mv plot.pdf plot/Stretch_times_FCFS_EFT-SCORE-MIX_${WORKLOAD_TP}_${CLUSTER_TP}.pdf

# Moving main csv data file
#~ mv outputs/Stretch_times_FCFS.txt data/Stretch_times_FCFS_${WORKLOAD_TP}_${CLUSTER_TP}.txt
#~ mv "outputs/Stretch_times_EFT-SCORE MIX.txt" data/Stretch_times_EFT-SCORE-MIX_${WORKLOAD_TP}_${CLUSTER_TP}.txt

end=`date +%s` 
runtime=$((end-start))
echo "Execution complete! It lasted" $((runtime/60))" minute(s) and "$((runtime%60))" second(s)."
