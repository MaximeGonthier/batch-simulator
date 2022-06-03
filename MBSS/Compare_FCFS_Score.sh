#!/bin/bash
# bash Compare_FCFS_Score.sh workload cluster contrainte_taille
start=`date +%s`

if [ "$#" -ne 3 ]; then
    echo "Usage is bash Compare_algorithms.sh workload cluster contraintes_tailles_données"
    exit
fi

# Get arguments
WORKLOAD=$1
WORKLOAD_TP=${WORKLOAD:27}
CLUSTER=$2
CLUSTER_TP=${CLUSTER:24}
CLUSTER_TP=${CLUSTER_TP::-4}
echo "Workload:" ${WORKLOAD_TP}
echo "Cluster:" ${CLUSTER_TP}
CONTRAINTES_TAILLES=$3

#~ # 1. Queue times, flow times and stretch of FCFS_SCORE VS FCFS
#~ SCHEDULER_REF="Fcfs"
#~ echo "${SCHEDULER_REF}"
#~ python3 -O src/main_multi_core.py $WORKLOAD $CLUSTER $SCHEDULER_REF 0 $CONTRAINTES_TAILLES
#~ SCHEDULER_COMP="Fcfs_with_a_score_x1_x1_x1"
#~ echo "${SCHEDULER_COMP}"
#~ python3 -O src/main_multi_core.py $WORKLOAD $CLUSTER $SCHEDULER_COMP 0 $CONTRAINTES_TAILLES
#~ echo "Plotting Queue, Flow, Stretch of each job:" ${SCHEDULER_REF} "VS" ${SCHEDULER_COMP}
#~ python3 src/plot_queue_times.py outputs/Queue_times_${SCHEDULER_REF}.txt outputs/Queue_times_${SCHEDULER_COMP}.txt 0
#~ mv outputs/Queue_times_${SCHEDULER_REF}.txt data/Queue_times_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER_REF}.txt
#~ mv outputs/Queue_times_${SCHEDULER_COMP}.txt data/Queue_times_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER_COMP}.txt
#~ mv plot.pdf plot/Queue_times_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER_REF}_VS_${SCHEDULER_COMP}.pdf
#~ python3 src/plot_queue_times.py outputs/Flow_times_${SCHEDULER_REF}.txt outputs/Flow_times_${SCHEDULER_COMP}.txt 0
#~ mv outputs/Flow_times_${SCHEDULER_REF}.txt data/Flow_times_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER_REF}.txt
#~ mv outputs/Flow_times_${SCHEDULER_COMP}.txt data/Flow_times_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER_COMP}.txt
#~ mv plot.pdf plot/Flow_times_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER_REF}_VS_${SCHEDULER_COMP}.pdf
#~ python3 src/plot_queue_times.py outputs/Stretch_times_${SCHEDULER_REF}.txt outputs/Stretch_times_${SCHEDULER_COMP}.txt 1
#~ mv outputs/Stretch_times_${SCHEDULER_REF}.txt data/Stretch_times_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER_REF}.txt
#~ mv outputs/Stretch_times_${SCHEDULER_COMP}.txt data/Stretch_times_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER_COMP}.txt
#~ mv plot.pdf plot/Stretch_times_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER_REF}_VS_${SCHEDULER_COMP}.pdf

