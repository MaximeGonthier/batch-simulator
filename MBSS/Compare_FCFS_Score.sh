#!/bin/bash
# bash Compare_FCFS_Score.sh workload cluster contrainte_taille
# oarsub -p nova -l core=16,walltime=04:00:00 -r '2022-09-22 14:00:00' "bash Compare_FCFS_Score.sh inputs/workloads/converted/2022-01-17-\>2022-01-17_V9532 inputs/clusters/rackham_450_128_32_256_4_1024.txt 0"
# oarsub -p dahu -l core=32,walltime=04:00:00 -r '2022-09-22 14:00:00' "bash Compare_FCFS_Score.sh inputs/workloads/converted/2022-01-17-\>2022-01-17_V9532 inputs/clusters/rackham_450_128_32_256_4_1024.txt 0"

start=`date +%s`

if [ "$#" -ne 4 ]; then
    echo "Usage is bash Compare_FCFS_Score.sh converted_workload cluster size_constraint(0, 1 or 2) starting_i"
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
CONTRAINTES_TAILLES=$3 # 1 if you want both constraints
echo "Contraintes tailles:" ${CONTRAINTES_TAILLES}
STARTING_I=$(($4))

make -C C/

#~ # 1. Queue times, flow times and stretch of all jobs of FCFS_SCORE VS FCFS
#~ make print_distribution_queue_times -C C/
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

# 2. Stretch of all jobs of multiple algorithms on a same plot
#~ make print_distribution_queue_times -C C/

#~ SCHEDULER_1="Fcfs"
#~ ./C/main $WORKLOAD $CLUSTER $SCHEDULER_1 $CONTRAINTES_TAILLES

#~ SCHEDULER_2="Fcfs_easybf"
#~ ./C/main $WORKLOAD $CLUSTER $SCHEDULER_2 $CONTRAINTES_TAILLES

#~ SCHEDULER_3="Fcfs_with_a_score_x500_x500_x0"
#~ ./C/main $WORKLOAD $CLUSTER $SCHEDULER_3 $CONTRAINTES_TAILLES

#~ SCHEDULER_4="Fcfs_with_a_score_easybf_x500_x500_x0"
#~ ./C/main $WORKLOAD $CLUSTER $SCHEDULER_4 $CONTRAINTES_TAILLES

#~ python3 src/plot_stretch_multiple_schedulers.py Stretch ${SCHEDULER_1} ${SCHEDULER_2} ${SCHEDULER_3} ${SCHEDULER_4}
#~ mv outputs/Stretch_times_${SCHEDULER_1}.txt data/Stretch_times_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER_1}.txt
#~ mv outputs/Stretch_times_${SCHEDULER_2}.txt data/Stretch_times_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER_2}.txt
#~ mv outputs/Stretch_times_${SCHEDULER_3}.txt data/Stretch_times_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER_3}.txt
#~ mv outputs/Stretch_times_${SCHEDULER_4}.txt data/Stretch_times_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER_4}.txt
#~ mv plot.pdf plot/Stretch_times_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER_1}_${SCHEDULER_2}_${SCHEDULER_3}_${SCHEDULER_4}.pdf

#~ python3 src/plot_stretch_multiple_schedulers.py Bounded_Stretch ${SCHEDULER_1} ${SCHEDULER_2} ${SCHEDULER_3} ${SCHEDULER_4}
#~ mv outputs/Bounded_Stretch_times_${SCHEDULER_1}.txt data/Bounded_Stretch_times_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER_1}.txt
#~ mv outputs/Bounded_Stretch_times_${SCHEDULER_2}.txt data/Bounded_Stretch_times_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER_2}.txt
#~ mv outputs/Bounded_Stretch_times_${SCHEDULER_3}.txt data/Bounded_Stretch_times_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER_3}.txt
#~ mv outputs/Bounded_Stretch_times_${SCHEDULER_4}.txt data/Bounded_Stretch_times_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER_4}.txt
#~ mv plot.pdf plot/Bounded_Stretch_times_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER_1}_${SCHEDULER_2}_${SCHEDULER_3}_${SCHEDULER_4}.pdf


#~ # 3. Curve with 2 fixed parameters and varying only one
#~ MULTIPLIER=Area_filling

#~ echo "Scheduler,Number of jobs,Maximum queue time,Mean queue time,Total queue time,Maximum flow,Mean flow,Total flow,Transfer time,Makespan,Core time used, Waiting for a load time, Total waiting for a load time and transfer time, Mean Stretch, Mean Stretch With a Minimum, Max Stretch, Max Stretch With a Minimum, Nb Upgraded Jobs, Nb jobs large queue time, Mean flow stretch 128 jobs, Mean flow stretch 256 jobs, Mean flow stretch 1024 jobs, Mean flow stretch with a minimum 128 jobs, Mean flow stretch with a minimum 256 jobs, Mean flow stretch with a minimum 1024 jobs" > outputs/Results_FCFS_Score_Move_1_Parameter_${WORKLOAD_TP}_${CLUSTER_TP}_${MULTIPLIER}.csv

#~ truncate -s 0 outputs/stretch.txt
#~ PAS=2000
#~ for ((i=0; i<5; i++))
#~ do
	#~ M1=500
	#~ M2=500
	#~ M3=0
	#~ M4=$((i*PAS))
	#~ SCHEDULER="Fcfs_with_a_score_area_factor_x${M1}_x${M2}_x${M3}_x${M4}"
	#~ # SCHEDULER="Fcfs_with_a_score_area_factor_with_omniscient_planned_area_x{M1}_x${M2}_x${M3}_x${M4}"
	#~ echo "Starting ${SCHEDULER}"
	#~ truncate -s 0 outputs/Results_${SCHEDULER}.csv
	#~ ./C/main $WORKLOAD $CLUSTER $SCHEDULER $CONTRAINTES_TAILLES
	#~ cat outputs/Stretch_${SCHEDULER}.txt >> outputs/stretch.txt
	#~ echo "" >> outputs/stretch.txt
	#~ cat outputs/Results_${SCHEDULER}.csv >> outputs/Results_FCFS_Score_Move_1_Parameter_${WORKLOAD_TP}_${CLUSTER_TP}_${MULTIPLIER}.csv
