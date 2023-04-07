# bash plot_in_ICPP_paper.sh

# Boxplots
#ALL
python3 src/plot_boxplot.py all all byuser NO_BF stretch 1 boxplot


#~ day1="10-03"
#~ day2="10-09"
#~ make print_cluster_usage_core_by_core -C C/
#~ ./C/main inputs/workloads/converted/2022-${day1}-\>2022-${day2}_V10000_anonymous inputs/clusters/rackham_450_128_32_256_4_1024.txt Fcfs 0 outputs/test.csv 0 100
#~ python3 src/plot_stats_one_execution.py outputs/Stats_Fcfs.csv Used_nodes 2022-${day1}-\>2022-${day2}_V10000_anonymous 450_128_32_256_4_1024 Fcfs 0 0 0 0 0 03 10 2022 core_by_core 7
#~ mv outputs/Stats_Fcfs.csv data/Stats_Fcfs_${day1}-${day2}.csv
#~ python3 src/plot_stats_one_execution.py data/Stats_Fcfs_${day1}-${day2}.csv Used_nodes 2022-${day1}-\>2022-${day2}_V10000_anonymous 450_128_32_256_4_1024 Fcfs 0 0 0 0 0 03 10 2022 core_by_core 7


#~ day1="10-24"
#~ day2="10-30"
#~ make print_cluster_usage_core_by_core -C C/
#~ ./C/main inputs/workloads/converted/2022-${day1}-\>2022-${day2}_V10000_anonymous inputs/clusters/rackham_450_128_32_256_4_1024.txt Fcfs 0 outputs/test.csv 0 100
#~ python3 src/plot_stats_one_execution.py outputs/Stats_Fcfs.csv Used_nodes 2022-${day1}-\>2022-${day2}_V10000_anonymous 450_128_32_256_4_1024 Fcfs 0 0 0 0 0 24 10 2022 core_by_core 7
#~ mv outputs/Stats_Fcfs.csv data/Stats_Fcfs_${day1}-${day2}.csv
#~ python3 src/plot_stats_one_execution.py data/Stats_Fcfs_${day1}-${day2}.csv Used_nodes 2022-${day1}-\>2022-${day2}_V10000_anonymous 450_128_32_256_4_1024 Fcfs 0 0 0 0 0 24 10 2022 core_by_core 7


# Points
#~ python3 src/plot_queue_times.py data/Stretch_times_FCFS_2022-10-03-\>2022-10-09_V10000_anonymous_450_128_32_256_4_1024.txt data/Stretch_times_SCORE_2022-10-03-\>2022-10-09_V10000_anonymous_450_128_32_256_4_1024.txt stretch LEA 2022-10-03-\>2022-10-09_V10000_anonymous

#~ python3 src/plot_queue_times.py data/Stretch_times_FCFS_2022-10-03-\>2022-10-09_V10000_anonymous_450_128_32_256_4_1024.txt data/Stretch_times_EFT-SCORE-MIX_2022-10-03-\>2022-10-09_V10000_anonymous_450_128_32_256_4_1024.txt stretch LEM 2022-10-03-\>2022-10-09_V10000_anonymous

#~ python3 src/plot_queue_times.py data/Stretch_times_FCFS_2022-10-24-\>2022-10-30_V10000_anonymous_450_128_32_256_4_1024.txt data/Stretch_times_SCORE_2022-10-24-\>2022-10-30_V10000_anonymous_450_128_32_256_4_1024.txt stretch LEA 2022-10-24-\>2022-10-30_V10000_anonymous


#~ date1="10-03"
#~ date2="10-09"

#~ python3 src/plot_boxplot.py ${date1} ${date2} byuser NO_BF transfer_time 1 hist
#~ python3 src/plot_boxplot.py ${date1} ${date2} byuser NO_BF core_time 1 boxplot
#~ python3 src/plot_boxplot.py ${date1} ${date2} byuser NO_BF core_time 1 hist
#~ python3 src/plot_boxplot.py ${date1} ${date2} byuser NO_BF stretch 1 boxplot
#~ python3 src/plot_boxplot.py ${date1} ${date2} byuser NO_BF bounded_stretch 1 boxplot

