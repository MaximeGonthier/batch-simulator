import sys

Random = sys.argv[1]
RandomAvailable = sys.argv[2]

f_Maxqueuetime = open("outputs/Max_queue_time.csv", "w")
f_Maxqueuetime.write("Number of jobs, Random, Random-Available\n")
f_Meanqueuetime = open("outputs/Mean_queue_time.csv", "w")
f_Meanqueuetime.write("Number of jobs, Random, Random-Available\n")
f_Totalqueuetime = open("outputs/Total_queue_time.csv", "w")
f_Totalqueuetime.write("Number of jobs, Random, Random-Available\n")
f_Maxflow = open("outputs/Max_flow.csv", "w")
f_Maxflow.write("Number of jobs, Random, Random-Available\n")
f_Meanflow = open("outputs/Mean_flow.csv", "w")
f_Meanflow.write("Number of jobs, Random, Random-Available\n")
f_Totalflow = open("outputs/Total_flow.csv", "w")
f_Totalflow.write("Number of jobs, Random, Random-Available\n")
f_Totaltransfertime = open("outputs/Total_transfer_time.csv", "w")
f_Totaltransfertime.write("Number of jobs, Random, Random-Available\n")
f_Makespan = open("outputs/Makespan.csv", "w")
f_Makespan.write("Number of jobs, Random, Random-Available\n")
f_Coretimeused = open("outputs/Core_time_used.csv", "w")
f_Coretimeused.write("Number of jobs, Random, Random-Available\n")

f_RandomAvailable = open(RandomAvailable, "r")

with open(Random) as f_Random:
	lineRandom = f_Random.readline()
	lineRandomAvailable = f_RandomAvailable.readline()
	while lineRandom:
		Random1, Random2, Random3, Random4, Random5, Random6, Random7, Random8, Random9, Random10 = lineRandom.split()
		RandomAvailable1, RandomAvailable2, RandomAvailable3, RandomAvailable4, RandomAvailable5, RandomAvailable6, RandomAvailable7, RandomAvailable8, RandomAvailable9, RandomAvailable10 = lineRandomAvailable.split()
		
		f_Maxqueuetime.write("%s,%s,%s\n" % (int(Random1), int(Random2), int(RandomAvailable2)))
		f_Meanqueuetime.write("%s,%s,%s\n" % (int(Random1), float(Random3), float(RandomAvailable3)))
		f_Totalqueuetime.write("%s,%s,%s\n" % (int(Random1), int(Random4), int(RandomAvailable4)))
		f_Maxflow.write("%s,%s,%s\n" % (int(Random1), int(Random5), int(RandomAvailable5)))
		f_Meanflow.write("%s,%s,%s\n" % (int(Random1), float(Random6), float(RandomAvailable6)))
		f_Totalflow.write("%s,%s,%s\n" % (int(Random1), int(Random7), int(RandomAvailable7)))
		f_Totaltransfertime.write("%s,%s,%s\n" % (int(Random1), int(Random8), int(RandomAvailable8)))
		f_Makespan.write("%s,%s,%s\n" % (int(Random1), int(Random9), int(RandomAvailable9)))
		f_Coretimeused.write("%s,%s,%s\n" % (int(Random1), int(Random10), int(RandomAvailable10)))
		
		lineRandom = f_Random.readline()
		lineRandomAvailable = f_RandomAvailable.readline()

f_Maxqueuetime.close()
f_Meanqueuetime.close()
f_Totalqueuetime.close()
f_Maxflow.close()
f_Meanflow.close()
f_Totalflow.close()
f_Totaltransfertime.close()
f_Makespan.close()
f_Coretimeused.close()

f_Random.close()
f_RandomAvailable.close()

#~ echo "Number of jobs, Maximum queue time, Mean queue time, Total queue time, Maximum flow, Mean flow, Total flow, Total transfer time, Makespan, Core time used" > outputs/results.csv
