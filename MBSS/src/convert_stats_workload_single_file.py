import sys

JOUR = sys.argv[1]
f_output1 = open("inputs/workloads/converted/distribution/" + JOUR + "_walltime", "w")
f_output2 = open("inputs/workloads/converted/distribution/" + JOUR + "_delay", "w")
f_output3 = open("inputs/workloads/converted/distribution/" + JOUR + "_cores", "w")

for i in range (1, LAST_DAY + 1):
	if (i <= 9):
		FILENAME=ANNEE+"-"+MOIS+"-"+"0"+str(i)
	else:
		FILENAME=ANNEE+"-"+MOIS+"-"+str(i)
	print(FILENAME)
	f_input = open("inputs/workloads/converted/" + JOUR, "r")
	line = f_input.readline()
	# ~ print(len(line))
	while line:
		# ~ print(line)
		words = line.split()
		# ~ print(len(words))
		# ~ if (str(r3) == "jobstate=COMPLETED" and int(str(r11)[6:]) <= 20):
		if (len(words) == 15):
			# ~ print("write")
			r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15 = line.split()
			if (int(str(r11)[6:]) <= 20):
				if (len(str(r15)) == 16): # Mean that the walltime is superior to 24h
					walltime = int(str(r15)[6:7])*24*60*60 + int(str(r15)[8:10])*60*60 + int(str(r15)[11:13])*60 + int(str(r15)[14:16])
				else:
					walltime = int(str(r15)[6:8])*60*60 + int(str(r15)[9:11])*60 + int(str(r15)[12:14])
				f_output1.write("%d\n" % walltime)
				f_output2.write("%d\n" % int(int(str(r8)[4:]) - int(str(r7)[6:])))
				f_output3.write("%d\n" % int(str(r11)[6:]))
		line = f_input.readline()

f_output1.close
f_output2.close
f_output3.close
