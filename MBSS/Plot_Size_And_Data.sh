start=`date +%s`

# Get arguments
WORKLOAD=$1
WORKLOAD_TP=${WORKLOAD:27}
CLUSTER=$2
CLUSTER_TP=${CLUSTER:24}
CLUSTER_TP=${CLUSTER_TP::-4}
echo ${WORKLOAD_TP}
echo ${CLUSTER_TP}
CONTRAINTES_TAILLES=1

echo "Plotting results..."
python3 src/plot_barplot.py Results_Size_And_Data_${WORKLOAD_TP} Maximum_queue_time ${CLUSTER_TP} 0 data/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Results_Size_And_Data_${WORKLOAD_TP} Mean_queue_time ${CLUSTER_TP} 0 data/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Results_Size_And_Data_${WORKLOAD_TP} Total_queue_time ${CLUSTER_TP} 0 data/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Results_Size_And_Data_${WORKLOAD_TP} Maximum_flow ${CLUSTER_TP} 0 data/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Results_Size_And_Data_${WORKLOAD_TP} Mean_flow ${CLUSTER_TP} 0 data/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Results_Size_And_Data_${WORKLOAD_TP} Total_flow ${CLUSTER_TP} 0 data/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Results_Size_And_Data_${WORKLOAD_TP} Transfer_time ${CLUSTER_TP} 0 data/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Results_Size_And_Data_${WORKLOAD_TP} Makespan ${CLUSTER_TP} 0 data/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Results_Size_And_Data_${WORKLOAD_TP} Core_time_used ${CLUSTER_TP} 0 data/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Results_Size_And_Data_${WORKLOAD_TP} Waiting_for_a_load_time ${CLUSTER_TP} 0 data/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Results_Size_And_Data_${WORKLOAD_TP} Total_waiting_for_a_load_time_and_transfer_time ${CLUSTER_TP} 0 data/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Results_Size_And_Data_${WORKLOAD_TP} Mean_Stretch ${CLUSTER_TP} 0 data/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Results_Size_And_Data_${WORKLOAD_TP} Mean_Stretch_With_a_Minimum ${CLUSTER_TP} 0 data/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Results_Size_And_Data_${WORKLOAD_TP} Max_Stretch ${CLUSTER_TP} 0 data/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Results_Size_And_Data_${WORKLOAD_TP} Max_Stretch_With_a_Minimum ${CLUSTER_TP} 0 data/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Results_Size_And_Data_${WORKLOAD_TP} Nb_Upgraded_Jobs ${CLUSTER_TP} 0 data/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Results_Size_And_Data_${WORKLOAD_TP} Mean_Stretch_128 ${CLUSTER_TP} 0 data/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Results_Size_And_Data_${WORKLOAD_TP} Mean_Stretch_256 ${CLUSTER_TP} 0 data/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Results_Size_And_Data_${WORKLOAD_TP} Mean_Stretch_1024 ${CLUSTER_TP} 0 data/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Results_Size_And_Data_${WORKLOAD_TP} Mean_Stretch_With_a_Minimum_128 ${CLUSTER_TP} 0 data/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Results_Size_And_Data_${WORKLOAD_TP} Mean_Stretch_With_a_Minimum_256 ${CLUSTER_TP} 0 data/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py Results_Size_And_Data_${WORKLOAD_TP} Mean_Stretch_With_a_Minimum_1024 ${CLUSTER_TP} 0 data/Results_Size_And_Data_${WORKLOAD_TP}_${CLUSTER_TP}.csv

end=`date +%s` 
runtime=$((end-start))
echo "Execution complete! It lasted" $((runtime/60))" minute(s) and "$((runtime%60))" second(s)."
