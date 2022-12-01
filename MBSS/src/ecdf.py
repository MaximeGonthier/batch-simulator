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

# ~ print("EFT:", eft)
# ~ print("Score:", score)
# ~ print("OPPORTUNISTIC-Score:", opportunistic)
# ~ print("EFT-Score:", eft_score)

min_ecdf = min(eft + score + opportunistic + eft_score)
# ~ max_ecdf = max(eft + score + opportunistic + eft_score)
max_ecdf = 2.5
# ~ color=["#4c0000","#E50000","#00bfff","#ff9b15","#91a3b0"])
x = np.linspace(min_ecdf, max_ecdf)

print("min:", min_ecdf, "max:", max_ecdf)

plt.axvline(x = 1, linestyle = "dotted", color = "black")

ecdf = ECDF(eft)
y = ecdf(x)
plt.step(x, y, label = "EFT")

ecdf = ECDF(score)
y = ecdf(x)
# ~ plt.step(x, y, label = "SCORE")
plt.step(x, y, label = "LEA")

ecdf = ECDF(opportunistic)
y = ecdf(x)
# ~ plt.step(x, y, label = "OPPORTUNISTIC-SCORE MIX")
plt.step(x, y, label = "LEO")

ecdf = ECDF(eft_score)
y = ecdf(x)
# ~ plt.step(x, y, label = "EFT-SCORE MIX")
plt.step(x, y, label = "LEM")

if sys.argv[1] == "outputs/scatter_mean_stretch_all_workloads.csv":
	filename = "plot/ECDF/ecdf_mean_stretch_all_workloads.pdf"
else:
	filename = "plot/ECDF/ecdf_mean_stretch_all_workloads_bf.pdf"

plt.xlabel('Stretch\'s speed-up')
plt.ylabel('Cumulative probability')
plt.legend()

plt.savefig(filename)
