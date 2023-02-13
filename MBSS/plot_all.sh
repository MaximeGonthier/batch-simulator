PROPORTION="V10000"

# Plots in paper

# Bar plots
#~ python3 src/plot_dot_and_bar.py Results_FCFS_Score_Backfill_2022-07-16-\>2022-07-16_V10000 Mean_Stretch Total_waiting_for_a_load_time_and_transfer_time 450_128_32_256_4_1024 data/Results_FCFS_Score_Backfill_2022-07-16-\>2022-07-16_V10000_450_128_32_256_4_1024.csv 0
#~ python3 src/plot_dot_and_bar.py Results_FCFS_Score_Backfill_2022-09-09-\>2022-09-09_V10000 Mean_Stretch Total_waiting_for_a_load_time_and_transfer_time 450_128_32_256_4_1024 data/Results_FCFS_Score_Backfill_2022-09-09-\>2022-09-09_V10000_450_128_32_256_4_1024.csv 0
#~ python3 src/plot_dot_and_bar.py Results_FCFS_Score_Backfill_2022-03-26-\>2022-03-26_V10000 Mean_Stretch Total_waiting_for_a_load_time_and_transfer_time 450_128_32_256_4_1024 data/Results_FCFS_Score_Backfill_2022-03-26-\>2022-03-26_V10000_450_128_32_256_4_1024.csv 0
#~ python3 src/plot_dot_and_bar.py Results_FCFS_Score_Backfill_2022-08-16-\>2022-08-16_V10000 Mean_Stretch Total_waiting_for_a_load_time_and_transfer_time 450_128_32_256_4_1024 data/Results_FCFS_Score_Backfill_2022-08-16-\>2022-08-16_V10000_450_128_32_256_4_1024.csv 0
#~ python3 src/plot_barplot.py Results_FCFS_Score_Backfill_2022-01-28-\>2022-01-28_V10000 Mean_Stretch 450_128_32_256_4_1024 0 data/Results_FCFS_Score_Backfill_2022-01-28-\>2022-01-28_V10000_450_128_32_256_4_1024.csv 4

# Cluster usage
#~ python3 src/plot_stats_one_execution.py data/Stats_Fcfs_07-16.csv Used_nodes 2022-07-16-\>2022-07-16_V10000 450_128_32_256_4_1024 Fcfs 0 0 0 0 1 16 07 2022 core_by_core
#~ python3 src/plot_stats_one_execution.py data/Stats_Fcfs_with_a_score_x500_x1_x0_x0_07-16.csv Used_nodes 2022-07-16-\>2022-07-16_V10000 450_128_32_256_4_1024 Fcfs_with_a_score_x500_x1_x0_x0 0 0 0 0 1 16 07 2022 core_by_core
#~ python3 src/plot_stats_one_execution.py data/Stats_Fcfs_with_a_score_mixed_strategy_x500_x1_x0_x0_07-16.csv Used_nodes 2022-07-16-\>2022-07-16_V10000 450_128_32_256_4_1024 Fcfs_with_a_score_mixed_strategy_x500_x1_x0_x0 0 0 0 0 1 16 07 2022 core_by_core
#~ python3 src/plot_stats_one_execution.py data/Stats_Fcfs_09-09.csv Used_nodes 2022-09-09-\>2022-09-09_V10000 450_128_32_256_4_1024 Fcfs 0 0 0 0 1 09 09 2022 core_by_core
#~ python3 src/plot_stats_one_execution.py data/Stats_Fcfs_with_a_score_mixed_strategy_x500_x1_x0_x0_09-09.csv Used_nodes 2022-09-09-\>2022-09-09_V10000 450_128_32_256_4_1024 Fcfs_with_a_score_mixed_strategy_x500_x1_x0_x0 0 0 0 0 1 09 09 2022 core_by_core
#~ python3 src/plot_stats_one_execution.py data/Stats_Fcfs_03-26.csv Used_nodes 2022-03-26-\>2022-03-26_V10000 450_128_32_256_4_1024 Fcfs 0 0 0 0 1 26 03 2022 core_by_core

# Boxplots
#~ python3 src/plot_boxplot.py outputs/scatter_mean_stretch_all_workloads.csv
#~ python3 src/plot_boxplot.py outputs/scatter_mean_stretch_all_workloads_bf.csv

# ECDF
#~ python3 src/ecdf.py outputs/scatter_mean_stretch_all_workloads.csv