#~ done

#~ python3 src/plot_curve.py outputs/stretch.txt ${PAS} ${MULTIPLIER}
#~ mv outputs/stretch.txt data/Mean_stretch_${WORKLOAD_TP}_${CLUSTER_TP}_${MULTIPLIER}.txt
#~ mv plot.pdf plot/Mean_stretch_${WORKLOAD_TP}_${CLUSTER_TP}_${MULTIPLIER}.pdf
#~ mv outputs/Results_FCFS_Score_Move_1_Parameter_${WORKLOAD_TP}_${CLUSTER_TP}_${MULTIPLIER}.csv data/Results_FCFS_Score_Move_1_Parameter_${WORKLOAD_TP}_${CLUSTER_TP}_${MULTIPLIER}.csv

# 4. Barplots and heatmap of stretch, stretch with minimum and total flow
#~ echo "Scheduler,Number of jobs,Maximum queue time,Mean queue time,Total queue time,Maximum flow,Mean flow,Total flow,Transfer time,Makespan,Core time used, Waiting for a load time, Total waiting for a load time and transfer time, Mean Stretch, Mean Stretch With a Minimum, Max Stretch, Max Stretch With a Minimum, Nb Upgraded Jobs, Nb jobs large queue time" > outputs/Results_FCFS_Score_${WORKLOAD_TP}_${CLUSTER_TP}.csv

