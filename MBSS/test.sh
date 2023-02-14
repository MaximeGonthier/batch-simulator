#!/bin/bash
start=`date +%s`

WORKLOAD=$1
CLUSTER=inputs/clusters/rackham_450_128_32_256_4_1024.txt
CONTRAINTES_TAILLES=0
BUSY_CLUSTER_THRESHOLD=80
OUTPUT_FILE=outputs/test.csv

make -C C/

#~ SCHEDULER="Fcfs_with_a_score_x500_x1_x0_x0"; BACKFILL_MODE=0
SCHEDULER="Fcfs_with_a_score_conservativebf_x500_x1_x0_x0"; BACKFILL_MODE=2
	
./C/main $WORKLOAD $CLUSTER $SCHEDULER $CONTRAINTES_TAILLES $OUTPUT_FILE $BACKFILL_MODE $BUSY_CLUSTER_THRESHOLD

end=`date +%s` 
runtime=$((end-start))
echo "Execution complete! It lasted" $((runtime/60))" minute(s) and "$((runtime%60))" second(s)"

# 07-16 
# LEA (FCFS a 0.99)
# 2 minute(s) and 55 second(s) -> 0 minute(s) and 17 second(s)
# 1.298620 -> 0.995980 (0.995090 et 0 minute(s) and 18 second(s) avec 1h)
# LEA-BF
# 3 minute(s) and 44 second(s) -> 0 minute(s) and 19 second(s)
# 1.291280 -> 0.998301 (0.991990 et 0 minute(s) and 18 second(s) avec 1h)

# 09-09 
# LEA (FCFS a 1.69)
# 3 minute(s) and 41 second(s) -> 0 minute(s) and 52 second(s)
# 2.022777 -> 1.708952 (1.636232 et 0 minute(s) and 36 second(s) avec 1h)
# LEA-BF
# 5 minute(s) and 24 second(s) -> 1 minute(s) and 3 second(s)
# 2.008631 -> 1.705071 (1.627036 et 0 minute(s) and 38 second(s) avec 1h)

# 03-26 
# LEA (FCFS a 2.79)
# 48 minutes -> 3 minute(s) and 21 second(s)
# 1.96 -> 2.796220 (2.749011 et 1 minute(s) and 40 second(s) avec 1h)
# LEA-BF
# bcp -> 3 minute(s) and 23 second(s)
# 2 -> 2.846290 (2.786406 et 2 minute(s) and 1 second(s) avec 1h)

# 08-16 
# LEA (FCFS a 135)
# 97 minutes -> 7 minute(s) and 7 second(s)
# 2.89 -> 100.772736 (82.939766 et 5 minute(s) and 26 second(s) avec 1h)
# LEA-BF
# bcp -> 5 minute(s) and 47 second(s)
# 5 -> 103.341209 (81.365906 et 7 minute(s) and 20 second(s) avec 1h)