# Courbes VS
#~ python3 src/plot_queue_times.py data/Stretch_times_FCFS_2022-07-16-\>2022-07-16_V10000_450_128_32_256_4_1024.txt  data/Stretch_times_SCORE_2022-07-16-\>2022-07-16_V10000_450_128_32_256_4_1024.txt stretch LEA 2022-07-16-\>2022-07-16_V10000
#~ python3 src/plot_queue_times.py data/Stretch_times_FCFS_2022-07-16-\>2022-07-16_V10000_450_128_32_256_4_1024.txt  data/Stretch_times_EFT-SCORE-MIX_2022-07-16-\>2022-07-16_V10000_450_128_32_256_4_1024.txt stretch LEM 2022-07-16-\>2022-07-16_V10000
#~ python3 src/plot_queue_times.py data/Stretch_times_FCFS_2022-03-26-\>2022-03-26_V10000_450_128_32_256_4_1024.txt  data/Stretch_times_EFT-SCORE-MIX_2022-03-26-\>2022-03-26_V10000_450_128_32_256_4_1024.txt stretch LEM 2022-03-26-\>2022-03-26_V10000







# First batch
#~ DATE="2022-01-17->2022-01-17"
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Backfill 0
#~ python3 src/compute_percentage_reduction.py data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv ${DATE}_${PROPORTION}
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_${DATE}_${PROPORTION} Percentage_FCFS 1
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_bf_${DATE}_${PROPORTION} Percentage_FCFS_BF 2
#~ DATE="2022-01-21->2022-01-21"
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Backfill 0
#~ python3 src/compute_percentage_reduction.py data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv ${DATE}_${PROPORTION}
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_${DATE}_${PROPORTION} Percentage_FCFS 1
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_bf_${DATE}_${PROPORTION} Percentage_FCFS_BF 2
#~ DATE="2022-01-28->2022-01-28"
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Backfill 0 26481
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Backfill 3 26481
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Backfill 4 26481
#~ python3 src/compute_percentage_reduction.py data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv ${DATE}_${PROPORTION}
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_${DATE}_${PROPORTION} Percentage_FCFS 1
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_bf_${DATE}_${PROPORTION} Percentage_FCFS_BF 2
#~ DATE="2022-02-01->2022-02-01"
#~ PROPORTION="V10000"
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Backfill 0
#~ python3 src/compute_percentage_reduction.py data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv ${DATE}_${PROPORTION}
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_${DATE}_${PROPORTION} Percentage_FCFS 1
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_bf_${DATE}_${PROPORTION} Percentage_FCFS_BF 2
#~ DATE="2022-02-02->2022-02-03"
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Backfill 0
#~ python3 src/compute_percentage_reduction.py data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv ${DATE}_${PROPORTION}
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_${DATE}_${PROPORTION} Percentage_FCFS 1
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_bf_${DATE}_${PROPORTION} Percentage_FCFS_BF 2
#~ DATE="2022-03-15->2022-03-16"
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Backfill 0
#~ python3 src/compute_percentage_reduction.py data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv ${DATE}_${PROPORTION}
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_${DATE}_${PROPORTION} Percentage_FCFS 1
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_bf_${DATE}_${PROPORTION} Percentage_FCFS_BF 2
#~ DATE="2022-04-07->2022-04-09"
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Backfill 0
#~ python3 src/compute_percentage_reduction.py data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv ${DATE}_${PROPORTION}
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_${DATE}_${PROPORTION} Percentage_FCFS 1
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_bf_${DATE}_${PROPORTION} Percentage_FCFS_BF 2
#~ DATE="2022-04-19->2022-04-19"
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Backfill 0
#~ python3 src/compute_percentage_reduction.py data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv ${DATE}_${PROPORTION}
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_${DATE}_${PROPORTION} Percentage_FCFS 1
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_bf_${DATE}_${PROPORTION} Percentage_FCFS_BF 2
#~ DATE="2022-05-06->2022-05-06"
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Backfill 0
#~ python3 src/compute_percentage_reduction.py data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv ${DATE}_${PROPORTION}
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_${DATE}_${PROPORTION} Percentage_FCFS 1
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_bf_${DATE}_${PROPORTION} Percentage_FCFS_BF 2
#~ DATE="2022-07-13->2022-07-13"
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Backfill 0
#~ python3 src/compute_percentage_reduction.py data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv ${DATE}_${PROPORTION}
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_${DATE}_${PROPORTION} Percentage_FCFS 1
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_bf_${DATE}_${PROPORTION} Percentage_FCFS_BF 2
#~ DATE="2022-07-14->2022-07-14"
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Backfill 0
#~ python3 src/compute_percentage_reduction.py data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv ${DATE}_${PROPORTION}
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_${DATE}_${PROPORTION} Percentage_FCFS 1
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_bf_${DATE}_${PROPORTION} Percentage_FCFS_BF 2
#~ DATE="2022-07-16->2022-07-16"
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Backfill 0 7434
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Backfill 3 7434
#~ python3 src/compute_percentage_reduction.py data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv ${DATE}_${PROPORTION}
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_${DATE}_${PROPORTION} Percentage_FCFS 1
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_bf_${DATE}_${PROPORTION} Percentage_FCFS_BF 2
#~ DATE="2022-07-17->2022-07-17"
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Backfill 0
#~ python3 src/compute_percentage_reduction.py data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv ${DATE}_${PROPORTION}
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_${DATE}_${PROPORTION} Percentage_FCFS 1
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_bf_${DATE}_${PROPORTION} Percentage_FCFS_BF 2
#~ DATE="2022-07-18->2022-07-18"
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Backfill 0
#~ python3 src/compute_percentage_reduction.py data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv ${DATE}_${PROPORTION}
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_${DATE}_${PROPORTION} Percentage_FCFS 1
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_bf_${DATE}_${PROPORTION} Percentage_FCFS_BF 2
#~ DATE="2022-08-16->2022-08-16"
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Backfill 0 41306
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Backfill 3 41306
#~ python3 src/compute_percentage_reduction.py data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv ${DATE}_${PROPORTION}
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_${DATE}_${PROPORTION} Percentage_FCFS 1
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_bf_${DATE}_${PROPORTION} Percentage_FCFS_BF 2

