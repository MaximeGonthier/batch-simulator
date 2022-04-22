#!/bin/bash
# bash Generate_workload_from_rackham.sh date_input_file

# Get job history
echo "Downloading job history of" $1 "..."
scp maxim@rackham.uppmax.uu.se:../../../sw/share/slurm/rackham/accounting/$1 /home/gonthier/data-aware-batch-scheduling/MBSS/inputs/workloads/raw/$1
echo "Download done! Here are the first few lines of the raw workload" $1
head -5 inputs/workloads/raw/$1

# Convert file into readable information and add input data
echo "Converting job history..."
python3 src/generate_workload_from_rackham.py $1 10 10
echo "Conversion done! Here are the first few lines of the converted workload" $1
head -5 inputs/workloads/converted/$1
