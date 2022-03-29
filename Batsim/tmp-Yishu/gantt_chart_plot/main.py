from evalys.jobset import JobSet
from evalys import visu
import matplotlib.pyplot as plt
js = JobSet.from_csv("./toy_example3.csv")
visu.gantt.plot_gantt(js,title="Fault-free execution")
# js.plot(with_details=True)
# plt.xticks([5,10,15,20])
plt.show()
# x.savefig("gantt.pdf")
#Now, the figure is saved as gantt.pdf, if you want to show this figure,
#you should comment out the 219th line in gantt.py and do plt.show()