# Second batch
#~ DATE="2022-03-12->2022-03-12"
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Backfill 0
#~ python3 src/compute_percentage_reduction.py data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv ${DATE}_${PROPORTION}
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_${DATE}_${PROPORTION} Percentage_FCFS 1
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_bf_${DATE}_${PROPORTION} Percentage_FCFS_BF 2
#~ DATE="2022-03-13->2022-03-13"
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Backfill 0
#~ python3 src/compute_percentage_reduction.py data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv ${DATE}_${PROPORTION}
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_${DATE}_${PROPORTION} Percentage_FCFS 1
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_bf_${DATE}_${PROPORTION} Percentage_FCFS_BF 2
#~ DATE="2022-03-14->2022-03-14"
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Backfill 0
#~ python3 src/compute_percentage_reduction.py data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv ${DATE}_${PROPORTION}
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_${DATE}_${PROPORTION} Percentage_FCFS 1
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_bf_${DATE}_${PROPORTION} Percentage_FCFS_BF 2
#~ DATE="2022-03-26->2022-03-26"
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Backfill 0 4721
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Backfill 3 4721
#~ python3 src/compute_percentage_reduction.py data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv ${DATE}_${PROPORTION}
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_${DATE}_${PROPORTION} Percentage_FCFS 1
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_bf_${DATE}_${PROPORTION} Percentage_FCFS_BF 2
#~ DATE="2022-03-30->2022-03-30"
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Backfill 0
#~ python3 src/compute_percentage_reduction.py data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv ${DATE}_${PROPORTION}
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_${DATE}_${PROPORTION} Percentage_FCFS 1
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_bf_${DATE}_${PROPORTION} Percentage_FCFS_BF 2

