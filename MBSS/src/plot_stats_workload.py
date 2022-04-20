import pandas as pd
from matplotlib import pyplot as plt
import sys

FILENAME=sys.argv[1]
print(FILENAME)
data3 = pd.read_csv("inputs/workloads/converted/distribution/" + FILENAME)
plt.hist(data3, align="mid")
plt.savefig("plot/Distribution/" + FILENAME + ".pdf")