# To get all combinations of multiplier couples
#~ for ((i=3; i<=3; i++))
#~ do
	#~ truncate -s 0 outputs/heatmap_stretch.txt
	#~ truncate -s 0 outputs/heatmap_max_stretch.txt
	#~ truncate -s 0 outputs/heatmap_stretch_with_a_minimum.txt
	#~ truncate -s 0 outputs/heatmap_max_stretch_with_a_minimum.txt
	#~ truncate -s 0 outputs/heatmap_total_flow.txt
	#~ truncate -s 0 outputs/heatmap_max_flow.txt
	
	# Heatmap size
	#~ N=5
	#~ # N=8
	
	#~ if [ $((i)) == 1 ]; then
		#~ MULTIPLIER_1=Time_to_load_file
		#~ MULTIPLIER_2=Time_to_evict_file
	#~ elif [ $((i)) == 2 ]; then
		#~ MULTIPLIER_1=Time_to_load_file
		#~ MULTIPLIER_2=Nb_copy
	#~ elif [ $((i)) == 3 ]; then
		#~ MULTIPLIER_1=Time_to_evict_file
		#~ MULTIPLIER_2=Nb_copy	
	#~ fi
	
	#~ # 0 if not choosen
	#~ M1=0
	#~ M2=2000
	#~ M3=0
	#~ PAS=500
		
	#~ for ((j=4; j<N; j++))
	#~ do
		#~ for ((k=0; k<N; k++))
		#~ do
			#~ SCHEDULER="Fcfs_with_a_score_x${M1}_x${M2}_x${M3}"
			#~ truncate -s 0 outputs/Results_${SCHEDULER}.csv
			#~ echo "Starting ${SCHEDULER}"
			#~ ./C/main $WORKLOAD $CLUSTER $SCHEDULER $CONTRAINTES_TAILLES
			#~ echo "Results ${SCHEDULER} are:"
			#~ head outputs/Results_${SCHEDULER}.csv
			#~ cat outputs/Results_${SCHEDULER}.csv >> outputs/Results_FCFS_Score_${WORKLOAD_TP}_${CLUSTER_TP}.csv
			#~ cat outputs/Stretch_${SCHEDULER}.txt >> outputs/heatmap_stretch.txt
			#~ cat outputs/Stretch_with_a_minimum_${SCHEDULER}.txt >> outputs/heatmap_stretch_with_a_minimum.txt
			#~ cat outputs/Total_flow_${SCHEDULER}.txt >> outputs/heatmap_total_flow.txt
			#~ cat outputs/Max_Stretch_${SCHEDULER}.txt >> outputs/heatmap_max_stretch.txt
			#~ cat outputs/Max_Stretch_with_a_minimum_${SCHEDULER}.txt >> outputs/heatmap_max_stretch_with_a_minimum.txt
			#~ cat outputs/Max_flow_${SCHEDULER}.txt >> outputs/heatmap_max_flow.txt
			#~ echo "" >> outputs/heatmap_stretch.txt
			#~ echo "" >> outputs/heatmap_stretch_with_a_minimum.txt
			#~ echo "" >> outputs/heatmap_total_flow.txt
			#~ echo "" >> outputs/heatmap_max_stretch.txt
			#~ echo "" >> outputs/heatmap_max_stretch_with_a_minimum.txt
			#~ echo "" >> outputs/heatmap_max_flow.txt
		
			#~ if [ ${MULTIPLIER_2} == "Time_to_load_file" ]; then
				#~ M1=$((M1+PAS))
			#~ elif [ ${MULTIPLIER_2} == "Time_to_evict_file" ]; then
				#~ M2=$((M2+PAS))
			#~ elif [ ${MULTIPLIER_2} == "Nb_copy" ]; then
				#~ M3=$((M3+PAS))
			#~ fi
		#~ done
		#~ if [ ${MULTIPLIER_1} == "Time_to_load_file" ]; then
			#~ M1=$((M1+PAS))
			#~ M2=0
			#~ M3=0
		#~ elif [ ${MULTIPLIER_1} == "Time_to_evict_file" ]; then
			#~ M1=0
			#~ M2=$((M2+PAS))
			#~ M3=0
		#~ elif [ ${MULTIPLIER_1} == "Nb_copy" ]; then
			#~ M1=0
			#~ M2=0
			#~ M3=$((M3+PAS))
		#~ fi
	#~ done
	
	#~ echo "Plotting heatmap ${MULTIPLIER_1} X ${MULTIPLIER_2}"
	
	#~ python3 src/plot_heatmap.py outputs/heatmap_stretch.txt $((N)) ${MULTIPLIER_1} ${MULTIPLIER_2} $((PAS)) "Mean_Flow_Stretch"
	#~ mv plot.pdf plot/Heatmap_Stretch_FCFS_Score_${MULTIPLIER_1}_${MULTIPLIER_2}_${WORKLOAD_TP}_${CLUSTER_TP}.pdf
	#~ mv outputs/heatmap_stretch.txt data/Heatmap_Stretch_FCFS_Score_${MULTIPLIER_1}_${MULTIPLIER_2}_${WORKLOAD_TP}_${CLUSTER_TP}.txt
	
	#~ python3 src/plot_heatmap.py outputs/heatmap_stretch_with_a_minimum.txt $((N)) ${MULTIPLIER_1} ${MULTIPLIER_2} $((PAS)) "Mean_Bounded_Flow_Stretch"
	#~ mv plot.pdf plot/Heatmap_Stretch_with_a_minimum_FCFS_Score_${MULTIPLIER_1}_${MULTIPLIER_2}_${WORKLOAD_TP}_${CLUSTER_TP}.pdf
	#~ mv outputs/heatmap_stretch_with_a_minimum.txt data/Heatmap_Stretch_with_a_minimum_FCFS_Score_${MULTIPLIER_1}_${MULTIPLIER_2}_${WORKLOAD_TP}_${CLUSTER_TP}.txt
	
	#~ python3 src/plot_heatmap.py outputs/heatmap_total_flow.txt $((N)) ${MULTIPLIER_1} ${MULTIPLIER_2} $((PAS)) "Total_Flow"
	#~ mv plot.pdf plot/Heatmap_Total_Flow_FCFS_Score_${MULTIPLIER_1}_${MULTIPLIER_2}_${WORKLOAD_TP}_${CLUSTER_TP}.pdf
	#~ mv outputs/heatmap_total_flow.txt data/Heatmap_Total_Flow_FCFS_Score_${MULTIPLIER_1}_${MULTIPLIER_2}_${WORKLOAD_TP}_${CLUSTER_TP}.txt
	
	#~ python3 src/plot_heatmap.py outputs/heatmap_max_stretch.txt $((N)) ${MULTIPLIER_1} ${MULTIPLIER_2} $((PAS)) "Max_Flow_Stretch"
	#~ mv plot.pdf plot/Heatmap_Max_Stretch_FCFS_Score_${MULTIPLIER_1}_${MULTIPLIER_2}_${WORKLOAD_TP}_${CLUSTER_TP}.pdf
	#~ mv outputs/heatmap_max_stretch.txt data/Heatmap_Max_Stretch_FCFS_Score_${MULTIPLIER_1}_${MULTIPLIER_2}_${WORKLOAD_TP}_${CLUSTER_TP}.txt
	
	#~ python3 src/plot_heatmap.py outputs/heatmap_max_stretch_with_a_minimum.txt $((N)) ${MULTIPLIER_1} ${MULTIPLIER_2} $((PAS)) "Max_Bounded_Flow_Stretch"
	#~ mv plot.pdf plot/Heatmap_Max_Stretch_with_a_minimum_FCFS_Score_${MULTIPLIER_1}_${MULTIPLIER_2}_${WORKLOAD_TP}_${CLUSTER_TP}.pdf
	#~ mv outputs/heatmap_max_stretch_with_a_minimum.txt data/Heatmap_Max_Stretch_with_a_minimum_FCFS_Score_${MULTIPLIER_1}_${MULTIPLIER_2}_${WORKLOAD_TP}_${CLUSTER_TP}.txt
	
	#~ python3 src/plot_heatmap.py outputs/heatmap_max_flow.txt $((N)) ${MULTIPLIER_1} ${MULTIPLIER_2} $((PAS)) "Max_Flow"
	#~ mv plot.pdf plot/Heatmap_Max_Flow_FCFS_Score_${MULTIPLIER_1}_${MULTIPLIER_2}_${WORKLOAD_TP}_${CLUSTER_TP}.pdf
	#~ mv outputs/heatmap_max_flow.txt data/Heatmap_Max_Flow_FCFS_Score_${MULTIPLIER_1}_${MULTIPLIER_2}_${WORKLOAD_TP}_${CLUSTER_TP}.txt
#~ done

#~ echo "Final results are:"
#~ cat outputs/Results_FCFS_Score_${WORKLOAD_TP}_${CLUSTER_TP}.csv

