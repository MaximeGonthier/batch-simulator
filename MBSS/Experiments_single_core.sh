#!/bin/bash
# bash Experiments.sh NB_TAILLE_TESTE
start=`date +%s`

# Get arguments
NB_TAILLE_TESTE=$1

# Generate workload
python3 src/generate_workload.py 0 25 25 50 0 0 10 $((NB_TAILLE_TESTE))

# Random (R)
truncate -s 0 outputs/Results_Random.txt
for ((i=1 ; i<=(($NB_TAILLE_TESTE)); i++))
	do 
	python3 src/main.py inputs/workloads/workload_${i}.txt inputs/cluster_1.txt Random 0
done

# Random Available (RA)
truncate -s 0 outputs/Results_Random-Available.txt
for ((i=1 ; i<=(($NB_TAILLE_TESTE)); i++))
	do 
	python3 src/main.py inputs/workloads/workload_${i}.txt inputs/cluster_1.txt Random-Available 0
done

# First Come First Serve (FCFS)
truncate -s 0 outputs/Results_First-Come-First-Serve.txt
for ((i=1 ; i<=(($NB_TAILLE_TESTE)); i++))
	do 
	python3 src/main.py inputs/workloads/workload_${i}.txt inputs/cluster_1.txt First-Come-First-Serve 0
done
# First Come First Serve Data Aware (FCFS-DA)
truncate -s 0 outputs/Results_First-Come-First-Serve-Data-Aware.txt
for ((i=1 ; i<=(($NB_TAILLE_TESTE)); i++))
	do 
	python3 src/main.py inputs/workloads/workload_${i}.txt inputs/cluster_1.txt First-Come-First-Serve-Data-Aware 0
done

# Convert into easily readable file
python3 src/convert_outputs.py outputs/Results_Random.txt outputs/Results_Random-Available.txt outputs/Results_First-Come-First-Serve.txt outputs/Results_First-Come-First-Serve-Data-Aware.txt

# Plots
echo "Plotting maximum queue time..."
python3 src/plot.py outputs/Max_queue_time.csv Maximum_queue_time
echo "Plotting mean queue time..."
python3 src/plot.py outputs/Mean_queue_time.csv Mean_queue_time
echo "Plotting total queue time..."
python3 src/plot.py outputs/Total_queue_time.csv Total_queue_time
echo "Plotting maximum flow..."
python3 src/plot.py outputs/Max_flow.csv Maximum_flow
echo "Plotting mean flow..."
python3 src/plot.py outputs/Mean_flow.csv Mean_flow
echo "Plotting total flow..."
python3 src/plot.py outputs/Total_flow.csv Total_flow
echo "Plotting total transfer time..."
python3 src/plot.py outputs/Total_transfer_time.csv Total_transfer_time
echo "Plotting makespan..."
python3 src/plot.py outputs/Makespan.csv Makespan
echo "Plotting core time used..."
python3 src/plot.py outputs/Core_time_used.csv Core_time_used

end=`date +%s` 
runtime=$((end-start))
echo "Execution complete! it lasted" $((runtime/60))" minute(s) and "$((runtime%60))" second(s)."
