#~ bash plot.sh inputs/workloads/converted/2022-01-17-\>2022-01-17_V9271 inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Adaptative_Multiplier_2022-01-17-\>2022-01-17_V9271_450_128_32_256_4_1024.csv FCFS_Score_Adaptative_Multiplier
#~ bash plot.sh inputs/workloads/converted/2022-01-21-\>2022-01-21_V9271 inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Adaptative_Multiplier_2022-01-21-\>2022-01-21_V9271_450_128_32_256_4_1024.csv FCFS_Score_Adaptative_Multiplier
#~ bash plot.sh inputs/workloads/converted/2022-02-02-\>2022-02-03_V9271 inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Adaptative_Multiplier_2022-02-02-\>2022-02-03_V9271_450_128_32_256_4_1024.csv FCFS_Score_Adaptative_Multiplier
#~ bash plot.sh inputs/workloads/converted/2022-04-07-\>2022-04-09_V9271 inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Adaptative_Multiplier_2022-04-07-\>2022-04-09_V9271_450_128_32_256_4_1024.csv FCFS_Score_Adaptative_Multiplier
#~ bash plot.sh inputs/workloads/converted/2022-05-21-\>2022-05-22_V9271 inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Adaptative_Multiplier_2022-05-21-\>2022-05-22_V9271_450_128_32_256_4_1024.csv FCFS_Score_Adaptative_Multiplier
#~ bash plot.sh inputs/workloads/converted/2022-06-12-\>2022-06-13_V9271 inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Adaptative_Multiplier_2022-06-12-\>2022-06-13_V9271_450_128_32_256_4_1024.csv FCFS_Score_Adaptative_Multiplier
#~ bash plot.sh inputs/workloads/converted/2022-07-17-\>2022-07-18_V9271 inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Adaptative_Multiplier_2022-07-17-\>2022-07-18_V9271_450_128_32_256_4_1024.csv FCFS_Score_Adaptative_Multiplier
#~ bash plot.sh inputs/workloads/converted/2022-08-16-\>2022-08-16_V9271 inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Adaptative_Multiplier_2022-08-16-\>2022-08-16_V9271_450_128_32_256_4_1024.csv FCFS_Score_Adaptative_Multiplier
#~ bash plot.sh inputs/workloads/converted/2022-09-08-\>2022-09-08_V9271 inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Adaptative_Multiplier_2022-09-08-\>2022-09-08_V9271_450_128_32_256_4_1024.csv FCFS_Score_Adaptative_Multiplier

# Conservative bf
bash plot.sh inputs/workloads/converted/2022-01-17-\>2022-01-17_V9271 inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_2022-01-17-\>2022-01-17_V9271_450_128_32_256_4_1024.csv FCFS_Score_Backfill
bash plot.sh inputs/workloads/converted/2022-01-21-\>2022-01-21_V9271 inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_2022-01-21-\>2022-01-21_V9271_450_128_32_256_4_1024.csv FCFS_Score_Backfill
#~ bash plot.sh inputs/workloads/converted/2022-04-07-\>2022-04-09_V9271 inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Backfill_2022-04-07-\>2022-04-09_V9271_450_128_32_256_4_1024.csv FCFS_Score_Backfill

# Data persistence
#~ bash plot.sh inputs/workloads/converted/2022-01-17-\>2022-01-17_V9271 inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_Data_Persistence_2022-01-17-\>2022-01-17_V9271_450_128_32_256_4_1024.csv Data_Persistence
#~ bash plot.sh inputs/workloads/converted/2022-01-21-\>2022-01-21_V9271 inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_Data_Persistence_2022-01-21-\>2022-01-21_V9271_450_128_32_256_4_1024.csv Data_Persistence

#Easy bf
bash plot.sh inputs/workloads/converted/2022-01-17-\>2022-01-17_V9271 inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Easy_Backfill_2022-01-17-\>2022-01-17_V9271_450_128_32_256_4_1024.csv FCFS_Score_Easy_Backfill
bash plot.sh inputs/workloads/converted/2022-01-21-\>2022-01-21_V9271 inputs/clusters/rackham_450_128_32_256_4_1024.txt data/Results_FCFS_Score_Easy_Backfill_2022-01-21-\>2022-01-21_V9271_450_128_32_256_4_1024.csv FCFS_Score_Easy_Backfill

make -C ../
