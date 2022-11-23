#~ echo "No backfill, more strategies"
#~ bash plot.sh inputs/workloads/converted/2022-01-17-\>2022-01-17_V10000 inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Adaptative_Multiplier_2022-01-17-\>2022-01-17_V10000_450_128_32_256_4_1024.csv FCFS_Score_Adaptative_Multiplier
#~ bash plot.sh inputs/workloads/converted/2022-01-21-\>2022-01-21_V10000 inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Adaptative_Multiplier_2022-01-21-\>2022-01-21_V10000_450_128_32_256_4_1024.csv FCFS_Score_Adaptative_Multiplier
#~ bash plot.sh inputs/workloads/converted/2022-02-02-\>2022-02-03_V10000 inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Adaptative_Multiplier_2022-02-02-\>2022-02-03_V10000_450_128_32_256_4_1024.csv FCFS_Score_Adaptative_Multiplier
#~ bash plot.sh inputs/workloads/converted/2022-04-07-\>2022-04-09_V10000 inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Adaptative_Multiplier_2022-04-07-\>2022-04-09_V10000_450_128_32_256_4_1024.csv FCFS_Score_Adaptative_Multiplier
#~ bash plot.sh inputs/workloads/converted/2022-05-21-\>2022-05-22_V10000 inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Adaptative_Multiplier_2022-05-21-\>2022-05-22_V10000_450_128_32_256_4_1024.csv FCFS_Score_Adaptative_Multiplier
#~ bash plot.sh inputs/workloads/converted/2022-06-12-\>2022-06-13_V10000 inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Adaptative_Multiplier_2022-06-12-\>2022-06-13_V10000_450_128_32_256_4_1024.csv FCFS_Score_Adaptative_Multiplier
#~ bash plot.sh inputs/workloads/converted/2022-07-17-\>2022-07-18_V10000 inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Adaptative_Multiplier_2022-07-17-\>2022-07-18_V10000_450_128_32_256_4_1024.csv FCFS_Score_Adaptative_Multiplier
#~ bash plot.sh inputs/workloads/converted/2022-08-16-\>2022-08-16_V10000 inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Adaptative_Multiplier_2022-08-16-\>2022-08-16_V10000_450_128_32_256_4_1024.csv FCFS_Score_Adaptative_Multiplier
#~ bash plot.sh inputs/workloads/converted/2022-09-08-\>2022-09-08_V10000 inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Adaptative_Multiplier_2022-09-08-\>2022-09-08_V10000_450_128_32_256_4_1024.csv FCFS_Score_Adaptative_Multiplier

#~ echo "Easy bf"
#~ DATE="2022-01-17->2022-01-17"
#~ bash plot.sh inputs/workloads/converted/${DATE}_V10000 inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Easy_Backfill_${DATE}_V10000_450_128_32_256_4_1024.csv FCFS_Score_Easy_Backfill

#~ DATE="2022-01-21->2022-01-21"
#~ bash plot.sh inputs/workloads/converted/${DATE}_V10000 inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Easy_Backfill_${DATE}_V10000_450_128_32_256_4_1024.csv FCFS_Score_Easy_Backfill

#~ DATE="2022-03-15->2022-03-16"
#~ bash plot.sh inputs/workloads/converted/${DATE}_V10000 inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Easy_Backfill_${DATE}_V10000_450_128_32_256_4_1024.csv FCFS_Score_Easy_Backfill

#~ DATE="2022-05-21->2022-05-22"
#~ bash plot.sh inputs/workloads/converted/${DATE}_V10000 inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Easy_Backfill_${DATE}_V10000_450_128_32_256_4_1024.csv FCFS_Score_Easy_Backfill

#~ DATE="2022-08-16->2022-08-16"
#~ bash plot.sh inputs/workloads/converted/${DATE}_V10000 inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Easy_Backfill_${DATE}_V10000_450_128_32_256_4_1024.csv FCFS_Score_Easy_Backfill


#~ echo "Data persistence"
#~ DATE="2022-01-17->2022-01-17"
#~ bash plot.sh inputs/workloads/converted/${DATE}_V10000 inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_Data_Persistence_${DATE}_V10000_450_128_32_256_4_1024.csv Data_Persistence

