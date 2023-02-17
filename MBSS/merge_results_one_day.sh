DATE=$1

WORKLOAD="inputs/workloads/converted/2022-${DATE}->2022-${DATE}_V10000_anonymous"
WORKLOAD_TP=${WORKLOAD:27}
CLUSTER="inputs/clusters/rackham_450_128_32_256_4_1024.txt"
CLUSTER_TP=${CLUSTER:24}
CLUSTER_TP=${CLUSTER_TP::-4}

OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}.csv
echo "Scheduler,Number of jobs,Maximum queue time,Mean queue time,Total queue time,Maximum flow,Mean flow,Total flow,Transfer time,Makespan,Core time used, Waiting for a load time, Total waiting for a load time and transfer time, Mean Stretch, Mean Stretch With a Minimum, Max Stretch, Max Stretch With a Minimum, Nb Upgraded Jobs, Nb jobs large queue time, Mean flow stretch 128 jobs, Mean flow stretch 256 jobs, Mean flow stretch 1024 jobs, Mean flow stretch with a minimum 128 jobs, Mean flow stretch with a minimum 256 jobs, Mean flow stretch with a minimum 1024 jobs, Number of data reuse" > ${OUTPUT_FILE}

cat data/Results_FCFS_Score_Backfill_2022-${DATE}-\>2022-${DATE}_V10000_anonymous_450_128_32_256_4_1024_Fcfs.csv >> ${OUTPUT_FILE}
cat data/Results_FCFS_Score_Backfill_2022-${DATE}-\>2022-${DATE}_V10000_anonymous_450_128_32_256_4_1024_Fcfs_conservativebf.csv >> ${OUTPUT_FILE}
cat data/Results_FCFS_Score_Backfill_2022-${DATE}-\>2022-${DATE}_V10000_anonymous_450_128_32_256_4_1024_Fcfs_with_a_score_x1_x0_x0_x0.csv >> ${OUTPUT_FILE}
cat data/Results_FCFS_Score_Backfill_2022-${DATE}-\>2022-${DATE}_V10000_anonymous_450_128_32_256_4_1024_Fcfs_with_a_score_conservativebf_x1_x0_x0_x0.csv >> ${OUTPUT_FILE}
cat data/Results_FCFS_Score_Backfill_2022-${DATE}-\>2022-${DATE}_V10000_anonymous_450_128_32_256_4_1024_Fcfs_with_a_score_x500_x1_x0_x0.csv >> ${OUTPUT_FILE}
cat data/Results_FCFS_Score_Backfill_2022-${DATE}-\>2022-${DATE}_V10000_anonymous_450_128_32_256_4_1024_Fcfs_with_a_score_conservativebf_x500_x1_x0_x0.csv >> ${OUTPUT_FILE}
cat data/Results_FCFS_Score_Backfill_2022-${DATE}-\>2022-${DATE}_V10000_anonymous_450_128_32_256_4_1024_Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_x500_x1_x0_x0.csv >> ${OUTPUT_FILE}
cat data/Results_FCFS_Score_Backfill_2022-${DATE}-\>2022-${DATE}_V10000_anonymous_450_128_32_256_4_1024_Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_conservativebf_x500_x1_x0_x0.csv >> ${OUTPUT_FILE}
cat data/Results_FCFS_Score_Backfill_2022-${DATE}-\>2022-${DATE}_V10000_anonymous_450_128_32_256_4_1024_Fcfs_with_a_score_mixed_strategy_x500_x1_x0_x0.csv >> ${OUTPUT_FILE}
cat data/Results_FCFS_Score_Backfill_2022-${DATE}-\>2022-${DATE}_V10000_anonymous_450_128_32_256_4_1024_Fcfs_with_a_score_mixed_strategy_conservativebf_x500_x1_x0_x0.csv >> ${OUTPUT_FILE}
