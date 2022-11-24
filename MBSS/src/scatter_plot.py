import matplotlib.pyplot as plt
import pandas as pd
import sys

data = pd.read_csv(sys.argv[1])
df = pd.DataFrame(data)
if sys.argv[2] == "EFT" or sys.argv[2] == "EFT-CONSERVATIVE-BF":
	y_index = 0
	scheduler = "EFT"
elif sys.argv[2] == "SCORE" or sys.argv[2] == "SCORE-CONSERVATIVE-BF":
	y_index = 1
	scheduler = "SCORE"
elif sys.argv[2] == "OPPORTUNISTIC-SCORE-MIX" or sys.argv[2] == "OPPORTUNISTIC-SCORE-MIX-CONSERVATIVE-BF":
	y_index = 2
	scheduler = "OPPORTUNISTIC-SCORE MIX"
elif sys.argv[2] == "EFT-SCORE-MIX" or sys.argv[2] == "EFT-SCORE-MIX-CONSERVATIVE-BF":
	y_index = 3
	scheduler = "EFT-SCORE MIX"
else:
	print("Error name of scheduler when calling scatter_plot.py")
	exit

x = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
# ~ size = [100,500,100,500]
y = sorted(list(df.iloc[:, y_index]))
print(y)
plt.axhline(y = 1, color = 'black', linestyle = "dotted", linewidth = 4)
# ~ plt.scatter(x, y, s=size, c='coral', label='class 1')
# ~ plt.scatter(x, y, c='blue', label='S')
plt.scatter(x, y, s = 100, c = "blue")

# ~ plt.legend()
if sys.argv[1] == "outputs/scatter_mean_stretch_all_workloads.csv":
	filename = "plot/Scatter/scatter_mean_stretch_all_workloads_" + sys.argv[2] + ".pdf"
	plt.title(scheduler)
else:
	filename = "plot/Scatter/scatter_mean_stretch_all_workloads_bf_" + sys.argv[2] + ".pdf"
	plt.title(scheduler + " CONSERVATIVE BF")

plt.xlabel('Sample')
plt.ylabel('Stretch\'s speed-up')
plt.savefig(filename)
# ~ plt.show()
