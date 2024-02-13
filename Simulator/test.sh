#!/usr/bin/bash

# bash test.sh 8_functions_4_endpoints set_of_endpoints_1 8_functions_4_endpoints

nusers=4

workload=$1
endpoints=$2
output_name=$3

make energy_incentive -C src/

./src/main inputs/workloads/converted/${workload} inputs/clusters/${endpoints} no_schedule 0 outputs/${output_name}.csv 0 100

python3 src/plot_barplots.py outputs/${output_name}.csv ${nusers} ${output_name}

python3 src/plot_finish_time.py outputs/${output_name}.csv ${nusers} ${output_name}