#~ echo "Plotting final results barplots..."
#~ python3 src/plot_barplot.py FCFS_Score_${WORKLOAD_TP} Maximum_queue_time ${CLUSTER_TP} 0 outputs/Results_FCFS_Score_${WORKLOAD_TP}_${CLUSTER_TP}.csv
#~ python3 src/plot_barplot.py FCFS_Score_${WORKLOAD_TP} Mean_queue_time ${CLUSTER_TP} 0 outputs/Results_FCFS_Score_${WORKLOAD_TP}_${CLUSTER_TP}.csv
#~ python3 src/plot_barplot.py FCFS_Score_${WORKLOAD_TP} Total_queue_time ${CLUSTER_TP} 0 outputs/Results_FCFS_Score_${WORKLOAD_TP}_${CLUSTER_TP}.csv
#~ python3 src/plot_barplot.py FCFS_Score_${WORKLOAD_TP} Maximum_flow ${CLUSTER_TP} 0 outputs/Results_FCFS_Score_${WORKLOAD_TP}_${CLUSTER_TP}.csv
#~ python3 src/plot_barplot.py FCFS_Score_${WORKLOAD_TP} Mean_flow ${CLUSTER_TP} 0 outputs/Results_FCFS_Score_${WORKLOAD_TP}_${CLUSTER_TP}.csv
#~ python3 src/plot_barplot.py FCFS_Score_${WORKLOAD_TP} Total_flow ${CLUSTER_TP} 0 outputs/Results_FCFS_Score_${WORKLOAD_TP}_${CLUSTER_TP}.csv
#~ python3 src/plot_barplot.py FCFS_Score_${WORKLOAD_TP} Transfer_time ${CLUSTER_TP} 0 outputs/Results_FCFS_Score_${WORKLOAD_TP}_${CLUSTER_TP}.csv
#~ python3 src/plot_barplot.py FCFS_Score_${WORKLOAD_TP} Makespan ${CLUSTER_TP} 0 outputs/Results_FCFS_Score_${WORKLOAD_TP}_${CLUSTER_TP}.csv
#~ python3 src/plot_barplot.py FCFS_Score_${WORKLOAD_TP} Core_time_used ${CLUSTER_TP} 0 outputs/Results_FCFS_Score_${WORKLOAD_TP}_${CLUSTER_TP}.csv
#~ python3 src/plot_barplot.py FCFS_Score_${WORKLOAD_TP} Waiting_for_a_load_time ${CLUSTER_TP} 0 outputs/Results_FCFS_Score_${WORKLOAD_TP}_${CLUSTER_TP}.csv
#~ python3 src/plot_barplot.py FCFS_Score_${WORKLOAD_TP} Total_waiting_for_a_load_time_and_transfer_time ${CLUSTER_TP} 0 outputs/Results_FCFS_Score_${WORKLOAD_TP}_${CLUSTER_TP}.csv

#~ # Moving main csv data file
#~ mv outputs/Results_FCFS_Score_${WORKLOAD_TP}_${CLUSTER_TP}.csv data/Results_FCFS_Score_${WORKLOAD_TP}_${CLUSTER_TP}.csv

# 5. Just testing manually
# echo "Scheduler,Number of jobs,Maximum queue time,Mean queue time,Total queue time,Maximum flow,Mean flow,Total flow,Transfer time,Makespan,Core time used, Waiting for a load time, Total waiting for a load time and transfer time, Mean Stretch, Mean Stretch With a Minimum, Nb Upgraded Jobs" > outputs/Results_FCFS_Score_${WORKLOAD_TP}_${CLUSTER_TP}.csv
#~ SCHEDULER="Fcfs_with_a_score_x1000_x0_x0"
#~ truncate -s 0 outputs/Results_${SCHEDULER}.csv
#~ echo "Starting ${SCHEDULER}"
#~ ./C/main $WORKLOAD $CLUSTER $SCHEDULER $CONTRAINTES_TAILLES $OUTPUT_FILE 0
#~ cat outputs/Results_${SCHEDULER}.csv >> data/Results_FCFS_Score_${WORKLOAD_TP}_${CLUSTER_TP}.csv
#~ SCHEDULER="Fcfs_with_a_score_x2000_x0_x0"
#~ truncate -s 0 outputs/Results_${SCHEDULER}.csv
#~ echo "Starting ${SCHEDULER}"
#~ ./C/main $WORKLOAD $CLUSTER $SCHEDULER $CONTRAINTES_TAILLES $OUTPUT_FILE 0
#~ cat outputs/Results_${SCHEDULER}.csv >> data/Results_FCFS_Score_${WORKLOAD_TP}_${CLUSTER_TP}.csv
#~ SCHEDULER="Fcfs_with_a_score_x4000_x0_x0"
#~ truncate -s 0 outputs/Results_${SCHEDULER}.csv
#~ echo "Starting ${SCHEDULER}"
#~ ./C/main $WORKLOAD $CLUSTER $SCHEDULER $CONTRAINTES_TAILLES $OUTPUT_FILE 0
#~ cat outputs/Results_${SCHEDULER}.csv >> data/Results_FCFS_Score_${WORKLOAD_TP}_${CLUSTER_TP}.csv

# 6. Comparer fcfs et Fcfs score avec deux workloads différents
#~ echo "Scheduler,Number of jobs,Maximum queue time,Mean queue time,Total queue time,Maximum flow,Mean flow,Total flow,Transfer time,Makespan,Core time used, Waiting for a load time, Total waiting for a load time and transfer time, Mean Stretch, Mean Stretch With a Minimum, Max Stretch, Max Stretch With a Minimum, Nb Upgraded Jobs, Nb jobs large queue time, Mean flow stretch 128 jobs, Mean flow stretch 256 jobs, Mean flow stretch 1024 jobs, Mean flow stretch with a minimum 128 jobs, Mean flow stretch with a minimum 256 jobs, Mean flow stretch with a minimum 1024 jobs" > outputs/Results_FCFS_Score_Saturated_Cluster_${WORKLOAD_TP}_${CLUSTER_TP}.csv

#~ SCHEDULER="Fcfs"
#~ echo "Starting ${SCHEDULER}"
#~ truncate -s 0 outputs/Results_${SCHEDULER}.csv
#~ ./C/main $WORKLOAD $CLUSTER $SCHEDULER $CONTRAINTES_TAILLES $OUTPUT_FILE 0
#~ cat outputs/Results_${SCHEDULER}.csv >> outputs/Results_FCFS_Score_Saturated_Cluster_${WORKLOAD_TP}_${CLUSTER_TP}.csv

