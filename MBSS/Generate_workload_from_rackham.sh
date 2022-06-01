#!/bin/bash
# Merge consecutive files and do a workload that my simulator can read
# bash Generate_workload_from_rackham.sh input_files1 input_files2 input_files3 etc...

# Convert file into readable information and add input data
echo "Merging input files..."
echo "There are $# input files"
FILE_START=$1
N=$(($#-7))
FILE_END=${!N}
START=${FILE_START:21}
END=${FILE_END:21}
OUTPUT="inputs/workloads/raw/"$START"->"$END
echo "Output will be" $OUTPUT
truncate -s 0 $OUTPUT
for ((i=1; i<=$#; i++))
do
	if [ $((i)) == 1 ]
	then
		head -1 ${@:$i:1} > outputs/start_end_date_evaluated_jobs.txt
	fi
	if [ $((i)) == $((N)) ]
	then
		tail -1 ${@:$i:1} >> outputs/start_end_date_evaluated_jobs.txt
	fi
	echo "Adding" ${@:$i:1}
	cat ${@:i:i} >> $OUTPUT
done

echo "Converting job history..."
# python3 src/generate_workload_from_rackham.py $START"->"$END 256jobs 1024jobs dataonalljobs?
python3 src/generate_workload_from_rackham.py $START"->"$END 10 5 1
echo "Conversion done!"
