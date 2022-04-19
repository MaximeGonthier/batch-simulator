import sys

FILENAME = sys.argv[1]

f_input = open("inputs/workloads/raw/" + FILENAME, "r")
f_output1 = open("inputs/workloads/converted/distribution/" + FILENAME + "_walltime", "w")
f_output2 = open("inputs/workloads/converted/distribution/" + FILENAME + "_delay", "w")
f_output3 = open("inputs/workloads/converted/distribution/" + FILENAME + "_cores", "w")

line = f_input.readline()
while line:
	r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15 = line.split()
	if (str(r3) == "jobstate=COMPLETED" and int(str(r11)[6:]) <= 20):
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

# ~ data1 = pd.read_csv("inputs/workloads/converted/distribution/" + FILENAME + "_walltime")
# ~ data1.hist(align="mid")
# ~ plt.savefig("plot/Distribution/" + FILENAME + "_walltime.pdf")

# ~ data2 = pd.read_csv("inputs/workloads/converted/distribution/" + FILENAME + "_delay")
# ~ data2.hist(align="mid")
# ~ plt.savefig("plot/Distribution/" + FILENAME + "_delay.pdf")

# ~ data3 = pd.read_csv("inputs/workloads/converted/distribution/" + FILENAME + "_cores")
# ~ plt.hist(data3, align="mid", range=(1,20), bins=20)
# ~ plt.savefig("plot/Distribution/" + FILENAME + "_cores.pdf")

# ~ fig, axes = plt.subplots(1, 3)

# ~ data1.hist(data1, align="mid", ax=axes[0])
# ~ data2.hist(data2, align="mid", ax=axes[1])
# ~ data3.hist(data3, align="mid", ax=axes[2])


# ~ f_output.write("{ id: %d subtime: %d delay: %d walltime: %d cores: %d data: [" % (id_count, int(str(r9)[7:]) - min_subtime, int(str(r8)[4:]) - int(str(r7)[6:]), walltime, int(str(r11)[6:])))
