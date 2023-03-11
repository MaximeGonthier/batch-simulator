#!/bin/bash

# bash srun_from_date.sh 24:00:00 01-01

# srun -t 30:00:00 ./C/main inputs/workloads/converted/2022-01-31-\>2022-01-31_V10000_anonymous inputs/clusters/rackham_450_128_32_256_4_1024.txt Fcfs_with_a_score_conservativebf_x500_x1_x0_x0 0 data/Results_FCFS_Score_Backfill_2022-01-31-\>2022-01-31_V10000_anonymous_rackham_450_128_32_256_4_1024_Fcfs_with_a_score_conservativebf_x500_x1_x0_x0.csv 2 80 > 01-31_Fcfs_with_a_score_conservativebf_x500_x1_x0_x0.txt &

#~ srun -t 60:00:00 ./C/main inputs/workloads/converted/2022-02-20-\>2022-02-26_V10000_anonymous inputs/clusters/rackham_450_128_32_256_4_1024.txt Fcfs_with_a_score_mixed_strategy_x500_x1_x0_x0 0 data/Results_FCFS_Score_Backfill_2022-02-20-\>2022-02-26_V10000_anonymous_450_128_32_256_4_1024_Fcfs_with_a_score_mixed_strategy_x500_x1_x0_x0.csv 0 100 > 02-20_02-26_Fcfs_with_a_score_mixed_strategy_x500_x1_x0_x0.txt &

#~ srun -t 60:00:00 ./C/main inputs/workloads/converted/2022-02-27-\>2022-03-05_V10000_anonymous inputs/clusters/rackham_450_128_32_256_4_1024.txt Fcfs_with_a_score_mixed_strategy_x500_x1_x0_x0 0 data/Results_FCFS_Score_Backfill_2022-02-27-\>2022-03-05_V10000_anonymous_450_128_32_256_4_1024_Fcfs_with_a_score_mixed_strategy_x500_x1_x0_x0.csv 0 100 > 02-27_03-05_Fcfs_with_a_score_mixed_strategy_x500_x1_x0_x0.txt &

#~ if [ "$#" -ne 6 ]; then
    #~ echo "Usage is bash srun_from_date.sh WALLTIME date_debut date_fin mode(srun or local) compilation(normal ou opti t+1h) save_after_X_jobs(no_save or a number or resume)"
    #~ exit
#~ fi

# Get arguments
DATE1=$2
DATE2=$3
WALLTIME=$1
MODE=$4
COMPILATION=$5
SAVE=$6
WORKLOAD="inputs/workloads/converted/2022-${DATE1}-\\>2022-${DATE2}_V10000_anonymous"
WORKLOAD_TP=${WORKLOAD:27}
CLUSTER="inputs/clusters/rackham_450_128_32_256_4_1024.txt"
CLUSTER_TP=${CLUSTER:24}
CLUSTER_TP=${CLUSTER_TP::-4}
CONTRAINTES_TAILLES=0
BUSY_CLUSTER_THRESHOLD=100

if [ ${COMPILATION} == "nb_heure_max" ]; then
	make save -C C/ nb_heure_max
else
	make save -C C/
fi

