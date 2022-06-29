#!/bin/bash
# bash Compare_FCFS_Score.sh workload cluster contrainte_taille
start=`date +%s`

#~ if [ "$#" -ne 3 ]; then
    #~ echo "Usage is bash Compare_algorithms.sh workload cluster contraintes_tailles_données"
    #~ exit
#~ fi

# Get arguments
WORKLOAD=$1
WORKLOAD_TP=${WORKLOAD:27}
CLUSTER=$2
CLUSTER_TP=${CLUSTER:24}
CLUSTER_TP=${CLUSTER_TP::-4}
echo "Workload:" ${WORKLOAD_TP}
echo "Cluster:" ${CLUSTER_TP}
CONTRAINTES_TAILLES=$3
echo "Contraintes tailles:" ${CONTRAINTES_TAILLES}

make -C C/

#~ # 1. Queue times, flow times and stretch of all jobs of FCFS_SCORE VS FCFS
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

#~ # 2. Stretch of all jobs of multiple algorithms on a same plot
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

#~ # 3. Curve with 2 fixed parameters and varying only one
#~ truncate -s 0 outputs/stretch.txt
#~ PAS=5000
#~ for ((i=0; i<5; i++))
#~ do
	#~ M1=$((i*PAS))
	#~ M2=0
	#~ M3=0
	#~ SCHEDULER="Fcfs_with_a_score_x${M1}_x${M2}_x${M3}"
	#~ echo "Starting ${SCHEDULER}"
	#~ python3 -O src/main_multi_core.py $WORKLOAD $CLUSTER $SCHEDULER 0 $CONTRAINTES_TAILLES
	#~ cat outputs/Stretch_${SCHEDULER}.txt >> outputs/stretch.txt
	#~ echo "" >> outputs/stretch.txt
#~ done

#~ MULTIPLIER=Time_to_load_file

#~ python3 src/plot_curve.py outputs/stretch.txt ${PAS} ${MULTIPLIER}
#~ mv outputs/stretch.txt data/Mean_stretch_${WORKLOAD_TP}_${CLUSTER_TP}_Time_to_evict.txt
#~ mv plot.pdf plot/Mean_stretch_${WORKLOAD_TP}_${CLUSTER_TP}_Time_to_evict.pdf


# 4. Barplots and heatmap of stretch, stretch with minimum and total flow
echo "Scheduler,Number of jobs,Maximum queue time,Mean queue time,Total queue time,Maximum flow,Mean flow,Total flow,Transfer time,Makespan,Core time used, Waiting for a load time, Total waiting for a load time and transfer time, Mean Stretch, Mean Stretch With a Minimum, Max Stretch, Max Stretch With a Minimum" > outputs/Results_FCFS_Score_${WORKLOAD_TP}_${CLUSTER_TP}.csv
		
