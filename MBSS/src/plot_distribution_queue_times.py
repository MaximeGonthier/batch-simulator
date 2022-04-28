import pandas as pd
from matplotlib import pyplot as plt
import sys
import numpy as np

FILENAME=sys.argv[1]
SCHEDULER=sys.argv[2]
WORKLOAD_DATE=sys.argv[3]
# ~ if (TYPE == "cores"):
# ~ data3 = pd.read_csv(FILENAME)
# ~ plt.hist(data3, align="mid")
# ~ plt.xlabel("Queue time in seconds")
# ~ plt.ylabel("#Occurences")
# ~ plt.savefig("plot/Distribution/Queue_Times/" + SCHEDULER + "_" + WORKLOAD_DATE + ".pdf")
# ~ else: # Log scale
file1 = open(FILENAME)

x = []
for line in file1:
	x.append(int(line))
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
plt.subplot(212)
plt.hist(x, bins=logbins)
plt.xscale('log')
plt.xlabel("Queue time in seconds")
plt.ylabel("#Occurences")
plt.savefig("plot/Distribution/Queue_Times/" + SCHEDULER + "_" + WORKLOAD_DATE + ".pdf")
