workload="meggie_and_emmy"
nusers=10
N_cores_max=1
mode_for_repetition="count_from_database"

python3 scripts/write_workload.py inputs/workloads/converted/${workload}_${mode_for_repetition} 1 ${mode_for_repetition} inputs/workloads/meggie_and_emmy-job-trace-extrapolated.csv