#~ SCHEDULER="Fcfs_with_a_score_x1_x1_x0_x0"
#~ echo "Starting ${SCHEDULER}"
#~ truncate -s 0 outputs/Results_${SCHEDULER}.csv
#~ ./C/main $WORKLOAD $CLUSTER $SCHEDULER $CONTRAINTES_TAILLES $OUTPUT_FILE 0
#~ cat outputs/Results_${SCHEDULER}.csv >> outputs/Results_FCFS_Score_Saturated_Cluster_${WORKLOAD_TP}_${CLUSTER_TP}.csv

#~ python3 src/plot_barplot.py Results_FCFS_Score_Saturated_Cluster_${WORKLOAD_TP} Total_waiting_for_a_load_time_and_transfer_time ${CLUSTER_TP} 0 outputs/Results_FCFS_Score_Saturated_Cluster_${WORKLOAD_TP}_${CLUSTER_TP}.csv
#~ python3 src/plot_barplot.py Results_FCFS_Score_Saturated_Cluster_${WORKLOAD_TP} Mean_Stretch ${CLUSTER_TP} 0 outputs/Results_FCFS_Score_Saturated_Cluster_${WORKLOAD_TP}_${CLUSTER_TP}.csv
#~ python3 src/plot_barplot.py Results_FCFS_Score_Saturated_Cluster_${WORKLOAD_TP} Mean_Stretch_With_a_Minimum ${CLUSTER_TP} 0 outputs/Results_FCFS_Score_Saturated_Cluster_${WORKLOAD_TP}_${CLUSTER_TP}.csv
#~ python3 src/plot_barplot.py Results_FCFS_Score_Saturated_Cluster_${WORKLOAD_TP} Nb_Upgraded_Jobs ${CLUSTER_TP} 0 outputs/Results_FCFS_Score_Saturated_Cluster_${WORKLOAD_TP}_${CLUSTER_TP}.csv

#~ mv outputs/Results_FCFS_Score_Saturated_Cluster_${WORKLOAD_TP}_${CLUSTER_TP}.csv data/Results_FCFS_Score_Saturated_Cluster_${WORKLOAD_TP}_${CLUSTER_TP}.csv


#~ echo "Scheduler,Number of jobs,Maximum queue time,Mean queue time,Total queue time,Maximum flow,Mean flow,Total flow,Transfer time,Makespan,Core time used, Waiting for a load time, Total waiting for a load time and transfer time, Mean Stretch, Mean Stretch With a Minimum, Max Stretch, Max Stretch With a Minimum, Nb Upgraded Jobs, Nb jobs large queue time, Mean flow stretch 128 jobs, Mean flow stretch 256 jobs, Mean flow stretch 1024 jobs, Mean flow stretch with a minimum 128 jobs, Mean flow stretch with a minimum 256 jobs, Mean flow stretch with a minimum 1024 jobs" > outputs/Results_FCFS_Score_Non_Saturated_Cluster_${WORKLOAD_TP}_${CLUSTER_TP}_reduced.csv

#~ WORKLOAD=${WORKLOAD}_reduced

#~ SCHEDULER="Fcfs"
#~ echo "Starting ${SCHEDULER}"
#~ truncate -s 0 outputs/Results_${SCHEDULER}.csv
#~ ./C/main $WORKLOAD $CLUSTER $SCHEDULER $CONTRAINTES_TAILLES $OUTPUT_FILE 0
#~ cat outputs/Results_${SCHEDULER}.csv >> outputs/Results_FCFS_Score_Non_Saturated_Cluster_${WORKLOAD_TP}_${CLUSTER_TP}_reduced.csv

#~ SCHEDULER="Fcfs_with_a_score_x500_x500_x0_x0"
#~ echo "Starting ${SCHEDULER}"
#~ truncate -s 0 outputs/Results_${SCHEDULER}.csv
#~ ./C/main $WORKLOAD $CLUSTER $SCHEDULER $CONTRAINTES_TAILLES $OUTPUT_FILE 0
#~ cat outputs/Results_${SCHEDULER}.csv >> outputs/Results_FCFS_Score_Non_Saturated_Cluster_${WORKLOAD_TP}_${CLUSTER_TP}_reduced.csv

#~ python3 src/plot_barplot.py Results_FCFS_Score_Non_Saturated_Cluster_${WORKLOAD_TP} Total_waiting_for_a_load_time_and_transfer_time ${CLUSTER_TP}_reduced 0 outputs/Results_FCFS_Score_Non_Saturated_Cluster_${WORKLOAD_TP}_${CLUSTER_TP}_reduced.csv
#~ python3 src/plot_barplot.py Results_FCFS_Score_Non_Saturated_Cluster_${WORKLOAD_TP} Mean_Stretch ${CLUSTER_TP}_reduced 0 outputs/Results_FCFS_Score_Non_Saturated_Cluster_${WORKLOAD_TP}_${CLUSTER_TP}_reduced.csv
#~ python3 src/plot_barplot.py Results_FCFS_Score_Non_Saturated_Cluster_${WORKLOAD_TP} Mean_Stretch_With_a_Minimum ${CLUSTER_TP}_reduced 0 outputs/Results_FCFS_Score_Non_Saturated_Cluster_${WORKLOAD_TP}_${CLUSTER_TP}_reduced.csv
#~ python3 src/plot_barplot.py Results_FCFS_Score_Non_Saturated_Cluster_${WORKLOAD_TP} Nb_Upgraded_Jobs ${CLUSTER_TP}_reduced 0 outputs/Results_FCFS_Score_Non_Saturated_Cluster_${WORKLOAD_TP}_${CLUSTER_TP}_reduced.csv

