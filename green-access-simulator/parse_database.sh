#!/usr/bin/bash

# bash parse_database.sh

cluster="emmy"

python src/parse_${cluster}_file_to_get_runtime_energy_data.py ../../ipdps20-paper-hpc-power-traces/data/cluster_characteristics/${cluster}/job_traces/rrze-traces-${cluster}-jobs-01.txt ../../ipdps20-paper-hpc-power-traces/data/cluster_characteristics/${cluster}/pwr_traces/rrze-traces-${cluster}-avg-pwr-01.txt inputs/workloads/${cluster}-1-raw
python src/parse_${cluster}_file_to_get_runtime_energy_data.py ../../ipdps20-paper-hpc-power-traces/data/cluster_characteristics/${cluster}/job_traces/rrze-traces-${cluster}-jobs-02.txt ../../ipdps20-paper-hpc-power-traces/data/cluster_characteristics/${cluster}/pwr_traces/rrze-traces-${cluster}-avg-pwr-02.txt inputs/workloads/${cluster}-2-raw
python src/parse_${cluster}_file_to_get_runtime_energy_data.py ../../ipdps20-paper-hpc-power-traces/data/cluster_characteristics/${cluster}/job_traces/rrze-traces-${cluster}-jobs-10.txt ../../ipdps20-paper-hpc-power-traces/data/cluster_characteristics/${cluster}/pwr_traces/rrze-traces-${cluster}-avg-pwr-10.txt inputs/workloads/${cluster}-10-raw
python src/parse_${cluster}_file_to_get_runtime_energy_data.py ../../ipdps20-paper-hpc-power-traces/data/cluster_characteristics/${cluster}/job_traces/rrze-traces-${cluster}-jobs-11.txt ../../ipdps20-paper-hpc-power-traces/data/cluster_characteristics/${cluster}/pwr_traces/rrze-traces-${cluster}-avg-pwr-11.txt inputs/workloads/${cluster}-11-raw
python src/parse_${cluster}_file_to_get_runtime_energy_data.py ../../ipdps20-paper-hpc-power-traces/data/cluster_characteristics/${cluster}/job_traces/rrze-traces-${cluster}-jobs-12.txt ../../ipdps20-paper-hpc-power-traces/data/cluster_characteristics/${cluster}/pwr_traces/rrze-traces-${cluster}-avg-pwr-12.txt inputs/workloads/${cluster}-12-raw

cat inputs/workloads/${cluster}-1-raw inputs/workloads/${cluster}-2-raw inputs/workloads/${cluster}-10-raw inputs/workloads/${cluster}-11-raw inputs/workloads/${cluster}-12-raw > inputs/workloads/${cluster}-raw 

cluster="meggie"

python src/parse_${cluster}_file_to_get_runtime_energy_data.py ../../ipdps20-paper-hpc-power-traces/data/cluster_characteristics/${cluster}/job_traces/rrze-traces-${cluster}-jobs-01.txt ../../ipdps20-paper-hpc-power-traces/data/cluster_characteristics/${cluster}/pwr_traces/rrze-traces-${cluster}-avg-pwr-01.txt inputs/workloads/${cluster}-1-raw
python src/parse_${cluster}_file_to_get_runtime_energy_data.py ../../ipdps20-paper-hpc-power-traces/data/cluster_characteristics/${cluster}/job_traces/rrze-traces-${cluster}-jobs-02.txt ../../ipdps20-paper-hpc-power-traces/data/cluster_characteristics/${cluster}/pwr_traces/rrze-traces-${cluster}-avg-pwr-02.txt inputs/workloads/${cluster}-2-raw
python src/parse_${cluster}_file_to_get_runtime_energy_data.py ../../ipdps20-paper-hpc-power-traces/data/cluster_characteristics/${cluster}/job_traces/rrze-traces-${cluster}-jobs-10.txt ../../ipdps20-paper-hpc-power-traces/data/cluster_characteristics/${cluster}/pwr_traces/rrze-traces-${cluster}-avg-pwr-10.txt inputs/workloads/${cluster}-10-raw
python src/parse_${cluster}_file_to_get_runtime_energy_data.py ../../ipdps20-paper-hpc-power-traces/data/cluster_characteristics/${cluster}/job_traces/rrze-traces-${cluster}-jobs-11.txt ../../ipdps20-paper-hpc-power-traces/data/cluster_characteristics/${cluster}/pwr_traces/rrze-traces-${cluster}-avg-pwr-11.txt inputs/workloads/${cluster}-11-raw
python src/parse_${cluster}_file_to_get_runtime_energy_data.py ../../ipdps20-paper-hpc-power-traces/data/cluster_characteristics/${cluster}/job_traces/rrze-traces-${cluster}-jobs-12.txt ../../ipdps20-paper-hpc-power-traces/data/cluster_characteristics/${cluster}/pwr_traces/rrze-traces-${cluster}-avg-pwr-12.txt inputs/workloads/${cluster}-12-raw

cat inputs/workloads/${cluster}-1-raw inputs/workloads/${cluster}-2-raw inputs/workloads/${cluster}-10-raw inputs/workloads/${cluster}-11-raw inputs/workloads/${cluster}-12-raw > inputs/workloads/${cluster}-raw
