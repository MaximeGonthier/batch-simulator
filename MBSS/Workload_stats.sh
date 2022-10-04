#!/bin/bash
# Generate the distribution of delay, submission time and core needed from real data
# bash Workload_stats.sh mois annee

MOIS=$1
ANNEE=$2

# Get job history
if [ $MOIS == "Janvier" ]
	then
	id_mois="01"
fi
if [ $MOIS == "Février" ]
	then
	id_mois="02"
fi
if [ $MOIS == "Mars" ]
	then
	id_mois="03"
fi
if [ $MOIS == "Avril" ]
	then
	id_mois="04"
fi
if [ $MOIS == "Mai" ]
	then
	id_mois="05"
fi
if [ $MOIS == "Juin" ]
	then
	id_mois="06"
fi
if [ $MOIS == "Juillet" ]
	then
	id_mois="07"
fi
if [ $MOIS == "Aout" ]
	then
	id_mois="08"
fi
if [ $MOIS == "Septembre" ]
	then
	id_mois="09"
fi
if [ $MOIS == "Octobre" ]
	then
	id_mois="10"
fi
if [ $MOIS == "Novembre" ]
	then
	id_mois="11"
fi
if [ $MOIS == "Décembre" ]
	then
	id_mois="12"
fi
echo "$MOIS"
if [ $MOIS=="Janvier" ] || [ $MOIS == "Mars" ] || [ $MOIS == "Mai" ] || [ $MOIS == "Juillet" ] || [ $MOIS == "Aout" ] || [ $MOIS == "Octobre" ] || [ $MOIS == "Décembre" ]
#~ if [ $MOIS=="Mars" ] || [ $MOIS=="Décembre" ] # Décembre a que 30 jours en fait personne travaille le 31
	then
	echo "31 jours"
	for ((i = 1 ; i <= 9 ; i++))
		do
		string+=${ANNEE}"-"${id_mois}"-0"${i},
	done
	for ((i = 0 ; i <= 9 ; i++))
		do
		string+=${ANNEE}"-"${id_mois}"-1"${i},
	done
	for ((i = 0 ; i <= 9 ; i++))
		do
		string+=${ANNEE}"-"${id_mois}"-2"${i},
	done
	string+=${ANNEE}"-"${id_mois}"-30,${ANNEE}-"${id_mois}"-31"
	last_day=31
elif [[ $MOIS == "Avril" || $MOIS == "Juin" || $MOIS == "Septembre" || $MOIS == "Novembre" ]]
	then
	cho "30 jours"
	for ((i = 1 ; i <= 9 ; i++))
		do
		string+=${ANNEE}"-"${id_mois}"-0"${i},
	done
	for ((i = 0 ; i <= 9 ; i++))
		do
		string+=${ANNEE}"-"${id_mois}"-1"${i},
	done
	for ((i = 0 ; i <= 9 ; i++))
		do
		string+=${ANNEE}"-"${id_mois}"-2"${i},
	done
	string+=${ANNEE}"-"${id_mois}"-30"
	last_day=30
elif [ $MOIS == "Février" ]
	then
	cho "28 jours"
	for ((i = 1 ; i <= 9 ; i++))
		do
		string+=${ANNEE}"-02-0"${i},
	done
	for ((i = 0 ; i <= 9 ; i++))
		do
		string+=${ANNEE}"-02-1"${i},
	done
	for ((i = 0 ; i <= 7 ; i++))
		do
		string+=${ANNEE}"-02-2"${i},
	done
	string+=${ANNEE}"-02-28"
	last_day=28
fi
echo ${string}
scp maxim@rackham.uppmax.uu.se:../../../sw/share/slurm/rackham/accounting/\{${string}\} /home/gonthier/data-aware-batch-scheduling/MBSS/inputs/workloads/raw/

python3 src/convert_stats_workload.py ${id_mois} ${ANNEE} ${last_day}
python3 src/plot_stats_workload.py ${ANNEE}_${id_mois} cores
python3 src/plot_stats_workload.py ${ANNEE}_${id_mois} walltime
python3 src/plot_stats_workload.py ${ANNEE}_${id_mois} delay
