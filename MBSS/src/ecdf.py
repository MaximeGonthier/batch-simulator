import numpy as np
import matplotlib.pyplot as plt
from statsmodels.distributions.empirical_distribution import ECDF
import sys
import pandas as pd

df = pd.read_csv(sys.argv[1])
print("Opening file", sys.argv[1])

eft = list(df.iloc[:, 0])
score = list(df.iloc[:, 1])
opportunistic = list(df.iloc[:, 2])
eft_score = list(df.iloc[:, 3])

x = np.linspace(min([eft, score]), min([eft, score]))

sample = eft
ecdf = ECDF(sample)
y = ecdf(x)
plt.step(x, y)

if sys.argv[1] == "outputs/scatter_mean_stretch_all_workloads.csv":
	filename = "plot/ECDF/ecdf_mean_stretch_all_workloads.pdf"
else:
	filename = "plot/ECDF/ecdf_mean_stretch_all_workloads_bf.pdf"

plt.xlabel('Stretch\'s speed-up')
plt.ylabel('Cumulative probability')

plt.savefig(filename)