#~ mv outputs/Results_FCFS_Score_Non_Saturated_Cluster_${WORKLOAD_TP}_${CLUSTER_TP}_reduced.csv data/Results_FCFS_Score_Non_Saturated_Cluster_${WORKLOAD_TP}_${CLUSTER_TP}_reduced.csv


#~ # 7. Comparer fcfs, fcfs_score et fcfs_score_adaptative_multiplier
#~ echo "Scheduler,Number of jobs,Maximum queue time,Mean queue time,Total queue time,Maximum flow,Mean flow,Total flow,Transfer time,Makespan,Core time used, Waiting for a load time, Total waiting for a load time and transfer time, Mean Stretch, Mean Stretch With a Minimum, Max Stretch, Max Stretch With a Minimum, Nb Upgraded Jobs, Nb jobs large queue time, Mean flow stretch 128 jobs, Mean flow stretch 256 jobs, Mean flow stretch 1024 jobs, Mean flow stretch with a minimum 128 jobs, Mean flow stretch with a minimum 256 jobs, Mean flow stretch with a minimum 1024 jobs" > outputs/Results_FCFS_Score_Adaptative_Multiplier_${WORKLOAD_TP}_${CLUSTER_TP}.csv
#~ OUTPUT_FILE=outputs/Results_FCFS_Score_Adaptative_Multiplier_${WORKLOAD_TP}_${CLUSTER_TP}.csv

#~ for ((i=1; i<=6; i++))
#~ do
	#~ # Schedulers
	#~ if [ $((i)) == 1 ]; then SCHEDULER="Fcfs"
	#~ elif [ $((i)) == 2 ]; then SCHEDULER="Fcfs_with_a_score_x1_x1_x0_x0"
	#~ elif [ $((i)) == 3 ]; then SCHEDULER="Fcfs_with_a_score_x500_x500_x0_x0"
	#~ elif [ $((i)) == 4 ]; then SCHEDULER="Fcfs_with_a_score_penalty_on_big_jobs_x1_x1_x0_x0" # Les jobs ont leurs temps pour charger un fichier a qui on ajoute une pénalité constante (en plus d'un multiplicateur possible par la suite) sur le multiplicateur. de 0 à +5 en fonction de la taille du fichiers. Donc on a par exemple x1+0.6 pour 128, ou x1+5 pour 1024.
	#~ elif [ $((i)) == 5 ]; then SCHEDULER="Fcfs_with_a_score_adaptative_multiplier_x500_x500_x0_x0" # Quand le cluster est chargé (il y a des nodes non utilisées) je passe à 500 500, sinon je suis à 1 1
	#~ elif [ $((i)) == 6 ]; then SCHEDULER="Mixed_strategy_90"
	#~ fi
	#~ ./C/main $WORKLOAD $CLUSTER $SCHEDULER $CONTRAINTES_TAILLES $OUTPUT_FILE 0
#~ done
#~ echo "Final results are:"
#~ cat ${OUTPUT_FILE}
#~ echo "Plotting results..."
#~ python3 src/plot_barplot.py Results_FCFS_Score_Adaptative_Multiplier_${WORKLOAD_TP} Maximum_queue_time ${CLUSTER_TP} 0 ${OUTPUT_FILE}
#~ python3 src/plot_barplot.py Results_FCFS_Score_Adaptative_Multiplier_${WORKLOAD_TP} Total_flow ${CLUSTER_TP} 0 ${OUTPUT_FILE}
#~ python3 src/plot_barplot.py  Results_FCFS_Score_Adaptative_Multiplier_${WORKLOAD_TP} Total_waiting_for_a_load_time_and_transfer_time ${CLUSTER_TP} 0 ${OUTPUT_FILE}
#~ python3 src/plot_barplot.py Results_FCFS_Score_Adaptative_Multiplier_${WORKLOAD_TP} Mean_Stretch ${CLUSTER_TP} 0 ${OUTPUT_FILE}
#~ python3 src/plot_barplot.py Results_FCFS_Score_Adaptative_Multiplier_${WORKLOAD_TP} Mean_Stretch_With_a_Minimum ${CLUSTER_TP} 0 ${OUTPUT_FILE}
#~ mv ${OUTPUT_FILE} data/Results_FCFS_Score_Adaptative_Multiplier_${WORKLOAD_TP}_${CLUSTER_TP}.csv


# 8. Comparer adaptative multiplier
#~ if (($((STARTING_I)) == 1))
#~ then
	#~ echo "Scheduler,Number of jobs,Maximum queue time,Mean queue time,Total queue time,Maximum flow,Mean flow,Total flow,Transfer time,Makespan,Core time used, Waiting for a load time, Total waiting for a load time and transfer time, Mean Stretch, Mean Stretch With a Minimum, Max Stretch, Max Stretch With a Minimum, Nb Upgraded Jobs, Nb jobs large queue time, Mean flow stretch 128 jobs, Mean flow stretch 256 jobs, Mean flow stretch 1024 jobs, Mean flow stretch with a minimum 128 jobs, Mean flow stretch with a minimum 256 jobs, Mean flow stretch with a minimum 1024 jobs" > outputs/Results_FCFS_Score_Adaptative_Multiplier_${WORKLOAD_TP}_${CLUSTER_TP}.csv
