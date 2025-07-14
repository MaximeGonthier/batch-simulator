#!/usr/bin/bash

endpoints=$1
workload=$2
nusers=$3
N_cores_max=$4
mode_for_repetition=$5

make -C src/

echo ""

n_iteration=1

if [ ${endpoints} == set_of_endpoints_1 ]; then
./src/main inputs/workloads/converted/${workload}_${mode_for_repetition} inputs/clusters/${endpoints} no_schedule 0 outputs/${endpoints}_${workload}_${mode_for_repetition}_credit.csv 0 100 ${nusers} from_emmy_and_meggie credit
fi
./src/main inputs/workloads/converted/${workload}_${mode_for_repetition} inputs/clusters/${endpoints} no_schedule 0 outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv 0 100 ${nusers} from_emmy_and_meggie carbon

if [ ${endpoints} == set_of_endpoints_1 ]; then
python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_credit.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_credit "nb_jobs_completed_in_mean_core_hours" ${n_iteration} credit figure_5a


# carbon
python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_carbon "total_energy" ${n_iteration} carbon table6_energy_CBA
python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_credit.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_credit "total_energy" ${n_iteration} credit table6_energy_EBA
python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_carbon "nb_jobs_completed_in_mean_core_hours_reduced" ${n_iteration} carbon figure6
python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_carbon "carbon_used" ${n_iteration} carbon table_6_attributed_carbon_CBA
python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_carbon "direct_carbon_used" ${n_iteration} carbon table_6_operational_carbon_CBA
python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_credit.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_credit "carbon_used" ${n_iteration} credit table_6_attributed_carbon_EBA
python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_credit.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_credit "direct_carbon_used" ${n_iteration} credit table_6_operational_carbon_EBA
fi

if [ ${endpoints} == set_of_endpoints_2 ]; then
python3 src/plot_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_carbon.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_carbon "nb_jobs_completed_in_mean_core_hours_reduced" ${n_iteration} carbon figure_7a
fi


if [ ${endpoints} == set_of_endpoints_1 ]; then
python3 src/plot_curve.py outputs/${endpoints}_${workload}_${mode_for_repetition}_credit.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_credit "finish_times" ${n_iteration} credit figure_5b
fi

if [ ${endpoints} == set_of_endpoints_1 ]; then
python3 src/plot_stacked_barplots.py outputs/${endpoints}_${workload}_${mode_for_repetition}_credit.csv ${nusers} ${endpoints}_${workload}_${mode_for_repetition}_credit "machine_used" ${n_iteration} credit figure_5c
fi
