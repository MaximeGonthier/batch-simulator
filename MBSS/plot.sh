#!/bin/bash
# bash plot.sh workload cluster data_file

start=`date +%s`

if [ "$#" -ne 3 ]; then
    echo "Usage is bash plot.sh workload cluster data_file"
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
DATA_FILE=$3

python3 src/plot_barplot.py Results_FCFS_Score_Adaptative_Multiplier_${WORKLOAD_TP} Maximum_queue_time ${CLUSTER_TP} 0 ${DATA_FILE}
python3 src/plot_barplot.py Results_FCFS_Score_Adaptative_Multiplier_${WORKLOAD_TP} Mean_queue_time ${CLUSTER_TP} 0 ${DATA_FILE}
python3 src/plot_barplot.py Results_FCFS_Score_Adaptative_Multiplier_${WORKLOAD_TP} Total_queue_time ${CLUSTER_TP} 0 ${DATA_FILE}
python3 src/plot_barplot.py Results_FCFS_Score_Adaptative_Multiplier_${WORKLOAD_TP} Maximum_flow ${CLUSTER_TP} 0 ${DATA_FILE}
python3 src/plot_barplot.py Results_FCFS_Score_Adaptative_Multiplier_${WORKLOAD_TP} Mean_flow ${CLUSTER_TP} 0 ${DATA_FILE}
python3 src/plot_barplot.py Results_FCFS_Score_Adaptative_Multiplier_${WORKLOAD_TP} Total_flow ${CLUSTER_TP} 0 ${DATA_FILE}
python3 src/plot_barplot.py Results_FCFS_Score_Adaptative_Multiplier_${WORKLOAD_TP} Transfer_time ${CLUSTER_TP} 0 ${DATA_FILE}
python3 src/plot_barplot.py Results_FCFS_Score_Adaptative_Multiplier_${WORKLOAD_TP} Makespan ${CLUSTER_TP} 0 ${DATA_FILE}
python3 src/plot_barplot.py Results_FCFS_Score_Adaptative_Multiplier_${WORKLOAD_TP} Core_time_used ${CLUSTER_TP} 0 ${DATA_FILE}
python3 src/plot_barplot.py Results_FCFS_Score_Adaptative_Multiplier_${WORKLOAD_TP} Waiting_for_a_load_time ${CLUSTER_TP} 0 ${DATA_FILE}
python3 src/plot_barplot.py Results_FCFS_Score_Adaptative_Multiplier_${WORKLOAD_TP} Total_waiting_for_a_load_time_and_transfer_time ${CLUSTER_TP} 0 ${DATA_FILE}
python3 src/plot_barplot.py Results_FCFS_Score_Adaptative_Multiplier_${WORKLOAD_TP} Mean_Stretch ${CLUSTER_TP} 0 ${DATA_FILE}
python3 src/plot_barplot.py Results_FCFS_Score_Adaptative_Multiplier_${WORKLOAD_TP} Mean_Stretch_With_a_Minimum ${CLUSTER_TP} 0 ${DATA_FILE}
python3 src/plot_barplot.py Results_FCFS_Score_Adaptative_Multiplier_${WORKLOAD_TP} Max_Stretch ${CLUSTER_TP} 0 ${DATA_FILE}
python3 src/plot_barplot.py Results_FCFS_Score_Adaptative_Multiplier_${WORKLOAD_TP} Max_Stretch_With_a_Minimum ${CLUSTER_TP} 0 ${DATA_FILE}
python3 src/plot_barplot.py Results_FCFS_Score_Adaptative_Multiplier_${WORKLOAD_TP} Nb_Upgraded_Jobs ${CLUSTER_TP} 0 ${DATA_FILE}
python3 src/plot_barplot.py Results_FCFS_Score_Adaptative_Multiplier_${WORKLOAD_TP} Mean_Stretch_128 ${CLUSTER_TP} 0 ${DATA_FILE}
python3 src/plot_barplot.py Results_FCFS_Score_Adaptative_Multiplier_${WORKLOAD_TP} Mean_Stretch_256 ${CLUSTER_TP} 0 ${DATA_FILE}
python3 src/plot_barplot.py Results_FCFS_Score_Adaptative_Multiplier_${WORKLOAD_TP} Mean_Stretch_1024 ${CLUSTER_TP} 0 ${DATA_FILE}
python3 src/plot_barplot.py Results_FCFS_Score_Adaptative_Multiplier_${WORKLOAD_TP} Mean_Stretch_With_a_Minimum_128 ${CLUSTER_TP} 0 ${DATA_FILE}
python3 src/plot_barplot.py Results_FCFS_Score_Adaptative_Multiplier_${WORKLOAD_TP} Mean_Stretch_With_a_Minimum_256 ${CLUSTER_TP} 0 ${DATA_FILE}
python3 src/plot_barplot.py Results_FCFS_Score_Adaptative_Multiplier_${WORKLOAD_TP} Mean_Stretch_With_a_Minimum_1024 ${CLUSTER_TP} 0 ${DATA_FILE}

end=`date +%s` 
runtime=$((end-start))
echo "Execution complete! It lasted" $((runtime/60))" minute(s) and "$((runtime%60))" second(s)."
