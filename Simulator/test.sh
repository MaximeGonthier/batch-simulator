#!/usr/bin/bash

endpoints=$1
workload=$2
nusers=$3
N_cores_max=$4
mode_for_repetition=$5

make -C src/

echo ""

#~ python3 src/write_workload.py inputs/workloads/converted/${workload}_${mode_for_repetition} 1 ${mode_for_repetition} inputs/workloads/meggie_and_emmy-job-trace-extrapolated.csv

n_iteration=1

#~ # For fixed slice experiment
#~ start_at=0 # January 1st
start_at=4344 # July 1st
#~ for ((starting_slice=start_at; starting_slice<=start_at+23; starting_slice++)); do
    #~ ./src/main inputs/workloads/converted/${workload}_${mode_for_repetition} inputs/clusters/${endpoints} no_schedule 0 outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv 0 100 ${nusers} from_emmy_and_meggie carbon ${starting_slice}
    #~ mv outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv outputs/slice_${starting_slice}
#~ done
#~ python3 src/get_stats_fixed_slice.py

if [ ${endpoints} == set_of_endpoints_1 ]; then
./src/main inputs/workloads/converted/${workload}_${mode_for_repetition} inputs/clusters/${endpoints} no_schedule 0 outputs/${endpoints}_${workload}_${mode_for_repetition}_credit.csv 0 100 ${nusers} from_emmy_and_meggie credit
fi
./src/main inputs/workloads/converted/${workload}_${mode_for_repetition} inputs/clusters/${endpoints} no_schedule 0 outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv 0 100 ${nusers} from_emmy_and_meggie carbon

#~ # echo ""
#~ # echo "Plot barplots"

if [ ${endpoints} == set_of_endpoints_1 ]; then
python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_credit.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_credit "total_energy" ${n_iteration} credit figure4_varying_carbon
#python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_credit.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_credit "nb_jobs_completed" ${n_iteration} credit
python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_credit.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_credit "nb_jobs_completed_in_mean_core_hours" ${n_iteration} credit figure2_varying_carbon
#python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_credit.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_credit "queue_time" ${n_iteration} credit
#python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_credit.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_credit "carbon_used" ${n_iteration} credit
# carbon
python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_carbon "total_energy" ${n_iteration} carbon table2_energy_varying_carbon
python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_credit.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_credit "total_energy" ${n_iteration} credit table2_energy_varying_carbon_credit
#python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_carbon "nb_jobs_completed" ${n_iteration} carbon
python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_carbon "nb_jobs_completed_in_mean_core_hours_reduced" ${n_iteration} carbon figure6_varying_carbon
#python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_carbon "queue_time" ${n_iteration} carbon
python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_carbon "carbon_used" ${n_iteration} carbon table2_carbon_varying_carbon
python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_carbon "direct_carbon_used" ${n_iteration} carbon table_direct_carbon_varying_carbon_set_of_endpoint_1
python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_credit.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_credit "carbon_used" ${n_iteration} credit table2_credit_varying_carbon
python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_credit.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_credit "direct_carbon_used" ${n_iteration} credit table_direct_credit_varying_carbon_set_of_endpoint_1
fi

if [ ${endpoints} == set_of_endpoints_2 ]; then
python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_carbon "nb_jobs_completed_in_mean_core_hours_reduced" ${n_iteration} carbon figure7_varying_carbon
python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_carbon "total_energy" ${n_iteration} carbon table3_energy_varying_carbon
python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_carbon "carbon_used" ${n_iteration} carbon table3_carbon_varying_carbon
python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_carbon "direct_carbon_used" ${n_iteration} carbon table_direct_carbon_varying_carbon_set_of_endpoint_2
fi

#echo ""
#echo "Plot curves"

if [ ${endpoints} == set_of_endpoints_1 ]; then
python3 src/plot_curve.py outputs/${endpoints}_${workload}_${mode_for_repetition}_credit.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_credit "finish_times" ${n_iteration} credit figure3_varying_carbon
#python3 src/plot_curve.py outputs/${endpoints}_${workload}_${mode_for_repetition}_credit.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_credit "finish_times_core_hours_Y_axis" ${n_iteration} credit
#python3 src/plot_curve.py outputs/${endpoints}_${workload}_${mode_for_repetition}_credit.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_credit "energy_consumed" ${n_iteration} credit
fi

#python3 src/plot_curve.py outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_carbon "finish_times" ${n_iteration} carbon
#python3 src/plot_curve.py outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_carbon "finish_times_core_hours_Y_axis" ${n_iteration} carbon
#python3 src/plot_curve.py outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_carbon "energy_consumed" ${n_iteration} carbon

#echo ""
#echo "Plot stacked barplots"

if [ ${endpoints} == set_of_endpoints_1 ]; then
python3 src/plot_stacked_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_credit.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_credit "machine_used" ${n_iteration} credit figure5_varying_carbon
python3 src/plot_stacked_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_carbon "machine_used" ${n_iteration} carbon stacked_barplots_set_of_endpoints_1_varying_carbon
fi
if [ ${endpoints} == set_of_endpoints_2 ]; then
python3 src/plot_stacked_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_carbon "machine_used" ${n_iteration} carbon stacked_barplots_set_of_endpoints_2_varying_carbon
fi

#python3 src/plot_stacked_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_carbon "machine_used" ${n_iteration} carbon