# To get all combinations of multiplier couples
for ((i=1; i<=3; i++))
do
	truncate -s 0 outputs/heatmap_stretch.txt
	truncate -s 0 outputs/heatmap_max_stretch.txt
	truncate -s 0 outputs/heatmap_stretch_with_a_minimum.txt
	truncate -s 0 outputs/heatmap_max_stretch_with_a_minimum.txt
	truncate -s 0 outputs/heatmap_total_flow.txt
	truncate -s 0 outputs/heatmap_max_flow.txt
	
	# Heatmap size
	N=5
	#~ # N=8
	
	if [ $((i)) == 1 ]; then
		MULTIPLIER_1=Time_to_load_file
		MULTIPLIER_2=Time_to_evict_file
	elif [ $((i)) == 2 ]; then
		MULTIPLIER_1=Time_to_load_file
		MULTIPLIER_2=Nb_copy
	elif [ $((i)) == 3 ]; then
		MULTIPLIER_1=Time_to_evict_file
		MULTIPLIER_2=Nb_copy	
	fi
	
	# 0 if not choosen
	M1=0
	M2=0
	M3=0
	PAS=500
		
	for ((j=0; j<N; j++))
	do
		for ((k=0; k<N; k++))
		do
			SCHEDULER="Fcfs_with_a_score_x${M1}_x${M2}_x${M3}"
			truncate -s 0 outputs/Results_${SCHEDULER}.csv
			echo "Starting ${SCHEDULER}"
			./C/main $WORKLOAD $CLUSTER $SCHEDULER $CONTRAINTES_TAILLES
			echo "Results ${SCHEDULER} are:"
			head outputs/Results_${SCHEDULER}.csv
			cat outputs/Results_${SCHEDULER}.csv >> outputs/Results_FCFS_Score_${WORKLOAD_TP}_${CLUSTER_TP}.csv
			cat outputs/Stretch_${SCHEDULER}.txt >> outputs/heatmap_stretch.txt
			cat outputs/Stretch_with_a_minimum_${SCHEDULER}.txt >> outputs/heatmap_stretch_with_a_minimum.txt
			cat outputs/Total_flow_${SCHEDULER}.txt >> outputs/heatmap_total_flow.txt
			cat outputs/Max_Stretch_${SCHEDULER}.txt >> outputs/heatmap_max_stretch.txt
			cat outputs/Max_Stretch_with_a_minimum_${SCHEDULER}.txt >> outputs/heatmap_max_stretch_with_a_minimum.txt
			cat outputs/Max_flow_${SCHEDULER}.txt >> outputs/heatmap_max_flow.txt
			echo "" >> outputs/heatmap_stretch.txt
			echo "" >> outputs/heatmap_stretch_with_a_minimum.txt
			echo "" >> outputs/heatmap_total_flow.txt
			echo "" >> outputs/heatmap_max_stretch.txt
			echo "" >> outputs/heatmap_max_stretch_with_a_minimum.txt
			echo "" >> outputs/heatmap_max_flow.txt
		
			if [ ${MULTIPLIER_2} == "Time_to_load_file" ]; then
				M1=$((M1+PAS))
			elif [ ${MULTIPLIER_2} == "Time_to_evict_file" ]; then
				M2=$((M2+PAS))
			elif [ ${MULTIPLIER_2} == "Nb_copy" ]; then
				M3=$((M3+PAS))
			fi
		done
		if [ ${MULTIPLIER_1} == "Time_to_load_file" ]; then
			M1=$((M1+PAS))
			M2=0
			M3=0
		elif [ ${MULTIPLIER_1} == "Time_to_evict_file" ]; then
			M1=0
			M2=$((M2+PAS))
			M3=0
		elif [ ${MULTIPLIER_1} == "Nb_copy" ]; then
			M1=0
			M2=0
			M3=$((M3+PAS))
		fi
	done
	
	echo "Plotting heatmap ${MULTIPLIER_1} X ${MULTIPLIER_2}"
	
	python3 src/plot_heatmap.py outputs/heatmap_stretch.txt $((N)) ${MULTIPLIER_1} ${MULTIPLIER_2} $((PAS)) "Mean_Flow_Stretch"
	mv plot.pdf plot/Heatmap_Stretch_FCFS_Score_${MULTIPLIER_1}_${MULTIPLIER_2}_${WORKLOAD_TP}_${CLUSTER_TP}.pdf
	mv outputs/heatmap_stretch.txt data/Heatmap_Stretch_FCFS_Score_${MULTIPLIER_1}_${MULTIPLIER_2}_${WORKLOAD_TP}_${CLUSTER_TP}.txt
	
	python3 src/plot_heatmap.py outputs/heatmap_stretch_with_a_minimum.txt $((N)) ${MULTIPLIER_1} ${MULTIPLIER_2} $((PAS)) "Mean_Bounded_Flow_Stretch"
	mv plot.pdf plot/Heatmap_Stretch_with_a_minimum_FCFS_Score_${MULTIPLIER_1}_${MULTIPLIER_2}_${WORKLOAD_TP}_${CLUSTER_TP}.pdf
	mv outputs/heatmap_stretch_with_a_minimum.txt data/Heatmap_Stretch_with_a_minimum_FCFS_Score_${MULTIPLIER_1}_${MULTIPLIER_2}_${WORKLOAD_TP}_${CLUSTER_TP}.txt
	
	python3 src/plot_heatmap.py outputs/heatmap_total_flow.txt $((N)) ${MULTIPLIER_1} ${MULTIPLIER_2} $((PAS)) "Total_Flow"
	mv plot.pdf plot/Heatmap_Total_Flow_FCFS_Score_${MULTIPLIER_1}_${MULTIPLIER_2}_${WORKLOAD_TP}_${CLUSTER_TP}.pdf
	mv outputs/heatmap_total_flow.txt data/Heatmap_Total_Flow_FCFS_Score_${MULTIPLIER_1}_${MULTIPLIER_2}_${WORKLOAD_TP}_${CLUSTER_TP}.txt
	
	python3 src/plot_heatmap.py outputs/heatmap_max_stretch.txt $((N)) ${MULTIPLIER_1} ${MULTIPLIER_2} $((PAS)) "Max_Flow_Stretch"
	mv plot.pdf plot/Heatmap_Max_Stretch_FCFS_Score_${MULTIPLIER_1}_${MULTIPLIER_2}_${WORKLOAD_TP}_${CLUSTER_TP}.pdf
	mv outputs/heatmap_max_stretch.txt data/Heatmap_Max_Stretch_FCFS_Score_${MULTIPLIER_1}_${MULTIPLIER_2}_${WORKLOAD_TP}_${CLUSTER_TP}.txt
	
	python3 src/plot_heatmap.py outputs/heatmap_max_stretch_with_a_minimum.txt $((N)) ${MULTIPLIER_1} ${MULTIPLIER_2} $((PAS)) "Max_Bounded_Flow_Stretch"
	mv plot.pdf plot/Heatmap_Max_Stretch_with_a_minimum_FCFS_Score_${MULTIPLIER_1}_${MULTIPLIER_2}_${WORKLOAD_TP}_${CLUSTER_TP}.pdf
	mv outputs/heatmap_max_stretch_with_a_minimum.txt data/Heatmap_Max_Stretch_with_a_minimum_FCFS_Score_${MULTIPLIER_1}_${MULTIPLIER_2}_${WORKLOAD_TP}_${CLUSTER_TP}.txt
	
	python3 src/plot_heatmap.py outputs/heatmap_max_flow.txt $((N)) ${MULTIPLIER_1} ${MULTIPLIER_2} $((PAS)) "Max_Flow"
	mv plot.pdf plot/Heatmap_Max_Flow_FCFS_Score_${MULTIPLIER_1}_${MULTIPLIER_2}_${WORKLOAD_TP}_${CLUSTER_TP}.pdf
	mv outputs/heatmap_max_flow.txt data/Heatmap_Max_Flow_FCFS_Score_${MULTIPLIER_1}_${MULTIPLIER_2}_${WORKLOAD_TP}_${CLUSTER_TP}.txt
	
	echo "Plotting heatmap ok for ${MULTIPLIER_1} X ${MULTIPLIER_2}"
