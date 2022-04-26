#!/bin/bash
# bash Generate_cluster.sh Nb_nodes_128 Nb_nodes_256 Nb_nodes_1024 BW Cores

TOTAL_NUMBER_NODE=$(($1+$2+$3))

truncate -s 0 inputs/clusters/rackham_$1_128_$2_256_$3_1024.txt

for ((i=0 ; i<$1; i++)) do
	echo "{ id: $i memory: 128 bandwidth: $4 core: $5 }" >> inputs/clusters/rackham_$1_128_$2_256_$3_1024.txt
done
for ((i=$1 ; i<$(($1+$2)); i++)) do
	echo "{ id: $i memory: 256 bandwidth: $4 core: $5 }" >> inputs/clusters/rackham_$1_128_$2_256_$3_1024.txt
done
for ((i=$1+$2 ; i<$(($1+$2+$3)); i++)) do
	echo "{ id: $i memory: 1024 bandwidth: $4 core: $5 }" >> inputs/clusters/rackham_$1_128_$2_256_$3_1024.txt
done
