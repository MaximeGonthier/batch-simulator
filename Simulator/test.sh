#!/usr/bin/bash

# bash test.sh set_of_endpoints_1 8_functions_4_endpoints_64coresmax_8users 8 64
# bash test.sh set_of_endpoints_1 8_functions_4_endpoints_1coresmax_8users 8 1
# bash test.sh set_of_endpoints_1 8_functions_4_endpoints_64coresmax_8users_balanced_randomized 8 64
# bash test.sh set_of_endpoints_1 8_functions_4_endpoints_64coresmax_8users_reasonable_weight_and_randomized_nb_calls 8 64

# Meggie and Emmys and 10 users
# bash test.sh set_of_endpoints_1 set_of_endpoints_1_9users_nocoresmax_meggie_and_emmy 9 1 default

# In paper
# bash test.sh set_of_endpoints_1 meggie_and_emmy 10 1 count_from_database
# bash test.sh set_of_endpoints_2 meggie_and_emmy 10 1 count_from_database
# bash test.sh set_of_endpoints_3 meggie_and_emmy 10 1 count_from_database

endpoints=$1
workload=$2
nusers=$3
N_cores_max=$4
mode_for_repetition=$5

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


# With emmy and meggie database
#~ python3 src/write_workload.py inputs/workloads/converted/${workload}_${mode_for_repetition} 1 ${mode_for_repetition} inputs/workloads/meggie_and_emmy-job-trace-extrapolated.csv

n_iteration=1

#~ if [ ${endpoints} == set_of_endpoints_1 ]; then
#~ ./src/main inputs/workloads/converted/${workload}_${mode_for_repetition} inputs/clusters/${endpoints} no_schedule 0 outputs/${endpoints}_${workload}_${mode_for_repetition}_credit.csv 0 100 ${nusers} from_emmy_and_meggie credit
#~ fi
#~ ./src/main inputs/workloads/converted/${workload}_${mode_for_repetition} inputs/clusters/${endpoints} no_schedule 0 outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv 0 100 ${nusers} from_emmy_and_meggie carbon

echo ""
echo "Plot barplots"

if [ ${endpoints} == set_of_endpoints_1 ]; then
python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_credit.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_credit "total_energy" ${n_iteration} credit
#~ python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_credit.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_credit "nb_jobs_completed" ${n_iteration} credit
python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_credit.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_credit "nb_jobs_completed_in_mean_core_hours" ${n_iteration} credit
#~ python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_credit.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_credit "queue_time" ${n_iteration} credit
#~ python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_credit.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_credit "carbon_used" ${n_iteration} credit
fi

#~ python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_carbon "total_energy" ${n_iteration} carbon
#~ python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_carbon "nb_jobs_completed" ${n_iteration} carbon
#~ python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_carbon "nb_jobs_completed_in_mean_core_hours_reduced" ${n_iteration} carbon
#~ python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_carbon "queue_time" ${n_iteration} carbon
#~ python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_carbon "carbon_used" ${n_iteration} carbon

#~ echo ""
#~ echo "Plot curves"

#~ if [ ${endpoints} == set_of_endpoints_1 ]; then
#~ python3 src/plot_curve.py outputs/${endpoints}_${workload}_${mode_for_repetition}_credit.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_credit "finish_times" ${n_iteration} credit
#~ python3 src/plot_curve.py outputs/${endpoints}_${workload}_${mode_for_repetition}_credit.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_credit "finish_times_core_hours_Y_axis" ${n_iteration} credit
#~ python3 src/plot_curve.py outputs/${endpoints}_${workload}_${mode_for_repetition}_credit.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_credit "energy_consumed" ${n_iteration} credit
# python3 src/plot_curve.py outputs/${endpoints}_${workload}_${mode_for_repetition}_credit.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_credit "finish_times_core_hours_Y_axis_energy_consumed_X_axis" ${n_iteration} credit
#~ fi

#~ python3 src/plot_curve.py outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_carbon "finish_times" ${n_iteration} carbon
#~ python3 src/plot_curve.py outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_carbon "finish_times_core_hours_Y_axis" ${n_iteration} carbon
#~ python3 src/plot_curve.py outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_carbon "energy_consumed" ${n_iteration} carbon
# python3 src/plot_curve.py outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_carbon "finish_times_core_hours_Y_axis_energy_consumed_X_axis" ${n_iteration} carbon

echo ""
echo "Plot stacked barplots"

#~ if [ ${endpoints} == set_of_endpoints_1 ]; then
#~ python3 src/plot_stacked_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_credit.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_credit "machine_used" ${n_iteration} credit
#~ fi

python3 src/plot_stacked_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_carbon "machine_used" ${n_iteration} carbon