#~ # 2. Stretch of multiple algorithms on a same plot
#~ SCHEDULER_1="Fcfs_with_a_score_x1_x1_x1"
#~ echo "${SCHEDULER_1}"
#~ python3 -O src/main_multi_core.py $WORKLOAD $CLUSTER $SCHEDULER_1 0 $CONTRAINTES_TAILLES
#~ SCHEDULER_2="Fcfs_with_a_score_x2_x2_x2"
#~ echo "${SCHEDULER_2}"
#~ python3 -O src/main_multi_core.py $WORKLOAD $CLUSTER $SCHEDULER_2 0 $CONTRAINTES_TAILLES
#~ SCHEDULER_3="Fcfs_with_a_score_x3_x3_x3"
#~ echo "${SCHEDULER_3}"
#~ python3 -O src/main_multi_core.py $WORKLOAD $CLUSTER $SCHEDULER_3 0 $CONTRAINTES_TAILLES
#~ python3 src/plot_stretch_multiple_schedulers.py ${SCHEDULER_1} ${SCHEDULER_2} ${SCHEDULER_3}
#~ mv outputs/Stretch_times_${SCHEDULER_1}.txt data/Stretch_times_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER_1}.txt
#~ mv outputs/Stretch_times_${SCHEDULER_2}.txt data/Stretch_times_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER_2}.txt
#~ mv outputs/Stretch_times_${SCHEDULER_3}.txt data/Stretch_times_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER_3}.txt
#~ mv plot.pdf plot/Stretch_times_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER_1}_${SCHEDULER_2}_${SCHEDULER_3}.pdf

# 3. Barplots and heatmap of stretch
echo "Scheduler,Number of jobs,Maximum queue time,Mean queue time,Total queue time,Maximum flow,Mean flow,Total flow,Transfer time,Makespan,Core time used, Waiting for a load time, Total waiting for a load time and transfer time, Mean Stretch" > outputs/Results_FCFS_Score_${WORKLOAD_TP}_${CLUSTER_TP}.csv
truncate -s 0 outputs/heatmap.txt

