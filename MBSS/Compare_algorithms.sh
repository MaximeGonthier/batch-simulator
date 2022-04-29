#!/bin/bash
# bash Compare_algorithms.sh workload cluster
start=`date +%s`

if [ "$#" -ne 2 ]; then
    echo "Usage is bash Compare_algorithms.sh workload_date cluster"
    exit
fi

# Get arguments
WORKLOAD=$1
CLUSTER=$2

# Generate workload
#~ bash Generate_workload_from_rackham.sh $WORKLOAD
# OR $1 is already an existing workload

echo "Scheduler,Number of jobs,Maximum queue time,Mean queue time,Total queue time,Maximum flow,Mean flow,Total flow,Total transfer and wait time,Makespan,Core time used, Total waiting for a load time, Total waiting for a load time and transfer time" > outputs/Results_${WORKLOAD}.csv

for ((i=0; i<4; i++))
do
	if [ $((i)) == 0 ]; then SCHEDULER="Random" 
	elif [ $((i)) == 1 ]; then SCHEDULER="Fcfs_with_a_score" 
	elif [ $((i)) == 2 ]; then SCHEDULER="Maximum_use_single_file" 
	elif [ $((i)) == 3 ]; then SCHEDULER="Easy_bf_fcfs_fcfs" 
	fi
	truncate -s 0 outputs/Results_${SCHEDULER}.csv
	echo "${SCHEDULER}"
	python3 src/main_multi_core.py inputs/workloads/converted/$WORKLOAD $CLUSTER $SCHEDULER 0
	echo "Results ${SCHEDULER} are:"
	head outputs/Results_${SCHEDULER}.csv
	cat outputs/Results_${SCHEDULER}.csv >> outputs/Results_${WORKLOAD}.csv
done

echo "Final results are:"
cat outputs/Results_${WORKLOAD}.csv

echo "Plotting results..."
python3 src/plot_barplot.py ${WORKLOAD} Maximum_queue_time
python3 src/plot_barplot.py ${WORKLOAD} Mean_queue_time
python3 src/plot_barplot.py ${WORKLOAD} Total_queue_time
python3 src/plot_barplot.py ${WORKLOAD} Maximum_flow
python3 src/plot_barplot.py ${WORKLOAD} Mean_flow
python3 src/plot_barplot.py ${WORKLOAD} Total_flow
python3 src/plot_barplot.py ${WORKLOAD} Total_transfer_time
python3 src/plot_barplot.py ${WORKLOAD} Makespan
python3 src/plot_barplot.py ${WORKLOAD} Core_time_used
python3 src/plot_barplot.py ${WORKLOAD} Total_waiting_for_a_load_time
python3 src/plot_barplot.py ${WORKLOAD} Total_waiting_for_a_load_time_and_transfer_time

#~ # Fcfs_with_a_score (FCFS-Score)
#~ SCHEDULER="Fcfs_with_a_score"
#~ echo "job_id,workload_name,profile,submission_time,requested_number_of_resources,requested_time,success,final_state,starting_time,execution_time,finish_time,waiting_time,turnaround_time,stretch,allocated_resources,consumed_energy,metadata" > "outputs/Results_all_jobs_${SCHEDULER}.csv"
#~ truncate -s 0 outputs/Results_Fcfs_with_a_score.txt
#~ python3 src/main_multi_core.py $WORKLOAD $CLUSTER Fcfs_with_a_score ShiftLeft 1



#~ # Random Available (RA)
#~ truncate -s 0 outputs/Results_Random-Available.txt
#~ for ((i=1 ; i<=(($NB_TAILLE_TESTE)); i++))
	#~ do 
	#~ python3 src/main.py inputs/workloads/workload_${i}.txt inputs/cluster_1.txt Random-Available 0
#~ done
#~ # First Come First Serve (FCFS)
#~ truncate -s 0 outputs/Results_First-Come-First-Serve.txt
#~ for ((i=1 ; i<=(($NB_TAILLE_TESTE)); i++))
	#~ do 
	#~ python3 src/main.py inputs/workloads/workload_${i}.txt inputs/cluster_1.txt First-Come-First-Serve 0
#~ done
#~ # First Come First Serve Data Aware (FCFS-DA)
#~ truncate -s 0 outputs/Results_First-Come-First-Serve-Data-Aware.txt
#~ for ((i=1 ; i<=(($NB_TAILLE_TESTE)); i++))
	#~ do 
	#~ python3 src/main.py inputs/workloads/workload_${i}.txt inputs/cluster_1.txt First-Come-First-Serve-Data-Aware 0
#~ done

# Convert into easily readable file
#~ python3 src/convert_outputs.py outputs/Results_Random.txt outputs/Results_Random-Available.txt outputs/Results_First-Come-First-Serve.txt outputs/Results_First-Come-First-Serve-Data-Aware.txt

# Plots
#~ echo "Plotting maximum queue time..."
#~ python3 src/plot.py outputs/Max_queue_time.csv Maximum_queue_time_${WORKLOAD}
#~ echo "Plotting mean queue time..."
#~ python3 src/plot.py outputs/Mean_queue_time.csv Mean_queue_time_${WORKLOAD}
#~ echo "Plotting total queue time..."
#~ python3 src/plot.py outputs/Total_queue_time.csv Total_queue_time_${WORKLOAD}
#~ echo "Plotting maximum flow..."
#~ python3 src/plot.py outputs/Max_flow.csv Maximum_flow_${WORKLOAD}
#~ echo "Plotting mean flow..."
#~ python3 src/plot.py outputs/Mean_flow.csv Mean_flow_${WORKLOAD}
#~ echo "Plotting total flow..."
#~ python3 src/plot.py outputs/Total_flow.csv Total_flow_${WORKLOAD}
#~ echo "Plotting total transfer time..."
#~ python3 src/plot.py outputs/Total_transfer_time.csv Total_transfer_time_${WORKLOAD}
#~ echo "Plotting makespan..."
#~ python3 src/plot.py outputs/Makespan.csv Makespan_${WORKLOAD}
#~ echo "Plotting core time used..."
#~ python3 src/plot.py outputs/Core_time_used.csv Core_time_used_${WORKLOAD}

end=`date +%s` 
runtime=$((end-start))
echo "Execution complete! It lasted" $((runtime/60))" minute(s) and "$((runtime%60))" second(s)."