done

echo "Final results are:"
cat outputs/Results_FCFS_Score_${WORKLOAD_TP}_${CLUSTER_TP}.csv

echo "Plotting final results barplots..."
python3 src/plot_barplot.py FCFS_Score_${WORKLOAD_TP} Maximum_queue_time ${CLUSTER_TP} 0 outputs/Results_FCFS_Score_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py FCFS_Score_${WORKLOAD_TP} Mean_queue_time ${CLUSTER_TP} 0 outputs/Results_FCFS_Score_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py FCFS_Score_${WORKLOAD_TP} Total_queue_time ${CLUSTER_TP} 0 outputs/Results_FCFS_Score_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py FCFS_Score_${WORKLOAD_TP} Maximum_flow ${CLUSTER_TP} 0 outputs/Results_FCFS_Score_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py FCFS_Score_${WORKLOAD_TP} Mean_flow ${CLUSTER_TP} 0 outputs/Results_FCFS_Score_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py FCFS_Score_${WORKLOAD_TP} Total_flow ${CLUSTER_TP} 0 outputs/Results_FCFS_Score_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py FCFS_Score_${WORKLOAD_TP} Transfer_time ${CLUSTER_TP} 0 outputs/Results_FCFS_Score_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py FCFS_Score_${WORKLOAD_TP} Makespan ${CLUSTER_TP} 0 outputs/Results_FCFS_Score_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py FCFS_Score_${WORKLOAD_TP} Core_time_used ${CLUSTER_TP} 0 outputs/Results_FCFS_Score_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py FCFS_Score_${WORKLOAD_TP} Waiting_for_a_load_time ${CLUSTER_TP} 0 outputs/Results_FCFS_Score_${WORKLOAD_TP}_${CLUSTER_TP}.csv
python3 src/plot_barplot.py FCFS_Score_${WORKLOAD_TP} Total_waiting_for_a_load_time_and_transfer_time ${CLUSTER_TP} 0 outputs/Results_FCFS_Score_${WORKLOAD_TP}_${CLUSTER_TP}.csv

