# In our experiments we evaluate our schedulers week by week.
# Our workload is constituted of 51 weeks, ranging from January the 3rd 2022 to December the 25th 2022.
# This code randomly generate 10 numbers between 1 and 51 using the seed "0".
# We used these 10 randomly selected weeks to conduct our experiments.

import random

random.seed(0)

nums = list(range(1, 52)) # List of integers from 1 to 51

random.shuffle(nums)

print(nums[0:10]) # <- List of 10 unique random numbers

# The produce numbers are [28, 13, 43, 41, 42, 8, 6, 36, 2, 50]
# Which corresponds to the weeks (format is month-day):


# 2:	01-10 01-16 - 227636 jobs - save 70000 lancé le 13 à 10h57 - save_and_resume 150000 le 14 mars à 13h48 

# 6:	02-07 02-13 - 82740 jobs - lancé le 12 à 18h36 sans save (a pu en lancer que 8 pb de plafrim)

# 8:	02-21 02-27 - 86038 jobs - Lancé le 12 à 18h34 sans save - fini - (<24h) - résultats légèrement positifs

# 13:	03-28 04-03 - 150014 jobs - Lancé avec save 60000 (60h) - save_and_resume 120000 le 12 mars à 12h

# 28:	07-11 07-17	- 158582 jobs - save 50000 - resume - fini - (< 24h) - résultats positifs 

# 36:	09-05 09-11 - 101017 jobs - save 70000 (<15min) lancé le 13 à 10h56 - Le save des 2 LEA a crash mais pas les autres. Save pour LEA fais en local et autres saved state récupéré en local aussi - fini en local - (<25min total) - résultats mitigé pour LEM et mauvais pour LEA

# 41:	10-10 10-16 - 135431 jobs - save 70000 lancé le 12 à 18h30 - resume lancé le 13 à 10h51 - Réussi pour les deux FCFS. Crash pour les autres ?

# 42:	10-17 10-23 - 184502 jobs - save 70000 lancé le 12 à 18h30

# 43:	10-24 10-30 - 214089 jobs - save 100000 lancé le 12 à 12h35

# 50:	12-12 12-18 - 156916 jobs - save 70000 lancé le 13 à 10h56


# ~ Il faut ls -lta et voir les save time
# bash plot_all_boxplots.sh date1 date2

# The full list would be [28, 13, 43, 41, 42, 8, 6, 36, 2, 50, 40, 1, 5, 35, 21, 15, 51, 29, 34, 44, 39, 12, 30, 18, 16, 11, 22, 48, 24, 4, 45, 10, 47, 7, 37, 19, 9, 46, 14, 38, 23, 31, 20, 26, 32, 33, 17, 3, 27, 49, 25]
