#!/usr/bin/bash

# bash test.sh set_of_endpoints_1 8_functions_4_endpoints_64coresmax_8users 8 64
# bash test.sh set_of_endpoints_1 8_functions_4_endpoints_1coresmax_8users 8 1
# bash test.sh set_of_endpoints_1 8_functions_4_endpoints_64coresmax_8users_balanced_randomized 8 64
# bash test.sh set_of_endpoints_1 8_functions_4_endpoints_64coresmax_8users_reasonable_weight_and_randomized_nb_calls 8 64

# Meggie and Emmys and 9 users
# bash test.sh set_of_endpoints_1 8_functions_4_endpoints_9users_nocoresmax_meggie_and_emmy 9 1


endpoints=$1
workload=$2
nusers=$3
N_cores_max=$4

make energy_incentive -C src/

echo ""

# With randomization
#~ n_iteration=30
#~ for (( i=1; i<=30; i++ ))
#~ for (( i=1; i<=1; i++ ))
#~ do
	#~ echo "Iteration ${i}"
	#~ # python3 src/write_workload.py inputs/workloads/converted/${workload} ${N_cores_max} default
	#~ # python3 src/write_workload.py inputs/workloads/converted/${workload} ${N_cores_max} randomize_weight
	#~ # python3 src/write_workload.py inputs/workloads/converted/${workload} ${N_cores_max} balance_weight
	#~ # python3 src/write_workload.py inputs/workloads/converted/${workload} ${N_cores_max} balance_nb_calls
	#~ python3 src/write_workload.py inputs/workloads/converted/${workload} ${N_cores_max} reasonable_weight_and_randomized_nb_calls
	#~ python3 src/write_workload.py inputs/workloads/converted/${workload} ${N_cores_max} default inputs/workloads/meggie-job-trace-extrapolated.csv
	#~ ./src/main inputs/workloads/converted/${workload} inputs/clusters/${endpoints} no_schedule 0 outputs/${workload}_${i}.csv 0 100 ${nusers} alok
	#~ ./src/main inputs/workloads/converted/${workload} inputs/clusters/${endpoints} no_schedule 0 outputs/${workload}_${i}.csv 0 100 ${nusers} meggy credit
	#~ ./src/main inputs/workloads/converted/${workload} inputs/clusters/${endpoints} no_schedule 0 outputs/${workload}_${i}.csv 0 100 ${nusers} meggy carbon
#~ done

# Without randomization
n_iteration=1
#~ python3 src/write_workload.py ${workload} 1 count_from_datase inputs/workloads/meggie_and_emmy-job-trace-extrapolated.csv
#~ python3 src/write_workload.py inputs/workloads/converted//${workload}_default 1 default inputs/workloads/meggie_and_emmy-job-trace-extrapolated.csv
./src/main inputs/workloads/converted/${workload}_default inputs/clusters/${endpoints} no_schedule 0 outputs/${workload}_default_credit.csv 0 100 ${nusers} from_emmy_and_meggie credit
./src/main inputs/workloads/converted//${workload}_default inputs/clusters/${endpoints} no_schedule 0 outputs/${workload}_default_carbon.csv 0 100 ${nusers} from_emmy_and_meggie carbon

echo "Plot barplots"

python3 src/plot_barplots.py outputs/${workload}_default_credit.csv ${nusers} ${workload}_default_credit "total_energy" ${n_iteration}
python3 src/plot_barplots.py outputs/${workload}_default_carbon.csv ${nusers} ${workload}_default_carbon "total_energy" ${n_iteration}

python3 src/plot_barplots.py outputs/${workload}_default_credit.csv ${nusers} ${workload}_default_credit "nb_jobs_completed" ${n_iteration}
python3 src/plot_barplots.py outputs/${workload}_default_carbon.csv ${nusers} ${workload}_default_carbon "nb_jobs_completed" ${n_iteration}

python3 src/plot_barplots.py outputs/${workload}_default_credit.csv ${nusers} ${workload}_default_credit "nb_jobs_completed_in_mean_core_hours" ${n_iteration}
python3 src/plot_barplots.py outputs/${workload}_default_carbon.csv ${nusers} ${workload}_default_carbon "nb_jobs_completed_in_mean_core_hours" ${n_iteration}

python3 src/plot_barplots.py outputs/${workload}_default_credit.csv ${nusers} ${workload}_default_credit "queue_time" ${n_iteration}
python3 src/plot_barplots.py outputs/${workload}_default_carbon.csv ${nusers} ${workload}_default_carbon "queue_time" ${n_iteration}

#~ echo "Plot curves"

#~ python3 src/plot_curve.py outputs/${workload}.csv ${nusers} ${workload} "finish_times" ${n_iteration}
#~ python3 src/plot_curve.py outputs/${workload}.csv ${nusers} ${workload} "finish_times_core_hours_Y_axis" ${n_iteration}
#~ python3 src/plot_curve.py outputs/${workload}.csv ${nusers} ${workload} "energy_consumed" ${n_iteration}
#~ python3 src/plot_curve.py outputs/${workload}.csv ${nusers} ${workload} "finish_times_core_hours_Y_axis_energy_consumed_X_axis" ${n_iteration}

echo "Plot stacked barplots"

python3 src/plot_stacked_barplots.py outputs/${workload}_default_credit.csv ${nusers} ${workload}_default_credit "machine_used" ${n_iteration}
python3 src/plot_stacked_barplots.py outputs/${workload}_default_carbon.csv ${nusers} ${workload}_default_carbon "machine_used" ${n_iteration}
