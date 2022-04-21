#!/bin/bash
# bash Experiments_multi_core.sh workload
start=`date +%s`

# Get arguments
WORKLOAD=$1

# Generate workload
#~ bash Generate_workload_from_rackham.sh $WORKLOAD
# OR $1 is already an existing workload

SCHEDULER="Random"
echo "job_id,workload_name,profile,submission_time,requested_number_of_resources,requested_time,success,final_state,starting_time,execution_time,finish_time,waiting_time,turnaround_time,stretch,allocated_resources,consumed_energy,metadata" > "outputs/Results_all_jobs_${SCHEDULER}.csv"

# Random (R)
truncate -s 0 outputs/Results_Random.txt
python3 src/main_multi_core.py $WORKLOAD inputs/clusters/rackham_4nodes.txt Random 1

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

#~ # Convert into easily readable file
#~ python3 src/convert_outputs.py outputs/Results_Random.txt outputs/Results_Random-Available.txt outputs/Results_First-Come-First-Serve.txt outputs/Results_First-Come-First-Serve-Data-Aware.txt

#~ # Plots
#~ echo "Plotting maximum queue time..."
#~ python3 src/plot.py outputs/Max_queue_time.csv Maximum_queue_time
#~ echo "Plotting mean queue time..."
#~ python3 src/plot.py outputs/Mean_queue_time.csv Mean_queue_time
#~ echo "Plotting total queue time..."
#~ python3 src/plot.py outputs/Total_queue_time.csv Total_queue_time
#~ echo "Plotting maximum flow..."
#~ python3 src/plot.py outputs/Max_flow.csv Maximum_flow
#~ echo "Plotting mean flow..."
#~ python3 src/plot.py outputs/Mean_flow.csv Mean_flow
#~ echo "Plotting total flow..."
#~ python3 src/plot.py outputs/Total_flow.csv Total_flow
#~ echo "Plotting total transfer time..."
#~ python3 src/plot.py outputs/Total_transfer_time.csv Total_transfer_time
#~ echo "Plotting makespan..."
#~ python3 src/plot.py outputs/Makespan.csv Makespan
#~ echo "Plotting core time used..."
#~ python3 src/plot.py outputs/Core_time_used.csv Core_time_used

python3 ../Batsim/batsched-Maxime/gantt-chart-plot/main.py outputs/Results_all_jobs_${SCHEDULER}.csv ${SCHEDULER}

end=`date +%s` 
runtime=$((end-start))
echo "Execution complete! It lasted" $((runtime/60))" minute(s) and "$((runtime%60))" second(s)."
