#!/usr/bin/bash

# bash test.sh set_of_endpoints_1 8_functions_4_endpoints_64coresmax_8users 8 64
# bash test.sh set_of_endpoints_1 8_functions_4_endpoints_1coresmax_8users 8 1
# bash test.sh set_of_endpoints_1 8_functions_4_endpoints_64coresmax_8users_balanced_randomized 8 64
# bash test.sh set_of_endpoints_1 8_functions_4_endpoints_64coresmax_8users_reasonable_weight_and_randomized_nb_calls 8 64

# Meggy
# bash test.sh set_of_endpoints_1 8_functions_4_endpoints_8users_nocoresmax_meggy 8 1


endpoints=$1
workload=$2
nusers=$3
N_cores_max=$4

make energy_incentive -C src/

echo ""

#~ for (( i=1; i<=30; i++ ))
for (( i=1; i<=1; i++ ))
do
	echo "Iteration ${i}"
	#~ # python3 src/write_workload.py inputs/workloads/converted/${workload} ${N_cores_max} default
	#~ # python3 src/write_workload.py inputs/workloads/converted/${workload} ${N_cores_max} randomize_weight
	#~ # python3 src/write_workload.py inputs/workloads/converted/${workload} ${N_cores_max} balance_weight
	#~ # python3 src/write_workload.py inputs/workloads/converted/${workload} ${N_cores_max} balance_nb_calls
	#~ python3 src/write_workload.py inputs/workloads/converted/${workload} ${N_cores_max} reasonable_weight_and_randomized_nb_calls
	python3 src/write_workload.py inputs/workloads/converted/${workload} ${N_cores_max} default inputs/workloads/meggie-job-trace-extrapolated.csv
	#~ ./src/main inputs/workloads/converted/${workload} inputs/clusters/${endpoints} no_schedule 0 outputs/${workload}_${i}.csv 0 100 ${nusers} alok
	./src/main inputs/workloads/converted/${workload} inputs/clusters/${endpoints} no_schedule 0 outputs/${workload}_${i}.csv 0 100 ${nusers} meggy credit
	./src/main inputs/workloads/converted/${workload} inputs/clusters/${endpoints} no_schedule 0 outputs/${workload}_${i}.csv 0 100 ${nusers} meggy carbon
done

#~ echo "Plot barplots"

#~ python3 src/plot_barplots.py outputs/${workload}.csv ${nusers} ${workload} "total_energy"
#~ python3 src/plot_barplots.py outputs/${workload}.csv ${nusers} ${workload} "nb_jobs_completed"
#~ python3 src/plot_barplots.py outputs/${workload}.csv ${nusers} ${workload} "nb_jobs_completed_in_mean_core_hours"
#~ python3 src/plot_barplots.py outputs/${workload}.csv ${nusers} ${workload} "queue_time"

#~ echo "Plot curves"

#~ python3 src/plot_curve.py outputs/${workload}.csv ${nusers} ${workload} "finish_times"
#~ python3 src/plot_curve.py outputs/${workload}.csv ${nusers} ${workload} "finish_times_core_hours_Y_axis"
#~ python3 src/plot_curve.py outputs/${workload}.csv ${nusers} ${workload} "energy_consumed"
#~ python3 src/plot_curve.py outputs/${workload}.csv ${nusers} ${workload} "finish_times_core_hours_Y_axis_energy_consumed_X_axis"

#~ echo "Plot stacked barplots"

#~ python3 src/plot_stacked_barplots.py outputs/${workload}.csv ${nusers} ${workload} "machine_used"
