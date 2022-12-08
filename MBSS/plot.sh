#!/bin/bash
# bash plot.sh workload cluster data_file

if [ "$#" -le 4 ]; then
    echo "Usage is bash plot.sh workload cluster data_file model percentage_mode(0 or 1) nbjobsworkload1(optional)"
    exit
fi

# Get arguments
WORKLOAD=$1
WORKLOAD_TP=${WORKLOAD:27}
CLUSTER=$2
CLUSTER_TP=${CLUSTER:24}
CLUSTER_TP=${CLUSTER_TP::-4}
DATA_FILE=$3
PERCENTAGE_MODE=$5
MODEL=$4
echo "Workload: ${WORKLOAD_TP} | Model: ${MODEL} | Percentage mode: ${PERCENTAGE_MODE}"

#~ VAR="Percentage_FCFS"

#~ if [[ "$MODEL"=="$VAR" ]]; then
	#~ PERCENTAGE_MODE=1
#~ else
#~ fi

#~ python3 src/get_nb_evaluated_jobs.py ${WORKLOAD}

#~ python3 src/plot_barplot.py Results_${MODEL}_${WORKLOAD_TP} Maximum_queue_time ${CLUSTER_TP} 0 ${DATA_FILE} ${PERCENTAGE_MODE}
#~ python3 src/plot_barplot.py Results_${MODEL}_${WORKLOAD_TP} Mean_queue_time ${CLUSTER_TP} 0 ${DATA_FILE}
#~ python3 src/plot_barplot.py Results_${MODEL}_${WORKLOAD_TP} Total_queue_time ${CLUSTER_TP} 0 ${DATA_FILE}
#~ python3 src/plot_barplot.py Results_${MODEL}_${WORKLOAD_TP} Maximum_flow ${CLUSTER_TP} 0 ${DATA_FILE}
#~ python3 src/plot_barplot.py Results_${MODEL}_${WORKLOAD_TP} Mean_flow ${CLUSTER_TP} 0 ${DATA_FILE}
#~ python3 src/plot_barplot.py Results_${MODEL}_${WORKLOAD_TP} Total_flow ${CLUSTER_TP} 0 ${DATA_FILE} ${PERCENTAGE_MODE}
#~ python3 src/plot_barplot.py Results_${MODEL}_${WORKLOAD_TP} Transfer_time ${CLUSTER_TP} 0 ${DATA_FILE}
#~ python3 src/plot_barplot.py Results_${MODEL}_${WORKLOAD_TP} Makespan ${CLUSTER_TP} 0 ${DATA_FILE}
#~ python3 src/plot_barplot.py Results_${MODEL}_${WORKLOAD_TP} Core_time_used ${CLUSTER_TP} 0 ${DATA_FILE}
#~ python3 src/plot_barplot.py Results_${MODEL}_${WORKLOAD_TP} Waiting_for_a_load_time ${CLUSTER_TP} 0 ${DATA_FILE}
#~ python3 src/plot_barplot.py Results_${MODEL}_${WORKLOAD_TP} Mean_Stretch_With_a_Minimum ${CLUSTER_TP} 0 ${DATA_FILE} ${PERCENTAGE_MODE}
#~ python3 src/plot_barplot.py Results_${MODEL}_${WORKLOAD_TP} Max_Stretch ${CLUSTER_TP} 0 ${DATA_FILE}
#~ python3 src/plot_barplot.py Results_${MODEL}_${WORKLOAD_TP} Max_Stretch_With_a_Minimum ${CLUSTER_TP} 0 ${DATA_FILE}
#~ python3 src/plot_barplot.py Results_${MODEL}_${WORKLOAD_TP} Nb_Upgraded_Jobs ${CLUSTER_TP} 0 ${DATA_FILE}
#~ python3 src/plot_barplot.py Results_${MODEL}_${WORKLOAD_TP} Mean_Stretch_128 ${CLUSTER_TP} 0 ${DATA_FILE}
#~ python3 src/plot_barplot.py Results_${MODEL}_${WORKLOAD_TP} Mean_Stretch_256 ${CLUSTER_TP} 0 ${DATA_FILE}
#~ python3 src/plot_barplot.py Results_${MODEL}_${WORKLOAD_TP} Mean_Stretch_1024 ${CLUSTER_TP} 0 ${DATA_FILE}
#~ python3 src/plot_barplot.py Results_${MODEL}_${WORKLOAD_TP} Mean_Stretch_With_a_Minimum_128 ${CLUSTER_TP} 0 ${DATA_FILE}
#~ python3 src/plot_barplot.py Results_${MODEL}_${WORKLOAD_TP} Mean_Stretch_With_a_Minimum_256 ${CLUSTER_TP} 0 ${DATA_FILE}
#~ python3 src/plot_barplot.py Results_${MODEL}_${WORKLOAD_TP} Mean_Stretch_With_a_Minimum_1024 ${CLUSTER_TP} 0 ${DATA_FILE}

# OLD
#~ python3 src/plot_barplot.py Results_${MODEL}_${WORKLOAD_TP} Mean_Stretch ${CLUSTER_TP} 0 ${DATA_FILE} ${PERCENTAGE_MODE}
#~ python3 src/plot_barplot.py Results_${MODEL}_${WORKLOAD_TP} Total_waiting_for_a_load_time_and_transfer_time ${CLUSTER_TP} 0 ${DATA_FILE} ${PERCENTAGE_MODE}
#~ if [[ ${MODEL} == "FCFS_Score_Backfill" && "$#" == 6 ]]; then
	#~ python3 src/plot_barplot.py Results_${MODEL}_${WORKLOAD_TP} Number_of_data_reuse ${CLUSTER_TP} 0 ${DATA_FILE} ${PERCENTAGE_MODE} $6
#~ fi

# NEW
#~ python3 src/plot_dot_and_bar.py Results_${MODEL}_${WORKLOAD_TP} Mean_Stretch Total_waiting_for_a_load_time_and_transfer_time ${CLUSTER_TP} ${DATA_FILE} ${PERCENTAGE_MODE}
