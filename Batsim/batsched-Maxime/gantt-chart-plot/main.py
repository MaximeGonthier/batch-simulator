# Coded by Yishu Du
from evalys.jobset import JobSet
from evalys import visu
import matplotlib.pyplot as plt
import sys

inputfile = "./"
inputfile += sys.argv[1]
title = sys.argv[2]

js = JobSet.from_csv(inputfile)
# ~ visu.gantt.plot_gantt(js, title="Gantt chart")
visu.gantt.plot_gantt(js, title=title)
# ~ plt = visu.gantt.plot_gantt(js, title=title)
# js.plot(with_details=True)
# plt.xticks([5,10,15,20])
plt.show()
# x.savefig("gantt.pdf")
#Now, the figure is saved as gantt.pdf, if you want to show this figure,
#you should comment out the 219th line in gantt.py and do plt.show()
# ~ filename = "plot/Gantt_charts/" + title + ".pdf"

# ~ plt.savefig(filename)


# ~ # importing package
# ~ import matplotlib.pyplot as plt
# ~ import pandas as pd
# ~ import sys

# ~ df = pd.read_csv(sys.argv[1])
# ~ title = sys.argv[2]

# ~ plt = df.plot(x='Number of jobs', title=title)

# ~ filename = "plot/" + title + ".pdf"

# ~ plt.figure.savefig(filename)