#~ fi
#~ OUTPUT_FILE=outputs/Results_FCFS_Score_Adaptative_Multiplier_${WORKLOAD_TP}_${CLUSTER_TP}.csv
#~ for ((i=$((STARTING_I)); i<=15; i++))
#~ do
	#~ # Schedulers
	#~ if [ $((i)) == 1 ]; then SCHEDULER="Fcfs"
	#~ elif [ $((i)) == 2 ]; then SCHEDULER="Fcfs_with_a_score_x1_x0_x0_x0"
	#~ elif [ $((i)) == 3 ]; then SCHEDULER="Fcfs_with_a_score_mixed_strategy_x1_x1_x1_x0"
	#~ elif [ $((i)) == 4 ]; then SCHEDULER="Fcfs_with_a_score_mixed_strategy_x486_x1_x0_x0"
	#~ elif [ $((i)) == 5 ]; then SCHEDULER="Fcfs_with_a_score_mixed_strategy_x486_x50_x0_x0"
	#~ elif [ $((i)) == 6 ]; then SCHEDULER="Fcfs_with_a_score_mixed_strategy_x500_x1_x0_x0"
	#~ elif [ $((i)) == 7 ]; then SCHEDULER="Fcfs_with_a_score_mixed_strategy_x500_x50_x0_x0"
	#~ elif [ $((i)) == 8 ]; then SCHEDULER="Fcfs_with_a_score_adaptative_multiplier_x1_x0_x0_x0"
	#~ elif [ $((i)) == 9 ]; then SCHEDULER="Fcfs_with_a_score_adaptative_multiplier_x1_x1_x0_x0"
	#~ elif [ $((i)) == 10 ]; then SCHEDULER="Fcfs_with_a_score_mixed_strategy_adaptative_multiplier_x1_x0_x0_x0"
	#~ elif [ $((i)) == 11 ]; then SCHEDULER="Fcfs_with_a_score_mixed_strategy_adaptative_multiplier_x1_x1_x0_x0"
	#~ elif [ $((i)) == 12 ]; then SCHEDULER="Fcfs_with_a_score_mixed_strategy_adaptative_multiplier_x1_x1_x1_x0"
	#~ elif [ $((i)) == 13 ]; then SCHEDULER="Mix_score_nb_running_jobs"
	#~ elif [ $((i)) == 14 ]; then SCHEDULER="Flow_adaptation_heft_locality"
	#~ elif [ $((i)) == 15 ]; then SCHEDULER="Flow_adaptation_heft_score"
	#~ fi
	#~ ./C/main $WORKLOAD $CLUSTER $SCHEDULER $CONTRAINTES_TAILLES $OUTPUT_FILE 0
#~ done
#~ echo "Final results are:"
#~ cat ${OUTPUT_FILE}
#~ echo "Plotting results..."
#~ python3 src/plot_barplot.py Results_FCFS_Score_Adaptative_Multiplier_${WORKLOAD_TP} Maximum_queue_time ${CLUSTER_TP} 0 ${OUTPUT_FILE}
#~ python3 src/plot_barplot.py Results_FCFS_Score_Adaptative_Multiplier_${WORKLOAD_TP} Total_flow ${CLUSTER_TP} 0 ${OUTPUT_FILE}
#~ python3 src/plot_barplot.py  Results_FCFS_Score_Adaptative_Multiplier_${WORKLOAD_TP} Total_waiting_for_a_load_time_and_transfer_time ${CLUSTER_TP} 0 ${OUTPUT_FILE}
#~ python3 src/plot_barplot.py Results_FCFS_Score_Adaptative_Multiplier_${WORKLOAD_TP} Mean_Stretch ${CLUSTER_TP} 0 ${OUTPUT_FILE}
#~ python3 src/plot_barplot.py Results_FCFS_Score_Adaptative_Multiplier_${WORKLOAD_TP} Mean_Stretch_With_a_Minimum ${CLUSTER_TP} 0 ${OUTPUT_FILE}
#~ mv ${OUTPUT_FILE} data/Results_FCFS_Score_Adaptative_Multiplier_${WORKLOAD_TP}_${CLUSTER_TP}.csv

#~ # 9. Comparer backfilling 2.0
#~ OUTPUT_FILE=outputs/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}.csv
#~ if (($((STARTING_I)) == 1))
#~ then
	#~ echo "Scheduler,Number of jobs,Maximum queue time,Mean queue time,Total queue time,Maximum flow,Mean flow,Total flow,Transfer time,Makespan,Core time used, Waiting for a load time, Total waiting for a load time and transfer time, Mean Stretch, Mean Stretch With a Minimum, Max Stretch, Max Stretch With a Minimum, Nb Upgraded Jobs, Nb jobs large queue time, Mean flow stretch 128 jobs, Mean flow stretch 256 jobs, Mean flow stretch 1024 jobs, Mean flow stretch with a minimum 128 jobs, Mean flow stretch with a minimum 256 jobs, Mean flow stretch with a minimum 1024 jobs" > ${OUTPUT_FILE}
