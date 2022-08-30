# bash Start_all_workload_repartition.sh WORKLOAD CLUSTER

# Get arguments
#~ WORKLOAD=$1
#~ WORKLOAD_TP=${WORKLOAD:27}
#~ CLUSTER=$2
#~ CLUSTER_TP=${CLUSTER:24}
#~ CLUSTER_TP=${CLUSTER_TP::-4}

bash Compare_Size_Constraint.sh inputs/workloads/converted/2022-01-17->2022-01-17_V10000 inputs/clusters/rackham_450_128_32_256_4_1024.txt
bash Compare_Size_Constraint.sh inputs/workloads/converted/2022-01-17->2022-01-17_V85105 inputs/clusters/rackham_450_128_32_256_4_1024.txt
bash Compare_Size_Constraint.sh inputs/workloads/converted/2022-01-17->2022-01-17_V9532 inputs/clusters/rackham_450_128_32_256_4_1024.txt
bash Compare_Size_Constraint.sh inputs/workloads/converted/2022-01-17->2022-01-17_V9271 inputs/clusters/rackham_450_128_32_256_4_1024.txt
