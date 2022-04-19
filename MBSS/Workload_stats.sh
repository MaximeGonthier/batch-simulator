#!/bin/bash
# Generate the distribution of delay, submission time and core needed from real data
# bash Workload_stats.sh date_input_file

# Get job history
echo "Downloading job history of" $1 "..."
scp maxim@rackham.uppmax.uu.se:../../../sw/share/slurm/rackham/accounting/$1 /home/gonthier/data-aware-batch-scheduling/MBSS/inputs/workloads/raw/$1

python3 src/convert_stats_workload.py $1
python3 src/plot_stats_workload.py $1_cores
python3 src/plot_stats_workload.py $1_walltime
python3 src/plot_stats_workload.py $1_delay