#~ python3 src/plot_boxplot.py ${date1} ${date2} byuser BF transfer_time 1 hist
#~ python3 src/plot_boxplot.py ${date1} ${date2} byuser BF core_time 1 boxplot
#~ python3 src/plot_boxplot.py ${date1} ${date2} byuser BF core_time 1 hist
#~ python3 src/plot_boxplot.py ${date1} ${date2} byuser BF stretch 1 boxplot
#~ python3 src/plot_boxplot.py ${date1} ${date2} byuser BF bounded_stretch 1 boxplot

# ECDF
# python3 src/plot_boxplot.py ${date1} ${date2} byuser NO_BF stretch 1 ecdf

# NO_BF VS BF
#~ python3 src/plot_bf_vs_nobf.py ${date1} ${date2}

#~ date1="10-24"
#~ date2="10-30"

#~ python3 src/plot_boxplot.py ${date1} ${date2} byuser NO_BF transfer_time 1 hist
#~ python3 src/plot_boxplot.py ${date1} ${date2} byuser NO_BF core_time 1 boxplot
#~ python3 src/plot_boxplot.py ${date1} ${date2} byuser NO_BF core_time 1 hist
#~ python3 src/plot_boxplot.py ${date1} ${date2} byuser NO_BF stretch 1 boxplot
#~ python3 src/plot_boxplot.py ${date1} ${date2} byuser NO_BF bounded_stretch 1 boxplot

#~ python3 src/plot_boxplot.py ${date1} ${date2} byuser BF transfer_time 1 hist
#~ python3 src/plot_boxplot.py ${date1} ${date2} byuser BF core_time 1 boxplot
#~ python3 src/plot_boxplot.py ${date1} ${date2} byuser BF core_time 1 hist
#~ python3 src/plot_boxplot.py ${date1} ${date2} byuser BF stretch 1 boxplot
#~ python3 src/plot_boxplot.py ${date1} ${date2} byuser BF bounded_stretch 1 boxplot

# ECDF
# python3 src/plot_boxplot.py ${date1} ${date2} byuser NO_BF stretch 1 ecdf

# NO_BF VS BF
#~ python3 src/plot_bf_vs_nobf.py ${date1} ${date2}

#~ date1="all"
#~ date2="all"

#~ python3 src/plot_boxplot.py ${date1} ${date2} byuser NO_BF transfer_time 1 hist
#~ python3 src/plot_boxplot.py ${date1} ${date2} byuser NO_BF core_time 1 boxplot
#~ python3 src/plot_boxplot.py ${date1} ${date2} byuser NO_BF core_time 1 hist
#~ python3 src/plot_boxplot.py ${date1} ${date2} byuser NO_BF stretch 1 boxplot
#~ python3 src/plot_boxplot.py ${date1} ${date2} byuser NO_BF bounded_stretch 1 boxplot

#~ python3 src/plot_boxplot.py ${date1} ${date2} byuser BF transfer_time 1 hist
#~ python3 src/plot_boxplot.py ${date1} ${date2} byuser BF core_time 1 boxplot
#~ python3 src/plot_boxplot.py ${date1} ${date2} byuser BF core_time 1 hist
#~ python3 src/plot_boxplot.py ${date1} ${date2} byuser BF stretch 1 boxplot
#~ python3 src/plot_boxplot.py ${date1} ${date2} byuser BF bounded_stretch 1 boxplot

# ECDF
# python3 src/plot_boxplot.py ${date1} ${date2} byuser NO_BF stretch 1 ecdf

# NO_BF VS BF
#~ python3 src/plot_bf_vs_nobf.py ${date1} ${date2}
