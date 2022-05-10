#!/bin/bash
# Merge consecutive files and do a workload that my simulator can read
# bash Generate_workload_from_rackham.sh input_files

# Get job history
#~ echo "Downloading job history of" $1 "..."
#~ scp maxim@rackham.uppmax.uu.se:../../../sw/share/slurm/rackham/accounting/$1 /home/gonthier/data-aware-batch-scheduling/MBSS/inputs/workloads/raw/$1
#~ echo "Download done! Here are the first few lines of the raw workload" $1
#~ head -5 inputs/workloads/raw/$1

# Convert file into readable information and add input data
echo "Merging input files..."
echo "There are $# input files"
FILE_START=$1
FILE_END=${@: -1}
START=${FILE_START:21}
END=${FILE_END:21}
OUTPUT="inputs/workloads/raw/"$START"->"$END
echo "Output will be" $OUTPUT
truncate -s 0 $OUTPUT
for ((i=1; i<=$#; i++))
do
	echo "Adding" ${@:$i:1}
	cat ${@:i:i} >> $OUTPUT
done

echo "Converting job history..."
python3 src/generate_workload_from_rackham.py $START"->"$END 10 10
echo "Conversion done!"
