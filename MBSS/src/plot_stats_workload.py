import pandas as pd
from matplotlib import pyplot as plt
import sys
import numpy as np

FILENAME=sys.argv[1]
TYPE=sys.argv[2]
print(FILENAME)
print(TYPE)
if (TYPE == "cores"):
	data3 = pd.read_csv("inputs/workloads/converted/distribution/" + FILENAME + "_" + TYPE)
	plt.hist(data3, align="mid")
	# ~ plt.show()
	plt.savefig("plot/Distribution/" + FILENAME + "_" + TYPE +".pdf")
# ~ elif (TYPE == "walltime"):
else:
	file1 = open("inputs/workloads/converted/distribution/" + FILENAME + "_" + TYPE)

	x = []
	for line in file1:
		x.append(int(line))
	# ~ print(x)
	x = pd.Series(x)

	# histogram on linear scale
	plt.subplot(211)
	hist, bins, _ = plt.hist(x, bins=10)
	
	if (bins[0] == 0):
		first_arg = 0
	else:
		first_arg = np.log10(bins[0])
	
	# histogram on log scale. 
	# Use non-equal bin sizes, such that they look equal on log scale.
	logbins = np.logspace(first_arg,np.log10(bins[-1]),len(bins))
	# ~ print(first_arg)
	# ~ print(np.log10(bins[-1]))
	# ~ print(len(bins))
	plt.subplot(212)
	plt.hist(x, bins=logbins)
	plt.xscale('log')
	# ~ plt.show()
	plt.savefig("plot/Distribution/" + FILENAME + "_" + TYPE +".pdf")
# ~ elif (TYPE == "delay"):
	# ~ file1 = open("inputs/workloads/converted/distribution/" + FILENAME + "_" + TYPE)

	# ~ x = []
	# ~ for line in file1:
		# ~ x.append(int(line))
	# ~ print(x)
	# ~ x = pd.Series(x)

	# ~ # histogram on linear scale
	# ~ plt.subplot(211)
	# ~ hist, bins, _ = plt.hist(x, bins=10)

	# ~ # histogram on log scale. 
	# ~ # Use non-equal bin sizes, such that they look equal on log scale.
	# ~ logbins = np.logspace(np.log10(bins[0]),np.log10(bins[-1]),len(bins))
	# ~ print(bins[0])
	# ~ print(np.log10(bins[0]))
	# ~ print(np.log10(bins[-1]))
	# ~ print(len(bins))
	# ~ plt.subplot(212)
	# ~ plt.hist(x, bins=logbins)
	# ~ plt.xscale('log')
	# ~ plt.show()
# ~ else:
	# ~ print("Wrong argument")
	# ~ exit
