#!/usr/bin/bash

# bash test.sh set_of_endpoints_1 8_functions_4_endpoints_64coresmax_8users 8 64
# bash test.sh set_of_endpoints_1 8_functions_4_endpoints_1coresmax_8users 8 1
# bash test.sh set_of_endpoints_1 8_functions_4_endpoints_64coresmax_8users_balanced_randomized 8 64

endpoints=$1
workload=$2
nusers=$3
N_cores_max=$4

python3 src/write_workload.py inputs/workloads/converted/${workload} ${N_cores_max}

echo ""

make energy_incentive -C src/

echo ""

./src/main inputs/workloads/converted/${workload} inputs/clusters/${endpoints} no_schedule 0 outputs/${workload}.csv 0 100 ${nusers}

echo ""

python3 src/plot_barplots.py outputs/${workload}.csv ${nusers} ${workload} "total_energy"
python3 src/plot_barplots.py outputs/${workload}.csv ${nusers} ${workload} "nb_jobs_completed"
python3 src/plot_barplots.py outputs/${workload}.csv ${nusers} ${workload} "nb_jobs_completed_in_mean_core_hours"
python3 src/plot_barplots.py outputs/${workload}.csv ${nusers} ${workload} "queue_time"

echo ""

python3 src/plot_curve.py outputs/${workload}.csv ${nusers} ${workload} "finish_times"
python3 src/plot_curve.py outputs/${workload}.csv ${nusers} ${workload} "finish_times_core_hours_Y_axis"
python3 src/plot_curve.py outputs/${workload}.csv ${nusers} ${workload} "energy_consumed"
python3 src/plot_curve.py outputs/${workload}.csv ${nusers} ${workload} "finish_times_core_hours_Y_axis_energy_consumed_X_axis"
python3 src/plot_curve.py outputs/${workload}.csv ${nusers} ${workload} "finish_times_submission_order_X_axis"
