#!/bin/bash
start=`date +%s`

if [ "$#" -ne 4 ]; then
    echo "Usage is bash *.sh workload cluster algo1 algo2"
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

SCHEDULER=$3
echo "${SCHEDULER}"
python3 -O src/main_multi_core.py $WORKLOAD $CLUSTER $SCHEDULER 0 0
SCHEDULER=$4
echo "${SCHEDULER}"
python3 -O src/main_multi_core.py $WORKLOAD $CLUSTER $SCHEDULER 0 0

echo "Plotting results..."
python3 src/plot_queue_times.py outputs/Stretch_times_$4.txt outputs/Stretch_times_$3.txt 1
mv plot.pdf plot/Stretch_times_$3_$4_${WORKLOAD_TP}_${CLUSTER_TP}.pdf

# Moving main csv data file
mv outputs/Stretch_times_$4.txt data/Stretch_times_$4_${WORKLOAD_TP}_${CLUSTER_TP}.txt
mv outputs/Stretch_times_$3.txt data/Stretch_times_$3_${WORKLOAD_TP}_${CLUSTER_TP}.txt

end=`date +%s` 
runtime=$((end-start))
echo "Execution complete! It lasted" $((runtime/60))" minute(s) and "$((runtime%60))" second(s)."