for ((i=1; i<=4; i++))
do
	# Schedulers
	TYPE_HEATMAP_MULTIPLIER=X1_X2
	if [ $((i)) == 1 ]; then SCHEDULER="Fcfs_with_a_score_x0_x0_x0"
	elif [ $((i)) == 2 ]; then SCHEDULER="Fcfs_with_a_score_x0_x1_x0"
	elif [ $((i)) == 3 ]; then SCHEDULER="Fcfs_with_a_score_x1_x0_x0"
	elif [ $((i)) == 4 ]; then SCHEDULER="Fcfs_with_a_score_x1_x1_x0"
	#~ elif [ $((i)) == 3 ]; then SCHEDULER="Fcfs_with_a_score_x0_x2_x1"
	#~ elif [ $((i)) == 4 ]; then SCHEDULER="Fcfs_with_a_score_x0_x3_x1"
	#~ elif [ $((i)) == 5 ]; then SCHEDULER="Fcfs_with_a_score_x0_x4_x1"
	#~ elif [ $((i)) == 6 ]; then SCHEDULER="Fcfs_with_a_score_x1_x0_x1"
	#~ elif [ $((i)) == 7 ]; then SCHEDULER="Fcfs_with_a_score_x1_x1_x1"
	#~ elif [ $((i)) == 8 ]; then SCHEDULER="Fcfs_with_a_score_x1_x2_x1"
	#~ elif [ $((i)) == 9 ]; then SCHEDULER="Fcfs_with_a_score_x1_x3_x1"
	#~ elif [ $((i)) == 10 ]; then SCHEDULER="Fcfs_with_a_score_x1_x4_x1"
	#~ elif [ $((i)) == 11 ]; then SCHEDULER="Fcfs_with_a_score_x2_x0_x1"
	#~ elif [ $((i)) == 12 ]; then SCHEDULER="Fcfs_with_a_score_x2_x1_x1"
	#~ elif [ $((i)) == 13 ]; then SCHEDULER="Fcfs_with_a_score_x2_x2_x1"
	#~ elif [ $((i)) == 14 ]; then SCHEDULER="Fcfs_with_a_score_x2_x3_x1"
	#~ elif [ $((i)) == 15 ]; then SCHEDULER="Fcfs_with_a_score_x2_x4_x1"
	#~ elif [ $((i)) == 16 ]; then SCHEDULER="Fcfs_with_a_score_x3_x0_x1"
	#~ elif [ $((i)) == 17 ]; then SCHEDULER="Fcfs_with_a_score_x3_x1_x1"
	#~ elif [ $((i)) == 18 ]; then SCHEDULER="Fcfs_with_a_score_x3_x2_x1"
	#~ elif [ $((i)) == 19 ]; then SCHEDULER="Fcfs_with_a_score_x3_x3_x1"
	#~ elif [ $((i)) == 20 ]; then SCHEDULER="Fcfs_with_a_score_x3_x4_x1"
	#~ elif [ $((i)) == 21 ]; then SCHEDULER="Fcfs_with_a_score_x4_x0_x1"
	#~ elif [ $((i)) == 22 ]; then SCHEDULER="Fcfs_with_a_score_x4_x1_x1"
	#~ elif [ $((i)) == 23 ]; then SCHEDULER="Fcfs_with_a_score_x4_x2_x1"
	#~ elif [ $((i)) == 24 ]; then SCHEDULER="Fcfs_with_a_score_x4_x3_x1"
	#~ elif [ $((i)) == 25 ]; then SCHEDULER="Fcfs_with_a_score_x4_x4_x1"
	fi
	#~ if [ $((i)) == 1 ]; then SCHEDULER="Fcfs_with_a_score_x0_x1_x0"
	#~ elif [ $((i)) == 2 ]; then SCHEDULER="Fcfs_with_a_score_x0_x1_x1"
	#~ elif [ $((i)) == 3 ]; then SCHEDULER="Fcfs_with_a_score_x0_x1_x2"
	#~ elif [ $((i)) == 4 ]; then SCHEDULER="Fcfs_with_a_score_x0_x1_x3"
	#~ elif [ $((i)) == 5 ]; then SCHEDULER="Fcfs_with_a_score_x0_x1_x4"
	#~ elif [ $((i)) == 6 ]; then SCHEDULER="Fcfs_with_a_score_x1_x1_x0"
	#~ elif [ $((i)) == 7 ]; then SCHEDULER="Fcfs_with_a_score_x1_x1_x1"
	#~ elif [ $((i)) == 8 ]; then SCHEDULER="Fcfs_with_a_score_x1_x1_x2"
	#~ elif [ $((i)) == 9 ]; then SCHEDULER="Fcfs_with_a_score_x1_x1_x3"
	#~ elif [ $((i)) == 10 ]; then SCHEDULER="Fcfs_with_a_score_x1_x1_x4"
	#~ elif [ $((i)) == 11 ]; then SCHEDULER="Fcfs_with_a_score_x2_x1_x0"
	#~ elif [ $((i)) == 12 ]; then SCHEDULER="Fcfs_with_a_score_x2_x1_x1"
	#~ elif [ $((i)) == 13 ]; then SCHEDULER="Fcfs_with_a_score_x2_x1_x2"
	#~ elif [ $((i)) == 14 ]; then SCHEDULER="Fcfs_with_a_score_x2_x1_x3"
	#~ elif [ $((i)) == 15 ]; then SCHEDULER="Fcfs_with_a_score_x2_x1_x4"
	#~ elif [ $((i)) == 16 ]; then SCHEDULER="Fcfs_with_a_score_x3_x1_x0"
	#~ elif [ $((i)) == 17 ]; then SCHEDULER="Fcfs_with_a_score_x3_x1_x1"
	#~ elif [ $((i)) == 18 ]; then SCHEDULER="Fcfs_with_a_score_x3_x1_x2"
	#~ elif [ $((i)) == 19 ]; then SCHEDULER="Fcfs_with_a_score_x3_x1_x3"
	#~ elif [ $((i)) == 20 ]; then SCHEDULER="Fcfs_with_a_score_x3_x1_x4"
	#~ elif [ $((i)) == 21 ]; then SCHEDULER="Fcfs_with_a_score_x4_x1_x0"
	#~ elif [ $((i)) == 22 ]; then SCHEDULER="Fcfs_with_a_score_x4_x1_x1"
	#~ elif [ $((i)) == 23 ]; then SCHEDULER="Fcfs_with_a_score_x4_x1_x2"
	#~ elif [ $((i)) == 24 ]; then SCHEDULER="Fcfs_with_a_score_x4_x1_x3"
	#~ elif [ $((i)) == 25 ]; then SCHEDULER="Fcfs_with_a_score_x4_x1_x4"
	#~ fi
	
	truncate -s 0 outputs/Results_${SCHEDULER}.csv
	echo "${SCHEDULER}"
	# ../../pypy3.9-v7.3.9-linux64/bin/pypy3 -O src/main_multi_core.py $WORKLOAD $CLUSTER $SCHEDULER 0 $CONTRAINTES_TAILLES
	python3 -O src/main_multi_core.py $WORKLOAD $CLUSTER $SCHEDULER 0 $CONTRAINTES_TAILLES
	echo "Results ${SCHEDULER} are:"
	head outputs/Results_${SCHEDULER}.csv
	cat outputs/Results_${SCHEDULER}.csv >> outputs/Results_FCFS_Score_${WORKLOAD_TP}_${CLUSTER_TP}.csv
	cat outputs/Stretch_${SCHEDULER}.txt >> outputs/heatmap.txt
	echo "" >> outputs/heatmap.txt
