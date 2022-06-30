#!/bin/bash
# Merge consecutive files and do a workload that my simulator can read
# bash Generate_workload_from_rackham.sh day-1 daytoevaluate day+1 ... day+n

# Convert file into readable information and add input data
#~ if [ $(($#)) < 8 ]
#~ then
	#~ exit
#~ fi
echo "Merging input files..."
echo "There are $# input files"
FILE_START=$2
#~ N=$(($#))
FILE_END=$2
START=${FILE_START:21}
END=${FILE_END:21}
OUTPUT="inputs/workloads/raw/"$START"->"$END
echo "Output will be" $OUTPUT
truncate -s 0 $OUTPUT
for ((i=1; i<=$#; i++))
do
	# Day 0
	if [ $((i)) == 1 ]
	then
		head -1 ${@:$i:1} > outputs/start_end_date_evaluated_jobs.txt
		tail -1 ${@:$i:1} >> outputs/start_end_date_evaluated_jobs.txt
	fi
	# Day 1
	if [ $((i)) == 2 ]
	then
		head -1 ${@:$i:1} >> outputs/start_end_date_evaluated_jobs.txt
		tail -1 ${@:$i:1} >> outputs/start_end_date_evaluated_jobs.txt
	fi
	# Day 2 and beyond
	if [ $((i)) == 3 ]
	then
		head -1 ${@:$i:1} >> outputs/start_end_date_evaluated_jobs.txt
	fi
	echo "Adding" ${@:$i:1}
	cat ${@:i:i} >> $OUTPUT
done

echo "Converting job history..."
# python3 src/generate_workload_from_rackham.py $START"->"$END 256jobs 1024jobs dataonalljobs? 1storsecondversion(the one with -2 jobs started from history)?
python3 src/generate_workload_from_rackham.py $START"->"$END 10 5 1 2
echo "Conversion done!"
