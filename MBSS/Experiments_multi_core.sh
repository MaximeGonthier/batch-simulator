#!/bin/bash
# bash Experiments_multi_core.sh workload cluster scheduler PRINT?(1 for gantt chart, 2 for distrib of queue times)
start=`date +%s`

if [ "$#" -ne 5 ]; then
    echo "Usage is bash Experiments_multi_core.sh workload cluster scheduler PRINT? CONTRAINTE_TAILLES?"
    exit
fi

# Get arguments
WORKLOAD=$1
CLUSTER=$2
SCHEDULER=$3
PRINT=$4
CONTRAINTES_TAILLES=$5
DATE=${WORKLOAD:27:30}

if [ $PRINT == 1 ]; then
echo "job_id,workload_name,profile,submission_time,requested_number_of_resources,requested_time,success,final_state,starting_time,execution_time,finish_time,waiting_time,turnaround_time,stretch,allocated_resources,consumed_energy,metadata" > "outputs/Results_all_jobs_${SCHEDULER}.csv"
elif [ $PRINT == 2 ]; then
: > "outputs/Distribution_queue_times_${SCHEDULER}.txt"
fi

truncate -s 0 outputs/Results_${SCHEDULER}.csv

#~ make -C C/
#~ make print -C C/
# Running the simulation
#~ ./C/main $WORKLOAD $CLUSTER $SCHEDULER $CONTRAINTES_TAILLES
#~ libtool --mode=execute gdb --args ./C/main $WORKLOAD $CLUSTER $SCHEDULER $CONTRAINTES_TAILLES
#~ valgrind --leak-check=full \
         #~ --show-leak-kinds=all \
         #~ --track-origins=yes \
         #~ --verbose \
         #~ --log-file=valgrind-out.txt \
          #~ ./C/main $WORKLOAD $CLUSTER $SCHEDULER $CONTRAINTES_TAILLES 2>&1 | tee terminal_output.txt

#~ if [ $PRINT == 0 ]; then
	#~ make print -j8 -C C/
	#~ # ../../pypy3.9-v7.3.9-linux64/bin/pypy3 -O src/main_multi_core.py $WORKLOAD $CLUSTER $SCHEDULER $PRINT $CONTRAINTES_TAILLES
	#~ python3 -O src/main_multi_core.py $WORKLOAD $CLUSTER $SCHEDULER $PRINT $CONTRAINTES_TAILLES
	# make print -C C/
#~ if [ $PRINT == 1 ]; then
	# ../../pypy3.9-v7.3.9-linux64/bin/pypy3 src/main_multi_core.py $WORKLOAD $CLUSTER $SCHEDULER $PRINT $CONTRAINTES_TAILLES
	#~ python3 src/main_multi_core.py $WORKLOAD $CLUSTER $SCHEDULER $PRINT $CONTRAINTES_TAILLES
	#~ make -C C/
#~ elif [ $PRINT == 2 ]; then
	# ../../pypy3.9-v7.3.9-linux64/bin/pypy3 src/main_multi_core.py $WORKLOAD $CLUSTER $SCHEDULER $PRINT $CONTRAINTES_TAILLES
	#~ python3 src/main_multi_core.py $WORKLOAD $CLUSTER $SCHEDULER $PRINT $CONTRAINTES_TAILLES
	#~ make print_distribution_queue_times -C C/
#~ fi

#~ ./C/main $WORKLOAD $CLUSTER Fcfs $CONTRAINTES_TAILLES
#~ ./C/main $WORKLOAD $CLUSTER Fcfs_with_a_score_x0_x0_x0 $CONTRAINTES_TAILLES 2>&1 | tee terminal_output2.txt
make print_gantt_chart -C C/
./C/main $WORKLOAD $CLUSTER Fcfs $CONTRAINTES_TAILLES

#~ if [ $PRINT == 1 ]; then
echo "Launching gantt charts..." outputs/Results_all_jobs_${SCHEDULER}.csv
python3 ../Batsim/batsched-Maxime/gantt-chart-plot/main.py outputs/Results_all_jobs_${SCHEDULER}.csv ${SCHEDULER}
#~ fi
#~ if [ $PRINT == 2 ]; then
	#~ echo "Plotting distribution of queue times..."
	#~ python3 src/plot_distribution_queue_times.py outputs/Distribution_queue_times_${SCHEDULER}.txt $SCHEDULER $DATE
#~ fi

#~ echo "Results:"
#~ head outputs/Results_${SCHEDULER}.csv

end=`date +%s` 
runtime=$((end-start))
echo "Execution complete! It lasted" $((runtime/60))" minute(s) and "$((runtime%60))" second(s)."
