# importing package
import matplotlib.pyplot as plt
import pandas as pd
import sys

df = pd.read_csv(sys.argv[1])
title = sys.argv[2]

plt = df.plot(x='Number of jobs', title=title)

filename = "plot/" + title + ".pdf"

plt.figure.savefig(filename)