#~ DATE="2022-01-21->2022-01-21"
#~ bash plot.sh inputs/workloads/converted/${DATE}_V10000 inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_Data_Persistence_${DATE}_V10000_450_128_32_256_4_1024.csv Data_Persistence

#~ DATE="2022-03-15->2022-03-16"
#~ bash plot.sh inputs/workloads/converted/${DATE}_V10000 inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_Data_Persistence_${DATE}_V10000_450_128_32_256_4_1024.csv Data_Persistence





echo "Conservative bf"
DATE="2022-01-17->2022-01-17"
PROPORTION="V10000"
bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Backfill 0
python3 src/compute_percentage_reduction.py data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv ${DATE}_${PROPORTION}
bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_${DATE}_${PROPORTION} Percentage_FCFS 1
bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_bf_${DATE}_${PROPORTION} Percentage_FCFS_BF 1

DATE="2022-01-21->2022-01-21"
PROPORTION="V10000"
bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Backfill 0
python3 src/compute_percentage_reduction.py data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv ${DATE}_${PROPORTION}
bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_${DATE}_${PROPORTION} Percentage_FCFS 1
bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_bf_${DATE}_${PROPORTION} Percentage_FCFS_BF 1

DATE="2022-01-28->2022-01-28"
PROPORTION="V10000"
bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Backfill 0
python3 src/compute_percentage_reduction.py data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv ${DATE}_${PROPORTION}
bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_${DATE}_${PROPORTION} Percentage_FCFS 1
bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_bf_${DATE}_${PROPORTION} Percentage_FCFS_BF 1

DATE="2022-02-01->2022-02-01"
PROPORTION="V10000"
bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Backfill 0
python3 src/compute_percentage_reduction.py data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv ${DATE}_${PROPORTION}
bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_${DATE}_${PROPORTION} Percentage_FCFS 1
bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_bf_${DATE}_${PROPORTION} Percentage_FCFS_BF 1

DATE="2022-02-02->2022-02-03"
PROPORTION="V10000"
bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Backfill 0
python3 src/compute_percentage_reduction.py data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv ${DATE}_${PROPORTION}
bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_${DATE}_${PROPORTION} Percentage_FCFS 1
bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_bf_${DATE}_${PROPORTION} Percentage_FCFS_BF 1

DATE="2022-03-15->2022-03-16"
PROPORTION="V10000"
bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Backfill 0
python3 src/compute_percentage_reduction.py data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv ${DATE}_${PROPORTION}
bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_${DATE}_${PROPORTION} Percentage_FCFS 1
bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_bf_${DATE}_${PROPORTION} Percentage_FCFS_BF 1

DATE="2022-04-07->2022-04-09"
PROPORTION="V10000"
bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Backfill 0
python3 src/compute_percentage_reduction.py data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv ${DATE}_${PROPORTION}
bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_${DATE}_${PROPORTION} Percentage_FCFS 1
bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_bf_${DATE}_${PROPORTION} Percentage_FCFS_BF 1

DATE="2022-04-19->2022-04-19"
PROPORTION="V10000"
bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Backfill 0
python3 src/compute_percentage_reduction.py data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv ${DATE}_${PROPORTION}
bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_${DATE}_${PROPORTION} Percentage_FCFS 1
bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_bf_${DATE}_${PROPORTION} Percentage_FCFS_BF 1

DATE="2022-05-06->2022-05-06"
PROPORTION="V10000"
bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Backfill 0
python3 src/compute_percentage_reduction.py data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv ${DATE}_${PROPORTION}
bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_${DATE}_${PROPORTION} Percentage_FCFS 1
bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_bf_${DATE}_${PROPORTION} Percentage_FCFS_BF 1

DATE="2022-07-13->2022-07-13"
PROPORTION="V10000"
bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Backfill 0
python3 src/compute_percentage_reduction.py data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv ${DATE}_${PROPORTION}
bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_${DATE}_${PROPORTION} Percentage_FCFS 1
bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_bf_${DATE}_${PROPORTION} Percentage_FCFS_BF 1