# Third batch
#~ for ((i=1; i<=16; i++))
#~ for ((i=3; i<=3; i++))
#~ do 
	#~ if [ $((i)) == 1 ]; then DATE="2022-06-08->2022-06-08"
	#~ elif [ $((i)) == 2 ]; then DATE="2022-09-12->2022-09-12"
	#~ elif [ $((i)) == 3 ]; then DATE="2022-09-13->2022-09-13"; NJOBSE=15473
	#~ elif [ $((i)) == 4 ]; then DATE="2022-04-21->2022-04-21"
	#~ elif [ $((i)) == 5 ]; then DATE="2022-09-07->2022-09-07"
	#~ elif [ $((i)) == 6 ]; then DATE="2022-09-09->2022-09-09"; NJOBSE=10201
	#~ elif [ $((i)) == 7 ]; then DATE="2022-09-10->2022-09-10"
	#~ elif [ $((i)) == 8 ]; then DATE="2022-09-11->2022-09-11"; NJOBSE=7202
	#~ elif [ $((i)) == 9 ]; then DATE="2022-09-14->2022-09-14"
	#~ elif [ $((i)) == 10 ]; then DATE="2022-09-17->2022-09-17"
	#~ elif [ $((i)) == 11 ]; then DATE="2022-09-18->2022-09-18"
	#~ elif [ $((i)) == 12 ]; then DATE="2022-08-13->2022-08-13"
	#~ elif [ $((i)) == 13 ]; then DATE="2022-08-14->2022-08-14"
	#~ elif [ $((i)) == 14 ]; then DATE="2022-08-24->2022-08-24"
	#~ elif [ $((i)) == 15 ]; then DATE="2022-08-25->2022-08-25"
	#~ elif [ $((i)) == 16 ]; then DATE="2022-08-26->2022-08-26"	
	#~ fi
	#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Backfill 0 ${NJOBSE}
	#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Backfill 3 ${NJOBSE}
	#~ python3 src/compute_percentage_reduction.py data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv ${DATE}_${PROPORTION}
	#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_${DATE}_${PROPORTION} Percentage_FCFS 1
	#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_bf_${DATE}_${PROPORTION} Percentage_FCFS_BF 2
#~ done

# Fourth batch
#~ echo "Fourth batch"
#~ for ((i=1; i<=5; i++))
#~ do 
	#~ if [ $((i)) == 1 ]; then DATE="2022-03-25->2022-03-25"
	#~ elif [ $((i)) == 2 ]; then DATE="2022-06-11->2022-06-11"
	#~ elif [ $((i)) == 3 ]; then DATE="2022-03-27->2022-03-27"
	#~ elif [ $((i)) == 4 ]; then DATE="2022-03-23->2022-03-23"
	#~ elif [ $((i)) == 5 ]; then DATE="2022-03-31->2022-03-31"
	#~ fi
	#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Backfill 0
	#~ python3 src/compute_percentage_reduction.py data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv ${DATE}_${PROPORTION}
	#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_${DATE}_${PROPORTION} Percentage_FCFS 1
	#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_bf_${DATE}_${PROPORTION} Percentage_FCFS_BF 2
#~ done

# Fifth batch
#~ echo "Fifth batch"
#~ for ((i=1; i<=3; i++))
#~ do 
	#~ if [ $((i)) == 1 ]; then DATE="2022-09-15->2022-09-15"
	#~ elif [ $((i)) == 2 ]; then DATE="2022-01-02->2022-01-02"
	#~ elif [ $((i)) == 3 ]; then DATE="2022-09-16->2022-09-16"
	#~ fi
	#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Backfill 0
	#~ python3 src/compute_percentage_reduction.py data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv ${DATE}_${PROPORTION}
	#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_${DATE}_${PROPORTION} Percentage_FCFS 1
	#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_bf_${DATE}_${PROPORTION} Percentage_FCFS_BF 2
#~ done

