#!/bin/bash
# Merge consecutive files and do a workload that my simulator can read
# bash Generate_workload_from_rackham.sh day0 start daytoevaluate1 daytoevaluate2 ... daytoevaluaten end day+1 ... day+n

# Convert file into readable information and add input data
#~ if [ $(($#)) < 8 ]
#~ then
	#~ exit
#~ fi
echo "Merging input files..."
echo "There are $(($#-2)) input files"

#~ $((i))=1
#~ while ((${i} != "z"))
#~ do
	#~ $((i))=$((2))
#~ done
#~ i=i-1
#~ FILE_START=$i

#~ i=i+2
#~ while (($i != "/"))
#~ do
	#~ i=i+1
#~ done
#~ i=i-1
#~ FILE_END=$i

for ((i=1; i<=$#; i++))
do
	if [ ${@:$i:1} == "start" ]
	then
		start=$((i+1))
		FILE_START=${@:$start:1}
	fi
	if [ ${@:$i:1} == "end" ]
	then
		end=$((i-1))
		FILE_END=${@:$end:1}
	fi
done
#~ echo $start
#~ FILE_START=$2
#~ # N=$(($#))
#~ FILE_END=$2
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
	if [ $((i)) == $((start)) ]
	then
		head -1 ${@:$i:1} >> outputs/start_end_date_evaluated_jobs.txt
	fi
	if [ $((i)) == $((end)) ]
	then
		tail -1 ${@:$i:1} >> outputs/start_end_date_evaluated_jobs.txt
	fi
	
	# Day 2 and beyond
	if [ $((i)) == $((end+2)) ]
	then
		head -1 ${@:$i:1} >> outputs/start_end_date_evaluated_jobs.txt
	fi
	
	if [ ${@:$i:1} != "start" ]
	then
		if [ ${@:$i:1} != "end" ]
		then
			echo "Adding" ${@:$i:1}
			#~ cat ${@:i:i} >> $OUTPUT
			cat ${@:$i:1} >> $OUTPUT
		fi
	fi
done
#~ exit
echo "Converting job history..."
# python3 src/generate_workload_from_rackham.py $START"->"$END 256jobs 1024jobs dataonalljobs? 1storsecondversion(the one with -2 jobs started from history)?
python3 src/generate_workload_from_rackham.py $START"->"$END 10 5 1 2
echo "Conversion done!"
