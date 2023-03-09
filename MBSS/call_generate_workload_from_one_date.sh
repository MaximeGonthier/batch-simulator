#!/bin/bash

# bash call_generate_workload_from_one_date.sh date mode("jour" ou "semaine")

main_day=$1
mode=$2

echo "Evaluated day is ${main_day}"

#~ echo "Year is ${main_day::-6}"
year=${main_day::-6}
#~ echo "Month is ${main_day:5:-3}"
month=${main_day:5:-3}
#~ echo "Day is ${main_day:8}"
day=${main_day:8}

if [ ${day} = "01" ]; then
	if [ ${month} = "01" ] || [ ${month} = "02" ] || [ ${month} = "04" ] || [ ${month} = "06" ] || [ ${month} = "08" ] || [ ${month} = "09" ] || [ ${month} = "11" ]; then
		day0="31"
	elif [ ${month} = "03" ]; then
		day0="28"
	else
		day0="30"
	fi
	
	if [ ${month} = "01" ] && [ ${day} = "01" ]; then
		month0="12"
		year0="2021"
	else
		if [ ${day} = "01" ]; then
			month0=$((month-1))
		else
			month0=$((month))
		fi
		year0="2022"
	fi
			
	if [ $((month0)) -lt 10 ]; then
		month0="0"$((month0))
	fi
else
	if [ ${day} = "08" ]; then
		day0="07"
	elif [ ${day} = "09" ]; then
		day0="08"
	else
		day0=$((day-1))
		if [ $((day0)) -lt 10 ]; then
			day0="0"$((day0))
		fi
	fi
	month0=${month}
	year0="2022"
fi

echo "Day0 is ${day0}"
echo "Month0 is ${month0}"
echo "Year0 is ${year0}"

if [ model == "jour" ]; then
	call="Generate_workload_from_rackham.sh inputs/workloads/raw/${year0}-${month0}-${day0} start inputs/workloads/raw/${main_day} end inputs/workloads/raw/${year}-"
else
	call="Generate_workload_from_rackham.sh inputs/workloads/raw/${year0}-${month0}-${day0} start inputs/workloads/raw/${main_day} inputs/workloads/raw/${year}-"
fi

if [ ${month} = "04" ] || [ ${month} = "06" ] || [ ${month} = "09" ] || [ ${month} = "11" ]; then
	if [ ${day} = "30" ]; then
		day2="01"
		month2=$((month+1))
		if [ $((month2)) -lt 10 ]; then
			month2="0"$((month2))
		fi
	else
		if [ ${day} = "08" ]; then
			day2="09"
		elif [ ${day} = "09" ]; then
			day2="10"
		else
			day2=$((day+1))
			if [ $((day2)) -lt 10 ]; then
				day2="0"$((day2))
			fi
		fi
		month2=${month}
	fi
elif [ ${month} = "02" ]; then
	if [ ${day} = "28" ]; then
		day2="01"
		month2=$((month+1))
		if [ $((month2)) -lt 10 ]; then
			month2="0"$((month2))
		fi
	else
		day2=$((day+1))
		month2=${month}
		if [ $((day2)) -lt 10 ]; then
			day2="0"$((day2))
		fi
	fi
else
	if [ ${day} = "31" ]; then
		day2="01"
		month2=$((month+1))
		if [ $((month2)) -lt 10 ]; then
			month2="0"$((month2))
		fi
	else
		if [ ${day} = "08" ]; then
			day2="09"
		elif [ ${day} = "09" ]; then
			day2="10"
		else
			day2=$((day+1))
		fi
		month2=${month}
		if [ $((day2)) -lt 10 ]; then
			day2="0"$((day2))
		fi
	fi
fi

echo "Day2 is ${day2}"
echo "Month2 is ${month2}"

if [ model == "jour" ]; then
	call="${call}${month2}-${day2} collection"
else
	call="${call}${month2}-${day2}"
fi

lastday=${day2}
lastmonth=${month2}

