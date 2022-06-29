#!/bin/bash
# bash Plot_heatmap.sh workload cluster multiplier_1 multiplier_2 N PAS
start=`date +%s`

if [ "$#" -ne 6 ]; then
    echo "Usage is bash Plot_heatmap.sh workload cluster multiplier_1 multiplier_2 N PAS"
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
		
N=$5
MULTIPLIER_1=$3
MULTIPLIER_2=$4
PAS=$6
			
echo "Plotting heatmap ${MULTIPLIER_1} X ${MULTIPLIER_2}"
	
python3 src/plot_heatmap.py data/Heatmap_Stretch_FCFS_Score_${MULTIPLIER_1}_${MULTIPLIER_2}_${WORKLOAD_TP}_${CLUSTER_TP}.txt $((N)) ${MULTIPLIER_1} ${MULTIPLIER_2} $((PAS)) "Mean_Flow_Stretch"
mv plot.pdf plot/Heatmap_Stretch_FCFS_Score_${MULTIPLIER_1}_${MULTIPLIER_2}_${WORKLOAD_TP}_${CLUSTER_TP}.pdf
	
python3 src/plot_heatmap.py data/Heatmap_Stretch_with_a_minimum_FCFS_Score_${MULTIPLIER_1}_${MULTIPLIER_2}_${WORKLOAD_TP}_${CLUSTER_TP}.txt $((N)) ${MULTIPLIER_1} ${MULTIPLIER_2} $((PAS)) "Mean_Bounded_Flow_Stretch"
mv plot.pdf plot/Heatmap_Stretch_with_a_minimum_FCFS_Score_${MULTIPLIER_1}_${MULTIPLIER_2}_${WORKLOAD_TP}_${CLUSTER_TP}.pdf
	
python3 src/plot_heatmap.py data/Heatmap_Total_Flow_FCFS_Score_${MULTIPLIER_1}_${MULTIPLIER_2}_${WORKLOAD_TP}_${CLUSTER_TP}.txt $((N)) ${MULTIPLIER_1} ${MULTIPLIER_2} $((PAS)) "Total_Flow"
mv plot.pdf plot/Heatmap_Total_Flow_FCFS_Score_${MULTIPLIER_1}_${MULTIPLIER_2}_${WORKLOAD_TP}_${CLUSTER_TP}.pdf
	
python3 src/plot_heatmap.py data/Heatmap_Max_Stretch_FCFS_Score_${MULTIPLIER_1}_${MULTIPLIER_2}_${WORKLOAD_TP}_${CLUSTER_TP}.txt $((N)) ${MULTIPLIER_1} ${MULTIPLIER_2} $((PAS)) "Max_Flow_Stretch"
mv plot.pdf plot/Heatmap_Max_Stretch_FCFS_Score_${MULTIPLIER_1}_${MULTIPLIER_2}_${WORKLOAD_TP}_${CLUSTER_TP}.pdf
	
python3 src/plot_heatmap.py data/Heatmap_Max_Stretch_with_a_minimum_FCFS_Score_${MULTIPLIER_1}_${MULTIPLIER_2}_${WORKLOAD_TP}_${CLUSTER_TP}.txt $((N)) ${MULTIPLIER_1} ${MULTIPLIER_2} $((PAS)) "Max_Bounded_Flow_Stretch"
mv plot.pdf plot/Heatmap_Max_Stretch_with_a_minimum_FCFS_Score_${MULTIPLIER_1}_${MULTIPLIER_2}_${WORKLOAD_TP}_${CLUSTER_TP}.pdf
	
python3 src/plot_heatmap.py data/Heatmap_Max_Flow_FCFS_Score_${MULTIPLIER_1}_${MULTIPLIER_2}_${WORKLOAD_TP}_${CLUSTER_TP}.txt $((N)) ${MULTIPLIER_1} ${MULTIPLIER_2} $((PAS)) "Max_Flow"
mv plot.pdf plot/Heatmap_Max_Flow_FCFS_Score_${MULTIPLIER_1}_${MULTIPLIER_2}_${WORKLOAD_TP}_${CLUSTER_TP}.pdf
	
echo "Plotting heatmap ok for ${MULTIPLIER_1} X ${MULTIPLIER_2}"

end=`date +%s` 
runtime=$((end-start))
echo "Execution complete! It lasted" $((runtime/60))" minute(s) and "$((runtime%60))" second(s)."