#~ fi
#~ for ((i=$((STARTING_I)); i<=20; i++))
#~ do
	#~ # Schedulers
	#~ if [ $((i)) == 1 ]; then SCHEDULER="Fcfs"; BACKFILL_MODE=0
	#~ elif [ $((i)) == 2 ]; then SCHEDULER="Fcfs_conservativebf"; BACKFILL_MODE=0
	#~ elif [ $((i)) == 3 ]; then SCHEDULER="Fcfs_conservativebf"; BACKFILL_MODE=1
	#~ elif [ $((i)) == 4 ]; then SCHEDULER="Fcfs_conservativebf"; BACKFILL_MODE=2
	#~ elif [ $((i)) == 5 ]; then SCHEDULER="Fcfs_conservativebf"; BACKFILL_MODE=3
	#~ elif [ $((i)) == 6 ]; then SCHEDULER="Fcfs_with_a_score_x500_x1_x0_x0"; BACKFILL_MODE=0
	#~ elif [ $((i)) == 7 ]; then SCHEDULER="Fcfs_with_a_score_conservativebf_x500_x1_x0_x0"; BACKFILL_MODE=0
	#~ elif [ $((i)) == 8 ]; then SCHEDULER="Fcfs_with_a_score_conservativebf_x500_x1_x0_x0"; BACKFILL_MODE=1
	#~ elif [ $((i)) == 9 ]; then SCHEDULER="Fcfs_with_a_score_conservativebf_x500_x1_x0_x0"; BACKFILL_MODE=2
	#~ elif [ $((i)) == 10 ]; then SCHEDULER="Fcfs_with_a_score_conservativebf_x500_x1_x0_x0"; BACKFILL_MODE=3
	#~ elif [ $((i)) == 11 ]; then SCHEDULER="Fcfs_with_a_score_mixed_strategy_x500_x1_x0_x0"; BACKFILL_MODE=0
	#~ elif [ $((i)) == 12 ]; then SCHEDULER="Fcfs_with_a_score_mixed_strategy_conservativebf_x500_x1_x0_x0"; BACKFILL_MODE=0
	#~ elif [ $((i)) == 13 ]; then SCHEDULER="Fcfs_with_a_score_mixed_strategy_conservativebf_x500_x1_x0_x0"; BACKFILL_MODE=1
	#~ elif [ $((i)) == 14 ]; then SCHEDULER="Fcfs_with_a_score_mixed_strategy_conservativebf_x500_x1_x0_x0"; BACKFILL_MODE=2
	#~ elif [ $((i)) == 15 ]; then SCHEDULER="Fcfs_with_a_score_mixed_strategy_conservativebf_x500_x1_x0_x0"; BACKFILL_MODE=3
	#~ elif [ $((i)) == 16 ]; then SCHEDULER="Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_x500_x1_x0_x0"; BACKFILL_MODE=0
	#~ elif [ $((i)) == 17 ]; then SCHEDULER="Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_conservativebf_x500_x1_x0_x0"; BACKFILL_MODE=0
	#~ elif [ $((i)) == 18 ]; then SCHEDULER="Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_conservativebf_x500_x1_x0_x0"; BACKFILL_MODE=1
	#~ elif [ $((i)) == 19 ]; then SCHEDULER="Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_conservativebf_x500_x1_x0_x0"; BACKFILL_MODE=2
	#~ elif [ $((i)) == 20 ]; then SCHEDULER="Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_conservativebf_x500_x1_x0_x0"; BACKFILL_MODE=3
	#~ fi
	#~ ./C/main $WORKLOAD $CLUSTER $SCHEDULER $CONTRAINTES_TAILLES $OUTPUT_FILE $BACKFILL_MODE
#~ done
#~ echo "Final results are:"
#~ cat ${OUTPUT_FILE}
#~ mv ${OUTPUT_FILE} data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}.csv

# 10. Tester data persistence
OUTPUT_FILE=outputs/Results_Data_Persistence_${WORKLOAD_TP}_${CLUSTER_TP}.csv
if (($((STARTING_I)) == 1))
then
	echo "Scheduler,Number of jobs,Maximum queue time,Mean queue time,Total queue time,Maximum flow,Mean flow,Total flow,Transfer time,Makespan,Core time used, Waiting for a load time, Total waiting for a load time and transfer time, Mean Stretch, Mean Stretch With a Minimum, Max Stretch, Max Stretch With a Minimum, Nb Upgraded Jobs, Nb jobs large queue time, Mean flow stretch 128 jobs, Mean flow stretch 256 jobs, Mean flow stretch 1024 jobs, Mean flow stretch with a minimum 128 jobs, Mean flow stretch with a minimum 256 jobs, Mean flow stretch with a minimum 1024 jobs" > ${OUTPUT_FILE}
fi
for ((i=$((STARTING_I)); i<=4; i++))
do
	# Schedulers
	if [ $((i)) == 1 ]; then 
		SCHEDULER="Fcfs"
		make -C C/
		./C/main $WORKLOAD $CLUSTER $SCHEDULER $CONTRAINTES_TAILLES $OUTPUT_FILE 0
		make data_persistence -C C/
		./C/main $WORKLOAD $CLUSTER $SCHEDULER $CONTRAINTES_TAILLES $OUTPUT_FILE 0
	elif [ $((i)) == 2 ]; then 
		SCHEDULER="Fcfs_with_a_score_x500_x1_x0_x0"
		make -C C/
		./C/main $WORKLOAD $CLUSTER $SCHEDULER $CONTRAINTES_TAILLES $OUTPUT_FILE 0
		make data_persistence -C C/
		./C/main $WORKLOAD $CLUSTER $SCHEDULER $CONTRAINTES_TAILLES $OUTPUT_FILE 0
	elif [ $((i)) == 3 ]; then 
		SCHEDULER="Fcfs_with_a_score_mixed_strategy_x500_x1_x0_x0"
		make -C C/
		./C/main $WORKLOAD $CLUSTER $SCHEDULER $CONTRAINTES_TAILLES $OUTPUT_FILE 0
		make data_persistence -C C/
		./C/main $WORKLOAD $CLUSTER $SCHEDULER $CONTRAINTES_TAILLES $OUTPUT_FILE 0
	elif [ $((i)) == 4 ]; then 
		SCHEDULER="Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_x500_x1_x0_x0"
		make -C C/
		./C/main $WORKLOAD $CLUSTER $SCHEDULER $CONTRAINTES_TAILLES $OUTPUT_FILE 0
		make data_persistence -C C/
		./C/main $WORKLOAD $CLUSTER $SCHEDULER $CONTRAINTES_TAILLES $OUTPUT_FILE 0
	fi
done
echo "Final results are:"
cat ${OUTPUT_FILE}
mv ${OUTPUT_FILE} data/Results_Data_Persistence_${WORKLOAD_TP}_${CLUSTER_TP}.csv


end=`date +%s` 
runtime=$((end-start))
echo "Execution complete! It lasted" $((runtime/60))" minute(s) and "$((runtime%60))" second(s)."