DATE="2022-07-14->2022-07-14"
PROPORTION="V10000"
bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Backfill 0
python3 src/compute_percentage_reduction.py data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv ${DATE}_${PROPORTION}
bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_${DATE}_${PROPORTION} Percentage_FCFS 1
bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_bf_${DATE}_${PROPORTION} Percentage_FCFS_BF 1

DATE="2022-07-16->2022-07-16"
PROPORTION="V10000"
bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Backfill 0
python3 src/compute_percentage_reduction.py data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv ${DATE}_${PROPORTION}
bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_${DATE}_${PROPORTION} Percentage_FCFS 1
bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_bf_${DATE}_${PROPORTION} Percentage_FCFS_BF 1

DATE="2022-07-17->2022-07-17"
PROPORTION="V10000"
bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Backfill 0
python3 src/compute_percentage_reduction.py data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv ${DATE}_${PROPORTION}
bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_${DATE}_${PROPORTION} Percentage_FCFS 1
bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_bf_${DATE}_${PROPORTION} Percentage_FCFS_BF 1

DATE="2022-07-18->2022-07-18"
PROPORTION="V10000"
bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Backfill 0
python3 src/compute_percentage_reduction.py data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv ${DATE}_${PROPORTION}
bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_${DATE}_${PROPORTION} Percentage_FCFS 1
bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_bf_${DATE}_${PROPORTION} Percentage_FCFS_BF 1

DATE="2022-08-16->2022-08-16"
PROPORTION="V10000"
bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Backfill 0
python3 src/compute_percentage_reduction.py data/Results_FCFS_Score_Backfill_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv ${DATE}_${PROPORTION}
bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_${DATE}_${PROPORTION} Percentage_FCFS 1
bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_bf_${DATE}_${PROPORTION} Percentage_FCFS_BF 1


