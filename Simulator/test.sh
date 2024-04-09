#!/usr/bin/bash

endpoints=$1
workload=$2
nusers=$3
N_cores_max=$4
mode_for_repetition=$5

make -C src/

echo ""

# python3 src/write_workload.py inputs/workloads/converted/${workload}_${mode_for_repetition} 1 ${mode_for_repetition} inputs/workloads/meggie_and_emmy-job-trace-extrapolated.csv

n_iteration=1

if [ ${endpoints} == set_of_endpoints_1 ]; then
./src/main inputs/workloads/converted/${workload}_${mode_for_repetition} inputs/clusters/${endpoints} no_schedule 0 outputs/${endpoints}_${workload}_${mode_for_repetition}_credit.csv 0 100 ${nusers} from_emmy_and_meggie credit
fi
./src/main inputs/workloads/converted/${workload}_${mode_for_repetition} inputs/clusters/${endpoints} no_schedule 0 outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv 0 100 ${nusers} from_emmy_and_meggie carbon

# echo ""
# echo "Plot barplots"

if [ ${endpoints} == set_of_endpoints_1 ]; then
python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_credit.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_credit "total_energy" ${n_iteration} credit figure4
#python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_credit.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_credit "nb_jobs_completed" ${n_iteration} credit
python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_credit.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_credit "nb_jobs_completed_in_mean_core_hours" ${n_iteration} credit figure2
#python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_credit.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_credit "queue_time" ${n_iteration} credit
#python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_credit.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_credit "carbon_used" ${n_iteration} credit
# carbon
python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_carbon "total_energy" ${n_iteration} carbon table2_energy
#python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_carbon "nb_jobs_completed" ${n_iteration} carbon
python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_carbon "nb_jobs_completed_in_mean_core_hours_reduced" ${n_iteration} carbon figure6
#python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_carbon "queue_time" ${n_iteration} carbon
python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_carbon "carbon_used" ${n_iteration} carbon table2_carbon
fi

if [ ${endpoints} == set_of_endpoints_2 ]; then
python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_carbon "nb_jobs_completed_in_mean_core_hours_reduced" ${n_iteration} carbon figure7
python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_carbon "total_energy" ${n_iteration} carbon table3_energy
python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_carbon "carbon_used" ${n_iteration} carbon table3_carbon
fi

#echo ""
#echo "Plot curves"

if [ ${endpoints} == set_of_endpoints_1 ]; then
python3 src/plot_curve.py outputs/${endpoints}_${workload}_${mode_for_repetition}_credit.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_credit "finish_times" ${n_iteration} credit figure3
#python3 src/plot_curve.py outputs/${endpoints}_${workload}_${mode_for_repetition}_credit.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_credit "finish_times_core_hours_Y_axis" ${n_iteration} credit
#python3 src/plot_curve.py outputs/${endpoints}_${workload}_${mode_for_repetition}_credit.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_credit "energy_consumed" ${n_iteration} credit
fi

#python3 src/plot_curve.py outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_carbon "finish_times" ${n_iteration} carbon
#python3 src/plot_curve.py outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_carbon "finish_times_core_hours_Y_axis" ${n_iteration} carbon
#python3 src/plot_curve.py outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_carbon "energy_consumed" ${n_iteration} carbon

#echo ""
#echo "Plot stacked barplots"

if [ ${endpoints} == set_of_endpoints_1 ]; then
python3 src/plot_stacked_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_credit.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_credit "machine_used" ${n_iteration} credit figure5
fi

if [ ${endpoints} == set_of_endpoints_2 ]; then
python3 src/plot_stacked_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_carbon "machine_used" ${n_iteration} carbon figure8
fi

#python3 src/plot_stacked_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_carbon "machine_used" ${n_iteration} carbon
