# importing package
import matplotlib.pyplot as plt
import pandas as pd
import sys

df = pd.read_csv(sys.argv[1])
title = sys.argv[2]

# ~ df.set_index('Time').plot.bar(title ="Championship", rot=0)
# ~ df.set_index('Time')

plt = df.plot(title=title)

filename = "plot/" + title + ".pdf"

plt.figure.savefig(filename)
