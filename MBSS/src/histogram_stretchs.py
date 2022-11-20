# Not used cause I do everything ion wompute percentage all workkoad . py
# python3 src/histogram_stretchs.py all_percentage_improvement_stretch_no_bf.txt SCORE no_bf
# python3 src/histogram_stretchs.py all_percentage_improvement_stretch_with_bf.txt SCORE with_bf

import pandas as pd
from matplotlib import pyplot as plt
import sys
import numpy as np

FILENAME=sys.argv[1]
SCHEDULER=sys.argv[2]
BF=sys.argv[3]
file1 = open(FILENAME)
x = []
for line in file1:
	x.append(float(line))
x = pd.Series(x)
print(x)
plt.hist(x)
plt.xlabel("Speedup")
plt.ylabel("#Occurences")
plt.savefig("plot/Distribution/Stretch_all_workloads_" + SCHEDULER + "_" + BF + ".pdf")