#~ # NEW 44
#~ # Getting all values and plotting mean and median. Careful I need compute_percentages_all_workloads.py for scatter and boxplots latter on so keep it!
#~ python3 src/compute_percentages_all_workloads.py 44 0 mean data/Percentages_to_fcfs_2022-01-17-\>2022-01-17_V10000 data/Percentages_to_fcfs_2022-01-21-\>2022-01-21_V10000 data/Percentages_to_fcfs_2022-02-01-\>2022-02-01_V10000 data/Percentages_to_fcfs_2022-02-02-\>2022-02-03_V10000 data/Percentages_to_fcfs_2022-03-15-\>2022-03-16_V10000 data/Percentages_to_fcfs_2022-04-07-\>2022-04-09_V10000 data/Percentages_to_fcfs_2022-04-19-\>2022-04-19_V10000 data/Percentages_to_fcfs_2022-08-16-\>2022-08-16_V10000 data/Percentages_to_fcfs_2022-01-28-\>2022-01-28_V10000 data/Percentages_to_fcfs_2022-05-06-\>2022-05-06_V10000 data/Percentages_to_fcfs_2022-07-13-\>2022-07-13_V10000 data/Percentages_to_fcfs_2022-07-16-\>2022-07-16_V10000 data/Percentages_to_fcfs_2022-07-17-\>2022-07-17_V10000 data/Percentages_to_fcfs_2022-07-18-\>2022-07-18_V10000 data/Percentages_to_fcfs_2022-07-14-\>2022-07-14_V10000 data/Percentages_to_fcfs_2022-03-12-\>2022-03-12_V10000 data/Percentages_to_fcfs_2022-03-13-\>2022-03-13_V10000 data/Percentages_to_fcfs_2022-03-14-\>2022-03-14_V10000 data/Percentages_to_fcfs_2022-03-26-\>2022-03-26_V10000 data/Percentages_to_fcfs_2022-03-30-\>2022-03-30_V10000 data/Percentages_to_fcfs_2022-06-08-\>2022-06-08_V10000 data/Percentages_to_fcfs_2022-09-12-\>2022-09-12_V10000 data/Percentages_to_fcfs_2022-09-13-\>2022-09-13_V10000 data/Percentages_to_fcfs_2022-04-21-\>2022-04-21_V10000 data/Percentages_to_fcfs_2022-09-07-\>2022-09-07_V10000 data/Percentages_to_fcfs_2022-09-10-\>2022-09-10_V10000 data/Percentages_to_fcfs_2022-09-09-\>2022-09-09_V10000 data/Percentages_to_fcfs_2022-09-11-\>2022-09-11_V10000 data/Percentages_to_fcfs_2022-09-14-\>2022-09-14_V10000 data/Percentages_to_fcfs_2022-09-17-\>2022-09-17_V10000 data/Percentages_to_fcfs_2022-09-18-\>2022-09-18_V10000 data/Percentages_to_fcfs_2022-08-13-\>2022-08-13_V10000 data/Percentages_to_fcfs_2022-08-14-\>2022-08-14_V10000 data/Percentages_to_fcfs_2022-08-24-\>2022-08-24_V10000 data/Percentages_to_fcfs_2022-08-25-\>2022-08-25_V10000 data/Percentages_to_fcfs_2022-08-26-\>2022-08-26_V10000 data/Percentages_to_fcfs_2022-06-11-\>2022-06-11_V10000 data/Percentages_to_fcfs_2022-03-23-\>2022-03-23_V10000 data/Percentages_to_fcfs_2022-03-25-\>2022-03-25_V10000 data/Percentages_to_fcfs_2022-03-27-\>2022-03-27_V10000 data/Percentages_to_fcfs_2022-03-31-\>2022-03-31_V10000 data/Percentages_to_fcfs_2022-09-15-\>2022-09-15_V10000 data/Percentages_to_fcfs_2022-09-16-\>2022-09-16_V10000 data/Percentages_to_fcfs_2022-01-02-\>2022-01-02_V10000
#~ bash plot.sh inputs/workloads/converted/All_workloads_mean inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_all_workloads_mean Percentage_FCFS 1
#~ python3 src/compute_percentages_all_workloads.py 44 0 mediane data/Percentages_to_fcfs_2022-01-17-\>2022-01-17_V10000 data/Percentages_to_fcfs_2022-01-21-\>2022-01-21_V10000 data/Percentages_to_fcfs_2022-02-01-\>2022-02-01_V10000 data/Percentages_to_fcfs_2022-02-02-\>2022-02-03_V10000 data/Percentages_to_fcfs_2022-03-15-\>2022-03-16_V10000 data/Percentages_to_fcfs_2022-04-07-\>2022-04-09_V10000 data/Percentages_to_fcfs_2022-04-19-\>2022-04-19_V10000 data/Percentages_to_fcfs_2022-08-16-\>2022-08-16_V10000 data/Percentages_to_fcfs_2022-01-28-\>2022-01-28_V10000 data/Percentages_to_fcfs_2022-05-06-\>2022-05-06_V10000 data/Percentages_to_fcfs_2022-07-13-\>2022-07-13_V10000 data/Percentages_to_fcfs_2022-07-16-\>2022-07-16_V10000 data/Percentages_to_fcfs_2022-07-17-\>2022-07-17_V10000 data/Percentages_to_fcfs_2022-07-18-\>2022-07-18_V10000 data/Percentages_to_fcfs_2022-07-14-\>2022-07-14_V10000 data/Percentages_to_fcfs_2022-03-12-\>2022-03-12_V10000 data/Percentages_to_fcfs_2022-03-13-\>2022-03-13_V10000 data/Percentages_to_fcfs_2022-03-14-\>2022-03-14_V10000 data/Percentages_to_fcfs_2022-03-26-\>2022-03-26_V10000 data/Percentages_to_fcfs_2022-03-30-\>2022-03-30_V10000 data/Percentages_to_fcfs_2022-06-08-\>2022-06-08_V10000 data/Percentages_to_fcfs_2022-09-12-\>2022-09-12_V10000 data/Percentages_to_fcfs_2022-09-13-\>2022-09-13_V10000 data/Percentages_to_fcfs_2022-04-21-\>2022-04-21_V10000 data/Percentages_to_fcfs_2022-09-07-\>2022-09-07_V10000 data/Percentages_to_fcfs_2022-09-10-\>2022-09-10_V10000 data/Percentages_to_fcfs_2022-09-09-\>2022-09-09_V10000 data/Percentages_to_fcfs_2022-09-11-\>2022-09-11_V10000 data/Percentages_to_fcfs_2022-09-14-\>2022-09-14_V10000 data/Percentages_to_fcfs_2022-09-17-\>2022-09-17_V10000 data/Percentages_to_fcfs_2022-09-18-\>2022-09-18_V10000 data/Percentages_to_fcfs_2022-08-13-\>2022-08-13_V10000 data/Percentages_to_fcfs_2022-08-14-\>2022-08-14_V10000 data/Percentages_to_fcfs_2022-08-24-\>2022-08-24_V10000 data/Percentages_to_fcfs_2022-08-25-\>2022-08-25_V10000 data/Percentages_to_fcfs_2022-08-26-\>2022-08-26_V10000 data/Percentages_to_fcfs_2022-06-11-\>2022-06-11_V10000 data/Percentages_to_fcfs_2022-03-23-\>2022-03-23_V10000 data/Percentages_to_fcfs_2022-03-25-\>2022-03-25_V10000 data/Percentages_to_fcfs_2022-03-27-\>2022-03-27_V10000 data/Percentages_to_fcfs_2022-03-31-\>2022-03-31_V10000 data/Percentages_to_fcfs_2022-09-15-\>2022-09-15_V10000 data/Percentages_to_fcfs_2022-09-16-\>2022-09-16_V10000 data/Percentages_to_fcfs_2022-01-02-\>2022-01-02_V10000
#~ bash plot.sh inputs/workloads/converted/All_workloads_mediane inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_all_workloads_mediane Percentage_FCFS 1
#~ # All avec bf
#~ python3 src/compute_percentages_all_workloads.py 44 1 mean data/Percentages_to_fcfs_bf_2022-01-17-\>2022-01-17_V10000 data/Percentages_to_fcfs_bf_2022-01-21-\>2022-01-21_V10000 data/Percentages_to_fcfs_bf_2022-02-01-\>2022-02-01_V10000 data/Percentages_to_fcfs_bf_2022-02-02-\>2022-02-03_V10000 data/Percentages_to_fcfs_bf_2022-03-15-\>2022-03-16_V10000 data/Percentages_to_fcfs_bf_2022-04-07-\>2022-04-09_V10000 data/Percentages_to_fcfs_bf_2022-04-19-\>2022-04-19_V10000 data/Percentages_to_fcfs_bf_2022-08-16-\>2022-08-16_V10000 data/Percentages_to_fcfs_bf_2022-01-28-\>2022-01-28_V10000 data/Percentages_to_fcfs_bf_2022-05-06-\>2022-05-06_V10000 data/Percentages_to_fcfs_bf_2022-07-13-\>2022-07-13_V10000 data/Percentages_to_fcfs_bf_2022-07-16-\>2022-07-16_V10000 data/Percentages_to_fcfs_bf_2022-07-17-\>2022-07-17_V10000 data/Percentages_to_fcfs_bf_2022-07-18-\>2022-07-18_V10000 data/Percentages_to_fcfs_bf_2022-07-14-\>2022-07-14_V10000 data/Percentages_to_fcfs_bf_2022-03-12-\>2022-03-12_V10000 data/Percentages_to_fcfs_bf_2022-03-13-\>2022-03-13_V10000 data/Percentages_to_fcfs_bf_2022-03-14-\>2022-03-14_V10000 data/Percentages_to_fcfs_bf_2022-03-26-\>2022-03-26_V10000 data/Percentages_to_fcfs_bf_2022-03-30-\>2022-03-30_V10000 data/Percentages_to_fcfs_bf_2022-06-08-\>2022-06-08_V10000 data/Percentages_to_fcfs_bf_2022-09-12-\>2022-09-12_V10000 data/Percentages_to_fcfs_bf_2022-09-13-\>2022-09-13_V10000 data/Percentages_to_fcfs_bf_2022-04-21-\>2022-04-21_V10000 data/Percentages_to_fcfs_bf_2022-09-07-\>2022-09-07_V10000 data/Percentages_to_fcfs_bf_2022-09-10-\>2022-09-10_V10000 data/Percentages_to_fcfs_bf_2022-09-09-\>2022-09-09_V10000 data/Percentages_to_fcfs_bf_2022-09-11-\>2022-09-11_V10000 data/Percentages_to_fcfs_bf_2022-09-14-\>2022-09-14_V10000 data/Percentages_to_fcfs_bf_2022-09-17-\>2022-09-17_V10000 data/Percentages_to_fcfs_bf_2022-09-18-\>2022-09-18_V10000 data/Percentages_to_fcfs_bf_2022-08-13-\>2022-08-13_V10000 data/Percentages_to_fcfs_bf_2022-08-14-\>2022-08-14_V10000 data/Percentages_to_fcfs_bf_2022-08-24-\>2022-08-24_V10000 data/Percentages_to_fcfs_bf_2022-08-25-\>2022-08-25_V10000 data/Percentages_to_fcfs_bf_2022-08-26-\>2022-08-26_V10000 data/Percentages_to_fcfs_bf_2022-06-11-\>2022-06-11_V10000 data/Percentages_to_fcfs_bf_2022-03-23-\>2022-03-23_V10000 data/Percentages_to_fcfs_bf_2022-03-25-\>2022-03-25_V10000 data/Percentages_to_fcfs_bf_2022-03-27-\>2022-03-27_V10000 data/Percentages_to_fcfs_bf_2022-03-31-\>2022-03-31_V10000 data/Percentages_to_fcfs_bf_2022-09-15-\>2022-09-15_V10000 data/Percentages_to_fcfs_bf_2022-09-16-\>2022-09-16_V10000 data/Percentages_to_fcfs_bf_2022-01-02-\>2022-01-02_V10000
#~ bash plot.sh inputs/workloads/converted/All_workloads_mean inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_bf_all_workloads_mean Percentage_FCFS_BF 2
#~ python3 src/compute_percentages_all_workloads.py 44 1 mediane data/Percentages_to_fcfs_bf_2022-01-17-\>2022-01-17_V10000 data/Percentages_to_fcfs_bf_2022-01-21-\>2022-01-21_V10000 data/Percentages_to_fcfs_bf_2022-02-01-\>2022-02-01_V10000 data/Percentages_to_fcfs_bf_2022-02-02-\>2022-02-03_V10000 data/Percentages_to_fcfs_bf_2022-03-15-\>2022-03-16_V10000 data/Percentages_to_fcfs_bf_2022-04-07-\>2022-04-09_V10000 data/Percentages_to_fcfs_bf_2022-04-19-\>2022-04-19_V10000 data/Percentages_to_fcfs_bf_2022-08-16-\>2022-08-16_V10000 data/Percentages_to_fcfs_bf_2022-01-28-\>2022-01-28_V10000 data/Percentages_to_fcfs_bf_2022-05-06-\>2022-05-06_V10000 data/Percentages_to_fcfs_bf_2022-07-13-\>2022-07-13_V10000 data/Percentages_to_fcfs_bf_2022-07-16-\>2022-07-16_V10000 data/Percentages_to_fcfs_bf_2022-07-17-\>2022-07-17_V10000 data/Percentages_to_fcfs_bf_2022-07-18-\>2022-07-18_V10000 data/Percentages_to_fcfs_bf_2022-07-14-\>2022-07-14_V10000 data/Percentages_to_fcfs_bf_2022-03-12-\>2022-03-12_V10000 data/Percentages_to_fcfs_bf_2022-03-13-\>2022-03-13_V10000 data/Percentages_to_fcfs_bf_2022-03-14-\>2022-03-14_V10000 data/Percentages_to_fcfs_bf_2022-03-26-\>2022-03-26_V10000 data/Percentages_to_fcfs_bf_2022-03-30-\>2022-03-30_V10000 data/Percentages_to_fcfs_bf_2022-06-08-\>2022-06-08_V10000 data/Percentages_to_fcfs_bf_2022-09-12-\>2022-09-12_V10000 data/Percentages_to_fcfs_bf_2022-09-13-\>2022-09-13_V10000 data/Percentages_to_fcfs_bf_2022-04-21-\>2022-04-21_V10000 data/Percentages_to_fcfs_bf_2022-09-07-\>2022-09-07_V10000 data/Percentages_to_fcfs_bf_2022-09-10-\>2022-09-10_V10000 data/Percentages_to_fcfs_bf_2022-09-09-\>2022-09-09_V10000 data/Percentages_to_fcfs_bf_2022-09-11-\>2022-09-11_V10000 data/Percentages_to_fcfs_bf_2022-09-14-\>2022-09-14_V10000 data/Percentages_to_fcfs_bf_2022-09-17-\>2022-09-17_V10000 data/Percentages_to_fcfs_bf_2022-09-18-\>2022-09-18_V10000 data/Percentages_to_fcfs_bf_2022-08-13-\>2022-08-13_V10000 data/Percentages_to_fcfs_bf_2022-08-14-\>2022-08-14_V10000 data/Percentages_to_fcfs_bf_2022-08-24-\>2022-08-24_V10000 data/Percentages_to_fcfs_bf_2022-08-25-\>2022-08-25_V10000 data/Percentages_to_fcfs_bf_2022-08-26-\>2022-08-26_V10000 data/Percentages_to_fcfs_bf_2022-06-11-\>2022-06-11_V10000 data/Percentages_to_fcfs_bf_2022-03-23-\>2022-03-23_V10000 data/Percentages_to_fcfs_bf_2022-03-25-\>2022-03-25_V10000 data/Percentages_to_fcfs_bf_2022-03-27-\>2022-03-27_V10000 data/Percentages_to_fcfs_bf_2022-03-31-\>2022-03-31_V10000 data/Percentages_to_fcfs_bf_2022-09-15-\>2022-09-15_V10000 data/Percentages_to_fcfs_bf_2022-09-16-\>2022-09-16_V10000 data/Percentages_to_fcfs_bf_2022-01-02-\>2022-01-02_V10000
#~ bash plot.sh inputs/workloads/converted/All_workloads_mediane inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_bf_all_workloads_mediane Percentage_FCFS_BF 2

