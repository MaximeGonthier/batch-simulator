#!/bin/bash

# Printing header of the .csv file
#~ echo "Number of jobs, Maximum queue time, Mean queue time, Total queue time, Maximum flow, Mean flow, Total flow, Total transfer time, Makespan, Core time used" > outputs/results.csv

#~ # Starting simulation 
#~ truncate -s 0 outputs/Results_Random.txt
#~ python3 src/main.py inputs/workload_1.txt inputs/cluster_1.txt Random
#~ python3 src/main.py inputs/workload_2.txt inputs/cluster_1.txt Random

truncate -s 0 outputs/Results_Random-Available.txt
#~ python3 src/main.py inputs/workload_1.txt inputs/cluster_1.txt Random-Available
python3 src/main.py inputs/workload_2.txt inputs/cluster_1.txt Random-Available

# Convert into easily readable file
#~ python3 src/convert_outputs.py outputs/Results_Random.txt outputs/Results_Random-Available.txt

#~ # Plot maximum queue time
#~ python3 src/plot.py outputs/Max_queue_time.csv Maximum_queue_time
#~ # Plot mean queue time
#~ python3 src/plot.py outputs/Mean_queue_time.csv Mean_queue_time
