#!/bin/bash
# Merge consecutive files and do a workload that my simulator can read
# bash Generate_reduced_workload_from_rackham.sh start daytoevaluate1 daytoevaluate2 ... daytoevaluaten end day+1 ... day+n collection day+n+1 day+n+2 ... day+n+m

echo "Merging input files..."
echo "There are $(($#-3)) input files"

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
	if [ ${@:$i:1} == "collection" ]
	then
		collection=$((i-1))
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
	#~ if [ $((i)) == 1 ]
	#~ then
		#~ head -1 ${@:$i:1} > outputs/start_end_date_evaluated_jobs.txt
		#~ tail -1 ${@:$i:1} >> outputs/start_end_date_evaluated_jobs.txt
	#~ fi
	
	# Day 1
	if [ $((i)) == $((start)) ]
	then
		head -1 ${@:$i:1} > outputs/start_end_date_evaluated_jobs.txt
		sed -n '2 p' ${@:$i:1} >> outputs/start_end_date_evaluated_jobs.txt
		sed -n '4 p' ${@:$i:1} >> outputs/start_end_date_evaluated_jobs.txt
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
	
	# Day just for job collection afterward
	if [ $((i)) == $((collection)) ]
	then
		tail -1 ${@:$i:1} >> outputs/start_end_date_evaluated_jobs.txt
	fi
	
	if [ ${@:$i:1} != "start" ]
	then
		if [ ${@:$i:1} != "end" ]
		then
			if [ ${@:$i:1} != "collection" ]
			then
				echo "Adding" ${@:$i:1}
				cat ${@:$i:1} >> $OUTPUT
			fi
		fi
	fi
done

echo "Start and end times"
cat outputs/start_end_date_evaluated_jobs.txt

#~ VARIANCE=10000
#~ VARIANCE=85105
#~ VARIANCE=9532
#~ VARIANCE=9271

echo "Converting job history..."
# python3 src/generate_workload_from_rackham.py $START"->"$END 256jobs 1024jobs dataonalljobs? variance?
#~ if [ $((VARIANCE)) == 10000 ]
#~ then
VARIANCE=10000
python3 src/generate_workload_from_rackham.py $START"->"$END 0 0 1 $((VARIANCE))
#~ elif [ $((VARIANCE)) == 85105 ]
#~ then
VARIANCE=85105
python3 src/generate_workload_from_rackham.py $START"->"$END 10 5 1 $((VARIANCE))
#~ elif [ $((VARIANCE)) == 9532 ]
#~ then
VARIANCE=9532
python3 src/generate_workload_from_rackham.py $START"->"$END 3 2 1 $((VARIANCE))
#~ elif [ $((VARIANCE)) == 9271 ]
#~ then
VARIANCE=9271
python3 src/generate_workload_from_rackham.py $START"->"$END 7 1 1 $((VARIANCE))
#~ else
	#~ echo "Taille pas pris en compte"
#~ fi
echo "Conversion done!"

echo "Plotting stats on the workload..."
#~ python3 src/plot_stats_one_converted_workload.py $START"->"$END
#~ python3 src/plot_stats_one_converted_workload.py $START"->"$END"_V"$((VARIANCE))
echo "Plotting stats done!"