if [ ${SAVE} == "no_save" ]; then
	SCHEDULER="Fcfs"; BACKFILL_MODE=0
	OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
	if [ ${MODE} == "srun" ]; then
		call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) > ${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	else
		call="./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) > outputs/${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	fi
	echo "call: ${call}"
	eval ${call}

	SCHEDULER="Fcfs_conservativebf"; BACKFILL_MODE=2
	OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
	if [ ${MODE} == "srun" ]; then
		call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) > ${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	else
		call="./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) > outputs/${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	fi
	echo "call: ${call}"
	eval ${call}

	SCHEDULER="Fcfs_with_a_score_x1_x0_x0_x0"; BACKFILL_MODE=0
	OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
	if [ ${MODE} == "srun" ]; then
		call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) > ${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	else
		call="./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) > outputs/${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	fi
	echo "call: ${call}"
	eval ${call}

	SCHEDULER="Fcfs_with_a_score_conservativebf_x1_x0_x0_x0"; BACKFILL_MODE=2
	OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
	if [ ${MODE} == "srun" ]; then
		call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) > ${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	else
		call="./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) > outputs/${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	fi
	echo "call: ${call}"
	eval ${call}

	SCHEDULER="Fcfs_with_a_score_x500_x1_x0_x0"; BACKFILL_MODE=0
	OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
	if [ ${MODE} == "srun" ]; then
		call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) > ${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	else
		call="./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) > outputs/${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	fi
	echo "call: ${call}"
	eval ${call}

	SCHEDULER="Fcfs_with_a_score_conservativebf_x500_x1_x0_x0"; BACKFILL_MODE=2
	OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
	if [ ${MODE} == "srun" ]; then
		call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) > ${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	else
		call="./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) > outputs/${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	fi
	echo "call: ${call}"
	eval ${call}

	SCHEDULER="Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_x500_x1_x0_x0"; BACKFILL_MODE=0
	OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
	if [ ${MODE} == "srun" ]; then
		call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) > ${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	else
		call="./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) > outputs/${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	fi
	echo "call: ${call}"
	eval ${call}

	SCHEDULER="Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_conservativebf_x500_x1_x0_x0"; BACKFILL_MODE=2
	OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
	if [ ${MODE} == "srun" ]; then
		call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) > ${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	else
		call="./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) > outputs/${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	fi
	echo "call: ${call}"
	eval ${call}

	SCHEDULER="Fcfs_with_a_score_mixed_strategy_x500_x1_x0_x0"; BACKFILL_MODE=0
	OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
	if [ ${MODE} == "srun" ]; then
		call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) > ${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	else
		call="./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) > outputs/${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	fi
	echo "call: ${call}"
	eval ${call}

	SCHEDULER="Fcfs_with_a_score_mixed_strategy_conservativebf_x500_x1_x0_x0"; BACKFILL_MODE=2
	OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
	if [ ${MODE} == "srun" ]; then
		call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) > ${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	else
		call="./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) > outputs/${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	fi
	echo "call: ${call}"
	eval ${call}
elif [ ${SAVE} == "resume" ]; then # Resume
	SCHEDULER="Fcfs"; BACKFILL_MODE=0
	OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
	if [ ${MODE} == "srun" ]; then
		call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) resume > ${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	else
		call="./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) resume > outputs/${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	fi
	echo "call: ${call}"
	eval ${call}

	SCHEDULER="Fcfs_conservativebf"; BACKFILL_MODE=2
	OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
	if [ ${MODE} == "srun" ]; then
		call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) resume > ${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	else
		call="./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) resume > outputs/${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	fi
	echo "call: ${call}"
	eval ${call}

	SCHEDULER="Fcfs_with_a_score_x1_x0_x0_x0"; BACKFILL_MODE=0
	OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
	if [ ${MODE} == "srun" ]; then
		call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) resume > ${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	else
		call="./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) resume > outputs/${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	fi
	echo "call: ${call}"
	eval ${call}

	SCHEDULER="Fcfs_with_a_score_conservativebf_x1_x0_x0_x0"; BACKFILL_MODE=2
	OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
	if [ ${MODE} == "srun" ]; then
		call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) resume > ${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	else
		call="./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) resume > outputs/${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	fi
	echo "call: ${call}"
	eval ${call}

	SCHEDULER="Fcfs_with_a_score_x500_x1_x0_x0"; BACKFILL_MODE=0
	OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
	if [ ${MODE} == "srun" ]; then
		call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) resume > ${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	else
		call="./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) resume > outputs/${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	fi
	echo "call: ${call}"
	eval ${call}

	SCHEDULER="Fcfs_with_a_score_conservativebf_x500_x1_x0_x0"; BACKFILL_MODE=2
	OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
	if [ ${MODE} == "srun" ]; then
		call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) resume > ${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	else
		call="./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) resume > outputs/${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	fi
	echo "call: ${call}"
	eval ${call}

	SCHEDULER="Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_x500_x1_x0_x0"; BACKFILL_MODE=0
	OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
	if [ ${MODE} == "srun" ]; then
		call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) resume > ${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	else
		call="./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) resume > outputs/${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	fi
	echo "call: ${call}"
	eval ${call}

	SCHEDULER="Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_conservativebf_x500_x1_x0_x0"; BACKFILL_MODE=2
	OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
	if [ ${MODE} == "srun" ]; then
		call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) resume > ${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	else
		call="./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) resume > outputs/${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	fi
	echo "call: ${call}"
	eval ${call}

	SCHEDULER="Fcfs_with_a_score_mixed_strategy_x500_x1_x0_x0"; BACKFILL_MODE=0
	OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
	if [ ${MODE} == "srun" ]; then
		call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) resume > ${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	else
		call="./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) resume > outputs/${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	fi
	echo "call: ${call}"
	eval ${call}

	SCHEDULER="Fcfs_with_a_score_mixed_strategy_conservativebf_x500_x1_x0_x0"; BACKFILL_MODE=2
	OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
	if [ ${MODE} == "srun" ]; then
		call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) resume > ${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	else
		call="./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) resume > outputs/${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	fi
	echo "call: ${call}"
	eval ${call}
elif [ ${SAVE} == "save_and_resume" ]; then # Resume
	SAVE_TIME=$7
	SCHEDULER="Fcfs"; BACKFILL_MODE=0
	OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
	if [ ${MODE} == "srun" ]; then
		call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) save_and_resume $((SAVE_TIME)) > ${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	else
		call="./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) save_and_resume $((SAVE_TIME)) > outputs/${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	fi
	echo "call: ${call}"
	eval ${call}

	SCHEDULER="Fcfs_conservativebf"; BACKFILL_MODE=2
	OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
	if [ ${MODE} == "srun" ]; then
		call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) save_and_resume $((SAVE_TIME)) > ${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	else
		call="./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) save_and_resume $((SAVE_TIME)) > outputs/${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	fi
	echo "call: ${call}"
	eval ${call}

	SCHEDULER="Fcfs_with_a_score_x1_x0_x0_x0"; BACKFILL_MODE=0
	OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
	if [ ${MODE} == "srun" ]; then
		call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) save_and_resume $((SAVE_TIME)) > ${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	else
		call="./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) save_and_resume $((SAVE_TIME)) > outputs/${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	fi
	echo "call: ${call}"
	eval ${call}

	SCHEDULER="Fcfs_with_a_score_conservativebf_x1_x0_x0_x0"; BACKFILL_MODE=2
	OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
	if [ ${MODE} == "srun" ]; then
		call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) save_and_resume $((SAVE_TIME)) > ${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	else
		call="./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) save_and_resume $((SAVE_TIME)) > outputs/${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	fi
	echo "call: ${call}"
	eval ${call}

	SCHEDULER="Fcfs_with_a_score_x500_x1_x0_x0"; BACKFILL_MODE=0
	OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
	if [ ${MODE} == "srun" ]; then
		call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) save_and_resume $((SAVE_TIME)) > ${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	else
		call="./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) save_and_resume $((SAVE_TIME)) > outputs/${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	fi
	echo "call: ${call}"
	eval ${call}

	SCHEDULER="Fcfs_with_a_score_conservativebf_x500_x1_x0_x0"; BACKFILL_MODE=2
	OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
	if [ ${MODE} == "srun" ]; then
		call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) save_and_resume $((SAVE_TIME)) > ${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	else
		call="./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) save_and_resume $((SAVE_TIME)) > outputs/${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	fi
	echo "call: ${call}"
	eval ${call}

	SCHEDULER="Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_x500_x1_x0_x0"; BACKFILL_MODE=0
	OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
	if [ ${MODE} == "srun" ]; then
		call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) save_and_resume $((SAVE_TIME)) > ${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	else
		call="./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) save_and_resume $((SAVE_TIME)) > outputs/${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	fi
	echo "call: ${call}"
	eval ${call}

	SCHEDULER="Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_conservativebf_x500_x1_x0_x0"; BACKFILL_MODE=2
	OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
	if [ ${MODE} == "srun" ]; then
		call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) save_and_resume $((SAVE_TIME)) > ${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	else
		call="./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) save_and_resume $((SAVE_TIME)) > outputs/${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	fi
	echo "call: ${call}"
	eval ${call}

	SCHEDULER="Fcfs_with_a_score_mixed_strategy_x500_x1_x0_x0"; BACKFILL_MODE=0
	OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
	if [ ${MODE} == "srun" ]; then
		call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) save_and_resume $((SAVE_TIME)) > ${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	else
		call="./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) save_and_resume $((SAVE_TIME)) > outputs/${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	fi
	echo "call: ${call}"
	eval ${call}

	SCHEDULER="Fcfs_with_a_score_mixed_strategy_conservativebf_x500_x1_x0_x0"; BACKFILL_MODE=2
	OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
	if [ ${MODE} == "srun" ]; then
		call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) save_and_resume $((SAVE_TIME)) > ${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	else
		call="./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) save_and_resume $((SAVE_TIME)) > outputs/${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	fi
	echo "call: ${call}"
	eval ${call}
else # save has a number need to save
	SAVE_TIME=$7
	SCHEDULER="Fcfs"; BACKFILL_MODE=0
	OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
	if [ ${MODE} == "srun" ]; then
		call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) save $((SAVE_TIME)) > ${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	else
		call="./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) save $((SAVE_TIME)) > outputs/${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	fi
	echo "call: ${call}"
	eval ${call}

	SCHEDULER="Fcfs_conservativebf"; BACKFILL_MODE=2
	OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
	if [ ${MODE} == "srun" ]; then
		call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) save $((SAVE_TIME)) > ${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	else
		call="./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) save $((SAVE_TIME)) > outputs/${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	fi
	echo "call: ${call}"
	eval ${call}

	SCHEDULER="Fcfs_with_a_score_x1_x0_x0_x0"; BACKFILL_MODE=0
	OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
	if [ ${MODE} == "srun" ]; then
		call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) save $((SAVE_TIME)) > ${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	else
		call="./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) save $((SAVE_TIME)) > outputs/${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	fi
	echo "call: ${call}"
	eval ${call}

	SCHEDULER="Fcfs_with_a_score_conservativebf_x1_x0_x0_x0"; BACKFILL_MODE=2
	OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
	if [ ${MODE} == "srun" ]; then
		call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) save $((SAVE_TIME)) > ${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	else
		call="./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) save $((SAVE_TIME)) > outputs/${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	fi
	echo "call: ${call}"
	eval ${call}

	SCHEDULER="Fcfs_with_a_score_x500_x1_x0_x0"; BACKFILL_MODE=0
	OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
	if [ ${MODE} == "srun" ]; then
		call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) save $((SAVE_TIME)) > ${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	else
		call="./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) save $((SAVE_TIME)) > outputs/${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	fi
	echo "call: ${call}"
	eval ${call}

	SCHEDULER="Fcfs_with_a_score_conservativebf_x500_x1_x0_x0"; BACKFILL_MODE=2
	OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
	if [ ${MODE} == "srun" ]; then
		call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) save $((SAVE_TIME)) > ${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	else
		call="./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) save $((SAVE_TIME)) > outputs/${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	fi
	echo "call: ${call}"
	eval ${call}

	SCHEDULER="Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_x500_x1_x0_x0"; BACKFILL_MODE=0
	OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
	if [ ${MODE} == "srun" ]; then
		call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) save $((SAVE_TIME)) > ${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	else
		call="./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) save $((SAVE_TIME)) > outputs/${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	fi
	echo "call: ${call}"
	eval ${call}

	SCHEDULER="Fcfs_with_a_score_adaptative_multiplier_if_EAT_is_t_conservativebf_x500_x1_x0_x0"; BACKFILL_MODE=2
	OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
	if [ ${MODE} == "srun" ]; then
		call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) save $((SAVE_TIME)) > ${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	else
		call="./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) save $((SAVE_TIME)) > outputs/${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	fi
	echo "call: ${call}"
	eval ${call}

	SCHEDULER="Fcfs_with_a_score_mixed_strategy_x500_x1_x0_x0"; BACKFILL_MODE=0
	OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
	if [ ${MODE} == "srun" ]; then
		call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) save $((SAVE_TIME)) > ${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	else
		call="./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) save $((SAVE_TIME)) > outputs/${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	fi
	echo "call: ${call}"
	eval ${call}

	SCHEDULER="Fcfs_with_a_score_mixed_strategy_conservativebf_x500_x1_x0_x0"; BACKFILL_MODE=2
	OUTPUT_FILE=data/Results_FCFS_Score_Backfill_${WORKLOAD_TP}_${CLUSTER_TP}_${SCHEDULER}.csv
	if [ ${MODE} == "srun" ]; then
		call="srun -t ${WALLTIME} ./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) save $((SAVE_TIME)) > ${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	else
		call="./C/main ${WORKLOAD} ${CLUSTER} ${SCHEDULER} $((CONTRAINTES_TAILLES)) ${OUTPUT_FILE} $((BACKFILL_MODE)) $((BUSY_CLUSTER_THRESHOLD)) save $((SAVE_TIME)) > outputs/${DATE1}_${DATE2}_${SCHEDULER}.txt &"
	fi
	echo "call: ${call}"
	eval ${call}
fi
