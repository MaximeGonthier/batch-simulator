# Plot total of scores data of fcfs with a score
# python3 plot_stats_socres.py fichier_de_stats_de_fcfs_with_a_score

# Imports
import sys

# Node: 30 EAT: 1395019 C: 1920 CxX: 134400000 Score: 135795019
total_eat = 0
total_CxX = 0
total_score = 0

with open(sys.argv[1]) as f:
	line = f.readline()
	while line:
		r1, r2, r3, r4, r5, r6, r7, r8, r9, r10 = line.split() 
		total_eat += int(r4)
		total_CxX += int(r8)
		total_score += int(r10)
		line = f.readline()
f.close()

print("Total EAT:", total_eat)
print("Total CxX:", total_CxX)
print("Total Score:", total_score)