#~ # Scatter plot
#~ echo "Scatter..."
#~ python3 src/scatter_plot.py outputs/scatter_mean_stretch_all_workloads.csv EFT
#~ python3 src/scatter_plot.py outputs/scatter_mean_stretch_all_workloads.csv SCORE
#~ python3 src/scatter_plot.py outputs/scatter_mean_stretch_all_workloads.csv OPPORTUNISTIC-SCORE-MIX
#~ python3 src/scatter_plot.py outputs/scatter_mean_stretch_all_workloads.csv EFT-SCORE-MIX
#~ python3 src/scatter_plot.py outputs/scatter_mean_stretch_all_workloads_bf.csv EFT-CONSERVATIVE-BF
#~ python3 src/scatter_plot.py outputs/scatter_mean_stretch_all_workloads_bf.csv SCORE-CONSERVATIVE-BF
#~ python3 src/scatter_plot.py outputs/scatter_mean_stretch_all_workloads_bf.csv OPPORTUNISTIC-SCORE-MIX-CONSERVATIVE-BF
#~ python3 src/scatter_plot.py outputs/scatter_mean_stretch_all_workloads_bf.csv EFT-SCORE-MIX-CONSERVATIVE-BF

#~ # Box plots
#~ python3 src/plot_boxplot.py outputs/scatter_mean_stretch_all_workloads.csv
#~ python3 src/plot_boxplot.py outputs/scatter_mean_stretch_all_workloads_bf.csv

#~ # ECDF
#~ python3 src/ecdf.py outputs/scatter_mean_stretch_all_workloads.csv
#~ python3 src/ecdf.py outputs/scatter_mean_stretch_all_workloads_bf.csv

# Best TH
#~ PROPORTION="V10000"
#~ DATE="2022-07-16->2022-07-16"
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Threshold_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Threshold 0
#~ DATE="2022-07-13->2022-07-13"
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Threshold_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Threshold 0
#~ DATE="2022-07-18->2022-07-18"
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Threshold_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Threshold 0
#~ DATE="2022-08-16->2022-08-16"
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Threshold_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Threshold 0