if [ model == "jour" ]; then
	for ((i=0; i<$((14-3)); i++))
	do
		if [ ${lastmonth} = "04" ] || [ ${lastmonth} = "06" ] || [ ${lastmonth} = "09" ] || [ ${lastmonth} = "11" ]; then
			if [ ${lastday} = "30" ]; then
				nextday="01"
				nextmonth=$((lastmonth+1))
				if [ $((nextmonth)) -lt 10 ]; then
					nextmonth="0"$((nextmonth))
				fi
			else
				if [ ${lastday} = "08" ]; then
					nextday="09"
				elif [ ${lastday} = "09" ]; then
					nextday="10"
				else
					nextday=$((lastday+1))
					if [ $((nextday)) -lt 10 ]; then
						nextday="0"$((nextday))
					fi
				fi
				nextmonth=${lastmonth}
			fi
		elif [ ${lastmonth} = "02" ]; then
			if [ ${lastday} = "28" ]; then
				nextday="01"
				nextmonth=$((lastmonth+1))
				if [ $((nextmonth)) -lt 10 ]; then
					nextmonth="0"$((nextmonth))
				fi
			else
				if [ ${lastday} = "08" ]; then
					nextday="09"
				elif [ ${lastday} = "09" ]; then
					nextday="10"
				else
					nextday=$((lastday+1))
					if [ $((nextday)) -lt 10 ]; then
						nextday="0"$((nextday))
					fi
				fi
				nextmonth=${lastmonth}
			fi
		else
			if [ ${lastday} = "31" ]; then
				nextday="01"
				nextmonth=$((lastmonth+1))
				if [ $((nextmonth)) -lt 10 ]; then
					nextmonth="0"$((nextmonth))
				fi
			else
				if [ ${lastday} = "08" ]; then
					nextday="09"
				elif [ ${lastday} = "09" ]; then
					nextday="10"
				else
					nextday=$((lastday+1))
					if [ $((nextday)) -lt 10 ]; then
						nextday="0"$((nextday))
					fi
				fi
				nextmonth=${lastmonth}
			fi
		fi
		call="${call} inputs/workloads/raw/${year}-${nextmonth}-${nextday}"
		lastday=${nextday}
		lastmonth=${nextmonth}
	done