done

echo "Final results are:"
cat outputs/Results_FCFS_Score_${WORKLOAD_TP}.csv

#~ echo "Plotting results..."
#~ python3 src/plot_barplot.py FCFS_Score_${WORKLOAD_TP} Maximum_queue_time ${CLUSTER_TP} 0
#~ python3 src/plot_barplot.py FCFS_Score_${WORKLOAD_TP} Mean_queue_time ${CLUSTER_TP} 0
#~ python3 src/plot_barplot.py FCFS_Score_${WORKLOAD_TP} Total_queue_time ${CLUSTER_TP} 0
#~ python3 src/plot_barplot.py FCFS_Score_${WORKLOAD_TP} Maximum_flow ${CLUSTER_TP} 0
#~ python3 src/plot_barplot.py FCFS_Score_${WORKLOAD_TP} Mean_flow ${CLUSTER_TP} 0
#~ python3 src/plot_barplot.py FCFS_Score_${WORKLOAD_TP} Total_flow ${CLUSTER_TP} 0
#~ python3 src/plot_barplot.py FCFS_Score_${WORKLOAD_TP} Transfer_time ${CLUSTER_TP} 0
#~ python3 src/plot_barplot.py FCFS_Score_${WORKLOAD_TP} Makespan ${CLUSTER_TP} 0
#~ python3 src/plot_barplot.py FCFS_Score_${WORKLOAD_TP} Core_time_used ${CLUSTER_TP} 0
#~ python3 src/plot_barplot.py FCFS_Score_${WORKLOAD_TP} Waiting_for_a_load_time ${CLUSTER_TP} 0
#~ python3 src/plot_barplot.py FCFS_Score_${WORKLOAD_TP} Total_waiting_for_a_load_time_and_transfer_time ${CLUSTER_TP} 0

echo "Plotting heatmap..."
python3 src/plot_heatmap.py outputs/heatmap.txt ${WORKLOAD_TP} 2
mv plot.pdf plot/Heatmap_FCFS_Score_${TYPE_HEATMAP_MULTIPLIER}_${WORKLOAD_TP}_${CLUSTER_TP}.pdf
mv outputs/heatmap.txt data/Heatmap_FCFS_Score_${TYPE_HEATMAP_MULTIPLIER}_${WORKLOAD_TP}_${CLUSTER_TP}.txt

echo "Moving data..."
mv outputs/Results_FCFS_Score_${WORKLOAD_TP}_${CLUSTER_TP}.csv data/Results_FCFS_Score_${WORKLOAD_TP}_${CLUSTER_TP}.csv

end=`date +%s` 
runtime=$((end-start))
echo "Execution complete! It lasted" $((runtime/60))" minute(s) and "$((runtime%60))" second(s)."
