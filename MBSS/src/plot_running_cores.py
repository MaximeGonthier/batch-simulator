# python3 src/plot_running_cores.py input_file title
# importing package
import matplotlib.pyplot as plt
import pandas as pd
import sys

df = pd.read_csv(sys.argv[1])
title = sys.argv[2]

plt = df.plot(title=title)
plt.axhline(y = 9720, color = 'black', linestyle = '-', label = "Total number of cores")

plt.axvline(x = 7729, color = 'r', linestyle = '-', label = "First job day 1")
plt.axvline(x = 966994, color = 'orange', linestyle = '-', label = "Last job day 1")

plt.axvline(x = 483742, color = 'g', linestyle = '-', label = "First job day 2")
plt.axvline(x = 1053602, color = 'palegreen', linestyle = '-', label = "Last job day 2")

plt.axvline(x = 0, color = 'b', linestyle = '-', label = "First job day 3")
plt.axvline(x = 1138639, color = 'lightblue', linestyle = '-', label = "Last job day 3")

plt.legend(loc = 'upper left')

filename = "plot/" + title + ".pdf"

plt.figure.savefig(filename)