# NEW 15
# All sans bf
python3 src/compute_percentages_all_workloads.py 15 0 mean data/Percentages_to_fcfs_2022-01-17-\>2022-01-17_V10000 data/Percentages_to_fcfs_2022-01-21-\>2022-01-21_V10000 data/Percentages_to_fcfs_2022-02-01-\>2022-02-01_V10000 data/Percentages_to_fcfs_2022-02-02-\>2022-02-03_V10000 data/Percentages_to_fcfs_2022-03-15-\>2022-03-16_V10000 data/Percentages_to_fcfs_2022-04-07-\>2022-04-09_V10000 data/Percentages_to_fcfs_2022-04-19-\>2022-04-19_V10000 data/Percentages_to_fcfs_2022-08-16-\>2022-08-16_V10000 data/Percentages_to_fcfs_2022-01-28-\>2022-01-28_V10000 data/Percentages_to_fcfs_2022-05-06-\>2022-05-06_V10000 data/Percentages_to_fcfs_2022-07-13-\>2022-07-13_V10000 data/Percentages_to_fcfs_2022-07-16-\>2022-07-16_V10000 data/Percentages_to_fcfs_2022-07-17-\>2022-07-17_V10000 data/Percentages_to_fcfs_2022-07-18-\>2022-07-18_V10000 data/Percentages_to_fcfs_2022-07-14-\>2022-07-14_V10000
bash plot.sh inputs/workloads/converted/All_workloads_mean inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_all_workloads_mean Percentage_FCFS 1
python3 src/compute_percentages_all_workloads.py 15 0 mediane data/Percentages_to_fcfs_2022-01-17-\>2022-01-17_V10000 data/Percentages_to_fcfs_2022-01-21-\>2022-01-21_V10000 data/Percentages_to_fcfs_2022-02-01-\>2022-02-01_V10000 data/Percentages_to_fcfs_2022-02-02-\>2022-02-03_V10000 data/Percentages_to_fcfs_2022-03-15-\>2022-03-16_V10000 data/Percentages_to_fcfs_2022-04-07-\>2022-04-09_V10000 data/Percentages_to_fcfs_2022-04-19-\>2022-04-19_V10000 data/Percentages_to_fcfs_2022-08-16-\>2022-08-16_V10000 data/Percentages_to_fcfs_2022-01-28-\>2022-01-28_V10000 data/Percentages_to_fcfs_2022-05-06-\>2022-05-06_V10000 data/Percentages_to_fcfs_2022-07-13-\>2022-07-13_V10000 data/Percentages_to_fcfs_2022-07-16-\>2022-07-16_V10000 data/Percentages_to_fcfs_2022-07-17-\>2022-07-17_V10000 data/Percentages_to_fcfs_2022-07-18-\>2022-07-18_V10000 data/Percentages_to_fcfs_2022-07-14-\>2022-07-14_V10000
bash plot.sh inputs/workloads/converted/All_workloads_mediane inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_all_workloads_mediane Percentage_FCFS 1
# All avec bf
python3 src/compute_percentages_all_workloads.py 15 1 mean data/Percentages_to_fcfs_bf_2022-01-17-\>2022-01-17_V10000 data/Percentages_to_fcfs_bf_2022-01-21-\>2022-01-21_V10000 data/Percentages_to_fcfs_bf_2022-02-01-\>2022-02-01_V10000 data/Percentages_to_fcfs_bf_2022-02-02-\>2022-02-03_V10000 data/Percentages_to_fcfs_bf_2022-03-15-\>2022-03-16_V10000 data/Percentages_to_fcfs_bf_2022-04-07-\>2022-04-09_V10000 data/Percentages_to_fcfs_bf_2022-04-19-\>2022-04-19_V10000 data/Percentages_to_fcfs_bf_2022-08-16-\>2022-08-16_V10000 data/Percentages_to_fcfs_bf_2022-01-28-\>2022-01-28_V10000 data/Percentages_to_fcfs_bf_2022-05-06-\>2022-05-06_V10000 data/Percentages_to_fcfs_bf_2022-07-13-\>2022-07-13_V10000 data/Percentages_to_fcfs_bf_2022-07-16-\>2022-07-16_V10000 data/Percentages_to_fcfs_bf_2022-07-17-\>2022-07-17_V10000 data/Percentages_to_fcfs_bf_2022-07-18-\>2022-07-18_V10000 data/Percentages_to_fcfs_bf_2022-07-14-\>2022-07-14_V10000
bash plot.sh inputs/workloads/converted/All_workloads_mean inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_bf_all_workloads_mean Percentage_FCFS_BF 2
python3 src/compute_percentages_all_workloads.py 15 1 mediane data/Percentages_to_fcfs_bf_2022-01-17-\>2022-01-17_V10000 data/Percentages_to_fcfs_bf_2022-01-21-\>2022-01-21_V10000 data/Percentages_to_fcfs_bf_2022-02-01-\>2022-02-01_V10000 data/Percentages_to_fcfs_bf_2022-02-02-\>2022-02-03_V10000 data/Percentages_to_fcfs_bf_2022-03-15-\>2022-03-16_V10000 data/Percentages_to_fcfs_bf_2022-04-07-\>2022-04-09_V10000 data/Percentages_to_fcfs_bf_2022-04-19-\>2022-04-19_V10000 data/Percentages_to_fcfs_bf_2022-08-16-\>2022-08-16_V10000 data/Percentages_to_fcfs_bf_2022-01-28-\>2022-01-28_V10000 data/Percentages_to_fcfs_bf_2022-05-06-\>2022-05-06_V10000 data/Percentages_to_fcfs_bf_2022-07-13-\>2022-07-13_V10000 data/Percentages_to_fcfs_bf_2022-07-16-\>2022-07-16_V10000 data/Percentages_to_fcfs_bf_2022-07-17-\>2022-07-17_V10000 data/Percentages_to_fcfs_bf_2022-07-18-\>2022-07-18_V10000 data/Percentages_to_fcfs_bf_2022-07-14-\>2022-07-14_V10000
bash plot.sh inputs/workloads/converted/All_workloads_mediane inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Percentages_to_fcfs_bf_all_workloads_mediane Percentage_FCFS_BF 2

#~ # Best TH
#~ PROPORTION="V10000"
#~ DATE="2022-07-16->2022-07-16"
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Threshold_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Threshold 0
#~ DATE="2022-07-13->2022-07-13"
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Threshold_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Threshold 0
#~ DATE="2022-07-18->2022-07-18"
#~ bash plot.sh inputs/workloads/converted/${DATE}_${PROPORTION} inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Threshold_${DATE}_${PROPORTION}_450_128_32_256_4_1024.csv FCFS_Score_Threshold 0