# Moving main csv data file
mv outputs/Results_FCFS_Score_${WORKLOAD_TP}_${CLUSTER_TP}.csv data/Results_FCFS_Score_${WORKLOAD_TP}_${CLUSTER_TP}.csv

# 5. Just testing manually
# echo "Scheduler,Number of jobs,Maximum queue time,Mean queue time,Total queue time,Maximum flow,Mean flow,Total flow,Transfer time,Makespan,Core time used, Waiting for a load time, Total waiting for a load time and transfer time, Mean Stretch, Mean Stretch With a Minimum" > outputs/Results_FCFS_Score_${WORKLOAD_TP}_${CLUSTER_TP}.csv
#~ SCHEDULER="Fcfs_with_a_score_x1000_x0_x0"
#~ truncate -s 0 outputs/Results_${SCHEDULER}.csv
#~ echo "Starting ${SCHEDULER}"
#~ ./C/main $WORKLOAD $CLUSTER $SCHEDULER $CONTRAINTES_TAILLES
#~ cat outputs/Results_${SCHEDULER}.csv >> data/Results_FCFS_Score_${WORKLOAD_TP}_${CLUSTER_TP}.csv
#~ SCHEDULER="Fcfs_with_a_score_x2000_x0_x0"
#~ truncate -s 0 outputs/Results_${SCHEDULER}.csv
#~ echo "Starting ${SCHEDULER}"
#~ ./C/main $WORKLOAD $CLUSTER $SCHEDULER $CONTRAINTES_TAILLES
#~ cat outputs/Results_${SCHEDULER}.csv >> data/Results_FCFS_Score_${WORKLOAD_TP}_${CLUSTER_TP}.csv
#~ SCHEDULER="Fcfs_with_a_score_x4000_x0_x0"
#~ truncate -s 0 outputs/Results_${SCHEDULER}.csv
#~ echo "Starting ${SCHEDULER}"
#~ ./C/main $WORKLOAD $CLUSTER $SCHEDULER $CONTRAINTES_TAILLES
#~ cat outputs/Results_${SCHEDULER}.csv >> data/Results_FCFS_Score_${WORKLOAD_TP}_${CLUSTER_TP}.csv

end=`date +%s` 
runtime=$((end-start))
echo "Execution complete! It lasted" $((runtime/60))" minute(s) and "$((runtime%60))" second(s)."