else
	for ((i=0; i<$((5)); i++))
	do
		if [ ${lastmonth} = "04" ] || [ ${lastmonth} = "06" ] || [ ${lastmonth} = "09" ] || [ ${lastmonth} = "11" ]; then
			if [ ${lastday} = "30" ]; then
				nextday="01"
				nextmonth=$((lastmonth+1))
				if [ $((nextmonth)) -lt 10 ]; then
					nextmonth="0"$((nextmonth))
				fi
			else
				if [ ${lastday} = "08" ]; then
					nextday="09"
				elif [ ${lastday} = "09" ]; then
					nextday="10"
				else
					nextday=$((lastday+1))
					if [ $((nextday)) -lt 10 ]; then
						nextday="0"$((nextday))
					fi
				fi
				nextmonth=${lastmonth}
			fi
		elif [ ${lastmonth} = "02" ]; then
			if [ ${lastday} = "28" ]; then
				nextday="01"
				nextmonth=$((lastmonth+1))
				if [ $((nextmonth)) -lt 10 ]; then
					nextmonth="0"$((nextmonth))
				fi
			else
				if [ ${lastday} = "08" ]; then
					nextday="09"
				elif [ ${lastday} = "09" ]; then
					nextday="10"
				else
					nextday=$((lastday+1))
					if [ $((nextday)) -lt 10 ]; then
						nextday="0"$((nextday))
					fi
				fi
				nextmonth=${lastmonth}
			fi
		else
			if [ ${lastday} = "31" ]; then
				nextday="01"
				nextmonth=$((lastmonth+1))
				if [ $((nextmonth)) -lt 10 ]; then
					nextmonth="0"$((nextmonth))
				fi
			else
				if [ ${lastday} = "08" ]; then
					nextday="09"
				elif [ ${lastday} = "09" ]; then
					nextday="10"
				else
					nextday=$((lastday+1))
					if [ $((nextday)) -lt 10 ]; then
						nextday="0"$((nextday))
					fi
				fi
				nextmonth=${lastmonth}
			fi
		fi
		call="${call} inputs/workloads/raw/${year}-${nextmonth}-${nextday}"
		lastday=${nextday}
		lastmonth=${nextmonth}
	done
	call="${call} end"
	lastdayforanonymize=${lastday}
	lastmonthforanonymize=${lastmonth}
	for ((i=0; i<$((1)); i++))
	do
		if [ ${lastmonth} = "04" ] || [ ${lastmonth} = "06" ] || [ ${lastmonth} = "09" ] || [ ${lastmonth} = "11" ]; then
			if [ ${lastday} = "30" ]; then
				nextday="01"
				nextmonth=$((lastmonth+1))
				if [ $((nextmonth)) -lt 10 ]; then
					nextmonth="0"$((nextmonth))
				fi
			else
				if [ ${lastday} = "08" ]; then
					nextday="09"
				elif [ ${lastday} = "09" ]; then
					nextday="10"
				else
					nextday=$((lastday+1))
					if [ $((nextday)) -lt 10 ]; then
						nextday="0"$((nextday))
					fi
				fi
				nextmonth=${lastmonth}
			fi
		elif [ ${lastmonth} = "02" ]; then
			if [ ${lastday} = "28" ]; then
				nextday="01"
				nextmonth=$((lastmonth+1))
				if [ $((nextmonth)) -lt 10 ]; then
					nextmonth="0"$((nextmonth))
				fi
			else
				if [ ${lastday} = "08" ]; then
					nextday="09"
				elif [ ${lastday} = "09" ]; then
					nextday="10"
				else
					nextday=$((lastday+1))
					if [ $((nextday)) -lt 10 ]; then
						nextday="0"$((nextday))
					fi
				fi
				nextmonth=${lastmonth}
			fi
		else
			if [ ${lastday} = "31" ]; then
				nextday="01"
				nextmonth=$((lastmonth+1))
				if [ $((nextmonth)) -lt 10 ]; then
					nextmonth="0"$((nextmonth))
				fi
			else
				if [ ${lastday} = "08" ]; then
					nextday="09"
				elif [ ${lastday} = "09" ]; then
					nextday="10"
				else
					nextday=$((lastday+1))
					if [ $((nextday)) -lt 10 ]; then
						nextday="0"$((nextday))
					fi
				fi
				nextmonth=${lastmonth}
			fi
		fi
		call="${call} inputs/workloads/raw/${year}-${nextmonth}-${nextday} collection"
		lastday=${nextday}
		lastmonth=${nextmonth}
	done
	for ((i=0; i<$((1)); i++))
	do
		if [ ${lastmonth} = "04" ] || [ ${lastmonth} = "06" ] || [ ${lastmonth} = "09" ] || [ ${lastmonth} = "11" ]; then
			if [ ${lastday} = "30" ]; then
				nextday="01"
				nextmonth=$((lastmonth+1))
				if [ $((nextmonth)) -lt 10 ]; then
					nextmonth="0"$((nextmonth))
				fi
			else
				if [ ${lastday} = "08" ]; then
					nextday="09"
				elif [ ${lastday} = "09" ]; then
					nextday="10"
				else
					nextday=$((lastday+1))
					if [ $((nextday)) -lt 10 ]; then
						nextday="0"$((nextday))
					fi
				fi
				nextmonth=${lastmonth}
			fi
		elif [ ${lastmonth} = "02" ]; then
			if [ ${lastday} = "28" ]; then
				nextday="01"
				nextmonth=$((lastmonth+1))
				if [ $((nextmonth)) -lt 10 ]; then
					nextmonth="0"$((nextmonth))
				fi
			else
				if [ ${lastday} = "08" ]; then
					nextday="09"
				elif [ ${lastday} = "09" ]; then
					nextday="10"
				else
					nextday=$((lastday+1))
					if [ $((nextday)) -lt 10 ]; then
						nextday="0"$((nextday))
					fi
				fi
				nextmonth=${lastmonth}
			fi
		else
			if [ ${lastday} = "31" ]; then
				nextday="01"
				nextmonth=$((lastmonth+1))
				if [ $((nextmonth)) -lt 10 ]; then
					nextmonth="0"$((nextmonth))
				fi
			else
				if [ ${lastday} = "08" ]; then
					nextday="09"
				elif [ ${lastday} = "09" ]; then
					nextday="10"
				else
					nextday=$((lastday+1))
					if [ $((nextday)) -lt 10 ]; then
						nextday="0"$((nextday))
					fi
				fi
				nextmonth=${lastmonth}
			fi
		fi
		call="${call} inputs/workloads/raw/${year}-${nextmonth}-${nextday}"
		lastday=${nextday}
		lastmonth=${nextmonth}
	done
fi

echo "Will call ${call}"

bash ${call}

#~ bash Stats_single_workload.sh inputs/workloads/converted/${main_day}-\>${main_day}_V10000 inputs/clusters/rackham_450_128_32_256_4_1024.txt Fcfs

# Anonymize
if [ model == "jour" ]; then
	python3 src/anonymize_converted_workload.py inputs/workloads/converted/${main_day}-\>${main_day}_V10000
	rm inputs/workloads/converted/${main_day}-\>${main_day}_V10000
else
	python3 src/anonymize_converted_workload.py inputs/workloads/converted/${main_day}-\>2022-${lastmonthforanonymize}-${lastdayforanonymize}_V10000
	rm inputs/workloads/converted/${main_day}-\>2022-${lastmonthforanonymize}-${lastdayforanonymize}_V10000
fi
