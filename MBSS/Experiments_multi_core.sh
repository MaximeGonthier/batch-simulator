#!/bin/bash
# bash Experiments_multi_core.sh workload cluster scheduler print_gantt_chart?
start=`date +%s`

if [ "$#" -ne 4 ]; then
    echo "Usage is bash Experiments_multi_core.sh workload cluster scheduler print_gantt_chart?"
    exit
fi

# Get arguments
WORKLOAD=$1
CLUSTER=$2
SCHEDULER=$3
PRINT_GANTT_CHART=$4

# Generate workload
#~ bash Generate_workload_from_rackham.sh $WORKLOAD
# OR $1 is already an existing workload

# Random (Random)
echo "job_id,workload_name,profile,submission_time,requested_number_of_resources,requested_time,success,final_state,starting_time,execution_time,finish_time,waiting_time,turnaround_time,stretch,allocated_resources,consumed_energy,metadata" > "outputs/Results_all_jobs_${SCHEDULER}.csv"
truncate -s 0 outputs/Results_${SCHEDULER}.txt
python3 src/main_multi_core.py $WORKLOAD $CLUSTER $SCHEDULER ShiftLeft $4

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

if [ $4 == 1 ]; then
	python3 ../Batsim/batsched-Maxime/gantt-chart-plot/main.py outputs/Results_all_jobs_${SCHEDULER}.csv ${SCHEDULER}
fi

echo "Results:"
head outputs/Results_${SCHEDULER}.txt

end=`date +%s` 
runtime=$((end-start))
echo "Execution complete! It lasted" $((runtime/60))" minute(s) and "$((runtime%60))" second(s)."
